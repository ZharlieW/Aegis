import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../common/common_image.dart';

class RequestPermission extends StatefulWidget {
  const RequestPermission({super.key});

  @override
  RequestPermissionState createState() => RequestPermissionState();
}

class PermissionsContent {
  final String title;
  final String content;

  PermissionsContent({
    required this.content,
    required this.title,
  });
}

class RequestPermissionState extends State<RequestPermission> {
  int selectIndex = 0;

  final List<PermissionsContent> permissionsContentList = [
    PermissionsContent(
      title: 'I fully trust this application',
      content: 'Approve all request automatically',
    ),
    PermissionsContent(
      title: 'Only Approve basic actions',
      content: 'Coming soon...',
    ),
    PermissionsContent(
      title: 'Manually review and approve each permission',
      content: 'Coming soon...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => AegisNavigator.pop(context),
          child: Center(
            child: CommonImage(
              iconName: 'title_close_icon.png',
              size: 32,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          'Permission Request',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CommonImage(
                      iconName: 'aegis_logo.png',
                      size: 100,
                    ).setPaddingOnly(
                      top: 24.0,
                      bottom: 20.0,
                    ),
                  ),
                  Text(
                    "How would you like to handle this application's permissions?",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ).setPadding(const EdgeInsets.symmetric(vertical: 20)),
                  _requestContentWidget(),
                  const SizedBox(
                    height: 8,
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      AegisNavigator.pop(context, true);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary, // 背景色
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Text(
                        'Grant Permissions',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                      ),
                    ),
                  ).setPaddingOnly(top: 20.0),
                  FilledButton.tonal(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainer, // 背景色
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Text(
                        'Reject',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                      ),
                    ),
                  ).setPaddingOnly(top: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _requestContentWidget() {
    return Column(
      children: permissionsContentList.map((PermissionsContent contentInfo) {
        int findIndex = permissionsContentList.indexOf(contentInfo);
        bool isSelect = findIndex == selectIndex;
        return GestureDetector(
          onTap: () {
            setState(() {
              if(findIndex == 0) {
                selectIndex = findIndex;
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CommonImage(
                  iconName: isSelect
                      ? 'select_radio_button_icon.png'
                      : 'radio_button_icon.png',
                  size: 32,
                ).setPaddingOnly(right: 16.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contentInfo.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        contentInfo.content,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
