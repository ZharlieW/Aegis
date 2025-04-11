import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/common_appbar.dart';
import '../../common/common_image.dart';
import '../../nostr/nips/nip19/nip19.dart';
import '../../utils/account.dart';
import '../../utils/took_kit.dart';

class AccountBackup extends StatefulWidget {
  const AccountBackup({super.key});

  @override
  _AccountBackupState createState() => _AccountBackupState();
}

class _AccountBackupState extends State<AccountBackup> {
  bool _isObscured = true;
  late final String nsecKeyStr;

  String get displayNsecKey {
    if (_isObscured) {
      return nsecKeyStr.split('\n').map((line) => '•' * line.length).join('\n');
    } else {
      return nsecKeyStr;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  _init() {
    Account instance = Account.sharedInstance;
    String nsecKey = Nip19.encodePrivateKey(instance.currentPrivkey);
    nsecKeyStr = nsecKey;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomScrollView(
          slivers: [
            const CommonAppBar(
              title: 'Account backup',
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  Account.sharedInstance.currentPubkey,
                ),
                _openAccountWidget(),
                SizedBox(height: 30),
                _accountPrivateKeyWidget(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _openAccountWidget() {
    Account instance = Account.sharedInstance;
    String pubkey = instance.currentPubkey;
    String nupKey = Account.getNupPublicKey(pubkey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Public account ID',
            style: Theme.of(context).textTheme.titleMedium),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 300,
                child: Text(nupKey),
              ),
              GestureDetector(
                onTap: () {
                  TookKit.copyKey(context, nupKey);
                },
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: CommonImage(
                      iconName: 'copy_icon.png',
                      size: 24,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ).setPadding(const EdgeInsets.symmetric(horizontal: 16));
  }

  Widget _accountPrivateKeyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Account private key',
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Text('Show'),
                Switch(
                  value: !_isObscured,
                  onChanged: (value) {
                    setState(() {
                      _isObscured = !value;
                    });
                  },
                ).setPaddingOnly(left: 10.0),
              ],
            ),
          ],
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  displayNsecKey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  TookKit.copyKey(context, nsecKeyStr);
                },
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: CommonImage(
                      iconName: 'copy_icon.png',
                      size: 24,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: 16));
  }
}
