import 'package:flutter/foundation.dart';
import 'package:aegis/services/app_log_service.dart';

class AegisLogger {
  static final AegisLogger _instance = AegisLogger._internal();
  factory AegisLogger() => _instance;
  AegisLogger._internal();

  static const bool _enableLogsInRelease = false;
  static const AppLogLevel _minLogLevel = AppLogLevel.info;

  static void debug(String message, [Object? error]) {
    _log(AppLogLevel.debug, '🐛', message, error);
  }

  static void info(String message, [Object? error]) {
    _log(AppLogLevel.info, 'ℹ️', message, error);
  }

  static void warning(String message, [Object? error]) {
    _log(AppLogLevel.warning, '⚠️', message, error);
  }

  static void error(String message, [Object? error]) {
    _log(AppLogLevel.error, '❌', message, error);
  }

  static void crypto(String operation, bool isNative, bool success,
      [String? details]) {
    if (!_shouldLog(AppLogLevel.info)) return;

    final nativeStr = isNative ? 'Native' : 'Flutter';
    final statusStr = success ? '✅' : '❌';
    final msg =
        '$statusStr $nativeStr $operation ${success ? 'successful' : 'failed'}';

    _log(AppLogLevel.info, '🔐', details != null ? '$msg: $details' : msg);
  }

  static void _log(AppLogLevel level, String emoji, String message,
      [Object? error]) {
    if (!_shouldLog(level)) return;

    final levelStr = level.name.toUpperCase();
    final fullMessage = '[[$levelStr] $emoji $message';
    final appSummary = error == null ? message : '$message | error: $error';
    AppLogService.instance.add(level: level, summary: appSummary);

    if (kDebugMode || _enableLogsInRelease) {
      print(fullMessage);
      if (error != null) {
        print('  └─ Error: $error');
      }
    }
  }

  static bool _shouldLog(AppLogLevel level) {
    if (kDebugMode) return true;
    if (!_enableLogsInRelease) return false;
    return level.index >= _minLogLevel.index;
  }
}
