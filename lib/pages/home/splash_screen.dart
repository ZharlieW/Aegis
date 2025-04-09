import 'dart:async';

import 'package:aegis/common/common_image.dart';
import 'package:flutter/material.dart';

import '../../navigator/navigator.dart';
import '../../utils/account.dart';
import '../login/login.dart';
import 'home.dart';

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
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 1), () async{
      Account instance = Account.sharedInstance;
      if(instance.currentPubkey.isEmpty || instance.currentPrivkey.isEmpty){
        await AegisNavigator.pushPage(context, (context) => Login(isLaunchLogin: true,));
      }
      _replaceHome();
    });
  }

  void _replaceHome(){
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Home(),
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
      backgroundColor: Colors.white, //
      body: Center(
        child: ScaleTransition(
          scale: _animation, //
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonImage(iconName: 'aegis_logo.png',size: 250,),
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
}
