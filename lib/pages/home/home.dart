import 'package:aegis/common/common_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../application/application.dart';
import '../request/request.dart';
import '../settings/settings.dart';
import '../../utils/account.dart';

class Home extends StatefulWidget {
  @override
  _HomeSate createState() => _HomeSate();
}

class _HomeSate extends State<Home> with AccountObservers {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Application(),
    // Request(),
    Settings(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Account.sharedInstance.addObserver(this);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.purpleAccent,
            icon: _buildIcon('application_icon.png',false),
            activeIcon:
                _buildIcon('select_application_icon.png', _selectedIndex == 0),
            label: 'Applications',
          ),
          // BottomNavigationBarItem(
          //   icon: _buildIcon('request_icon.png',false),
          //   activeIcon:
          //       _buildIcon('select_request_icon.png', _selectedIndex == 1),
          //   label: 'Request',
          // ),
          BottomNavigationBarItem(
            icon: _buildIcon('settings_icon.png',false),
            activeIcon:
                _buildIcon('select_settings_icon.png', _selectedIndex == 1),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String iconName, bool isSelected) {
    Widget iconWidget = SizedBox(
      height: 32,
      child: CommonImage(
        iconName: iconName,
        size: 24,
      ),
    );

    if (!isSelected) return iconWidget;
    return Container(
      width: 64,
      height: 32,
      padding: const EdgeInsets.all(4), //
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2), //
        borderRadius: BorderRadius.circular(16),
      ),
      child: iconWidget,
    );
  }

  @override
  void didLoginSuccess() {
    // TODO: implement didLoginSuccess
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
  }

  @override
  void didSwitchUser() {
    // TODO: implement didSwitchUser
  }

  @override
  void didAddBunkerSocketMap() {
    // TODO: implement didAddBunkerSocketMap
  }

  @override
  void didAddClientRequestMap() {
    // TODO: implement didAddClientRequestMap
  }
}
