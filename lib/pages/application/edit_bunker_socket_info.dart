import 'package:aegis/common/common_tips.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../db/clientAuthDB_isar.dart';
import '../../navigator/navigator.dart';

class EditApplicationInfo extends StatefulWidget {

  final ClientAuthDBISAR clientAuthDBISAR;
  const EditApplicationInfo({super.key,required this.clientAuthDBISAR});

  @override
  EditApplicationInfoState createState() => EditApplicationInfoState();
}

class EditApplicationInfoState extends State<EditApplicationInfo> {
  final TextEditingController nameController = TextEditingController();

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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: TextField(
                controller: nameController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: widget.clientAuthDBISAR.name,
                  labelText: 'name',
                  border: const OutlineInputBorder(),
                  isDense: false,
                  contentPadding: const EdgeInsets.all(16), //
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: updateName,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: Text(
                  'Update',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

  void updateName(){
    String name = nameController.text.trim();
    if(name.isEmpty)  {
      CommonTips.error(context,'The name cannot be empty');
      return;
    }
    if(name.length > 15)  {
      CommonTips.error(context,'The name is too long.');
      return;
    }

    ValueNotifier<ClientAuthDBISAR> clientNotifier = AccountManager.sharedInstance.applicationMap[widget.clientAuthDBISAR.clientPubkey]!;
    clientNotifier.value.name = name;

    ClientAuthDBISAR.saveFromDB(clientNotifier.value,isUpdate: true);

    CommonTips.success(context,'Update success');
    AegisNavigator.pop(context);
  }
}
