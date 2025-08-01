import 'dart:io';
import '../nostr/nips/nip04/nip04_native_channel.dart';
import '../nostr/nips/nip44/nip44_native_channel.dart';
import 'logger.dart';

class PlatformCryptoUtils {
  static final PlatformCryptoUtils _instance = PlatformCryptoUtils._internal();
  factory PlatformCryptoUtils() => _instance;
  PlatformCryptoUtils._internal();

  bool? _isNativeSupported;
  final NIP04NativeChannel _nip04Channel = NIP04NativeChannel();
  final NIP44NativeChannel _nip44Channel = NIP44NativeChannel();

  /// Check if native implementation is supported
  Future<bool> isNativeSupported() async {
    if (_isNativeSupported != null) {
      return _isNativeSupported!;
    }

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Test NIP-04 support
        final nip04Supported = await _nip04Channel.isNativeSupported();
        // Test NIP-44 support
        final nip44Supported = await _nip44Channel.isNativeSupported();
        
        _isNativeSupported = nip04Supported && nip44Supported;
        AegisLogger.info('Native crypto support: $_isNativeSupported (NIP04: $nip04Supported, NIP44: $nip44Supported)');
        return _isNativeSupported!;
      } else {
        _isNativeSupported = false;
        return false;
      }
    } catch (e) {
      AegisLogger.error('Failed to check native support', e);
      _isNativeSupported = false;
      return false;
    }
  }

  /// NIP-04 encryption
  Future<String?> encryptNIP04(String plaintext, String privateKey, String publicKey) async {
    try {
      if (await isNativeSupported()) {
        AegisLogger.info('Using native NIP-04 encryption');
        return await _nip04Channel.nativeNip04Encrypt(plaintext, privateKey, publicKey);
      } else {
        AegisLogger.info('Native not supported, falling back to Dart implementation');
        // TODO: Implement Dart version of NIP-04 encryption
        throw UnimplementedError('Dart NIP-04 implementation not yet available');
      }
    } catch (e) {
      AegisLogger.error('NIP-04 encryption failed', e);
      return null;
    }
  }

  /// NIP-04 decryption
  Future<String?> decryptNIP04(String ciphertext, String privateKey, String publicKey) async {
    try {
      if (await isNativeSupported()) {
        AegisLogger.info('Using native NIP-04 decryption');
        return await _nip04Channel.nativeNip04Decrypt(ciphertext, privateKey, publicKey);
      } else {
        AegisLogger.info('Native not supported, falling back to Dart implementation');
        // TODO: Implement Dart version of NIP-04 decryption
        throw UnimplementedError('Dart NIP-04 implementation not yet available');
      }
    } catch (e) {
      AegisLogger.error('NIP-04 decryption failed', e);
      return null;
    }
  }

  /// NIP-44 encryption
  Future<String?> encryptNIP44(String plaintext, String privateKey, String publicKey) async {
    try {
      if (await isNativeSupported()) {
        AegisLogger.info('Using native NIP-44 encryption');
        return await _nip44Channel.nativeEncrypt(plaintext, privateKey, publicKey);
      } else {
        AegisLogger.info('Native not supported, falling back to Dart implementation');
        // TODO: Implement Dart version of NIP-44 encryption
        throw UnimplementedError('Dart NIP-44 implementation not yet available');
      }
    } catch (e) {
      AegisLogger.error('NIP-44 encryption failed', e);
      return null;
    }
  }

  /// NIP-44 decryption
  Future<String?> decryptNIP44(String ciphertext, String privateKey, String publicKey) async {
    try {
      if (await isNativeSupported()) {
        AegisLogger.info('Using native NIP-44 decryption');
        return await _nip44Channel.nativeDecrypt(ciphertext, privateKey, publicKey);
      } else {
        AegisLogger.info('Native not supported, falling back to Dart implementation');
        // TODO: Implement Dart version of NIP-44 decryption
        throw UnimplementedError('Dart NIP-44 implementation not yet available');
      }
    } catch (e) {
      AegisLogger.error('NIP-44 decryption failed', e);
      return null;
    }
  }

  /// Detect encryption type
  String detectEncryptionType(String content) {
    if (content.contains('?iv=')) {
      return 'NIP04';
    } else {
      return 'NIP44';
    }
  }

  /// Auto decrypt (choose decryption method based on content format)
  Future<String?> autoDecrypt(String ciphertext, String privateKey, String publicKey) async {
    final encryptionType = detectEncryptionType(ciphertext);
    AegisLogger.info('Auto-detected encryption type: $encryptionType');
    
    if (encryptionType == 'NIP04') {
      return await decryptNIP04(ciphertext, privateKey, publicKey);
    } else {
      return await decryptNIP44(ciphertext, privateKey, publicKey);
    }
  }

  /// Sign rumor event
  Future<String?> signRumorEvent(String rumorJsonString, String privateKey) async {
    try {
      if (await isNativeSupported()) {
        AegisLogger.info('Using native rumor event signing');
        return await _nip44Channel.nativeSignRumorEvent(rumorJsonString, privateKey);
      } else {
        AegisLogger.info('Native not supported, falling back to Dart implementation');
        // TODO: Implement Dart version of signing
        throw UnimplementedError('Dart rumor signing implementation not yet available');
      }
    } catch (e) {
      AegisLogger.error('Rumor event signing failed', e);
      return null;
    }
  }
} 