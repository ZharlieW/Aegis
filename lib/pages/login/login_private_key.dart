
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../common/common_appbar.dart';
import '../../common/common_image.dart';
import '../../navigator/navigator.dart';
import '../application/add_application.dart';


class LoginPrivateKey extends StatefulWidget {
  const LoginPrivateKey({super.key});

  @override
  _LoginPrivateKeyState createState() => _LoginPrivateKeyState();
}

class _LoginPrivateKeyState extends State<LoginPrivateKey> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CustomScrollView(
        slivers: [
          CommonAppBar(
            title: 'Use your private key',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: [
                  Text(
                    "Setup Aegis with your Nostr private key. Youcan enter different versions: Nsec, Ncryptsec or Hex.You can also scan it from a QR Code.",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 24.0),
                    decoration: InputDecoration(
                      hintStyle:  TextStyle(fontSize: 16.0),
                      labelText: 'Nsec / private key',
                      hintText: 'Nsec / private key',
                      border: const OutlineInputBorder(),
                      // isDense: false,
                      contentPadding: const EdgeInsets.all(12), //
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      AegisNavigator.popToRoot(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer, // 背景色
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Text(
                        'login',
                        style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ).setPaddingOnly(top: 20.0),
                ],
              ).setPadding(EdgeInsets.symmetric(horizontal: 16)),

            ],
            ),

          ),
        ],
      ),
    );
  }
}
