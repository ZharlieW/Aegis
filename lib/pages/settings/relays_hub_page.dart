import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/utils/connect.dart';
import 'package:aegis/utils/default_profile_relays_store.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Relays overview: live connections from [Connect] + editable default profile relay list.
class RelaysHubPage extends StatefulWidget {
  const RelaysHubPage({super.key});

  @override
  State<RelaysHubPage> createState() => _RelaysHubPageState();
}

class _RelaysHubPageState extends State<RelaysHubPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.relaysHubTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.relaysHubActiveTab),
            Tab(text: l10n.relaysHubDefaultsTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ActiveRelaysTab(),
          _DefaultProfileRelaysTab(),
        ],
      ),
    );
  }
}

class _ActiveRelaysTab extends StatefulWidget {
  const _ActiveRelaysTab();

  @override
  State<_ActiveRelaysTab> createState() => _ActiveRelaysTabState();
}

class _ActiveRelaysTabState extends State<_ActiveRelaysTab> {
  late ConnectStatusCallBack _listener;

  @override
  void initState() {
    super.initState();
    _listener = (relay, status, kinds) {
      if (mounted) setState(() {});
    };
    Connect.sharedInstance.addConnectStatusListener(_listener);
  }

  @override
  void dispose() {
    Connect.sharedInstance.removeConnectStatusListener(_listener);
    super.dispose();
  }

  Future<void> _reconnectOne(String url) async {
    final entry = Connect.sharedInstance.webSockets[url];
    if (entry == null) return;
    final kinds = List<RelayKind>.from(entry.relayKinds);
    await Connect.sharedInstance.closeConnect(url);
    for (final k in kinds) {
      await Connect.sharedInstance.connect(url, relayKind: k);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final entries = Connect.sharedInstance.webSockets.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.relaysHubActiveEmpty,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final e = entries[i];
        final url = e.key;
        final socket = e.value;
        final kinds = socket.relayKinds;
        final status = _relayStatusFor(url);
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SelectableText(
                        url,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyRelayUrl(context, url),
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: l10n.copiedToClipboard,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _relayStatusLabel(status),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: status == _RelayConnectionStatus.connected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (kinds.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: kinds
                        .map(
                          (k) => Chip(
                            label: Text(
                              k.name,
                              style: theme.textTheme.labelSmall,
                            ),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _reconnectOne(url),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(l10n.relaysHubReconnect),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DefaultProfileRelaysTab extends StatefulWidget {
  const _DefaultProfileRelaysTab();

  @override
  State<_DefaultProfileRelaysTab> createState() =>
      _DefaultProfileRelaysTabState();
}

class _DefaultProfileRelaysTabState extends State<_DefaultProfileRelaysTab> {
  List<String> _urls = [];
  bool _loading = true;
  late ConnectStatusCallBack _listener;

  @override
  void initState() {
    super.initState();
    _listener = (relay, status, kinds) {
      if (mounted) setState(() {});
    };
    Connect.sharedInstance.addConnectStatusListener(_listener);
    _load();
  }

  @override
  void dispose() {
    Connect.sharedInstance.removeConnectStatusListener(_listener);
    super.dispose();
  }

  Future<void> _load() async {
    await LocalStorage.init();
    final list = await DefaultProfileRelaysStore.load();
    if (!mounted) return;
    setState(() {
      _urls = list;
      _loading = false;
    });
  }

  Future<void> _persist(List<String> next) async {
    final clean = DefaultProfileRelaysStore.dedupeAndTrim(next);
    await DefaultProfileRelaysStore.save(clean);
    if (!mounted) return;
    setState(() => _urls = clean);
  }

  Future<void> _addOrEdit({int? index}) async {
    final l10n = AppLocalizations.of(context)!;
    final initial = index != null && index < _urls.length ? _urls[index] : '';
    final controller = TextEditingController(text: initial);

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          index == null ? l10n.relaysHubAddRelay : l10n.relaysHubEditRelay,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.relaysHubRelayUrlHint,
            hintText: 'wss://',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    controller.dispose();
    if (result == null || result.isEmpty) return;

    if (!DefaultProfileRelaysStore.isValidRelayUrl(result)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.relaysHubInvalidUrl)),
        );
      }
      return;
    }

    final next = List<String>.from(_urls);
    if (index != null && index < next.length) {
      next[index] = result;
    } else {
      next.add(result);
    }
    await _persist(next);
  }

  Future<void> _removeAt(int index) async {
    final next = List<String>.from(_urls)..removeAt(index);
    await _persist(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            l10n.relaysHubDefaultsDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: _urls.isEmpty
              ? Center(
                  child: Text(
                    l10n.relaysHubDefaultsEmpty,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _urls.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final url = _urls[i];
                    final status = _relayStatusFor(url);
                    return ListTile(
                      title: SelectableText(url),
                      subtitle: Text(
                        _relayStatusLabel(status),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: status == _RelayConnectionStatus.connected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy_outlined),
                            tooltip: l10n.copiedToClipboard,
                            onPressed: () => _copyRelayUrl(context, url),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _addOrEdit(index: i),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () => _removeAt(i),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _addOrEdit(),
                icon: const Icon(Icons.add),
                label: Text(l10n.relaysHubAddRelay),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _RelayConnectionStatus {
  connected,
  disconnected,
  unknown,
}

_RelayConnectionStatus _relayStatusFor(String url) {
  final socket = Connect.sharedInstance.webSockets[url];
  if (socket == null) {
    return _RelayConnectionStatus.unknown;
  }
  return socket.connectStatus == 1
      ? _RelayConnectionStatus.connected
      : _RelayConnectionStatus.disconnected;
}

String _relayStatusLabel(_RelayConnectionStatus status) {
  switch (status) {
    case _RelayConnectionStatus.connected:
      return '已连接';
    case _RelayConnectionStatus.disconnected:
      return '未连接';
    case _RelayConnectionStatus.unknown:
      return '未知';
  }
}

Future<void> _copyRelayUrl(BuildContext context, String url) async {
  final l10n = AppLocalizations.of(context)!;
  await Clipboard.setData(ClipboardData(text: url));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.copiedToClipboard)),
  );
}
