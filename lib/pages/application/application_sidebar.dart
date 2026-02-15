import 'package:aegis/common/common_image.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/pages/settings/language_page.dart';
import 'package:aegis/pages/settings/local_relay_info.dart';
import 'package:aegis/pages/settings/settings.dart';
import 'package:aegis/pages/browser/browser_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Sidebar and drawer menu for Application. Receives state and callbacks from parent.
class ApplicationSidebar extends StatelessWidget {
  const ApplicationSidebar({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
    required this.appVersion,
    required this.buildNumber,
    required this.currentThemeMode,
    required this.onThemeTap,
    required this.languageLabel,
    required this.useSplitLayout,
  });

  final String currentPage;
  final void Function(String) onPageSelected;
  final String appVersion;
  final String buildNumber;
  final ThemeMode currentThemeMode;
  final VoidCallback onThemeTap;
  final String languageLabel;
  final bool useSplitLayout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)!.appSubtitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _menuTile(
                    context,
                    page: 'home',
                    label: AppLocalizations.of(context)!.home,
                    icon: Icons.home,
                    useIconImage: false,
                  ),
                  _menuTile(
                    context,
                    page: 'localRelay',
                    label: AppLocalizations.of(context)!.localRelay,
                    icon: Icons.link,
                    useIconImage: true,
                    iconName: 'relays_icon.png',
                    onTapCustom: useSplitLayout
                        ? null
                        : () => AegisNavigator.pushPage(
                              context,
                              (context) => const LocalRelayInfo(),
                            ),
                  ),
                  _menuTile(
                    context,
                    page: 'browser',
                    label: AppLocalizations.of(context)!.browser,
                    icon: Icons.language,
                    useIconImage: false,
                    onTapCustom: useSplitLayout
                        ? null
                        : () => AegisNavigator.pushPage(
                              context,
                              (context) => const BrowserPage(),
                            ),
                  ),
                  _buildThemeSettingsTile(context),
                  _buildLanguageTile(context),
                  _menuTile(
                    context,
                    page: 'accounts',
                    label: AppLocalizations.of(context)!.accounts,
                    icon: Icons.person,
                    useIconImage: true,
                    iconName: 'user_icon.png',
                    onTapCustom: useSplitLayout
                        ? null
                        : () => AegisNavigator.pushPage(
                              context,
                              (context) => const Settings(),
                            ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        AppLocalizations.of(context)!.github,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      leading: CommonImage(
                        iconName: 'github_icon.png',
                        size: 22,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onTap: () async {
                        final Uri uri =
                            Uri.parse('https://github.com/ZharlieW/Aegis');
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        appVersion.isNotEmpty && buildNumber.isNotEmpty
                            ? '${AppLocalizations.of(context)!.version}: $appVersion($buildNumber)'
                            : appVersion.isNotEmpty
                                ? '${AppLocalizations.of(context)!.version}: $appVersion'
                                : '--',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required String page,
    required String label,
    required IconData icon,
    bool useIconImage = false,
    String? iconName,
    VoidCallback? onTapCustom,
  }) {
    final selected = useSplitLayout && currentPage == page;
    return ListTile(
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      trailing: useIconImage && iconName != null
          ? CommonImage(
              iconName: iconName,
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : Icon(
              icon,
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      onTap: () {
        if (useSplitLayout) {
          onPageSelected(page);
        } else if (onTapCustom != null) {
          onTapCustom();
        }
      },
    );
  }

  Widget _buildThemeSettingsTile(BuildContext context) {
    IconData themeIcon;
    switch (currentThemeMode) {
      case ThemeMode.light:
        themeIcon = Icons.light_mode;
        break;
      case ThemeMode.dark:
        themeIcon = Icons.dark_mode;
        break;
      case ThemeMode.system:
        themeIcon = Icons.brightness_auto;
        break;
    }
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.theme,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Icon(
        themeIcon,
        size: 22,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onThemeTap,
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.language,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text(
        languageLabel,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () =>
          AegisNavigator.pushPage(context, (context) => const LanguagePage()),
    );
  }
}

/// Drawer content for mobile. Same menu items, with Navigator.pop before navigation where needed.
class ApplicationDrawer extends StatelessWidget {
  const ApplicationDrawer({
    super.key,
    required this.appVersion,
    required this.buildNumber,
    required this.currentThemeMode,
    required this.onThemeTap,
    required this.languageLabel,
  });

  final String appVersion;
  final String buildNumber;
  final ThemeMode currentThemeMode;
  final VoidCallback onThemeTap;
  final String languageLabel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppLocalizations.of(context)!.appSubtitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.localRelay,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: CommonImage(
              iconName: 'relays_icon.png',
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              Navigator.pop(context);
              AegisNavigator.pushPage(
                context,
                (context) => const LocalRelayInfo(),
              );
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.browser,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Icon(
              Icons.language,
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              Navigator.pop(context);
              AegisNavigator.pushPage(
                context,
                (context) => const BrowserPage(),
              );
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.theme,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Icon(
              currentThemeMode == ThemeMode.light
                  ? Icons.light_mode
                  : currentThemeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: onThemeTap,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.language,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Text(
              languageLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              AegisNavigator.pushPage(
                  context, (context) => const LanguagePage());
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.github,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: CommonImage(
              iconName: 'github_icon.png',
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () async {
              Navigator.pop(context);
              final Uri uri =
                  Uri.parse('https://github.com/ZharlieW/Aegis');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            title: Text(
              '${AppLocalizations.of(context)!.version}: ${appVersion.isNotEmpty ? appVersion : '--'}${buildNumber.isNotEmpty ? ' ($buildNumber)' : ''}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: CommonImage(
              iconName: 'version_icon.png',
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
