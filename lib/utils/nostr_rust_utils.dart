import 'dart:convert';
import 'package:nostr_rust/src/rust/api/nostr.dart';

/// Nostr Rust utility class
/// Provides NIP-04, NIP-44 encryption/decryption and event signing functionality
class NostrRustUtils {
  /// Generate new Nostr key pair
  static NostrKeys generateKeys() {
    try {
      return generateKeys();
    } catch (e) {
      throw Exception('Failed to generate keys: $e');
    }
  }

  /// NIP-04 encryption
  /// [plaintext] Plaintext to encrypt
  /// [publicKey] Recipient's public key
  /// [privateKey] Sender's private key
  static String nip04Encrypt(
    String plaintext,
    String publicKey,
    String privateKey,
  ) {
    try {
      return nip04Encrypt(
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
  static String nip04Decrypt(
    String ciphertext,
    String publicKey,
    String privateKey,
  ) {
    try {
      return nip04Decrypt(
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
  static String nip44Encrypt(
    String plaintext,
    String publicKey,
    String privateKey,
  ) {
    try {
      return nip44Encrypt(
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
  static String nip44Decrypt(
    String ciphertext,
    String publicKey,
    String privateKey,
  ) {
    try {
      return nip44Decrypt(
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
  static NostrEvent signEvent(
    String eventJson,
    String privateKey,
  ) {
    try {
      return signEvent(
        eventJson: eventJson,
        privateKey: privateKey,
      );
    } catch (e) {
      throw Exception('Event signing failed: $e');
    }
  }

  /// Verify event
  /// [event] Event to verify
  static bool verifyEvent(NostrEvent event) {
    try {
      return verifyEvent(event: event);
    } catch (e) {
      throw Exception('Event verification failed: $e');
    }
  }

  /// Create text note event
  /// [content] Note content
  /// [privateKey] Sender's private key
  /// [tags] Optional tags list
  static NostrEvent createTextNote(
    String content,
    String privateKey, {
    List<List<String>>? tags,
  }) {
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
      return signEvent(eventJson, privateKey);
    } catch (e) {
      throw Exception('Failed to create text note: $e');
    }
  }

  /// Create encrypted direct message (NIP-04)
  /// [content] Message content
  /// [recipientPublicKey] Recipient's public key
  /// [senderPrivateKey] Sender's private key
  static NostrEvent createEncryptedDirectMessage(
    String content,
    String recipientPublicKey,
    String senderPrivateKey,
  ) {
    try {
      // Use NIP-04 to encrypt content
      final encryptedContent = nip04Encrypt(
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
      return signEvent(eventJson, senderPrivateKey);
    } catch (e) {
      throw Exception('Failed to create encrypted direct message: $e');
    }
  }

  /// Create encrypted direct message (NIP-44)
  /// [content] Message content
  /// [recipientPublicKey] Recipient's public key
  /// [senderPrivateKey] Sender's private key
  static NostrEvent createEncryptedDirectMessageV2(
    String content,
    String recipientPublicKey,
    String senderPrivateKey,
  ) {
    try {
      // Use NIP-44 to encrypt content
      final encryptedContent = nip44Encrypt(
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
      return signEvent(eventJson, senderPrivateKey);
    } catch (e) {
      throw Exception('Failed to create encrypted direct message V2: $e');
    }
  }
}