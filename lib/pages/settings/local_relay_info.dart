import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aegis/utils/relay_service.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/platform_utils.dart';
import 'package:aegis/utils/local_tls_proxy_manager_rust.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

/// Dialog widget for clearing database confirmation
class _ClearDatabaseDialog extends StatefulWidget {
  const _ClearDatabaseDialog();

  @override
  State<_ClearDatabaseDialog> createState() => _ClearDatabaseDialogState();
}

class _ClearDatabaseDialogState extends State<_ClearDatabaseDialog> {
  late final TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConfirmValid = _confirmController.text.toLowerCase() == 'confirm';
    return AlertDialog(
      title: const Text('Clear Database'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will delete all relay data and restart the relay if it is running. '
              'This action cannot be undone.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmController,
              decoration: const InputDecoration(
                labelText: 'Type "confirm" to proceed',
                hintText: 'confirm',
              ),
              autofocus: true,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed:
              isConfirmValid ? () => Navigator.of(context).pop(true) : null,
          style: TextButton.styleFrom(
            foregroundColor: isConfirmValid ? Colors.red : Colors.grey,
          ),
          child: const Text('Clear'),
        ),
      ],
    );
  }
}

/// Dialog widget for importing database
class _ImportDatabaseDialog extends StatefulWidget {
  const _ImportDatabaseDialog();

  @override
  State<_ImportDatabaseDialog> createState() => _ImportDatabaseDialogState();
}

class _ImportDatabaseDialogState extends State<_ImportDatabaseDialog> {
  late final TextEditingController _pathController;

  @override
  void initState() {
    super.initState();
    _pathController = TextEditingController();
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPathValid = _pathController.text.trim().isNotEmpty;
    return AlertDialog(
      title: const Text('Import Database'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the path to the database directory to import. '
              'The existing database will be backed up before import.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pathController,
              decoration: const InputDecoration(
                labelText: 'Database directory path',
                hintText: '/path/to/nostr_relay_backup_...',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: isPathValid
              ? () => Navigator.of(context).pop(_pathController.text.trim())
              : null,
          child: const Text('Import'),
        ),
      ],
    );
  }
}

/// Local Relay Info Page
/// Shows relay address, status, and database size with option to clear data
class LocalRelayInfo extends StatefulWidget {
  const LocalRelayInfo({super.key});

  @override
  State<LocalRelayInfo> createState() => _LocalRelayInfoState();
}

class _LocalRelayInfoState extends State<LocalRelayInfo> {
  bool _isRelayRunning = false;
  String? _relayUrl;
  int _databaseSize = 0;
  bool _isLoading = true;
  bool _isClearing = false;
  bool _isRestarting = false;
  bool _isExporting = false;
  bool _isImporting = false;
  Map<String, dynamic>? _stats;
  DateTime? _sessionStartTime;
  Duration _currentSessionUptime = Duration.zero;
  Timer? _uptimeTimer;
  bool _showLogs = false;
  String _logContent = '';
  Timer? _logRefreshTimer;
  final ScrollController _logScrollController = ScrollController();
  bool _showSecureRelayAddress = false;

  @override
  void initState() {
    super.initState();
    _loadRelayInfo();
    // Listen to relay status changes
    RelayService.instance.serverNotifier.addListener(_onRelayStatusChanged);
  }

  @override
  void dispose() {
    RelayService.instance.serverNotifier.removeListener(_onRelayStatusChanged);
    _stopUptimeTimer();
    _stopLogRefreshTimer();
    _logScrollController.dispose();
    super.dispose();
  }

  void _onRelayStatusChanged() {
    _loadRelayInfo();
  }

