import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:android_content_provider/android_content_provider.dart';
import 'package:aegis/utils/logger.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;
import 'package:nostr_rust/src/rust/frb_generated.dart';

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

  /// Handle GET_PUBLIC_KEY requests
  Future<CursorData> _handleGetPublicKey(String callingPackage, String authDetail, String uri) async {
    try {
      // Generate keys for demo - in production, use actual user keys
      final keys = rust_api.generateKeys();
      
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
      
      // Parse the signed event to extract signature
      final signedEvent = json.decode(signedEventJson);
      final signature = signedEvent['sig'] as String;
      
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