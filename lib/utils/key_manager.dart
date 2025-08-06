import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DBKeyManager {
  static const _userPrivkeyKeyPrefix = 'aegis_user_privkey_key_';
  static const _secureStorage = FlutterSecureStorage();

  /// Get user private key encryption password from Keychain
  /// If not found, returns null (for migration from database)
  static Future<String?> getUserPrivkeyKey(String userPubkey) async {
    try {
      final key = '$_userPrivkeyKeyPrefix$userPubkey';
      final stored = await _secureStorage.read(key: key);
      if (stored != null && stored.isNotEmpty) {
        print('[Keychain] User privkey key found for: $userPubkey');
        return stored;
      }
    } on PlatformException catch (e) {
      print('[Keychain] Error reading user privkey key: $e');
    }
    return null;
  }

  /// Generate and store new user private key encryption password
  static Future<String> generateUserPrivkeyKey(String userPubkey) async {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    final password = base64Encode(bytes);
    
    final key = '$_userPrivkeyKeyPrefix$userPubkey';
    await _secureStorage.write(key: key, value: password);
    print('[Keychain] Generated new user privkey key for: $userPubkey');
    return password;
  }

  /// Migrate user private key password from database to Keychain
  /// Returns the password (either migrated or newly generated)
  static Future<String> migrateUserPrivkeyKey(String userPubkey, String? dbPassword) async {
    // First try to get from Keychain
    final existingKey = await getUserPrivkeyKey(userPubkey);
    if (existingKey != null) {
      print('[Keychain] User privkey key already exists in Keychain for: $userPubkey');
      return existingKey;
    }

    // If not in Keychain, migrate from database or generate new
    if (dbPassword != null && dbPassword.isNotEmpty) {
      // Migrate from database
      final key = '$_userPrivkeyKeyPrefix$userPubkey';
      await _secureStorage.write(key: key, value: dbPassword);
      print('[Keychain] Migrated user privkey key from database for: $userPubkey');
      return dbPassword;
    } else {
      // Generate new password
      return await generateUserPrivkeyKey(userPubkey);
    }
  }

  /// Clear user private key password from Keychain
  static Future<void> clearUserPrivkeyKey(String userPubkey) async {
    try {
      final key = '$_userPrivkeyKeyPrefix$userPubkey';
      await _secureStorage.delete(key: key);
      print('[Keychain] Cleared user privkey key for: $userPubkey');
    } on PlatformException catch (e) {
      print('[Keychain] Error clearing user privkey key: $e');
    }
  }
}