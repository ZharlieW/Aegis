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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                  child: Text('Start the websocket service'),
                ),
                GestureDetector(
                  onTap: _startWebsocketService,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    color: Colors.red,
                    child: Center(
                      child: Text('start'),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Container(
                  child: Text('Connect the websocket service'),
                ),
                GestureDetector(
                  onTap: _connectWebsocketService,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    color: Colors.red,
                    child: Center(
                      child: Text('connect'),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Container(
                  child: Text('Start the http service'),
                ),
                GestureDetector(
                  onTap: _startHttpsService,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    color: Colors.red,
                    child: Center(
                      child: Text('Start'),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Container(
                  child: Text('Connect the http service'),
                ),
                GestureDetector(
                  onTap: _connectHttpsService,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    color: Colors.red,
                    child: Center(
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

  void _startWebsocketService(){
    AegisWebSocketServer.sharedInstance.start();
  }

  void _connectWebsocketService(){
    AegisWebSocketClient.sharedInstance.connect();
  }

  void _startHttpsService(){
    AegisHttpServer.sharedInstance.start();
  }

  void _connectHttpsService() async {
    String url = await AegisWebSocketServer.getLocalIpAddress();
    AegisHttpServerClient.sharedInstance.sendPostRequest('http://$url:8080/hello',{'aa':'a'});
  }
}
