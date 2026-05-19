/// Thin ElectrumX client that performs a `name_show`-equivalent flow
/// over WebSocket. Uses `web_socket_channel` so the same code path
/// works on every platform aegis ships to, including the web build.
///
/// Failover semantics:
///   * Definitive answers (name not found, name expired) short-circuit
///     and propagate immediately.
///   * Transport errors (timeout, connection refused, TLS failure) are
///     swallowed and the next server is tried.
///   * If every server fails at the transport level, the result is
///     wrapped in [ElectrumxUnreachableException]. Callers that want
///     fail-open semantics should catch this and proceed.
library;

import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'electrumx_servers.dart';
import 'script.dart';

class NameNotFoundException implements Exception {
  final String name;
  const NameNotFoundException(this.name);
  @override
  String toString() => 'namecoin: name $name not found on Namecoin blockchain';
}

class NameExpiredException implements Exception {
  final String name;
  const NameExpiredException(this.name);
  @override
  String toString() => 'namecoin: name $name has expired';
}

class ElectrumxUnreachableException implements Exception {
  final Object? lastError;
  const ElectrumxUnreachableException([this.lastError]);
  @override
  String toString() =>
      'namecoin: all ElectrumX servers unreachable'
      '${lastError != null ? ' (last error: $lastError)' : ''}';
}

/// Public interface so callers can inject a fake transport in tests.
abstract class NameResolver {
  /// Returns the raw JSON value stored against [name] on the
  /// Namecoin blockchain.
  Future<String> nameShow(String name);

  Future<void> close();
}

class ElectrumxClient implements NameResolver {
  final List<ElectrumxServer> servers;
  final Duration connectTimeout;
  final Duration readTimeout;

  ElectrumxClient({
    this.servers = defaultElectrumxServers,
    this.connectTimeout = const Duration(seconds: 10),
    this.readTimeout = const Duration(seconds: 15),
  });

  @override
  Future<String> nameShow(String name) async {
    Object? lastError;
    var foundDefinitiveMiss = false;

    for (final server in servers) {
      try {
        final value = await _nameShowOn(name, server);
        if (value == null) {
          foundDefinitiveMiss = true;
          continue;
        }
        return value;
      } on NameNotFoundException {
        rethrow;
      } on NameExpiredException {
        rethrow;
      } on _NameMissError {
        foundDefinitiveMiss = true;
        continue;
      } on Object catch (e) {
        lastError = e;
        continue;
      }
    }

    if (foundDefinitiveMiss) throw NameNotFoundException(name);
    throw ElectrumxUnreachableException(lastError);
  }

  @override
  Future<void> close() async {}

  Future<String?> _nameShowOn(String name, ElectrumxServer server) async {
    final channel = WebSocketChannel.connect(Uri.parse(server.url));
    await channel.ready.timeout(connectTimeout);
    final rpc = _Rpc(channel);
    try {
      return await _runFlow(rpc, name).timeout(readTimeout);
    } finally {
      await rpc.close();
    }
  }

  Future<String?> _runFlow(_Rpc rpc, String name) async {
    // 1. Negotiate protocol version. Response is discarded — we only
    //    need to confirm the socket is alive.
    await rpc.call('server.version', ['aegis-namecoin-nip05', '1.4']);

    // 2. Compute the name-index scripthash and fetch history.
    final script = buildNameIndexScript(utf8.encode(name));
    final scriptHash = electrumScriptHash(script);
    final history = await rpc.call(
      'blockchain.scripthash.get_history',
      [scriptHash],
    );
    if (history is! List || history.isEmpty) {
      throw const _NameMissError();
    }
    final latest = history.last;
    if (latest is! Map) throw const _NameMissError();
    final txHash = latest['tx_hash'];
    final txHeight = latest['height'];
    if (txHash is! String) throw const _NameMissError();

    // 3. Fetch the verbose transaction.
    final tx = await rpc.call(
      'blockchain.transaction.get',
      [txHash, true],
    );
    if (tx is! Map) throw const _NameMissError();
    final vouts = tx['vout'];
    if (vouts is! List) throw const _NameMissError();

    // 4. Best-effort expiry check.
    var currentHeight = 0;
    try {
      final header = await rpc.call('blockchain.headers.subscribe', const []);
      if (header is Map) {
        final h = header['height'];
        if (h is int) currentHeight = h;
      }
    } on Object {
      // Non-fatal — skip the expiry check.
    }

    if (currentHeight > 0 &&
        txHeight is int &&
        txHeight > 0 &&
        currentHeight - txHeight >= namecoinNameExpireDepth) {
      throw NameExpiredException(name);
    }

    return _extractNameValue(vouts, name);
  }

