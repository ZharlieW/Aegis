import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account.dart';
import 'nostr_wallet_connection_parser.dart';
import 'url_scheme_handler.dart';
import 'logger.dart';
import '../db/userDB_isar.dart';
import '../utils/local_storage.dart';
import '../nostr/utils.dart';
import '../nostr/nips/nip55/nip55_handler.dart';


class LaunchSchemeUtils {
  static const platform = MethodChannel('app.channel.shared.data');

  static Future<void> open(String scheme) async {
    final uri = Uri.tryParse(scheme);
    if (uri != null) {
      await launchUrl(uri);
    } else {
      print('Invalid scheme URL');
    }
  }

  static void getSchemeData() {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onSchemeCalled') {
        String? schemeUrl = call.arguments;
        if (schemeUrl == null) return;
        // String uri = url.substring(APP_SCHEME.length);
        // String schemeUrl = Uri.decodeComponent(uri);
        Account instance = Account.sharedInstance;
        if(instance.currentPrivkey.isEmpty || instance.currentPubkey.isEmpty){
           UrlSchemeHandler.showLoginDialog();
           return;
        }
        NostrWalletConnectionParserHandler.handleScheme(schemeUrl);
      }
    });
  }
  
  /// Handle scheme data from Android Intent
  static Future<void> handleSchemeData(String schemeData) async {
    try {
      AegisLogger.info('📱 Handling scheme data: $schemeData');
      
      final uri = Uri.tryParse(schemeData);
      if (uri == null) {
        AegisLogger.error('❌ Invalid scheme data: $schemeData');
        return;
      }
      
      // Initialize LocalStorage if not already initialized
      try {
        await LocalStorage.init();
        AegisLogger.info('📱 LocalStorage initialized for Intent mode');
      } catch (e) {
        AegisLogger.error('❌ Failed to initialize LocalStorage: $e');
        return;
      }
      
      // Check if user is logged in
      final account = Account.sharedInstance;
      if (account.currentPrivkey.isEmpty || account.currentPubkey.isEmpty) {
        AegisLogger.warning('⚠️ User not logged in, attempting auto-login for Intent mode');
        
        // Try to auto-login for Intent mode
        final currentPubkey = LocalStorage.get('pubkey');
        if (currentPubkey != null && currentPubkey.isNotEmpty) {
          AegisLogger.info('📱 Found stored pubkey: ${currentPubkey.substring(0, 16)}...');
          
          // Set the current user using loginSuccess method
          await account.loginSuccess(currentPubkey, null);
        } else {
          AegisLogger.error('❌ No stored pubkey found for auto-login');
          return;
        }
      }
      
      // Handle different schemes
      switch (uri.scheme) {
        case 'aegis':
          await _handleAegisScheme(uri);
          break;
        case 'nostrsigner':
          await _handleNostrSignerScheme(uri);
          break;
        default:
          AegisLogger.warning('⚠️ Unsupported scheme: ${uri.scheme}');
      }
    } catch (e) {
      AegisLogger.error('❌ Failed to handle scheme data: $e');
    }
  }
  
  /// Handle aegis:// scheme
  static Future<void> _handleAegisScheme(Uri uri) async {
    AegisLogger.info('📱 Handling aegis:// scheme: $uri');
    
    // Use existing NostrWalletConnectionParserHandler for aegis://
    NostrWalletConnectionParserHandler.handleScheme(uri.toString());
  }
  
  /// Handle nostrsigner:// scheme (NIP-55)
  /// Supports web applications calling Aegis via nostrsigner: URL scheme
  /// Format: nostrsigner:{data}?type={type}&callbackUrl={url}&returnType={type}&compressionType={type}
  static Future<void> _handleNostrSignerScheme(Uri uri) async {
    AegisLogger.info('🌐 Handling nostrsigner:// scheme from web: $uri');
    
    // Legacy path-based handling (keep old behavior)
    final path = uri.path;
    if (path.startsWith('/auth/nip46')) {
      await _handleNIP46Auth(uri.queryParameters);
      return;
    } else if (path.startsWith('/sign')) {
      await _handleSigningRequest(uri.queryParameters);
      return;
    }
    
    // Extract query parameters (outside try-catch so available for error handling)
    final queryParams = uri.queryParameters;
    final callbackUrl = queryParams['callbackUrl'];
    final returnType = queryParams['returnType'] ?? 'signature';
    final compressionType = queryParams['compressionType'] ?? 'none';
    
    try {
      final type = queryParams['type'] ?? 'get_public_key';
      
      AegisLogger.info('🌐 Request type: $type, returnType: $returnType, compressionType: $compressionType');
      
      // Extract data from URI path or scheme-specific part
      // Format: nostrsigner:{data}?params...
      final uriString = uri.toString();
      final schemeIndex = uriString.indexOf('nostrsigner:');
      if (schemeIndex == -1) {
        AegisLogger.error('❌ Invalid nostrsigner URL format');
        await _sendWebCallback(callbackUrl, null, 'Invalid URL format', returnType, compressionType);
        return;
      }
      
      final afterScheme = uriString.substring(schemeIndex + 'nostrsigner:'.length);
      final questionIndex = afterScheme.indexOf('?');
      final dataPart = questionIndex != -1 
          ? afterScheme.substring(0, questionIndex)
          : afterScheme;
      
      // Decode the data part
      String decodedData;
      try {
        decodedData = Uri.decodeComponent(dataPart);
      } catch (e) {
        decodedData = dataPart; // Use as-is if decoding fails
      }
      
      // Process the request based on type
      Map<String, dynamic> result;
      
      switch (type) {
        case 'get_public_key':
          result = await NIP55Handler.handleGetPublicKey();
          break;
          
        case 'sign_event':
          if (decodedData.isEmpty) {
            await _sendWebCallback(callbackUrl, null, 'Missing event JSON', returnType, compressionType);
            return;
          }
          result = await NIP55Handler.handleSignEvent(eventJson: decodedData);
          break;
          
        case 'nip04_encrypt':
          final pubkey = queryParams['pubkey'];
          if (decodedData.isEmpty || pubkey == null) {
            await _sendWebCallback(callbackUrl, null, 'Missing plaintext or pubkey', returnType, compressionType);
            return;
          }
          result = await NIP55Handler.handleNIP04Encrypt(
            plaintext: decodedData,
            pubkey: pubkey,
          );
          break;
          
        case 'nip44_encrypt':
          final pubkey = queryParams['pubkey'];
          if (decodedData.isEmpty || pubkey == null) {
            await _sendWebCallback(callbackUrl, null, 'Missing plaintext or pubkey', returnType, compressionType);
            return;
          }
          result = await NIP55Handler.handleNIP44Encrypt(
            plaintext: decodedData,
            pubkey: pubkey,
          );
          break;
          
        case 'nip04_decrypt':
          final pubkey = queryParams['pubkey'];
          if (decodedData.isEmpty || pubkey == null) {
            await _sendWebCallback(callbackUrl, null, 'Missing encrypted text or pubkey', returnType, compressionType);
            return;
          }
          result = await NIP55Handler.handleNIP04Decrypt(
            ciphertext: decodedData,
            pubkey: pubkey,
          );
          break;
          
        case 'nip44_decrypt':
          final pubkey = queryParams['pubkey'];
          if (decodedData.isEmpty || pubkey == null) {
            await _sendWebCallback(callbackUrl, null, 'Missing encrypted text or pubkey', returnType, compressionType);
            return;
          }
          result = await NIP55Handler.handleNIP44Decrypt(
            ciphertext: decodedData,
            pubkey: pubkey,
          );
          break;
          
        case 'decrypt_zap_event':
          if (decodedData.isEmpty) {
            await _sendWebCallback(callbackUrl, null, 'Missing event JSON', returnType, compressionType);
            return;
          }
          result = await NIP55Handler.handleDecryptZapEvent(eventJson: decodedData);
          break;
          
        default:
          AegisLogger.error('❌ Unknown request type: $type');
          await _sendWebCallback(callbackUrl, null, 'Unknown request type: $type', returnType, compressionType);
          return;
      }
      
      // Send result back via callback URL or clipboard
      await _sendWebCallback(callbackUrl, result, null, returnType, compressionType);
      
    } catch (e) {
      AegisLogger.error('❌ Error handling nostrsigner scheme: $e');
      await _sendWebCallback(callbackUrl, null, e.toString(), returnType, compressionType);
    }
  }
  
  /// Handle NIP-46 authentication via nostrsigner://
  static Future<void> _handleNIP46Auth(Map<String, String> params) async {
    try {
      final method = params['method'] ?? 'connect';
      final pubkey = params['pubkey'];
      
      AegisLogger.info('📱 NIP-46 auth request: method=$method, pubkey=$pubkey');
      
      // Handle through existing NIP-46 parser
      NostrWalletConnectionParserHandler.handleScheme('nostrsigner://auth/nip46?${Uri(queryParameters: params).query}');
    } catch (e) {
      AegisLogger.error('❌ Failed to handle NIP-46 auth: $e');
    }
  }

  /// Legacy signing request handler (nostrsigner://sign?event=xxx&callback=yyy)
  static Future<void> _handleSigningRequest(Map<String, String> params) async {
    try {
      final eventJson = params['event'];
      final callbackUrl = params['callback'] ?? params['callbackUrl'];
      final returnType = params['returnType'] ?? 'signature';
      final compressionType = params['compressionType'] ?? 'none';

      AegisLogger.info('📱 Legacy signing request: callback=$callbackUrl');

      if (eventJson == null || eventJson.isEmpty) {
        await _sendWebCallback(callbackUrl, null, 'Missing event JSON', returnType, compressionType);
        return;
      }

      // Delegate to existing parser for backward compatibility
      NostrWalletConnectionParserHandler.handleScheme('nostrsigner://sign?event=$eventJson&callback=$callbackUrl');
    } catch (e) {
      AegisLogger.error('❌ Failed to handle legacy signing request: $e');
    }
  }
  
  /// Send result back to web application via callback URL or clipboard
  static Future<void> _sendWebCallback(
    String? callbackUrl,
    Map<String, dynamic>? result,
    String? error,
    String returnType,
    String compressionType,
  ) async {
    try {
      String resultData;
      
      if (error != null) {
        // Send error
        if (callbackUrl != null && callbackUrl.isNotEmpty) {
          final errorUri = Uri.tryParse(callbackUrl);
          if (errorUri != null) {
            final errorCallback = errorUri.replace(
              queryParameters: {
                ...errorUri.queryParameters,
                'error': error,
              },
            );
            await launchUrl(errorCallback);
            AegisLogger.info('🌐 Sent error to callback URL: $error');
          }
        } else {
          AegisLogger.warning('⚠️ Error occurred but no callback URL provided: $error');
        }
        return;
      }
      
      if (result == null || result['error'] != null) {
        final errorMsg = result?['error'] as String? ?? 'Unknown error';
        if (callbackUrl != null && callbackUrl.isNotEmpty) {
          final errorUri = Uri.tryParse(callbackUrl);
          if (errorUri != null) {
            final errorCallback = errorUri.replace(
              queryParameters: {
                ...errorUri.queryParameters,
                'error': errorMsg,
              },
            );
            await launchUrl(errorCallback);
            AegisLogger.info('🌐 Sent error to callback URL: $errorMsg');
          }
        }
        return;
      }
      
      // Format result based on returnType
      if (returnType == 'event') {
        final event = result['event'] as String?;
        if (event == null) {
          _sendWebCallback(callbackUrl, null, 'No event in result', returnType, compressionType);
          return;
        }
        
        if (compressionType == 'gzip') {
          // For gzip compression, return "Signer1" + Base64 encoded event
          // Note: Actual gzip compression would require additional libraries
          // For now, use Base64 encoding as placeholder
          resultData = 'Signer1${base64Encode(utf8.encode(event))}';
        } else {
          resultData = event;
        }
      } else {
        // Return signature or other result
        resultData = result['result'] as String? ?? '';
      }
      
      if (callbackUrl != null && callbackUrl.isNotEmpty) {
        // Send result to callback URL
        final callbackUri = Uri.tryParse(callbackUrl);
        if (callbackUri != null) {
          final resultUri = callbackUri.replace(
            queryParameters: {
              ...callbackUri.queryParameters,
              'event': resultData,
            },
          );
          await launchUrl(resultUri);
          AegisLogger.info('🌐 Sent result to callback URL: ${resultUri.toString().substring(0, resultUri.toString().length > 200 ? 200 : resultUri.toString().length)}...');
        }
      } else {
        // Copy to clipboard (desktop platforms)
        try {
          await Clipboard.setData(ClipboardData(text: resultData));
          AegisLogger.info('🌐 Result copied to clipboard');
        } catch (e) {
          AegisLogger.error('❌ Failed to copy to clipboard: $e');
        }
      }
    } catch (e) {
      AegisLogger.error('❌ Error sending web callback: $e');
    }
  }
  
  /// Get current user private key for Intent mode auto-login (legacy)
  // ignore: unused_element
  static Future<String?> _getCurrentUserPrivateKeyForIntent() async {
    try {
      // Initialize LocalStorage if not already initialized
      try {
        await LocalStorage.init();
      } catch (e) {
        AegisLogger.error('❌ Failed to initialize LocalStorage in _getCurrentUserPrivateKeyForIntent: $e');
        return null;
      }
      
      // Get current user pubkey
      final currentPubkey = LocalStorage.get('pubkey');
      if (currentPubkey == null || currentPubkey.isEmpty) {
        AegisLogger.warning('⚠️ No current user found');
        return null;
      }
      
      // Get private key from database
      final user = await UserDBISAR.searchFromDB(currentPubkey);
      if (user == null) {
        AegisLogger.warning('⚠️ User not found in database');
        return null;
      }
      
      // Decrypt private key
      final decryptedPrivkey = await Account.sharedInstance.decryptPrivkey(user);
      if (decryptedPrivkey.isEmpty) {
        AegisLogger.warning('⚠️ Failed to decrypt private key');
        return null;
      }
      
      AegisLogger.info('📱 Successfully retrieved private key for Intent mode');
      return bytesToHex(decryptedPrivkey);
    } catch (e) {
      AegisLogger.error('❌ Failed to get private key for Intent mode: $e');
      return null;
    }
  }
}