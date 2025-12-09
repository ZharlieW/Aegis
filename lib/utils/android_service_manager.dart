import 'package:flutter/services.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:aegis/utils/platform_utils.dart';

/// Manages Android foreground service for running local relay and signer
class AndroidServiceManager {
  static const MethodChannel _channel = MethodChannel('com.aegis.app/foreground_service');
  static bool _isServiceRunning = false;

  /// Check if service is currently running
  static bool get isServiceRunning => _isServiceRunning;

  /// Start the foreground service and initialize relay/signer
  static Future<bool> startService({String port = '8081'}) async {
    if (!PlatformUtils.isAndroid) {
      AegisLogger.warning('⚠️ Foreground service is only available on Android');
      return false;
    }

    try {
      // Start the Android foreground service
      await _channel.invokeMethod('startService');
      AegisLogger.info('✅ Android foreground service started');

      // Wait a bit for the service to initialize Flutter engine
      await Future.delayed(const Duration(milliseconds: 500));

      // Start relay and signer
      await ServerNIP46Signer.instance.start(port);
      AegisLogger.info('✅ Relay and signer started in foreground service');

      _isServiceRunning = true;
      return true;
    } catch (e) {
      AegisLogger.error('❌ Failed to start foreground service', e);
      return false;
    }
  }

  /// Stop the foreground service and cleanup relay/signer
  static Future<bool> stopService() async {
    if (!PlatformUtils.isAndroid) {
      AegisLogger.warning('⚠️ Foreground service is only available on Android');
      return false;
    }

    try {
      // Stop relay and signer first
      await ServerNIP46Signer.instance.dispose();
      AegisLogger.info('✅ Relay and signer stopped');

      // Stop the Android foreground service
      await _channel.invokeMethod('stopService');
      AegisLogger.info('✅ Android foreground service stopped');

      _isServiceRunning = false;
      return true;
    } catch (e) {
      AegisLogger.error('❌ Failed to stop foreground service', e);
      return false;
    }
  }

  /// Initialize method channel handler for service communication
  static void initialize() {
    if (!PlatformUtils.isAndroid) {
      return;
    }

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'startRelayAndSigner':
          try {
            final port = call.arguments?['port'] as String? ?? '8081';
            await ServerNIP46Signer.instance.start(port);
            AegisLogger.info('✅ Relay and signer started from service');
            return {'success': true};
          } catch (e) {
            AegisLogger.error('❌ Failed to start relay and signer from service', e);
            return {'success': false, 'error': e.toString()};
          }

        case 'stopRelayAndSigner':
          try {
            await ServerNIP46Signer.instance.dispose();
            AegisLogger.info('✅ Relay and signer stopped from service');
            return {'success': true};
          } catch (e) {
            AegisLogger.error('❌ Failed to stop relay and signer from service', e);
            return {'success': false, 'error': e.toString()};
          }

        default:
          AegisLogger.warning('⚠️ Unknown method call: ${call.method}');
          return {'success': false, 'error': 'Unknown method'};
      }
    });

    AegisLogger.info('✅ Android service manager initialized');
  }
}

