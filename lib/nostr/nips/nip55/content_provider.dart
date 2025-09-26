import 'dart:async';

import 'package:android_content_provider/android_content_provider.dart';
import 'package:aegis/utils/logger.dart';
import 'package:nostr_rust/src/rust/frb_generated.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/db/db_isar.dart';
import 'nip55_handler.dart';

/// Aegis Signer Content Provider for NIP-55
/// 
/// This class handles Content Provider queries from other Android applications
/// for Nostr signing, encryption, and decryption operations.
class ContentProvider extends AndroidContentProvider {
  ContentProvider(super.authority);

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
    } else {
      // When projection is empty, use default values
      authDetail = "";
      AegisLogger.info('📱 Empty projection, using default values');
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
      
      // Initialize LocalStorage to access stored pubkey
      await LocalStorage.init();
      AegisLogger.info('✅ LocalStorage initialized in Content Provider');
      
      // Get current user pubkey and initialize database
      final pubkey = LocalStorage.get('pubkey');
      if (pubkey != null && pubkey.isNotEmpty) {
        await DBISAR.sharedInstance.open(pubkey);
        AegisLogger.info('✅ DBISAR initialized for user: ${pubkey.substring(0, 16)}...');
      } else {
        AegisLogger.warning('⚠️ No current user found in LocalStorage');
      }
    } catch (e) {
      AegisLogger.error('❌ Failed to initialize Content Provider: $e');
      throw e;
    }
  }


  /// Handle GET_PUBLIC_KEY requests
  Future<CursorData> _handleGetPublicKey(String callingPackage, String authDetail, String uri) async {
    try {
      AegisLogger.info('📱 Processing GET_PUBLIC_KEY request from $callingPackage');
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleGetPublicKey();
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to get public key: ${result['error']}');
        var data = MatrixCursorData(
          columnNames: ['error'],
          notificationUris: [uri],
        );
        data.addRow(['Failed to get public key: ${result['error']}']);
        return data;
      }
      
      final publicKey = result['result'] as String;
      AegisLogger.info('✅ Generated public key for $callingPackage: ${publicKey.substring(0, 16)}...');
      
      var data = MatrixCursorData(
        columnNames: ['result'],
        notificationUris: [uri],
      );
      data.addRow([publicKey]);
      
      AegisLogger.info('📱 Content Provider returning data: result=${publicKey.substring(0, 16)}...');
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

      AegisLogger.info('📱 Processing SIGN_EVENT request from $callingPackage');
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleSignEvent(
        eventJson: eventJson,
        currentUser: currentUser,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to sign event: ${result['error']}');
        var data = MatrixCursorData(
          columnNames: ['error'],
          notificationUris: [uri],
        );
        data.addRow(['Failed to sign event: ${result['error']}']);
        return data;
      }
      
      final signature = result['result'] as String;
      final signedEventJson = result['event'] as String;
      
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

      AegisLogger.info('📱 Processing NIP-04 encrypt request from $callingPackage');
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleNIP04Encrypt(
        plaintext: plaintext,
        pubkey: pubkey,
        currentUser: currentUser,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to encrypt with NIP-04: ${result['error']}');
        var data = MatrixCursorData(
          columnNames: ['error'],
          notificationUris: [uri],
        );
        data.addRow(['Failed to encrypt: ${result['error']}']);
        return data;
      }
      
      final encrypted = result['result'] as String;
      AegisLogger.info('✅ NIP-04 encrypted for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result'],
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

      AegisLogger.info('📱 Processing NIP-04 decrypt request from $callingPackage');
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleNIP04Decrypt(
        ciphertext: ciphertext,
        pubkey: pubkey,
        currentUser: currentUser,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to decrypt with NIP-04: ${result['error']}');
        var data = MatrixCursorData(
          columnNames: ['error'],
          notificationUris: [uri],
        );
        data.addRow(['Failed to decrypt: ${result['error']}']);
        return data;
      }
      
      final decrypted = result['result'] as String;
      AegisLogger.info('✅ NIP-04 decrypted for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result'],
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

      AegisLogger.info('📱 Processing NIP-44 encrypt request from $callingPackage');
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleNIP44Encrypt(
        plaintext: plaintext,
        pubkey: pubkey,
        currentUser: currentUser,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to encrypt with NIP-44: ${result['error']}');
        var data = MatrixCursorData(
          columnNames: ['error'],
          notificationUris: [uri],
        );
        data.addRow(['Failed to encrypt: ${result['error']}']);
        return data;
      }
      
      final encrypted = result['result'] as String;
      AegisLogger.info('✅ NIP-44 encrypted for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result'],
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

      AegisLogger.info('📱 Processing NIP-44 decrypt request from $callingPackage');
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleNIP44Decrypt(
        ciphertext: ciphertext,
        pubkey: pubkey,
        currentUser: currentUser,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to decrypt with NIP-44: ${result['error']}');
        var data = MatrixCursorData(
          columnNames: ['error'],
          notificationUris: [uri],
        );
        data.addRow(['Failed to decrypt: ${result['error']}']);
        return data;
      }
      
      final decrypted = result['result'] as String;
      AegisLogger.info('✅ NIP-44 decrypted for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result'],
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
      AegisLogger.info('📱 Processing DECRYPT_ZAP_EVENT request from $callingPackage');
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleDecryptZapEvent(
        eventJson: eventJson,
        currentUser: currentUser,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to decrypt zap event: ${result['error']}');
        var data = MatrixCursorData(
          columnNames: ['error'],
          notificationUris: [uri],
        );
        data.addRow(['Failed to decrypt zap event: ${result['error']}']);
        return data;
      }
      
      final decryptedZap = result['result'] as String;
      AegisLogger.info('✅ Decrypt zap event completed for $callingPackage');
      
      var data = MatrixCursorData(
        columnNames: ['result'],
        notificationUris: [uri],
      );
      data.addRow([decryptedZap]);
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