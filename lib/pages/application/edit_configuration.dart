import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/common_appbar.dart';
import '../../navigator/navigator.dart';
import 'add_application.dart';

class EditConfiguration extends StatefulWidget {
  const EditConfiguration({super.key});

  @override
  _EditConfigurationState createState() => _EditConfigurationState();
}

class _EditConfigurationState extends State<EditConfiguration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CommonAppBar(
            title: 'Add a nsecbunker',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Outlined text field
              Text(
                "To create a new nsecbunker, you only need to provide a name. The relay address defaults to the local address: 127.0.0.1:8081.",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                height: 56,
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: const TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'wss',
                    hintText: 'wss://...',
                    border: OutlineInputBorder(),
                    isDense: false,
                    contentPadding: EdgeInsets.all(16), //
                  ),
                ),
              ),
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(
                    hintStyle:  TextStyle(fontSize: 16.0),
                    labelText: 'Name',
                    hintText: 'Enter Name',
                    border: const OutlineInputBorder(),
                    // isDense: false,
                    contentPadding: const EdgeInsets.all(12), //
                    suffixIcon: Container(
                      width: 72,
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          // margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: CommonImage(
                            iconName: 'add_icon.png',
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(
                    hintStyle:  TextStyle(fontSize: 16.0),
                    labelText: 'Name',
                    hintText: 'wss://relay.nsec.app',
                    border: const OutlineInputBorder(),
                    // isDense: false,
                    contentPadding: const EdgeInsets.all(12), //
                    suffixIcon: Container(
                      width: 72,
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          // margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: CommonImage(
                            iconName: 'add_icon.png',
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FilledButton.tonal(
                onPressed: () {
                  AegisNavigator.pushPage(context, (context) => AddApplication());
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondaryContainer, // 背景色
                ),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    'Create',
                    style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).setPaddingOnly(top: 20.0),
              // Your list of items
            ]
            ),
          ),
        ],
      ),
    );
  }
}
