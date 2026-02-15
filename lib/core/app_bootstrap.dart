import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/background_audio_manager.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/utils/theme_manager.dart';
import 'package:aegis/utils/locale_manager.dart';
import 'package:aegis/utils/window_manager.dart';
import 'package:aegis/utils/android_service_manager.dart';
import 'package:aegis/nostr/nips/nip55/intent_handler.dart';
import 'package:aegis/nostr/nips/nip55/nip55_handler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nostr_rust/src/rust/frb_generated.dart';

/// Centralized app initialization. Separates must-succeed steps from optional
/// ones and defers non-critical work (e.g. periodic cleanup) so startup is not blocked.
class AppBootstrap {
  AppBootstrap._();

  static bool _deferredScheduled = false;

  /// Run before [runApp]. Optional steps: log failure but do not throw.
  /// Call from [main] after [WidgetsFlutterBinding.ensureInitialized].
  static Future<void> runPreApp() async {
    await _runOptional('RustLib', () => RustLib.init());
    await _runOptional('NIP55Handler', () => NIP55Handler.initialize());
    await _runOptional('IntentHandler', () => IntentHandler.initialize());
    await _runOptional('AndroidServiceManager', () async {
      AndroidServiceManager.initialize();
    });
    await initializeDateFormatting();
    await _runOptional('OXWindowManager', () => OXWindowManager().initWindow());
  }

  /// Run after first frame (e.g. from [MainState.initState]).
  /// Core steps: storage, theme, locale, account. Then startup cleanup.
  /// Returns a [Future] that completes when app is ready; optional steps may log and continue.
  static Future<void> runAppInit() async {
    await _runOptional('BackgroundAudioManager', () => BackgroundAudioManager().init());

    await LocalStorage.init();
    await ThemeManager.init();
    await LocaleManager.init();
    await Account.sharedInstance.autoLogin();

    await _runOptional('SignedEventManager.cleanupOnStartup', () async {
      AegisLogger.info('🚀 Starting startup cleanup of signed events');
      await SignedEventManager.sharedInstance.cleanupOnStartup();
    });
  }

  /// Schedule deferred work (e.g. periodic cleanup). Call once after [runAppInit] completes.
  /// Does not block; runs the first cleanup after 30 minutes.
  static void scheduleDeferred() {
    if (_deferredScheduled) return;
    _deferredScheduled = true;
    _schedulePeriodicCleanup();
  }

  static Future<void> _runOptional(String name, Future<void> Function() fn) async {
    try {
      await fn();
      AegisLogger.info('✅ $name initialized successfully');
    } catch (e) {
      AegisLogger.error('❌ Failed to initialize $name: $e');
    }
  }

  static void _schedulePeriodicCleanup() {
    Future.delayed(const Duration(minutes: 30), () {
      _performPeriodicCleanup();
    });
  }

  static Future<void> _performPeriodicCleanup() async {
    try {
      AegisLogger.info('🔄 Starting periodic cleanup of signed events');
      await SignedEventManager.sharedInstance.periodicCleanup();
    } catch (e) {
      AegisLogger.error('Failed to perform periodic cleanup: $e');
    } finally {
      _schedulePeriodicCleanup();
    }
  }
}
