import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;
import '../../../utils/logger.dart';
import '../../../utils/local_storage.dart';
import '../../../db/userDB_isar.dart';
import '../../../db/db_isar.dart';
import '../../../db/signed_event_db_isar.dart';
import '../../../utils/key_manager.dart';
import '../nip19/nip19.dart';
import '../../../nostr/utils.dart';

/// NIP-55 Core Service Handler
/// Handles all NIP-55 business logic including Content Provider and Intent requests
class NIP55Handler {
  static const MethodChannel _channel = MethodChannel('com.aegis.app/nip55');
  
  // Cache for private key to avoid repeated database queries and decryption
  static String? _cachedPrivateKey;
  static String? _cachedPubkey;
  static int _cacheTimestamp = 0;
  static const int CACHE_TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes cache timeout
  
  /// Initialize NIP-55 handler
  static Future<void> initialize() async {
    try {
      _channel.setMethodCallHandler(_handleMethodCall);
      AegisLogger.info('✅ NIP-55 MethodChannel handler set successfully');
    } catch (e) {
      AegisLogger.error('❌ Failed to set NIP-55 MethodChannel handler', e);
    }
  }
  
  /// Handle method calls from Android
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    AegisLogger.info('📱 NIP-55 MethodChannel received: ${call.method}');
    AegisLogger.info('📱 NIP-55 MethodChannel arguments: ${call.arguments}');
    
    switch (call.method) {
      case 'processNIP55Request':
        return await _processNIP55Request(call.arguments);
      default:
        AegisLogger.error('❌ NIP-55 MethodChannel unknown method: ${call.method}');
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  }
  
  /// Process NIP-55 request from Android Intent
  static Future<Map<String, dynamic>> _processNIP55Request(Map<dynamic, dynamic> args) async {
    try {
      final type = args['type'] as String? ?? 'get_public_key';
      final content = args['content'] as String? ?? '';
      final id = args['id'] as String?;
      final currentUser = args['current_user'] as String?;
      final pubkey = args['pubkey'] as String?;
      final callbackUrl = args['callbackUrl'] as String?;
      final compressionType = args['compressionType'] as String?;
      final returnType = args['returnType'] as String?;
      
      AegisLogger.info('Processing NIP-55 request: type=$type, id=$id');
      AegisLogger.info('Content: $content');
      AegisLogger.info('Callback: $callbackUrl, Compression: $compressionType, Return: $returnType');
      AegisLogger.info('Full NIP-55 args: $args');
      
      switch (type) {
        case 'get_public_key':
          return await handleGetPublicKey(requestId: id);
        case 'sign_event':
          return await handleSignEvent(
            eventJson: content,
            requestId: id,
            currentUser: currentUser,
          );
        case 'nip04_encrypt':
          return await handleNIP04Encrypt(
            plaintext: content,
            pubkey: pubkey!,
            requestId: id,
            currentUser: currentUser,
          );
        case 'nip04_decrypt':
          return await handleNIP04Decrypt(
            ciphertext: content,
            pubkey: pubkey!,
            requestId: id,
            currentUser: currentUser,
          );
        case 'nip44_encrypt':
          return await handleNIP44Encrypt(
            plaintext: content,
            pubkey: pubkey!,
            requestId: id,
            currentUser: currentUser,
          );
        case 'nip44_decrypt':
          return await handleNIP44Decrypt(
            ciphertext: content,
            pubkey: pubkey!,
            requestId: id,
            currentUser: currentUser,
          );
        case 'decrypt_zap_event':
          return await handleDecryptZapEvent(
            eventJson: content,
            requestId: id,
            currentUser: currentUser,
          );
        default:
          throw Exception('Unknown request type: $type');
      }
    } catch (e) {
      AegisLogger.error('NIP-55 request failed', e);
      return {
        'error': e.toString(),
        'id': args['id'],
      };
    }
  }
  
  // ============================================================================
  // Core Business Logic Methods
  // ============================================================================
  
