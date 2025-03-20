import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/background_audio_manager.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("📱 The application goes back to the foreground and checks WebSocket...");
    } else if (state == AppLifecycleState.paused) {
      print("📱 Application enter background");
      if (AegisWebSocketServer.instance.clients.isNotEmpty) {
      }
    }
  }
}