import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> set(String key, dynamic value) async {
    if (_prefs == null) await init();

    if (value is String) {
      return _prefs!.setString(key, value);
    } else if (value is int) {
      return _prefs!.setInt(key, value);
    } else if (value is double) {
      return _prefs!.setDouble(key, value);
    } else if (value is bool) {
      return _prefs!.setBool(key, value);
    } else if (value is List<String>) {
      return _prefs!.setStringList(key, value);
    } else if (value is Map) {
      String jsonString = jsonEncode(value);
      return _prefs!.setString(key, jsonString);
    } else {
      throw Exception("Unsupported type");
    }
  }

  static dynamic get(String key) {
    if (_prefs == null) throw Exception("LocalStorage not initialized");

    final value = _prefs!.getString(key);
    if (value == null) return null;

    try {
      return jsonDecode(value);
    } catch (_) {
      return value;
    }
  }

  static Future<bool> remove(String key) async {
    if (_prefs == null) await init();
    return _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    if (_prefs == null) await init();
    return _prefs!.clear();
  }

  static bool containsKey(String key) {
    if (_prefs == null) throw Exception("LocalStorage not initialized");
    return _prefs!.containsKey(key);
  }

  static Future<List<String>> getKeys() async {
    if (_prefs == null) await init();
    return _prefs!.getKeys().toList();
  }
}
