import 'dart:async';
import 'dart:convert';

import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/db/remembered_permission_choice_store.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/nostr/nostr.dart' show Event, Filter, OKEvent;
import 'package:aegis/nostr/nips/nip46/nostr_remote_request.dart';
import 'package:aegis/nostr/signer/local_nostr_signer.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/connect.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/method_usage_stats.dart';
import 'package:aegis/utils/nip46_error.dart';
import 'package:aegis/utils/nip46_crypto_request_validator.dart';
import 'package:aegis/utils/nip46_method_key.dart';
import 'package:aegis/utils/nostr_wallet_connection_parser.dart';
import 'package:aegis/utils/permission_approval_batcher.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;

/// One-time NIP-46 signer session on **remote** relay(s) (e.g. from scanned QR).
/// Connects to every relay in the URI, subscribes for kind 24133 with p = current user,
/// and broadcasts session_ready and NIP-46 responses to all relays so the client
/// (e.g. Flotilla) can receive regardless of which relay it listens on.
class RemoteRelayNip46Session {
  RemoteRelayNip46Session._();

  static final RemoteRelayNip46Session instance = RemoteRelayNip46Session._();

  static const int _ttlMinutes = 60;

  List<String>? _relayUrls;
  String? _clientPubkey;
  String? _secret;
  String? _subscriptionId;
  Timer? _ttlTimer;
  bool _closed = false;
  bool _sessionReadySent = false;
  bool _sessionReadyRetried = false;

  /// Whether a session is currently active (connected and listening).
  bool get isActive =>
      _relayUrls != null &&
      _relayUrls!.isNotEmpty &&
      _clientPubkey != null &&
      _subscriptionId != null &&
      !_closed;

  /// Last failure reason when [startFromNostrConnectUri] returns false (for UI message).
  static String? lastFailureReason;

  /// Start a one-time remote signer session from a nostrconnect URI.
  /// Parses relays and client pubkey, saves app to DB, connects to every relay,
  /// subscribes for kind 24133 (p = current user), and broadcasts session_ready to all.
  /// Returns true if session was started; false if already active or parse/login failed.
  /// On false, [lastFailureReason] may be set for display.
  static Future<bool> startFromNostrConnectUri(String nostrConnectUri) async {
    lastFailureReason = null;
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty || account.currentPrivkey.isEmpty) {
      AegisLogger.warning('RemoteRelayNip46Session: not logged in');
      lastFailureReason = 'not_logged_in';
      return false;
    }

    final parsed = NostrWalletConnectionParserHandler.parseUri(nostrConnectUri);
    if (parsed == null) {
      AegisLogger.warning('RemoteRelayNip46Session: failed to parse nostrconnect URI');
      lastFailureReason = 'parse_failed';
      return false;
    }

    final clientPubkey = parsed.clientPubkey;
    final relayUrls = parsed.allRelays ?? (parsed.relay != null ? [parsed.relay!] : <String>[]);
    final validRelays = relayUrls.where((r) => r.isNotEmpty && r.startsWith('ws')).toList();
    if (validRelays.isEmpty || clientPubkey.isEmpty) {
      AegisLogger.warning(
          'RemoteRelayNip46Session: invalid relay or clientPubkey from URI');
      lastFailureReason = 'invalid_relay_or_client';
      return false;
    }

    if (instance.isActive) {
      AegisLogger.info('RemoteRelayNip46Session: already active, closing previous');
      await instance.close();
    }

