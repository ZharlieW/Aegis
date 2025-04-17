import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aegis/utils/account.dart';

import '../db/clientAuthDB_isar.dart';
import '../nostr/event.dart';
import '../nostr/nips/nip46/nostr_remote_request.dart';
import '../nostr/signer/local_nostr_signer.dart';
import 'aegis_websocket_server.dart';
import 'nostr_wallet_connection_parser.dart';

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

  String subscriptionId = '';
  String port = '8080';

  AegisWebSocketServer? server;

  Future<void> start(String getPort) async {
    port = getPort;
    // generateKeyPair();
    await _startWebSocketServer();
  }

  void generateKeyPair()  {
    // String getIpAddress = await ServerNIP46Signer.getIpAddress();
    print("✅ NIP-46  ws://127.0.0.1:$port");
    String bunkerUrl =  getBunkerUrl();
    print("🔗 Bunker URL: $bunkerUrl");
  }

  Future<void> _startWebSocketServer() async {
    AegisWebSocketServer.instance
        .start(onMessageReceived: _handleMessage, port: port,onDoneFromSocket:_onDoneFromSocket);
  }

  void _handleMessage(String message, WebSocket socket) async {
    final request = jsonDecode(message);
    final messageType = request[0];
    print('===getClientRequest===>>>>>>🔔🔔🔔 $request');

    if (messageType == 'REQ') {
      List<dynamic> kindList = request?[2]?['kinds'];
      if (!kindList.contains(24133)) return;
      String? getPubKey = request?[2]?['#p']?[0]?.toLowerCase();
      if (getPubKey != null) {
        await _dealwithApplication(getPubKey,socket);
        Account.sharedInstance.clientReqMap[getPubKey] = request;

        ClientAuthDBISAR? connectInfo = Account.sharedInstance.authToNostrConnectInfo[getPubKey];
        if (connectInfo != null) {
          NostrWalletConnectionParserHandler.sendAuthUrl(request[1], connectInfo);
        }
      }
      _handleRequest(socket, request[1]);
    } else if (messageType == 'EVENT') {
      String clientPubkey = request[1]['pubkey'];
      await _dealwithApplication(clientPubkey,socket);
      _handleEvent(socket, request[1]);
    }
  }

  void _onDoneFromSocket(WebSocket socket) async {
    final list = Account.sharedInstance.applicationValueNotifier.value.values.toList();
    for(var client in list){
      if(client.socketHashCode == socket.hashCode){
        client.socketHashCode = null;
        Account.sharedInstance.addApplicationValueNotifier(client,isUpdate: true);
      }
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
        .nip44Encrypt(event.pubkey, responseJson);

    final signEvent = Event.from(
      subscriptionId: subscriptionId,
      kind: event.kind,
      tags: [["p", event.pubkey]],
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
    switch (remoteRequest.method) {
      case "connect":
        responseJson =
            jsonEncode({"id": remoteRequest.id, "result": "ack", "error": ''});
        break;

      case "ping":
        responseJson =
            jsonEncode({"id": remoteRequest.id, "result": "pong", "error": ''});
        break;

      case "get_public_key":
        final instance = Account.sharedInstance;
        responseJson = jsonEncode({
          "id": remoteRequest.id,
          "result": LocalNostrSigner.instance.publicKey,
          "error": "",
        });

        ClientAuthDBISAR? client = instance.authToNostrConnectInfo[event.pubkey];
        client ??= await ClientAuthDBISAR.searchFromDB(instance.currentPubkey, event.pubkey);

        if (client != null)  break;

        final isSuccess = await Account.authToClient();
        if (isSuccess) {
          ClientAuthDBISAR newClient = ClientAuthDBISAR(
            createTimestamp: DateTime.now().millisecondsSinceEpoch,
            pubkey: instance.currentPubkey,
            clientPubkey: event.pubkey,
            name: event.pubkey,
            connectionType: EConnectionType.bunker.toInt,
          );
          await ClientAuthDBISAR.saveFromDB(newClient);
        } else {
          responseJson = jsonEncode({
            "id": remoteRequest.id,
            "result": null,
            "error": "unauthorized",
          });
        }
        break;

      case "sign_event":
        String? contentStr = remoteRequest.params[0];
        if (contentStr != null) {
          Event? signEvent =
              Event.fromJson(jsonDecode(contentStr), verify: false);
          if (signEvent == null) return null;
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

  String getBunkerUrl()  {
    // String ipAddress = AegisWebSocketServer.instance.ip;
    return "bunker://${LocalNostrSigner.instance.publicKey}?relay=ws://127.0.0.1:$port";
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

  Future<void> _dealwithApplication(String clientPubkey,WebSocket socket) async {
    final instance = Account.sharedInstance;
    ClientAuthDBISAR? client = instance.authToNostrConnectInfo[clientPubkey];
    client ??= await ClientAuthDBISAR.searchFromDB(instance.currentPubkey, clientPubkey);
    if (client != null) {
      bool isUpdate = false;
      if(client.socketHashCode == null){
        client.socketHashCode = socket.hashCode;
        isUpdate = true;
      }
      Account.sharedInstance.addApplicationValueNotifier(client,isUpdate:isUpdate);
    }
  }
}
