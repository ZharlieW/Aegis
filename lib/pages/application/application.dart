import 'package:aegis/common/common_image.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/db/userDB_isar.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/utils/took_kit.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../db/clientAuthDB_isar.dart';
import '../../navigator/navigator.dart';
import '../../utils/launch_scheme_utils.dart';
import '../../utils/server_nip46_signer.dart';
import '../login/login.dart';
import '../settings/settings.dart';
import 'add_application.dart';
import 'application_info.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> with AccountObservers {
  late WebViewController controller;

  bool isPortAvailable = true;

  List<ValueNotifier<ClientAuthDBISAR>> get clientList {
    final list = Account.sharedInstance.applicationMap.values.toList();
    list.sort((a, b) {
      if (a.value.socketHashCode == null && b.value.socketHashCode != null) {
        return 1; // a > b
      }
      if (a.value.socketHashCode != null && b.value.socketHashCode == null) {
        return -1; // a < b
      }
      return (b.value.socketHashCode ?? 0)
          .compareTo(a.value.socketHashCode ?? 0);
    });
    return list;
  }


  String get _getCurrentKeyToStr {
    Account instance = Account.sharedInstance;
    String pubkey = instance.currentPubkey;
    String private = instance.currentPrivkey;
    if (pubkey.isEmpty || private.isEmpty) return '--';
    return _getNpubKeyToStr(pubkey);
  }

  String _getNpubKeyToStr(String pubkey) {
    String nupKey = Account.getNupPublicKey(pubkey);
    return '${nupKey.substring(0, 15)}:${nupKey.substring(nupKey.length - 15)}';
  }

  Map<String,UserDBISAR> accountMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LaunchSchemeUtils.getSchemeData();
    Account.sharedInstance.addObserver(this);
    getAccountList();
  }

  @override
  void dispose() {
    Account.sharedInstance.removeObserver(this);
    super.dispose();
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
        actions: [
          GestureDetector(
            onTap: () => AegisNavigator.pushPage(context, (context) => const Settings()),
            child: CommonImage(
              iconName: 'settings_icon.png',
              size: 24,
            ).setPaddingOnly(right: 16.0),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Account: ',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _getCurrentKeyToStr,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...accountMap.values.toList().map((account) {
              return ListTile(
                title: Text(
                  _getNpubKeyToStr(account.pubkey),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: CommonImage(
                  iconName: 'change_icon.png',
                  size: 22,
                ),
                onTap: () {
                  _switchAccount(account);
                  Navigator.pop(context);
                },
              );
            }),
            const Divider(),
            ListTile(
              title: Text(
                'Add Account',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: CommonImage(
                iconName: 'add_circle_icon.png',
                size: 22,
              ),
              onTap: () {
                AegisNavigator.pop(context);
                AegisNavigator.pushPage(context, (context) => const Login());
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: AegisWebSocketServer.instance.serverNotifier,
                    builder: (context, value, child) {
                      return Expanded(
                        child: value == null
                            ? _showPortUnAvailableWidget()
                            : _applicationList(clientList),
                      );
                    },
                  ),
                ],
              ).setPaddingOnly(top: 12.0),
              Positioned(
                bottom: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    Account account = Account.sharedInstance;
                    bool isEmpty = account.currentPubkey.isEmpty ||
                        account.currentPrivkey.isEmpty;
                    AegisNavigator.pushPage(
                      context,
                      (context) =>
                          isEmpty ? const Login() : const AddApplication(),
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color:  Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(56),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.14 * 255).round()),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CommonImage(
                        iconName: 'add_icon.png',
                        size: 36,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _applicationList(
      List<ValueNotifier<ClientAuthDBISAR>> applicationList) {
    if (applicationList.isEmpty) return _noBunkerSocketWidget();
    return SingleChildScrollView(
      child: Column(
        children:
            applicationList.map((ValueNotifier<ClientAuthDBISAR> dbNotifier) {
          return ValueListenableBuilder(
              valueListenable: dbNotifier,
              builder: (context, value, child) {

                int timestamp = value.createTimestamp ?? DateTime.now().millisecondsSinceEpoch;
                bool isBunker = value.connectionType == EConnectionType.bunker.toInt;
                String connectType = isBunker ? EConnectionType.bunker.toStr : EConnectionType.nostrconnect.toStr;
                bool isConnect = value.socketHashCode != null;
                String name = value.name ?? '--';

                if (name.length > 20) {
                  name = '${name.substring(0, 5)}...${name.substring(0, 5)}';
                }

                Widget iconWidget() {
                  if (isBunker) {
                    return CommonImage(
                      iconName: 'default_app_icon.png',
                      size: 40,
                    ).setPaddingOnly(right: 8.0);
                  }
                  return Image.network(
                    value.image ?? '',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ).setPaddingOnly(right: 8.0);
                }

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    AegisNavigator.pushPage(
                      context,
                      (context) => ApplicationInfo(clientAuthDBISAR: value),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    height: 72,
                    child: Row(
                      children: [
                        iconWidget(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                              Text(
                                connectType,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              TookKit.formatTimestamp(timestamp),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isConnect
                                        ? Colors.greenAccent
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ).setPaddingOnly(right: 8.0),
                                Text(
                                  isConnect ? 'Connected' : 'Disconnected',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }).toList(),
      ),
    );
  }

  Widget _noBunkerSocketWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CommonImage(
                iconName: 'aegis_logo.png',
                size: 100,
              ).setPaddingOnly(
                top: 24.0,
                bottom: 20.0,
              ),
            ),
            Text(
              'Congratulations!\n\nNow you can start using apps that support Aegis!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _showPortUnAvailableWidget() {
    return Column(
      children: [
        Text(
          'The local relay is set to use port 8081, but it appears another app is already using this port. Please close the conflicting app and try again.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ).setPadding(
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 200,
          child: ElevatedButton.icon(
            onPressed: () async {
              await ServerNIP46Signer.instance.start('8081');
              AegisWebSocketServer.instance.serverNotifier.addListener(() {
                bool isConnect = AegisWebSocketServer.instance.serverNotifier.value != null;
                if (mounted) {
                  CommonTips.success(
                    context,
                    isConnect ? 'Connection successful!' : 'Failed to connect to the socket.',
                  );
                }
              });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
            label: Text(
              "Retry",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  void _switchAccount(UserDBISAR account){
    Account.sharedInstance.loginSuccess(account.pubkey,null);
    CommonTips.success(context, 'Switch successfully!');
  }

  @override
  void didAddApplicationMap() {
    // TODO: implement didAddApplicationMap
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didLoginSuccess() {
    // TODO: implement didLoginSuccess
    if(mounted){
      getAccountList();
    }
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    if(mounted){
      getAccountList();
    }
  }

  @override
  void didSwitchUser() {
    // TODO: implement didSwitchUser
  }

  @override
  void didRemoveApplicationMap() {
    // TODO: implement didRemoveApplicationMap
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateApplicationMap() {
    // TODO: implement didUpdateApplicationMap
    if (mounted) {
      setState(() {});
    }
  }
}
