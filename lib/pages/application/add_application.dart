import 'package:aegis/common/common_image.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/common_appbar.dart';
import 'add_nsecbunker.dart';
import 'application_item.dart';
import 'edit_configuration.dart';

class AddApplication extends StatefulWidget {
  const AddApplication({super.key});

  @override
  _AddApplicationState createState() => _AddApplicationState();
}

class _AddApplicationState extends State<AddApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CommonAppBar(
            title: 'Add a new application',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Usually Nostrapplications have a "Login with Aegis" option that permits to use Aegis as external signer; when you press that button Aegis is launched and you are asked to approve some permissions.',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _cardWidget(
                        onTap: () =>  CommonTips.error(context, 'comming soon !'),
                        iconName: 'clipboard_icon.png',
                        title: 'Paste from clipboard',
                        content:
                            'If your app offers you a Nostr Connect URL, you can paste it here. Usually this login mode it is offered by web apps.'),
                    _cardWidget(
                      onTap: () =>  CommonTips.error(context, 'comming soon !'),
                      iconName: 'scan_icon.png',
                      title: 'Scan a QR Code',
                      content:
                          "If your app offers you a Nostr Connect QR Code you can scan it from here. Usually this login mode it is offered by web apps.",
                    ),
                    _cardWidget(
                        onTap: () => {
                              AegisNavigator.pushPage(
                                context,
                                (context) => AddNsecbunker(),
                              )
                            },
                        iconName: 'nsecbunker_icon.png',
                        title: 'Add a nsecbunker',
                        content:
                            "This option allow to add a nsecbunker manually, and use with whichever app supports Nostr Connect (NIP-46)　。"),
                  ],
                ),
              ),
              // Your list of items
            ]),
          ),
        ],
      ),
    );
  }

  Widget _cardWidget(
      {required String iconName,
      required String title,
      required String content,
      required onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        // width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonImage(
              iconName: iconName,
              size: 56,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    content,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
