import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;
import '../../../utils/logger.dart';
import '../../../utils/account.dart';

/// NIP-55 Android Signer Intent Handler
/// Handles communication between Android signer and Nostr clients
class NIP55Handler {
  static const MethodChannel _channel = MethodChannel('com.aegis.app/nip55');
  
  /// Initialize NIP-55 handler
  static Future<void> initialize() async {
    try {
      _channel.setMethodCallHandler(_handleMethodCall);
      AegisLogger.info('✅ NIP-55 MethodChannel handler set successfully');
    } catch (e) {
      AegisLogger.error('❌ Failed to set NIP-55 MethodChannel handler', e);
    }
  }
  
  /// Handle method calls from Android
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    AegisLogger.info('📱 NIP-55 MethodChannel received: ${call.method}');
    AegisLogger.info('📱 NIP-55 MethodChannel arguments: ${call.arguments}');
    
    switch (call.method) {
      case 'processNIP55Request':
        return await _processNIP55Request(call.arguments);
      default:
        AegisLogger.error('❌ NIP-55 MethodChannel unknown method: ${call.method}');
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  }
  
  /// Process NIP-55 request from Android Intent
  static Future<Map<String, dynamic>> _processNIP55Request(Map<dynamic, dynamic> args) async {
    try {
      final type = args['type'] as String? ?? 'get_public_key';
      final content = args['content'] as String? ?? '';
      final id = args['id'] as String?;
      final currentUser = args['current_user'] as String?;
      final pubkey = args['pubkey'] as String?;
      final callbackUrl = args['callbackUrl'] as String?;
      final compressionType = args['compressionType'] as String?;
      final returnType = args['returnType'] as String?;
      
      AegisLogger.info('Processing NIP-55 request: type=$type, id=$id');
      AegisLogger.info('Content: $content');
      AegisLogger.info('Callback: $callbackUrl, Compression: $compressionType, Return: $returnType');
      AegisLogger.info('Full NIP-55 args: $args');
      
      switch (type) {
        case 'get_public_key':
          return await _handleGetPublicKey(args);
        case 'sign_event':
          return await _handleSignEvent(content, id, currentUser);
        case 'nip04_encrypt':
          return await _handleNIP04Encrypt(content, id, currentUser, pubkey);
        case 'nip04_decrypt':
          return await _handleNIP04Decrypt(content, id, currentUser, pubkey);
        case 'nip44_encrypt':
          return await _handleNIP44Encrypt(content, id, currentUser, pubkey);
        case 'nip44_decrypt':
          return await _handleNIP44Decrypt(content, id, currentUser, pubkey);
        case 'decrypt_zap_event':
          return await _handleDecryptZapEvent(content, id, currentUser);
        default:
          throw Exception('Unknown request type: $type');
      }
    } catch (e) {
      AegisLogger.error('NIP-55 request failed', e);
      return {
        'error': e.toString(),
        'id': args['id'],
      };
    }
  }
  
  /// Handle get_public_key request
  static Future<Map<String, dynamic>> _handleGetPublicKey(Map<dynamic, dynamic> args) async {
    try {
      // Get current user's private key
      final currentPrivkey = Account.sharedInstance.currentPrivkey;
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      // Get public key from current user's private key
      final publicKey = rust_api.getPublicKeyFromPrivate(privateKey: currentPrivkey);
      
      AegisLogger.info('Generated public key: $publicKey');
      
      return {
        'type': 'get_public_key',
        'result': publicKey,
        'package': 'com.aegis.app',
      };
    } catch (e) {
      AegisLogger.error('Failed to generate public key', e);
      return {
        'error': e.toString(),
        'package': 'com.aegis.app',
      };
    }
  }
  
  /// Handle sign_event request
  static Future<Map<String, dynamic>> _handleSignEvent(String eventJson, String? id, String? currentUser) async {
    try {
      // Get current user's private key
      final currentPrivkey = Account.sharedInstance.currentPrivkey;
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      // Sign the event using Rust
      final signedEventJson = rust_api.signEvent(
        eventJson: eventJson,
        privateKey: currentPrivkey,
      );
      
      return {
        'type': 'sign_event',
        'signature': json.decode(signedEventJson)['sig'],
        'id': id,
        'event': signedEventJson,
      };
    } catch (e) {
      throw Exception('Failed to sign event: $e');
    }
  }
  
  /// Handle NIP-04 encryption request
  static Future<Map<String, dynamic>> _handleNIP04Encrypt(String plaintext, String? id, String? currentUser, String? pubkey) async {
    try {
      // Get current user's private key
      final currentPrivkey = Account.sharedInstance.currentPrivkey;
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final encrypted = rust_api.nip04Encrypt(
        plaintext: plaintext,
        publicKey: pubkey!,
        privateKey: currentPrivkey,
      );
      
      return {
        'result': encrypted,
        'id': id,
      };
    } catch (e) {
      throw Exception('Failed to encrypt with NIP-04: $e');
    }
  }
  
  /// Handle NIP-04 decryption request
  static Future<Map<String, dynamic>> _handleNIP04Decrypt(String ciphertext, String? id, String? currentUser, String? pubkey) async {
    try {
      // Get current user's private key
      final currentPrivkey = Account.sharedInstance.currentPrivkey;
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final decrypted = rust_api.nip04Decrypt(
        ciphertext: ciphertext,
        publicKey: pubkey!,
        privateKey: currentPrivkey,
      );
      
      return {
        'result': decrypted,
        'id': id,
      };
    } catch (e) {
      throw Exception('Failed to decrypt with NIP-04: $e');
    }
  }
  
  /// Handle NIP-44 encryption request
  static Future<Map<String, dynamic>> _handleNIP44Encrypt(String plaintext, String? id, String? currentUser, String? pubkey) async {
    try {
      // Get current user's private key
      final currentPrivkey = Account.sharedInstance.currentPrivkey;
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final encrypted = rust_api.nip44Encrypt(
        plaintext: plaintext,
        publicKey: pubkey!,
        privateKey: currentPrivkey,
      );
      
      return {
        'signature': encrypted,
        'id': id,
      };
    } catch (e) {
      throw Exception('Failed to encrypt with NIP-44: $e');
    }
  }
  
  /// Handle NIP-44 decryption request
  static Future<Map<String, dynamic>> _handleNIP44Decrypt(String ciphertext, String? id, String? currentUser, String? pubkey) async {
    try {
      // Get current user's private key
      final currentPrivkey = Account.sharedInstance.currentPrivkey;
      if (currentPrivkey.isEmpty) {
        throw Exception('No current user private key available');
      }
      
      final decrypted = rust_api.nip44Decrypt(
        ciphertext: ciphertext,
        publicKey: pubkey!,
        privateKey: currentPrivkey,
      );
      
      return {
        'result': decrypted,
        'id': id,
      };
    } catch (e) {
      throw Exception('Failed to decrypt with NIP-44: $e');
    }
  }
  
  /// Handle decrypt_zap_event request
  static Future<Map<String, dynamic>> _handleDecryptZapEvent(String eventJson, String? id, String? currentUser) async {
    try {
      // This would decrypt a zap event
      // Implementation depends on your zap event structure
      return {
        'result': eventJson, // Placeholder
        'id': id,
      };
    } catch (e) {
      throw Exception('Failed to decrypt zap event: $e');
    }
  }
}
