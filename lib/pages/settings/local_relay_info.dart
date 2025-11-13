import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aegis/utils/relay_service.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/platform_utils.dart';

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
  Map<String, dynamic>? _stats;
  DateTime? _sessionStartTime;
  Duration _currentSessionUptime = Duration.zero;
  Timer? _uptimeTimer;

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
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _isLoading ? null : () => _loadRelayInfo(),
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
                      GestureDetector(
                        onTap: () {
                          final defaultPort = PlatformUtils.isDesktop ? 18081 : 8081;
                          final address = _relayUrl ?? 'ws://127.0.0.1:$defaultPort';
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
                              _relayUrl ?? 'ws://127.0.0.1:${PlatformUtils.isDesktop ? 18081 : 8081}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.copy,
                              size: 18,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    if (_stats != null)
                      _buildInfoItem(
                        'Total Events',
                        Text(
                          _formatNumber(_stats!['totalEvents'] as int? ?? 0),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    if (_sessionStartTime != null)
                      _buildInfoItem(
                        'Service Uptime',
                        Text(
                          _formatDuration(_currentSessionUptime.inSeconds),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
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
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.delete_outline),
                          label: Text(_isClearing ? 'Clearing...' : 'Clear Database'),
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

