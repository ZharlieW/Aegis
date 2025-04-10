import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aegis/utils/account.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../db/clientAuthDB_isar.dart';
import '../db/db_isar.dart';
import '../nostr/event.dart';
import '../nostr/nips/nip46/nostr_remote_request.dart';
import '../nostr/signer/local_nostr_signer.dart';
import 'aegis_websocket_server.dart';
import 'nostr_wallet_connection_parser.dart';

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
  String port = '8080';

  List<String>? _remotePubkeyTags;

  AegisWebSocketServer? server;

  Future<void> start(String getPort) async {
    port = getPort;
    // generateKeyPair();
    await _startWebSocketServer();
  }

  void generateKeyPair() async {
    String getIpAddress = await ServerNIP46Signer.getIpAddress();
    print("✅ NIP-46  ws://${getIpAddress}:$port");
    String bunkerUrl = await getBunkerUrl();
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
      List<dynamic> kindList = request?[2]?['kinds'];
      if (!kindList.contains(24133)) return;

      String? getPubKey = request?[2]?['#p']?[0]?.toLowerCase();
      if (getPubKey != null) {
        Account.sharedInstance.clientReqMap[getPubKey] = request;
        Nip46NostrConnectInfo? connectInfo = Account.sharedInstance.nip46NostrConnectInfoMap.value[getPubKey];
        if (connectInfo != null) {
          NostrWalletConnectionParserHandler.sendAuthUrl(request[1], connectInfo);
        }
      }
      _handleRequest(socket, request[1]);
    } else if (messageType == 'EVENT') {
      String clientPubkey = request[1]['pubkey'];
      ValueListenable<Map<String, Nip46NostrConnectInfo>> valueMap = Account.sharedInstance.nip46NostrConnectInfoMap;
      if (valueMap.value[clientPubkey.toLowerCase()] == null) {
        ClientAuthDBISAR? clientInfo = await ServerNIP46Signer.instance.searchConnectInfo(
          Account.sharedInstance.currentPubkey,
          clientPubkey,
        );
        if (clientInfo != null) {
          Nip46NostrConnectInfo info = Nip46NostrConnectInfo(
            image: clientInfo.image ?? '',
            name: clientInfo.name ?? '',
            relay: clientInfo.relay ?? '',
            createTimestamp: clientInfo.createTimestamp ?? DateTime.now().millisecondsSinceEpoch,
            server: clientInfo.server ?? '',
            secret: clientInfo.secret ?? '',
            pubkey: clientInfo.pubkey,
            scheme: clientInfo.scheme ?? '',
          );

          Map<String, Nip46NostrConnectInfo> newValue = Map.from(valueMap.value);
          newValue[clientInfo.clientPubkey] = info;
          Account.sharedInstance.nip46NostrConnectInfoMap.value = newValue;
        }
      }
      // isClientAuthorized
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
        .nip44Encrypt(event.pubkey, responseJson);

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
    _remotePubkey = event.pubkey;
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
        String responseJsonResult = LocalNostrSigner.instance.publicKey;
        if(Account.sharedInstance.nip46NostrConnectInfoMap.value[_remotePubkey] == null){
          var result = await Account.clientAuth(
              pubkey: Account.sharedInstance.currentPubkey,
              clientPubkey: _remotePubkey,
              connectionType: EConnectionType.bunker,
          );
          if(!result){
            responseJsonResult = '';
          }
        }

        responseJson = jsonEncode({
          "id": remoteRequest.id,
          "result": responseJsonResult,
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

  Future<String> getBunkerUrl() async {
    String ipAddress = AegisWebSocketServer.instance.ip;
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

  Future<ClientAuthDBISAR?> searchConnectInfo(String pubkey, String clientPubkey) async {
    final result = await DBISAR.sharedInstance.isar.clientAuthDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .clientPubkeyEqualTo(clientPubkey)
        .findFirst();
    return result;
  }

  Future<void> saveClientAuth({
    required String pubkey,
    required String clientPubkey,
    required EConnectionType connectionType,
    String? image,
    String? name,
    String? relay,
  }) async {
    final existingAuth = await DBISAR.sharedInstance.isar.clientAuthDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .clientPubkeyEqualTo(clientPubkey)
        .findFirst();

    if (existingAuth == null) {
      final auth = ClientAuthDBISAR(
        pubkey: pubkey,
        clientPubkey: clientPubkey,
        isAuthorized: true,
        connectionType: connectionType.toInt,
        image: image,
        name: name,
        relay: relay,
      );
      Account.sharedInstance.addClientRequestList(auth);
      await DBISAR.sharedInstance.isar.writeTxn(() async {
        await DBISAR.sharedInstance.isar.clientAuthDBISARs.put(auth);
      });
    }
  }
}
