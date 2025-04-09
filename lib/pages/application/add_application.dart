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
                      'You can choose any of these methods to connect with Aegis!',
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
                        title: 'Paste Nostr Connect URL from clipboard',
                        content:
                            ''),
                    _cardWidget(
                      onTap: () =>  CommonTips.error(context, 'comming soon !'),
                      iconName: 'scan_icon.png',
                      title: 'Scan Nostr Connect QR Code',
                      content:
                          "",
                    ),
                    _cardWidget(
                        onTap: () => {
                              AegisNavigator.pushPage(
                                context,
                                (context) => AddNsecbunker(),
                              )
                            },
                        iconName: 'nsecbunker_icon.png',
                        title: 'Add a nsecbunker manually',
                        content:
                            ""),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
