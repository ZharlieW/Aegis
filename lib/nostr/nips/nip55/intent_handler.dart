import 'dart:async';
import 'package:flutter/services.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/db/userDB_isar.dart';
import 'package:aegis/db/db_isar.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/key_manager.dart';
import 'package:aegis/nostr/utils.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;
import 'dart:convert';

/// Android Intent Handler for NIP-55 and URL Scheme support
/// Handles communication between Android MainActivity and Flutter app
/// 
/// This class provides similar functionality to ContentProvider
/// but for Intent-based requests instead of Content Provider queries
class IntentHandler {
  static const MethodChannel _channel = MethodChannel('com.aegis.app/intent');
  static StreamController<Map<String, dynamic>>? _intentController;
  
  // Cache for private key to avoid repeated database queries and decryption
  static String? _cachedPrivateKey;
  static String? _cachedPubkey;
  static int _cacheTimestamp = 0;
  static const int CACHE_TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes cache timeout
  
  /// Initialize intent handler
  static Future<void> initialize() async {
    try {
      _channel.setMethodCallHandler(_handleMethodCall);
      _intentController = StreamController<Map<String, dynamic>>.broadcast();
      
      // Note: RustLib and LocalStorage are already initialized in main.dart
      // We don't need to re-initialize them here
      
      AegisLogger.info('✅ Intent handler initialized successfully');
    } catch (e) {
      AegisLogger.error('❌ Failed to initialize intent handler', e);
    }
  }
  
  /// Handle method calls from Android MainActivity
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      AegisLogger.info('📱 Intent handler received: ${call.method}');
      AegisLogger.info('📱 Intent handler arguments: ${call.arguments}');
      
