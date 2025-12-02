import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;

export 'nip49_utils.dart';

/// NIP-49: Private Key Encryption
/// 
/// This class uses Rust implementation from nostr-rust crate
/// for NIP-49 encryption/decryption operations.
class NIP49 {
  static const int version = 0x02;
  static const String hrp = 'ncryptsec';
  static const int defaultLogN = 16;
  static const int minLogN = 12;
  static const int maxLogN = 22;

  /// Encrypt private key using NIP-49 (ncryptsec1 format)
  /// 
  /// Uses Rust implementation from nostr-rust crate
  /// 
  /// [privateKeyHex] - Private key in hex format (64 characters)
  /// [password] - Password for encryption
  /// [logN] - Scrypt log2(N) parameter (12-22, default 16)
  /// [keySecurityByte] - Key security level: 0=Weak, 1=Medium, 2=Unknown (default)
  static Future<String> encrypt(
    String privateKeyHex,
    String password, {
    int logN = defaultLogN,
    int keySecurityByte = 0x02,
  }) async {
    if (privateKeyHex.length != 64) {
      throw ArgumentError('Private key must be 32 bytes (64 hex characters)');
    }

    if (logN < minLogN || logN > maxLogN) {
      throw ArgumentError('logN must be between $minLogN and $maxLogN');
    }

    try {
      final ncryptsec = await rust_api.nip49Encrypt(
        privateKey: privateKeyHex,
        password: password,
        logN: logN,
        keySecurity: keySecurityByte,
      );
      return ncryptsec;
    } catch (e) {
      throw ArgumentError('NIP-49 encryption failed: $e');
    }
  }

  /// Decrypt private key from NIP-49 (ncryptsec1 format)
  /// 
  /// Uses Rust implementation from nostr-rust crate
  /// 
  /// [encryptedKey] - Encrypted private key in ncryptsec1 format
  /// [password] - Password for decryption
  static Future<String> decrypt(String encryptedKey, String password) async {
    if (!encryptedKey.startsWith('ncryptsec1')) {
      throw ArgumentError('Invalid ncryptsec format: must start with "ncryptsec1"');
    }

    try {
      final privateKey = await rust_api.nip49Decrypt(
        ncryptsec: encryptedKey,
        password: password,
      );
      return privateKey;
    } catch (e) {
      throw ArgumentError('NIP-49 decryption failed: $e');
    }
  }
}