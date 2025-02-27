import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/common_appbar.dart';
import '../../navigator/navigator.dart';
import 'add_application.dart';

class AddNsecbunker extends StatefulWidget {
  const AddNsecbunker({super.key});

  @override
  _AddNsecbunkerState createState() => _AddNsecbunkerState();
}

class _AddNsecbunkerState extends State<AddNsecbunker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomScrollView(
          slivers: [
            CommonAppBar(
              title: 'Add a nsecbunker',
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  "To create a new nsecbunker you need to give it a name and select one or more relays, that's all!",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ).setPadding(EdgeInsets.symmetric(horizontal: 16)),
                Container(
                  height: 56,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: const TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      labelText: 'name',
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                      isDense: false,
                      contentPadding: EdgeInsets.all(16), //
                    ),
                  ),
                ),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondaryContainer,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabled: false,
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    labelText: 'Bunker URL',
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    hintText: 'asd',
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16), //
                  ),
                ).setPadding(EdgeInsets.symmetric(horizontal: 16)),
                SizedBox(
                  height: 20,
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary, //
                  ),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Text(
                      'Add',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ).setPadding(EdgeInsets.symmetric(horizontal: 16)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
