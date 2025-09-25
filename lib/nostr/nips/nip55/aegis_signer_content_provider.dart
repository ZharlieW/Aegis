import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:android_content_provider/android_content_provider.dart';
import 'package:aegis/utils/logger.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;
import 'package:nostr_rust/src/rust/frb_generated.dart';
import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/db/db_isar.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/db/userDB_isar.dart';
import 'package:aegis/utils/key_manager.dart';
import 'package:aegis/nostr/utils.dart';

/// Aegis Signer Content Provider for NIP-55
/// 
/// This class handles Content Provider queries from other Android applications
/// for Nostr signing, encryption, and decryption operations.
class AegisSignerContentProvider extends AndroidContentProvider {
  AegisSignerContentProvider(super.authority);

  @override
  Future<int> delete(
      String uri, String? selection, List<String>? selectionArgs) async {
    return 0;
  }

  @override
  Future<String?> getType(String uri) async {
    return null;
  }

  @override
  Future<String?> insert(String uri, ContentValues? values) async {
    return null;
  }

  int now() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  String? _localCacheCallingPackage;
  int _localCacheUpdateTime = DateTime.now().millisecondsSinceEpoch;

  @override
  Future<void> onCallingPackageChanged() async {
    var callingPackage = await getCallingPackage();
    if (callingPackage != null) {
      _localCacheCallingPackage = callingPackage;
      _localCacheUpdateTime = now();
    }
  }

  bool inited = false;

  // Cache for private key to avoid repeated database queries and decryption
  String? _cachedPrivateKey;
  String? _cachedPubkey;
  int _cacheTimestamp = 0;
  static const int CACHE_TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes cache timeout

  @override
  Future<CursorData?> query(String uri, List<String>? projection,
      String? selection, List<String>? selectionArgs, String? sortOrder) async {
    
    AegisLogger.info('📱 Content Provider query received: $uri');
    AegisLogger.info('📱 Projection: $projection');
    AegisLogger.info('📱 Selection: $selection');
    
    if (!inited) {
      await _doInit();
      inited = true;
    }

    // Extract operation type from URI
    var operationType = uri.replaceAll("content://com.aegis.app.", "");
    String authDetail = "";
    String? pubkey;
    String? currentUser;
    
    if (projection != null && projection.isNotEmpty) {
      authDetail = projection.first;
      if (projection.length > 1) {
        pubkey = projection[1];
      }
      if (projection.length > 2) {
        currentUser = projection[2];
      }
    }

    // Get calling package
    var callingPackage = await getCallingPackage();
    if (callingPackage == null && now() - _localCacheUpdateTime < 5000) {
      callingPackage = _localCacheCallingPackage;
    }
    
    if (callingPackage == null) {
      AegisLogger.error('❌ Failed to get calling package');
      return null;
    }

    AegisLogger.info('📱 Processing $operationType request from $callingPackage');

    try {
      switch (operationType) {
        case 'GET_PUBLIC_KEY':
          return await _handleGetPublicKey(callingPackage, authDetail, uri);
        case 'SIGN_EVENT':
          return await _handleSignEvent(callingPackage, authDetail, currentUser, uri);
        case 'NIP04_ENCRYPT':
          return await _handleNIP04Encrypt(callingPackage, authDetail, pubkey, currentUser, uri);
        case 'NIP04_DECRYPT':
          return await _handleNIP04Decrypt(callingPackage, authDetail, pubkey, currentUser, uri);
        case 'NIP44_ENCRYPT':
          return await _handleNIP44Encrypt(callingPackage, authDetail, pubkey, currentUser, uri);
        case 'NIP44_DECRYPT':
          return await _handleNIP44Decrypt(callingPackage, authDetail, pubkey, currentUser, uri);
        case 'DECRYPT_ZAP_EVENT':
          return await _handleDecryptZapEvent(callingPackage, authDetail, currentUser, uri);
        default:
          AegisLogger.error('❌ Unknown operation type: $operationType');
          return null;
      }
    } catch (e) {
      AegisLogger.error('❌ Content Provider error: $e');
      return null;
    }
  }

