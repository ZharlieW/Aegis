import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/common_constant.dart';
import '../navigator/navigator.dart';
import '../pages/login/login.dart';
import 'account.dart';
import 'nostr_wallet_connection_parser.dart';
import 'url_scheme_handler.dart';


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


}