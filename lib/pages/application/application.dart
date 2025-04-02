import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:aegis/utils/took_kit.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/common_webview.dart';
import '../../navigator/navigator.dart';
import '../../utils/launch_scheme_utils.dart';
import '../../utils/nostr_wallet_connection_parser.dart';
import '../login/login.dart';
import 'add_application.dart';
import 'bunker_socket_info.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late WebViewController controller ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LaunchSchemeUtils.getSchemeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Application',
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
                ValueListenableBuilder<Map<String,BunkerSocket>>(
                  valueListenable: Account.sharedInstance.bunkerSocketMap,
                  builder: (context, value, child) {
                    final infoList = Account.sharedInstance.nip46NostrConnectInfoMap;
                    if (value.isEmpty && infoList.value.isEmpty) return _noBunkerSocketWidget();
                    return Column(
                      children: _applicationList(value.values.toList()),
                    );
                  },
                ),
                ValueListenableBuilder<Map<String,Nip46NostrConnectInfo>>(
                  valueListenable: Account.sharedInstance.nip46NostrConnectInfoMap,
                  builder: (context, value, child) {
                    final bunkerSocketInfo = Account.sharedInstance.bunkerSocketMap;
                    if (value.isEmpty && bunkerSocketInfo.value.isEmpty) return Container();
                    return Column(
                      children: _nostrConnectApplicationList(value.values.toList()),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Account account = Account.sharedInstance;
                  if(account.currentPubkey.isEmpty || account.currentPrivkey.isEmpty){
                    AegisNavigator.pushPage(context, (context) => Login());
                    return;
                  }
                  AegisNavigator.pushPage(context, (context) => AddApplication());
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

  List<Widget> _applicationList(List<BunkerSocket> bunkerSocketist) {
    return bunkerSocketist.map((BunkerSocket bunkerSocket) {
      int timestamp = bunkerSocket.createTimestamp;
      String bunkerName = '${bunkerSocket.nsecBunker.substring(0,5)}...${bunkerSocket.nsecBunker.substring(bunkerSocket.nsecBunker.length - 20)}';
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          AegisNavigator.pushPage(context, (context) => BunkerSocketInfo(bunkerSocket: bunkerSocket,));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bunkerSocket.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      bunkerName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Text(
                TookKit.formatTimestamp(timestamp),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _nostrConnectApplicationList(List<Nip46NostrConnectInfo> connectInfo) {
    return connectInfo.map((Nip46NostrConnectInfo info) {
      int timestamp = info.createTimestamp ?? DateTime.now().millisecondsSinceEpoch;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // AegisNavigator.pushPage(context, (context) => BunkerSocketInfo(bunkerSocket: bunkerSocket,));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                info.image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ).setPaddingOnly(right: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      info.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      info.relay ?? '--',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                TookKit.formatTimestamp(timestamp),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }).toList();
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
              'Congratulations, your new account is ready!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Now you can start using apps that support Aegis, when needed Aegis will open and ask you to confirm permissions. In this view you will find all the apps that have active permissions.",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Discover all Nostr apps for android at nostrapps.com.",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            FilledButton.tonal(
              onPressed: () {
                AegisNavigator.pushPage(context, (context) => CommonWebView('https://nostrapps.com'));
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: Text(
                  'Discover',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ).setPaddingOnly(top: 20.0),
          ],
        ),
      ),
    );
  }
}
