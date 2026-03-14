import 'package:flutter/material.dart';

import 'package:aegis/common/common_image.dart';
import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/app_icon_loader.dart';

/// Page that shows the permissions/capabilities granted to a connected application
/// (NIP-46 / Nostr Connect: get_public_key, sign_event, encrypt/decrypt).
class ApplicationPermissionsPage extends StatelessWidget {
  final ClientAuthDBISAR clientAuthDBISAR;

  const ApplicationPermissionsPage({
    super.key,
    required this.clientAuthDBISAR,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                imageUrl: clientAuthDBISAR.image,
                appName: clientAuthDBISAR.name ?? '?',
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
                clientAuthDBISAR.name ?? '--',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.permissionsPageDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              _PermissionItem(
                icon: Icons.vpn_key_outlined,
                title: l10n.permissionAccessPubkey,
              ),
              _PermissionItem(
                icon: Icons.draw_outlined,
                title: l10n.permissionSignEvents,
              ),
              _PermissionItem(
                icon: Icons.lock_outline,
                title: l10n.permissionEncryptDecrypt,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PermissionItem({
    required this.icon,
    required this.title,
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
        children: [
          Icon(
            icon,
            size: 24,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