  @override
  Future<int> update(String uri, ContentValues? values, String? selection,
      List<String>? selectionArgs) async {
    return 0;
  }

  /// Initialize the content provider
  Future<void> _doInit() async {
    AegisLogger.info('🚀 Initializing Aegis Signer Content Provider');
    
    try {
      // Clear any existing private key cache
      _clearPrivateKeyCache();
      
      // Initialize RustLib for Content Provider
      await RustLib.init();
      AegisLogger.info('✅ RustLib initialized in Content Provider');
      
      // Initialize LocalStorage to access stored pubkey
      await LocalStorage.init();
      AegisLogger.info('✅ LocalStorage initialized in Content Provider');
      
      // Get current user pubkey and initialize database
      final pubkey = LocalStorage.get('pubkey');
      if (pubkey != null && pubkey.isNotEmpty) {
        await DBISAR.sharedInstance.open(pubkey);
        AegisLogger.info('✅ DBISAR initialized for user: ${pubkey.substring(0, 16)}...');
        
        // Note: Account.sharedInstance.currentPubkey will be empty in Content Provider
        // We'll handle this in _ensureClientAuth by getting pubkey from LocalStorage
      } else {
        AegisLogger.warning('⚠️ No current user found in LocalStorage');
      }
    } catch (e) {
      AegisLogger.error('❌ Failed to initialize Content Provider: $e');
      throw e;
    }
  }

  /// Create or get client auth record for NIP-55 client
  Future<ClientAuthDBISAR> _ensureClientAuth(String callingPackage) async {
    // Get current pubkey from LocalStorage (since Account.currentPubkey is empty in Content Provider)
    final currentPubkey = LocalStorage.get('pubkey');
    if (currentPubkey == null || currentPubkey.isEmpty) {
      throw Exception('No current user found - user must be logged in');
    }
    
    // Generate a client pubkey based on package name for NIP-55
    final clientPubkey = _generateClientPubkeyFromPackage(callingPackage);
    
    // Check if client already exists
    ClientAuthDBISAR? existingClient = await ClientAuthDBISAR.searchFromDB(currentPubkey, clientPubkey);
    
    if (existingClient != null) {
      return existingClient;
    }
    
    // Create new client auth record
    final newClient = ClientAuthDBISAR(
      createTimestamp: DateTime.now().millisecondsSinceEpoch,
      pubkey: currentPubkey,
      clientPubkey: clientPubkey,
      name: callingPackage,
      connectionType: EConnectionType.nip55.toInt,
    );
    
    // Save to database
    await ClientAuthDBISAR.saveFromDB(newClient);
    
    // Add to AccountManager (if it's initialized)
    try {
      AccountManager.sharedInstance.addApplicationMap(newClient);
    } catch (e) {
      AegisLogger.warning('⚠️ AccountManager not available in Content Provider: $e');
    }
    
    AegisLogger.info('✅ Created NIP-55 client auth for $callingPackage');
    return newClient;
  }

  /// Generate a consistent client pubkey from package name
  String _generateClientPubkeyFromPackage(String packageName) {
    // Create a consistent pubkey-like string from package name
    // In a real implementation, you might want to use a proper hash function
    final hash = packageName.hashCode.abs().toString().padLeft(64, '0');
    return hash.length > 64 ? hash.substring(0, 64) : hash.padRight(64, '0');
  }

  /// Clear private key cache (call when user switches or logs out)
  void _clearPrivateKeyCache() {
    _cachedPrivateKey = null;
    _cachedPubkey = null;
    _cacheTimestamp = 0;
    AegisLogger.info('🗑️ Private key cache cleared');
  }

