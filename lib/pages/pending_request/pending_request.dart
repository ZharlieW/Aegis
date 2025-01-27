import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/aegis_http_server.dart';
import '../../utils/aegis_http_server_client.dart';
import '../../utils/aegis_websocket.dart';
import '../../utils/aegis_websocket_client.dart';

class PendingRequest extends StatefulWidget {
  @override
  _PendingRequestState createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {

  String socketInfo = '';
  String socketConnectInfo = '';
  String httpInfo = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Pending Request'),
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
    AegisWebSocketClient.sharedInstance.connect();
  }

  void _startWebSocketServer() async {
    await AegisWebSocketServer.sharedInstance.start();
    String localIp = await AegisWebSocketServer.getLocalIpAddress();
    socketInfo = 'WebSocket server will run at: ws://$localIp:${AegisWebSocketServer.sharedInstance.port}';
    setState(() {});
  }

  void _startHttpsService() async{
    AegisHttpServer.sharedInstance.start();
    String localIp = await AegisWebSocketServer.getLocalIpAddress();
    httpInfo = 'Http server will run at: http://$localIp:${AegisWebSocketServer.sharedInstance.port}';
    setState(() {});

  }

  void _connectHttpsService() async {
    String url = await AegisWebSocketServer.getLocalIpAddress();
    AegisHttpServerClient.sharedInstance
        .sendPostRequest('http://$url:8080/hello', {'aa': 'a'});
  }


}