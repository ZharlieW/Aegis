import 'package:shared_preferences/shared_preferences.dart';

class BrowserHistoryStore {
  BrowserHistoryStore._();

  static const String storageKey = 'browser_recent_urls';
  static const int maxEntries = 20;

  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(storageKey) ?? const <String>[];
  }

  static Future<void> add(String rawUrl) async {
    final url = _normalizeUrl(rawUrl);
    if (url == null) return;

    final existing = await load();
    final next = <String>[
      url,
      ...existing.where((entry) => entry != url),
    ];
    final capped = next.take(maxEntries).toList(growable: false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(storageKey, capped);
  }

  static Future<void> remove(String rawUrl) async {
    final url = _normalizeUrl(rawUrl) ?? rawUrl.trim();
    final existing = await load();
    final next =
        existing.where((entry) => entry != url).toList(growable: false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(storageKey, next);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }

  static String? _normalizeUrl(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.host.isEmpty) return null;
    if (uri.scheme != 'https' && uri.scheme != 'http') return null;

    return uri.removeFragment().toString();
  }
}
