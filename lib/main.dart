import 'package:aegis/core/app_bootstrap.dart';
import 'package:aegis/core/service_locator.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'package:aegis/utils/theme_manager.dart';
import 'package:aegis/nostr/nips/nip55/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/utils/locale_manager.dart';
import 'package:aegis/pages/home/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await AppBootstrap.runPreApp();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainApp> with WidgetsBindingObserver {
  bool _isFirstLaunch = true;
  bool isLogin = false;
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = init();
    // Listen to theme changes
    ThemeManager.themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeManager.themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await AppBootstrap.runAppInit();
    AppBootstrap.scheduleDeferred();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleManager.localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          navigatorKey: AegisNavigator.navigatorKey,
          title: '',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF615289),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF615289),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: ThemeManager.themeNotifier.value,
          builder: EasyLoading.init(),
          home: SplashScreen(initializationFuture: _initializationFuture),
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (!_isFirstLaunch) {
        LaunchSchemeUtils.getSchemeData();
        AegisLogger.info("📱 The application goes back to the foreground and checks WebSocket...");
      } else {
        _isFirstLaunch = false;
        AegisLogger.info("🚀 First launch, skip scheme data handling.");
      }
      AegisLogger.info("📱 The application goes back to the foreground");
    } else if (state == AppLifecycleState.paused) {
      AegisLogger.info("📱 Application enter background");
    }
  }
  
}

/// NIP-55 Content Provider entry point
/// This function is called by the Android Content Provider when other apps
/// make requests to our signer
@pragma('vm:entry-point')
void aegisSignerProviderEntrypoint() {
  // Initialize the content provider with our authorities
  ContentProvider(
    'com.aegis.app.GET_PUBLIC_KEY;com.aegis.app.SIGN_EVENT;com.aegis.app.NIP04_ENCRYPT;com.aegis.app.NIP04_DECRYPT;com.aegis.app.NIP44_ENCRYPT;com.aegis.app.NIP44_DECRYPT;com.aegis.app.DECRYPT_ZAP_EVENT'
  );
}
