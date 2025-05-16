import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/background_audio_manager.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'pages/home/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundAudioManager().init();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainApp> with WidgetsBindingObserver {
  bool _isFirstLaunch = true;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    WidgetsBinding.instance.addObserver(this);
    await LocalStorage.init();
    await Account.sharedInstance.autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AegisNavigator.navigatorKey,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF615289),
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (!_isFirstLaunch) {
        LaunchSchemeUtils.getSchemeData();
        print("📱 The application goes back to the foreground and checks WebSocket...");
      } else {
        _isFirstLaunch = false;
        print("🚀 First launch, skip scheme data handling.");
      }
      print(
          "📱 The application goes back to the foreground and checks WebSocket...");
    } else if (state == AppLifecycleState.paused) {
      print("📱 Application enter background");
      if (AegisWebSocketServer.instance.clients.isNotEmpty) {}
    }
  }
}
