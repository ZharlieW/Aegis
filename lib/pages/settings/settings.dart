import 'package:aegis/common/common_image.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                child: Column(
                  children: [
                    _accountView(),
                    _itemWidget(
                      iconName: 'backup_icon.png',
                      content: 'Backup Keys',
                    ),
                    _itemWidget(
                      iconName: 'relays_icon.png',
                      content: 'Relays',
                    ),
                    _itemWidget(
                      iconName: 'policy_icon.png',
                      content: 'Sign policy',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aegis Account',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                'npub1smn:2syewl0f',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                child: Center(
                  child: CommonImage(
                    iconName: 'copy_Icon.png',
                    size: 24,
                  ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: Center(
                  child: CommonImage(
                    iconName: 'logout_icon.png',
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemWidget({required String iconName, required String content}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        children: [
          CommonImage(iconName: iconName, size: 24).setPaddingOnly(right: 12.0),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
