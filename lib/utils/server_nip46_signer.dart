import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/thread_pool_manager.dart';
import 'package:aegis/utils/logger.dart';

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

  // String subscriptionId = '';
  final Map<int, String> _subscriptionIds = {};
  String port = '8080';

  AegisWebSocketServer? server;
  final ThreadPoolManager _threadPool = ThreadPoolManager();

  Future<void> start(String getPort) async {
    port = getPort;
    
    try {
      await _threadPool.initialize();
      AegisLogger.info('The thread pool has been initialized successfully and can start processing requests');
    } catch (e) {
      AegisLogger.error('Thread pool initialization failed', e);
    }
    
    await _startWebSocketServer();
  }

  void generateKeyPair()  {
    // String getIpAddress = await ServerNIP46Signer.getIpAddress();
    AegisLogger.info("✅ NIP-46  ws://127.0.0.1:$port");
    String bunkerUrl =  getBunkerUrl();
    AegisLogger.info("🔗 Bunker URL: $bunkerUrl");
  }

  Future<void> _startWebSocketServer() async {
    AegisWebSocketServer.instance
        .start(onMessageReceived: _handleMessage, port: port,onDoneFromSocket:_onDoneFromSocket);
  }

  void _handleMessage(String message, WebSocket socket) async {
    final request = await _threadPool.runOtherTask(() async => jsonDecode(message));

    final messageType = request[0];
    AegisLogger.debug('===getClientRequest===>>>>>>🔔🔔🔔 $request');
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
    AccountManager instance = AccountManager.sharedInstance;
    final list = instance.applicationMap.values.toList();
    for(var client in list){
      if(client.value.socketHashCode == socket.hashCode){
        client.value.socketHashCode = null;
        instance.updateApplicationMap(client.value);
      }
    }
  }

  void _handleRequest(WebSocket socket, String subscriptionId) async {
    _subscriptionIds[socket.hashCode] = subscriptionId;

    final jsonResponseEOSE = jsonEncode(['EOSE', subscriptionId]);
    socket.send(jsonResponseEOSE);
  }

  void _handleEvent(WebSocket socket, Map<String, dynamic> eventData) async {
    AegisLogger.debug('eventData===$eventData');
    
    if (!_threadPool.isInitialized) {
      AegisLogger.warning('The thread pool is not initialized. Attempt to reinitialize...');
      try {
        await _threadPool.initialize();
        AegisLogger.info('The reinitialization of the thread pool was successful');
      } catch (e) {
        AegisLogger.error('Thread pool reinitialization failed', e);
        socket.send(jsonEncode(['CLOSED', '', 'The server thread pool is not initialized. Please try again later']));
        return;
      }
    }
    
    final event = await _threadPool.runOtherTask(() async => Event.fromJson(eventData));
    if (event == null) return;

    String? serverPrivate = LocalNostrSigner.instance.getPrivateKey(event.pubkey);
    if(serverPrivate == null) return;

    NostrRemoteRequest? remoteRequest = await NostrRemoteRequest.decrypt(
        event.content, event.pubkey, LocalNostrSigner.instance,serverPrivate);

    if (remoteRequest == null) {
      final jsonResponseClosed = jsonEncode(['CLOSED', event.id, 'The remote signing server has disconnected. You can no longer use the remote signing service until you re-establish the connection. Please reconnect and add the client again. ']);
      socket.send(jsonResponseClosed);
      return;
    }

    final jsonResponseOk = jsonEncode(['OK', event.id, true, '']);
    socket.send(jsonResponseOk);

    String? responseJson = await _processRemoteRequest(remoteRequest, event, socket);
    if (responseJson == null) return;
    String? responseJsonEncrypt = await LocalNostrSigner.instance.nip44Encrypt(serverPrivate, responseJson, event.pubkey);

    final signEvent = Event.from(
      subscriptionId: _subscriptionIds[socket.hashCode],
      kind: event.kind,
      tags: [["p", event.pubkey]],
      content: responseJsonEncrypt ?? '',
      pubkey: LocalNostrSigner.instance.getPublicKey(event.pubkey) ?? '',
      privkey: LocalNostrSigner.instance.getPrivateKey(event.pubkey) ?? '',
    );
    
    final encodeJson = signEvent.serialize();
    socket.send(encodeJson);
  }

  Future<String?> _processRemoteRequest(
      NostrRemoteRequest remoteRequest, Event event,WebSocket socket) async {
    Map responseJson = {};
    String? serverPrivate = LocalNostrSigner.instance.getPrivateKey(event.pubkey);
    switch (remoteRequest.method) {
      case "connect":
        responseJson = {"id": remoteRequest.id, "result": "ack", "error": ''};
        break;

      case "ping":
        responseJson = {"id": remoteRequest.id, "result": "pong", "error": ''};
        break;

      case "get_public_key":
        final instance = Account.sharedInstance;
        responseJson = {
          "id": remoteRequest.id,
          "result": LocalNostrSigner.instance.getPublicKey(event.pubkey),
          "error": "",
        };

        ClientAuthDBISAR? client = instance.authToNostrConnectInfo[event.pubkey];
        client ??= AccountManager.sharedInstance.applicationMap[event.pubkey]?.value;

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
          AccountManager.sharedInstance.addApplicationMap(newClient);
          try {
            await ClientAuthDBISAR.saveFromDB(newClient);
          } catch (e) {
            AegisLogger.error('Database saving failed', e);
          }
        } else {
          responseJson = {
            "id": remoteRequest.id,
            "result": null,
            "error": "unauthorized",
          };
        }
        break;

      case "sign_event":
        String? contentStr = remoteRequest.params[0];
        if (contentStr != null) {
          Event? signEvent;
          try {
            signEvent = await _threadPool.runOtherTask(() async {
              try {
                return Event.fromJson(jsonDecode(contentStr), verify: false);
              } catch (_) {
                return null;
              }
            });
          } catch (e) {
            AegisLogger.error('JSON decoding failed', e);
            signEvent = null;
          }
          
          if (signEvent == null) return null;
          final eventFromJ = Event.from(
            createdAt: signEvent.createdAt,
            subscriptionId: _subscriptionIds[socket.hashCode],
            kind: signEvent.kind,
            tags: signEvent.tags,
            content: signEvent.content,
            pubkey: LocalNostrSigner.instance.getPublicKey(event.pubkey) ?? '',
            privkey: LocalNostrSigner.instance.getPrivateKey(event.pubkey) ?? '',
          );
          
          String? result;
          try {
            result = await _threadPool.runOtherTask(() async => jsonEncode(eventFromJ.toJson()));
          } catch (e) {
            AegisLogger.error('JSON encoding failed', e);
            result = null;
          }
          
          responseJson = {
            "id": remoteRequest.id,
            "result": result,
            "error": result == null ? 'encoding_failed' : null
          };
        }
        break;

      case "nip04_encrypt":
        String? result = await LocalNostrSigner.instance
            .encrypt(remoteRequest.params[0], remoteRequest.params[1]);
        responseJson = {"id": remoteRequest.id, "result": result ?? '', "error": ''};
        break;

      case "nip04_decrypt":
        String? result = await LocalNostrSigner.instance
            .decrypt(remoteRequest.params[0], remoteRequest.params[1]);
        responseJson ={"id": remoteRequest.id, "result": result ?? '', "error": ''};
        break;

      case "nip44_decrypt":
        if(serverPrivate == null ||  remoteRequest.params[1] is! String || remoteRequest.params[0] is! String ) break;
        String? result = await LocalNostrSigner.instance
            .nip44Decrypt(serverPrivate, remoteRequest.params[1]!, remoteRequest.params[0]!);
        responseJson = {"id": remoteRequest.id, "result": result ?? '', "error": ''};
        break;

      case "nip44_encrypt":
        if(serverPrivate == null ||  remoteRequest.params[1] is! String || remoteRequest.params[0] is! String ) break;

        String? result = await LocalNostrSigner.instance
            .nip44Encrypt(serverPrivate, remoteRequest.params[1]!,remoteRequest.params[0]! );
        responseJson = {"id": remoteRequest.id, "result": result ?? '', "error": ''};
        break;

      default:
        responseJson = {
          "id": remoteRequest.id,
          "result": "no ${remoteRequest.method} method",
          "error": ''
        };
    }
    
    String? encodeResponseJson;
    try {
      encodeResponseJson = await _threadPool.runOtherTask(() async => jsonEncode(responseJson));
    } catch (e) {
      AegisLogger.error('JSON encoding failed', e);
      encodeResponseJson = null;
    }

    return encodeResponseJson;
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

  Future<void> _dealwithApplication(String clientPubkey, WebSocket socket) async {
    final account = Account.sharedInstance;
    final manager = AccountManager.sharedInstance;

    ClientAuthDBISAR? app = account.authToNostrConnectInfo[clientPubkey] ?? manager.applicationMap[clientPubkey]?.value;
    if (app == null) return;

    if (!manager.applicationMap.containsKey(clientPubkey)) {
      app.socketHashCode = socket.hashCode;
      manager.addApplicationMap(app);
      return;
    }

    final notifier = manager.applicationMap[clientPubkey]!;
    if (notifier.value.socketHashCode == null) {
      notifier.value.socketHashCode = socket.hashCode;
      manager.updateApplicationMap(notifier.value);
    }
  }

  void dispose() {
    _threadPool.dispose();
  }
}
