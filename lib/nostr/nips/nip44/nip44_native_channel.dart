import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../../../utils/logger.dart';

class NIP44NativeChannel {
  static const MethodChannel _channel = MethodChannel('aegis_nostr');

  static final NIP44NativeChannel _instance = NIP44NativeChannel._internal();
  factory NIP44NativeChannel() => _instance;
  NIP44NativeChannel._internal();


  Future<String?> nativeEncrypt(String plaintext, String privateKey, String publicKey) async {
    try {
      final result = await _channel.invokeMethod('nip44Encrypt', {
        'plaintext': plaintext,
        'privateKey': privateKey,
        'publicKey': publicKey,
      });

      return result as String?;
    } on PlatformException catch (e) {
      AegisLogger.error('Native encrypt error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      AegisLogger.error('Native encrypt unexpected error', e);
      return null;
    }
  }


  Future<String?> nativeDecrypt(String ciphertext, String privateKey, String publicKey) async {
    try {
      final result = await _channel.invokeMethod('nip44Decrypt', {
        'ciphertext': ciphertext,
        'privateKey': privateKey,
        'publicKey': publicKey,
      });

      return result as String?;
    } on PlatformException catch (e) {
      AegisLogger.error('Native decrypt error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      AegisLogger.error('Native decrypt unexpected error', e);
      return null;
    }
  }


  Future<bool> isNativeSupported() async {
    try {
      await _channel.invokeMethod('nip44Encrypt', {
        'plaintext': 'test',
        'privateKey': '0' * 64,
        'publicKey': '0' * 64,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}