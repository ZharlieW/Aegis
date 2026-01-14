import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/thread_pool_manager.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../db/clientAuthDB_isar.dart';
import 'package:aegis/nostr/nostr.dart' show Event, Filter;
import '../nostr/nips/nip46/nostr_remote_request.dart';
import '../nostr/signer/local_nostr_signer.dart';
import 'relay_service.dart';
import 'connect.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;
import 'package:nostr_rust/src/rust/api/relay.dart' as rust_relay;
import 'local_tls_proxy_manager_rust.dart';
import 'platform_utils.dart';
import 'android_service_manager.dart';
import '../pages/application/bunker_application_name_page.dart';

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
  bool _accountsInitialized = false;

  Future<void> start(String getPort) async {
    port = getPort;

    try {
      await _threadPool.initialize();
      AegisLogger.info(
          'The thread pool has been initialized successfully and can start processing requests');
    } catch (e) {
      AegisLogger.error('Thread pool initialization failed', e);
    }

    await _startWebSocketServer();
  }

  void generateKeyPair() {
    // String getIpAddress = await ServerNIP46Signer.getIpAddress();
    final relayUrl = getRelayUrlForDisplay(secure: true);
    AegisLogger.info("✅ NIP-46  $relayUrl");
    String bunkerUrl = getBunkerUrl();
    AegisLogger.info("🔗 Bunker URL: $bunkerUrl");
  }

  Future<void> _startWebSocketServer() async {
    // On Android, ensure Service is running (Service will start relay)
    if (PlatformUtils.isAndroid) {
      // Check if relay is running
      if (!await rust_relay.isRelayRunning()) {
        // Relay not running, ensure Service is started
        AegisLogger.info('⚠️ Relay not running on Android, ensuring Service is started...');
        try {
          // Start Service (Service will start relay)
          await AndroidServiceManager.startService(port: port);
          // Wait a bit for Service to start relay
          await Future.delayed(const Duration(milliseconds: 1000));
          
          // Check again
          if (!await rust_relay.isRelayRunning()) {
            throw Exception('Failed to start relay in Service');
          }
          AegisLogger.info('✅ Relay started by Service');
        } catch (e) {
          AegisLogger.error('❌ Failed to start Service or relay', e);
          rethrow;
        }
      } else {
        AegisLogger.info('✅ Relay already running (by Service)');
      }
      
      // Get relay service instance (it will get URL from rust_relay)
      relayService = RelayService.instance;
      // RelayService will automatically get the URL from rust_relay when accessed
      AegisLogger.info('✅ Relay service ready on ${relayService!.relayUrl}');
      
      // Continue with TLS proxy and client initialization
      final fallbackPort = PlatformUtils.isDesktop ? 18081 : 8081;
      final wsPort =
          int.tryParse(relayService!.port) ?? int.tryParse(port) ?? fallbackPort;
      AegisLogger.info(
          '🔧 Attempting to start TLS proxy: platform=${PlatformUtils.platformName}, wsPort=$wsPort');
      try {
        await LocalTlsProxyManagerRust.instance.ensureStarted(wsPort: wsPort);
        AegisLogger.info('✅ TLS proxy start completed');
      } catch (e, stackTrace) {
        AegisLogger.error('❌ Failed to start local TLS proxy', e);
        AegisLogger.error('Stack trace', stackTrace);
      }

      // Initialize and connect client to the relay
      await _initializeClient();
      return;
    }
    
    // For non-Android platforms, use original logic
    // Start the Nostr relay using RelayService
    relayService = RelayService.instance;
    await relayService!.start(port: port);
    AegisLogger.info('✅ Relay service started on ${relayService!.relayUrl}');

    final fallbackPort = PlatformUtils.isDesktop ? 18081 : 8081;
    final wsPort =
        int.tryParse(relayService!.port) ?? int.tryParse(port) ?? fallbackPort;
    AegisLogger.info(
        '🔧 Attempting to start TLS proxy: platform=${PlatformUtils.platformName}, wsPort=$wsPort');
    try {
      await LocalTlsProxyManagerRust.instance.ensureStarted(wsPort: wsPort);
      AegisLogger.info('✅ TLS proxy start completed');
    } catch (e, stackTrace) {
      AegisLogger.error('❌ Failed to start local TLS proxy', e);
      AegisLogger.error('Stack trace', stackTrace);
    }

    // Initialize and connect client to the relay
    await _initializeClient();
  }

  /// Initialize Nostr client and connect to relay
  Future<void> _initializeClient() async {
    try {
      // Add and connect to local relay
      final relayUrl = relayService!.relayUrl;

      Connect.sharedInstance
          .addConnectStatusListener((relay, status, relayKinds) async {
        if (status == 1 && relay == relayUrl) {
          await _subscribeToNIP46Events();
        }
      });
      // Get Connect instance
      _connect = Connect();
      await _connect!.connect(relayUrl, relayKind: RelayKind.remoteSigner);
    } catch (e) {
      AegisLogger.error('Failed to initialize client', e);
      rethrow;
    }
  }

  /// Subscribe to NIP-46 events
  Future<void> _subscribeToNIP46Events() async {
    try {
      final relayUrl = relayService!.relayUrl;
      if (_subscriptionId.isNotEmpty) {
        Connect.sharedInstance.closeRequests(_subscriptionId, relay: relayUrl);
      }
      // Collect every account pubkey so each account remains reachable
      final serverPubkeys = await _getAllServerPubkeys();
      if (serverPubkeys.isEmpty) {
        AegisLogger.warning(
            'No server pubkeys available for NIP-46 subscription');
        return;
      }

      // Create subscription filter for kind 24133 events with p tags = all pubkeys
      final filter = Filter(
        kinds: [24133],
        p: serverPubkeys,
      );

      // Subscribe using Connect
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

  /// Update subscription to reflect current applications (public method)
  /// Call this after creating or deleting an application
  Future<void> updateSubscription() async {
    if (relayService == null || _connect == null) {
      AegisLogger.warning('Relay service or connect not initialized, skipping subscription update');
      return;
    }
    await _subscribeToNIP46Events();
  }

  Future<void> _ensureAccountsInitialized() async {
    if (_accountsInitialized) return;
    try {
      await AccountManager.sharedInstance.initAccountList();
      _accountsInitialized = true;
    } catch (e) {
      AegisLogger.error('Failed to initialize account cache', e);
    }
  }

  Future<List<String>> _getAllServerPubkeys() async {
    await _ensureAccountsInitialized();
    final manager = AccountManager.sharedInstance;
    final currentPubkey = Account.sharedInstance.currentPubkey;
    final storedAccounts = await AccountManager.getAllAccount();
    final pubkeys = <String>{};

    // Get all remote signer pubkeys from applications
    for (final appNotifier in manager.applicationMap.values) {
      final app = appNotifier.value;
      // Use remote signer pubkey if exists, otherwise fallback to user pubkey (backward compatibility)
      final remoteSignerPubkey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
          ? app.remoteSignerPubkey!
          : app.pubkey;
      if (remoteSignerPubkey.isNotEmpty) {
        pubkeys.add(remoteSignerPubkey);
      }
    }

    // Also add current account's applications if not already included
    if (currentPubkey.isNotEmpty) {
      try {
        final currentApps = await ClientAuthDBISAR.getAllFromDB(currentPubkey);
        for (final app in currentApps) {
          final remoteSignerPubkey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey;
          if (remoteSignerPubkey.isNotEmpty) {
            pubkeys.add(remoteSignerPubkey);
          }
        }
      } catch (e) {
        AegisLogger.warning('Failed to get applications for current account', e);
      }
    }

    // Add user pubkeys as fallback for backward compatibility (if no applications found)
    if (pubkeys.isEmpty) {
      if (currentPubkey.isNotEmpty) {
        pubkeys.add(currentPubkey);
      }
      pubkeys.addAll(manager.accountMap.keys.where((key) => key.isNotEmpty));
      pubkeys.addAll(storedAccounts.keys.where((key) => key.isNotEmpty));
    }

    return pubkeys.toList();
  }

  /// Handle event from relay (called via Connect callback)
  Future<void> _handleEvent(Event event) async {
    try {
      if (!_threadPool.isInitialized) {
        AegisLogger.warning(
            'The thread pool is not initialized. Attempt to reinitialize...');
        try {
          await _threadPool.initialize();
          AegisLogger.info(
              'The reinitialization of the thread pool was successful');
        } catch (e) {
          AegisLogger.error('Thread pool reinitialization failed', e);
          return;
        }
      }

      // Extract remote signer pubkey from event p tag
      final remoteSignerPubkey = _extractServerPubkey(event);
      if (remoteSignerPubkey == null || remoteSignerPubkey.isEmpty) {
        AegisLogger.warning(
            'No remote signer pubkey found in event ${event.id} p tag, using backward compatibility');
        // Backward compatibility: use current pubkey
        await _dealwithApplication(event.pubkey);
      } else {
        // Handle application by remote signer pubkey
        await _dealwithApplicationByRemoteSignerPubkey(remoteSignerPubkey);
      }

      // Get server private key using remote signer pubkey or fallback to user pubkey
      final targetServerPubkey = remoteSignerPubkey ??
          Account.sharedInstance.currentPubkey;
      final serverPrivate = targetServerPubkey.isNotEmpty
          ? await _getServerPrivateKey(targetServerPubkey)
          : null;
      if (targetServerPubkey.isEmpty || serverPrivate == null) {
        AegisLogger.error(
            'Failed to locate server keypair for event ${event.id}');
        return;
      }

      NostrRemoteRequest? remoteRequest = await NostrRemoteRequest.decrypt(
          event.content,
          event.pubkey,
          LocalNostrSigner.instance,
          serverPrivate);

      if (remoteRequest == null) {
        AegisLogger.warning(
            'Failed to decrypt NIP-46 request from ${event.pubkey}');
        return;
      }

      // Process the remote request
      // Pass serverPrivate (remote signer private key) and find user pubkey for signing operations
      final appInfo = await _findApplicationByRemoteSignerPubkey(targetServerPubkey);
      final userPubkey = appInfo?['userPubkey'] as String? ?? targetServerPubkey;
      String? responseJson = await _processRemoteRequest(remoteRequest, event, serverPrivate, userPubkey);
      if (responseJson == null) return;

      // Encrypt response
      String? responseJsonEncrypt = await LocalNostrSigner.instance
          .nip44Encrypt(serverPrivate, responseJson, event.pubkey);

      // Create response event using local Event utilities
      final signEvent = Event.from(
        kind: event.kind,
        tags: [
          ["p", event.pubkey]
        ],
        content: responseJsonEncrypt ?? '',
        pubkey: targetServerPubkey,
        privkey: serverPrivate,
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

  String? _extractServerPubkey(Event event) {
    for (final tag in event.tags) {
      if (tag.isNotEmpty && tag[0] == 'p' && tag.length > 1) {
        return tag[1];
      }
    }
    return null;
  }

  /// Find application and user pubkey by remote signer pubkey
  /// Returns a map with 'app' (ClientAuthDBISAR) and 'userPubkey' (String)
  Future<Map<String, dynamic>?> _findApplicationByRemoteSignerPubkey(
      String remoteSignerPubkey) async {
    await _ensureAccountsInitialized();
    final manager = AccountManager.sharedInstance;
    final account = Account.sharedInstance;

    // Search in applicationMap
    for (final appNotifier in manager.applicationMap.values) {
      final app = appNotifier.value;
      // Check if this is the remote signer pubkey
      final appRemoteSignerPubkey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
          ? app.remoteSignerPubkey!
          : app.pubkey; // Backward compatibility: if remoteSignerPubkey is empty, use user pubkey
      if (appRemoteSignerPubkey == remoteSignerPubkey) {
        return {'app': app, 'userPubkey': app.pubkey};
      }
    }

    // Search in current account's applications
    final currentPubkey = account.currentPubkey;
    if (currentPubkey.isNotEmpty) {
      try {
        final currentApps = await ClientAuthDBISAR.getAllFromDB(currentPubkey);
        for (final app in currentApps) {
          final appRemoteSignerPubkey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey; // Backward compatibility
          if (appRemoteSignerPubkey == remoteSignerPubkey) {
            return {'app': app, 'userPubkey': app.pubkey};
          }
        }
      } catch (e) {
        AegisLogger.warning(
            'Failed to search applications for remote signer pubkey', e);
      }
    }

    // Search in all stored accounts
    final storedAccounts = await AccountManager.getAllAccount();
    for (final userPubkey in storedAccounts.keys) {
      try {
        final apps = await ClientAuthDBISAR.getAllFromDB(userPubkey);
        for (final app in apps) {
          final appRemoteSignerPubkey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey; // Backward compatibility
          if (appRemoteSignerPubkey == remoteSignerPubkey) {
            return {'app': app, 'userPubkey': app.pubkey};
          }
        }
      } catch (e) {
        // Continue searching other accounts
      }
    }

    // Backward compatibility: if remoteSignerPubkey equals user pubkey
    if (remoteSignerPubkey == currentPubkey && currentPubkey.isNotEmpty) {
      return {'app': null, 'userPubkey': currentPubkey};
    }
    if (manager.accountMap.containsKey(remoteSignerPubkey)) {
      return {'app': null, 'userPubkey': remoteSignerPubkey};
    }
    if (storedAccounts.containsKey(remoteSignerPubkey)) {
      return {'app': null, 'userPubkey': remoteSignerPubkey};
    }

    return null;
  }

  /// Find the first unused application (clientPubkey is empty) by remote signer pubkey
  /// Returns the first ClientAuthDBISAR with matching remoteSignerPubkey and empty clientPubkey
  Future<ClientAuthDBISAR?> _findUnusedApplicationByRemoteSignerPubkey(
      String remoteSignerPubkey) async {
    await _ensureAccountsInitialized();
    final manager = AccountManager.sharedInstance;
    final account = Account.sharedInstance;

    // Search in applicationMap
    for (final appNotifier in manager.applicationMap.values) {
      final app = appNotifier.value;
      // Check if this is the remote signer pubkey and clientPubkey is empty
      final appRemoteSignerPubkey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
          ? app.remoteSignerPubkey!
          : app.pubkey; // Backward compatibility: if remoteSignerPubkey is empty, use user pubkey
      if (appRemoteSignerPubkey == remoteSignerPubkey && 
          app.clientPubkey.isEmpty) {
        return app;
      }
    }

    // Search in current account's applications
    final currentPubkey = account.currentPubkey;
    if (currentPubkey.isNotEmpty) {
      try {
        final currentApps = await ClientAuthDBISAR.getAllFromDB(currentPubkey);
        for (final app in currentApps) {
          final appRemoteSignerPubkey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey; // Backward compatibility
          if (appRemoteSignerPubkey == remoteSignerPubkey && 
              app.clientPubkey.isEmpty) {
            return app;
          }
        }
      } catch (e) {
        AegisLogger.warning(
            'Failed to search applications for remote signer pubkey', e);
      }
    }

    // Search in all stored accounts
    final storedAccounts = await AccountManager.getAllAccount();
    for (final userPubkey in storedAccounts.keys) {
      try {
        final apps = await ClientAuthDBISAR.getAllFromDB(userPubkey);
        for (final app in apps) {
          final appRemoteSignerPubkey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey; // Backward compatibility
          if (appRemoteSignerPubkey == remoteSignerPubkey && 
              app.clientPubkey.isEmpty) {
            return app;
          }
        }
      } catch (e) {
        // Continue searching other accounts
      }
    }

    return null;
  }

  /// Get user's private key by user pubkey
  Future<String?> _getUserPrivateKey(String userPubkey) async {
    await _ensureAccountsInitialized();
    final manager = AccountManager.sharedInstance;
    final storedUser = manager.accountMap[userPubkey];
    if (storedUser?.privkey != null && storedUser!.privkey!.isNotEmpty) {
      return storedUser.privkey!;
    }
    if (userPubkey == Account.sharedInstance.currentPubkey) {
      return Account.sharedInstance.currentPrivkey;
    }
    AegisLogger.warning('🔐 [NIP-46] No private key found for userPubkey: ${userPubkey.length > 16 ? userPubkey.substring(0, 16) : userPubkey}...');
    return null;
  }

  Future<String?> _getServerPrivateKey(String serverPubkey) async {
    await _ensureAccountsInitialized();
    
    // First, try to find application by remote signer pubkey
    final appInfo = await _findApplicationByRemoteSignerPubkey(serverPubkey);
    if (appInfo != null) {
      final app = appInfo['app'] as ClientAuthDBISAR?;
      final userPubkey = appInfo['userPubkey'] as String;
      
      // If we found an application with remote signer keypair, use it
      if (app != null && app.remoteSignerPrivateKey != null && app.remoteSignerPrivateKey!.isNotEmpty) {
        return app.remoteSignerPrivateKey!;
      }
      
      // Otherwise, get user's private key
      final manager = AccountManager.sharedInstance;
      final storedUser = manager.accountMap[userPubkey];
      if (storedUser?.privkey != null && storedUser!.privkey!.isNotEmpty) {
        return storedUser.privkey!;
      }
      if (userPubkey == Account.sharedInstance.currentPubkey) {
        return Account.sharedInstance.currentPrivkey;
      }
    }
    
    // Backward compatibility: try direct lookup by serverPubkey as user pubkey
    final manager = AccountManager.sharedInstance;
    final storedUser = manager.accountMap[serverPubkey];
    if (storedUser?.privkey != null && storedUser!.privkey!.isNotEmpty) {
      return storedUser.privkey!;
    }
    if (serverPubkey == Account.sharedInstance.currentPubkey) {
      return Account.sharedInstance.currentPrivkey;
    }
    
    AegisLogger.warning('🔐 [NIP-46] No private key found for serverPubkey: ${serverPubkey.length > 16 ? serverPubkey.substring(0, 16) : serverPubkey}...');
    return null;
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

      // Update application activity timestamp
      if (app != null) {
        try {
          final clientPubkey = app.clientPubkey.isNotEmpty ? app.clientPubkey : pubkey;
          await ClientAuthDBISAR.updateActivityTimestamp(app.pubkey, clientPubkey);
          
          // Update the application in AccountManager to trigger UI refresh
          final updated = await ClientAuthDBISAR.searchFromDB(app.pubkey, clientPubkey);
          if (updated != null) {
            AccountManager.sharedInstance.updateApplicationMap(updated);
          }
        } catch (e) {
          AegisLogger.warning('Failed to update activity timestamp', e);
        }
      }

      await SignedEventManager.sharedInstance.recordSignedEvent(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: eventContent,
        applicationName:
            _formatApplicationName(customAppName ?? app?.name, pubkey),
        applicationPubkey: pubkey,
        status: 1,
        metadata: metadata,
      );
    } catch (e) {
      AegisLogger.error('Failed to record signed event: $eventContent', e);
    }
  }

  Future<String?> _processRemoteRequest(
      NostrRemoteRequest remoteRequest, Event event, String serverPrivate, String userPubkey) async {
    Map responseJson = {};
    // serverPrivate is the remote signer private key (for encryption/decryption)
    // userPubkey is the user pubkey (for signing events)
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
        
        // First check if application already exists by clientPubkey
        ClientAuthDBISAR? client =
            instance.authToNostrConnectInfo[event.pubkey];
        client ??=
            AccountManager.sharedInstance.applicationMap[event.pubkey]?.value;

        if (client != null) {
          // Application already exists, return user pubkey
          responseJson = {
            "id": remoteRequest.id,
            "result": userPubkey,
            "error": "",
          };
          break;
        }

        // Check authorization
        final isSuccess = await Account.authToClient();
        if (!isSuccess) {
          responseJson = {
            "id": remoteRequest.id,
            "result": "",
            "error": "unauthorized",
          };
          break;
        }

        // Find unused application by remote signer pubkey (from event p tag)
        // The remote signer pubkey should be in the event's p tag
        // Find the first application with matching remoteSignerPubkey and empty clientPubkey
        final remoteSignerPubkeyFromEvent = _extractServerPubkey(event);
        ClientAuthDBISAR? unusedApp;

        if (remoteSignerPubkeyFromEvent != null && remoteSignerPubkeyFromEvent.isNotEmpty) {
          // Find the first unused application (clientPubkey is empty) with matching remoteSignerPubkey
          unusedApp = await _findUnusedApplicationByRemoteSignerPubkey(remoteSignerPubkeyFromEvent);
        } else {
          // If no remoteSignerPubkey in event, cannot find application
          AegisLogger.warning('No remote signer pubkey found in event ${event.id} p tag');
        }

        if (unusedApp != null) {
          // Update the application with clientPubkey
          // If the app was stored with a temporary key (remoteSignerPubkey), remove it first
          final oldKey = unusedApp.clientPubkey.isEmpty 
              ? (unusedApp.remoteSignerPubkey ?? '')
              : unusedApp.clientPubkey;
          if (oldKey.isNotEmpty && AccountManager.sharedInstance.applicationMap.containsKey(oldKey)) {
            AccountManager.sharedInstance.removeApplicationMap(oldKey);
          }
          
          unusedApp.clientPubkey = event.pubkey;
          AccountManager.sharedInstance.addApplicationMap(unusedApp);
          try {
            await ClientAuthDBISAR.saveFromDB(unusedApp, isUpdate: true);

            // Record connection event
            await _recordSignedEvent(
              eventId: remoteRequest.id,
              eventKind: 24133,
              eventContent: 'get_public_key',
              pubkey: event.pubkey,
              customAppName: unusedApp.name,
            );

            responseJson = {
              "id": remoteRequest.id,
              "result": userPubkey,
              "error": "",
            };
          } catch (e) {
            AegisLogger.error('Database saving failed', e);
            responseJson = {
              "id": remoteRequest.id,
              "result": "",
              "error": "Failed to update application",
            };
          }
        } else {
          // No unused application found with matching remoteSignerPubkey and empty clientPubkey
          // Automatically create a new application for this connection
          AegisLogger.info('No unused application found with remoteSignerPubkey ${remoteSignerPubkeyFromEvent ?? "unknown"} and empty clientPubkey for client ${event.pubkey}. Creating new application automatically.');
          
          // Create a new application
          final newApp = await createBunkerApplication();
          
          if (newApp != null) {
            // Update the newly created application with clientPubkey
            final oldKey = newApp.clientPubkey.isEmpty 
                ? (newApp.remoteSignerPubkey ?? '')
                : newApp.clientPubkey;
            if (oldKey.isNotEmpty && AccountManager.sharedInstance.applicationMap.containsKey(oldKey)) {
              AccountManager.sharedInstance.removeApplicationMap(oldKey);
            }
            
            newApp.clientPubkey = event.pubkey;
            AccountManager.sharedInstance.addApplicationMap(newApp);
            
            try {
              await ClientAuthDBISAR.saveFromDB(newApp, isUpdate: true);

              // Record connection event
              await _recordSignedEvent(
                eventId: remoteRequest.id,
                eventKind: 24133,
                eventContent: 'get_public_key',
                pubkey: event.pubkey,
                customAppName: newApp.name,
              );

              responseJson = {
                "id": remoteRequest.id,
                "result": userPubkey,
                "error": "",
              };
            } catch (e) {
              AegisLogger.error('Database saving failed after creating new application', e);
              responseJson = {
                "id": remoteRequest.id,
                "result": "",
                "error": "Failed to save newly created application",
              };
            }
          } else {
            // Failed to create new application
            AegisLogger.error('Failed to create new bunker application for client ${event.pubkey}');
            responseJson = {
              "id": remoteRequest.id,
              "result": "",
              "error": "Failed to create application",
            };
          }
        }
        break;

      case "sign_event":
        String? contentStr = remoteRequest.params[0];
        if (contentStr != null && serverPrivate.isNotEmpty) {
          // For signing, we need user's private key, not remote signer private key
          final privateKey = await _getUserPrivateKey(userPubkey);
          if (privateKey == null) {
            responseJson = {
              "id": remoteRequest.id,
              "result": "",
              "error": "No private key found for signing",
            };
            break;
          }

          // Directly pass the event JSON to Rust signing function
          // This ensures all fields (including tags) are preserved without modification
          final nativeRes = await rust_api.signEvent(
            eventJson: contentStr,
            privateKey: privateKey,
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
              eventContent: eventContent.isNotEmpty && eventContent.length < 20
                  ? eventContent
                  : 'Signed Event (Kind $eventKind)',
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

        responseJson = {
          "id": remoteRequest.id,
          "result": result ?? '',
          "error": ''
        };
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

        responseJson = {
          "id": remoteRequest.id,
          "result": result ?? '',
          "error": ''
        };
        break;

      case "nip44_decrypt":
        if (serverPrivate.isEmpty ||
            remoteRequest.params[1] is! String ||
            remoteRequest.params[0] is! String) break;
        String? result = await LocalNostrSigner.instance.nip44Decrypt(
            serverPrivate, remoteRequest.params[1]!, remoteRequest.params[0]!);

        // Record NIP-44 decryption event
        if (result != null) {
          await _recordSignedEvent(
            eventId: remoteRequest.id,
            eventKind: 4,
            eventContent: 'NIP-44 Decrypted Data',
            pubkey: event.pubkey,
          );
        }

        responseJson = {
          "id": remoteRequest.id,
          "result": result ?? '',
          "error": ''
        };
        break;

      case "nip44_encrypt":
        if (serverPrivate.isEmpty ||
            remoteRequest.params[1] is! String ||
            remoteRequest.params[0] is! String) break;

        String? result = await LocalNostrSigner.instance.nip44Encrypt(
            serverPrivate, remoteRequest.params[1]!, remoteRequest.params[0]!);

        // Record NIP-44 encryption event
        if (result != null) {
          await _recordSignedEvent(
            eventId: remoteRequest.id,
            eventKind: 4,
            eventContent: 'NIP-44 Encrypted Data',
            pubkey: event.pubkey,
          );
        }

        responseJson = {
          "id": remoteRequest.id,
          "result": result ?? '',
          "error": ''
        };
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
      encodeResponseJson =
          await _threadPool.runOtherTask(() async => jsonEncode(responseJson));
    } catch (e) {
      AegisLogger.error('JSON encoding failed', e);
      encodeResponseJson = null;
    }

    return encodeResponseJson;
  }

  String getRelayUrlForDisplay({bool secure = false}) {
    final defaultPort = PlatformUtils.isDesktop ? 18081 : 8081;
    final rawUrl = relayService?.relayUrl ?? 'ws://127.0.0.1:$defaultPort';
    if (!secure) {
      return rawUrl;
    }
    final uri = Uri.tryParse(rawUrl);
    final portNumber = uri?.port ?? defaultPort;
    final proxyManager = LocalTlsProxyManagerRust.instance;
    if (!proxyManager.isRunning) {
      return rawUrl;
    }
    return proxyManager.relayUrlFor(portNumber.toString());
  }

  /// Create a new bunker application with remote signer keypair
  /// Returns the created ClientAuthDBISAR or null if failed
  Future<ClientAuthDBISAR?> createBunkerApplication({String? name, String? image}) async {
    try {
      final instance = Account.sharedInstance;
      if (instance.currentPubkey.isEmpty) {
        AegisLogger.warning('Cannot create bunker application: user not logged in');
        return null;
      }

      // Get all bunker applications to calculate index
      final bunkerApplications = AccountManager
          .sharedInstance.applicationMap.values
          .where((app) =>
              app.value.connectionType == EConnectionType.bunker.toInt)
          .toList();
      final index = bunkerApplications.length + 1;

      // Use user's keypair as remote signer keypair
      final remoteSignerPubkey = instance.currentPubkey;
      final remoteSignerPrivateKey = instance.currentPrivkey;
      if (remoteSignerPubkey.isEmpty || remoteSignerPrivateKey.isEmpty) {
        AegisLogger.error('User keypair is empty, cannot create bunker application');
        return null;
      }
      AegisLogger.info(
          'Using user keypair as remote signer keypair for application #$index');

      // Use provided name or default to 'application #$index'
      final applicationName = name != null && name.isNotEmpty 
          ? name 
          : 'application #$index';

      // Create new application with empty clientPubkey (will be set when client connects)
      ClientAuthDBISAR newClient = ClientAuthDBISAR(
        createTimestamp: DateTime.now().millisecondsSinceEpoch,
        pubkey: instance.currentPubkey,
        clientPubkey: '', // Empty clientPubkey, will be set when client connects
        remoteSignerPubkey: remoteSignerPubkey,
        remoteSignerPrivateKey: remoteSignerPrivateKey,
        name: applicationName,
        image: image,
        connectionType: EConnectionType.bunker.toInt,
      );

      // Save to database first
      await ClientAuthDBISAR.saveFromDB(newClient);
      
      // Add to applicationMap using remoteSignerPubkey as key (since clientPubkey is empty)
      final tempApp = ClientAuthDBISAR(
        pubkey: newClient.pubkey,
        clientPubkey: remoteSignerPubkey, // Use remoteSignerPubkey as temporary key
        connectionType: newClient.connectionType,
        remoteSignerPubkey: newClient.remoteSignerPubkey,
        remoteSignerPrivateKey: newClient.remoteSignerPrivateKey,
        name: newClient.name,
        image: newClient.image,
        relay: newClient.relay,
        server: newClient.server,
        secret: newClient.secret,
        scheme: newClient.scheme,
        createTimestamp: newClient.createTimestamp,
        updateTimestamp: newClient.updateTimestamp,
      );
      AccountManager.sharedInstance.addApplicationMap(tempApp);

      // Update subscription to include the new remote signer pubkey
      try {
        await _subscribeToNIP46Events();
        AegisLogger.info('Updated NIP-46 subscription with new remote signer pubkey');
      } catch (e) {
        AegisLogger.warning('Failed to update subscription after creating application', e);
      }

      AegisLogger.info('Created new bunker application with remote signer pubkey: ${remoteSignerPubkey.substring(0, 16)}...');
      return newClient;
    } catch (e) {
      AegisLogger.error('Failed to create bunker application', e);
      return null;
    }
  }

  /// Find an unused bunker application (clientPubkey is empty)
  /// Returns the first unused application or null if not found
  Future<ClientAuthDBISAR?> findUnusedBunkerApplication() async {
    try {
      final instance = Account.sharedInstance;
      if (instance.currentPubkey.isEmpty) {
        return null;
      }

      // Search in applicationMap
      for (final appNotifier in AccountManager.sharedInstance.applicationMap.values) {
        final app = appNotifier.value;
        if (app.connectionType == EConnectionType.bunker.toInt &&
            app.pubkey == instance.currentPubkey &&
            app.clientPubkey.isEmpty) {
          return app;
        }
      }

      // Search in database
      final allApps = await ClientAuthDBISAR.getAllFromDB(instance.currentPubkey);
      for (final app in allApps) {
        if (app.connectionType == EConnectionType.bunker.toInt &&
            app.clientPubkey.isEmpty) {
          // Add to applicationMap if not already there
          // Use remoteSignerPubkey as key when clientPubkey is empty
          final mapKey = (app.remoteSignerPubkey != null && app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : 'unused_${app.id}';
          if (!AccountManager.sharedInstance.applicationMap.containsKey(mapKey)) {
            // Create a temporary app with mapKey as clientPubkey for storage in applicationMap
            // The actual app in database still has empty clientPubkey
            final tempApp = ClientAuthDBISAR(
              pubkey: app.pubkey,
              clientPubkey: mapKey, // Temporary key for applicationMap
              connectionType: app.connectionType,
              remoteSignerPubkey: app.remoteSignerPubkey,
              remoteSignerPrivateKey: app.remoteSignerPrivateKey,
              name: app.name,
              image: app.image,
              relay: app.relay,
              server: app.server,
              secret: app.secret,
              scheme: app.scheme,
              createTimestamp: app.createTimestamp,
              updateTimestamp: app.updateTimestamp,
            );
            AccountManager.sharedInstance.addApplicationMap(tempApp);
          }
          return app;
        }
      }

      return null;
    } catch (e) {
      AegisLogger.error('Failed to find unused bunker application', e);
      return null;
    }
  }

  /// Get or create a bunker application for displaying bunker URL
  /// Returns the remote signer pubkey to use in bunker URL
  Future<String> getOrCreateBunkerApplicationPubkey() async {
    // First try to find an unused application
    final unusedApp = await findUnusedBunkerApplication();
    if (unusedApp != null && unusedApp.remoteSignerPubkey != null && unusedApp.remoteSignerPubkey!.isNotEmpty) {
      return unusedApp.remoteSignerPubkey!;
    }

    // If no unused application, create a new one
    final newApp = await createBunkerApplication();
    if (newApp != null && newApp.remoteSignerPubkey != null && newApp.remoteSignerPubkey!.isNotEmpty) {
      return newApp.remoteSignerPubkey!;
    }

    // Fallback to user pubkey for backward compatibility
    AegisLogger.warning('Failed to get or create bunker application, using user pubkey');
    return Account.sharedInstance.currentPubkey;
  }

  String getBunkerUrl({bool secure = true}) {
    final relayUrl = getRelayUrlForDisplay(secure: secure);
    // This method is synchronous, so we use user pubkey as fallback
    // The actual remote signer pubkey should be obtained via getOrCreateBunkerApplicationPubkey()
    return "bunker://${LocalNostrSigner.instance.publicKey}?relay=$relayUrl";
  }

  /// Get bunker URL with remote signer pubkey
  Future<String> getBunkerUrlWithRemoteSigner({bool secure = true}) async {
    final relayUrl = getRelayUrlForDisplay(secure: secure);
    final remoteSignerPubkey = await getOrCreateBunkerApplicationPubkey();
    return "bunker://$remoteSignerPubkey?relay=$relayUrl";
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

    ClientAuthDBISAR? app = account.authToNostrConnectInfo[clientPubkey] ??
        manager.applicationMap[clientPubkey]?.value;
    if (app == null) return;

    if (!manager.applicationMap.containsKey(clientPubkey)) {
      manager.addApplicationMap(app);
      return;
    }
  }

  /// Handle application by remote signer pubkey (extracted from event p tag)
  Future<void> _dealwithApplicationByRemoteSignerPubkey(
      String remoteSignerPubkey) async {
    final appInfo = await _findApplicationByRemoteSignerPubkey(remoteSignerPubkey);
    if (appInfo == null) return;

    final app = appInfo['app'] as ClientAuthDBISAR?;
    if (app != null) {
      final manager = AccountManager.sharedInstance;
      if (!manager.applicationMap.containsKey(app.clientPubkey)) {
        manager.addApplicationMap(app);
      }
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
        await _connect!
            .closeConnects([relayService!.relayUrl], RelayKind.remoteSigner);
      } catch (e) {
        AegisLogger.error('Failed to close relay connection', e);
      }
    }

    // Stop relay
    if (relayService != null) {
      await relayService!.stop();
    }

    try {
      await LocalTlsProxyManagerRust.instance.stop();
    } catch (e) {
      AegisLogger.error('Failed to stop local TLS proxy', e);
    }

    // Dispose thread pool
    _threadPool.dispose();

    AegisLogger.info('✅ ServerNIP46Signer disposed');
  }

  /// Show dialog when new connection request arrives but no unused application is available
  void _showNewConnectionRequestDialog() {
    // Use addPostFrameCallback to ensure this runs on the UI thread after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = AegisNavigator.navigatorKey.currentContext;
      if (context == null) {
        return;
      }

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('New Connection Request'),
              content: Text('A new application is trying to connect, but no unused application is available. Please create a new application first.'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              actions: [
                TextButton(
                  onPressed: () => AegisNavigator.pop(dialogContext),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AegisNavigator.pop(dialogContext);
                    AegisNavigator.pushPage(
                      context,
                      (context) => const BunkerApplicationNamePage(),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(dialogContext).colorScheme.primary,
                    ),
                  ),
                  child: Text(
                    'Create Application',
                    style: TextStyle(
                      color: Theme.of(dialogContext).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        AegisLogger.error('Failed to show dialog', e);
      }
    });
  }
}
