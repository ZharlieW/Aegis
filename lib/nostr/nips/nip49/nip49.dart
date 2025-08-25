import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:bech32/bech32.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/key_derivators/scrypt.dart' as pc;
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:unorm_dart/unorm_dart.dart' as unorm;

export 'nip49_signer.dart';
export 'nip49_utils.dart';

class NIP49 {
  static const int version = 0x02;
  static const String hrp = 'ncryptsec';
  static const int defaultLogN = 16;
  static const int minLogN = 12;
  static const int maxLogN = 22;

  static String normalizePassword(String password) {
    return unorm.nfkc(password);
  }

  static Future<Uint8List> deriveKey(
    String password,
    Uint8List salt,
    int logN,
  ) async {
    if (logN < minLogN || logN > maxLogN) {
      throw ArgumentError('logN must be between $minLogN and $maxLogN');
    }

    final normalizedPassword = normalizePassword(password);
    final passwordBytes = utf8.encode(normalizedPassword);
    final n = 1 << logN;
    const r = 8;
    const p = 1;
    const dkLen = 32;

    final scrypt = pc.Scrypt();
    final params = pointycastle.ScryptParameters(n, r, p, dkLen, salt);
    scrypt.init(params);

    final derivedKey = Uint8List(dkLen);
    scrypt.deriveKey(Uint8List.fromList(passwordBytes), 0, derivedKey, 0);

    return derivedKey;
  }

  static Future<String> encrypt(
    String privateKeyHex,
    String password, {
    int logN = defaultLogN,
    int keySecurityByte = 0x02,
  }) async {
    if (privateKeyHex.length != 64) {
      throw ArgumentError('Private key must be 32 bytes (64 hex characters)');
    }

    final privateKeyBytes = Uint8List.fromList(hex.decode(privateKeyHex));
    final random = Random.secure();
    
    final salt = Uint8List.fromList(
      List.generate(16, (_) => random.nextInt(256)),
    );
    final nonce = Uint8List.fromList(
      List.generate(24, (_) => random.nextInt(256)),
    );

    final key = await deriveKey(password, salt, logN);
    final algorithm = Xchacha20.poly1305Aead();
    final secretKey = SecretKey(key);
    final aad = Uint8List.fromList([keySecurityByte]);

    final secretBox = await algorithm.encrypt(
      privateKeyBytes,
      secretKey: secretKey,
      nonce: nonce,
      aad: aad,
    );

    final cipherText = secretBox.cipherText;
    final macBytes = secretBox.mac.bytes;

    if (cipherText.length != 32) {
      throw StateError('Unexpected ciphertext length: ${cipherText.length}');
    }
    if (macBytes.length != 16) {
      throw StateError('Unexpected MAC length: ${macBytes.length}');
    }

    final encryptedData = Uint8List(91);
    int offset = 0;
    
    encryptedData[offset++] = version;
    encryptedData[offset++] = logN;
    encryptedData.setRange(offset, offset + 16, salt);
    offset += 16;
    encryptedData.setRange(offset, offset + 24, nonce);
    offset += 24;
    encryptedData[offset++] = keySecurityByte;
    encryptedData.setRange(offset, offset + 32, cipherText);
    offset += 32;
    encryptedData.setRange(offset, offset + 16, macBytes);

    final bech32Data = Bech32(hrp, _convertBits(encryptedData, 8, 5, true));
    final encoder = Bech32Encoder();
    return encoder.convert(bech32Data, 500);
  }

  static Future<String> decrypt(String encryptedKey, String password) async {
    final decoder = Bech32Decoder();
    final bech32Data = decoder.convert(encryptedKey, 500);

    if (bech32Data.hrp != hrp) {
      throw ArgumentError('Invalid HRP, expected $hrp');
    }

    final data = Uint8List.fromList(_convertBits(bech32Data.data, 5, 8, false));

    if (data.length < 89) {
      throw ArgumentError('Invalid encrypted key length: ${data.length}');
    }

    int offset = 0;
    final version = data[offset++];
    if (version != 0x02) {
      throw ArgumentError('Unsupported version: $version');
    }

    final logN = data[offset++];
    if (logN < minLogN || logN > maxLogN) {
      throw ArgumentError('Invalid logN: $logN');
    }

    final salt = data.sublist(offset, offset + 16);
    offset += 16;
    final nonce = data.sublist(offset, offset + 24);
    offset += 24;
    final keySecurityByte = data[offset++];
    final cipherText = data.sublist(offset, offset + 32);
    offset += 32;
    final mac = data.sublist(offset, offset + 16);

    final key = await deriveKey(password, salt, logN);
    final algorithm = Xchacha20.poly1305Aead();
    final secretKey = SecretKey(key);
    final aad = Uint8List.fromList([keySecurityByte]);
    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(mac));

    try {
      final decrypted = await algorithm.decrypt(
        secretBox,
        secretKey: secretKey,
        aad: aad,
      );
      return hex.encode(decrypted);
    } catch (e) {
      throw ArgumentError(
        'Failed to decrypt: invalid password or corrupted data',
      );
    }
  }

  static List<int> _convertBits(
    List<int> data,
    int fromBits,
    int toBits,
    bool pad,
  ) {
    var acc = 0;
    var bits = 0;
    final ret = <int>[];
    final maxv = (1 << toBits) - 1;
    final maxAcc = (1 << (fromBits + toBits - 1)) - 1;

    for (var value in data) {
      if (value < 0 || (value >> fromBits) != 0) {
        throw ArgumentError('Invalid data for conversion');
      }
      acc = ((acc << fromBits) | value) & maxAcc;
      bits += fromBits;
      while (bits >= toBits) {
        bits -= toBits;
        ret.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        ret.add((acc << (toBits - bits)) & maxv);
      }
    } else if (bits >= fromBits || ((acc << (toBits - bits)) & maxv) != 0) {
      throw ArgumentError('Invalid padding in convertBits');
    }

    return ret;
  }
}