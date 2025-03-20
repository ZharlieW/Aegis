import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aegis/utils/account.dart';
import 'package:isar/isar.dart';

import '../db/clientAuthDB_isar.dart';
import '../db/db_isar.dart';
import '../navigator/navigator.dart';
import '../nostr/event.dart';
import '../nostr/nips/nip46/nostr_remote_request.dart';
import '../nostr/signer/local_nostr_signer.dart';
import '../pages/request/request_permission.dart';
import 'aegis_websocket_server.dart';

class BunkerSocket {
  String name;
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

class ClientRequest {
  final String method;
  final List<String?> params;
  final Event event;

  ClientRequest({
    required this.method,
    required this.params,
    required this.event,
  });
}

class ServerNIP46Signer {
  static final ServerNIP46Signer instance = ServerNIP46Signer._internal();
  factory ServerNIP46Signer() => instance;
  ServerNIP46Signer._internal();

  String _remotePubkey = '';
  String subscriptionId = '';
  String port = '8081';

  List<String>? _remotePubkeyTags;

  AegisWebSocketServer? server;

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
    AegisWebSocketServer.instance
        .start(onMessageReceived: _handleMessage, port: port);
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

    String? responseJson = await _processRemoteRequest(remoteRequest, event);
    if (responseJson == null) return;
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

  Future<String?> _processRemoteRequest(
      NostrRemoteRequest remoteRequest, Event event) async {
    String responseJson = '';

    print('==event.pubkey===${event.pubkey}');
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
       bool isAuthorized = await isClientAuthorized(Account.sharedInstance.currentPubkey,_remotePubkey);
       print('===isAuthorized===$isAuthorized');
       if(!isAuthorized){
         final status = await AegisNavigator.presentPage(
             AegisNavigator.navigatorKey.currentContext,
                 (context) => RequestPermission(),
             fullscreenDialog: false);
         if (status == null || status == false) return null;
         saveClientAuth(Account.sharedInstance.currentPubkey,_remotePubkey);
       }

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
            .nip44Decrypt(remoteRequest.params[0], remoteRequest.params[1]);
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

  Future<bool> isClientAuthorized(String pubkey, String clientPubkey) async {
    final auth = await DBISAR.sharedInstance.isar.clientAuthDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .clientPubkeyEqualTo(clientPubkey)
        .findFirst();
    return auth != null && auth.isAuthorized;
  }

  Future<void> saveClientAuth(String pubkey, String clientPubkey) async {
    final existingAuth = await DBISAR.sharedInstance.isar.clientAuthDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .clientPubkeyEqualTo(clientPubkey)
        .findFirst();

    if (existingAuth == null) {
      final auth = ClientAuthDBISAR(pubkey: pubkey,clientPubkey:clientPubkey,isAuthorized:true);
      Account.sharedInstance.addClientRequestList(auth);
      await DBISAR.sharedInstance.isar.writeTxn(() async {
        await DBISAR.sharedInstance.isar.clientAuthDBISARs.put(auth);
      });
    }
  }
}
