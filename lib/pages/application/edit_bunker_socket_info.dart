import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../navigator/navigator.dart';
import '../login/login.dart';
import 'add_application.dart';

class EditBunkerSocketInfo extends StatefulWidget {
  const EditBunkerSocketInfo({super.key});

  @override
  _EditBunkerSocketInfoState createState() => _EditBunkerSocketInfoState();
}

class _EditBunkerSocketInfoState extends State<EditBunkerSocketInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EditBunkerSocketInfo',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            ValueListenableBuilder<List<BunkerSocket>>(
              valueListenable: Account.sharedInstance.bunkerSocketList,
              builder: (context, value, child) {
                if (value.isEmpty) return _noBunkerSocketWidget();
                return Column(
                  children: _applicationList(value),
                );
              },
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  AegisNavigator.pushPage(context, (context) => Login());
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
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

      return GestureDetector(
        onTap: (){},
        child: Container(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bunkerSocket.name),
                    Text(bunkerSocket.nsecBunker.substring(0, 8)),
                  ],
                ),
              ),
              Text(dateTime.toString())
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
                AegisNavigator.pushPage(context, (context) => AddApplication());
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
