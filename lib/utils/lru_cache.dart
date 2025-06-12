import 'dart:collection';

class CacheEntry<T> {
  final T value;
  final DateTime createdAt;
  final Duration? ttl;

  CacheEntry(this.value, this.createdAt, this.ttl);

  bool get isExpired {
    if (ttl == null) return false;
    return DateTime.now().difference(createdAt) > ttl!;
  }
}

class LRUCache<K, V> {
  final int _maxSize;
  final Duration _defaultTtl;
  final bool _trackHitRate;
  final LinkedHashMap<K, CacheEntry<V>> _cache = LinkedHashMap();

  int _hits = 0;
  int _misses = 0;

  LRUCache({
    required int maxSize,
    Duration defaultTtl = const Duration(minutes: 30),
    bool trackHitRate = false,
  })  : _maxSize = maxSize,
        _defaultTtl = defaultTtl,
        _trackHitRate = trackHitRate;

  V? get(K key) {
    final entry = _cache.remove(key);
    if (entry == null) {
      if (_trackHitRate) _misses++;
      return null;
    }

    if (entry.isExpired) {
      if (_trackHitRate) _misses++;
      return null;
    }

    _cache[key] = entry;
    if (_trackHitRate) _hits++;
    return entry.value;
  }

  void put(K key, V value, {Duration? ttl}) {
    _cache.remove(key);

    if (_cache.length >= _maxSize) {
      _cache.remove(_cache.keys.first);
    }

    _cache[key] = CacheEntry(value, DateTime.now(), ttl ?? _defaultTtl);
  }

  void remove(K key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  int get length => _cache.length;

  bool containsKey(K key) {
    final entry = _cache[key];
    if (entry?.isExpired == true) {
      _cache.remove(key);
      return false;
    }
    return entry != null;
  }

  int cleanup() {
    final expiredKeys = <K>[];
    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        expiredKeys.add(entry.key);
      }
    }
    for (final key in expiredKeys) {
      _cache.remove(key);
    }
    return expiredKeys.length;
  }

  Map<K, V> getAll() {
    final result = <K, V>{};
    final expiredKeys = <K>[];

    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        expiredKeys.add(entry.key);
      } else {
        result[entry.key] = entry.value.value;
      }
    }

    for (final key in expiredKeys) {
      _cache.remove(key);
    }

    return result;
  }

  CacheStats getStats() {
    int expired = 0;
    int valid = 0;

    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        expired++;
      } else {
        valid++;
      }
    }

    final hitRate = _trackHitRate && (_hits + _misses) > 0
        ? _hits / (_hits + _misses)
        : 0.0;

    return CacheStats(
      totalEntries: _cache.length,
      validEntries: valid,
      expiredEntries: expired,
      maxSize: _maxSize,
      hitRate: hitRate,
      hits: _trackHitRate ? _hits : null,
      misses: _trackHitRate ? _misses : null,
    );
  }

  bool get isEmpty {
    return getAll().isEmpty;
  }

  int get validLength {
    int count = 0;
    for (final entry in _cache.entries) {
      if (!entry.value.isExpired) {
        count++;
      }
    }
    return count;
  }

  void resetStats() {
    if (_trackHitRate) {
      _hits = 0;
      _misses = 0;
    }
  }

  void enableAutoCleanup(Duration interval) {

  }
}

class CacheStats {
  final int totalEntries;
  final int validEntries;
  final int expiredEntries;
  final int maxSize;
  final double hitRate;
  final int? hits;
  final int? misses;

  CacheStats({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
    required this.maxSize,
    required this.hitRate,
    this.hits,
    this.misses,
  });

  double get utilization => totalEntries / maxSize;

  bool get isFull => totalEntries >= maxSize;

  bool get hasExpiredEntries => expiredEntries > 0;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('CacheStats{');
    buffer.write('total: $totalEntries, ');
    buffer.write('valid: $validEntries, ');
    buffer.write('expired: $expiredEntries, ');
    buffer.write('max: $maxSize, ');
    buffer.write('utilization: ${(utilization * 100).toStringAsFixed(1)}%, ');
    buffer.write('hitRate: ${(hitRate * 100).toStringAsFixed(1)}%');

    if (hits != null && misses != null) {
      buffer.write(', hits: $hits, misses: $misses');
    }

    buffer.write('}');
    return buffer.toString();
  }
}
