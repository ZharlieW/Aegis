import 'dart:collection';

import 'package:aegis/utils/logger.dart';

class RequestCaseTimer {
  static final Map<String, List<int>> _records = HashMap<String, List<int>>();

  static void record(String method, Stopwatch stopwatch) {
    if (stopwatch.isRunning) stopwatch.stop();
    final elapsed = stopwatch.elapsedMilliseconds;
    _records.putIfAbsent(method, () => []).add(elapsed);

    final logLine =
        "_processRemoteRequest -> $method 耗时: ${elapsed}ms (平均: ${_average(method).toStringAsFixed(1)}ms)";

    AegisLogger.debug(logLine);
    print(logLine);
  }

  static double _average(String method) {
    final list = _records[method];
    if (list == null || list.isEmpty) return 0;
    final total = list.reduce((a, b) => a + b);
    return total / list.length;
  }

  static Map<String, int> latestCost() {
    final Map<String, int> map = {};
    _records.forEach((key, value) {
      if (value.isNotEmpty) map[key] = value.last;
    });
    return map;
  }

  static void reset() => _records.clear();
} 