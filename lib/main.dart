import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/background_audio_manager.dart';
import 'package:aegis/utils/nostr_wallet_connection_parser.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundAudioManager().init();
  await ServerNIP46Signer.instance.start('8081');
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

  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    WidgetsBinding.instance.addObserver(this);
    await Account.sharedInstance.autoLogin();
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
        if (url == null) return;
        String scheme = 'aegis://';
        String schemeUrl = Uri.decodeComponent(url.substring(scheme.length));
        if (Account.sharedInstance.isValidNostrConnectSchemeUri(schemeUrl)) {
          Account.sharedInstance.nostrWalletConnectSchemeUri = schemeUrl;
          NostrWalletConnectionParserHandler.handleScheme(schemeUrl);
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _getSchemeData();
      print(
          "📱 The application goes back to the foreground and checks WebSocket...");
    } else if (state == AppLifecycleState.paused) {
      print("📱 Application enter background");
      if (AegisWebSocketServer.instance.clients.isNotEmpty) {}
    }
  }
}
