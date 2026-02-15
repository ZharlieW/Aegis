import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/pages/login/create_nostr_account.dart';
import 'package:aegis/pages/login/login_private_key.dart';

class Login extends StatefulWidget {
  final bool isLaunchLogin;
  const Login({super.key,this.isLaunchLogin = false});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
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
                'A simple signer for Nostr',
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
                    AppLocalizations.of(context)!.usePrivateKey,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                    AppLocalizations.of(context)!.createNewNostrAccount,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
