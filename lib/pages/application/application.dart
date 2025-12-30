import 'dart:async';
import 'package:aegis/common/common_image.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/common/common_toast.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/relay_service.dart';
import 'package:aegis/utils/took_kit.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:aegis/utils/platform_utils.dart';
import 'package:aegis/utils/theme_manager.dart';
import 'package:aegis/utils/app_icon_loader.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../db/clientAuthDB_isar.dart';
import '../../navigator/navigator.dart';
import '../../utils/launch_scheme_utils.dart';
import '../../utils/server_nip46_signer.dart';
import '../login/login.dart';
import '../settings/settings.dart';
import '../settings/local_relay_info.dart';
import 'add_application.dart';
import 'application_info.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> with AccountManagerObservers {

  static const double _splitLayoutBreakpoint = 900;

  bool isPortAvailable = true;

  // App version info
  String _appVersion = '';
  String _buildNumber = '';

  // Current selected page in split layout (home, localRelay, accounts)
  String _currentPage = 'home';
  
  // Theme mode for UI updates
  ThemeMode _currentThemeMode = ThemeMode.system;

  List<ValueNotifier<ClientAuthDBISAR>> get clientList {
    final list = AccountManager.sharedInstance.applicationMap.values.toList();
    list.sort((a, b) {
      // Sort by connection status first (connected apps first)
      bool aConnected = _isConnected(a.value);
      bool bConnected = _isConnected(b.value);
      if (!aConnected && bConnected) {
        return 1; // a > b
      }
      if (aConnected && !bConnected) {
        return -1; // a < b
      }
      // If both have same connection status, sort by updateTimestamp (most recent first)
      int aTimestamp = a.value.updateTimestamp ?? a.value.createTimestamp ?? 0;
      int bTimestamp = b.value.updateTimestamp ?? b.value.createTimestamp ?? 0;
      return bTimestamp.compareTo(aTimestamp);
    });
    return list;
  }

  /// Check if application has activity within the last minute
  bool _isConnected(ClientAuthDBISAR client) {
    final timestamp = client.updateTimestamp ?? client.createTimestamp;
    if (timestamp == null) return false;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneMinuteAgo = now - (60 * 1000); // 1 minute in milliseconds
    
    return timestamp >= oneMinuteAgo;
  }

  /// Get first letter of name
  String _getFirstLetter(String name) {
    if (name.isEmpty) return '?';
    // Handle special case for names starting with 0x
    if (name.startsWith('0x')) {
      return '0';
    }
    return name[0].toUpperCase();
  }

  /// Build initial letter icon
  Widget _buildInitialIcon(String name, double size) {
    final letter = _getFirstLetter(name);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Timer? _statusUpdateTimer;

  @override
  void initState() {
    super.initState();
    LaunchSchemeUtils.getSchemeData();
    AccountManager.sharedInstance.addObserver(this);

    // Initialize theme mode
    _currentThemeMode = ThemeManager.themeMode;
    ThemeManager.themeNotifier.addListener(_onThemeChanged);

    // Retrieve version info
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() {
          _appVersion = info.version;
          _buildNumber = info.buildNumber;
        });
      }
    });

    // Update connection status every 5 seconds
    _statusUpdateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _statusUpdateTimer?.cancel();
    AccountManager.sharedInstance.removeObserver(this);
    ThemeManager.themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {
        _currentThemeMode = ThemeManager.themeMode;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool useSplitLayout =
        PlatformUtils.isDesktop || screenWidth >= _splitLayoutBreakpoint;

    // Wide layout with split screen
    if (useSplitLayout) {
      return Scaffold(
        body: Row(
          children: [
            // Left sidebar menu
            _buildSideMenu(context, useSplitLayout: true),
            // Right main content area
            Expanded(
              child: _buildRightPanelContent(context),
            ),
          ],
        ),
      );
    }
    
    // Mobile layout with drawer
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 250,
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonImage(
                      iconName: 'more_icon.png',
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ).setPaddingOnly(left: 20.0,right: 8.0),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => AegisNavigator.pushPage(context, (context) => const Settings()),
            child: CommonImage(
              iconName: 'user_icon.png',
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ).setPaddingOnly(right: 16.0),
          ),
        ],
      ),
      drawer: _buildMobileDrawer(context),
      body: _buildMainContent(context),
    );
  }

  // Build wide layout sidebar menu
  Widget _buildSideMenu(BuildContext context, {bool useSplitLayout = false}) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Aegis - Nostr Signer',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const Divider(height: 1),
            // Menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    selected: useSplitLayout && _currentPage == 'home',
                    selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text(
                      'Home',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: Icon(
                      Icons.home,
                      size: 22,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      if (useSplitLayout) {
                        setState(() {
                          _currentPage = 'home';
                        });
                      }
                    },
                  ),
                  ListTile(
                    selected: useSplitLayout && _currentPage == 'localRelay',
                    selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text(
                      'Local Relay',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: CommonImage(
                      iconName: 'relays_icon.png',
                      size: 22,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      if (useSplitLayout) {
                        setState(() {
                          _currentPage = 'localRelay';
                        });
                      } else {
                        AegisNavigator.pushPage(
                          context,
                          (context) => const LocalRelayInfo(),
                        );
                      }
                    },
                  ),
                  _buildThemeSettingsTile(context, useSplitLayout),
                  ListTile(
                    selected: useSplitLayout && _currentPage == 'accounts',
                    selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text(
                      'Accounts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: CommonImage(
                      iconName: 'user_icon.png',
                      size: 22,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      if (useSplitLayout) {
                        setState(() {
                          _currentPage = 'accounts';
                        });
                      } else {
                        AegisNavigator.pushPage(context, (context) => const Settings());
                      }
                    },
                  ),
                ],
              ),
            ),
            // Bottom row: Github (left) and Version (right)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Github on left
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Github',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      leading: CommonImage(
                        iconName: 'github_icon.png',
                        size: 22,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onTap: () async {
                        final Uri fallbackUri = Uri.parse('https://github.com/ZharlieW/Aegis');
                        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
                      },
                    ),
                  ),
                  // Version on right
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _appVersion.isNotEmpty && _buildNumber.isNotEmpty
                            ? 'v$_appVersion($_buildNumber)'
                            : _appVersion.isNotEmpty
                                ? 'v$_appVersion'
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

  // Build theme settings tile
  Widget _buildThemeSettingsTile(BuildContext context, bool useSplitLayout) {
    IconData themeIcon;
    
    switch (_currentThemeMode) {
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
        'Theme',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Icon(
        themeIcon,
        size: 22,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () async {
        // Cycle through: Light -> Dark -> System -> Light
        ThemeMode nextMode;
        String modeText;
        switch (_currentThemeMode) {
          case ThemeMode.light:
            nextMode = ThemeMode.dark;
            modeText = 'Dark Mode';
            break;
          case ThemeMode.dark:
            nextMode = ThemeMode.system;
            modeText = 'System Default';
            break;
          case ThemeMode.system:
            nextMode = ThemeMode.light;
            modeText = 'Light Mode';
            break;
        }
        await ThemeManager.setThemeMode(nextMode);
        if (mounted) {
          CommonToast.instance.show(context, 'Switched to $modeText', toastType: ToastType.normal);
        }
      },
    );
  }

  // Build mobile drawer menu
  Widget _buildMobileDrawer(BuildContext context) {
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
                      'Aegis - Nostr Signer',
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
              'Local Relay',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: CommonImage(
              iconName: 'relays_icon.png',
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              AegisNavigator.pushPage(
                context,
                (context) => const LocalRelayInfo(),
              );
            },
          ),
          _buildThemeSettingsTile(context, false),
          ListTile(
            title: Text(
              'Github',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: CommonImage(
              iconName: 'github_icon.png',
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () async {
              Navigator.pop(context); // Close drawer
              final Uri fallbackUri = Uri.parse('https://github.com/ZharlieW/Aegis');
              await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            title: Text(
              'Version: ${_appVersion.isNotEmpty ? _appVersion : '--'}${_buildNumber.isNotEmpty ? ' ($_buildNumber)' : ''}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: CommonImage(
              iconName: 'version_icon.png',
              size: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
            },
          ),
        ],
      ),
    );
  }

  // Build right panel content based on current page
  Widget _buildRightPanelContent(BuildContext context) {
    switch (_currentPage) {
      case 'localRelay':
        return const LocalRelayInfo();
      case 'accounts':
        return const Settings();
      case 'home':
      default:
        return _buildMainContent(context);
    }
  }

  // Build main content area
  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: RelayService.instance.serverNotifier,
                  builder: (context, value, child) {
                    return Expanded(
                      child: !value
                          ? _showPortUnAvailableWidget()
                          : _applicationList(clientList),
                    );
                  },
                ),
              ],
            ).setPaddingOnly(top: 12.0),
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Account account = Account.sharedInstance;
                  bool isEmpty = account.currentPubkey.isEmpty ||
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
                    color:  Theme.of(context).colorScheme.secondaryContainer,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _applicationList(
      List<ValueNotifier<ClientAuthDBISAR>> applicationList) {
    final filterApplication = applicationList
        .where((notifier) => notifier.value.pubkey == Account.sharedInstance.currentPubkey)
        .toList();
    if (filterApplication.isEmpty) return _noBunkerSocketWidget();
    return SingleChildScrollView(
      child: Column(
        children:
        filterApplication.map((ValueNotifier<ClientAuthDBISAR> dbNotifier) {
          return ValueListenableBuilder(
              valueListenable: dbNotifier,
              builder: (context, value, child) {
                // Use updateTimestamp if available, otherwise fall back to createTimestamp
                int timestamp = value.updateTimestamp ?? value.createTimestamp ?? DateTime.now().millisecondsSinceEpoch;
                bool isBunker = value.connectionType == EConnectionType.bunker.toInt;
                String connectType = isBunker ? EConnectionType.bunker.toStr : EConnectionType.nostrconnect.toStr;
                
                // Check if application has activity within the last minute
                bool isConnect = _isConnected(value);

                Widget iconWidget() {
                  return AppIconLoader.buildIcon(
                    imageUrl: value.image,
                    appName: value.name ?? '?',
                    size: 40,
                    fallback: _buildInitialIcon(value.name ?? '?', 40),
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(20),
                  ).setPaddingOnly(right: 8.0);
                }

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    AegisNavigator.pushPage(
                      context,
                      (context) => ApplicationInfo(clientAuthDBISAR: value),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    height: 72,
                    child: Row(
                      children: [
                        iconWidget(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  value.name ?? '--',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  connectType,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              TookKit.formatTimestamp(timestamp),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isConnect
                                        ? Colors.greenAccent
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ).setPaddingOnly(right: 8.0),
                                Text(
                                  isConnect ? 'Connected' : 'Disconnected',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }).toList(),
      ),
    );
  }

  Widget _noBunkerSocketWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Center(
              child: Text(
                'Congratulations!\n\nNow you can start using apps that support Aegis!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showPortUnAvailableWidget() {
    return Center(
      child: Column(
        children: [
          Text(
            'The local relay is set to use port ${PlatformUtils.isDesktop ? 18081 : 8081}, but it appears another app is already using this port. Please close the conflicting app and try again.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ).setPadding(
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              onPressed: () async {
                final defaultPort = PlatformUtils.isDesktop ? '18081' : '8081';
                await ServerNIP46Signer.instance.start(defaultPort);
                RelayService.instance.serverNotifier.addListener(() {
                  bool isConnect = RelayService.instance.serverNotifier.value;
                  if (mounted) {
                    CommonTips.success(
                      context,
                      isConnect ? 'NIP-46 Signer started!' : 'Failed to start.',
                    );
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              label: Text(
                "Retry",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void didRemoveApplicationMap() {
    // TODO: implement didRemoveApplicationMap
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didAddApplicationMap() {
    // TODO: implement didAddApplicationMap
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateApplicationMap() {
    // TODO: implement didAddApplicationMap
    if (mounted) {
      setState(() {});
    }
  }


}
