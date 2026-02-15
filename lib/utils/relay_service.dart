import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:nostr_rust/src/rust/api/relay.dart' as rust_relay;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

import 'package:aegis/core/contracts/relay_service_interface.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/utils/platform_utils.dart';

/// Nostr Relay Service using rust nostr-relay-builder
/// This replaces the old AegisWebSocketServer
class RelayService implements IRelayService {
  static final RelayService instance = RelayService._internal();
  factory RelayService() => instance;

  RelayService._internal();

  ValueNotifier<bool> serverNotifier = ValueNotifier(false);
  String _host = '127.0.0.1';
  // Default port: 18081 for desktop, 8081 for mobile
  int _port = PlatformUtils.isDesktop ? 18081 : 8081;
  String? _relayUrl;
  DateTime? _sessionStartTime;

  @override
  String get preferredPort {
    try {
      final v = LocalStorage.get(_keyLocalRelayPort);
      if (v != null && v is String) return v;
    } catch (_) {}
    return _defaultPort.toString();
  }

  @override
  Future<void> setPreferredPort(String port) async {
    await LocalStorage.set(_keyLocalRelayPort, port);
  }

  /// Get the relay URL (for client connections)
  @override
  String get relayUrl {
    if (_relayUrl != null) return _relayUrl!;
    // If bound to 0.0.0.0, return localhost for local connections
    // For remote connections, users should use the device's actual IP
    final displayHost = _host == '0.0.0.0' ? '127.0.0.1' : _host;
    return 'ws://$displayHost:$_port';
  }

  /// Get the relay port
  @override
  String get port => _port.toString();

  /// Get the current session start time (if known)
  @override
  DateTime? get sessionStartTime => _sessionStartTime;

  /// Ensure we have a session start timestamp when relay is confirmed running
  @override
  void recordSessionStartIfUnset() {
    _sessionStartTime ??= DateTime.now();
  }

  /// Clear the cached session start timestamp
  @override
  void clearSessionStart() {
    _sessionStartTime = null;
  }

  /// Get default port based on platform
  static int get _defaultPort => PlatformUtils.isDesktop ? 18081 : 8081;

  /// Storage key for user-preferred relay port (optional override)
  static const String _keyLocalRelayPort = 'local_relay_port';

  /// Start the Nostr relay server
  @override
  Future<void> start({
    String? host,  // If null, defaults to '127.0.0.1' on iOS (to avoid iCloud Private Relay conflicts) or '0.0.0.0' on other platforms
    String? port,
    int maxRetries = 3,
  }) async {
    try {
      // On Android, relay should only run in Service
      if (PlatformUtils.isAndroid) {
        // Check if relay is already running (by Service)
        if (await rust_relay.isRelayRunning()) {
          // Relay running in Service, get URL and reuse
          try {
            _relayUrl = await rust_relay.getRelayUrl();
            AegisLogger.info("✅ Relay running in service on $_relayUrl, reusing");
            serverNotifier.value = true;
            recordSessionStartIfUnset();
            return;
          } catch (e) {
            AegisLogger.warning("⚠️ Relay running but can't get URL: $e");
            // Fallback to default URL
            _host = host ?? '0.0.0.0';
            _port = port != null ? (int.tryParse(port) ?? _defaultPort) : _defaultPort;
            _relayUrl = 'ws://127.0.0.1:$_port';
            serverNotifier.value = true;
            recordSessionStartIfUnset();
            return;
          }
        } else {
          // Relay not running, but we don't start it here on Android
          // Service should start it automatically
          AegisLogger.warning("⚠️ Relay not running on Android. Service should start it automatically.");
          throw Exception("Relay not running. Service should start it automatically.");
        }
      }
      
      // For non-Android platforms, use original logic
      // On iOS, use 127.0.0.1 to avoid conflicts with iCloud Private Relay
      // iCloud Private Relay can interfere with binding to 0.0.0.0
      _host = host ?? (PlatformUtils.isIOS ? '127.0.0.1' : '0.0.0.0');
      _port = port != null ? (int.tryParse(port) ?? _defaultPort) : (int.tryParse(this.preferredPort) ?? _defaultPort);

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

      // Start the relay with retry logic for IO errors
      int attempts = 0;
      Exception? lastError;
      
      while (attempts < maxRetries) {
        try {
          _relayUrl = await rust_relay.startRelay(host: _host, port: _port, dbPath: dbPath);
          serverNotifier.value = true;
          _sessionStartTime = DateTime.now();
          AegisLogger.info("✅ Nostr relay started on $_relayUrl");
          return;
        } catch (e) {
          attempts++;
          lastError = e is Exception ? e : Exception(e.toString());
          
          // Check if it's an IO error related to database locks
          final errorMsg = e.toString().toLowerCase();
          final isIOError = errorMsg.contains('io error') || 
                           errorMsg.contains('lock') || 
                           errorMsg.contains('resource temporarily unavailable');
          
          if (isIOError && attempts < maxRetries) {
            AegisLogger.warning("⚠️ IO error on attempt $attempts/$maxRetries, retrying...");
            // Wait progressively longer: 1s, 2s, 3s...
            await Future.delayed(Duration(seconds: attempts));
          } else {
            break;
          }
        }
      }
      
      // If we get here, all retries failed
      AegisLogger.error("🚨 Failed to start relay after $attempts attempts", lastError);
      serverNotifier.value = false;
      throw lastError ?? Exception("Failed to start relay");
    } catch (e) {
      AegisLogger.error("🚨 Failed to start relay", e);
      serverNotifier.value = false;
      rethrow;
    }
  }

