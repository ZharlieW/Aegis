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

/// Dialog widget for logout confirmation
class _LogoutDialog extends StatefulWidget {
  const _LogoutDialog();

  @override
  State<_LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<_LogoutDialog> {
  late final TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConfirmValid = _confirmController.text.toLowerCase() == 'confirm';
    return AlertDialog(
      title: const Text("Logout"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Are you sure you want to log out?"),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmController,
              decoration: const InputDecoration(
                labelText: 'Type "confirm" to proceed',
                hintText: 'confirm',
              ),
              autofocus: true,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: isConfirmValid
              ? () {
                  Account instance = Account.sharedInstance;
                  if (instance.currentPrivkey.isEmpty ||
                      instance.currentPubkey.isEmpty) {
                    CommonTips.error(context, 'Not logged in');
                    return;
                  }
                  Account.sharedInstance.logout();
                  AegisNavigator.pop(context);
                }
              : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              isConfirmValid
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
            label: Text(
              "Confirm",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    color: isConfirmValid 
                        ? Theme.of(context).colorScheme.onPrimary 
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
        ),
      ],
    );
  }
}

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accounts',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _accountView(),
                    ...accountMap.values.toList().map((account) {
                      if(Account.sharedInstance.currentPubkey == account.pubkey){
                        return const SizedBox();
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListTile(
                          title: Text(
                            account.username ?? '--',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            _getNpubKeyToStr(account.pubkey),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: CommonImage(
                            iconName: 'change_icon.png',
                            size: 22,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          onTap: () => _switchAccount(account),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Only pop if we can pop (not in split layout)
                  if (Navigator.canPop(context)) {
                    AegisNavigator.pop(context);
                  }
                  AegisNavigator.pushPage(context, (context) => const Login());
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                ),
                label: Text(
                  "Add Account",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ).setPadding(const EdgeInsets.fromLTRB(20, 0, 20, 20)),

          ],
        ),
      ),
    );
  }

  Widget _accountView() {
    Account account = Account.sharedInstance;
    UserDBISAR? currentUser = accountMap[account.currentPubkey];
    if(currentUser == null) return const SizedBox();
    String name = currentUser.username ?? 'Unnamed';

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
                  name,
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
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    showRenameDialog(
                      context: context,
                      initialName: name,
                      onConfirm: (newName) async {
                        currentUser.username = newName;
                        await AccountManager.sharedInstance.saveAccount(currentUser);
                        getAccountList();
                        CommonTips.success(context, 'Update successful!');
                      },
                    );
                  },
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: CommonImage(
                        iconName: 'edit_icon.png',
                        size: 24,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _LogoutDialog(),
                    );
                  },
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: CommonImage(
                        iconName: 'logout_icon.png',
                        size: 24,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showRenameDialog({
    required BuildContext context,
    required String initialName,
    required void Function(String newName) onConfirm,
  }) async {
    final controller = TextEditingController(text: initialName);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Account'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Account Name',
            hintText: 'Enter new name',
          ),
          autofocus: true,
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
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                onConfirm(newName);
                Navigator.of(context).pop();
              }
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
      ),
    );
  }

  @override
  void didLoginSuccess() {
    // TODO: implement didLoginSuccess
    if (mounted) {
      getAccountList();
    }
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    if (mounted) {
      getAccountList();
    }
  }

  @override
  void didSwitchUser() {
    // TODO: implement didSwitchUser
  }
}
