import 'package:flutter/cupertino.dart';
import 'package:nostr_rust/src/rust/api/relay.dart' as rust_relay;
import 'package:path_provider/path_provider.dart';
import 'logger.dart';

/// Nostr Relay Service using rust nostr-relay-builder
/// This replaces the old AegisWebSocketServer
class RelayService {
  static final RelayService instance = RelayService._internal();
  factory RelayService() => instance;

  RelayService._internal();

  ValueNotifier<bool> serverNotifier = ValueNotifier(false);
  String _host = '127.0.0.1';
  int _port = 8081;
  String? _relayUrl;

  /// Get the relay URL (for client connections)
  String get relayUrl {
    if (_relayUrl != null) return _relayUrl!;
    // If bound to 0.0.0.0, return localhost for local connections
    // For remote connections, users should use the device's actual IP
    final displayHost = _host == '0.0.0.0' ? '127.0.0.1' : _host;
    return 'ws://$displayHost:$_port';
  }

  /// Get the relay port
  String get port => _port.toString();

  /// Start the Nostr relay server
  Future<void> start({
    String host = '0.0.0.0',  // Bind to all interfaces (network accessible)
    String port = '8081',
  }) async {
    try {
      _host = host;
      _port = int.tryParse(port) ?? 8081;

      // Check if already running
      if (await rust_relay.isRelayRunning()) {
        // Relay is already running, get its URL
        try {
          _relayUrl = await rust_relay.getRelayUrl();
          AegisLogger.warning("⚠️ Relay is already running on $_relayUrl");
        } catch (e) {
          _relayUrl = 'ws://$_host:$_port';
          AegisLogger.warning("⚠️ Relay is already running (URL retrieval failed, using default: $_relayUrl)");
        }
        serverNotifier.value = true;
        return;
      }

      // Get database path (for future persistent storage)
      final appDir = await getApplicationSupportDirectory();
      final dbPath = '${appDir.path}/nostr_relay.db';
      AegisLogger.info("📁 Using database path: $dbPath");

      // Start the relay (using async version)
      _relayUrl = await rust_relay.startRelay(host: _host, port: _port, dbPath: dbPath);
      serverNotifier.value = true;
      AegisLogger.info("✅ Nostr relay started on $_relayUrl");
    } catch (e) {
      AegisLogger.error("🚨 Failed to start relay", e);
      serverNotifier.value = false;
      rethrow;
    }
  }

  /// Stop the relay server
  Future<void> stop() async {
    try {
      if (!await rust_relay.isRelayRunning()) {
        AegisLogger.warning("⚠️ Relay is not running");
        return;
      }

      await rust_relay.stopRelay();
      serverNotifier.value = false;
      _relayUrl = null;
      AegisLogger.info("✅ Relay stopped");
    } catch (e) {
      AegisLogger.error("🚨 Failed to stop relay", e);
      rethrow;
    }
  }

  /// Check if relay is running
  Future<bool> isRunning() async {
    return await rust_relay.isRelayRunning();
  }

  /// Get the current relay URL from the running instance
  Future<String?> getUrl() async {
    try {
      if (!await rust_relay.isRelayRunning()) {
        return null;
      }
      return await rust_relay.getRelayUrl();
    } catch (e) {
      AegisLogger.error("🚨 Failed to get relay URL", e);
      return null;
    }
  }
}

