import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Settings'),
      ),
      body: Center(
        child: GestureDetector(
          child: Column(
            children: [
              _itemWidget(Icons.safety_check,'Safe'),
              _itemWidget(Icons.key,'Backup key'),
              _itemWidget(Icons.language,'language'),
              _itemWidget(Icons.perm_data_setting,'Tor/Orbot setting'),
              _itemWidget(Icons.admin_panel_settings,'Relays'),
              _itemWidget(Icons.looks_4,'Log'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemWidget(IconData iconData, String content){
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 16
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
              content,
              style:TextStyle(
                fontSize: 24
              )
          )
        ],
      ),
    );
  }
}