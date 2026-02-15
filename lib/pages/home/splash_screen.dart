import 'dart:async';

import 'package:aegis/common/common_image.dart';
import 'package:aegis/pages/application/application.dart';
import 'package:flutter/material.dart';

import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/pages/login/login.dart';

class SplashScreen extends StatefulWidget {
  final Future<void> initializationFuture;
  
  const SplashScreen({super.key, required this.initializationFuture});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );

    _controller.forward();
    
    // Start waiting for initialization to complete
    _handleInitializationComplete();
  }

  void _replaceHome(){
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Application(),
        transitionDuration: Duration.zero, //
        reverseTransitionDuration: Duration.zero, //
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child; //
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonImage(iconName: 'aegis_logo.png', size: 250),
              Text(
                'Aegis',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle navigation after initialization
  Future<void> _handleInitializationComplete() async {
    // Wait for initialization to complete
    await widget.initializationFuture;
    
    // Check login status and navigate accordingly
    if (mounted) {
      final instance = Account.sharedInstance;
      if (instance.currentPubkey.isEmpty || instance.currentPrivkey.isEmpty) {
        await AegisNavigator.pushPage(context, (context) => const Login(isLaunchLogin: true));
      }
      _replaceHome();
    }
  }
}
