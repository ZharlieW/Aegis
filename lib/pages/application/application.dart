import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/took_kit.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../db/clientAuthDB_isar.dart';
import '../../navigator/navigator.dart';
import '../../utils/launch_scheme_utils.dart';
import '../login/login.dart';
import 'add_application.dart';
import 'application_info.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with AccountObservers {
  late WebViewController controller;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LaunchSchemeUtils.getSchemeData();
    Account.sharedInstance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Applications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: _applicationList(clientList),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Account account = Account.sharedInstance;
                  if (account.currentPubkey.isEmpty ||
                      account.currentPrivkey.isEmpty) {
                    AegisNavigator.pushPage(context, (context) => Login());
                    return;
                  }
                  AegisNavigator.pushPage(
                      context, (context) => AddApplication());
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(56),
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
    );
  }

  Widget _applicationList(
      List<ValueNotifier<ClientAuthDBISAR>> applicationList) {
    if (applicationList.isEmpty) return _noBunkerSocketWidget();
    return Column(
      children:
          applicationList.map((ValueNotifier<ClientAuthDBISAR> dbNotifier) {
        return ValueListenableBuilder(
            valueListenable: dbNotifier,
            builder: (context, value, child) {
              int timestamp = value.createTimestamp;
              bool isBunker =
                  value.connectionType == EConnectionType.bunker.toInt;
              String connectType = isBunker ? 'bunker://' : 'nostrconnect://';
              bool isConnect = value.socketHashCode != null;
              String name = value.name ?? '--';
              if (name.length > 20) {
                name = '${name.substring(0, 5)}...${name.substring(0, 5)}';
              }

              Widget _iconWidget() {
                if (isBunker)
                  return CommonImage(
                    iconName: 'default_app_icon.png',
                    size: 40,
                  ).setPaddingOnly(right: 8.0);
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
                  AegisNavigator.pushPage(context,
                      (context) => ApplicationInfo(clientAuthDBISAR: value));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 72,
                  child: Row(
                    children: [
                      _iconWidget(),
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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
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
                                isConnect ? 'Connected' : 'Not Connected',
                                style: Theme.of(context).textTheme.titleMedium,
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

  @override
  void didAddApplicationMap() {
    // TODO: implement didAddApplicationMap
    if(mounted){
      setState(() {});
    }
  }

  @override
  void didLoginSuccess() {
    // TODO: implement didLoginSuccess
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
  }

  @override
  void didSwitchUser() {
    // TODO: implement didSwitchUser
  }

  @override
  void didRemoveApplicationMap() {
    // TODO: implement didRemoveApplicationMap
    if(mounted){
      setState(() {});
    }
  }

  @override
  void didUpdateApplicationMap() {
    // TODO: implement didUpdateApplicationMap
    if(mounted){
      setState(() {});
    }
  }
}
