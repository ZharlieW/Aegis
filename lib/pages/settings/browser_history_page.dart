import 'package:aegis/utils/browser_history_store.dart';
import 'package:flutter/material.dart';

class BrowserHistoryPage extends StatefulWidget {
  const BrowserHistoryPage({super.key});

  @override
  State<BrowserHistoryPage> createState() => _BrowserHistoryPageState();
}

class _BrowserHistoryPageState extends State<BrowserHistoryPage> {
  List<String> _urls = const <String>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final urls = await BrowserHistoryStore.load();
    if (!mounted) return;
    setState(() {
      _urls = urls;
      _loading = false;
    });
  }

  Future<void> _remove(String url) async {
    await BrowserHistoryStore.remove(url);
    await _load();
  }

  Future<void> _clearAll() async {
    await BrowserHistoryStore.clear();
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Browser history cleared.')),
    );
  }

  Future<void> _confirmClearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear browser history'),
        content: const Text(
            'This removes saved recent URLs only. Open WebViews are not affected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browser History'),
        actions: [
          IconButton(
            onPressed: _urls.isEmpty ? null : _confirmClearAll,
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _urls.isEmpty
              ? Center(
                  child: Text(
                    'No browser history yet.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: _urls.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final url = _urls[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(
                        url,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: () => _remove(url),
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete',
                      ),
                    );
                  },
                ),
    );
  }
}
