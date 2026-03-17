import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import 'package:aegis/common/common_image.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';

class RequestPermission extends StatefulWidget {
  /// When true (e.g. first-time connect), show "fully trust" vs "approve each" and return both granted and fullTrust.
  /// When false (manual approval for one action), show only allow/reject.
  final bool isInitialConnect;

  /// Optional description for the specific action being requested (used when isInitialConnect is false).
  final String? permissionDescription;

  const RequestPermission({
    super.key,
    this.isInitialConnect = true,
    this.permissionDescription,
  });

  @override
  RequestPermissionState createState() => RequestPermissionState();
}

class RequestPermissionState extends State<RequestPermission> {
  /// Selected trust mode when isInitialConnect: true = fully trust, false = approve each manually.
  bool _fullTrust = true;
  /// Whether user wants to always allow this specific permission type in the future.
  bool _alwaysAllowThisPermission = false;

  void _popReject() {
    AegisNavigator.pop(context, null);
  }

  void _popGrant() {
    AegisNavigator.pop(
      context,
      AuthResult(
        granted: true,
        fullTrust: widget.isInitialConnect ? _fullTrust : false,
        rememberedMethodKey: (!widget.isInitialConnect &&
                widget.permissionDescription != null &&
                _alwaysAllowThisPermission)
            ? widget.permissionDescription
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: _popReject,
          child: Center(
            child: CommonImage(
              iconName: 'title_close_icon.png',
              size: 32,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.permissionRequest,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CommonImage(
                      iconName: 'aegis_logo.png',
                      size: 100,
                    ).setPaddingOnly(
                      top: 24.0,
                      bottom: 20.0,
                    ),
                  ),
                  Text(
                    widget.isInitialConnect
                        ? AppLocalizations.of(context)!.permissionRequestContent
                        : AppLocalizations.of(context)!.approveActionRequest,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ).setPadding(const EdgeInsets.symmetric(vertical: 20)),
                  if (!widget.isInitialConnect &&
                      widget.permissionDescription != null &&
                      widget.permissionDescription!.isNotEmpty)
                    Text(
                      widget.permissionDescription!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ).setPadding(const EdgeInsets.only(bottom: 12)),
                  if (!widget.isInitialConnect)
                    SwitchListTile(
                      value: _alwaysAllowThisPermission,
                      onChanged: (v) =>
                          setState(() => _alwaysAllowThisPermission = v),
                      title: Text(
                        AppLocalizations.of(context)!
                            .alwaysAllowThisPermission,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ).setPadding(const EdgeInsets.only(bottom: 16)),
                  if (widget.isInitialConnect) _trustModeOptions() else const SizedBox.shrink(),
                  if (widget.isInitialConnect) const SizedBox(height: 16) else const SizedBox.shrink(),
                  if (widget.isInitialConnect) _permissionInfoWidget() else const SizedBox.shrink(),
                  if (widget.isInitialConnect) const SizedBox(height: 32) else const SizedBox(height: 24),
                  FilledButton.tonal(
                    onPressed: _popGrant,
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.grantPermissions,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: _popReject,
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.reject,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _trustModeOptions() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioListTile<bool>(
            value: true,
            groupValue: _fullTrust,
            onChanged: (v) => setState(() => _fullTrust = true),
            title: Text(
              l10n.authTrustFully,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            subtitle: Text(
              l10n.authTrustFullyHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<bool>(
            value: false,
            groupValue: _fullTrust,
            onChanged: (v) => setState(() => _fullTrust = false),
            title: Text(
              l10n.authManualEach,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            subtitle: Text(
              l10n.authManualEachHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _permissionInfoWidget() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                _fullTrust ? l10n.fullAccessGranted : l10n.authManualEach,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _fullTrust ? l10n.fullAccessHint : l10n.authManualEachHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _permissionItem(l10n.permissionAccessPubkey),
          _permissionItem(l10n.permissionSignEvents),
          _permissionItem(l10n.permissionEncryptDecrypt),
        ],
      ),
    );
  }

  Widget _permissionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
