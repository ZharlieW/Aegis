import 'dart:convert';

/// Per-permission usage for the application permissions screen (NIP-46 method keys).
class MethodUsageEntry {
  final int lastUsedMs;
  final int count;

  const MethodUsageEntry({
    required this.lastUsedMs,
    required this.count,
  });
}

/// Parse/update JSON stored on [ClientAuthDBISAR.methodUsageStatsJson].
class MethodUsageStats {
  MethodUsageStats._(this._byKey);

  final Map<String, MethodUsageEntry> _byKey;

  static MethodUsageStats parse(String raw) {
    if (raw.isEmpty) return MethodUsageStats._({});
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return MethodUsageStats._({});
      final out = <String, MethodUsageEntry>{};
      for (final e in decoded.entries) {
        final k = e.key;
        if (k is! String) continue;
        final v = e.value;
        if (v is! Map) continue;
        final last = v['lastUsedMs'];
        final c = v['count'];
        final lastMs = last is int
            ? last
            : last is num
                ? last.toInt()
                : 0;
        final count = c is int
            ? c
            : c is num
                ? c.toInt()
                : 0;
        if (count > 0 || lastMs > 0) {
          out[k] = MethodUsageEntry(lastUsedMs: lastMs, count: count);
        }
      }
      return MethodUsageStats._(out);
    } catch (_) {
      return MethodUsageStats._({});
    }
  }

  String toJsonString() {
    if (_byKey.isEmpty) return '{}';
    final map = <String, Map<String, int>>{};
    for (final e in _byKey.entries) {
      map[e.key] = {
        'lastUsedMs': e.value.lastUsedMs,
        'count': e.value.count,
      };
    }
    return jsonEncode(map);
  }

  MethodUsageEntry? operator [](String methodKey) => _byKey[methodKey];

  void increment(String methodKey) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final prev = _byKey[methodKey];
    _byKey[methodKey] = MethodUsageEntry(
      lastUsedMs: now,
      count: (prev?.count ?? 0) + 1,
    );
  }

  /// Returns updated JSON after incrementing usage for [methodKey].
  static String incrementJson(String raw, String methodKey) {
    if (methodKey.isEmpty) return raw.isEmpty ? '{}' : raw;
    final stats = parse(raw);
    stats.increment(methodKey);
    return stats.toJsonString();
  }
}

/// Fixed display order: get_public_key → sign_event* → nip04* → nip44* → others (A–Z).
void sortPermissionMethodsInPlace(List<String> methods) {
  methods.sort(comparePermissionMethods);
}

int comparePermissionMethods(String a, String b) {
  final ca = _category(a);
  final cb = _category(b);
  if (ca != cb) return ca.compareTo(cb);
  switch (ca) {
    case 1:
      return _compareSignEvent(a, b);
    case 2:
      return _compareNip04(a, b);
    case 3:
      return _compareNip44(a, b);
    default:
      return a.compareTo(b);
  }
}

int _category(String m) {
  if (m == 'get_public_key') return 0;
  if (m.startsWith('sign_event')) return 1;
  if (m.startsWith('nip04_')) return 2;
  if (m.startsWith('nip44_')) return 3;
  return 4;
}

int _compareSignEvent(String a, String b) {
  final ka = _signEventSortKey(a);
  final kb = _signEventSortKey(b);
  if (ka != kb) return ka.compareTo(kb);
  return a.compareTo(b);
}

/// sign_event without kind sorts before any kind; kinds sort numerically.
int _signEventSortKey(String m) {
  if (m == 'sign_event') return -1;
  if (!m.startsWith('sign_event:')) return 0;
  final rest = m.substring('sign_event:'.length);
  return int.tryParse(rest) ?? 0x7fffffff;
}

const _nip04Order = ['nip04_encrypt', 'nip04_decrypt'];
const _nip44Order = ['nip44_decrypt', 'nip44_encrypt'];

int _compareNip04(String a, String b) {
  final ia = _nip04Order.indexOf(a);
  final ib = _nip04Order.indexOf(b);
  if (ia != -1 || ib != -1) {
    if (ia == -1) return 1;
    if (ib == -1) return -1;
    if (ia != ib) return ia.compareTo(ib);
  }
  return a.compareTo(b);
}

int _compareNip44(String a, String b) {
  final ia = _nip44Order.indexOf(a);
  final ib = _nip44Order.indexOf(b);
  if (ia != -1 || ib != -1) {
    if (ia == -1) return 1;
    if (ib == -1) return -1;
    if (ia != ib) return ia.compareTo(ib);
  }
  return a.compareTo(b);
}
