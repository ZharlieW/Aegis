import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aegis/utils/relay_service.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/platform_utils.dart';
import 'package:aegis/utils/local_tls_proxy_manager_rust.dart';

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
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('ws://'),
          selected: !_showSecureRelayAddress,
          onSelected: (selected) {
            if (selected && mounted) {
              setState(() {
                _showSecureRelayAddress = false;
              });
            }
          },
        ),
        ChoiceChip(
          label: const Text('wss://'),
          selected: _showSecureRelayAddress,
          onSelected: secureAvailable
              ? (selected) {
                  if (selected && mounted) {
                    setState(() {
                      _showSecureRelayAddress = true;
                    });
                  }
                }
              : null,
        ),
        if (!secureAvailable)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              'TLS proxy not running',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
          ),
      ],
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
      builder: (context) => AlertDialog(
        title: const Text('Clear Database'),
        content: const Text(
          'This will delete all relay data and restart the relay if it is running. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
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

  Widget _buildInfoItem(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          value,
        ],
      ),
    );
  }

  Widget _buildStatusWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isRelayRunning ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _isRelayRunning ? 'Running' : 'Stopped',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _isRelayRunning ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
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
                    _buildInfoItem(
                      'Address',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final address = _resolvedRelayAddress();
                              Clipboard.setData(ClipboardData(text: address));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Address copied to clipboard'),
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
                                      .titleMedium
                                      ?.copyWith(
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
                          const SizedBox(height: 8),
                          _buildAddressModeSelector(),
                        ],
                      ),
                    ),
                    _buildInfoItem(
                      'Status',
                      _buildStatusWidget(),
                    ),
                    _buildInfoItem(
                      'Database Size',
                      Text(
                        _formatBytes(_databaseSize),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ),
                    if (_stats != null)
                      _buildInfoItem(
                        'Total Events',
                        Text(
                          _formatNumber(_stats!['totalEvents'] as int? ?? 0),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    _buildInfoItem(
                      'Service Uptime',
                      Text(
                        _formatDuration(_currentSessionUptime.inSeconds),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ),
                    // Relay Logs as a list item
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            shape: const Border(),
                            collapsedShape: const Border(),
                            childrenPadding: EdgeInsets.zero,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Relay Logs',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  _showLogs
                                      ? 'Tap to hide logs'
                                      : 'Tap to view logs',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            initiallyExpanded: false,
                            onExpansionChanged: (expanded) {
                              if (expanded != _showLogs) {
                                _toggleLogs();
                              }
                            },
                            children: [
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: 200,
                                  maxHeight: 200,
                                ),
                                margin:
                                    const EdgeInsets.only(bottom: 8, top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade700,
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
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(24),
                                          child: Text(
                                            'No logs available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
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
                              // Action buttons inside ExpansionTile, closer to log content
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () async {
                                          final confirmed =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Clear Log'),
                                              content: const Text(
                                                'This will clear all log content. New logs will continue to be recorded.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  child: const Text('Clear'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirmed == true) {
                                            final success = await RelayService
                                                .instance
                                                .clearLogFile();
                                            if (mounted) {
                                              if (success) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Log file cleared'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                                // Reload logs to show empty content
                                                _loadLogs(
                                                    forceScrollToBottom: true);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Failed to clear log file'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.clear, size: 18),
                                        label: const Text('Clear Log'),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          side: BorderSide(
                                            color: Colors.red.shade300,
                                          ),
                                          foregroundColor: Colors.red.shade300,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          if (_logContent.isNotEmpty) {
                                            Clipboard.setData(ClipboardData(
                                                text: _logContent));
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Log content copied to clipboard'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.copy, size: 18),
                                        label: const Text('Copy Log'),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 32),
                    // Clear Database Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isClearing ? null : _handleClearDatabase,
                          icon: _isClearing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.delete_outline),
                          label: Text(
                              _isClearing ? 'Clearing...' : 'Clear Database'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Note: Clearing the database will delete all stored events. '
                        'If the relay is running, it will be restarted automatically.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
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
