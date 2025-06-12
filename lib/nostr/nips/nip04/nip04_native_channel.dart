import 'package:flutter/services.dart';
import '../../../utils/logger.dart';

class NIP04NativeChannel {
  static const MethodChannel _channel = MethodChannel('aegis_nostr');
  
  static final NIP04NativeChannel _instance = NIP04NativeChannel._internal();
  factory NIP04NativeChannel() => _instance;
  NIP04NativeChannel._internal();
  
  Future<String?> nativeNip04Encrypt(String plaintext, String privateKey, String publicKey) async {
    try {
      final result = await _channel.invokeMethod('nip04Encrypt', {
        'plaintext': plaintext,
        'privateKey': privateKey,
        'publicKey': publicKey,
      });
      
      return result as String?;
    } on PlatformException catch (e) {
      AegisLogger.error('Native NIP04 encrypt error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      AegisLogger.error('Native NIP04 encrypt unexpected error', e);
      return null;
    }
  }
  
  Future<String?> nativeNip04Decrypt(String ciphertext, String privateKey, String publicKey) async {
    try {
      final result = await _channel.invokeMethod('nip04Decrypt', {
        'ciphertext': ciphertext,
        'privateKey': privateKey,
        'publicKey': publicKey,
      });
      
      return result as String?;
    } on PlatformException catch (e) {
      AegisLogger.error('Native NIP04 decrypt error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      AegisLogger.error('Native NIP04 decrypt unexpected error', e);
      return null;
    }
  }
  
  Future<bool> isNativeSupported() async {
    try {
      await _channel.invokeMethod('nip04Encrypt', {
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