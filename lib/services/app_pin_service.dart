import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores a PIN hash + salt in secure storage. Used to gate sensitive in-app actions.
class AppPinService {
  AppPinService._();
  static final AppPinService instance = AppPinService._();

  static const _storage = FlutterSecureStorage();
  static const _kSalt = 'aegis_app_pin_salt_v1';
  static const _kHash = 'aegis_app_pin_hash_v1';

  /// 4–6 digits (device-local app PIN).
  static bool isValidPinFormat(String pin) {
    return RegExp(r'^\d{4,6}$').hasMatch(pin.trim());
  }

  String _hash(String pin, String salt) {
    final bytes = utf8.encode('aegis.app.pin.v1|$salt|${pin.trim()}');
    final digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }

  Future<bool> get isPinConfigured async {
    final h = await _storage.read(key: _kHash);
    return h != null && h.isNotEmpty;
  }

  Future<bool> verify(String pin) async {
    if (!isValidPinFormat(pin)) return false;
    final salt = await _storage.read(key: _kSalt);
    final stored = await _storage.read(key: _kHash);
    if (salt == null || stored == null || salt.isEmpty) return false;
    return _hash(pin, salt) == stored;
  }

  Future<void> setPin(String pin) async {
    if (!isValidPinFormat(pin)) {
      throw ArgumentError('PIN must be 4–6 digits');
    }
    final salt = base64Encode(
      List<int>.generate(16, (_) => Random.secure().nextInt(256)),
    );
    final hash = _hash(pin, salt);
    await _storage.write(key: _kSalt, value: salt);
    await _storage.write(key: _kHash, value: hash);
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _kSalt);
    await _storage.delete(key: _kHash);
  }
}
