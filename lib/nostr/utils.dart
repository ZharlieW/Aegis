import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/scrypt.dart';

/// generates 32 random bytes converted in hex
String generate64RandomHexChars() {
  final random = Random.secure();
  final randomBytes = List<int>.generate(32, (i) => random.nextInt(256));
  return hex.encode(randomBytes);
}

/// current unix timestamp in seconds
int currentUnixTimestampSeconds() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}

String bytesToHex(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

Uint8List hexToBytes(String hex) {
  List<int> bytes = [];
  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return Uint8List.fromList(bytes);
}

/// encrypt & decrypt PrivateKey
Uint8List generateKeyFromPassword(String password, int length) {
  Uint8List salt = Uint8List.fromList(utf8.encode("Aegis.com"));
  final scrypt = Scrypt()..init(ScryptParameters(16384, 8, 1, 32, salt));

  return scrypt.process(Uint8List.fromList(utf8.encode(password)));
}

Uint8List decryptPrivateKey(Uint8List encryptedPrivateKey, String password) {
  // Generate a key based on the password
  final Uint8List key = generateKeyFromPassword(password, 32);

  // Create the AES cipher in ECB mode
  final BlockCipher cipher = AESEngine();

  // Initialize the cipher with the key
  cipher.init(false, KeyParameter(key));

  // Decrypt the private key
  Uint8List privateKey = Uint8List(encryptedPrivateKey.length);
  for (int offset = 0;
      offset < encryptedPrivateKey.length;
      offset += cipher.blockSize) {
    cipher.processBlock(encryptedPrivateKey, offset, privateKey, offset);
  }

  return privateKey;
}

Uint8List encryptPrivateKey(Uint8List privateKey, String password) {
  // Generate a key based on the password
  final Uint8List key = generateKeyFromPassword(password, 32);

  // Create the AES cipher in ECB mode
  final BlockCipher cipher = AESEngine();

  // Initialize the cipher with the key
  cipher.init(true, KeyParameter(key));

  // Encrypt the private key
  Uint8List encryptedPrivateKey = Uint8List(privateKey.length);
  for (int offset = 0; offset < privateKey.length; offset += cipher.blockSize) {
    cipher.processBlock(privateKey, offset, encryptedPrivateKey, offset);
  }

  return encryptedPrivateKey;
}

String generateStrongPassword(int length) {
  final random = Random.secure();
  const lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  const upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  const specialCharacters = r'!@#$%^&*()_+-=[]{}|;:,.<>?';

  final characters =
      '$lowerCaseLetters$upperCaseLetters$numbers$specialCharacters';

  // generateStrongPassword
  return List.generate(
      length, (index) => characters[random.nextInt(characters.length)]).join();
}

bool validateNsec(String nsecBase64) {
  try {
    if (nsecBase64.length != 63) {
      return false;
    }
    if (!nsecBase64.startsWith('nsec')) {
      return false;
    }
    return true;
  } catch (e) {
    return false;
  }
}
