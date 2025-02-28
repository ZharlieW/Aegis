import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../nostr/event.dart';
import '../nostr/nips/nip46/nostr_remote_request.dart';
import '../nostr/signer/local_nostr_signer.dart';
import 'aegis_websocket_server.dart';

class BunkerSocket {
  final String name;
  final String nsecBunker;
  final String port;
  final int createTimestamp;

  BunkerSocket({
    required this.name,
    required this.nsecBunker,
    required this.port,
    required this.createTimestamp,
  });
}

class ServerNIP46Signer {
  static final ServerNIP46Signer instance = ServerNIP46Signer._internal();
  factory ServerNIP46Signer() => instance;
  ServerNIP46Signer._internal();

  late LocalNostrSigner localNostrSigner;
  String _remotePubkey = '';
  String subscriptionId = '';
  String _ipAddress = '';
  String port = '8081';

  List<String>? _remotePubkeyTags;

  Future<void> start(String getPort) async {
    port = getPort;
    generateKeyPair();
    await _startWebSocketServer();
  }

  void generateKeyPair() async {
    LocalNostrSigner.instance.init();
    String getIpAddress = await ServerNIP46Signer.getIpAddress();
    print("✅ NIP-46  ws://${getIpAddress}:$port");
    String bunkerUrl = await getBunkerUrl(port);
    print("🔗 Bunker URL: $bunkerUrl");
  }

  Future<void> _startWebSocketServer() async {
    AegisWebSocketServer server = AegisWebSocketServer(
      port: port,
      onMessageReceived: _handleMessage,
    );
    await server.start();
  }

  void _handleMessage(String message, WebSocket socket) async {
    final request = jsonDecode(message);
    final messageType = request[0];
    print('===getClientRequest===>>>>>>🔔🔔🔔 $request');

    if (messageType == 'REQ') {
      _handleRequest(socket, request[1]);
    } else if (messageType == 'EVENT') {
      _handleEvent(socket, request[1]);
    }
  }

  void _handleRequest(WebSocket socket, String subscriptionId) {
    this.subscriptionId = subscriptionId;
    final jsonResponseEOSE = jsonEncode(['EOSE', this.subscriptionId]);
    socket.add(jsonResponseEOSE);
  }

  void _handleEvent(WebSocket socket, Map<String, dynamic> eventData) async {
    final event = Event.fromJson(eventData);
    if (event == null) return;

    NostrRemoteRequest? remoteRequest = await NostrRemoteRequest.decrypt(
        event.content, event.pubkey, LocalNostrSigner.instance);

    if (remoteRequest == null) return;

    final jsonResponseOk = jsonEncode(['OK', event.id, true, '']);
    socket.add(jsonResponseOk);

    String responseJson = await _processRemoteRequest(remoteRequest, event);

    String? responseJsonEncrypt = await LocalNostrSigner.instance
        .nip44Encrypt(_remotePubkey, responseJson);

    final signEvent = Event.from(
      subscriptionId: subscriptionId,
      kind: event.kind,
      tags: [getRemoteSignerPubkeyTags()],
      content: responseJsonEncrypt ?? '',
      pubkey: LocalNostrSigner.instance.publicKey,
      privkey: LocalNostrSigner.instance.privateKey,
    );
    print('jsonResponse===${signEvent.serialize()}');
    socket.add(signEvent.serialize());
  }

  Future<String> _processRemoteRequest(
      NostrRemoteRequest remoteRequest, Event event) async {
    String responseJson = '';
    switch (remoteRequest.method) {
      case "connect":
        _remotePubkey = event.pubkey;
        responseJson =
            jsonEncode({"id": remoteRequest.id, "result": "ack", "error": ''});
        break;

      case "ping":
        responseJson =
            jsonEncode({"id": remoteRequest.id, "result": "pong", "error": ''});
        break;

      case "get_public_key":
        responseJson = jsonEncode({
          "id": remoteRequest.id,
          "result": LocalNostrSigner.instance.publicKey,
          "error": ''
        });
        break;

      case "sign_event":
        String? contentStr = remoteRequest.params[0];
        if (contentStr != null) {
          Event? signEvent =
              Event.fromJson(jsonDecode(contentStr), verify: false);
          if (signEvent == null) return '';
          final eventFromJ = Event.from(
            createdAt: signEvent.createdAt,
            subscriptionId: subscriptionId,
            kind: signEvent.kind,
            tags: signEvent.tags,
            content: signEvent.content,
            pubkey: LocalNostrSigner.instance.publicKey,
            privkey: LocalNostrSigner.instance.privateKey,
          );
          responseJson = jsonEncode({
            "id": remoteRequest.id,
            "result": jsonEncode(eventFromJ.toJson()),
            "error": null
          });
          print('======>>>.responseJson===>$responseJson');
        }
        break;

      case "nip04_encrypt":
        String? result = await LocalNostrSigner.instance
            .encrypt(remoteRequest.params[0], remoteRequest.params[1]);
        responseJson = jsonEncode(
            {"id": remoteRequest.id, "result": result ?? '', "error": ''});
        break;

      case "nip04_decrypt":
        String? result = await LocalNostrSigner.instance
            .decrypt(remoteRequest.params[0], remoteRequest.params[1]);
        responseJson = jsonEncode(
            {"id": remoteRequest.id, "result": result ?? '', "error": ''});
        break;

      case "nip44_decrypt":
        String? result = await LocalNostrSigner.instance
            .decrypt(remoteRequest.params[0], remoteRequest.params[1]);
        responseJson = jsonEncode(
            {"id": remoteRequest.id, "result": result ?? '', "error": ''});
        break;

      case "nip44_encrypt":
        String? result = await LocalNostrSigner.instance
            .nip44Encrypt(remoteRequest.params[0], remoteRequest.params[1]);
        responseJson = jsonEncode(
            {"id": remoteRequest.id, "result": result ?? '', "error": ''});
        break;

      default:
        responseJson = jsonEncode({
          "id": remoteRequest.id,
          "result": "no ${remoteRequest.method} method",
          "error": ''
        });
    }
    return responseJson;
  }

  Future<String> getBunkerUrl(String port) async {
    String ipAddress = await getIpAddress();
    return "bunker://${LocalNostrSigner.instance.publicKey}?relay=ws://$ipAddress:$port";
  }

  List<String> getRemoteSignerPubkeyTags() {
    _remotePubkeyTags ??= ["p", _remotePubkey];
    return _remotePubkeyTags!;
  }

  static Future<String> getIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            return addr.address;
          }
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}
