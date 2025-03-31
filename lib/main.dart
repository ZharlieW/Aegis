import 'dart:convert';

import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/pages/request/request_permission.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/background_audio_manager.dart';
import 'package:aegis/utils/nostr_wallet_connection_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'nostr/event.dart';
import 'nostr/signer/local_nostr_signer.dart';
import 'pages/home/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundAudioManager().init();
  await Account.sharedInstance.autoLogin();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainApp> with WidgetsBindingObserver {

  static const platform = MethodChannel('app.channel.shared.data');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    _getSchemeData();
    return MaterialApp(
      navigatorKey: AegisNavigator.navigatorKey,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Theme.of(context).colorScheme.primary),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }

  void _getSchemeData() {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onSchemeCalled') {
        String? url = call.arguments;

        if(url == null) return;
        String scheme = 'aegis://';
        NostrWalletConnectionParserHandler.handleScheme(url.substring(scheme.length));
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getSchemeData();
      print("📱 The application goes back to the foreground and checks WebSocket...");
    } else if (state == AppLifecycleState.paused) {
      print("📱 Application enter background");
      if (AegisWebSocketServer.instance.clients.isNotEmpty) {
      }
    }
  }
}