  /// Stop the relay server
  @override
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
        
        // Wait longer to ensure complete resource cleanup (database locks, file handles, etc.)
        // This is especially important for NDB/LMDB database file locks
        AegisLogger.info("⏳ Waiting for resources to be fully released...");
        await Future.delayed(const Duration(milliseconds: 2000));
        
        // Restart with saved configuration
        await start(host: currentHost, port: currentPort);
        AegisLogger.info("✅ Relay restarted");
      } else {
        // If not running, just start it
        await start();
        AegisLogger.info("✅ [RELAY_RESTART] Relay started successfully");
      }
    } catch (e) {
      AegisLogger.error("🚨 [RELAY_RESTART] Failed to restart relay", e);
      rethrow;
    }
  }

  /// Check if relay is running
  @override
  Future<bool> isRunning() async {
    return await rust_relay.isRelayRunning();
  }

  /// Get the current relay URL from the running instance
  @override
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
  Future<Map<String, dynamic>?> getStats() async {
    if(PlatformUtils.isAndroid) {
      //todo: fix crash
      return null;
    }
    try {
      final dbPath = await getDatabasePath();
      final stats = await rust_relay.getRelayStats(dbPath: dbPath);
      final totalEvents = int.parse(stats.totalEvents.toString());
      final connections = int.parse(stats.connections.toString());

      return {
        'totalEvents': totalEvents,
        'connections': connections,
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

  /// Export database directory to a zip file
  /// Returns the path to the exported zip file, or null on failure
  /// Note: This will stop the relay temporarily to ensure safe copying
  /// File naming format: nostr_relay_backup_YYYYMMDD_HHMMSS.zip
  Future<String?> exportDatabase(String targetZipPath) async {
    try {
      final isRunning = await this.isRunning();
      
      // Stop relay if running to release database locks
      if (isRunning) {
        await stop();
        // Wait for file locks to be released
        await Future.delayed(const Duration(milliseconds: 2000));
      }

      final dbPath = await getDatabasePath();
      final sourceDir = Directory(dbPath);
      
      if (!await sourceDir.exists()) {
        AegisLogger.warning("⚠️ Database directory not found: $dbPath");
        // Restart relay if it was running
        if (isRunning) {
          await start();
        }
        return null;
      }

      // Create zip archive
      final archive = Archive();
      
      int fileCount = 0;
      
      // Normalize database path for path comparison
      final normalizedDbPath = dbPath.replaceAll('\\', '/');
      
      // Add all files from database directory to archive
      await for (final entity in sourceDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final fileSize = await entity.length();
            if (fileSize == 0) {
              continue;
            }
            
            final fileData = await entity.readAsBytes();
            
            // Get relative path from source directory
            // Normalize path separators for cross-platform compatibility
            var relativePath = entity.path.replaceAll('\\', '/');
            if (relativePath.startsWith(normalizedDbPath)) {
              relativePath = relativePath.substring(normalizedDbPath.length + 1);
            } else {
              // Fallback: use filename if path doesn't match
              relativePath = entity.path.split(Platform.pathSeparator).last;
            }
            
            // Ensure forward slashes in zip (zip standard)
            relativePath = relativePath.replaceAll('\\', '/');
            
            archive.addFile(ArchiveFile(relativePath, fileData.length, fileData));
            fileCount++;
          } catch (e) {
            AegisLogger.warning("⚠️ Failed to read file ${entity.path}: $e");
          }
        }
      }
      
      if (fileCount == 0) {
        AegisLogger.warning("⚠️ No files found in database directory. Database may be empty.");
      }

      // Write zip file
      final zipFile = File(targetZipPath);
      if (await zipFile.exists()) {
        await zipFile.delete();
      }
      
      final zipEncoder = ZipEncoder();
      final zipData = zipEncoder.encode(archive);
      if (zipData == null) {
        throw Exception('Failed to encode zip archive');
      }
      
      await zipFile.writeAsBytes(zipData);
      
      AegisLogger.info("✅ Database exported successfully to $targetZipPath");

      // Restart relay if it was running
      if (isRunning) {
        await start();
      }

      return targetZipPath;
    } catch (e) {
      AegisLogger.error("🚨 Failed to export database", e);
      // Try to restart relay if it was running
      try {
        if (await this.isRunning() == false) {
          await start();
        }
      } catch (restartError) {
        AegisLogger.error("🚨 Failed to restart relay after export error", restartError);
      }
      return null;
    }
  }

  /// Import database from a zip file or directory
  /// Note: This will stop the relay temporarily and replace the existing database
  Future<bool> importDatabase(String sourcePath) async {
    try {
      final isRunning = await this.isRunning();
      
      // Stop relay if running to release database locks
      if (isRunning) {
        await stop();
        // Wait for file locks to be released
        await Future.delayed(const Duration(milliseconds: 2000));
      }

      final sourceFile = File(sourcePath);
      final sourceDir = Directory(sourcePath);
      
      final dbPath = await getDatabasePath();
      final targetDir = Directory(dbPath);

      // Backup existing database if it exists
      if (await targetDir.exists()) {
        final backupPath = '$dbPath.backup.${DateTime.now().millisecondsSinceEpoch}';
        try {
          await _copyDirectory(targetDir, Directory(backupPath));
        } catch (e) {
          AegisLogger.warning("⚠️ Failed to create backup: $e");
        }
        
        // Delete existing database
        await targetDir.delete(recursive: true);
      }

      // Create target directory
      await targetDir.create(recursive: true);

      // Check if source is a zip file or directory
      if (await sourceFile.exists() && sourcePath.toLowerCase().endsWith('.zip')) {
        // Import from zip file
        final zipData = await sourceFile.readAsBytes();
        final zipDecoder = ZipDecoder();
        final archive = zipDecoder.decodeBytes(zipData);
        
        for (final file in archive) {
          if (file.isFile) {
            final filePath = '${targetDir.path}${Platform.pathSeparator}${file.name}';
            final outputFile = File(filePath);
            // Create parent directory if needed
            await outputFile.parent.create(recursive: true);
            await outputFile.writeAsBytes(file.content as List<int>);
          }
        }
        AegisLogger.info("✅ Database imported successfully");
      } else if (await sourceDir.exists()) {
        // Import from directory (backward compatibility)
        await _copyDirectory(sourceDir, targetDir);
        AegisLogger.info("✅ Database imported successfully");
      } else {
        AegisLogger.error("🚨 Source not found: $sourcePath");
        // Restart relay if it was running
        if (isRunning) {
          await start();
        }
        return false;
      }

      // Restart relay if it was running
      if (isRunning) {
        await start();
      }

      return true;
    } catch (e) {
      AegisLogger.error("🚨 Failed to import database", e);
      // Try to restart relay if it was running
      try {
        if (await this.isRunning() == false) {
          await start();
        }
      } catch (restartError) {
        AegisLogger.error("🚨 Failed to restart relay after import error", restartError);
      }
      return false;
    }
  }

  /// Recursively copy directory contents
  Future<void> _copyDirectory(Directory source, Directory target) async {
    await target.create(recursive: true);
    
    await for (final entity in source.list(recursive: false)) {
      final entityName = entity.path.split(Platform.pathSeparator).last;
      if (entity is File) {
        final targetFile = File('${target.path}${Platform.pathSeparator}$entityName');
        await entity.copy(targetFile.path);
      } else if (entity is Directory) {
        final targetSubDir = Directory('${target.path}${Platform.pathSeparator}$entityName');
        await _copyDirectory(entity, targetSubDir);
      }
    }
  }
}

