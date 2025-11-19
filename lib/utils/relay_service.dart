import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:nostr_rust/src/rust/api/relay.dart' as rust_relay;
import 'package:path_provider/path_provider.dart';
import 'logger.dart';
import 'platform_utils.dart';

/// Nostr Relay Service using rust nostr-relay-builder
/// This replaces the old AegisWebSocketServer
class RelayService {
  static final RelayService instance = RelayService._internal();
  factory RelayService() => instance;

  RelayService._internal();

  ValueNotifier<bool> serverNotifier = ValueNotifier(false);
  String _host = '127.0.0.1';
  // Default port: 18081 for desktop, 8081 for mobile
  int _port = PlatformUtils.isDesktop ? 18081 : 8081;
  String? _relayUrl;
  DateTime? _sessionStartTime;

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

  /// Get the current session start time (if known)
  DateTime? get sessionStartTime => _sessionStartTime;

  /// Ensure we have a session start timestamp when relay is confirmed running
  void recordSessionStartIfUnset() {
    _sessionStartTime ??= DateTime.now();
  }

  /// Clear the cached session start timestamp
  void clearSessionStart() {
    _sessionStartTime = null;
  }

  /// Get default port based on platform
  static int get _defaultPort => PlatformUtils.isDesktop ? 18081 : 8081;

  /// Start the Nostr relay server
  Future<void> start({
    String host = '0.0.0.0',  // Bind to all interfaces (network accessible)
    String? port,
  }) async {
    try {
      _host = host;
      _port = port != null ? (int.tryParse(port) ?? _defaultPort) : _defaultPort;

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
        recordSessionStartIfUnset();
        return;
      }

      // Get database path (nostrdb uses a directory, not a single file)
      final appDir = await getApplicationSupportDirectory();
      final dbPath = '${appDir.path}/nostr_relay';
      AegisLogger.info("📁 Using database path: $dbPath");

      // Start the relay (using async version)
      _relayUrl = await rust_relay.startRelay(host: _host, port: _port, dbPath: dbPath);
      serverNotifier.value = true;
      _sessionStartTime = DateTime.now();
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
      _sessionStartTime = null;
      AegisLogger.info("✅ Relay stopped");
    } catch (e) {
      AegisLogger.error("🚨 Failed to stop relay", e);
      rethrow;
    }
  }

  /// Restart the relay server
  Future<void> restart() async {
    try {
      final wasRunning = await rust_relay.isRelayRunning();
      
      if (wasRunning) {
        // Save current host and port before stopping
        final currentHost = _host;
        final currentPort = _port.toString();
        
        // Stop the relay
        await stop();
        
        // Wait a bit to ensure clean shutdown
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Restart with saved configuration
        await start(host: currentHost, port: currentPort);
        AegisLogger.info("✅ Relay restarted");
      } else {
        // If not running, just start it
        await start();
        AegisLogger.info("✅ Relay started");
      }
    } catch (e) {
      AegisLogger.error("🚨 Failed to restart relay", e);
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

  /// Get database file path
  Future<String> getDatabasePath() async {
    final appDir = await getApplicationSupportDirectory();
    return '${appDir.path}/nostr_relay';
  }

  /// Get database size in bytes
  /// Note: nostrdb uses a directory with multiple files (data.mdb, lock.mdb, etc.)
  Future<int> getDatabaseSize() async {
    try {
      final dbPath = await getDatabasePath();
      final directory = Directory(dbPath);
      
      if (await directory.exists()) {
        return await _getDirectorySize(directory);
      }
      
      AegisLogger.warning("⚠️ Database directory not found: $dbPath");
      return 0;
    } catch (e) {
      AegisLogger.error("🚨 Failed to get database size", e);
      return 0;
    }
  }

  /// Recursively calculate directory size
  Future<int> _getDirectorySize(Directory directory) async {
    try {
      int totalSize = 0;
      await for (var entity in directory.list(recursive: true)) {
        if (entity is File) {
          try {
            totalSize += await entity.length();
          } catch (e) {
            // Skip files that can't be read (might be locked)
            AegisLogger.warning("⚠️ Failed to read file size: ${entity.path}");
          }
        }
      }
      return totalSize;
    } catch (e) {
      AegisLogger.error("🚨 Failed to calculate directory size: ${directory.path}", e);
      return 0;
    }
  }

  /// Clear database (delete database directory and restart relay if running)
  /// Note: nostrdb uses a directory with multiple files (data.mdb, lock.mdb, etc.)
  Future<bool> clearDatabase() async {
    try {
      final isRunning = await this.isRunning();
      
      // Stop relay if running
      if (isRunning) {
        await stop();
      }

      // Delete database directory recursively
      final dbPath = await getDatabasePath();
      final directory = Directory(dbPath);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        AegisLogger.info("✅ Database directory deleted: $dbPath");
      } else {
        AegisLogger.warning("⚠️ Database directory not found: $dbPath");
      }

      // Restart relay if it was running
      if (isRunning) {
        await start();
        AegisLogger.info("✅ Relay restarted after clearing database");
      }

      return true;
    } catch (e) {
      AegisLogger.error("🚨 Failed to clear database", e);
      return false;
    }
  }

  /// Get relay statistics (event-focused)
  /// Note: This requires regenerating flutter_rust_bridge code after adding the Rust API
  Future<Map<String, dynamic>?> getStats() async {
    try {
      final dbPath = await getDatabasePath();
      final stats = await rust_relay.getRelayStats(dbPath: dbPath);
      final totalEvents = int.parse(stats.totalEvents.toString());

      return {
        'totalEvents': totalEvents,
      };
    } catch (e) {
      AegisLogger.error("🚨 Failed to get relay stats", e);
      return null;
    }
  }

  /// Get log file path
  Future<String?> getLogFilePath() async {
    try {
      final dbPath = await getDatabasePath();
      final dbPathBuf = Directory(dbPath);
      if (await dbPathBuf.exists()) {
        final logFile = File('${dbPathBuf.parent.path}/relay.log');
        return logFile.path;
      }
      return null;
    } catch (e) {
      AegisLogger.error("🚨 Failed to get log file path", e);
      return null;
    }
  }

  /// Read log file content (last N lines)
  /// Uses Rust FFI to read and automatically truncate to 200 lines
  Future<String> readLogFile({int? maxLines}) async {
    try {
      final content = await rust_relay.relayReadLogFile(maxLines: maxLines);
      return content;
    } catch (e) {
      AegisLogger.error("🚨 Failed to read log file", e);
      return "Failed to read log file: $e";
    }
  }

  /// Clear log file content
  Future<bool> clearLogFile() async {
    try {
      final logPath = await getLogFilePath();
      if (logPath == null) {
        AegisLogger.error("🚨 Log file path not available");
        return false;
      }
      
      final logFile = File(logPath);
      if (await logFile.exists()) {
        await logFile.writeAsString('');
        AegisLogger.info("✅ Log file cleared");
        return true;
      } else {
        AegisLogger.warning("⚠️ Log file does not exist");
        return true; // Consider it successful if file doesn't exist
      }
    } catch (e) {
      AegisLogger.error("🚨 Failed to clear log file", e);
      return false;
    }
  }
}

