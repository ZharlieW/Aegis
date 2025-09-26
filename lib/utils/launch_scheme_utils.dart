import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account.dart';
import 'nostr_wallet_connection_parser.dart';
import 'url_scheme_handler.dart';
import 'logger.dart';
import '../db/userDB_isar.dart';
import '../utils/key_manager.dart';
import '../utils/local_storage.dart';
import '../nostr/utils.dart';


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
  static Future<void> _handleNostrSignerScheme(Uri uri) async {
    AegisLogger.info('📱 Handling nostrsigner:// scheme: $uri');
    
    // Parse NIP-55 intent parameters
    final path = uri.path;
    final queryParams = uri.queryParameters;
    
    if (path.startsWith('/auth/nip46')) {
      // Handle NIP-46 authentication
      await _handleNIP46Auth(queryParams);
    } else if (path.startsWith('/sign')) {
      // Handle signing request
      await _handleSigningRequest(queryParams);
    } else {
      AegisLogger.warning('⚠️ Unknown nostrsigner path: $path');
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
  
  /// Handle signing request via nostrsigner://
  static Future<void> _handleSigningRequest(Map<String, String> params) async {
    try {
      final eventJson = params['event'];
      final callbackUrl = params['callback'];
      
      AegisLogger.info('📱 Signing request: callback=$callbackUrl');
      
      if (eventJson != null) {
        // Handle signing through existing mechanism
        NostrWalletConnectionParserHandler.handleScheme('nostrsigner://sign?event=$eventJson&callback=$callbackUrl');
      }
    } catch (e) {
      AegisLogger.error('❌ Failed to handle signing request: $e');
    }
  }
  
  /// Get current user private key for Intent mode auto-login
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