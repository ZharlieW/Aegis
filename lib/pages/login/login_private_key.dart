import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';
import '../../common/common_appbar.dart';
import '../../common/common_tips.dart';
import '../../navigator/navigator.dart';
import '../../utils/account.dart';

class LoginPrivateKey extends StatefulWidget {
  const LoginPrivateKey({super.key});

  @override
  LoginPrivateKeyState createState() => LoginPrivateKeyState();
}

class LoginPrivateKeyState extends State<LoginPrivateKey> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomScrollView(
          slivers: [
            const CommonAppBar(
              title: 'Use your private key',
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      Text(
                        "Setup Aegis with your Nostr private key. Youcan enter different versions: Nsec, Ncryptsec or Hex.You can also scan it from a QR Code.",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _textController,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(fontSize: 24.0),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 16.0),
                          labelText: 'Nsec / private key',
                          hintText: 'Nsec / private key',
                          border: OutlineInputBorder(),
                          // isDense: false,
                          contentPadding: EdgeInsets.all(12), //
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: _nescLogin,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary, //
                        ),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                          ),
                        ),
                      ).setPaddingOnly(top: 20.0),
                    ],
                  ).setPadding(const EdgeInsets.symmetric(horizontal: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nescLogin() async {
    final privateKeyNsec = _textController.text.trim();
    if (privateKeyNsec.isEmpty) {
      CommonTips.error(context, 'The content cannot be empty！');
      return;
    }

    if (!Account.validateNsec(privateKeyNsec)) {
      CommonTips.error(context, 'Private illegal！');
      return;
    }

    String privateKey = Account.getPrivateKey(privateKeyNsec);
    String publicKey = Account.getPublicKey(privateKey);

    Account.sharedInstance.currentPubkey = publicKey;
    Account.sharedInstance.currentPrivkey = privateKey;

    CommonTips.error(context, 'Login successfully !');

    AegisNavigator.popToRoot(context);
  }
}
