import 'dart:math';

import 'package:aegis/nostr/utils.dart';
import 'package:bip340/bip340.dart' as bip340;
import 'package:hex/hex.dart';
import 'package:string_validator/string_validator.dart';

/// A keychain encapsulates a public key and a private key, which are used for tasks such as encrypting and decrypting messages, or creating and verifying digital signatures.
class Keychain {
  /// An hex-encoded (64 chars) private key used to decrypt messages or create digital signatures, and it must be kept secret.
  late String private;

  /// A hex-encoded (64 chars) public key used to encrypt messages or verify digital signatures, and it can be shared with anyone.
  late String public;

  /// Instantiate a Keychain with a private key hex-encoded
  Keychain(this.private) {
    assert(
      private.length == 64,
      "Private key should be 64 chars length (32 bytes hex encoded)",
    );
    public = bip340.getPublicKey(private);
  }

  /// Instantiate a Keychain from random bytes
  Keychain.generate() {
    private = generate64RandomHexChars();
    public = bip340.getPublicKey(private);
  }

  /// Encapsulate dart-bip340 sign() so you don't need to add bip340 as a dependency
  String sign(String message) {
    String aux = generate64RandomHexChars();
    return bip340.sign(private, message, aux);
  }

  static String getPublicKey(String private){
    return bip340.getPublicKey(private);
  }

  /// Encapsulate dart-bip340 verify() so you don't need to add bip340 as a dependency
  static bool verify(
    String pubkey,
    String message,
    String signature,
  ) {
    return bip340.verify(pubkey, message, signature);
  }
}

String generatePrivateKey() => getRandomHexString();

/// Returns the BIP340 public key derived from [privateKey].
///
/// An [ArgumentError] is thrown if [privateKey] is invalid.
String getPublicKey(String privateKey) {
  if (!keyIsValid(privateKey)) {
    throw ArgumentError.value(privateKey, 'privateKey', 'Invalid key');
  }
  return bip340.getPublicKey(privateKey);
}

/// Whether [key] is a a 32-byte hexadecimal string.
bool keyIsValid(String key) {
  return (isHexadecimal(key) && key.length == 64);
}

String getRandomHexString([int byteLength = 32]) {
  final Random random = Random.secure();
  var bytes = List<int>.generate(byteLength, (i) => random.nextInt(256));
  return HEX.encode(bytes);
}

