import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/common_constant.dart';
import '../navigator/navigator.dart';
import '../pages/login/login.dart';
import 'account.dart';
import 'nostr_wallet_connection_parser.dart';


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
        String? url = call.arguments;
        if (url == null) return;
        String uri = url.substring(APP_SCHEME.length);
        String schemeUrl = Uri.decodeComponent(uri);
        Account instance = Account.sharedInstance;
        if(instance.currentPrivkey.isEmpty || instance.currentPubkey.isEmpty){
           gotoLogin();
           return;
        }
        NostrWalletConnectionParserHandler.handleScheme(schemeUrl);
      }
    });
  }

  static Future<void> gotoLogin() async {
    showDialog(
      context:  AegisNavigator.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tips"),
          content: const Text("Unable to resolve scheme, please login first."),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), //
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