import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/common_constant.dart';
import '../navigator/navigator.dart';
import '../pages/login/login.dart';
import 'account.dart';
import 'account_manager.dart';
import 'launch_scheme_utils.dart';
import 'nostr_wallet_connection_parser.dart';
import 'logger.dart';
import '../db/clientAuthDB_isar.dart';

/// URL Scheme Handler for Aegis and NostrSigner schemes
class UrlSchemeHandler {
  static const String _xCallbackUrlHost = 'x-callback-url';
  static const String _authNip46Path = '/auth/nip46';
  static const String _methodConnect = 'connect';

  // Error codes
  static const int _errInvalid = 2001;
  static const int _errCancel = 1001;
  static const int _errParse = 2002;
  static const int _errMethod = 2003;

  /// Handle URL scheme calls
  static Future<void> handleScheme(String? url) async {
    if (url == null) return;

    // Determine the source app based on the scheme
    String sourceApp = _getSourceApp(url);

    void openError(String? cb, int code, String msg) {
      if (cb == null) return;
      final uriStr =
          '$cb?x-source=$sourceApp&errorCode=$code&errorMessage=${Uri.encodeComponent(msg)}';
      LaunchSchemeUtils.open(uriStr);
    }

    void openSuccess(String? cb) {
      if (cb == null) return;
      LaunchSchemeUtils.open('$cb?x-source=$sourceApp&relay=ws://0.0.0.0:8081');
    }

    String? encodedNc;
    String? successCallback;
    String? errorCallback;

    if (_isValidScheme(url)) {
      try {
        final uri = Uri.parse(Uri.decodeComponent(url));
        if (_isValidAuthPath(uri)) {
          // Validate method parameter
          final methodValidation = _validateMethodParameter(uri, openError);
          if (!methodValidation.isValid) return;

          // Extract parameters
          final params = _extractParameters(url, uri);
          if (!params.isValid) {
            openError(params.errorCallback, _errInvalid, params.errorMessage);
            return;
          }

          encodedNc = params.encodedNc;
          successCallback = params.successCallback;
          errorCallback = params.errorCallback;

          url = Uri.decodeComponent(encodedNc!);
        }
      } catch (e) {
        openError(errorCallback, _errParse, 'Malformed auth/nip46 uri');
        return;
      }
    }

    // Process the Nostr Connect URI
    await _processNostrConnectUri(url, successCallback, errorCallback, openError, openSuccess);
  }

  /// Check if URL uses a valid scheme
  static bool _isValidScheme(String url) {
    return url.startsWith('aegis://') || url.startsWith('nostrsigner://');
  }

  /// Check if URI has valid auth path
  static bool _isValidAuthPath(Uri uri) {
    return uri.host == _xCallbackUrlHost && uri.path == _authNip46Path;
  }

  /// Get source app based on scheme
  static String _getSourceApp(String url) {
    if (url.startsWith('nostrsigner://')) {
      return 'nostrsigner';
    }
    return 'aegis';
  }

  /// Validate method parameter
  static _MethodValidation _validateMethodParameter(Uri uri, Function(String?, int, String) openError) {
    final method = uri.queryParameters['method'];
    if (method == null) {
      return _MethodValidation(false, 'Missing method parameter. Expected method=connect');
    }
    if (method != _methodConnect) {
      return _MethodValidation(false, 'Invalid method parameter. Expected method=connect');
    }
    return _MethodValidation(true, '');
  }

  /// Extract parameters from URI
  static _ParameterExtraction _extractParameters(String url, Uri uri) {
    final nostrconnectStr = RegExp(r'nostrconnect=([^&]+)');
    final encodedNc = nostrconnectStr.firstMatch(url)?.group(1);

    final successCallback = uri.queryParameters['x-success'];
    final errorCallback = uri.queryParameters['x-error'];

    if (encodedNc == null) {
      return _ParameterExtraction(
        isValid: false,
        errorMessage: 'Missing nostrconnect parameter',
        errorCallback: errorCallback,
      );
    }

    return _ParameterExtraction(
      isValid: true,
      encodedNc: encodedNc,
      successCallback: successCallback,
      errorCallback: errorCallback,
    );
  }

  /// Process Nostr Connect URI
  static Future<void> _processNostrConnectUri(
    String url,
    String? successCallback,
    String? errorCallback,
    Function(String?, int, String) openError,
    Function(String?) openSuccess,
  ) async {
    final result = NostrWalletConnectionParserHandler.parseUri(url);
    if (result == null) {
      openError(errorCallback, _errParse, 'Failed to parse nostrconnect uri');
      return;
    }

    final clientPubkey = result.clientPubkey;
    final accountInstance = Account.sharedInstance;
    final accountManagerInstance = AccountManager.sharedInstance;

    final hasClient = accountManagerInstance.applicationMap[clientPubkey]?.value;
    if (hasClient == null) {
      final isSuccess = await Account.authToClient();
      if (!isSuccess) {
        openError(errorCallback, _errCancel, 'User cancelled authorization');
        return;
      }
    }

    accountManagerInstance.addApplicationMap(result);
    await ClientAuthDBISAR.saveFromDB(result);

    final reqInfo = accountInstance.clientReqMap[clientPubkey];
    accountInstance.addAuthToNostrConnectInfo(result);
    if (reqInfo != null) {
      NostrWalletConnectionParserHandler.sendAuthUrl(reqInfo[1], result);
    }

    if (successCallback != null) {
      openSuccess(successCallback);
    } else if (result.scheme != null && result.scheme!.isNotEmpty) {
      LaunchSchemeUtils.open(result.scheme!);
    }
  }

  /// Show login dialog when user is not logged in
  static Future<void> showLoginDialog() async {
    final context = AegisNavigator.navigatorKey.currentContext;
    if (context == null) {
      AegisLogger.warning('⚠️ Navigator context is null, cannot show login dialog');
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tips"),
          content: const Text("Unable to resolve scheme, please login first."),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () => AegisNavigator.pop(context),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.surfaceBright),
              ),
              label: Text(
                "Cancel",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async{
                await AegisNavigator.pushPage(context, (context) => const Login());
                AegisNavigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              label: Text(
                "Login",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Method validation result
class _MethodValidation {
  final bool isValid;
  final String errorMessage;

  _MethodValidation(this.isValid, this.errorMessage);
}

/// Parameter extraction result
class _ParameterExtraction {
  final bool isValid;
  final String? encodedNc;
  final String? successCallback;
  final String? errorCallback;
  final String errorMessage;

  _ParameterExtraction({
    required this.isValid,
    this.encodedNc,
    this.successCallback,
    this.errorCallback,
    this.errorMessage = '',
  });
} 