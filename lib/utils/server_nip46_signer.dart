import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/thread_pool_manager.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/signed_event_manager.dart';

import '../db/clientAuthDB_isar.dart';
import 'package:aegis/nostr/nostr.dart' show Event, Filter;
import '../nostr/nips/nip46/nostr_remote_request.dart';
import '../nostr/signer/local_nostr_signer.dart';
import 'relay_service.dart';
import 'connect.dart';
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

  String _subscriptionId = 'nip46-sub-${DateTime.now().millisecondsSinceEpoch}';
  String port = '8080';

  RelayService? relayService;
  Connect? _connect;
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
    // Start the Nostr relay using RelayService
    relayService = RelayService.instance;
    await relayService!.start(port: port);
    AegisLogger.info('✅ Relay service started on ${relayService!.relayUrl}');
    
    // Initialize and connect client to the relay
    await _initializeClient();
  }

  /// Initialize Nostr client and connect to relay
  Future<void> _initializeClient() async {
    try {
      // Get Connect instance
      _connect = Connect();
      
      // Add and connect to local relay
      final relayUrl = relayService!.relayUrl;
      await _connect!.connect(relayUrl, relayKind: RelayKind.remoteSigner);
      
      // Subscribe to NIP-46 events
      await _subscribeToNIP46Events();
      
    } catch (e) {
      AegisLogger.error('Failed to initialize client', e);
      rethrow;
    }
  }

  /// Subscribe to NIP-46 events
  Future<void> _subscribeToNIP46Events() async {
    try {
      // Get server public key to subscribe to events addressed to us
      final serverPubkey = LocalNostrSigner.instance.publicKey;
      
      // Create subscription filter for kind 24133 events with p tag = our pubkey
      final filter = Filter(
        kinds: [24133],
        p: [serverPubkey],
      );
      
      // Subscribe using Connect
      final relayUrl = relayService!.relayUrl;
      _subscriptionId = _connect!.addSubscription(
        [filter],
        relays: [relayUrl],
        relayKinds: [RelayKind.remoteSigner],
        eventCallBack: (Event event, String relay) {
          _handleEvent(event);
        },
        closeSubscription: false, // Keep subscription open
      );
    } catch (e) {
      AegisLogger.error('Failed to subscribe to events', e);
      rethrow;
    }
  }

  /// Handle event from relay (called via Connect callback)
  Future<void> _handleEvent(Event event) async {
    try {
      if (!_threadPool.isInitialized) {
        AegisLogger.warning('The thread pool is not initialized. Attempt to reinitialize...');
        try {
          await _threadPool.initialize();
          AegisLogger.info('The reinitialization of the thread pool was successful');
        } catch (e) {
          AegisLogger.error('Thread pool reinitialization failed', e);
          return;
        }
      }

      // Update application connection status
      await _dealwithApplication(event.pubkey);

      String? serverPrivate = LocalNostrSigner.instance.getPrivateKey(event.pubkey);
      if(serverPrivate == null) return;

      NostrRemoteRequest? remoteRequest = await NostrRemoteRequest.decrypt(
          event.content, event.pubkey, LocalNostrSigner.instance,serverPrivate);

      if (remoteRequest == null) {
        AegisLogger.warning('Failed to decrypt NIP-46 request from ${event.pubkey}');
        return;
      }

      // Process the remote request
      String? responseJson = await _processRemoteRequest(remoteRequest, event);
      if (responseJson == null) return;
      
      // Encrypt response
      String? responseJsonEncrypt = await LocalNostrSigner.instance.nip44Encrypt(serverPrivate, responseJson, event.pubkey);

      // Create response event using local Event utilities
      final serverPubkey = LocalNostrSigner.instance.getPublicKey(event.pubkey) ?? '';
      final serverPrivkey = LocalNostrSigner.instance.getPrivateKey(event.pubkey) ?? '';
      
      final signEvent = Event.from(
        kind: event.kind,
        tags: [["p", event.pubkey]],
        content: responseJsonEncrypt ?? '',
        pubkey: serverPubkey,
        privkey: serverPrivkey,
      );
      
      // Send response event to relay using Connect
      try {
        final relayUrl = relayService!.relayUrl;
        _connect!.sendEvent(
          signEvent,
          toRelays: [relayUrl],
          relayKinds: [RelayKind.remoteSigner],
        );
      } catch (e) {
        AegisLogger.error('❌ Failed to send response event', e);
      }
    } catch (e) {
      AegisLogger.error('Failed to handle event notification', e);
    }
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
      NostrRemoteRequest remoteRequest, Event event) async {

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
          
          // Parse the incoming event JSON and ensure it has all required fields
          Map<String, dynamic> eventData;
          try {
            eventData = jsonDecode(contentStr);
          } catch (e) {
            AegisLogger.error('Failed to parse event JSON: $contentStr', e);
            responseJson = {
              "id": remoteRequest.id,
              "result": null,
              "error": "Invalid JSON format",
            };
            break;
          }
          
          // Ensure pubkey field exists, use current pubkey if missing
          if (!eventData.containsKey('pubkey') || eventData['pubkey'] == null || eventData['pubkey'].toString().isEmpty) {
            eventData['pubkey'] = LocalNostrSigner.instance.getPublicKey(event.pubkey) ?? event.pubkey;
            AegisLogger.info('Added missing pubkey field: ${eventData['pubkey']}');
          }
          
          // Ensure created_at field exists
          if (!eventData.containsKey('created_at') || eventData['created_at'] == null) {
            eventData['created_at'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          }
          
          // Re-encode the event JSON with all required fields
          final completeEventJson = jsonEncode(eventData);
          
          final nativeRes = rust_api.signEvent(
            eventJson: completeEventJson,
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

  Future<void> _dealwithApplication(String clientPubkey) async {
    final account = Account.sharedInstance;
    final manager = AccountManager.sharedInstance;

    ClientAuthDBISAR? app = account.authToNostrConnectInfo[clientPubkey] ?? manager.applicationMap[clientPubkey]?.value;
    if (app == null) return;

    if (!manager.applicationMap.containsKey(clientPubkey)) {
      manager.addApplicationMap(app);
      return;
    }
  }

  Future<void> dispose() async {
    // Close subscription
    if (_subscriptionId.isNotEmpty && _connect != null) {
      try {
        final relayUrl = relayService?.relayUrl;
        if (relayUrl != null) {
          await _connect!.closeRequests(_subscriptionId, relay: relayUrl);
        }
      } catch (e) {
        AegisLogger.error('Failed to close subscription', e);
      }
    }
    
    // Close relay connection
    if (_connect != null && relayService != null) {
      try {
        await _connect!.closeConnects([relayService!.relayUrl], RelayKind.remoteSigner);
      } catch (e) {
        AegisLogger.error('Failed to close relay connection', e);
      }
    }
    
    // Stop relay
    if (relayService != null) {
      await relayService!.stop();
    }
    
    // Dispose thread pool
    _threadPool.dispose();
    
    AegisLogger.info('✅ ServerNIP46Signer disposed');
  }
}