  /// Get current user's private key from database with caching
  Future<String> _getCurrentUserPrivateKey() async {
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
    
    // Get user from database
    final user = await UserDBISAR.searchFromDB(currentPubkey);
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

  /// Decrypt private key for Content Provider
  Future<Uint8List> _decryptPrivkey(UserDBISAR user) async {
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

  /// Record a signed event for NIP-55 operation
  Future<void> _recordNIP55Event({
    required String eventId,
    required int eventKind,
    required String eventContent,
    required String callingPackage,
    String? metadata,
  }) async {
    try {
      final clientAuth = await _ensureClientAuth(callingPackage);
      
      // In Content Provider, we need to directly record to database since SignedEventManager
      // checks Account.currentPubkey which is empty in Content Provider process
      await _recordSignedEventDirectly(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: eventContent,
        applicationName: callingPackage,
        applicationPubkey: clientAuth.clientPubkey,
        userPubkey: clientAuth.pubkey,
        status: 1,
        metadata: metadata,
      );
      
      AegisLogger.info('✅ Recorded NIP-55 event: $eventContent');
    } catch (e) {
      AegisLogger.error('❌ Failed to record NIP-55 event: $e');
    }
  }

  /// Directly record signed event to database (bypassing SignedEventManager's login check)
  Future<void> _recordSignedEventDirectly({
    required String eventId,
    required int eventKind,
    required String eventContent,
    required String applicationName,
    required String applicationPubkey,
    required String userPubkey,
    int status = 1,
    String? metadata,
  }) async {
    try {
      // Import the SignedEventDBISAR class and record directly
      // This bypasses the login check in SignedEventManager
      final signedEvent = SignedEventDBISAR(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: eventContent,
        applicationName: applicationName,
        applicationPubkey: applicationPubkey,
        userPubkey: userPubkey,
        status: status,
        metadata: metadata,
        signedTimestamp: DateTime.now().millisecondsSinceEpoch,
      );
      
      await SignedEventDBISAR.saveFromDB(signedEvent);
      AegisLogger.info('✅ Directly recorded signed event: $eventContent');
    } catch (e) {
      AegisLogger.error('❌ Failed to record signed event directly: $e');
    }
  }

  /// Handle GET_PUBLIC_KEY requests
  Future<CursorData> _handleGetPublicKey(String callingPackage, String authDetail, String uri) async {
    try {
      // Get current user's private key from database
      final currentPrivkey = await _getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      // Get public key from current user's private key
      final publicKey = rust_api.getPublicKeyFromPrivate(privateKey: currentPrivkey);
      
      // Record the get_public_key event
      await _recordNIP55Event(
        eventId: DateTime.now().millisecondsSinceEpoch.toString(),
        eventKind: 24133, // NIP-55 get_public_key event kind
        eventContent: 'get_public_key',
        callingPackage: callingPackage,
        metadata: '{"operation": "get_public_key", "pubkey": "$publicKey"}',
      );
      
      AegisLogger.info('✅ Generated public key for $callingPackage: ${publicKey.substring(0, 16)}...');
      
      var data = MatrixCursorData(
        columnNames: ['result', 'signature'],
        notificationUris: [uri],
      );
      data.addRow([publicKey, publicKey]);
      return data;
    } catch (e) {
      AegisLogger.error('❌ Failed to get public key: $e');
      var data = MatrixCursorData(
        columnNames: ['error'],
        notificationUris: [uri],
      );
      data.addRow(['Failed to get public key: $e']);
      return data;
    }
  }

  /// Handle SIGN_EVENT requests
  Future<CursorData> _handleSignEvent(String callingPackage, String eventJson, String? currentUser, String uri) async {
    try {
      if (eventJson.isEmpty) {
        throw Exception('Event JSON is empty');
      }

      // Get current user's private key from database
      final currentPrivkey = await _getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final signedEventJson = rust_api.signEvent(
        eventJson: eventJson,
        privateKey: currentPrivkey,
      );
      
      // Parse the signed event to extract signature and details
      final signedEvent = json.decode(signedEventJson);
      final signature = signedEvent['sig'] as String;
      final eventId = signedEvent['id'] as String;
      final eventKind = signedEvent['kind'] as int;
      final content = signedEvent['content'] as String;
      
      // Record the sign_event operation
      await _recordNIP55Event(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: content.length > 100 ? '${content.substring(0, 100)}...' : content,
        callingPackage: callingPackage,
        metadata: '{"operation": "sign_event", "signature": "$signature"}',
      );
      
      AegisLogger.info('✅ Signed event for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['signature', 'event'],
        notificationUris: [uri],
      );
      data.addRow([signature, signedEventJson]);
      return data;
    } catch (e) {
      AegisLogger.error('❌ Failed to sign event: $e');
      var data = MatrixCursorData(
        columnNames: ['error'],
        notificationUris: [uri],
      );
      data.addRow(['Failed to sign event: $e']);
      return data;
    }
  }

  /// Handle NIP-04 encryption requests
  Future<CursorData> _handleNIP04Encrypt(String callingPackage, String plaintext, String? pubkey, String? currentUser, String uri) async {
    try {
      if (plaintext.isEmpty || pubkey == null || pubkey.isEmpty) {
        throw Exception('Invalid parameters for NIP-04 encryption');
      }

      // Get current user's private key from database
      final currentPrivkey = await _getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final encrypted = rust_api.nip04Encrypt(
        plaintext: plaintext,
        publicKey: pubkey,
        privateKey: currentPrivkey,
      );
      
      // Record the NIP-04 encryption event
      await _recordNIP55Event(
        eventId: DateTime.now().millisecondsSinceEpoch.toString(),
        eventKind: 4, // NIP-04 encrypted direct message kind
        eventContent: 'NIP-04 encryption',
        callingPackage: callingPackage,
        metadata: '{"operation": "nip04_encrypt", "pubkey": "$pubkey"}',
      );
      
      AegisLogger.info('✅ NIP-04 encrypted for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result', 'signature'],
        notificationUris: [uri],
      );
      data.addRow([encrypted, encrypted]);
      return data;
    } catch (e) {
      AegisLogger.error('❌ Failed to encrypt with NIP-04: $e');
      var data = MatrixCursorData(
        columnNames: ['error'],
        notificationUris: [uri],
      );
      data.addRow(['Failed to encrypt: $e']);
      return data;
    }
  }

  /// Handle NIP-04 decryption requests
  Future<CursorData> _handleNIP04Decrypt(String callingPackage, String ciphertext, String? pubkey, String? currentUser, String uri) async {
    try {
      if (ciphertext.isEmpty || pubkey == null || pubkey.isEmpty) {
        throw Exception('Invalid parameters for NIP-04 decryption');
      }

      // Get current user's private key from database
      final currentPrivkey = await _getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final decrypted = rust_api.nip04Decrypt(
        ciphertext: ciphertext,
        publicKey: pubkey,
        privateKey: currentPrivkey,
      );
      
      // Record the NIP-04 decryption event
      await _recordNIP55Event(
        eventId: DateTime.now().millisecondsSinceEpoch.toString(),
        eventKind: 4, // NIP-04 encrypted direct message kind
        eventContent: 'NIP-04 decryption',
        callingPackage: callingPackage,
        metadata: '{"operation": "nip04_decrypt", "pubkey": "$pubkey"}',
      );
      
      AegisLogger.info('✅ NIP-04 decrypted for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result', 'signature'],
        notificationUris: [uri],
      );
      data.addRow([decrypted, decrypted]);
      return data;
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt with NIP-04: $e');
      var data = MatrixCursorData(
        columnNames: ['error'],
        notificationUris: [uri],
      );
      data.addRow(['Failed to decrypt: $e']);
      return data;
    }
  }

