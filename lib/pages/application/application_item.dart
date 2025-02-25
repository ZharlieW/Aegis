import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/common_appbar.dart';
import '../../navigator/navigator.dart';
import 'add_application.dart';

class ApplicationItem extends StatefulWidget {
  const ApplicationItem({super.key});

  @override
  _ApplicationItemState createState() => _ApplicationItemState();
}

class _ApplicationItemState extends State<ApplicationItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,  // 左对齐
          children: [
            Spacer(),  // 空间占位符

            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          CommonAppBar(
            title: '0xChat',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'Manage the app permissions by temporarily disabling or completely reverting them. New permission are added by the app when required.',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _listItem(),
              _listItem(),

              // Your list of items
            ]
            ),
          ),

        ],
      ),
    );
  }

  Widget _listItem(){
    return Container(
      child: Row(
        children: [
          CommonImage(iconName: 'back_icon.png'),
          Text(
              'asdasf'
          ),
          CommonImage(iconName: 'back_icon.png'),
        ],
      ),
    );
  }
}
