import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/ecc/ecdh.dart';

import '../nostr/nips/nip04/nip04.dart';
import '../nostr/nips/nip44/nip44_v2.dart';

class AegisIsolate {
  static dynamic parseJson(String message) => jsonDecode(message);
  static String encodeJson(Object data) => jsonEncode(data);

  static Future<String?> nip04DecryptIsolate(Map args) async {
    final ciphertext = args['ciphertext'] as String;
    final clientPub = args['clientPubkey'] as String;
    final agreement = args['agreement'] as ECDHBasicAgreement;
    return NIP04.decrypt(ciphertext, agreement, clientPub);
  }

  static Future<String?> nip04EncryptIsolate(Map args) async {
    final plaintext = args['plaintext'] as String;
    final clientPub = args['clientPubkey'] as String;
    final agreement = args['agreement'] as ECDHBasicAgreement;
    return NIP04.encrypt(plaintext, agreement, clientPub);
  }

  static Future<String?> nip44DecryptIsolate(Map args) async {
    final ciphertext = args['ciphertext'] as String;
    final convKey = args['convKey'] as Uint8List;

    return await NIP44V2.decrypt(ciphertext, convKey);
  }

  static Future<String?> nip44EncryptIsolate(Map args) async {
    final plaintext = args['plaintext'] as String;
    final convKey = args['convKey'] as Uint8List;
    return await NIP44V2.encrypt(plaintext, convKey);
  }
}
