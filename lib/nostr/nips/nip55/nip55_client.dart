import 'dart:convert';
import 'package:flutter/services.dart';

/// NIP-55 Client for calling external Android signers
/// This class can be used by other apps to communicate with Aegis
class NIP55Client {
  static const MethodChannel _channel = MethodChannel('com.aegis.app/nip55_client');
  
  /// Check if external signer is installed
  static Future<bool> isExternalSignerInstalled() async {
    try {
      final result = await _channel.invokeMethod('isExternalSignerInstalled');
      return result as bool? ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Get public key from external signer
  static Future<String?> getPublicKey({
    List<Map<String, dynamic>>? permissions,
  }) async {
    try {
      final result = await _channel.invokeMethod('getPublicKey', {
        'permissions': permissions,
      });
      return result as String?;
    } catch (e) {
      return null;
    }
  }
  
  /// Sign event using external signer
  static Future<Map<String, dynamic>?> signEvent({
    required String eventJson,
    required String signerPackage,
    String? id,
    String? currentUser,
  }) async {
    try {
      final result = await _channel.invokeMethod('signEvent', {
        'eventJson': eventJson,
        'signerPackage': signerPackage,
        'id': id,
        'currentUser': currentUser,
      });
      return result as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
  
  /// Encrypt with NIP-04 using external signer
  static Future<Map<String, dynamic>?> nip04Encrypt({
    required String plaintext,
    required String signerPackage,
    required String pubkey,
    String? id,
    String? currentUser,
  }) async {
    try {
      final result = await _channel.invokeMethod('nip04Encrypt', {
        'plaintext': plaintext,
        'signerPackage': signerPackage,
        'pubkey': pubkey,
        'id': id,
        'currentUser': currentUser,
      });
      return result as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
  
  /// Decrypt with NIP-04 using external signer
  static Future<Map<String, dynamic>?> nip04Decrypt({
    required String ciphertext,
    required String signerPackage,
    required String pubkey,
    String? id,
    String? currentUser,
  }) async {
    try {
      final result = await _channel.invokeMethod('nip04Decrypt', {
        'ciphertext': ciphertext,
        'signerPackage': signerPackage,
        'pubkey': pubkey,
        'id': id,
        'currentUser': currentUser,
      });
      return result as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
  
  /// Encrypt with NIP-44 using external signer
  static Future<Map<String, dynamic>?> nip44Encrypt({
    required String plaintext,
    required String signerPackage,
    required String pubkey,
    String? id,
    String? currentUser,
  }) async {
    try {
      final result = await _channel.invokeMethod('nip44Encrypt', {
        'plaintext': plaintext,
        'signerPackage': signerPackage,
        'pubkey': pubkey,
        'id': id,
        'currentUser': currentUser,
      });
      return result as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
  
  /// Decrypt with NIP-44 using external signer
  static Future<Map<String, dynamic>?> nip44Decrypt({
    required String ciphertext,
    required String signerPackage,
    required String pubkey,
    String? id,
    String? currentUser,
  }) async {
    try {
      final result = await _channel.invokeMethod('nip44Decrypt', {
        'ciphertext': ciphertext,
        'signerPackage': signerPackage,
        'pubkey': pubkey,
        'id': id,
        'currentUser': currentUser,
      });
      return result as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
  
  /// Decrypt zap event using external signer
  static Future<Map<String, dynamic>?> decryptZapEvent({
    required String eventJson,
    required String signerPackage,
    String? id,
    String? currentUser,
  }) async {
    try {
      final result = await _channel.invokeMethod('decryptZapEvent', {
        'eventJson': eventJson,
        'signerPackage': signerPackage,
        'id': id,
        'currentUser': currentUser,
      });
      return result as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
}
