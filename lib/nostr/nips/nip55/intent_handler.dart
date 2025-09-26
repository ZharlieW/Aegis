import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'nip55_handler.dart';

/// Android Intent Handler for NIP-55 and URL Scheme support
/// Handles communication between Android MainActivity and Flutter app
/// 
/// This class delegates all business logic to NIP55Handler
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
    try {
    AegisLogger.info('📱 Intent handler received: ${call.method}');
    AegisLogger.info('📱 Intent handler arguments: ${call.arguments}');
    
    switch (call.method) {
      case 'onIntentReceived':
        return await _handleIntentReceived(call.arguments);
      case 'getPublicKeyForIntent':
          // Delegate to NIP55Handler
          final result = await NIP55Handler.handleGetPublicKey();
          return result;
        case 'signEventForIntent':
          // Delegate to NIP55Handler
          final args = call.arguments as Map<dynamic, dynamic>;
          final eventJson = args['eventJson'] as String? ?? '';
          final result = await NIP55Handler.handleSignEvent(eventJson: eventJson);
          return result;
        case 'signMessageForIntent':
          // Placeholder - not implemented in NIP55Handler yet
          AegisLogger.warning('⚠️ signMessageForIntent not implemented');
          return {'error': 'signMessageForIntent not implemented'};
        case 'nip04EncryptForIntent':
          // Delegate to NIP55Handler
          final args = call.arguments as Map<dynamic, dynamic>;
          final plaintext = args['message'] as String? ?? '';
          final pubkey = args['recipientPubkey'] as String?;
          if (pubkey == null) {
            return {'error': 'Missing recipientPubkey'};
          }
          final result = await NIP55Handler.handleNIP04Encrypt(
            plaintext: plaintext,
            pubkey: pubkey,
          );
          return result;
        case 'nip04DecryptForIntent':
          // Delegate to NIP55Handler
          final args = call.arguments as Map<dynamic, dynamic>;
          final ciphertext = args['encryptedMessage'] as String? ?? '';
          final pubkey = args['senderPubkey'] as String?;
          if (pubkey == null) {
            return {'error': 'Missing senderPubkey'};
          }
          final result = await NIP55Handler.handleNIP04Decrypt(
            ciphertext: ciphertext,
            pubkey: pubkey,
          );
          return result;
        case 'nip44EncryptForIntent':
          // Delegate to NIP55Handler
          final args = call.arguments as Map<dynamic, dynamic>;
          final plaintext = args['message'] as String? ?? '';
          final pubkey = args['recipientPubkey'] as String?;
          if (pubkey == null) {
            return {'error': 'Missing recipientPubkey'};
          }
          final result = await NIP55Handler.handleNIP44Encrypt(
            plaintext: plaintext,
            pubkey: pubkey,
          );
          return result;
        case 'nip44DecryptForIntent':
          // Delegate to NIP55Handler
          final args = call.arguments as Map<dynamic, dynamic>;
          final ciphertext = args['encryptedMessage'] as String? ?? '';
          final pubkey = args['senderPubkey'] as String?;
          if (pubkey == null) {
            return {'error': 'Missing senderPubkey'};
          }
          final result = await NIP55Handler.handleNIP44Decrypt(
            ciphertext: ciphertext,
            pubkey: pubkey,
          );
          return result;
        case 'decryptZapEventForIntent':
          // Delegate to NIP55Handler
          final args = call.arguments as Map<dynamic, dynamic>;
          final eventJson = args['zapEventJson'] as String? ?? '';
          final result = await NIP55Handler.handleDecryptZapEvent(eventJson: eventJson);
          return result;
      default:
        AegisLogger.error('❌ Intent handler unknown method: ${call.method}');
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
          );
      }
    } catch (e) {
      AegisLogger.error('❌ Error in intent handler method call: $e');
      throw PlatformException(
        code: 'HANDLER_ERROR',
        message: 'Error handling method call: $e',
        );
    }
  }
  
  /// Handle intent received from Android
  static Future<void> _handleIntentReceived(Map<dynamic, dynamic> args) async {
    try {
      final data = args['data'] as String?;
      if (data == null) {
        AegisLogger.error('❌ Intent data is null');
        return;
      }
      
      AegisLogger.info('📱 Processing intent data: ${data.substring(0, data.length > 200 ? 200 : data.length)}...');
      
      // Check if this is an error from Android
      if (data.startsWith('error:')) {
        AegisLogger.error('❌ Android reported error: ${data.substring(6)}');
        return;
      }
      
      // Extract Intent extras (type, id, current_user, pubkey, etc.)
      final extras = <String, dynamic>{};
      if (args['type'] != null) extras['type'] = args['type'];
      if (args['id'] != null) extras['id'] = args['id'];
      if (args['current_user'] != null) extras['current_user'] = args['current_user'];
      if (args['pubkey'] != null) extras['pubkey'] = args['pubkey'];
      
      AegisLogger.info('📱 Intent extras: $extras');
      
      // Parse the intent data to determine request type
      final requestType = _parseRequestType(data, extras);
      AegisLogger.info('📱 Detected request type: $requestType');
      
      // Handle different request types
      switch (requestType) {
        case 'get_public_key':
          await _handlePublicKeyRequest(data, extras);
          break;
        case 'sign_event':
          await _handleSignEventRequest(data);
          break;
        case 'sign_message':
          await _handleSignMessageRequest(data);
          break;
        case 'nip04_encrypt':
          await _handleNIP04EncryptRequest(data);
          break;
        case 'nip04_decrypt':
          await _handleNIP04DecryptRequest(data);
          break;
        case 'nip44_encrypt':
          await _handleNIP44EncryptRequest(data);
          break;
        case 'nip44_decrypt':
          await _handleNIP44DecryptRequest(data);
          break;
        case 'decrypt_zap_event':
          await _handleDecryptZapEventRequest(data);
          break;
        default:
          AegisLogger.warning('⚠️ Unknown request type: $requestType, treating as generic scheme');
        await LaunchSchemeUtils.handleSchemeData(data);
      }
      
      // Add to stream for UI to listen
      _intentController?.add({
        'type': requestType,
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
    } catch (e) {
      AegisLogger.error('❌ Failed to handle intent received: $e');
      // Add error to stream
      _intentController?.add({
        'type': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
  
  /// Parse request type from intent data
  static String _parseRequestType(String data, Map<dynamic, dynamic>? extras) {
    try {
      // First, try to get type from Intent extras (following NIP-55 protocol)
      if (extras != null && extras['type'] != null) {
        final type = extras['type'] as String;
        AegisLogger.info('📱 Request type from Intent extras: $type');
        return type;
      }
      
      // Fallback to parsing JSON content for backward compatibility
      if (data.startsWith('nostrsigner:{')) {
        // Parse JSON to determine request type
        final jsonStart = data.indexOf('{');
        final jsonEnd = data.lastIndexOf('}');
        if (jsonStart != -1 && jsonEnd != -1) {
          final jsonStr = data.substring(jsonStart, jsonEnd + 1);
          final json = jsonDecode(jsonStr);
          
          // Check for Nostr event fields
          if (json['id'] != null && json['pubkey'] != null && json['kind'] != null) {
            AegisLogger.info('📱 Detected Nostr event JSON, treating as sign_event');
            return 'sign_event';
          }
          
          // Check for specific operation types
          if (json['event'] != null) return 'sign_event';
          if (json['message'] != null) return 'sign_message';
          if (json['nip04'] != null) return 'nip04_encrypt';
          if (json['nip44'] != null) return 'nip44_encrypt';
          if (json['zap'] != null) return 'decrypt_zap_event';
        }
      }
      
      // Fallback to string matching
      if (data.contains('public_key')) return 'public_key';
      if (data.contains('sign_event')) return 'sign_event';
      if (data.contains('sign_message')) return 'sign_message';
      if (data.contains('nip04_encrypt')) return 'nip04_encrypt';
      if (data.contains('nip04_decrypt')) return 'nip04_decrypt';
      if (data.contains('nip44_encrypt')) return 'nip44_encrypt';
      if (data.contains('nip44_decrypt')) return 'nip44_decrypt';
      if (data.contains('decrypt_zap')) return 'decrypt_zap_event';
      
      return 'unknown';
    } catch (e) {
      AegisLogger.error('❌ Error parsing request type: $e');
      return 'unknown';
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
  
  /// Send signing result back to Android (following NIP-55 protocol)
  static Future<void> _sendSignResultToAndroid(String signature, String eventId, String signedEvent) async {
    try {
      // Create result data following NIP-55 protocol
      final resultData = {
        'result': signature,
        'id': eventId,
        'event': signedEvent,
      };
      
      AegisLogger.info('📱 Sending sign result to Android: signature=${signature.substring(0, 16)}..., id=$eventId');
      
      // Send result back to Android via MethodChannel
      await _channel.invokeMethod('setSignResult', resultData);
      
    } catch (e) {
      AegisLogger.error('❌ Error sending sign result to Android: $e');
    }
  }
  
  /// Send public key result to Android via MethodChannel
  static Future<void> _sendPublicKeyResultToAndroid(String publicKey, String? packageName, String? requestId) async {
    try {
      // Create result data following NIP-55 protocol
      final resultData = {
        'result': publicKey,
        'package': packageName ?? 'com.aegis.app',
        'id': requestId,
      };
      
      AegisLogger.info('📱 Sending public key result to Android: ${publicKey.substring(0, 16)}..., id=$requestId');
      
      // Send result back to Android via MethodChannel
      await _channel.invokeMethod('setSignResult', resultData);
      
    } catch (e) {
      AegisLogger.error('❌ Error sending public key result to Android: $e');
    }
  }
  
  static Future<void> _sendGenericResultToAndroid(String result, String? requestId) async {
    try {
      // Create result data following NIP-55 protocol
      final resultData = {
        'result': result,
        'id': requestId,
      };
      
      AegisLogger.info('📱 Sending generic result to Android: result=${result.substring(0, 16)}..., id=$requestId');
      
      // Send result back to Android via MethodChannel
      await _channel.invokeMethod('setSignResult', resultData);
      
    } catch (e) {
      AegisLogger.error('❌ Error sending generic result to Android: $e');
    }
  }
  
  
  // ============================================================================
  // Request Type Handlers
  // ============================================================================
  
  /// Handle public key request
  static Future<void> _handlePublicKeyRequest(String data, Map<dynamic, dynamic>? extras) async {
    try {
      AegisLogger.info('📱 Handling public key request');
      final requestId = extras?['id'] as String?;
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleGetPublicKey(requestId: requestId);
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to get public key: ${result['error']}');
        return;
      }
      
      final publicKey = result['result'] as String?;
      final packageName = result['package'] as String?;
      
      if (publicKey != null) {
        AegisLogger.info('✅ Public key request completed: ${publicKey.substring(0, 16)}...');
        // Send result back to Android
        await _sendPublicKeyResultToAndroid(publicKey, packageName, requestId);
      } else {
        AegisLogger.error('❌ Failed to get public key from result data');
      }
    } catch (e) {
      AegisLogger.error('❌ Error handling public key request: $e');
    }
  }
  
  /// Handle sign event request
  static Future<void> _handleSignEventRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling sign event request');
      
      // Parse the nostrsigner: JSON data
      if (data.startsWith('nostrsigner:{')) {
        final jsonStart = data.indexOf('{');
        final jsonEnd = data.lastIndexOf('}');
        if (jsonStart != -1 && jsonEnd != -1) {
          final jsonStr = data.substring(jsonStart, jsonEnd + 1);
          
          AegisLogger.info('📱 Parsed event data, delegating to NIP55Handler');
          
          // Delegate to NIP55Handler
          final result = await NIP55Handler.handleSignEvent(
            eventJson: jsonStr,
          );
          
          if (result['error'] != null) {
            AegisLogger.error('❌ Failed to sign event: ${result['error']}');
            await _sendSignResultToAndroid('', '', '');
            return;
          }
          
          final signature = result['result'] as String;
          final eventId = result['id'] as String?;
          final signedEvent = result['event'] as String;
          
          AegisLogger.info('✅ Event signed successfully');
          
          // Send result back to Android immediately (following NIP-55 protocol)
          await _sendSignResultToAndroid(signature, eventId ?? '', signedEvent);
          
          AegisLogger.info('✅ Sign event request completed successfully');
        } else {
          AegisLogger.error('❌ Invalid JSON format in sign event request');
        }
      } else {
        AegisLogger.warning('⚠️ Non-JSON sign event request, falling back to scheme handler');
        await LaunchSchemeUtils.handleSchemeData(data);
      }
    } catch (e) {
      AegisLogger.error('❌ Error handling sign event request: $e');
      // Try to send error result to Android
      try {
        await _sendSignResultToAndroid('', '', '');
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle sign message request
  static Future<void> _handleSignMessageRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling sign message request');
      await LaunchSchemeUtils.handleSchemeData(data);
      AegisLogger.info('✅ Sign message request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling sign message request: $e');
    }
  }
  
  /// Handle NIP-04 encrypt request
  static Future<void> _handleNIP04EncryptRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling NIP-04 encrypt request');
      
      // Parse the request data to extract parameters
      final requestData = jsonDecode(data);
      final plaintext = requestData['plaintext'] as String? ?? '';
      final pubkey = requestData['pubkey'] as String?;
      final requestId = requestData['id'] as String?;
      
      if (plaintext.isEmpty || pubkey == null) {
        AegisLogger.error('❌ Missing plaintext or pubkey for NIP-04 encryption');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleNIP04Encrypt(
        plaintext: plaintext,
        pubkey: pubkey,
        requestId: requestId,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to encrypt with NIP-04: ${result['error']}');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      final encrypted = result['result'] as String;
      await _sendGenericResultToAndroid(encrypted, requestId);
      
      AegisLogger.info('✅ NIP-04 encrypt request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling NIP-04 encrypt request: $e');
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle NIP-04 decrypt request
  static Future<void> _handleNIP04DecryptRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling NIP-04 decrypt request');
      
      // Parse the request data to extract parameters
      final requestData = jsonDecode(data);
      final ciphertext = requestData['ciphertext'] as String? ?? '';
      final pubkey = requestData['pubkey'] as String?;
      final requestId = requestData['id'] as String?;
      
      if (ciphertext.isEmpty || pubkey == null) {
        AegisLogger.error('❌ Missing ciphertext or pubkey for NIP-04 decryption');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleNIP04Decrypt(
        ciphertext: ciphertext,
        pubkey: pubkey,
        requestId: requestId,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to decrypt with NIP-04: ${result['error']}');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      final decrypted = result['result'] as String;
      await _sendGenericResultToAndroid(decrypted, requestId);
      
      AegisLogger.info('✅ NIP-04 decrypt request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling NIP-04 decrypt request: $e');
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle NIP-44 encrypt request
  static Future<void> _handleNIP44EncryptRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling NIP-44 encrypt request');
      
      // Parse the request data to extract parameters
      final requestData = jsonDecode(data);
      final plaintext = requestData['plaintext'] as String? ?? '';
      final pubkey = requestData['pubkey'] as String?;
      final requestId = requestData['id'] as String?;
      
      if (plaintext.isEmpty || pubkey == null) {
        AegisLogger.error('❌ Missing plaintext or pubkey for NIP-44 encryption');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleNIP44Encrypt(
        plaintext: plaintext,
        pubkey: pubkey,
        requestId: requestId,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to encrypt with NIP-44: ${result['error']}');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      final encrypted = result['result'] as String;
      await _sendGenericResultToAndroid(encrypted, requestId);
      
      AegisLogger.info('✅ NIP-44 encrypt request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling NIP-44 encrypt request: $e');
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle NIP-44 decrypt request
  static Future<void> _handleNIP44DecryptRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling NIP-44 decrypt request');
      
      // Parse the request data to extract parameters
      final requestData = jsonDecode(data);
      final ciphertext = requestData['ciphertext'] as String? ?? '';
      final pubkey = requestData['pubkey'] as String?;
      final requestId = requestData['id'] as String?;
      
      if (ciphertext.isEmpty || pubkey == null) {
        AegisLogger.error('❌ Missing ciphertext or pubkey for NIP-44 decryption');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleNIP44Decrypt(
        ciphertext: ciphertext,
        pubkey: pubkey,
        requestId: requestId,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to decrypt with NIP-44: ${result['error']}');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      final decrypted = result['result'] as String;
      await _sendGenericResultToAndroid(decrypted, requestId);
      
      AegisLogger.info('✅ NIP-44 decrypt request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling NIP-44 decrypt request: $e');
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
  /// Handle decrypt zap event request
  static Future<void> _handleDecryptZapEventRequest(String data) async {
    try {
      AegisLogger.info('📱 Handling decrypt zap event request');
      
      // Parse the request data to extract parameters
      final requestData = jsonDecode(data);
      final eventJson = requestData['eventJson'] as String? ?? '';
      final requestId = requestData['id'] as String?;
      
      if (eventJson.isEmpty) {
        AegisLogger.error('❌ Missing eventJson for zap event decryption');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      // Delegate to NIP55Handler
      final result = await NIP55Handler.handleDecryptZapEvent(
        eventJson: eventJson,
        requestId: requestId,
      );
      
      if (result['error'] != null) {
        AegisLogger.error('❌ Failed to decrypt zap event: ${result['error']}');
        await _sendGenericResultToAndroid('', requestId);
        return;
      }
      
      final decryptedZap = result['result'] as String;
      await _sendGenericResultToAndroid(decryptedZap, requestId);
      
      AegisLogger.info('✅ Decrypt zap event request completed');
    } catch (e) {
      AegisLogger.error('❌ Error handling decrypt zap event request: $e');
      try {
        final requestData = jsonDecode(data);
        final requestId = requestData['id'] as String?;
        await _sendGenericResultToAndroid('', requestId);
      } catch (e2) {
        AegisLogger.error('❌ Failed to send error result: $e2');
      }
    }
  }
  
}

