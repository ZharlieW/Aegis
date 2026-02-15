import 'package:flutter/foundation.dart';

/// Abstraction for the Nostr relay service. Allows swapping implementation for tests.
abstract class IRelayService {
  ValueNotifier<bool> get serverNotifier;
  String get relayUrl;
  String get port;
  DateTime? get sessionStartTime;
  String get preferredPort;
  Future<void> setPreferredPort(String port);

  Future<void> start({String? host, String? port, int maxRetries = 3});
  Future<void> stop();
  Future<bool> isRunning();
  Future<String?> getUrl();
  void recordSessionStartIfUnset();
  void clearSessionStart();
}
