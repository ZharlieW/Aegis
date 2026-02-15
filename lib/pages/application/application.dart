import 'dart:async';
import 'dart:convert';
import 'package:aegis/common/common_image.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/common/common_toast.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/relay_service.dart';
import 'package:aegis/utils/tool_kit.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:aegis/utils/platform_utils.dart';
import 'package:aegis/utils/theme_manager.dart';
import 'package:aegis/utils/locale_manager.dart';
import 'package:aegis/utils/app_icon_loader.dart';
import 'package:aegis/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:aegis/pages/settings/settings.dart';
import 'package:aegis/pages/settings/local_relay_info.dart';
import 'package:aegis/pages/browser/browser_page.dart';
import 'package:aegis/pages/activities/activities.dart';
import 'package:aegis/pages/application/application_info.dart';
import 'package:aegis/pages/application/application_sidebar.dart';
import 'package:aegis/pages/application/application_home_content.dart';
import 'package:nostr_rust/src/rust/api/relay.dart' as rust_relay;

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
  
  // Selected segment for home page (0: NIP-46, 1: NIP-07)
  int _selectedSegment = 0;
  
  // Theme mode for UI updates
  ThemeMode _currentThemeMode = ThemeMode.system;

  // For Android: track relay status via isRelayRunning()
  ValueNotifier<bool>? _androidRelayStatusNotifier;
  Timer? _androidRelayStatusTimer;

  // Cache for NIP-07 applications future to prevent flickering
  Future<Map<String, Map<String, dynamic>>>? _nip07ApplicationsFuture;

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
    

    // On Android, periodically check relay status via isRelayRunning()
    if (PlatformUtils.isAndroid) {
      _androidRelayStatusNotifier = ValueNotifier<bool>(false);
      _checkAndroidRelayStatus(); // Initial check
      _androidRelayStatusTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        _checkAndroidRelayStatus();
      });
    }
  }

  Future<void> _checkAndroidRelayStatus() async {
    if (!PlatformUtils.isAndroid || _androidRelayStatusNotifier == null) return;
    try {
      final isRunning = await rust_relay.isRelayRunning();
      if (_androidRelayStatusNotifier!.value != isRunning) {
        _androidRelayStatusNotifier!.value = isRunning;
      }
    } catch (e) {
      // Ignore errors, keep current status
    }
  }

  @override
  void dispose() {
    _statusUpdateTimer?.cancel();
    _androidRelayStatusTimer?.cancel();
    _androidRelayStatusNotifier?.dispose();
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
        leadingWidth: 56,
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Center(
              child: CommonImage(
                iconName: 'more_icon.png',
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        title: _currentPage == 'home'
            ? ApplicationHomeSegmentSelector(
                selectedSegment: _selectedSegment,
                onSegmentChanged: (v) => setState(() {
                  _selectedSegment = v;
                  if (v == 1) _nip07ApplicationsFuture = null;
                }),
                onClearNip07Cache: () => _nip07ApplicationsFuture = null,
              )
            : null,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => AegisNavigator.pushPage(context, (context) => const Settings()),
            child: Center(
              child: CommonImage(
                iconName: 'user_icon.png',
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ).setPaddingOnly(right: 16.0),
        ],
      ),
      drawer: _buildMobileDrawer(context),
      body: _buildMainContent(context),
    );
  }

  void _onThemeCycleTap() {
    final l10n = AppLocalizations.of(context)!;
    ThemeMode nextMode;
    String modeText;
    switch (_currentThemeMode) {
      case ThemeMode.light:
        nextMode = ThemeMode.dark;
        modeText = l10n.darkMode;
        break;
      case ThemeMode.dark:
        nextMode = ThemeMode.system;
        modeText = l10n.systemDefault;
        break;
      case ThemeMode.system:
        nextMode = ThemeMode.light;
        modeText = l10n.lightMode;
        break;
    }
    ThemeManager.setThemeMode(nextMode);
    if (mounted) {
      CommonToast.instance.show(context, l10n.switchedTo(modeText), toastType: ToastType.normal);
    }
  }

  // Build wide layout sidebar menu
  Widget _buildSideMenu(BuildContext context, {bool useSplitLayout = false}) {
    final l10n = AppLocalizations.of(context)!;
    final languageLabel = _languageLabelForLocale(l10n, LocaleManager.currentLocale);
    return ApplicationSidebar(
      currentPage: _currentPage,
      onPageSelected: (p) => setState(() => _currentPage = p),
      appVersion: _appVersion,
      buildNumber: _buildNumber,
      currentThemeMode: _currentThemeMode,
      onThemeTap: _onThemeCycleTap,
      languageLabel: languageLabel,
      useSplitLayout: useSplitLayout,
    );
  }

  String _languageLabelForLocale(AppLocalizations l10n, Locale? locale) {
    if (locale == null) return '${l10n.language} (${l10n.english})';
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') return l10n.traditionalChinese;
    switch (locale.languageCode) {
      case 'en': return l10n.english;
      case 'zh': return l10n.simplifiedChinese;
      case 'ja': return l10n.japanese;
      case 'ko': return l10n.korean;
      case 'es': return l10n.spanish;
      case 'fr': return l10n.french;
      case 'de': return l10n.german;
      case 'pt': return l10n.portuguese;
      case 'ru': return l10n.russian;
      case 'ar': return l10n.arabic;
      case 'az': return l10n.azerbaijani;
      case 'bg': return l10n.bulgarian;
      case 'ca': return l10n.catalan;
      case 'cs': return l10n.czech;
      case 'da': return l10n.danish;
      case 'el': return l10n.greek;
      case 'et': return l10n.estonian;
      case 'fa': return l10n.farsi;
      case 'hi': return l10n.hindi;
      case 'hu': return l10n.hungarian;
      case 'id': return l10n.indonesian;
      case 'it': return l10n.italian;
      case 'lv': return l10n.latvian;
      case 'nl': return l10n.dutch;
      case 'pl': return l10n.polish;
      case 'sv': return l10n.swedish;
      case 'th': return l10n.thai;
      case 'tr': return l10n.turkish;
      case 'uk': return l10n.ukrainian;
      case 'ur': return l10n.urdu;
      case 'vi': return l10n.vietnamese;
      default: return locale.toString();
    }
  }

  // Build mobile drawer menu
  Widget _buildMobileDrawer(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageLabel = _languageLabelForLocale(l10n, LocaleManager.currentLocale);
    return ApplicationDrawer(
      appVersion: _appVersion,
      buildNumber: _buildNumber,
      currentThemeMode: _currentThemeMode,
      onThemeTap: _onThemeCycleTap,
      languageLabel: languageLabel,
    );
  }

  // Build right panel content based on current page
  Widget _buildRightPanelContent(BuildContext context) {
    switch (_currentPage) {
      case 'localRelay':
        return const LocalRelayInfo();
      case 'browser':
        return const BrowserPage();
      case 'accounts':
        return const Settings();
      case 'home':
      default:
        return _buildMainContent(context);
    }
  }

  // Build main content area
  Widget _buildMainContent(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool useSplitLayout =
        PlatformUtils.isDesktop || screenWidth >= _splitLayoutBreakpoint;
    final relayNotifier = PlatformUtils.isAndroid
        ? (_androidRelayStatusNotifier ?? ValueNotifier<bool>(false))
        : RelayService.instance.serverNotifier;

    final listContent = ValueListenableBuilder<bool>(
      valueListenable: relayNotifier,
      builder: (context, isRelayRunning, child) {
        if (!isRelayRunning && _selectedSegment == 0) {
          if (PlatformUtils.isAndroid) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.waitingForRelayStart,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            );
          }
          return _showPortUnAvailableWidget();
        }
        return _selectedSegment == 0
            ? _applicationList(_getNIP46Applications())
            : _buildNIP07ApplicationList();
      },
    );

    return SafeArea(
      child: SizedBox(
        height: double.infinity,
        child: ApplicationHomeContent(
          showSegmentSelector: useSplitLayout && _currentPage == 'home',
          selectedSegment: _selectedSegment,
          onSegmentChanged: (v) => setState(() {
            _selectedSegment = v;
            if (v == 1) _nip07ApplicationsFuture = null;
          }),
          listContent: listContent,
          onClearNip07Cache: () => _nip07ApplicationsFuture = null,
        ),
      ),
    );
  }

  // Get NIP-46 applications (bunker and nostrconnect)
  List<ValueNotifier<ClientAuthDBISAR>> _getNIP46Applications() {
    return clientList.where((notifier) {
      final app = notifier.value;
      return app.pubkey == Account.sharedInstance.currentPubkey &&
          (app.connectionType == EConnectionType.bunker.toInt ||
           app.connectionType == EConnectionType.nostrconnect.toInt);
    }).toList();
  }

  Widget _applicationList(
      List<ValueNotifier<ClientAuthDBISAR>> applicationList) {
    if (applicationList.isEmpty) return _noBunkerSocketWidget();
    return SingleChildScrollView(
      child: Column(
        children:
        applicationList.map((ValueNotifier<ClientAuthDBISAR> dbNotifier) {
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
                              ToolKit.formatTimestamp(timestamp),
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
                                  isConnect ? AppLocalizations.of(context)!.connected : AppLocalizations.of(context)!.disconnected,
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

  // Build NIP-07 application list
  Widget _buildNIP07ApplicationList() {
    // Use cached future if available, otherwise create new one
    _nip07ApplicationsFuture ??= _loadNIP07Applications();
    
    return FutureBuilder<Map<String, Map<String, dynamic>>>(
      key: const ValueKey('nip07_applications'),
      future: _nip07ApplicationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.errorLoadingNip07Applications(snapshot.error.toString()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          );
        }
        
        final applications = snapshot.data ?? {};
        if (applications.isEmpty) {
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
                      AppLocalizations.of(context)!.noNip07ApplicationsHint,
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
        
        // Sort by last used timestamp (most recent first)
        final sortedApps = applications.values.toList()
          ..sort((a, b) => (b['lastUsedTimestamp'] as int).compareTo(a['lastUsedTimestamp'] as int));
        
        return SingleChildScrollView(
          child: Column(
            children: [
              ...sortedApps.map((app) => _buildNIP07ApplicationItem(app)),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildNIP07ApplicationItem(Map<String, dynamic> app) {
    final applicationName = app['applicationName'] as String? ?? AppLocalizations.of(context)!.unknown;
    final icon = app['icon'] as String?;
    final timestamp = app['lastUsedTimestamp'] as int? ?? 0;
    final applicationPubkey = app['applicationPubkey'] as String? ?? '';
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Navigate to Activities page with applicationPubkey
        AegisNavigator.pushPage(
          context,
          (context) => Activities(applicationPubkey: applicationPubkey),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        height: 72,
        child: Row(
          children: [
            // App Icon
            AppIconLoader.buildIcon(
              imageUrl: icon,
              appName: applicationName,
              size: 40,
              fallback: _buildInitialIcon(applicationName, 40),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(20),
            ).setPaddingOnly(right: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      applicationName,
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
                      'NIP-07',
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
                  ToolKit.formatTimestamp(timestamp),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ).setPaddingOnly(right: 8.0),
                    Text(
                      AppLocalizations.of(context)!.active,
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
  }
  
  Future<Map<String, Map<String, dynamic>>> _loadNIP07Applications() async {
    try {
      final account = Account.sharedInstance;
      if (account.currentPubkey.isEmpty) {
        return {};
      }
      
      final applications = await SignedEventDBISAR.getUniqueApplicationsByConnectionType(
        account.currentPubkey,
        'nip07',
      );
      
      // Filter out non-web apps based on metadata
      // Check metadata for 'isWebApp' field or valid HTTP/HTTPS URL
      final webApps = <String, Map<String, dynamic>>{};
      for (final entry in applications.entries) {
        final app = entry.value;
        final url = app['url'] as String? ?? '';
        final applicationPubkey = app['applicationPubkey'] as String? ?? '';
        
        // Get the original event to check metadata
        final events = await SignedEventDBISAR.getByConnectionType(
          account.currentPubkey,
          'nip07',
        );
        final event = events.firstWhere(
          (e) => e.applicationPubkey == applicationPubkey,
          orElse: () => events.first,
        );
        
        bool isWebApp = false;
        if (event.metadata != null && event.metadata!.isNotEmpty) {
          try {
            final metadata = json.decode(event.metadata!);
            // Check if metadata explicitly marks it as web app
            if (metadata['isWebApp'] == true) {
              isWebApp = true;
            } else if (metadata['isWebApp'] == false) {
              isWebApp = false;
            } else {
              // If not specified, check if URL is valid HTTP/HTTPS
              isWebApp = url.isNotEmpty && 
                  (url.startsWith('http://') || url.startsWith('https://')) &&
                  url != applicationPubkey;
            }
          } catch (e) {
            // If metadata parse fails, check URL
            isWebApp = url.isNotEmpty && 
                (url.startsWith('http://') || url.startsWith('https://')) &&
                url != applicationPubkey;
          }
        } else {
          // No metadata, check URL
          isWebApp = url.isNotEmpty && 
              (url.startsWith('http://') || url.startsWith('https://')) &&
              url != applicationPubkey;
        }
        
        if (isWebApp) {
          webApps[entry.key] = app;
        }
      }
      
      return webApps;
    } catch (e) {
      AegisLogger.error('Failed to load NIP-07 applications: $e');
      return {};
    }
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
                AppLocalizations.of(context)!.congratulationsEmptyState,
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
    final l10n = AppLocalizations.of(context)!;
    final preferredPort = RelayService.instance.preferredPort;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.localRelayPortInUse(preferredPort),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ).setPadding(
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)),
          const SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              onPressed: () async {
                await ServerNIP46Signer.instance.start(preferredPort);
                RelayService.instance.serverNotifier.addListener(() {
                  bool isConnect = RelayService.instance.serverNotifier.value;
                  if (mounted) {
                    CommonTips.success(
                      context,
                      isConnect ? l10n.nip46Started : l10n.nip46FailedToStart,
                    );
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              label: Text(
                l10n.retry,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _showChangePortDialog(),
            child: Text(l10n.localRelayChangePort),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePortDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: RelayService.instance.preferredPort);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.localRelayChangePort),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.localRelayChangePortHint),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    hintText: '1024-65535',
                  ),
                  onSubmitted: (value) {
                    final p = int.tryParse(value);
                    if (p != null && p >= 1024 && p <= 65535) {
                      Navigator.of(context).pop(value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                final value = controller.text.trim();
                final p = int.tryParse(value);
                if (p == null || p < 1024 || p > 65535) {
                  return;
                }
                Navigator.of(context).pop(value);
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    ).whenComplete(() => controller.dispose());
    if (result == null || !mounted) return;
    await RelayService.instance.setPreferredPort(result);
    try {
      await ServerNIP46Signer.instance.start(result);
      RelayService.instance.serverNotifier.addListener(() {
        final isConnect = RelayService.instance.serverNotifier.value;
        if (mounted) {
          CommonTips.success(
            context,
            isConnect ? l10n.nip46Started : l10n.nip46FailedToStart,
          );
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.localRelayChangePortHint)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.nip46FailedToStart} $e')),
        );
      }
    }
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