  String? _extractNameValue(List<dynamic> vouts, String name) {
    for (final vout in vouts) {
      if (vout is! Map) continue;
      final scriptPubKey = vout['scriptPubKey'];
      if (scriptPubKey is! Map) continue;
      final hexScript = scriptPubKey['hex'];
      if (hexScript is! String || hexScript.length < 2) continue;
      // Cheap leading-opcode filter: only NAME_UPDATE (0x53) or
      // NAME_FIRSTUPDATE (0x52) carry name/value pushes.
      final lead = hexScript.substring(0, 2).toLowerCase();
      if (lead != '53' && lead != '52') continue;
      List<int> bytes;
      try {
        bytes = hex.decode(hexScript);
      } on FormatException {
        continue;
      }
      final parsed = parseNameScript(bytes);
      if (parsed == null) continue;
      if (parsed.name == name) return parsed.value;
    }
    return null;
  }
}

class _NameMissError implements Exception {
  const _NameMissError();
}

class _Rpc {
  final WebSocketChannel _channel;
  final Map<int, Completer<dynamic>> _pending = {};
  StreamSubscription<dynamic>? _sub;
  int _nextId = 0;
  bool _closed = false;

  _Rpc(this._channel) {
    _sub = _channel.stream.listen(
      _onMessage,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: false,
    );
  }

  Future<dynamic> call(String method, List<dynamic> params) {
    if (_closed) {
      return Future.error(StateError('rpc: connection closed'));
    }
    final id = ++_nextId;
    final completer = Completer<dynamic>();
    _pending[id] = completer;

    final msg = json.encode({
      'jsonrpc': '2.0',
      'id': id,
      'method': method,
      'params': params,
    });
    try {
      _channel.sink.add(msg);
    } on Object catch (e) {
      _pending.remove(id);
      completer.completeError(e);
    }
    return completer.future;
  }

  void _onMessage(Object? data) {
    String text;
    if (data is String) {
      text = data;
    } else if (data is List<int>) {
      try {
        text = utf8.decode(data, allowMalformed: false);
      } on FormatException {
        return;
      }
    } else {
      return;
    }

    Map<String, dynamic> parsed;
    try {
      final decoded = json.decode(text);
      if (decoded is! Map<String, dynamic>) return;
      parsed = decoded;
    } on FormatException {
      return;
    }

    final id = parsed['id'];
    if (id is! int) return;
    final completer = _pending.remove(id);
    if (completer == null) return;

    final error = parsed['error'];
    if (error != null) {
      completer.completeError(StateError('rpc error: $error'));
      return;
    }
    completer.complete(parsed['result']);
  }

  void _onError(Object error, StackTrace _) => _failAll(error);
  void _onDone() => _failAll(StateError('rpc: connection closed'));

  void _failAll(Object error) {
    final completers = List<Completer<dynamic>>.from(_pending.values);
    _pending.clear();
    for (final c in completers) {
      if (!c.isCompleted) c.completeError(error);
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _failAll(StateError('rpc: closed by caller'));
    try {
      await _sub?.cancel();
    } on Object {/* ignore */}
    try {
      await _channel.sink.close();
    } on Object {/* ignore */}
  }
}
