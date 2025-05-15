import 'package:aegis/common/common_image.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../db/userDB_isar.dart';
import '../../navigator/navigator.dart';
import '../../utils/account.dart';
import '../../utils/account_manager.dart';
import '../../utils/took_kit.dart';
import '../login/login.dart';
import 'account_backup.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> with AccountObservers {
  Map<String,UserDBISAR> accountMap = {};

  String get _getKeyToStr {
    Account instance = Account.sharedInstance;
    String pubkey = instance.currentPubkey;
    String private = instance.currentPrivkey;
    if (pubkey.isEmpty || private.isEmpty) return '--';
    String nupKey = Account.getNupPublicKey(pubkey);
    return '${nupKey.substring(0, 10)}:${nupKey.substring(nupKey.length - 10)}';
  }

  String _getNpubKeyToStr(String pubkey) {
    String nupKey = Account.getNupPublicKey(pubkey);
    return '${nupKey.substring(0, 10)}:${nupKey.substring(nupKey.length - 10)}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Account.sharedInstance.addObserver(this);
    getAccountList();
  }

  void getAccountList() async {
    accountMap = await AccountManager.getAllAccount();
    accountMap.remove(Account.sharedInstance.currentPubkey);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                child: Column(
                  children: [
                    _accountView(),
                    ...accountMap.values.toList().map((account) {
                      int findIndex = accountMap.values.toList().indexOf(account);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListTile(
                          title: Text(
                            'Account ${findIndex + 2}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            _getNpubKeyToStr(account.pubkey),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: CommonImage(
                            iconName: 'change_icon.png',
                            size: 22,
                          ),
                          onTap: () => _switchAccount(account),
                        ),
                      );
                    }),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          AegisNavigator.pop(context);
                          AegisNavigator.pushPage(context, (context) => const Login());
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                        ),
                        label: Text(
                          "Add Account",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ).setPadding(const EdgeInsets.symmetric(horizontal: 20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountView() {
    return GestureDetector(
      onTap: () {
        AegisNavigator.pushPage(context, (context) => const AccountBackup());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account 1',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  _getKeyToStr,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Account account = Account.sharedInstance;
                    if (account.currentPubkey.isEmpty ||
                        account.currentPrivkey.isEmpty) {
                      AegisNavigator.pushPage(
                          context, (context) => const Login());
                      return;
                    }
                    String npubKey =
                        Account.getNupPublicKey(account.currentPubkey);

                    TookKit.copyKey(context, npubKey);
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
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to log out?"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), //
                          ),
                          actions: [
                            ElevatedButton.icon(
                              onPressed: () => AegisNavigator.pop(context),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.surfaceBright),
                              ),
                              label: Text(
                                "Cancel",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Account instance = Account.sharedInstance;
                                if (instance.currentPrivkey.isEmpty ||
                                    instance.currentPubkey.isEmpty) {
                                  CommonTips.error(context, 'Not logged in');
                                  return;
                                }
                                Account.sharedInstance.logout();
                                AegisNavigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              label: Text(
                                "Confirm",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: CommonImage(
                        iconName: 'logout_icon.png',
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _switchAccount(UserDBISAR account) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Switch account"),
          content:
          const Text("Are you sure you want to switch accounts?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), //
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () => AegisNavigator.pop(context),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.surfaceBright),
              ),
              label: Text(
                "Cancel",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async{
                await Account.sharedInstance.loginSuccess(account.pubkey,null);
                getAccountList();
                CommonTips.success(context, 'Switch successfully!');
                AegisNavigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              label: Text(
                "Confirm",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void didLoginSuccess() {
    // TODO: implement didLoginSuccess
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didSwitchUser() {
    // TODO: implement didSwitchUser
  }
}
