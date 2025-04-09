import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../navigator/navigator.dart';
import 'create_nostr_account.dart';
import 'login_private_key.dart';

class Login extends StatefulWidget {
  final bool isLaunchLogin;
  const Login({super.key,this.isLaunchLogin = false});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: widget.isLaunchLogin ? Container() : null,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              CommonImage(
                iconName: 'aegis_logo.png',
                size: 200,
              ),
              const Text(
                'Aegis',
                style: TextStyle(
                  fontFamily: 'Staatliches',
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'Aegis',
                style: TextStyle(
                  fontFamily: 'Staatliches',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Column(
            children: [
              FilledButton.tonal(
                onPressed: () {
                  AegisNavigator.pushPage(
                      context, (context) => LoginPrivateKey());
                },
                style: FilledButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer, // 背景色
                ),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    'Use your private key',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ).setPaddingOnly(top: 20.0),
              FilledButton.tonal(
                onPressed: () {
                  AegisNavigator.pushPage(
                      context, (context) => CreateNostrAccount());
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // 背景色
                ),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    'Create a new Nostr account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ).setPaddingOnly(top: 20.0),
            ],
          ),
        ],
      ).setPadding(const EdgeInsets.symmetric(horizontal: 32)),
    );
  }
}
