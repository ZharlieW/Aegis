import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/background_audio_manager.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/nostr/nips/nip55/nip55_handler.dart';
import 'package:aegis/nostr/nips/nip55/aegis_signer_content_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nostr_rust/src/rust/frb_generated.dart';
import 'pages/home/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize RustLib for Nostr functionality
  try {
    await RustLib.init();
    AegisLogger.info('✅ RustLib initialized successfully');
  } catch (e) {
    AegisLogger.error('❌ Failed to initialize RustLib: $e');
  }
  
  // Initialize NIP-55 handler for Android Intent communication
  try {
    await NIP55Handler.initialize();
    AegisLogger.info('✅ NIP-55 handler initialized successfully');
  } catch (e) {
    AegisLogger.error('❌ Failed to initialize NIP-55 handler: $e');
  }
  
  // Initialize intl library
  await initializeDateFormatting();
  
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
  }

  Future<void> init() async {
    try {
      // Initialize audio service (will be skipped on Android)
      await BackgroundAudioManager().init();
    } catch (e) {
      // Log error but don't crash the app
      AegisLogger.error("Failed to initialize audio service: $e");
    }

    try {
      WidgetsBinding.instance.addObserver(this);
      await LocalStorage.init();
      await Account.sharedInstance.autoLogin();
      
      
      // Clean up on app startup
      _performStartupCleanup();
      
      // Schedule periodic cleanup
      _schedulePeriodicCleanup();
    } catch (e) {
      AegisLogger.error("Failed to initialize app: $e");
    }
  }
  

  /// Perform startup cleanup
  void _performStartupCleanup() async {
    try {
      AegisLogger.info("🚀 Starting startup cleanup of signed events");
      await SignedEventManager.sharedInstance.cleanupOnStartup();
    } catch (e) {
      AegisLogger.error("Failed to perform startup cleanup: $e");
    }
  }

  /// Schedule periodic cleanup for signed events
  void _schedulePeriodicCleanup() {
    // Run cleanup every 30 minutes when app is active
    Future.delayed(const Duration(minutes: 30), () {
      _performPeriodicCleanup();
    });
  }

  /// Perform periodic cleanup
  void _performPeriodicCleanup() async {
    try {
      AegisLogger.info("🔄 Starting periodic cleanup of signed events");
      await SignedEventManager.sharedInstance.periodicCleanup();
    } catch (e) {
      AegisLogger.error("Failed to perform periodic cleanup: $e");
    } finally {
      // Schedule next cleanup
      _schedulePeriodicCleanup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AegisNavigator.navigatorKey,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF615289),
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(initializationFuture: _initializationFuture),
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
      AegisLogger.info("📱 The application goes back to the foreground and checks WebSocket...");
    } else if (state == AppLifecycleState.paused) {
      AegisLogger.info("📱 Application enter background");
      if (AegisWebSocketServer.instance.clients.isNotEmpty) {}
    }
  }
  
}

/// NIP-55 Content Provider entry point
/// This function is called by the Android Content Provider when other apps
/// make requests to our signer
@pragma('vm:entry-point')
void aegisSignerProviderEntrypoint() {
  // Initialize the content provider with our authorities
  AegisSignerContentProvider(
    'com.aegis.app.GET_PUBLIC_KEY;com.aegis.app.SIGN_EVENT;com.aegis.app.NIP04_ENCRYPT;com.aegis.app.NIP04_DECRYPT;com.aegis.app.NIP44_ENCRYPT;com.aegis.app.NIP44_DECRYPT;com.aegis.app.DECRYPT_ZAP_EVENT'
  );
}
