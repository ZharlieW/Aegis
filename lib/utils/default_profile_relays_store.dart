import 'dart:convert';

import 'package:aegis/utils/local_storage.dart';

/// User-editable default profile relay URLs (kind-10002 style list), device-local.
class DefaultProfileRelaysStore {
  DefaultProfileRelaysStore._();
  static const String storageKey = 'default_profile_relays_v1';

  static String _normalizeDedupeKey(String url) {
    var s = url.trim();
    while (s.length > 1 && s.endsWith('/')) {
      s = s.substring(0, s.length - 1);
    }
    return s.toLowerCase();
  }

  /// `wss://` / `ws://` with non-empty host.
  static bool isValidRelayUrl(String raw) {
    final u = raw.trim();
    if (!u.startsWith('ws://') && !u.startsWith('wss://')) return false;
    final uri = Uri.tryParse(u);
    return uri != null && uri.host.isNotEmpty;
  }

  static List<String> dedupeAndTrim(Iterable<String> urls) {
    final seen = <String>{};
    final out = <String>[];
    for (final raw in urls) {
      final t = raw.trim();
      if (t.isEmpty) continue;
      final key = _normalizeDedupeKey(t);
      if (seen.contains(key)) continue;
      seen.add(key);
      out.add(t);
    }
    return out;
  }

  static Future<List<String>> load() async {
    await LocalStorage.init();
    try {
      final v = LocalStorage.get(storageKey);
      if (v == null) return [];
      if (v is List) {
        return dedupeAndTrim(v.map((e) => e.toString()));
      }
      if (v is String && v.isNotEmpty) {
        final decoded = jsonDecode(v);
        if (decoded is List) {
          return dedupeAndTrim(decoded.map((e) => e.toString()));
        }
      }
    } catch (_) {}
    return [];
  }

  static Future<void> save(List<String> urls) async {
    await LocalStorage.init();
    final clean = dedupeAndTrim(urls);
    await LocalStorage.set(storageKey, jsonEncode(clean));
  }
}