  void _startUptimeTimer() {
    _uptimeTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _sessionStartTime == null) return;
      final duration = DateTime.now().difference(_sessionStartTime!);
      if (duration.inSeconds != _currentSessionUptime.inSeconds) {
        setState(() {
          _currentSessionUptime = duration;
        });
      }
    });
  }

  void _stopUptimeTimer() {
    _uptimeTimer?.cancel();
    _uptimeTimer = null;
  }

  String _resolvedRelayAddress() {
    final defaultPort = PlatformUtils.isDesktop ? 18081 : 8081;
    final fallbackUrl = _relayUrl ?? 'ws://127.0.0.1:$defaultPort';

    if (!_showSecureRelayAddress) {
      return fallbackUrl;
    }

    final uri = Uri.tryParse(fallbackUrl);
    final port = uri?.port ?? defaultPort;
    final proxyManager = LocalTlsProxyManagerRust.instance;
    if (!proxyManager.isRunning) {
      return fallbackUrl;
    }
    return proxyManager.relayUrlFor(port.toString());
  }

  Widget _buildAddressModeSelector() {
    final secureAvailable = LocalTlsProxyManagerRust.instance.isRunning;
    return SegmentedButton<String>(
      segments: [
        ButtonSegment(
          value: 'ws',
          label: Text(
            'WS',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        ButtonSegment(
          value: 'wss',
          label: Text(
            'WSS',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
      selected: {_showSecureRelayAddress ? 'wss' : 'ws'},
      onSelectionChanged: secureAvailable
          ? (Set<String> newSelection) {
              if (mounted) {
                setState(() {
                  _showSecureRelayAddress = newSelection.contains('wss');
                });
              }
            }
          : null,
    );
  }

  void _startLogRefreshTimer() {
    _stopLogRefreshTimer();
    if (_showLogs) {
      _loadLogs();
      _logRefreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        _loadLogs();
      });
    }
  }

  void _stopLogRefreshTimer() {
    _logRefreshTimer?.cancel();
    _logRefreshTimer = null;
  }

  Future<void> _loadLogs({bool forceScrollToBottom = false}) async {
    try {
      final content = await RelayService.instance.readLogFile(maxLines: 200);
      if (mounted) {
        // Check if user is near bottom before updating
        bool shouldAutoScroll = forceScrollToBottom;
        if (!shouldAutoScroll && _logScrollController.hasClients) {
          final position = _logScrollController.position;
          final maxScroll = position.maxScrollExtent;
          final currentScroll = position.pixels;
          // Auto scroll only if user is within 50 pixels of bottom
          shouldAutoScroll = (maxScroll - currentScroll) < 50;
        } else if (!shouldAutoScroll) {
          // If no scroll controller yet, auto scroll on first load
          shouldAutoScroll = true;
        }

        setState(() {
          _logContent = content;
        });

        // Auto scroll to bottom only if user was already near bottom or forced
        if (shouldAutoScroll) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _logScrollController.hasClients) {
              _logScrollController.animateTo(
                _logScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
    } catch (e) {
      AegisLogger.error("Failed to load logs", e);
    }
  }

  void _toggleLogs() {
    setState(() {
      _showLogs = !_showLogs;
    });
    if (_showLogs) {
      // Force scroll to bottom when logs are first shown
      _loadLogs(forceScrollToBottom: true);
      _startLogRefreshTimer();
      // Additional scroll after ExpansionTile animation completes
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _showLogs && _logScrollController.hasClients) {
          _logScrollController.animateTo(
            _logScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      _stopLogRefreshTimer();
    }
  }

  Future<void> _loadRelayInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isRunning = await RelayService.instance.isRunning();
      final relayUrl = await RelayService.instance.getUrl();
      final databaseSize = await RelayService.instance.getDatabaseSize();
      final stats = await RelayService.instance.getStats();

      DateTime? sessionStart;
      if (isRunning) {
        RelayService.instance.recordSessionStartIfUnset();
        sessionStart = RelayService.instance.sessionStartTime;
      } else {
        RelayService.instance.clearSessionStart();
        sessionStart = null;
      }

      if (mounted) {
        setState(() {
          _isRelayRunning = isRunning;
          _relayUrl = relayUrl;
          _databaseSize = databaseSize;
          _stats = stats;
          _sessionStartTime = sessionStart;
          _currentSessionUptime = sessionStart != null
              ? DateTime.now().difference(sessionStart)
              : Duration.zero;
          _isLoading = false;
        });
      }

      if (sessionStart != null) {
        _startUptimeTimer();
      } else {
        _stopUptimeTimer();
      }
    } catch (e) {
      AegisLogger.error("Failed to load relay info", e);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRelayRunning = false;
          _sessionStartTime = null;
          _currentSessionUptime = Duration.zero;
          _stats = null;
        });
      }
      RelayService.instance.clearSessionStart();
      _stopUptimeTimer();
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) {
      return '0s';
    }
    final duration = Duration(seconds: seconds);
    if (duration.inDays > 0) {
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      return hours > 0 ? '${days}d ${hours}h' : '${days}d';
    }
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      final secs = duration.inSeconds % 60;
      return secs > 0 ? '${minutes}m ${secs}s' : '${minutes}m';
    }
    return '${duration.inSeconds}s';
  }

  Future<void> _handleRestartRelay() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart Relay'),
        content: const Text(
          'Are you sure you want to restart the relay? The relay will be temporarily stopped and then restarted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Restart'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isRestarting = true;
    });

    try {
      await RelayService.instance.restart();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relay restarted successfully')),
        );
        await _loadRelayInfo();
      }
    } catch (e) {
      AegisLogger.error("Failed to restart relay", e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to restart relay: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRestarting = false;
        });
      }
    }
  }

  Future<void> _handleClearDatabase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _ClearDatabaseDialog(),
    );

    if (confirmed != true) return;

    setState(() {
      _isClearing = true;
    });

    try {
      final success = await RelayService.instance.clearDatabase();
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Database cleared successfully')),
          );
          await _loadRelayInfo();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to clear database')),
          );
        }
      }
    } catch (e) {
      AegisLogger.error("Failed to clear database", e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isClearing = false;
        });
      }
    }
  }

  Future<void> _handleExportDatabase() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Database'),
        content: const Text(
          'This will export the relay database as a ZIP file. The export may take a few moments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Export'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isExporting = true;
    });

    try {
      Directory exportDir;
      String exportPath;

      // Generate standardized filename: nostr_relay_backup_YYYYMMDD_HHMMSS.zip
      final now = DateTime.now();
      final timestamp = '${now.year.toString().padLeft(4, '0')}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}'
          '${now.minute.toString().padLeft(2, '0')}'
          '${now.second.toString().padLeft(2, '0')}';
      final zipFileName = 'nostr_relay_backup_$timestamp.zip';

      if (PlatformUtils.isDesktop) {
        // For desktop, use Downloads directory
        final homeDir = Platform.environment['HOME'] ??
            Platform.environment['USERPROFILE'] ??
            '';
        if (homeDir.isEmpty) {
          throw Exception('Cannot determine home directory');
        }
        exportDir = Directory('$homeDir${Platform.pathSeparator}Downloads');
        exportPath = '${exportDir.path}${Platform.pathSeparator}$zipFileName';
      } else if (PlatformUtils.isAndroid) {
        // For Android, use app documents directory (will share via share_plus)
        exportDir = await getApplicationDocumentsDirectory();
        exportPath = '${exportDir.path}${Platform.pathSeparator}$zipFileName';
      } else {
        // For iOS, use temporary directory (will be shared via share_plus)
        final tempDir = await getTemporaryDirectory();
        exportPath = '${tempDir.path}${Platform.pathSeparator}$zipFileName';
      }

      final exportedPath =
          await RelayService.instance.exportDatabase(exportPath);

      if (exportedPath != null) {
        if (mounted) {
          if (PlatformUtils.isIOS) {
            // For iOS, use share_plus to save to Files app
            try {
              final zipFile = File(exportedPath);
              if (await zipFile.exists()) {
                await Share.shareXFiles(
                  [XFile(exportedPath)],
                  subject: 'Nostr Relay Database Backup',
                  text:
                      'Nostr Relay Database Backup\n\nTap "Save to Files" to save to Files app.',
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Database exported as ZIP file. Use "Save to Files" in the share sheet to save.'),
                    duration: Duration(seconds: 5),
                  ),
                );
              } else {
                throw Exception('ZIP file not found');
              }
            } catch (e) {
              AegisLogger.error("Failed to share database on iOS", e);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Database exported to: $exportedPath\n\nYou can access it via Files app > On My iPhone > Aegis'),
                  duration: const Duration(seconds: 7),
                ),
              );
            }
          } else if (PlatformUtils.isAndroid) {
            // For Android, use share_plus to let user choose save location
            try {
              final zipFile = File(exportedPath);
              if (await zipFile.exists()) {
                await Share.shareXFiles(
                  [XFile(exportedPath)],
                  subject: 'Nostr Relay Database Backup',
                  text:
                      'Nostr Relay Database Backup\n\nChoose where to save the ZIP file.',
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Database exported as ZIP file. Choose where to save in the share sheet.'),
                    duration: Duration(seconds: 5),
                  ),
                );
              } else {
                throw Exception('ZIP file not found');
              }
            } catch (e) {
              AegisLogger.error("Failed to share database on Android", e);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Database exported to: $exportedPath'),
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          } else {
            // For Desktop, show path
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Database exported as ZIP file: $exportedPath'),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to export database')),
          );
        }
      }
    } catch (e) {
      AegisLogger.error("Failed to export database", e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _handleImportDatabase() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Database'),
        content: const Text(
          'This will replace the current database with the imported backup. The existing database will be backed up before import. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Import'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isImporting = true;
    });

    try {
      String? importPath;

      // Use file picker to select zip file or directory
      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['zip'],
          dialogTitle: 'Select database backup file (ZIP) or directory',
        );
      } catch (e) {
        AegisLogger.warning(
            "File picker with zip filter failed, trying directory picker", e);
        // Fallback to directory picker
        try {
          final dirResult = await FilePicker.platform.getDirectoryPath(
            dialogTitle: 'Select database backup directory',
          );
          importPath = dirResult;
        } catch (e2) {
          AegisLogger.warning("Directory picker also failed, using dialog", e2);
          // Final fallback to dialog for manual path entry
          final pathFromDialog = await showDialog<String>(
            context: context,
            builder: (context) => _ImportDatabaseDialog(),
          );
          importPath = pathFromDialog;
        }
      }

      // If file picker returned a result, use it
      if (result != null && result.files.single.path != null) {
        importPath = result.files.single.path;
      }

      if (importPath == null || importPath.isEmpty) {
        if (mounted) {
          setState(() {
            _isImporting = false;
          });
        }
        return;
      }

      // Verify the file or directory exists
      final file = File(importPath);
      final directory = Directory(importPath);

      if (await file.exists() && importPath.toLowerCase().endsWith('.zip')) {
        // Valid zip file, proceed
        AegisLogger.info("Selected ZIP file: $importPath");
      } else if (await directory.exists()) {
        // Valid directory, proceed (backward compatibility)
        AegisLogger.info("Selected directory: $importPath");
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Selected file or directory does not exist')),
          );
        }
        return;
      }

      final success = await RelayService.instance.importDatabase(importPath);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Database imported successfully')),
          );
          await _loadRelayInfo();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to import database')),
          );
        }
      }
    } catch (e) {
      AegisLogger.error("Failed to import database", e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Local Relay',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
        actions: [
          IconButton(
            icon: _isRestarting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.restart_alt),
            tooltip: 'Restart Relay',
            onPressed: _isRestarting ? null : _handleRestartRelay,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRelayInfo,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Connection Details Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Status Section
                              Row(
                                children: [
                                  Text(
                                    'Status',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _isRelayRunning
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _isRelayRunning
                                            ? Colors.green
                                            : Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      _isRelayRunning ? 'Running' : 'Stopped',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: _isRelayRunning
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Address Section
                              Row(
                                children: [
                                  Text(
                                    'Address',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      final address = _resolvedRelayAddress();
                                      Clipboard.setData(
                                          ClipboardData(text: address));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Address copied to clipboard'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _resolvedRelayAddress(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontFamily: 'monospace',
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.copy,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Protocol Section
                              Row(
                                children: [
                                  Text(
                                    'Protocol',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  const Spacer(),
                                  _buildAddressModeSelector(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Statistics Card (Size, Events, Uptime)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            // SIZE Section
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SIZE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatBytes(_databaseSize),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Vertical Divider
                            Container(
                              width: 1,
                              height: 40,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.2),
                            ),
                            // EVENTS Section
                            if (_stats != null) ...[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'EVENTS',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _formatNumber(
                                            _stats!['totalEvents'] as int? ?? 0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Vertical Divider
                              Container(
                                width: 1,
                                height: 40,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withOpacity(0.2),
                              ),
                            ],
                            // UPTIME Section
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'UPTIME',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatDuration(
                                          _currentSessionUptime.inSeconds),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Actions Card (System Logs, Export Data, Import Data)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Export Data List Item
                            ListTile(
                              title: Text(
                                'Export Data',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              onTap: _isExporting ? null : _handleExportDatabase,
                            ),
                            // Import Data List Item
                            ListTile(
                              title: Text(
                                'Import Data',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              onTap: _isImporting ? null : _handleImportDatabase,
                            ),
                            // System Logs List Item
                            ListTile(
                              title: Text(
                                'System Logs',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Icon(
                                _showLogs ? Icons.expand_less : Icons.expand_more,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              onTap: _toggleLogs,
                            ),
                            // Logs content (expandable)
                            if (_showLogs)
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: 200,
                                  maxHeight: 200,
                                ),
                                margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: _logContent.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Text(
                                            'No logs available',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                ),
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Scrollbar(
                                          controller: _logScrollController,
                                          thumbVisibility: true,
                                          radius: const Radius.circular(4),
                                          child: SingleChildScrollView(
                                            controller: _logScrollController,
                                            padding: const EdgeInsets.all(16),
                                            child: SelectableText(
                                              _logContent,
                                              style: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 11,
                                                color: Colors.greenAccent,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Clear All Relay Data (centered red text link)
                    Center(
                      child: TextButton(
                        onPressed: _isClearing ? null : _handleClearDatabase,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: _isClearing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                              )
                            : const Text(
                                'Clear All Relay Data',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
