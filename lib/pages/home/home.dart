import 'package:aegis/common/common_image.dart';
import 'package:flutter/material.dart';
import '../application/application.dart';
import '../settings/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeSate createState() => HomeSate();
}

class HomeSate extends State<Home> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const Application(),
    Settings(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
}
