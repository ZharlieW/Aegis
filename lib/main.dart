import 'package:aegis/navigator/navigator.dart';
import 'package:flutter/material.dart';

import 'pages/home/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AegisNavigator.navigatorKey,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Theme.of(context).colorScheme.primary),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}


