import 'package:flutter/material.dart';

import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/permission_approval_batcher_models.dart';

/// A batch permission dialog that groups multiple pending authorization requests
/// into a single user interaction (Amber-style).
class BatchRequestPermission extends StatefulWidget {
  final String clientPubkey;
  final ValueNotifier<List<BatchPermissionGroupView>> groupsNotifier;
  final bool allowDismiss;

  /// Called by the dialog to update group selection state.
  final void Function(String methodKey, bool selected) onSetSelected;
  final void Function(String methodKey, bool alwaysAllow) onSetAlwaysAllow;

  /// Called when user presses "Grant selected".
  final Future<void> Function() onApproveSelected;

  /// Called when user presses "Reject all" / close button.
  final Future<void> Function() onRejectAll;

  const BatchRequestPermission({
    super.key,
    required this.clientPubkey,
    required this.groupsNotifier,
    this.allowDismiss = false,
    required this.onSetSelected,
    required this.onSetAlwaysAllow,
    required this.onApproveSelected,
    required this.onRejectAll,
  });

  @override
  State<BatchRequestPermission> createState() => _BatchRequestPermissionState();
}

class _BatchRequestPermissionState extends State<BatchRequestPermission> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return PopScope(
      canPop: widget.allowDismiss,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && !widget.allowDismiss) {
          await widget.onRejectAll();
          if (!mounted) return;
          AegisNavigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () async {
              await widget.onRejectAll();
              if (!mounted) return;
              AegisNavigator.pop(context);
            },
            child: Center(
              child: Icon(
                Icons.close,
                size: 22,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          title: Text(
            l10n.permissionRequest,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ValueListenableBuilder<List<BatchPermissionGroupView>>(
                      valueListenable: widget.groupsNotifier,
                      builder: (context, groups, _) {
                        final totalRequests = groups.fold<int>(
                          0,
                          (sum, g) => sum + g.count,
                        );
                        return Column(
                          children: [
                            Text(
                              l10n.batchPermissionRequestsCount(totalRequests),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                    ValueListenableBuilder<List<BatchPermissionGroupView>>(
                      valueListenable: widget.groupsNotifier,
                      builder: (context, groups, _) {
                        if (groups.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            ...groups.map((g) => _PermissionTypeRow(
                                  group: g,
                                  onSetSelected: widget.onSetSelected,
                                  onSetAlwaysAllow: widget.onSetAlwaysAllow,
                                )),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    ),
                    // Disable grant when no permission group is selected (checkbox unchecked).
                    ValueListenableBuilder<List<BatchPermissionGroupView>>(
                      valueListenable: widget.groupsNotifier,
                      builder: (context, groups, _) {
                        final hasGrantSelection =
                            groups.any((g) => g.selected);
                        return FilledButton.tonal(
                          onPressed: !hasGrantSelection
                              ? null
                              : () async {
                                  await widget.onApproveSelected();
                                  if (!mounted) return;
                                  AegisNavigator.pop(context);
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            disabledBackgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Text(
                              l10n.grantPermissions,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: hasGrantSelection
                                    ? Colors.white
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: () async {
                        await widget.onRejectAll();
                        if (!mounted) return;
                        AegisNavigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceContainer,
                      ),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.reject,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionTypeRow extends StatelessWidget {
  final BatchPermissionGroupView group;
  final void Function(String methodKey, bool selected) onSetSelected;
  final void Function(String methodKey, bool alwaysAllow) onSetAlwaysAllow;

  const _PermissionTypeRow({
    required this.group,
    required this.onSetSelected,
    required this.onSetAlwaysAllow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: group.selected,
                onChanged: (v) => onSetSelected(group.methodKey, v ?? false),
              ),
              Expanded(
                child: Text(
                  group.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Text(
                'x${group.count}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SwitchListTile(
            value: group.alwaysAllow,
            onChanged: (v) => onSetAlwaysAllow(group.methodKey, v),
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              AppLocalizations.of(context)!.alwaysAllowThisPermission,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

