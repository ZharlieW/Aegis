import 'dart:async';
import 'package:flutter/services.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';

/// Android Intent Handler for NIP-55 and URL Scheme support
/// Handles communication between Android MainActivity and Flutter app
class IntentHandler {
  static const MethodChannel _channel = MethodChannel('com.aegis.app/intent');
  static StreamController<Map<String, dynamic>>? _intentController;
  
  /// Initialize intent handler
  static Future<void> initialize() async {
    try {
      _channel.setMethodCallHandler(_handleMethodCall);
      _intentController = StreamController<Map<String, dynamic>>.broadcast();
      AegisLogger.info('✅ Intent handler initialized successfully');
    } catch (e) {
      AegisLogger.error('❌ Failed to initialize intent handler', e);
    }
  }
  
  /// Handle method calls from Android MainActivity
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    AegisLogger.info('📱 Intent handler received: ${call.method}');
    AegisLogger.info('📱 Intent handler arguments: ${call.arguments}');
    
    switch (call.method) {
      case 'onIntentReceived':
        return await _handleIntentReceived(call.arguments);
      default:
        AegisLogger.error('❌ Intent handler unknown method: ${call.method}');
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  }
  
  /// Handle intent received from Android
  static Future<void> _handleIntentReceived(Map<dynamic, dynamic> args) async {
    try {
      final data = args['data'] as String?;
      if (data != null) {
        AegisLogger.info('📱 Processing intent data: $data');
        
        // Parse the intent data
        final intentData = _parseIntentData(data);
        
        // Add to stream for UI to listen
        _intentController?.add(intentData);
        
        // Also handle through existing scheme utils
        await LaunchSchemeUtils.handleSchemeData(data);
      }
    } catch (e) {
      AegisLogger.error('❌ Failed to handle intent received: $e');
    }
  }
  
  /// Parse intent data from Android
  static Map<String, dynamic> _parseIntentData(String data) {
    try {
      final uri = Uri.parse(data);
      return {
        'scheme': uri.scheme,
        'host': uri.host,
        'path': uri.path,
        'query': uri.query,
        'fragment': uri.fragment,
        'rawData': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to parse intent data: $e');
      return {
        'rawData': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'error': e.toString(),
      };
    }
  }
  
  /// Get current intent data from Android
  static Future<Map<String, dynamic>?> getIntentData() async {
    try {
      final result = await _channel.invokeMethod('getIntentData');
      return Map<String, dynamic>.from(result);
    } catch (e) {
      AegisLogger.error('❌ Failed to get intent data: $e');
      return null;
    }
  }
  
  /// Stream of intent data for UI to listen
  static Stream<Map<String, dynamic>>? get intentStream => _intentController?.stream;
  
  /// Dispose the intent handler
  static void dispose() {
    _intentController?.close();
    _intentController = null;
  }
}
