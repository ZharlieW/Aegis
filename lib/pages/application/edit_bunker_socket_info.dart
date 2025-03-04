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
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit configuration',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text(
              "To create a new nsecbunker you need to give it a name and select one or more relays, that's all!",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ).setPadding(EdgeInsets.symmetric(vertical: 20)),
            Container(
              height: 56,
              child: TextField(
                controller: _nameController,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  labelText: 'name',
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                  isDense: false,
                  contentPadding: EdgeInsets.all(16), //
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: () {
                AegisNavigator.pushPage(context, (context) => AddApplication());
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: Text(
                  'Update',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ).setPaddingOnly(top: 20.0),
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
        onTap: () {},
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
