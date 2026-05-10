import 'package:aegis/services/app_log_service.dart';
import 'package:flutter/material.dart';

class AppLogsPage extends StatefulWidget {
  const AppLogsPage({super.key});

  @override
  State<AppLogsPage> createState() => _AppLogsPageState();
}

class _AppLogsPageState extends State<AppLogsPage> {
  List<AppLogEntry> _logs = const <AppLogEntry>[];
  AppLogLevel? _selectedLevel;
  final TextEditingController _summaryFilterController =
      TextEditingController();

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

  @override
  void dispose() {
    _summaryFilterController.dispose();
    super.dispose();
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

  List<AppLogEntry> get _filteredLogs {
    final query = _summaryFilterController.text.trim().toLowerCase();
    if (_selectedLevel == null && query.isEmpty) {
      return _logs;
    }

    return _logs.where((log) {
      final matchesLevel =
          _selectedLevel == null || log.level == _selectedLevel;
      final matchesSummary =
          query.isEmpty || log.summary.toLowerCase().contains(query);
      return matchesLevel && matchesSummary;
    }).toList(growable: false);
  }

  Widget _buildFilters(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _summaryFilterController,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search summary',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _summaryFilterController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _summaryFilterController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear search',
                    ),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ChoiceChip(
                label: const Text('ALL'),
                selected: _selectedLevel == null,
                onSelected: (_) => setState(() => _selectedLevel = null),
              ),
              for (final level in AppLogLevel.values)
                ChoiceChip(
                  label: Text(_typeText(level)),
                  selected: _selectedLevel == level,
                  selectedColor:
                      _typeColor(context, level).withValues(alpha: 0.18),
                  labelStyle: TextStyle(
                    color: _selectedLevel == level
                        ? _typeColor(context, level)
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  onSelected: (_) => setState(() => _selectedLevel = level),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogList(BuildContext context, List<AppLogEntry> logs) {
    if (logs.isEmpty) {
      return const Center(
        child: Text('No matching logs.'),
      );
    }

    return ListView.separated(
      itemCount: logs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = logs[index];
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _filteredLogs;

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
          : Column(
              children: [
                _buildFilters(context),
                const Divider(height: 1),
                Expanded(child: _buildLogList(context, filteredLogs)),
              ],
            ),
    );
  }
}
