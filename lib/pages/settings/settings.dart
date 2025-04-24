import 'package:aegis/common/common_image.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../navigator/navigator.dart';
import '../../nostr/nips/nip19/nip19.dart';
import '../../utils/account.dart';
import '../../utils/took_kit.dart';
import '../login/login.dart';
import 'account_backup.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> with AccountObservers {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Account.sharedInstance.addObserver(this);
  }

  String get _getKeyToStr {
    Account instance = Account.sharedInstance;
    String pubkey = instance.currentPubkey;
    String private = instance.currentPrivkey;
    if (pubkey.isEmpty || private.isEmpty) return '--';
    String nupKey = Account.getNupPublicKey(pubkey);
    return '${nupKey.substring(0, 15)}...${nupKey.substring(nupKey.length - 10)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                child: Column(
                  children: [
                    _accountView(),
                    _itemWidget(
                        iconName: 'backup_icon.png',
                        content: 'Backup Keys',
                        onTap: () {
                          Account account = Account.sharedInstance;
                          bool isNoLogin = account.currentPubkey.isEmpty ||
                              account.currentPrivkey.isEmpty;
                          AegisNavigator.pushPage(
                            context,
                            (context) => isNoLogin
                                ? const Login()
                                : const AccountBackup(),
                          );
                        }),
                    _itemWidget(
                      iconName: 'version_icon.png',
                      content: 'Version: 0.1.2',
                      onTap: () => {},
                    ),
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
    return Container(
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
                'Account',
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
                              AegisNavigator.pushPage(
                                context,
                                (context) => const Login(
                                  isLaunchLogin: true,
                                ),
                              );
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
    );
  }

  Widget _itemWidget({
    required String iconName,
    required String content,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) {
          onTap();
          return;
        }
        CommonTips.error(context, 'comming soon !');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            CommonImage(iconName: iconName, size: 24)
                .setPaddingOnly(right: 12.0),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
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

  @override
  void didAddApplicationMap() {
    // TODO: implement didAddApplicationMap
  }

  @override
  void didRemoveApplicationMap() {
    // TODO: implement didRemoveApplicationMap
  }

  @override
  void didUpdateApplicationMap() {
    // TODO: implement didUpdateApplicationMap
  }
}
