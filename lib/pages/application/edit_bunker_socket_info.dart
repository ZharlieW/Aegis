import 'package:aegis/common/common_tips.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../db/clientAuthDB_isar.dart';
import '../../navigator/navigator.dart';
import '../../utils/account.dart';


class EditApplicationInfo extends StatefulWidget {
  final ClientAuthDBISAR clientAuthDBISAR;
  const EditApplicationInfo({super.key,required this.clientAuthDBISAR});

  @override
  _EditApplicationInfoState createState() => _EditApplicationInfoState();
}

class _EditApplicationInfoState extends State<EditApplicationInfo> {
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
            // Text(
            //   "To create a new nsecbunker, you only need to provide a name. The relay address defaults to the local address: 127.0.0.1:8081.",
            //   style: Theme.of(context).textTheme.titleSmall?.copyWith(
            //         color: Theme.of(context).colorScheme.onSurface,
            //         fontWeight: FontWeight.w500,
            //       ),
            // ).setPadding(EdgeInsets.symmetric(vertical: 20)),
            SizedBox(height: 20),
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
              onPressed: _updateName,
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

  void _updateName(){
    String name = _nameController.text.trim();
    if(name.isEmpty)  {
      CommonTips.error(context,'The name cannot be empty');
      return;
    }
    Account instance = Account.sharedInstance;

    ValueNotifier<ClientAuthDBISAR> clientNotifier = instance.applicationMap[widget.clientAuthDBISAR.clientPubkey]!;
    clientNotifier.value.name = name;

    ClientAuthDBISAR.saveFromDB(clientNotifier.value,isUpdate: true);

    CommonTips.success(context,'Update success');
    AegisNavigator.pop(context);
  }
}