  /// Handle NIP-44 encryption requests
  Future<CursorData> _handleNIP44Encrypt(String callingPackage, String plaintext, String? pubkey, String? currentUser, String uri) async {
    try {
      if (plaintext.isEmpty || pubkey == null || pubkey.isEmpty) {
        throw Exception('Invalid parameters for NIP-44 encryption');
      }

      // Get current user's private key from database
      final currentPrivkey = await _getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final encrypted = rust_api.nip44Encrypt(
        plaintext: plaintext,
        publicKey: pubkey,
        privateKey: currentPrivkey,
      );
      
      // Record the NIP-44 encryption event
      await _recordNIP55Event(
        eventId: DateTime.now().millisecondsSinceEpoch.toString(),
        eventKind: 44, // NIP-44 encrypted payloads kind
        eventContent: 'NIP-44 encryption',
        callingPackage: callingPackage,
        metadata: '{"operation": "nip44_encrypt", "pubkey": "$pubkey"}',
      );
      
      AegisLogger.info('✅ NIP-44 encrypted for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result', 'signature'],
        notificationUris: [uri],
      );
      data.addRow([encrypted, encrypted]);
      return data;
    } catch (e) {
      AegisLogger.error('❌ Failed to encrypt with NIP-44: $e');
      var data = MatrixCursorData(
        columnNames: ['error'],
        notificationUris: [uri],
      );
      data.addRow(['Failed to encrypt: $e']);
      return data;
    }
  }

  /// Handle NIP-44 decryption requests
  Future<CursorData> _handleNIP44Decrypt(String callingPackage, String ciphertext, String? pubkey, String? currentUser, String uri) async {
    try {
      if (ciphertext.isEmpty || pubkey == null || pubkey.isEmpty) {
        throw Exception('Invalid parameters for NIP-44 decryption');
      }

      // Get current user's private key from database
      final currentPrivkey = await _getCurrentUserPrivateKey();
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final decrypted = rust_api.nip44Decrypt(
        ciphertext: ciphertext,
        publicKey: pubkey,
        privateKey: currentPrivkey,
      );
      
      // Record the NIP-44 decryption event
      await _recordNIP55Event(
        eventId: DateTime.now().millisecondsSinceEpoch.toString(),
        eventKind: 44, // NIP-44 encrypted payloads kind
        eventContent: 'NIP-44 decryption',
        callingPackage: callingPackage,
        metadata: '{"operation": "nip44_decrypt", "pubkey": "$pubkey"}',
      );
      
      AegisLogger.info('✅ NIP-44 decrypted for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result', 'signature'],
        notificationUris: [uri],
      );
      data.addRow([decrypted, decrypted]);
      return data;
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt with NIP-44: $e');
      var data = MatrixCursorData(
        columnNames: ['error'],
        notificationUris: [uri],
      );
      data.addRow(['Failed to decrypt: $e']);
      return data;
    }
  }

  /// Handle DECRYPT_ZAP_EVENT requests
  Future<CursorData> _handleDecryptZapEvent(String callingPackage, String eventJson, String? currentUser, String uri) async {
    try {
      // For demo purposes, return a placeholder
      AegisLogger.info('📱 Decrypt zap event request from $callingPackage');
      
      // Record the decrypt zap event operation
      await _recordNIP55Event(
        eventId: DateTime.now().millisecondsSinceEpoch.toString(),
        eventKind: 9735, // NIP-57 zap event kind
        eventContent: 'Decrypt zap event',
        callingPackage: callingPackage,
        metadata: '{"operation": "decrypt_zap_event"}',
      );
      
      var data = MatrixCursorData(
        columnNames: ['result', 'signature'],
        notificationUris: [uri],
      );
      data.addRow(['decrypted_zap_content', 'decrypted_zap_content']);
      return data;
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt zap event: $e');
      var data = MatrixCursorData(
        columnNames: ['error'],
        notificationUris: [uri],
      );
      data.addRow(['Failed to decrypt zap event: $e']);
      return data;
    }
  }
}