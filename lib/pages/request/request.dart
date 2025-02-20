import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

import '../../utils/aegis_websocket_server.dart';
import '../../utils/server_nip46_signer.dart';
// import '../../utils/server_nip46_signer.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {

  String socketInfo = '';
  String socketConnectInfo = '';
  String httpInfo = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        AppBar(
          backgroundColor: Colors.lightBlue,
            title: const Text('Hello WorldWorldWorldWorldWorld'),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('Start the websocket service'),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _startWebSocketServer,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.only(left: 20),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                              'Start websocket'
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                              'Stop websocket'
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              socketInfo,
            ),

            Container(
              padding: EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('Connect the websocket service'),
                  ),
                  GestureDetector(
                    onTap: _startSocketClient,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                          'connect'
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              socketConnectInfo,
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
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    margin: EdgeInsets.only(left: 20),
                    child: Center(
                      child: Text('Start'),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              httpInfo,
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
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    margin: EdgeInsets.only(left: 20),
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

  void _startSocketClient() async {
    // AegisWebSocketClient.sharedInstance.connect();
  }

  void _startWebSocketServer() async {
    var signer = ServerNIP46Signer();
    signer.start();
    // var client = NIP46Client(serverUrl: "ws://127.0.0.1:8081");
    // await client.connect();
    // String response = await client.requestSign('{"kind":1,"content":"Hello NIP-46"}');
    // print("📥 远程签名返回: $response");
    // await AegisWebSocketServer.sharedInstance.start();
    // String localIp = await AegisWebSocketServer.getLocalIpAddress();
    // socketInfo = 'WebSocket server will run at: ws://$localIp:${AegisWebSocketServer.sharedInstance.port}';
    // setState(() {});
  }

  void _startHttpsService() async{
    // AegisHttpServer.sharedInstance.start();
    // String localIp = await AegisWebSocketServer.getLocalIpAddress();
    // httpInfo = 'Http server will run at: http://$localIp:${AegisWebSocketServer.sharedInstance.port}';
    // setState(() {});

  }

  void _connectHttpsService() async {
    // String url = await AegisWebSocketServer.getLocalIpAddress();
    // AegisHttpServerClient.sharedInstance
    //     .sendPostRequest('http://$url:8080/hello', {'aa': 'a'});
  }


}