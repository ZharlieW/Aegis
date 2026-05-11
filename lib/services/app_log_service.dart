import 'dart:collection';

enum AppLogLevel { debug, info, warning, error }

enum AppLogSource { nip55, nip46, browser, relay, general }

class AppLogEntry {
  AppLogEntry({
    required this.timestamp,
    required this.level,
    required this.summary,
    this.source = AppLogSource.general,
  });

  final DateTime timestamp;
  final AppLogLevel level;
  final String summary;
  final AppLogSource source;
}

/// Thin in-memory log store for UI display.
class AppLogService {
  AppLogService._internal();
  static final AppLogService instance = AppLogService._internal();

  static const int _maxEntries = 500;
  final List<AppLogEntry> _entries = <AppLogEntry>[];

  void add({
    required AppLogLevel level,
    required String summary,
    AppLogSource source = AppLogSource.general,
  }) {
    _entries.insert(
      0,
      AppLogEntry(
        timestamp: DateTime.now(),
        level: level,
        summary: summary,
        source: source,
      ),
    );
    if (_entries.length > _maxEntries) {
      _entries.removeRange(_maxEntries, _entries.length);
    }
  }

  UnmodifiableListView<AppLogEntry> getAll() {
    return UnmodifiableListView<AppLogEntry>(_entries);
  }

  void clear() {
    _entries.clear();
  }
}