    return instance._start(relayUrls: validRelays, clientPubkey: clientPubkey, app: parsed);
  }

  Future<bool> _start({
    required List<String> relayUrls,
    required String clientPubkey,
    required ClientAuthDBISAR app,
  }) async {
    _relayUrls = List.from(relayUrls);
    _clientPubkey = clientPubkey;
    _secret = app.secret;
    _closed = false;

    AccountManager.sharedInstance.addApplicationMap(app);
    Account.sharedInstance.addAuthToNostrConnectInfo(app);
    try {
      await ClientAuthDBISAR.saveFromDB(app);
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: failed to save app', e);
      _relayUrls = null;
      _clientPubkey = null;
      lastFailureReason = 'save_or_connect_failed';
      return false;
    }

    final connect = Connect.sharedInstance;
    connect.addConnectStatusListener(_onConnectStatus);
    // Start connecting to all relays without awaiting so the caller (scan page) can return immediately
    // and give user feedback. When each relay connects, _onConnectStatus will _subscribe and _sendSessionReady.
    for (final r in _relayUrls!) {
      connect.connect(r, relayKind: RelayKind.remoteSigner);
    }

    // If any relay was already connected, we may not get status callback; subscribe now if at least one is up.
    final anyConnected = _relayUrls!.any((r) => connect.webSockets[r]?.connectStatus == 1);
    if (anyConnected) {
      _subscribe();
      _sendSessionReady();
    }

    _ttlTimer = Timer(Duration(minutes: _ttlMinutes), () {
      AegisLogger.info('RemoteRelayNip46Session: TTL expired');
      close();
    });

    AegisLogger.info(
        'RemoteRelayNip46Session: started for relays=${_relayUrls!.length} client=${clientPubkey.substring(0, 8)}...');
    return true;
  }

  void _onConnectStatus(String relay, int status, List<RelayKind> relayKinds) {
    if (_relayUrls == null || !_relayUrls!.contains(relay) ||
        status != 1 ||
        !relayKinds.contains(RelayKind.remoteSigner)) return;
    _subscribe();
    _sendSessionReady();
  }

  void _sendSessionReady() {
    if (_sessionReadySent) return;
    final relayUrls = _relayUrls;
    final clientPubkey = _clientPubkey;
    final secret = _secret;
    if (relayUrls == null || relayUrls.isEmpty ||
        clientPubkey == null ||
        secret == null ||
        secret.isEmpty ||
        _closed) return;
    _sessionReadySent = true;

    final userPubkey = Account.sharedInstance.currentPubkey;
    final serverPrivate = Account.sharedInstance.currentPrivkey;
    if (serverPrivate.isEmpty) return;

    final delayMs = _sessionReadyRetried ? 500 : 100;
    Future<void>.delayed(Duration(milliseconds: delayMs), () async {
      if (_closed || _relayUrls != relayUrls) return;
      try {
        final payload = jsonEncode({'id': secret, 'result': secret});
        final encrypted = await LocalNostrSigner.instance.nip44Encrypt(
          serverPrivate,
          payload,
          clientPubkey,
        );
        if (encrypted == null || _closed) return;
        // Use fresh timestamp so relays do not reject (NIP-22 / policy)
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final ev = Event.from(
          createdAt: now,
          kind: 24133,
          tags: [['p', clientPubkey]],
          content: encrypted,
          pubkey: userPubkey,
          privkey: serverPrivate,
        );
        Connect.sharedInstance.sendEvent(
          ev,
          toRelays: List.from(relayUrls),
          relayKinds: [RelayKind.remoteSigner],
          sendCallBack: (OKEvent ok, String _) {
            if (_closed) return;
            if (!ok.status && ok.message.contains('Time Out') && !_sessionReadyRetried) {
              _sessionReadyRetried = true;
              _sessionReadySent = false;
              AegisLogger.info(
                  'RemoteRelayNip46Session: session_ready rejected (Time Out), retrying once...');
              _sendSessionReady();
            }
          },
        );
        AegisLogger.info(
            'RemoteRelayNip46Session: sent session_ready (result=secret) to ${relayUrls.length} relay(s) for client=${clientPubkey.substring(0, 8)}...');
      } catch (e) {
        AegisLogger.error('RemoteRelayNip46Session: sendSessionReady failed', e);
      }
    });
  }

  void _subscribe() {
    final relayUrls = _relayUrls;
    final clientPubkey = _clientPubkey;
    if (relayUrls == null || relayUrls.isEmpty || clientPubkey == null || _closed) return;

    final userPubkey = Account.sharedInstance.currentPubkey;
    if (userPubkey.isEmpty) return;

    if (_subscriptionId != null && _subscriptionId!.isNotEmpty) {
      Connect.sharedInstance.closeRequests(_subscriptionId!);
    }

    final filter = Filter(kinds: [24133], p: [userPubkey]);
    _subscriptionId = Connect.sharedInstance.addSubscription(
      [filter],
      relays: List.from(relayUrls),
      relayKinds: [RelayKind.remoteSigner],
      eventCallBack: _onEvent,
      closeSubscription: false,
    );
    AegisLogger.info('RemoteRelayNip46Session: subscribed on ${relayUrls.length} relay(s)');
  }

  void _onEvent(Event event, String relay) {
    if (_closed || _relayUrls == null || !_relayUrls!.contains(relay)) return;
    if (event.pubkey != _clientPubkey) return;

    _handleEvent(event);
  }

  Future<void> _handleEvent(Event event) async {
    final relayUrls = _relayUrls;
    final clientPubkey = _clientPubkey;
    if (relayUrls == null || relayUrls.isEmpty || clientPubkey == null || _closed) return;

    final userPubkey = Account.sharedInstance.currentPubkey;
    final serverPrivate = Account.sharedInstance.currentPrivkey;
    if (serverPrivate.isEmpty) return;

    NostrRemoteRequest? req;
    try {
      req = await NostrRemoteRequest.decrypt(
        event.content,
        event.pubkey,
        LocalNostrSigner.instance,
        serverPrivate,
      );
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: decrypt failed', e);
      return;
    }
    if (req == null) return;

    Map<String, dynamic> responseJson;
    try {
      responseJson = await _processRequest(req, event, serverPrivate, userPubkey);
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: process failed', e);
      responseJson = {'id': req.id, 'result': '', 'error': e.toString()};
    }

    // Keep session open so client can send sign_event (e.g. posting); close only on TTL or manual close.

    String? encrypted;
    try {
      encrypted = await LocalNostrSigner.instance.nip44Encrypt(
        serverPrivate,
        jsonEncode(responseJson),
        event.pubkey,
      );
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: encrypt response failed', e);
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final responseEvent = Event.from(
      createdAt: now,
      kind: event.kind,
      tags: [['p', event.pubkey]],
      content: encrypted ?? '',
      pubkey: userPubkey,
      privkey: serverPrivate,
    );

    try {
      Connect.sharedInstance.sendEvent(
        responseEvent,
        toRelays: List.from(relayUrls),
        relayKinds: [RelayKind.remoteSigner],
      );
      // Keep session open for sign_event (e.g. posting); close only on TTL or manual close.
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: send response failed', e);
    }
  }

  Future<Map<String, dynamic>> _processRequest(
    NostrRemoteRequest req,
    Event event,
    String serverPrivate,
    String userPubkey,
  ) async {
    switch (req.method) {
      case 'connect':
        final methodKey = Nip46MethodKey.resolve(req.method, req.params);
        await _recordSignedEvent(
          eventId: req.id,
          eventKind: 24133,
          eventContent: 'Connection',
          pubkey: event.pubkey,
          methodKey: methodKey,
        );
        return {'id': req.id, 'result': 'ack', 'error': ''};

      case 'ping':
        final methodKey = Nip46MethodKey.resolve(req.method, req.params);
        await _recordSignedEvent(
          eventId: req.id,
          eventKind: 24133,
          eventContent: 'Ping',
          pubkey: event.pubkey,
          methodKey: methodKey,
        );
        return {'id': req.id, 'result': 'pong', 'error': ''};

      case 'get_public_key':
        final methodKey = Nip46MethodKey.resolve(req.method, req.params);
        await _addUsedMethodToApp(event.pubkey, methodKey);
        await _recordSignedEvent(
          eventId: req.id,
          eventKind: 24133,
          eventContent: 'get_public_key',
          pubkey: event.pubkey,
          methodKey: methodKey,
        );
        return {'id': req.id, 'result': userPubkey, 'error': ''};

      case 'sign_event': {
        final methodKey = Nip46MethodKey.resolve(req.method, req.params);
        final eventKind = Nip46MethodKey.extractSignEventKind(req.params);
        String? signDescription;
        try {
          final ctx = AegisNavigator.navigatorKey.currentContext;
          final l10n = ctx != null ? AppLocalizations.of(ctx) : null;
          if (eventKind != null) {
            signDescription = l10n?.permissionSignEventKind(eventKind.toString());
          } else {
            signDescription = l10n?.permissionSignEvents;
          }
        } catch (_) {}
        if (!await _requireApprovalForApp(
          event.pubkey,
          methodKey: methodKey,
          description: signDescription,
        )) {
          return {'id': req.id, 'result': '', 'error': 'unauthorized'};
        }
        final contentStr = req.params.isNotEmpty ? req.params[0] : null;
        if (contentStr == null || contentStr.isEmpty) {
          return {'id': req.id, 'result': '', 'error': Nip46Error.invalidParams(req.method)};
        }
        try {
          // Some clients (e.g. Jumble) send event JSON without pubkey; Rust signEvent expects it.
          final eventJsonWithPubkey = _ensureEventJsonHasPubkey(contentStr, userPubkey);
          final signed = await rust_api.signEvent(
            eventJson: eventJsonWithPubkey,
            privateKey: serverPrivate,
          );
          await _addUsedMethodToApp(event.pubkey, methodKey);
          await _recordSignedEvent(
            eventId: req.id,
            eventKind: eventKind ?? 24133,
            eventContent: eventKind != null ? 'Signed Event (Kind $eventKind)' : 'Signed event',
            pubkey: event.pubkey,
            methodKey: methodKey,
          );
          return {'id': req.id, 'result': signed, 'error': ''};
        } catch (e) {
          return {'id': req.id, 'result': '', 'error': e.toString()};
        }
      }

      case 'nip04_encrypt': {
        final methodKey = Nip46MethodKey.resolve(req.method, req.params);
        if (!await _requireApprovalForApp(
          event.pubkey,
          methodKey: methodKey,
          description: 'Encrypt data using NIP-04',
        )) {
          return {'id': req.id, 'result': '', 'error': 'unauthorized'};
        }
        if (!Nip46CryptoRequestValidator.hasValidNip04Params(req.params)) {
          return {'id': req.id, 'result': '', 'error': Nip46Error.invalidParams(req.method)};
        }
        final result = await LocalNostrSigner.instance.encrypt(
          req.params[0],
          req.params[1],
        );
        if (result != null) {
          await _addUsedMethodToApp(event.pubkey, methodKey);
          await _recordSignedEvent(
            eventId: req.id,
            eventKind: 4,
            eventContent: 'NIP-04 Encrypted Data',
            pubkey: event.pubkey,
            methodKey: methodKey,
          );
        }
        return {'id': req.id, 'result': result ?? '', 'error': ''};
      }

      case 'nip04_decrypt': {
        final methodKey = Nip46MethodKey.resolve(req.method, req.params);
        if (!await _requireApprovalForApp(
          event.pubkey,
          methodKey: methodKey,
          description: 'Decrypt data using NIP-04',
        )) {
          return {'id': req.id, 'result': '', 'error': 'unauthorized'};
        }
        if (!Nip46CryptoRequestValidator.hasValidNip04Params(req.params)) {
          return {'id': req.id, 'result': '', 'error': Nip46Error.invalidParams(req.method)};
        }
        final result = await LocalNostrSigner.instance.decrypt(
          req.params[0],
          req.params[1],
        );
        if (result != null) {
          await _addUsedMethodToApp(event.pubkey, methodKey);
          await _recordSignedEvent(
            eventId: req.id,
            eventKind: 4,
            eventContent: 'NIP-04 Decrypted Data',
            pubkey: event.pubkey,
            methodKey: methodKey,
          );
        }
        return {'id': req.id, 'result': result ?? '', 'error': ''};
      }

      case 'nip44_encrypt': {
        final methodKey = Nip46MethodKey.resolve(req.method, req.params);
        if (!await _requireApprovalForApp(
          event.pubkey,
          methodKey: methodKey,
          description: 'Encrypt data using NIP-44',
        )) {
          return {'id': req.id, 'result': '', 'error': 'unauthorized'};
        }
        if (!Nip46CryptoRequestValidator.hasValidNip44Params(
          serverPrivate: serverPrivate,
          params: req.params,
        )) {
          return {'id': req.id, 'result': '', 'error': Nip46Error.invalidParams(req.method)};
        }
        final result = await LocalNostrSigner.instance.nip44Encrypt(
          serverPrivate,
          req.params[1]!,
          req.params[0]!,
        );
        if (result != null) {
          await _addUsedMethodToApp(event.pubkey, methodKey);
          await _recordSignedEvent(
            eventId: req.id,
            eventKind: 4,
            eventContent: 'NIP-44 Encrypted Data',
            pubkey: event.pubkey,
            methodKey: methodKey,
          );
        }
        return {'id': req.id, 'result': result ?? '', 'error': ''};
      }

      case 'nip44_decrypt': {
        final methodKey = Nip46MethodKey.resolve(req.method, req.params);
        if (!await _requireApprovalForApp(
          event.pubkey,
          methodKey: methodKey,
          description: 'Decrypt data using NIP-44',
        )) {
          return {'id': req.id, 'result': '', 'error': 'unauthorized'};
        }
        if (!Nip46CryptoRequestValidator.hasValidNip44Params(
          serverPrivate: serverPrivate,
          params: req.params,
        )) {
          return {'id': req.id, 'result': '', 'error': Nip46Error.invalidParams(req.method)};
        }
        final result = await LocalNostrSigner.instance.nip44Decrypt(
          serverPrivate,
          req.params[1]!,
          req.params[0]!,
        );
        if (result != null) {
          await _addUsedMethodToApp(event.pubkey, methodKey);
          await _recordSignedEvent(
            eventId: req.id,
            eventKind: 4,
            eventContent: 'NIP-44 Decrypted Data',
            pubkey: event.pubkey,
            methodKey: methodKey,
          );
        }
        return {'id': req.id, 'result': result ?? '', 'error': ''};
      }

      default:
        return {'id': req.id, 'result': '', 'error': 'no ${req.method} method'};
    }
  }

  /// For manual authMode (1), shows a batch dialog; for full trust (2), returns true.
  /// Returns false if denied or app is missing.
  Future<bool> _requireApprovalForApp(
    String clientPubkey, {
    required String methodKey,
    String? description,
  }) async {
    final app = Account.sharedInstance.authToNostrConnectInfo[clientPubkey] ??
        AccountManager.sharedInstance.applicationMap[clientPubkey]?.value;
    if (app == null) return false;
    if (app.authMode == 2) return true; // full trust
    if (app.allowedMethods.contains(methodKey)) return true;
    final appKey =
        app.clientPubkey.isNotEmpty ? app.clientPubkey : clientPubkey;
    if (await RememberedPermissionChoiceStore.isValid(
          userPubkey: app.pubkey,
          clientPubkey: appKey,
          methodKey: methodKey,
        )) {
      return true;
    }

    return PermissionApprovalBatcher.instance.requestApproval(
      clientPubkey: clientPubkey,
      methodKey: methodKey,
      description: description ?? methodKey,
    );
  }

  /// Update method usage stats and sync allowed methods for permissions page.
  Future<void> _addUsedMethodToApp(String clientPubkey, String methodKey) async {
    if (methodKey.isEmpty) return;
    try {
      final app = Account.sharedInstance.authToNostrConnectInfo[clientPubkey] ??
          AccountManager.sharedInstance.applicationMap[clientPubkey]?.value;
      if (app == null) return;

      final updated = await ClientAuthDBISAR.searchFromDB(
        app.pubkey,
        app.clientPubkey.isNotEmpty ? app.clientPubkey : clientPubkey,
      );
      if (updated == null) return;

      updated.methodUsageStatsJson =
          MethodUsageStats.incrementJson(updated.methodUsageStatsJson, methodKey);

      if (Nip46MethodKey.supportedPermissionMethodKeys.contains(methodKey) &&
          !updated.allowedMethods.contains(methodKey)) {
        updated.allowedMethods = List<String>.from(updated.allowedMethods)..add(methodKey);
        updated.allowedMethods.sort(
          (a, b) => Nip46MethodKey.supportedPermissionMethodKeys
              .indexOf(a)
              .compareTo(Nip46MethodKey.supportedPermissionMethodKeys.indexOf(b)),
        );
      }

      await ClientAuthDBISAR.saveFromDB(updated, isUpdate: true);
      AccountManager.sharedInstance.updateApplicationMap(updated);
    } catch (e) {
      AegisLogger.warning('RemoteRelayNip46Session: add used method failed', e);
    }
  }

  /// If event JSON has no pubkey field, add current user pubkey so Rust signEvent can parse it.
  static String _ensureEventJsonHasPubkey(String eventJson, String userPubkeyHex) {
    try {
      final map = jsonDecode(eventJson);
      if (map is! Map<String, dynamic>) return eventJson;
      if (map.containsKey('pubkey') && map['pubkey'] != null) return eventJson;
      map['pubkey'] = userPubkeyHex;
      return jsonEncode(map);
    } catch (_) {
      return eventJson;
    }
  }


  Future<void> _recordSignedEvent({
    required String eventId,
    required int eventKind,
    required String eventContent,
    required String pubkey,
    String? methodKey,
  }) async {
    try {
      final app = AccountManager.sharedInstance.applicationMap[pubkey]?.value;
      await SignedEventManager.sharedInstance.recordSignedEvent(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: eventContent,
        applicationName: app?.name ?? pubkey,
        applicationPubkey: pubkey,
        status: 1,
        methodKey: methodKey,
      );
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: recordSignedEvent failed', e);
    }
  }

  /// Close the session: unsubscribe and close all relay connections for remoteSigner.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _ttlTimer?.cancel();
    _ttlTimer = null;

    final relayUrls = _relayUrls;
    final subId = _subscriptionId;
    _relayUrls = null;
    _clientPubkey = null;
    _secret = null;
    _subscriptionId = null;
    _sessionReadySent = false;
    _sessionReadyRetried = false;

    if (subId != null && subId.isNotEmpty) {
      try {
        Connect.sharedInstance.closeRequests(subId);
      } catch (e) {
        AegisLogger.error('RemoteRelayNip46Session: closeRequests failed', e);
      }
    }
    if (relayUrls != null && relayUrls.isNotEmpty) {
      try {
        await Connect.sharedInstance.closeConnects(
          List.from(relayUrls),
          RelayKind.remoteSigner,
        );
      } catch (e) {
        AegisLogger.error('RemoteRelayNip46Session: closeConnects failed', e);
      }
    }
    Connect.sharedInstance.removeConnectStatusListener(_onConnectStatus);
    AegisLogger.info('RemoteRelayNip46Session: closed');
  }
}
