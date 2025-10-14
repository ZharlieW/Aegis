import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/thread_pool_manager.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/signed_event_manager.dart';

import '../db/clientAuthDB_isar.dart';
import '../nostr/event.dart';
import '../nostr/nips/nip46/nostr_remote_request.dart';
import '../nostr/signer/local_nostr_signer.dart';
import 'aegis_websocket_server.dart';
import 'nostr_wallet_connection_parser.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;

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
    AegisLogger.info("✅ NIP-46  ws://0.0.0.0:$port");
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

  String _formatApplicationName(String? appName, String pubkey) {
    String name = appName ?? pubkey;
    if (name.length == 64 && RegExp(r'^[0-9a-fA-F]+$').hasMatch(name)) {
      return '${name.substring(0, 6)}:${name.substring(name.length - 6)}';
    }
    return name;
  }

  /// Record signed event with application info
  Future<void> _recordSignedEvent({
    required String eventId,
    required int eventKind,
    required String eventContent,
    required String pubkey,
    String? customAppName,
    String? metadata,
  }) async {
    try {
      final account = Account.sharedInstance;
      final manager = AccountManager.sharedInstance;
      final app = account.authToNostrConnectInfo[pubkey] ?? 
                 manager.applicationMap[pubkey]?.value;
      
      await SignedEventManager.sharedInstance.recordSignedEvent(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: eventContent,
        applicationName: _formatApplicationName(customAppName ?? app?.name, pubkey),
        applicationPubkey: pubkey,
        status: 1,
        metadata:metadata,
      );
    } catch (e) {
      AegisLogger.error('Failed to record signed event: $eventContent', e);
    }
  }

  Future<String?> _processRemoteRequest(
      NostrRemoteRequest remoteRequest, Event event,WebSocket socket) async {

    Map responseJson = {};
    String? serverPrivate = LocalNostrSigner.instance.getPrivateKey(event.pubkey);
    switch (remoteRequest.method) {
      case "connect":
        responseJson = {"id": remoteRequest.id, "result": "ack", "error": ''};
        
        // Record connection event
        await _recordSignedEvent(
          eventId: remoteRequest.id,
          eventKind: 24133,
          eventContent: 'Connection',
          pubkey: event.pubkey,
        );
        break;

      case "ping":
        responseJson = {"id": remoteRequest.id, "result": "pong", "error": ''};
        
        // Record ping event
        await _recordSignedEvent(
          eventId: remoteRequest.id,
          eventKind: 24133,
          eventContent: 'Ping',
          pubkey: event.pubkey,
        );
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
          // Get all bunker applications to calculate index
          final bunkerApplications = AccountManager.sharedInstance.applicationMap.values
              .where((app) => app.value.connectionType == EConnectionType.bunker.toInt)
              .toList();
          final index = bunkerApplications.length + 1;
          
          ClientAuthDBISAR newClient = ClientAuthDBISAR(
            createTimestamp: DateTime.now().millisecondsSinceEpoch,
            pubkey: instance.currentPubkey,
            clientPubkey: event.pubkey,
            name: 'application #$index',
            connectionType: EConnectionType.bunker.toInt,
          );
          AccountManager.sharedInstance.addApplicationMap(newClient);
          try {
            await ClientAuthDBISAR.saveFromDB(newClient);
            
            // Record connection event
            await _recordSignedEvent(
              eventId: remoteRequest.id,
              eventKind: 24133,
              eventContent: 'get_public_key',
              pubkey: event.pubkey,
              customAppName: event.pubkey,
            );
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
        if (contentStr != null && serverPrivate != null) {
          final privateKey = LocalNostrSigner.instance.getPrivateKey(event.pubkey);
          final nativeRes = rust_api.signEvent(
            eventJson: contentStr,
            privateKey: privateKey!,
          );
          // Record the signed event
            try {
              // Parse the signed event to get event details
              final signedEvent = jsonDecode(nativeRes);
              final eventId = signedEvent['id'] as String? ?? '';
              final eventKind = signedEvent['kind'] as int? ?? -1;
              final eventContent = signedEvent['content'] as String? ?? '';
              
              // Get application info
              await _recordSignedEvent(
                eventId: eventId,
                eventKind: eventKind,
                eventContent: eventContent.isNotEmpty && eventContent.length < 20 ? eventContent : 'Signed Event (Kind $eventKind)',
                pubkey: event.pubkey,
                metadata: contentStr,

              );
            } catch (e) {
              AegisLogger.error('Failed to record signed event', e);
            }

          responseJson = {
            "id": remoteRequest.id,
            "result": nativeRes,
            "error": null,
          };
        }
        break;

      case "nip04_encrypt":
        String? result = await LocalNostrSigner.instance
            .encrypt(remoteRequest.params[0], remoteRequest.params[1]);
        
        // Record NIP-04 encryption event
        if (result != null) {
          await _recordSignedEvent(
            eventId: remoteRequest.id,
            eventKind: 4,
            eventContent: 'NIP-04 Encrypted Data',
            pubkey: event.pubkey,
          );
        }
        
        responseJson = {"id": remoteRequest.id, "result": result ?? '', "error": ''};
        break;

      case "nip04_decrypt":
        String? result = await LocalNostrSigner.instance
            .decrypt(remoteRequest.params[0], remoteRequest.params[1]);
        
        // Record NIP-04 decryption event
        if (result != null) {
          await _recordSignedEvent(
            eventId: remoteRequest.id,
            eventKind: 4,
            eventContent: 'NIP-04 Decrypted Data',
            pubkey: event.pubkey,
          );
        }
        
        responseJson ={"id": remoteRequest.id, "result": result ?? '', "error": ''};
        break;

      case "nip44_decrypt":
        if(serverPrivate == null ||  remoteRequest.params[1] is! String || remoteRequest.params[0] is! String ) break;
        String? result = await LocalNostrSigner.instance
            .nip44Decrypt(serverPrivate, remoteRequest.params[1]!, remoteRequest.params[0]!);
        
        // Record NIP-44 decryption event
        if (result != null) {
          await _recordSignedEvent(
            eventId: remoteRequest.id,
            eventKind: 4,
            eventContent: 'NIP-44 Decrypted Data',
            pubkey: event.pubkey,
          );
        }
        
        responseJson = {"id": remoteRequest.id, "result": result ?? '', "error": ''};
        break;

      case "nip44_encrypt":
        if(serverPrivate == null ||  remoteRequest.params[1] is! String || remoteRequest.params[0] is! String ) break;

        String? result = await LocalNostrSigner.instance
            .nip44Encrypt(serverPrivate, remoteRequest.params[1]!,remoteRequest.params[0]! );
        
        // Record NIP-44 encryption event
        if (result != null) {
          await _recordSignedEvent(
            eventId: remoteRequest.id,
            eventKind: 4,
            eventContent: 'NIP-44 Encrypted Data',
            pubkey: event.pubkey,
          );
        }
        
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
    return "bunker://${LocalNostrSigner.instance.publicKey}?relay=ws://0.0.0.0:$port";
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
