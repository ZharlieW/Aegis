import 'package:aegis/common/common_tips.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../common/common_appbar.dart';
import '../../db/db_isar.dart';
import '../../db/userDB_isar.dart';
import '../../nostr/keychain.dart';
import '../../nostr/nips/nip19/nip19.dart';
import '../../utils/account.dart';

class CreateNostrAccount extends StatefulWidget {
  const CreateNostrAccount({super.key});

  CreateNostrAccountState createState() => CreateNostrAccountState();
}

class CreateNostrAccountState extends State<CreateNostrAccount> {

  late Keychain _keychain;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CommonAppBar(
            title: 'Create a new Nostr account',
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    Text(
                      "Your Nostr account is ready! This is your public key, a sort of username that you can share with anyone to let it find you on Nostr:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      maxLines :2,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondaryContainer,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabled: false,
                        hintStyle: TextStyle(
                            fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        labelText: 'NupPub',
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        hintText: Account.getNupPublicKey(_keychain.public),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(12), //
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: _createAccount,
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text(
                          'Create',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimary,
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
    );
  }

  void _createAccount()async{


    String privateKeyNsec = Nip19.encodePrivateKey(_keychain.private);
    UserDBISAR user = UserDBISAR(pubkey: _keychain.public, privkey: _keychain.private, encryptedPrivkey: privateKeyNsec);
    await DBISAR.sharedInstance.saveToDB(user);
    Account.sharedInstance.loginSuccess(_keychain.public,_keychain.private);

    CommonTips.success(context, 'Create successfully !');
    AegisNavigator.popToRoot(context);
  }

  void _init(){
    _keychain = Account.generateNewKeychain();
    setState(() {});
  }
}
