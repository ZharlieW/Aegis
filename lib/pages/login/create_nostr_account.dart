import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../common/common_appbar.dart';
import '../../navigator/navigator.dart';

class CreateNostrAccount extends StatefulWidget {
  const CreateNostrAccount({super.key});

  @override
  _CreateNostrAccountState createState() => _CreateNostrAccountState();
}

class _CreateNostrAccountState extends State<CreateNostrAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CommonAppBar(
            title: 'Create a new Nostr account',
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    Text(
                      "Your Nostr account is ready! This is your public key, a sort of username that you can share with anyone to let it find you on Nostr:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: 24.0),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 16.0),
                        labelText: 'Nsec / private key',
                        hintText: 'wss://relay.nsec.app',
                        border: const OutlineInputBorder(),
                        // isDense: false,
                        contentPadding: const EdgeInsets.all(12), //
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: () {
                        AegisNavigator.popToRoot(context);
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
                  ],
                ).setPadding(EdgeInsets.symmetric(horizontal: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