  /// Get current user's private key from database with caching
  static Future<String> getCurrentUserPrivateKey() async {
    // Ensure LocalStorage is initialized
    try {
      await LocalStorage.init();
    } catch (e) {
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
  
  /// Decrypt private key for NIP-55 operations
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
  
  /// Record a signed event to database
  static Future<void> recordSignedEvent({
    required String eventId,
    required int eventKind,
    required String eventContent,
    required String applicationName,
    required String signature,
    String? metadata,
  }) async {
    try {
      // Ensure LocalStorage is initialized
      try {
        await LocalStorage.init();
      } catch (e) {
        AegisLogger.warning('⚠️ LocalStorage init check in recordSignedEvent: $e');
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
        applicationName: applicationName,
        userPubkey: currentPubkey,
        signedTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        status: 1, // 1: signed
        metadata: metadata ?? json.encode({'signature': signature, 'connection_type': 'nip55'}),
      );
      
      await SignedEventDBISAR.saveFromDB(signedEvent);
      AegisLogger.info('✅ Recorded signed event: $eventContent');
    } catch (e) {
      AegisLogger.error('❌ Failed to record signed event: $e');
    }
  }
  
  /// Handle get_public_key request
  static Future<Map<String, dynamic>> handleGetPublicKey({String? requestId}) async {
    try {
      // Get current user's private key
      final currentPrivkey = await getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      // Get public key from current user's private key
      final publicKey = rust_api.getPublicKeyFromPrivate(privateKey: currentPrivkey);
      
      // Convert hex public key to npub format for compatibility with nostr-signer-capacitor-plugin
      final npub = Nip19.encodePubkey(publicKey);
      
      // Record the get_public_key event
      await recordSignedEvent(
        eventId: 'get_public_key_${DateTime.now().millisecondsSinceEpoch}',
        eventKind: 0, // Kind 0 for get_public_key
        eventContent: 'get_public_key',
        applicationName: 'nip55_service',
        signature: 'nip55_${publicKey.substring(0, 16)}',
      );
      
      AegisLogger.info('✅ Generated public key: ${publicKey.substring(0, 16)}...');
      
      return {
        'result': npub, // Return npub format for compatibility
        'package': 'com.aegis.app',
        'id': requestId,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to generate public key: $e');
      return {
        'error': e.toString(),
        'package': 'com.aegis.app',
        'id': requestId,
      };
    }
  }
  
  /// Handle sign_event request
  static Future<Map<String, dynamic>> handleSignEvent({
    required String eventJson,
    String? requestId,
    String? currentUser,
  }) async {
    try {
      // Get current user's private key
      final currentPrivkey = await getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      // Sign the event using Rust
      final signedEventJson = rust_api.signEvent(
        eventJson: eventJson,
        privateKey: currentPrivkey,
      );
      
      // Parse signed event to extract details
      final signedEvent = json.decode(signedEventJson);
      final signature = signedEvent['sig'] as String;
      final eventId = signedEvent['id'] as String;
      final eventKind = signedEvent['kind'] as int;
      final content = signedEvent['content'] as String;
      
      // Record the signed event
      await recordSignedEvent(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: content.length > 100 ? '${content.substring(0, 100)}...' : content,
        applicationName: 'nip55_service',
        signature: signature,
      );
      
      AegisLogger.info('✅ Signed event: ${eventId.substring(0, 16)}...');
      
      return {
        'result': signature,
        'id': requestId,
        'event': signedEventJson,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to sign event: $e');
      return {
        'error': e.toString(),
        'id': requestId,
      };
    }
  }
  
  /// Handle NIP-04 encryption request
  static Future<Map<String, dynamic>> handleNIP04Encrypt({
    required String plaintext,
    required String pubkey,
    String? requestId,
    String? currentUser,
  }) async {
    try {
      // Get current user's private key
      final currentPrivkey = await getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final encrypted = rust_api.nip04Encrypt(
        plaintext: plaintext,
        publicKey: pubkey,
        privateKey: currentPrivkey,
      );
      
      // Record the encryption event
      await recordSignedEvent(
        eventId: 'nip04_encrypt_${DateTime.now().millisecondsSinceEpoch}',
        eventKind: 4, // NIP-04 encrypted direct message kind
        eventContent: 'NIP-04 encryption',
        applicationName: 'nip55_service',
        signature: 'nip04_encrypt_${encrypted.substring(0, 16)}',
      );
      
      AegisLogger.info('✅ NIP-04 encryption completed');
      
      return {
        'result': encrypted,
        'id': requestId,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to encrypt with NIP-04: $e');
      return {
        'error': e.toString(),
        'id': requestId,
      };
    }
  }
  
  /// Handle NIP-04 decryption request
  static Future<Map<String, dynamic>> handleNIP04Decrypt({
    required String ciphertext,
    required String pubkey,
    String? requestId,
    String? currentUser,
  }) async {
    try {
      // Get current user's private key
      final currentPrivkey = await getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final decrypted = rust_api.nip04Decrypt(
        ciphertext: ciphertext,
        publicKey: pubkey,
        privateKey: currentPrivkey,
      );
      
      // Record the decryption event
      await recordSignedEvent(
        eventId: 'nip04_decrypt_${DateTime.now().millisecondsSinceEpoch}',
        eventKind: 4, // NIP-04 encrypted direct message kind
        eventContent: 'NIP-04 decryption',
        applicationName: 'nip55_service',
        signature: 'nip04_decrypt_${decrypted.substring(0, 16)}',
      );
      
      AegisLogger.info('✅ NIP-04 decryption completed');
      
      return {
        'result': decrypted,
        'id': requestId,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt with NIP-04: $e');
      return {
        'error': e.toString(),
        'id': requestId,
      };
    }
  }
  
  /// Handle NIP-44 encryption request
  static Future<Map<String, dynamic>> handleNIP44Encrypt({
    required String plaintext,
    required String pubkey,
    String? requestId,
    String? currentUser,
  }) async {
    try {
      // Get current user's private key
      final currentPrivkey = await getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final encrypted = rust_api.nip44Encrypt(
        plaintext: plaintext,
        publicKey: pubkey,
        privateKey: currentPrivkey,
      );
      
      // Record the encryption event
      await recordSignedEvent(
        eventId: 'nip44_encrypt_${DateTime.now().millisecondsSinceEpoch}',
        eventKind: 44, // NIP-44 encrypted payloads kind
        eventContent: 'NIP-44 encryption',
        applicationName: 'nip55_service',
        signature: 'nip44_encrypt_${encrypted.substring(0, 16)}',
      );
      
      AegisLogger.info('✅ NIP-44 encryption completed');
      
      return {
        'result': encrypted,
        'id': requestId,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to encrypt with NIP-44: $e');
      return {
        'error': e.toString(),
        'id': requestId,
      };
    }
  }
  
  /// Handle NIP-44 decryption request
  static Future<Map<String, dynamic>> handleNIP44Decrypt({
    required String ciphertext,
    required String pubkey,
    String? requestId,
    String? currentUser,
  }) async {
    try {
      // Get current user's private key
      final currentPrivkey = await getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final decrypted = rust_api.nip44Decrypt(
        ciphertext: ciphertext,
        publicKey: pubkey,
        privateKey: currentPrivkey,
      );
      
      // Record the decryption event
      await recordSignedEvent(
        eventId: 'nip44_decrypt_${DateTime.now().millisecondsSinceEpoch}',
        eventKind: 44, // NIP-44 encrypted payloads kind
        eventContent: 'NIP-44 decryption',
        applicationName: 'nip55_service',
        signature: 'nip44_decrypt_${decrypted.substring(0, 16)}',
      );
      
      AegisLogger.info('✅ NIP-44 decryption completed');
      
      return {
        'result': decrypted,
        'id': requestId,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt with NIP-44: $e');
      return {
        'error': e.toString(),
        'id': requestId,
      };
    }
  }
  
  /// Handle decrypt_zap_event request
  static Future<Map<String, dynamic>> handleDecryptZapEvent({
    required String eventJson,
    String? requestId,
    String? currentUser,
  }) async {
    try {
      // This would decrypt a zap event
      // Implementation depends on your zap event structure
      // For now, return a placeholder
      
      // Record the decrypt zap event operation
      await recordSignedEvent(
        eventId: 'decrypt_zap_event_${DateTime.now().millisecondsSinceEpoch}',
        eventKind: 9735, // NIP-57 zap event kind
        eventContent: 'Decrypt zap event',
        applicationName: 'nip55_service',
        signature: 'decrypt_zap_placeholder',
      );
      
      AegisLogger.info('✅ Decrypt zap event completed (placeholder)');
      
      return {
        'result': 'decrypted_zap_content_placeholder',
        'id': requestId,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt zap event: $e');
      return {
        'error': e.toString(),
        'id': requestId,
      };
    }
  }
}
