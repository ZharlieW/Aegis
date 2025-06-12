import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AegisLogger {
  static final AegisLogger _instance = AegisLogger._internal();
  factory AegisLogger() => _instance;
  AegisLogger._internal();

  static const bool _enableLogsInRelease = false;
  static const LogLevel _minLogLevel = LogLevel.info;

  static void debug(String message, [Object? error]) {
    _log(LogLevel.debug, '🐛', message, error);
  }

  static void info(String message, [Object? error]) {
    _log(LogLevel.info, 'ℹ️', message, error);
  }

  static void warning(String message, [Object? error]) {
    _log(LogLevel.warning, '⚠️', message, error);
  }

  static void error(String message, [Object? error]) {
    _log(LogLevel.error, '❌', message, error);
  }

  static void crypto(String operation, bool isNative, bool success, [String? details]) {
    if (!_shouldLog(LogLevel.info)) return;
    
    final nativeStr = isNative ? 'Native' : 'Flutter';
    final statusStr = success ? '✅' : '❌';
    final msg = '$statusStr $nativeStr $operation ${success ? 'successful' : 'failed'}';
    
    _log(LogLevel.info, '🔐', details != null ? '$msg: $details' : msg);
  }

  static void _log(LogLevel level, String emoji, String message, [Object? error]) {
    if (!_shouldLog(level)) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase();
    final fullMessage = '[$timestamp] [$levelStr] $emoji $message';
    
    if (kDebugMode || _enableLogsInRelease) {
      print(fullMessage);
      if (error != null) {
        print('  └─ Error: $error');
      }
    }
  }

  static bool _shouldLog(LogLevel level) {
    if (kDebugMode) return true;
    if (!_enableLogsInRelease) return false;
    return level.index >= _minLogLevel.index;
  }
} 