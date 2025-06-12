import 'dart:typed_data';
import 'package:flutter/services.dart';

class NIP44NativeChannel {
  static const MethodChannel _channel = MethodChannel('aegis_nostr');
  
  static final NIP44NativeChannel _instance = NIP44NativeChannel._internal();
  factory NIP44NativeChannel() => _instance;
  NIP44NativeChannel._internal();
  

  Future<String?> nativeEncrypt(String plaintext, Uint8List conversationKey) async {
    try {
  
      final conversationKeyHex = conversationKey.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
      
      final result = await _channel.invokeMethod('nip44Encrypt', {
        'plaintext': plaintext,
        'conversationKey': conversationKeyHex,
      });
      
      return result as String?;
    } on PlatformException catch (e) {
      print('Native encrypt error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Native encrypt unexpected error: $e');
      return null;
    }
  }
  
 
  Future<String?> nativeDecrypt(String payload, Uint8List conversationKey) async {
    try {
   
      final conversationKeyHex = conversationKey.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
      
      final result = await _channel.invokeMethod('nip44Decrypt', {
        'payload': payload,
        'conversationKey': conversationKeyHex,
      });
      
      return result as String?;
    } on PlatformException catch (e) {
      print('Native decrypt error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Native decrypt unexpected error: $e');
      return null;
    }
  }
  

  Future<bool> isNativeSupported() async {
    try {
   
      await _channel.invokeMethod('nip44Encrypt', {
        'plaintext': 'test',
        'conversationKey': '0' * 64, 
      });
      return true;
    } catch (e) {
      return false;
    }
  }
} 