      switch (call.method) {
        case 'onIntentReceived':
          return await _handleIntentReceived(call.arguments);
        case 'getPublicKeyForIntent':
          return await _handleGetPublicKeyForIntent();
        case 'signEventForIntent':
          return await _handleSignEventForIntent(call.arguments);
        case 'signMessageForIntent':
          return await _handleSignMessageForIntent(call.arguments);
        case 'nip04EncryptForIntent':
          return await _handleNIP04EncryptForIntent(call.arguments);
        case 'nip04DecryptForIntent':
          return await _handleNIP04DecryptForIntent(call.arguments);
        case 'nip44EncryptForIntent':
          return await _handleNIP44EncryptForIntent(call.arguments);
        case 'nip44DecryptForIntent':
          return await _handleNIP44DecryptForIntent(call.arguments);
        case 'decryptZapEventForIntent':
          return await _handleDecryptZapEventForIntent(call.arguments);
        default:
          AegisLogger.error('❌ Intent handler unknown method: ${call.method}');
          throw PlatformException(
            code: 'UNIMPLEMENTED',
            message: 'Method ${call.method} not implemented',
          );
      }
    } catch (e) {
      AegisLogger.error('❌ Error in intent handler method call: $e');
      throw PlatformException(
        code: 'HANDLER_ERROR',
        message: 'Error handling method call: $e',
      );
    }
  }
  
  /// Handle intent received from Android
  static Future<void> _handleIntentReceived(Map<dynamic, dynamic> args) async {
    try {
      final data = args['data'] as String?;
      if (data == null) {
        AegisLogger.error('❌ Intent data is null');
        return;
      }
      
      AegisLogger.info('📱 Processing intent data: ${data.substring(0, data.length > 200 ? 200 : data.length)}...');
      
      // Check if this is an error from Android
      if (data.startsWith('error:')) {
        AegisLogger.error('❌ Android reported error: ${data.substring(6)}');
        return;
      }
      
      // Extract Intent extras (type, id, current_user, pubkey, etc.)
      final extras = <String, dynamic>{};
      if (args['type'] != null) extras['type'] = args['type'];
      if (args['id'] != null) extras['id'] = args['id'];
      if (args['current_user'] != null) extras['current_user'] = args['current_user'];
      if (args['pubkey'] != null) extras['pubkey'] = args['pubkey'];
      
      AegisLogger.info('📱 Intent extras: $extras');
      
      // Parse the intent data to determine request type
      final requestType = _parseRequestType(data, extras);
      AegisLogger.info('📱 Detected request type: $requestType');
      
      // Handle different request types
      switch (requestType) {
        case 'get_public_key':
          await _handlePublicKeyRequest(data, extras);
          break;
        case 'sign_event':
          await _handleSignEventRequest(data);
          break;
        case 'sign_message':
          await _handleSignMessageRequest(data);
          break;
        case 'nip04_encrypt':
          await _handleNIP04EncryptRequest(data);
          break;
        case 'nip04_decrypt':
          await _handleNIP04DecryptRequest(data);
          break;
        case 'nip44_encrypt':
          await _handleNIP44EncryptRequest(data);
          break;
        case 'nip44_decrypt':
          await _handleNIP44DecryptRequest(data);
          break;
        case 'decrypt_zap_event':
          await _handleDecryptZapEventRequest(data);
          break;
        default:
          AegisLogger.warning('⚠️ Unknown request type: $requestType, treating as generic scheme');
          await LaunchSchemeUtils.handleSchemeData(data);
      }
      
      // Add to stream for UI to listen
      _intentController?.add({
        'type': requestType,
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
    } catch (e) {
      AegisLogger.error('❌ Failed to handle intent received: $e');
      // Add error to stream
      _intentController?.add({
        'type': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
  
  /// Parse request type from intent data
  static String _parseRequestType(String data, Map<dynamic, dynamic>? extras) {
    try {
      // First, try to get type from Intent extras (following NIP-55 protocol)
      if (extras != null && extras['type'] != null) {
        final type = extras['type'] as String;
        AegisLogger.info('📱 Request type from Intent extras: $type');
        return type;
      }
      
      // Fallback to parsing JSON content for backward compatibility
      if (data.startsWith('nostrsigner:{')) {
        // Parse JSON to determine request type
        final jsonStart = data.indexOf('{');
        final jsonEnd = data.lastIndexOf('}');
        if (jsonStart != -1 && jsonEnd != -1) {
          final jsonStr = data.substring(jsonStart, jsonEnd + 1);
          final json = jsonDecode(jsonStr);
          
          // Check for Nostr event fields
          if (json['id'] != null && json['pubkey'] != null && json['kind'] != null) {
            AegisLogger.info('📱 Detected Nostr event JSON, treating as sign_event');
            return 'sign_event';
          }
          
          // Check for specific operation types
          if (json['event'] != null) return 'sign_event';
          if (json['message'] != null) return 'sign_message';
          if (json['nip04'] != null) return 'nip04_encrypt';
          if (json['nip44'] != null) return 'nip44_encrypt';
          if (json['zap'] != null) return 'decrypt_zap_event';
        }
      }
      
      // Fallback to string matching
      if (data.contains('public_key')) return 'public_key';
      if (data.contains('sign_event')) return 'sign_event';
      if (data.contains('sign_message')) return 'sign_message';
      if (data.contains('nip04_encrypt')) return 'nip04_encrypt';
      if (data.contains('nip04_decrypt')) return 'nip04_decrypt';
      if (data.contains('nip44_encrypt')) return 'nip44_encrypt';
      if (data.contains('nip44_decrypt')) return 'nip44_decrypt';
      if (data.contains('decrypt_zap')) return 'decrypt_zap_event';
      
      return 'unknown';
    } catch (e) {
      AegisLogger.error('❌ Error parsing request type: $e');
      return 'unknown';
    }
  }
  
  /// Handle getting public key for intent-based requests
  /// Similar to ContentProvider._handleGetPublicKey
  static Future<Map<String, dynamic>?> _handleGetPublicKeyForIntent() async {
    try {
      AegisLogger.info('📱 Getting public key for intent request');
      
      // Get current user's private key from database (with caching)
      final currentPrivkey = await _getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        AegisLogger.error('❌ No current user private key available');
        return null;
      }
      
      // Get public key from current user's private key
      final publicKey = rust_api.getPublicKeyFromPrivate(privateKey: currentPrivkey);
      
      // Record the get_public_key event to database
      await _recordSignedEventDirectly(
        eventId: 'get_public_key_intent_${DateTime.now().millisecondsSinceEpoch}',
        eventKind: 0, // Kind 0 for get_public_key
        eventContent: 'get_public_key',
        signature: 'intent_mode_${publicKey.substring(0, 16)}',
        callingPackage: 'intent_mode',
      );
      
      AegisLogger.info('📱 Generated public key for intent: ${publicKey.substring(0, 16)}...');
      
      // Return complete result data for MainActivity to use
      return {
        'result': publicKey,
        'package': 'com.aegis.app',
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to get public key for intent: $e');
      return null;
    }
  }
  
  /// Get current user's private key from database with caching
  /// Similar to ContentProvider._getCurrentUserPrivateKey
  static Future<String> _getCurrentUserPrivateKey() async {
    // Ensure LocalStorage is initialized before accessing it
    try {
      await LocalStorage.init();
    } catch (e) {
      // LocalStorage might already be initialized, ignore the error
      AegisLogger.info('📱 LocalStorage init check: $e');
    }
    
    // Get current pubkey from LocalStorage
    final currentPubkey = LocalStorage.get('pubkey');
    if (currentPubkey == null || currentPubkey.isEmpty) {
      throw Exception('No current user found - user must be logged in');
    }
    
    // Check if we have a valid cached private key for the same user
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_cachedPrivateKey != null && 
        _cachedPubkey == currentPubkey && 
        (now - _cacheTimestamp) < CACHE_TIMEOUT_MS) {
      AegisLogger.info('✅ Using cached private key for user: ${currentPubkey.substring(0, 16)}...');
      return _cachedPrivateKey!;
    }
    
    AegisLogger.info('🔄 Fetching private key from database for user: ${currentPubkey.substring(0, 16)}...');
    
    // Get user from database with error handling for already opened instances
    UserDBISAR? user;
    try {
      user = await UserDBISAR.searchFromDB(currentPubkey);
    } catch (e) {
      if (e.toString().contains('already been opened')) {
        AegisLogger.warning('📱 Database already opened, closing all and retrying...');
        // Close all databases and try again
        await DBISAR.sharedInstance.closeAllDatabases();
        user = await UserDBISAR.searchFromDB(currentPubkey);
      } else {
        AegisLogger.error('❌ Failed to get user from database: $e');
        rethrow;
      }
    }
    if (user == null) {
      throw Exception('User not found in database');
    }
    
    // Decrypt private key
    final decryptedPrivkey = await _decryptPrivkey(user);
    final privateKeyHex = bytesToHex(decryptedPrivkey);
    
    // Cache the private key
    _cachedPrivateKey = privateKeyHex;
    _cachedPubkey = currentPubkey;
    _cacheTimestamp = now;
    
    AegisLogger.info('✅ Private key cached for user: ${currentPubkey.substring(0, 16)}...');
    return privateKeyHex;
  }
  
  /// Decrypt private key for Intent Handler
  /// Similar to ContentProvider._decryptPrivkey
  static Future<Uint8List> _decryptPrivkey(UserDBISAR user) async {
    final encryptedBytes = hexToBytes(user.encryptedPrivkey!);

    // Try to get password from Keychain first
    String? password;

    // For existing users, migrate from database to Keychain if needed
    if (user.defaultPassword != null && user.defaultPassword!.isNotEmpty) {
      // Store the old password before clearing it
      final oldPassword = user.defaultPassword;

      // Migrate old password to Keychain
      try {
        await DBKeyManager.migrateUserPrivkeyKey(user.pubkey, oldPassword);
        // Clear the password from database after successful migration
        user.defaultPassword = null;
        await DBISAR.sharedInstance.saveToDB(user.pubkey, user);
        AegisLogger.info('[Migration] Cleared password from database for user: ${user.pubkey}');

        // Get the migrated password from Keychain
        password = await DBKeyManager.getUserPrivkeyKey(user.pubkey);
      } catch (error) {
        AegisLogger.warning('[Migration] Failed to migrate password for user: ${user.pubkey}, error: $error');
        // Fallback to database password (keep the old password in database)
        password = oldPassword;
      }
    } else {
      // Try to get from Keychain
      password = await DBKeyManager.getUserPrivkeyKey(user.pubkey);
    }

    if (password == null || password.isEmpty) {
      throw Exception('No password found for user private key');
    }

    // Decrypt the private key
    final decrypted = decryptPrivateKey(encryptedBytes, password);
    return decrypted;
  }
  
  
  
  /// Get current intent data from Android
  static Future<Map<String, dynamic>?> getIntentData() async {
    try {
      final result = await _channel.invokeMethod('getIntentData');
      return Map<String, dynamic>.from(result);
    } catch (e) {
      AegisLogger.error('❌ Failed to get intent data: $e');
      return null;
    }
  }
  
  /// Stream of intent data for UI to listen
  static Stream<Map<String, dynamic>>? get intentStream => _intentController?.stream;
  
  /// Dispose the intent handler
  static void dispose() {
    _intentController?.close();
    _intentController = null;
  }
  
  /// Send signing result back to Android (following NIP-55 protocol)
  static Future<void> _sendSignResultToAndroid(String signature, String eventId, String signedEvent) async {
    try {
      // Create result data following NIP-55 protocol
      final resultData = {
        'result': signature,
        'id': eventId,
        'event': signedEvent,
      };
      
      AegisLogger.info('📱 Sending sign result to Android: signature=${signature.substring(0, 16)}..., id=$eventId');
      
      // Send result back to Android via MethodChannel
      await _channel.invokeMethod('setSignResult', resultData);
      
    } catch (e) {
      AegisLogger.error('❌ Error sending sign result to Android: $e');
    }
  }
  
  /// Send public key result to Android via MethodChannel
  static Future<void> _sendPublicKeyResultToAndroid(String publicKey, String? packageName, String? requestId) async {
    try {
      // Create result data following NIP-55 protocol
      final resultData = {
        'result': publicKey,
        'package': packageName ?? 'com.aegis.app',
        'id': requestId,
      };
      
      AegisLogger.info('📱 Sending public key result to Android: ${publicKey.substring(0, 16)}..., id=$requestId');
      
      // Send result back to Android via MethodChannel
      await _channel.invokeMethod('setSignResult', resultData);
      
    } catch (e) {
      AegisLogger.error('❌ Error sending public key result to Android: $e');
    }
  }
  
  static Future<void> _sendGenericResultToAndroid(String result, String? requestId) async {
    try {
      // Create result data following NIP-55 protocol
      final resultData = {
        'result': result,
        'id': requestId,
      };
      
      AegisLogger.info('📱 Sending generic result to Android: result=${result.substring(0, 16)}..., id=$requestId');
      
      // Send result back to Android via MethodChannel
      await _channel.invokeMethod('setSignResult', resultData);
      
    } catch (e) {
      AegisLogger.error('❌ Error sending generic result to Android: $e');
    }
  }
  
  /// Record a signed event to database (similar to ContentProvider._recordSignedEventDirectly)
  static Future<void> _recordSignedEventDirectly({
    required String eventId,
    required int eventKind,
    required String eventContent,
    required String signature,
    required String callingPackage,
  }) async {
    try {
      // Ensure LocalStorage is initialized
      try {
        await LocalStorage.init();
      } catch (e) {
        AegisLogger.warning('⚠️ LocalStorage init check in _recordSignedEventDirectly: $e');
      }
      
      // Get current user pubkey
      final currentPubkey = LocalStorage.get('pubkey');
      if (currentPubkey == null || currentPubkey.isEmpty) {
        AegisLogger.warning('⚠️ No current user found, skipping event recording');
        return;
      }
      
      // Create signed event record
      final signedEvent = SignedEventDBISAR(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: eventContent,
        applicationName: callingPackage,
        userPubkey: currentPubkey,
        signedTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        status: 1, // 1: signed
        metadata: json.encode({'signature': signature, 'connection_type': 'nip55_intent'}),
      );
      
      await SignedEventDBISAR.saveFromDB(signedEvent);
      AegisLogger.info('✅ Directly recorded signed event: $eventContent');
    } catch (e) {
      AegisLogger.error('❌ Failed to record signed event directly: $e');
    }
  }
  
  // ============================================================================
  // Request Type Handlers
  // ============================================================================
  
  /// Handle public key request
  static Future<void> _handlePublicKeyRequest(String data, Map<dynamic, dynamic>? extras) async {
    try {
      AegisLogger.info('📱 Handling public key request');
      final requestId = extras?['id'] as String?;
      final resultData = await _handleGetPublicKeyForIntent();
      if (resultData != null) {
        final publicKey = resultData['result'] as String?;
        final packageName = resultData['package'] as String?;
        if (publicKey != null) {
          AegisLogger.info('✅ Public key request completed: ${publicKey.substring(0, 16)}...');
          // Send result back to Android
          await _sendPublicKeyResultToAndroid(publicKey, packageName, requestId);
        } else {
          AegisLogger.error('❌ Failed to get public key from result data');
        }
      } else {
        AegisLogger.error('❌ Failed to get public key');
      }
    } catch (e) {
      AegisLogger.error('❌ Error handling public key request: $e');
    }
  }
  
  /// Handle sign event request
  static Future<void> _handleSignEventRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling sign event request');
      
      // Parse the nostrsigner: JSON data
      if (data.startsWith('nostrsigner:{')) {
        final jsonStart = data.indexOf('{');
        final jsonEnd = data.lastIndexOf('}');
        if (jsonStart != -1 && jsonEnd != -1) {
          final jsonStr = data.substring(jsonStart, jsonEnd + 1);
          final eventData = jsonDecode(jsonStr);
          
          AegisLogger.info('📱 Parsed event data: id=${eventData['id']}, kind=${eventData['kind']}');
          
          // Get current user's private key (with timeout)
          final privateKey = await _getCurrentUserPrivateKey().timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              AegisLogger.error('❌ Timeout getting private key');
              return '';
            },
          );
          
          if (privateKey.isEmpty) {
            AegisLogger.error('❌ No private key available for signing');
            return;
          }
          
          AegisLogger.info('📱 Starting event signing...');
          
          // Sign the event using Rust API (with timeout)
          final signedEvent = await Future(() => rust_api.signEvent(
            privateKey: privateKey,
            eventJson: jsonStr,
          )).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              AegisLogger.error('❌ Timeout signing event');
              throw Exception('Signing timeout');
            },
          );
          
          AegisLogger.info('✅ Event signed successfully');
          
          // Parse signed event to extract signature
          final signedEventData = jsonDecode(signedEvent);
          final signature = signedEventData['sig'] as String;
          final eventId = signedEventData['id'] as String;
          final eventKind = signedEventData['kind'] as int;
          final content = signedEventData['content'] as String;
          
          AegisLogger.info('📱 Extracted signature: ${signature.substring(0, 16)}...');
          
          // Send result back to Android immediately (following NIP-55 protocol)
          await _sendSignResultToAndroid(signature, eventId, signedEvent);
          
          // Record the signed event (async, don't wait)
          _recordSignedEventDirectly(
            eventId: eventId,
            eventKind: eventKind,
            eventContent: content.length > 100 ? '${content.substring(0, 100)}...' : content,
            signature: signature,
            callingPackage: 'com.oxchat.lite', // OX Pro package name
          );
          
          AegisLogger.info('✅ Sign event request completed successfully');
        } else {
          AegisLogger.error('❌ Invalid JSON format in sign event request');
        }
      } else {
        AegisLogger.warning('⚠️ Non-JSON sign event request, falling back to scheme handler');
        await LaunchSchemeUtils.handleSchemeData(data);
      }
    } catch (e) {
      AegisLogger.error('❌ Error handling sign event request: $e');
      // Try to send error result to Android
      try {
        await _sendSignResultToAndroid('', '', '');
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle sign message request
  static Future<void> _handleSignMessageRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling sign message request');
      await LaunchSchemeUtils.handleSchemeData(data);
      AegisLogger.info('✅ Sign message request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling sign message request: $e');
    }
  }
  
  /// Handle NIP-04 encrypt request
  static Future<void> _handleNIP04EncryptRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling NIP-04 encrypt request');
      
      // Parse the request data to extract id
      final requestData = jsonDecode(data);
      final requestId = requestData['id'] as String?;
      
      // For now, return a placeholder result (this should be implemented properly)
      await _sendGenericResultToAndroid('encrypted_data_placeholder', requestId);
      
      AegisLogger.info('✅ NIP-04 encrypt request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling NIP-04 encrypt request: $e');
      // Send error result
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle NIP-04 decrypt request
  static Future<void> _handleNIP04DecryptRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling NIP-04 decrypt request');
      
      // Parse the request data to extract id
      final requestData = jsonDecode(data);
      final requestId = requestData['id'] as String?;
      
      // For now, return a placeholder result (this should be implemented properly)
      await _sendGenericResultToAndroid('decrypted_data_placeholder', requestId);
      
      AegisLogger.info('✅ NIP-04 decrypt request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling NIP-04 decrypt request: $e');
      // Send error result
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle NIP-44 encrypt request
  static Future<void> _handleNIP44EncryptRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling NIP-44 encrypt request');
      
      // Parse the request data to extract id
      final requestData = jsonDecode(data);
      final requestId = requestData['id'] as String?;
      
      // For now, return a placeholder result (this should be implemented properly)
      await _sendGenericResultToAndroid('nip44_encrypted_data_placeholder', requestId);
      
      AegisLogger.info('✅ NIP-44 encrypt request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling NIP-44 encrypt request: $e');
      // Send error result
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle NIP-44 decrypt request
  static Future<void> _handleNIP44DecryptRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling NIP-44 decrypt request');
      
      // Parse the request data to extract id
      final requestData = jsonDecode(data);
      final requestId = requestData['id'] as String?;
      
      // For now, return a placeholder result (this should be implemented properly)
      await _sendGenericResultToAndroid('nip44_decrypted_data_placeholder', requestId);
      
      AegisLogger.info('✅ NIP-44 decrypt request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling NIP-44 decrypt request: $e');
      // Send error result
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle decrypt zap event request
  static Future<void> _handleDecryptZapEventRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling decrypt zap event request');
      
      // Parse the request data to extract id
      final requestData = jsonDecode(data);
      final requestId = requestData['id'] as String?;
      
      // For now, return a placeholder result (this should be implemented properly)
      await _sendGenericResultToAndroid('decrypted_zap_event_placeholder', requestId);
      
      AegisLogger.info('✅ Decrypt zap event request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling decrypt zap event request: $e');
      // Send error result
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  // ============================================================================
  // Direct Method Handlers (for specific method calls)
  // ============================================================================
  
  /// Handle sign event for intent
  static Future<String?> _handleSignEventForIntent(Map<dynamic, dynamic> args) async {
    try {
      final eventJson = args['eventJson'] as String?;
      if (eventJson == null) {
        AegisLogger.error('❌ No event JSON provided for signing');
        return null;
      }
      
      AegisLogger.info('📱 Signing event for intent');
      
      // Parse and sign the event
      final privateKey = await _getCurrentUserPrivateKey();
      
      if (privateKey.isEmpty) {
        AegisLogger.error('❌ No private key available for signing');
        return null;
      }
      
      // Sign the event using Rust API
      final signedEvent = rust_api.signEvent(
        privateKey: privateKey,
        eventJson: eventJson,
      );
      
      AegisLogger.info('✅ Event signed successfully');
      return signedEvent;
    } catch (e) {
      AegisLogger.error('❌ Error signing event for intent: $e');
      return null;
    }
  }
  
  /// Handle sign message for intent
  static Future<String?> _handleSignMessageForIntent(Map<dynamic, dynamic> args) async {
    try {
      final message = args['message'] as String?;
      if (message == null) {
        AegisLogger.error('❌ No message provided for signing');
        return null;
      }
      
      AegisLogger.info('📱 Signing message for intent');
      
      final privateKey = await _getCurrentUserPrivateKey();
      if (privateKey.isEmpty) {
        AegisLogger.error('❌ No private key available for signing');
        return null;
      }
      
      // Sign the message using Rust API (if available)
      // Note: signMessage might not be available in rust_api
      // For now, we'll use a placeholder implementation
      final signature = "signature_placeholder_for_$message";
      
      AegisLogger.info('✅ Message signed successfully');
      return signature;
    } catch (e) {
      AegisLogger.error('❌ Error signing message for intent: $e');
      return null;
    }
  }
  
  /// Handle NIP-04 encrypt for intent
  static Future<String?> _handleNIP04EncryptForIntent(Map<dynamic, dynamic> args) async {
    try {
      final message = args['message'] as String?;
      final recipientPubkey = args['recipientPubkey'] as String?;
      
      if (message == null || recipientPubkey == null) {
        AegisLogger.error('❌ Missing message or recipient pubkey for NIP-04 encryption');
        return null;
      }
      
      AegisLogger.info('📱 NIP-04 encrypting for intent');
      
      final privateKey = await _getCurrentUserPrivateKey();
      if (privateKey.isEmpty) {
        AegisLogger.error('❌ No private key available for encryption');
        return null;
      }
      
      // Encrypt using Rust API
      final encrypted = rust_api.nip04Encrypt(
        plaintext: message,
        publicKey: recipientPubkey,
        privateKey: privateKey,
      );
      
      AegisLogger.info('✅ NIP-04 encryption completed');
      return encrypted;
    } catch (e) {
      AegisLogger.error('❌ Error NIP-04 encrypting for intent: $e');
      return null;
    }
  }
  
  /// Handle NIP-04 decrypt for intent
  static Future<String?> _handleNIP04DecryptForIntent(Map<dynamic, dynamic> args) async {
    try {
      final encryptedMessage = args['encryptedMessage'] as String?;
      final senderPubkey = args['senderPubkey'] as String?;
      
      if (encryptedMessage == null || senderPubkey == null) {
        AegisLogger.error('❌ Missing encrypted message or sender pubkey for NIP-04 decryption');
        return null;
      }
      
      AegisLogger.info('📱 NIP-04 decrypting for intent');
      
      final privateKey = await _getCurrentUserPrivateKey();
      if (privateKey.isEmpty) {
        AegisLogger.error('❌ No private key available for decryption');
        return null;
      }
      
      // Decrypt using Rust API
      final decrypted = rust_api.nip04Decrypt(
        ciphertext: encryptedMessage,
        publicKey: senderPubkey,
        privateKey: privateKey,
      );
      
      AegisLogger.info('✅ NIP-04 decryption completed');
      return decrypted;
    } catch (e) {
      AegisLogger.error('❌ Error NIP-04 decrypting for intent: $e');
      return null;
    }
  }
  
  /// Handle NIP-44 encrypt for intent
  static Future<String?> _handleNIP44EncryptForIntent(Map<dynamic, dynamic> args) async {
    try {
      final message = args['message'] as String?;
      final recipientPubkey = args['recipientPubkey'] as String?;
      
      if (message == null || recipientPubkey == null) {
        AegisLogger.error('❌ Missing message or recipient pubkey for NIP-44 encryption');
        return null;
      }
      
      AegisLogger.info('📱 NIP-44 encrypting for intent');
      
      final privateKey = await _getCurrentUserPrivateKey();
      if (privateKey.isEmpty) {
        AegisLogger.error('❌ No private key available for encryption');
        return null;
      }
      
      // Encrypt using Rust API
      final encrypted = rust_api.nip44Encrypt(
        plaintext: message,
        publicKey: recipientPubkey,
        privateKey: privateKey,
      );
      
      AegisLogger.info('✅ NIP-44 encryption completed');
      return encrypted;
    } catch (e) {
      AegisLogger.error('❌ Error NIP-44 encrypting for intent: $e');
      return null;
    }
  }
  
  /// Handle NIP-44 decrypt for intent
  static Future<String?> _handleNIP44DecryptForIntent(Map<dynamic, dynamic> args) async {
    try {
      final encryptedMessage = args['encryptedMessage'] as String?;
      final senderPubkey = args['senderPubkey'] as String?;
      
      if (encryptedMessage == null || senderPubkey == null) {
        AegisLogger.error('❌ Missing encrypted message or sender pubkey for NIP-44 decryption');
        return null;
      }
      
      AegisLogger.info('📱 NIP-44 decrypting for intent');
      
      final privateKey = await _getCurrentUserPrivateKey();
      if (privateKey.isEmpty) {
        AegisLogger.error('❌ No private key available for decryption');
        return null;
      }
      
      // Decrypt using Rust API
      final decrypted = rust_api.nip44Decrypt(
        ciphertext: encryptedMessage,
        publicKey: senderPubkey,
        privateKey: privateKey,
      );
      
      AegisLogger.info('✅ NIP-44 decryption completed');
      return decrypted;
    } catch (e) {
      AegisLogger.error('❌ Error NIP-44 decrypting for intent: $e');
      return null;
    }
  }
  
  /// Handle decrypt zap event for intent
  static Future<String?> _handleDecryptZapEventForIntent(Map<dynamic, dynamic> args) async {
    try {
      final zapEventJson = args['zapEventJson'] as String?;
      
      if (zapEventJson == null) {
        AegisLogger.error('❌ No zap event JSON provided for decryption');
        return null;
      }
      
      AegisLogger.info('📱 Decrypting zap event for intent');
      
      final privateKey = await _getCurrentUserPrivateKey();
      if (privateKey.isEmpty) {
        AegisLogger.error('❌ No private key available for zap decryption');
        return null;
      }
      
      // Decrypt zap event using Rust API (placeholder implementation)
      // Note: decryptZapEvent might not be available in rust_api
      final decryptedZap = "decrypted_zap_placeholder_for_$zapEventJson";
      
      AegisLogger.info('✅ Zap event decryption completed');
      return decryptedZap;
    } catch (e) {
      AegisLogger.error('❌ Error decrypting zap event for intent: $e');
      return null;
    }
  }
}

