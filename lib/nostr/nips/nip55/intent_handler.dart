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
    AegisLogger.info('📱 Intent handler received: ${call.method}');
    AegisLogger.info('📱 Intent handler arguments: ${call.arguments}');
    
    switch (call.method) {
      case 'onIntentReceived':
        return await _handleIntentReceived(call.arguments);
      case 'getPublicKeyForIntent':
        return await _handleGetPublicKeyForIntent();
      default:
        AegisLogger.error('❌ Intent handler unknown method: ${call.method}');
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  }
  
  /// Handle intent received from Android
  static Future<void> _handleIntentReceived(Map<dynamic, dynamic> args) async {
    try {
      final data = args['data'] as String?;
      if (data != null) {
        AegisLogger.info('📱 Processing intent data: $data');
        
        // Parse the intent data
        final intentData = _parseIntentData(data);
        
        // Add to stream for UI to listen
        _intentController?.add(intentData);
        
        // Handle scheme data
        await LaunchSchemeUtils.handleSchemeData(data);
        
        // For NIP-55 intents, try to return to calling app after processing
        if (data.startsWith('nostrsigner:')) {
          await _handleNIP55IntentReturn(data);
        }
      }
    } catch (e) {
      AegisLogger.error('❌ Failed to handle intent received: $e');
    }
  }
  
  /// Handle getting public key for intent-based requests
  /// Similar to ContentProvider._handleGetPublicKey
  static Future<String?> _handleGetPublicKeyForIntent() async {
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
      return publicKey;
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
  
  
  /// Handle returning to calling app after NIP-55 intent processing
  static Future<void> _handleNIP55IntentReturn(String schemeData) async {
    try {
      final uri = Uri.tryParse(schemeData);
      if (uri == null) return;
      
      // Check if this is a simple nostrsigner: intent (no specific action)
      if (uri.path.isEmpty && uri.query.isEmpty) {
        AegisLogger.info('📱 Simple nostrsigner intent, returning to calling app');
        
        // Close the current activity to return to calling app
        // This will work if the calling app is still in the background
        await _closeCurrentActivity();
      }
    } catch (e) {
      AegisLogger.error('❌ Failed to handle NIP-55 intent return: $e');
    }
  }
  
  /// Close current activity to return to calling app
  static Future<void> _closeCurrentActivity() async {
    try {
      // Use platform channel to close the current activity
      await _channel.invokeMethod('closeActivity');
    } catch (e) {
      AegisLogger.error('❌ Failed to close activity: $e');
    }
  }
  
  /// Parse intent data from Android
  static Map<String, dynamic> _parseIntentData(String data) {
    try {
      final uri = Uri.parse(data);
      return {
        'scheme': uri.scheme,
        'host': uri.host,
        'path': uri.path,
        'query': uri.query,
        'fragment': uri.fragment,
        'rawData': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to parse intent data: $e');
      return {
        'rawData': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'error': e.toString(),
      };
    }
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
  
  /// Record a signed event to database (similar to ContentProvider._recordSignedEventDirectly)
  static Future<void> _recordSignedEventDirectly({
    required String eventId,
    required int eventKind,
    required String eventContent,
    required String signature,
    required String callingPackage,
  }) async {
    try {
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
}

