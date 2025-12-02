import 'dart:convert';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;

/// Nostr Rust utility class
/// Provides NIP-04, NIP-44 encryption/decryption and event signing functionality
class NostrRustUtils {
  /// Generate new Nostr key pair
  static Future<rust_api.NostrKeys> generateKeys() async {
    try {
      return await rust_api.generateKeys();
    } catch (e) {
      throw Exception('Failed to generate keys: $e');
    }
  }

  /// NIP-04 encryption
  /// [plaintext] Plaintext to encrypt
  /// [publicKey] Recipient's public key
  /// [privateKey] Sender's private key
  static Future<String> nip04Encrypt(
    String plaintext,
    String publicKey,
    String privateKey,
  ) async {
    try {
      return await rust_api.nip04Encrypt(
        plaintext: plaintext,
        publicKey: publicKey,
        privateKey: privateKey,
      );
    } catch (e) {
      throw Exception('NIP-04 encryption failed: $e');
    }
  }

  /// NIP-04 decryption
  /// [ciphertext] Ciphertext to decrypt
  /// [publicKey] Sender's public key
  /// [privateKey] Recipient's private key
  static Future<String> nip04Decrypt(
    String ciphertext,
    String publicKey,
    String privateKey,
  ) async {
    try {
      return await rust_api.nip04Decrypt(
        ciphertext: ciphertext,
        publicKey: publicKey,
        privateKey: privateKey,
      );
    } catch (e) {
      throw Exception('NIP-04 decryption failed: $e');
    }
  }

  /// NIP-44 encryption
  /// [plaintext] Plaintext to encrypt
  /// [publicKey] Recipient's public key
  /// [privateKey] Sender's private key
  static Future<String> nip44Encrypt(
    String plaintext,
    String publicKey,
    String privateKey,
  ) async {
    try {
      return await rust_api.nip44Encrypt(
        plaintext: plaintext,
        publicKey: publicKey,
        privateKey: privateKey,
      );
    } catch (e) {
      throw Exception('NIP-44 encryption failed: $e');
    }
  }

  /// NIP-44 decryption
  /// [ciphertext] Ciphertext to decrypt
  /// [publicKey] Sender's public key
  /// [privateKey] Recipient's private key
  static Future<String> nip44Decrypt(
    String ciphertext,
    String publicKey,
    String privateKey,
  ) async {
    try {
      return await rust_api.nip44Decrypt(
        ciphertext: ciphertext,
        publicKey: publicKey,
        privateKey: privateKey,
      );
    } catch (e) {
      throw Exception('NIP-44 decryption failed: $e');
    }
  }

  /// Sign event
  /// [eventJson] Event JSON string
  /// [privateKey] Private key for signing
  /// Returns signed event as JSON string
  static Future<String> signEvent(
    String eventJson,
    String privateKey,
  ) async {
    try {
      return await rust_api.signEvent(
        eventJson: eventJson,
        privateKey: privateKey,
      );
    } catch (e) {
      throw Exception('Event signing failed: $e');
    }
  }

  /// Verify event
  /// [event] Event to verify
  static Future<bool> verifyEvent(rust_api.NostrEvent event) async {
    try {
      return await rust_api.verifyEvent(event: event);
    } catch (e) {
      throw Exception('Event verification failed: $e');
    }
  }

  /// Create text note event
  /// [content] Note content
  /// [privateKey] Sender's private key
  /// [tags] Optional tags list
  /// Returns signed event as JSON string
  static Future<String> createTextNote(
    String content,
    String privateKey, {
    List<List<String>>? tags,
  }) async {
    try {
      final eventData = {
        'pubkey': '', // Will be auto-filled during signing
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'kind': 1, // Text note
        'tags': tags ?? [],
        'content': content,
        'sig': '', // Will be auto-filled during signing
      };

      final eventJson = jsonEncode(eventData);
      return await signEvent(eventJson, privateKey);
    } catch (e) {
      throw Exception('Failed to create text note: $e');
    }
  }

  /// Create encrypted direct message (NIP-04)
  /// [content] Message content
  /// [recipientPublicKey] Recipient's public key
  /// [senderPrivateKey] Sender's private key
  /// Returns signed event as JSON string
  static Future<String> createEncryptedDirectMessage(
    String content,
    String recipientPublicKey,
    String senderPrivateKey,
  ) async {
    try {
      // Use NIP-04 to encrypt content
      final encryptedContent = await nip04Encrypt(
        content,
        recipientPublicKey,
        senderPrivateKey,
      );

      final eventData = {
        'pubkey': '', // Will be auto-filled during signing
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'kind': 4, // Direct message
        'tags': [
          ['p', recipientPublicKey]
        ],
        'content': encryptedContent,
        'sig': '', // Will be auto-filled during signing
      };

      final eventJson = jsonEncode(eventData);
      return await signEvent(eventJson, senderPrivateKey);
    } catch (e) {
      throw Exception('Failed to create encrypted direct message: $e');
    }
  }

  /// Create encrypted direct message (NIP-44)
  /// [content] Message content
  /// [recipientPublicKey] Recipient's public key
  /// [senderPrivateKey] Sender's private key
  /// Returns signed event as JSON string
  static Future<String> createEncryptedDirectMessageV2(
    String content,
    String recipientPublicKey,
    String senderPrivateKey,
  ) async {
    try {
      // Use NIP-44 to encrypt content
      final encryptedContent = await nip44Encrypt(
        content,
        recipientPublicKey,
        senderPrivateKey,
      );

      final eventData = {
        'pubkey': '', // Will be auto-filled during signing
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'kind': 4, // Direct message
        'tags': [
          ['p', recipientPublicKey]
        ],
        'content': encryptedContent,
        'sig': '', // Will be auto-filled during signing
      };

      final eventJson = jsonEncode(eventData);
      return await signEvent(eventJson, senderPrivateKey);
    } catch (e) {
      throw Exception('Failed to create encrypted direct message V2: $e');
    }
  }
}