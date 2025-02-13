import 'package:aegis/pages/application/application.dart';
import 'package:aegis/pages/pending_request/pending_request.dart';
import 'package:aegis/pages/profile/profile.dart';
import 'package:aegis/pages/setting/setting.dart';
import 'package:aegis/utils/aegis_http_server.dart';
import 'package:aegis/utils/aegis_http_server_client.dart';
import 'package:aegis/utils/aegis_websocket.dart';
import 'package:aegis/utils/aegis_websocket_client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: BottomTabBarExample(),
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
    AegisWebSocketServer.sharedInstance.start();
  }

  void _connectWebsocketService() {
    AegisWebSocketClient.sharedInstance.connect();
  }

  void _startHttpsService() {
    AegisHttpServer.sharedInstance.start();
  }

  void _connectHttpsService() async {
    String url = await AegisWebSocketServer.getLocalIpAddress();
    AegisHttpServerClient.sharedInstance
        .sendPostRequest('http://$url:8080/hello', {'aa': 'a'});
  }
}

class BottomTabBarExample extends StatefulWidget {
  @override
  _BottomTabBarExampleState createState() => _BottomTabBarExampleState();
}

class _BottomTabBarExampleState extends State<BottomTabBarExample> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Application(),
    PendingRequest(),
    Setting(),
    Profile(),
  ];

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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.lightBlue,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.lightBlue,
            icon: Icon(Icons.book_sharp),
            label: 'pending request',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.lightBlue,
            icon: Icon(Icons.dataset),
            label: 'setting',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.lightBlue,
            icon: Icon(Icons.account_circle),
            label: 'Accounts',
          ),
        ],
      ),
    );
  }
}

