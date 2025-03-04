import 'dart:async';

import 'package:aegis/common/common_image.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BottomTabBarExample(),
          transitionDuration: Duration.zero, //
          reverseTransitionDuration: Duration.zero, //
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child; //
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //
      body: Center(
        child: ScaleTransition(
          scale: _animation, //
          child: CommonImage(iconName: 'aegis_logo.png',size: 300,)
        ),
      ),
    );
  }
}
