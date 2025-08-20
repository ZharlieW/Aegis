import 'package:flutter/services.dart';
import 'dart:io';

class AegisServiceManager {
  static const _serviceChannel = MethodChannel('aegis_service_control');
  static const _websocketChannel = MethodChannel('aegis_websocket_service');
  
  static Future<void> startBackgroundService() async {
    try {
      await _serviceChannel.invokeMethod('startWebSocketService');
      AegisServiceLogger.info('Background service started');
    } catch (e) {
      AegisServiceLogger.error('Failed to start background service: $e');
      rethrow;
    }
  }
  
  static Future<void> stopBackgroundService() async {
    try {
      await _serviceChannel.invokeMethod('stopWebSocketService');
      AegisServiceLogger.info('Background service stopped');
    } catch (e) {
      AegisServiceLogger.error('Failed to stop background service: $e');
      rethrow;
    }
  }
  
  static Future<void> requestBatteryOptimization() async {
    try {
      final isIgnoring = await _serviceChannel.invokeMethod('checkBatteryOptimizationStatus');
      if (!isIgnoring) {
        await _serviceChannel.invokeMethod('requestBatteryOptimizationWhitelist');
        AegisServiceLogger.info('Battery optimization whitelist requested');
      } else {
        AegisServiceLogger.info('Already ignoring battery optimization');
      }
    } catch (e) {
      AegisServiceLogger.error('Battery optimization request failed: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> getServiceStatus() async {
    try {
      return await _websocketChannel.invokeMethod('getServiceStatus');
    } catch (e) {
      AegisServiceLogger.error('Failed to get service status: $e');
      return null;
    }
  }
  
  static Future<bool> isServiceRunning() async {
    try {
      final status = await getServiceStatus();
      return status?['isRunning'] ?? false;
    } catch (e) {
      AegisServiceLogger.error('Failed to check service status: $e');
      return false;
    }
  }
  
  static Future<bool> hasNetworkConnection() async {
    try {
      final status = await getServiceStatus();
      if (status != null && status.containsKey('hasNetwork')) {
        return status['hasNetwork'] ?? false;
      }
      
      return await _checkNetworkViaDNS();
      
    } catch (e) {
      AegisServiceLogger.error('Primary network check failed: $e');
      
      try {
        return await _checkNetworkViaDNS();
      } catch (fallbackError) {
        AegisServiceLogger.error('Fallback network check also failed: $fallbackError');
        
        return await _checkNetworkViaPlatform();
      }
    }
  }
  
  static Future<bool> _checkNetworkViaDNS() async {
    try {
      final result = await InternetAddress.lookup('8.8.8.8');
      return result.isNotEmpty;
    } catch (e) {
      AegisServiceLogger.debug('DNS lookup failed: $e');
      return false;
    }
  }
  
  static Future<bool> _checkNetworkViaPlatform() async {
    try {
      final result = await _serviceChannel.invokeMethod('checkNetworkConnectivity');
      return result ?? false;
    } catch (e) {
      AegisServiceLogger.debug('Platform network check failed: $e');
      return false;
    }
  }
  
  static Future<Map<String, dynamic>> getDetailedNetworkStatus() async {
    try {
      final status = await getServiceStatus();
      final hasNetwork = await hasNetworkConnection();
      
      return {
        'isRunning': status?['isRunning'] ?? false,
        'hasNetwork': hasNetwork,
        'networkType': status?['networkType'] ?? 'unknown',
        'timestamp': DateTime.now().toIso8601String(),
        'checkMethod': 'hybrid',
      };
    } catch (e) {
      AegisServiceLogger.error('Failed to get detailed network status: $e');
      return {
        'isRunning': false,
        'hasNetwork': false,
        'networkType': 'unknown',
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }
  
  static Future<void> startWebSocketServer() async {
    try {
      await _websocketChannel.invokeMethod('flutter_startWebSocketServer', {
        'port': '8080'
      });
      AegisServiceLogger.info('WebSocket server start requested');
    } catch (e) {
      AegisServiceLogger.error('Failed to start WebSocket server: $e');
      rethrow;
    }
  }
  
  static Future<void> stopWebSocketServer() async {
    try {
      await _websocketChannel.invokeMethod('flutter_stopWebSocketServer', null);
      AegisServiceLogger.info('WebSocket server stop requested');
    } catch (e) {
      AegisServiceLogger.error('Failed to stop WebSocket server: $e');
      rethrow;
    }
  }
  
  static Future<void> initializeBackgroundService() async {
    try {
      await startBackgroundService();
      
      await requestBatteryOptimization();
      
      AegisServiceLogger.info('Background service initialized successfully');
    } catch (e) {
      AegisServiceLogger.error('Failed to initialize background service: $e');
      rethrow;
    }
  }
  
  static Future<void> cleanupBackgroundService() async {
    try {
      await stopBackgroundService();
      AegisServiceLogger.info('Background service cleaned up');
    } catch (e) {
      AegisServiceLogger.error('Failed to cleanup background service: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>> performHealthCheck() async {
    try {
      final isRunning = await isServiceRunning();
      final hasNetwork = await hasNetworkConnection();
      final serviceStatus = await getServiceStatus();
      
      return {
        'serviceHealthy': isRunning,
        'networkHealthy': hasNetwork,
        'overallHealth': isRunning && hasNetwork,
        'serviceStatus': serviceStatus,
        'timestamp': DateTime.now().toIso8601String(),
        'recommendations': _generateHealthRecommendations(isRunning, hasNetwork),
      };
    } catch (e) {
      AegisServiceLogger.error('Health check failed: $e');
      return {
        'serviceHealthy': false,
        'networkHealthy': false,
        'overallHealth': false,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'recommendations': ['Check system logs', 'Restart service', 'Verify network'],
      };
    }
  }
  
  static List<String> _generateHealthRecommendations(bool isRunning, bool hasNetwork) {
    final recommendations = <String>[];
    
    if (!isRunning) {
      recommendations.add('Restart background service');
    }
    
    if (!hasNetwork) {
      recommendations.add('Check network connection');
      recommendations.add('Verify internet access');
    }
    
    if (isRunning && hasNetwork) {
      recommendations.add('Service is healthy');
    }
    
    return recommendations;
  }
}

class AegisServiceLogger {
  static void info(String message) {
    print('[AegisService] INFO: $message');
  }
  
  static void error(String message) {
    print('[AegisService] ERROR: $message');
  }
  
  static void debug(String message) {
    print('[AegisService] DEBUG: $message');
  }
  
  static void warning(String message) {
    print('[AegisService] WARNING: $message');
  }
}
