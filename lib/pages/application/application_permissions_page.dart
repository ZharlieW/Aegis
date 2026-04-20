import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aegis/common/common_image.dart';
import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/db/remembered_permission_choice_store.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/app_icon_loader.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/method_usage_stats.dart';

/// Page that shows only the permissions this app declared at connect (URI perms).
/// If [ClientAuthDBISAR.allowedMethods] is empty, shows a short message instead of listing all possible capabilities.
class ApplicationPermissionsPage extends StatefulWidget {
  final ClientAuthDBISAR clientAuthDBISAR;

  const ApplicationPermissionsPage({
    super.key,
    required this.clientAuthDBISAR,
  });

  @override
  State<ApplicationPermissionsPage> createState() =>
      _ApplicationPermissionsPageState();
}

class _ApplicationPermissionsPageState
    extends State<ApplicationPermissionsPage> {
  ClientAuthDBISAR? _app;
  ValueNotifier<ClientAuthDBISAR>? _appNotifier;

  @override
  void initState() {
    super.initState();
    _app = widget.clientAuthDBISAR;
    final client = widget.clientAuthDBISAR;
    final key = client.clientPubkey.isNotEmpty
        ? client.clientPubkey
        : (client.remoteSignerPubkey ?? '');
    _appNotifier = AccountManager.sharedInstance.applicationMap[key];
    WidgetsBinding.instance.addPostFrameCallback((_) => _reloadFromDb());
  }

  Future<void> _reloadFromDb() async {
    final w = widget.clientAuthDBISAR;
    final fresh = await ClientAuthDBISAR.searchFromDB(w.pubkey, w.clientPubkey);
    if (!mounted) return;
    if (fresh != null) {
      AccountManager.sharedInstance.updateApplicationMap(fresh);
      if (fresh.clientPubkey.isNotEmpty) {
        Account.sharedInstance.addAuthToNostrConnectInfo(fresh);
      }
      setState(() => _app = fresh);
    }
  }

  String _usageLine(
    AppLocalizations l10n,
    MethodUsageEntry? entry,
    String localeName,
  ) {
    if (entry == null || entry.count <= 0) {
      return l10n.permissionMethodUsageNever;
    }
    final dt = DateTime.fromMillisecondsSinceEpoch(entry.lastUsedMs);
    final timeStr = DateFormat.yMMMd(localeName).add_Hm().format(dt);
    return l10n.permissionMethodUsageStats(timeStr, entry.count);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = _appNotifier;
    if (notifier != null) {
      return ValueListenableBuilder<ClientAuthDBISAR>(
        valueListenable: notifier,
        builder: (context, client, _) {
          return _buildPage(context, client);
        },
      );
    }
    return _buildPage(context, _app ?? widget.clientAuthDBISAR);
  }

  Widget _buildPage(BuildContext context, ClientAuthDBISAR app) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final localeName = Localizations.localeOf(context).toString();
    final usageStats = MethodUsageStats.parse(app.methodUsageStatsJson);
    final isManualEach = app.authMode == 1;
    final permissionItems = _permissionItems(app);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.viewPermissions,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => AegisNavigator.pop(context),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              AppIconLoader.buildIcon(
                imageUrl: app.image,
                appName: app.name ?? '?',
                size: 56,
                fallback: CommonImage(
                  iconName: 'default_app_icon.png',
                  size: 56,
                ),
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(28),
              ),
              const SizedBox(height: 12),
              Text(
                app.name ?? '--',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                value: isManualEach,
                onChanged: (v) async {
                  final w = widget.clientAuthDBISAR;
                  final row = await ClientAuthDBISAR.searchFromDB(
                      w.pubkey, w.clientPubkey);
                  if (row == null || !context.mounted) return;
                  row.authMode = v ? 1 : 2;
                  // Manual mode: clear pre-granted method keys so prompts run again.
                  // (Otherwise allowedMethods from auto mode keeps bypassing _requireApprovalForApp.)
                  if (v) {
                    row.allowedMethods = [];
                    final appKey = row.clientPubkey.isNotEmpty
                        ? row.clientPubkey
                        : (row.remoteSignerPubkey ?? '');
                    await RememberedPermissionChoiceStore.deleteAllForClient(
                      userPubkey: row.pubkey,
                      clientPubkey: appKey,
                    );
                  }
                  await ClientAuthDBISAR.saveFromDB(row, isUpdate: true);
                  // Re-read so we pass a new object instance: ValueNotifier skips
                  // notifyListeners when value is set to the same reference as before.
                  final synced = await ClientAuthDBISAR.searchFromDB(
                      w.pubkey, w.clientPubkey);
                  if (synced != null) {
                    AccountManager.sharedInstance.updateApplicationMap(synced);
                    if (synced.clientPubkey.isNotEmpty) {
                      Account.sharedInstance.addAuthToNostrConnectInfo(synced);
                    }
                  }
                  await _reloadFromDb();
                },
                title: Text(
                  isManualEach ? l10n.authManualEach : l10n.authTrustFully,
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  isManualEach
                      ? l10n.authManualEachHint
                      : l10n.authTrustFullyHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmResetPermissions(context, l10n),
                  icon: Icon(
                    Icons.restart_alt_outlined,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                  label: Text(
                    l10n.resetPermissions,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: theme.colorScheme.error.withValues(alpha: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                permissionItems.isEmpty
                    ? l10n.permissionsPageNoDeclaredPerms
                    : l10n.permissionsPageDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ...permissionItems.map(
                (item) => _PermissionItem(
                  icon: _iconForMethod(item.method),
                  title: _titleForMethod(l10n, item.method),
                  subtitle:
                      _usageLine(l10n, usageStats[item.method], localeName),
                  sourceLabel: _sourceLabel(
                    localeName: localeName,
                    isDeclared: item.isDeclared,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmResetPermissions(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dL10n.resetPermissions),
          content: Text(dL10n.resetPermissionsConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(dL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(dL10n.confirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) return;

    final w = widget.clientAuthDBISAR;
    final fresh = await ClientAuthDBISAR.searchFromDB(w.pubkey, w.clientPubkey);
    if (fresh == null) return;

    fresh.allowedMethods = [];
    final appKey = fresh.clientPubkey.isNotEmpty
        ? fresh.clientPubkey
        : (fresh.remoteSignerPubkey ?? '');
    await RememberedPermissionChoiceStore.deleteAllForClient(
      userPubkey: fresh.pubkey,
      clientPubkey: appKey,
    );
    await ClientAuthDBISAR.saveFromDB(fresh, isUpdate: true);
    AccountManager.sharedInstance.updateApplicationMap(fresh);
    if (fresh.clientPubkey.isNotEmpty) {
      Account.sharedInstance.addAuthToNostrConnectInfo(fresh);
    }

    if (!context.mounted) return;
    await _reloadFromDb();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.resetPermissionsSuccess)),
    );
  }

  /// Permissions to show, with source labels:
  /// - Declared at connect time (URI perms)
  /// - Runtime-added after first approved usage
  static List<_PermissionViewItem> _permissionItems(ClientAuthDBISAR app) {
    final declaredSet = app.declaredMethods.toSet();
    final allowedSet = app.allowedMethods.toSet();
    allowedSet.add('get_public_key');

    final sorted = allowedSet.toList();
    sortPermissionMethodsInPlace(sorted);

    return sorted
        .map((method) => _PermissionViewItem(
              method: method,
              isDeclared: declaredSet.contains(method),
            ))
        .toList();
  }

  static IconData _iconForMethod(String method) {
    final base = method.contains(':') ? method.split(':').first : method;
    switch (base) {
      case 'get_public_key':
        return Icons.vpn_key_outlined;
      case 'sign_event':
        return Icons.draw_outlined;
      case 'nip04_encrypt':
      case 'nip44_encrypt':
        return Icons.lock_outlined;
      case 'nip04_decrypt':
      case 'nip44_decrypt':
        return Icons.lock_open_outlined;
      case 'decrypt_zap_event':
        return Icons.lock_open_outlined;
      default:
        return Icons.lock_outline;
    }
  }

  static String _titleForMethod(AppLocalizations l10n, String method) {
    if (method.contains(':')) {
      final parts = method.split(':');
      final base = parts.first;
      final kind = parts.length > 1 ? parts[1] : '';
      if (base == 'sign_event' && kind.isNotEmpty) {
        return _titleForSignEventKind(l10n, kind);
      }
    }
    switch (method) {
      case 'get_public_key':
        return l10n.permissionAccessPubkey;
      case 'nip04_encrypt':
        return l10n.permissionNip04Encrypt;
      case 'nip04_decrypt':
        return l10n.permissionNip04Decrypt;
      case 'nip44_encrypt':
        return l10n.permissionNip44Encrypt;
      case 'nip44_decrypt':
        return l10n.permissionNip44Decrypt;
      case 'decrypt_zap_event':
        return l10n.permissionDecryptZapEvent;
      default:
        return method;
    }
  }

  static String _sourceLabel({
    required String localeName,
    required bool isDeclared,
  }) {
    final isChinese = localeName.toLowerCase().startsWith('zh');
    if (isChinese) {
      return isDeclared ? '声明权限' : '运行时新增';
    }
    return isDeclared ? 'Declared permission' : 'Runtime added';
  }

  /// Human-readable title for sign_event by kind (matches Amber-style labels).
  static String _titleForSignEventKind(AppLocalizations l10n, String kind) {
    switch (kind) {
      case '0':
        return l10n.permissionSignKind0;
      case '1':
        return l10n.permissionSignKind1;
      case '3':
        return l10n.permissionSignKind3;
      case '4':
        return l10n.permissionSignKind4;
      case '5':
        return l10n.permissionSignKind5;
      case '6':
        return l10n.permissionSignKind6;
      case '7':
        return l10n.permissionSignKind7;
      case '9734':
        return l10n.permissionSignKind9734;
      case '9735':
        return l10n.permissionSignKind9735;
      case '10000':
        return l10n.permissionSignKind10000;
      case '10002':
        return l10n.permissionSignKind10002;
      case '10003':
        return l10n.permissionSignKind10003;
      case '10013':
        return l10n.permissionSignKind10013;
      case '31234':
        return l10n.permissionSignKind31234;
      case '30078':
        return l10n.permissionSignKind30078;
      case '22242':
        return l10n.permissionSignKind22242;
      case '27235':
        return l10n.permissionSignKind27235;
      case '30023':
        return l10n.permissionSignKind30023;
      default:
        return l10n.permissionSignEventKind(kind);
    }
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String sourceLabel;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.sourceLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    sourceLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionViewItem {
  final String method;
  final bool isDeclared;

  const _PermissionViewItem({
    required this.method,
    required this.isDeclared,
  });
}
