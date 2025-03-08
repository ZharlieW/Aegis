import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/pages/application/application.dart';
import 'package:aegis/pages/request/request.dart';
import 'package:aegis/pages/settings/settings.dart';
import 'package:aegis/splash_screen/splash_screen.dart';
import 'package:aegis/utils/account.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AegisNavigator.navigatorKey,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      // const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text('Start the websocket service'),
                ),
                GestureDetector(
                  onTap: _startWebsocketService,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    color: Colors.red,
                    child: const Center(
                      child: Text('start'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text('Connect the websocket service'),
                GestureDetector(
                  onTap: _connectWebsocketService,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    color: Colors.red,
                    child: const Center(
                      child: Text('connect'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text('Start the http service'),
                GestureDetector(
                  onTap: _startHttpsService,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    color: Colors.red,
                    child: const Center(
                      child: Text('Start'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text('Connect the http service'),
                GestureDetector(
                  onTap: _connectHttpsService,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    color: Colors.red,
                    child: const Center(
                      child: Text('connect'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startWebsocketService() {
    // AegisWebSocketServer.sharedInstance.start();
  }

  void _connectWebsocketService() {}

  void _startHttpsService() {}

  void _connectHttpsService() async {
    // String url = await AegisWebSocketServer.getLocalIpAddress();
    // AegisHttpServerClient.sharedInstance
    //     .sendPostRequest('http://$url:8080/hello', {'aa': 'a'});
  }
}

class BottomTabBarExample extends StatefulWidget {
  @override
  _BottomTabBarExampleState createState() => _BottomTabBarExampleState();
}

class _BottomTabBarExampleState extends State<BottomTabBarExample> with AccountObservers{
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Application(),
    Request(),
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
        // selectedItemColor:Theme.of(context).colorScheme.secondaryContainer,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            icon: Icon(Icons.book_sharp),
            label: 'Application',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            icon: Icon(Icons.dataset),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            icon: Icon(Icons.account_circle),
            label: 'Settings',
          ),
        ],
      ),
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
