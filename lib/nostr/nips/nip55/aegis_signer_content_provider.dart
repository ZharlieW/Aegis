import 'dart:async';
import 'dart:convert';

import 'package:android_content_provider/android_content_provider.dart';
import 'package:aegis/utils/logger.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;
import 'package:nostr_rust/src/rust/frb_generated.dart';
import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';

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
      // Initialize RustLib for Content Provider
      await RustLib.init();
      AegisLogger.info('✅ RustLib initialized in Content Provider');
    } catch (e) {
      AegisLogger.error('❌ Failed to initialize RustLib in Content Provider: $e');
      throw e;
    }
  }

  /// Create or get client auth record for NIP-55 client
  Future<ClientAuthDBISAR> _ensureClientAuth(String callingPackage) async {
    final account = Account.sharedInstance;
    final currentPubkey = account.currentPubkey;
    
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
    
    // Add to AccountManager
    AccountManager.sharedInstance.addApplicationMap(newClient);
    
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
      
      await SignedEventManager.sharedInstance.recordSignedEvent(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: eventContent,
        applicationName: callingPackage,
        applicationPubkey: clientAuth.clientPubkey,
        status: 1,
        metadata: metadata,
      );
      
      AegisLogger.info('✅ Recorded NIP-55 event: $eventContent');
    } catch (e) {
      AegisLogger.error('❌ Failed to record NIP-55 event: $e');
    }
  }

  /// Handle GET_PUBLIC_KEY requests
  Future<CursorData> _handleGetPublicKey(String callingPackage, String authDetail, String uri) async {
    try {
      // Generate keys for demo - in production, use actual user keys
      final keys = rust_api.generateKeys();
      
      // Record the get_public_key event
      await _recordNIP55Event(
        eventId: DateTime.now().millisecondsSinceEpoch.toString(),
        eventKind: 24133, // NIP-55 get_public_key event kind
        eventContent: 'get_public_key',
        callingPackage: callingPackage,
        metadata: '{"operation": "get_public_key", "pubkey": "${keys.publicKey}"}',
      );
      
      AegisLogger.info('✅ Generated public key for $callingPackage: ${keys.publicKey.substring(0, 16)}...');
      
      var data = MatrixCursorData(
        columnNames: ['signature'],
        notificationUris: [uri],
      );
      data.addRow([keys.publicKey]);
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

      // For demo, use generated keys - in production, use user's actual private key
      final keys = rust_api.generateKeys();
      
      final signedEventJson = rust_api.signEvent(
        eventJson: eventJson,
        privateKey: keys.privateKey,
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

      // For demo, use generated keys - in production, use user's actual private key
      final keys = rust_api.generateKeys();
      
      final encrypted = rust_api.nip04Encrypt(
        plaintext: plaintext,
        publicKey: pubkey,
        privateKey: keys.privateKey,
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
        columnNames: ['signature'],
        notificationUris: [uri],
      );
      data.addRow([encrypted]);
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

      // For demo, use generated keys - in production, use user's actual private key
      final keys = rust_api.generateKeys();
      
      final decrypted = rust_api.nip04Decrypt(
        ciphertext: ciphertext,
        publicKey: pubkey,
        privateKey: keys.privateKey,
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
        columnNames: ['signature'],
        notificationUris: [uri],
      );
      data.addRow([decrypted]);
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

      // For demo, use generated keys - in production, use user's actual private key
      final keys = rust_api.generateKeys();
      
      final encrypted = rust_api.nip44Encrypt(
        plaintext: plaintext,
        publicKey: pubkey,
        privateKey: keys.privateKey,
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
        columnNames: ['signature'],
        notificationUris: [uri],
      );
      data.addRow([encrypted]);
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

      // For demo, use generated keys - in production, use user's actual private key
      final keys = rust_api.generateKeys();
      
      final decrypted = rust_api.nip44Decrypt(
        ciphertext: ciphertext,
        publicKey: pubkey,
        privateKey: keys.privateKey,
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
        columnNames: ['signature'],
        notificationUris: [uri],
      );
      data.addRow([decrypted]);
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
        columnNames: ['signature'],
        notificationUris: [uri],
      );
      data.addRow(['decrypted_zap_content']);
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