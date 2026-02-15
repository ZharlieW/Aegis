import 'package:aegis/common/common_image.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/pages/browser/browser_page.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/pages/login/login.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/pages/application/add_application.dart';

/// Home tab content: segment selector, list content, and FAB.
class ApplicationHomeContent extends StatelessWidget {
  const ApplicationHomeContent({
    super.key,
    required this.showSegmentSelector,
    required this.selectedSegment,
    required this.onSegmentChanged,
    required this.listContent,
    required this.onClearNip07Cache,
  });

  final bool showSegmentSelector;
  final int selectedSegment;
  final void Function(int) onSegmentChanged;
  final Widget listContent;
  final VoidCallback onClearNip07Cache;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (showSegmentSelector) _buildSegmentSelector(context),
            Expanded(
              child: listContent,
            ),
          ],
        ).setPaddingOnly(top: 12.0),
        Positioned(
          bottom: 16,
          right: 16,
          child: _buildFab(context),
        ),
      ],
    );
  }

  Widget _buildSegmentSelector(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SegmentedButton<int>(
        segments: [
          ButtonSegment(
            value: 0,
            label: Text(AppLocalizations.of(context)!.remote),
            icon: const Icon(Icons.cloud_outlined),
          ),
          ButtonSegment(
            value: 1,
            label: Text(AppLocalizations.of(context)!.browser),
            icon: const Icon(Icons.language),
          ),
        ],
        selected: {selectedSegment},
        onSelectionChanged: (Set<int> newSelection) {
          onSegmentChanged(newSelection.first);
          if (newSelection.first == 1) {
            onClearNip07Cache();
          }
        },
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectedSegment == 1) {
          AegisNavigator.pushPage(
            context,
            (context) => const BrowserPage(),
          );
          return;
        }
        final account = Account.sharedInstance;
        final isEmpty = account.currentPubkey.isEmpty ||
            account.currentPrivkey.isEmpty;
        AegisNavigator.pushPage(
          context,
          (context) =>
              isEmpty ? const Login() : const AddApplication(),
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(56),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.14 * 255).round()),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: CommonImage(
            iconName: 'add_icon.png',
            size: 36,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

/// Compact segment selector for AppBar (mobile).
class ApplicationHomeSegmentSelector extends StatelessWidget {
  const ApplicationHomeSegmentSelector({
    super.key,
    required this.selectedSegment,
    required this.onSegmentChanged,
    required this.onClearNip07Cache,
  });

  final int selectedSegment;
  final void Function(int) onSegmentChanged;
  final VoidCallback onClearNip07Cache;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 220),
        child: SegmentedButton<int>(
          style: SegmentedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 36),
            visualDensity: VisualDensity.compact,
          ),
          segments: [
            ButtonSegment(
              value: 0,
              label: Text(
                  AppLocalizations.of(context)!.remote,
                  style: const TextStyle(fontSize: 13)),
              icon: const Icon(Icons.cloud_outlined, size: 16),
            ),
            ButtonSegment(
              value: 1,
              label: Text(
                  AppLocalizations.of(context)!.browser,
                  style: const TextStyle(fontSize: 13)),
              icon: const Icon(Icons.language, size: 16),
            ),
          ],
          selected: {selectedSegment},
          onSelectionChanged: (Set<int> newSelection) {
            onSegmentChanged(newSelection.first);
            if (newSelection.first == 1) {
              onClearNip07Cache();
            }
          },
        ),
      ),
    );
  }
}
