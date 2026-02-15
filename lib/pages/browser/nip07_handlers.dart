import 'dart:convert';

import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;

/// NIP-07 method handlers. Used by WebView page to process nostr bridge messages.
/// Each handler returns a map with 'id' and either 'result' or 'error'.
class Nip07Handlers {
  Nip07Handlers._();

  static String _applicationPubkeyFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty ? uri.host : url;
    } catch (_) {
      return url;
    }
  }

  static Future<Map<String, dynamic>> handleGetPublicKey(
    int id,
    String url,
    String title,
  ) async {
    try {
      final account = Account.sharedInstance;
      final publicKey = account.currentPubkey;

      if (publicKey.isEmpty) {
        return {'id': id, 'error': 'No user logged in'};
      }

      try {
        final applicationPubkey = _applicationPubkeyFromUrl(url);
        final metadata = json.encode({
          'connection_type': 'nip07',
          'url': url,
          'title': title,
        });
        await SignedEventManager.sharedInstance.recordSignedEvent(
          eventId: 'get_public_key_${DateTime.now().millisecondsSinceEpoch}',
          eventKind: 0,
          eventContent: 'get_public_key',
          applicationName: title,
          applicationPubkey: applicationPubkey,
          status: 1,
          metadata: metadata,
        );
        AegisLogger.info('✅ Recorded NIP-07 getPublicKey event');
      } catch (e) {
        AegisLogger.error('❌ Failed to record NIP-07 getPublicKey event: $e');
      }

      return {'id': id, 'result': publicKey};
    } catch (e) {
      AegisLogger.error('❌ Failed to get public key: $e');
      return {'id': id, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> handleSignEvent(
    int id,
    dynamic params,
    String url,
    String title,
  ) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      final publicKey = account.currentPubkey;

      if (privateKey.isEmpty || publicKey.isEmpty) {
        return {'id': id, 'error': 'No user logged in'};
      }

      Map<String, dynamic> eventMap;
      if (params is Map<String, dynamic>) {
        eventMap = Map<String, dynamic>.from(params);
      } else {
        eventMap = json.decode(params.toString());
      }

      if (!eventMap.containsKey('pubkey') ||
          eventMap['pubkey'] == null ||
          (eventMap['pubkey'] as String).isEmpty) {
        eventMap['pubkey'] = publicKey;
      }

      final eventJson = json.encode(eventMap);
      final signedEventJson = await rust_api.signEvent(
        eventJson: eventJson,
        privateKey: privateKey,
      );
      final signedEvent = json.decode(signedEventJson);

      try {
        final eventId = signedEvent['id'] as String? ?? '';
        final eventKind = signedEvent['kind'] as int? ?? -1;
        final eventContent = signedEvent['content'] as String? ?? '';
        if (eventKind != 22242) {
          final applicationPubkey = _applicationPubkeyFromUrl(url);
          final metadata = json.encode({
            'connection_type': 'nip07',
            'url': url,
            'title': title,
          });
          await SignedEventManager.sharedInstance.recordSignedEvent(
            eventId: eventId,
            eventKind: eventKind,
            eventContent: eventContent.isNotEmpty && eventContent.length < 100
                ? eventContent
                : 'Signed Event (Kind $eventKind)',
            applicationName: title,
            applicationPubkey: applicationPubkey,
            status: 1,
            metadata: metadata,
          );
          AegisLogger.info('✅ Recorded NIP-07 signed event: $eventId');
        } else {
          AegisLogger.info(
              '⚠️ Skipped recording kind 22242 event via NIP-07 (should use remote signer/NIP-46)');
        }
      } catch (e) {
        AegisLogger.error('❌ Failed to record NIP-07 signed event: $e');
      }

      return {'id': id, 'result': signedEvent};
    } catch (e) {
      AegisLogger.error('❌ Failed to sign event: $e');
      return {'id': id, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> _recordCryptoAndReturn(
    int id,
    dynamic resultValue,
    String url,
    String title,
    String operation,
    String? targetPubkey,
  ) async {
    try {
      final applicationPubkey = _applicationPubkeyFromUrl(url);
      final metadata = json.encode({
        'connection_type': 'nip07',
        'url': url,
        'title': title,
        'operation': operation,
        if (targetPubkey != null) 'target_pubkey': targetPubkey,
      });
      await SignedEventManager.sharedInstance.recordSignedEvent(
        eventId: '${operation}_${DateTime.now().millisecondsSinceEpoch}',
        eventKind: 4,
        eventContent: '$operation data',
        applicationName: title,
        applicationPubkey: applicationPubkey,
        status: 1,
        metadata: metadata,
      );
      AegisLogger.info('✅ Recorded NIP-07 $operation event');
    } catch (e) {
      AegisLogger.error('❌ Failed to record NIP-07 $operation event: $e');
    }
    return {'id': id, 'result': resultValue};
  }

  static Future<Map<String, dynamic>> handleNip04Encrypt(
    int id,
    dynamic params,
    String url,
    String title,
  ) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      if (privateKey.isEmpty) {
        return {'id': id, 'error': 'No user logged in'};
      }
      final publicKey = params['public_key'] as String;
      final plaintext = params['content'] as String;
      final encrypted = await rust_api.nip04Encrypt(
        plaintext: plaintext,
        publicKey: publicKey,
        privateKey: privateKey,
      );
      return _recordCryptoAndReturn(
        id,
        encrypted,
        url,
        title,
        'nip04_encrypt',
        publicKey,
      );
    } catch (e) {
      AegisLogger.error('❌ Failed to encrypt with NIP-04: $e');
      return {'id': id, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> handleNip04Decrypt(
    int id,
    dynamic params,
    String url,
    String title,
  ) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      if (privateKey.isEmpty) {
        return {'id': id, 'error': 'No user logged in'};
      }
      final publicKey = params['public_key'] as String;
      final ciphertext = params['content'] as String;
      final decrypted = await rust_api.nip04Decrypt(
        ciphertext: ciphertext,
        publicKey: publicKey,
        privateKey: privateKey,
      );
      return _recordCryptoAndReturn(
        id,
        decrypted,
        url,
        title,
        'nip04_decrypt',
        publicKey,
      );
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt with NIP-04: $e');
      return {'id': id, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> handleNip44Encrypt(
    int id,
    dynamic params,
    String url,
    String title,
  ) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      if (privateKey.isEmpty) {
        return {'id': id, 'error': 'No user logged in'};
      }
      final publicKey = params['public_key'] as String;
      final plaintext = params['content'] as String;
      final encrypted = await rust_api.nip44Encrypt(
        plaintext: plaintext,
        publicKey: publicKey,
        privateKey: privateKey,
      );
      return _recordCryptoAndReturn(
        id,
        encrypted,
        url,
        title,
        'nip44_encrypt',
        publicKey,
      );
    } catch (e) {
      AegisLogger.error('❌ Failed to encrypt with NIP-44: $e');
      return {'id': id, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> handleNip44Decrypt(
    int id,
    dynamic params,
    String url,
    String title,
  ) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      if (privateKey.isEmpty) {
        return {'id': id, 'error': 'No user logged in'};
      }
      final publicKey = params['public_key'] as String;
      final ciphertext = params['content'] as String;
      final decrypted = await rust_api.nip44Decrypt(
        ciphertext: ciphertext,
        publicKey: publicKey,
        privateKey: privateKey,
      );
      return _recordCryptoAndReturn(
        id,
        decrypted,
        url,
        title,
        'nip44_decrypt',
        publicKey,
      );
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt with NIP-44: $e');
      return {'id': id, 'error': e.toString()};
    }
  }

  /// Dispatch by method name. Returns response map for the given method, id, params, url, title.
  static Future<Map<String, dynamic>> handle(
    String method,
    int id,
    dynamic params,
    String url,
    String title,
  ) async {
    switch (method) {
      case 'getPublicKey':
        return handleGetPublicKey(id, url, title);
      case 'signEvent':
        return handleSignEvent(id, params, url, title);
      case 'nip04_encrypt':
        return handleNip04Encrypt(id, params, url, title);
      case 'nip04_decrypt':
        return handleNip04Decrypt(id, params, url, title);
      case 'nip44_encrypt':
        return handleNip44Encrypt(id, params, url, title);
      case 'nip44_decrypt':
        return handleNip44Decrypt(id, params, url, title);
      default:
        return {'id': id, 'error': 'Unknown method: $method'};
    }
  }
}
