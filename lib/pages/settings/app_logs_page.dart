import 'package:aegis/services/app_log_service.dart';
import 'package:flutter/material.dart';

class AppLogsPage extends StatefulWidget {
  const AppLogsPage({super.key});

  @override
  State<AppLogsPage> createState() => _AppLogsPageState();
}

class _AppLogsPageState extends State<AppLogsPage> {
  List<AppLogEntry> _logs = const <AppLogEntry>[];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _logs = AppLogService.instance.getAll().toList(growable: false);
    });
  }

  void _clearLogs() {
    AppLogService.instance.clear();
    _reload();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logs cleared.')),
    );
  }

  Future<void> _confirmClearLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear logs'),
        content: const Text('This will remove all app logs from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _clearLogs();
    }
  }

  String _formatTime(DateTime time) {
    final y = time.year.toString().padLeft(4, '0');
    final m = time.month.toString().padLeft(2, '0');
    final d = time.day.toString().padLeft(2, '0');
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    final ss = time.second.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm:$ss';
  }

  String _typeText(AppLogLevel level) {
    switch (level) {
      case AppLogLevel.debug:
        return 'DEBUG';
      case AppLogLevel.info:
        return 'INFO';
      case AppLogLevel.warning:
        return 'WARNING';
      case AppLogLevel.error:
        return 'ERROR';
    }
  }

  Color _typeColor(BuildContext context, AppLogLevel level) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (level) {
      case AppLogLevel.debug:
        return colorScheme.secondary;
      case AppLogLevel.info:
        return colorScheme.primary;
      case AppLogLevel.warning:
        return Colors.orange;
      case AppLogLevel.error:
        return colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _logs.isEmpty ? null : _confirmClearLogs,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: _logs.isEmpty
          ? const Center(
              child: Text('No logs yet.'),
            )
          : ListView.separated(
              itemCount: _logs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _logs[index];
                return ListTile(
                  title: Text(
                    item.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_formatTime(item.timestamp)),
                  trailing: Text(
                    _typeText(item.level),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: _typeColor(context, item.level),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                );
              },
            ),
    );
  }
}
