import 'package:aegis/common/common_tips.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/common_appbar.dart';

class AddNsecbunker extends StatefulWidget {
  const AddNsecbunker({super.key});

  @override
  _AddNsecbunkerState createState() => _AddNsecbunkerState();
}

class _AddNsecbunkerState extends State<AddNsecbunker> {
  final TextEditingController _nameController = TextEditingController();

  String bunkerUrl = '';

  String port = '8081';

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ServerNIP46Signer.instance.generateKeyPair();
    _init();
  }

  void _init() async {
    bunkerUrl = await ServerNIP46Signer.instance.getBunkerUrl(port);
    setState(() {});
  }

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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  maxLines: 3,
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
                    hintText: bunkerUrl,
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16), //
                  ),
                ).setPadding(EdgeInsets.symmetric(horizontal: 16)),
                const SizedBox(
                  height: 20,
                ),
                FilledButton.tonal(
                  onPressed: _addNsecBunker,
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

  void _addNsecBunker() {
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      CommonTips.error(context, 'Name is empty');
      return;
    }
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    BunkerSocket bunkerSocket = BunkerSocket(
      name: name,
      port: port,
      nsecBunker: bunkerUrl,
      createTimestamp: timestamp,
    );
    Account.sharedInstance.addBunkerSocketMap(bunkerSocket);
    ServerNIP46Signer.instance.start('8081');
    CommonTips.success(context, 'Add successfully !!');
    AegisNavigator.popToRoot(context);
  }
}
