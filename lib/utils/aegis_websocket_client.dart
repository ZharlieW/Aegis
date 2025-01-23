import 'dart:async';
import 'dart:io';

import 'aegis_websocket.dart';

class AegisWebSocketClient {
  static final AegisWebSocketClient sharedInstance = AegisWebSocketClient._internal();


  AegisWebSocketClient._internal();

  factory AegisWebSocketClient() {
    return sharedInstance;
  }


  WebSocket? _webSocket;
  bool _isClientConnected = false;


  Future<void> connect() async {
    if (_isClientConnected) {
      print('Client is already connected.');
      return;
    }

    try {
      String localIp = await AegisWebSocketServer.getLocalIpAddress();
      String _serverUrl = 'ws://$localIp:${AegisWebSocketServer.sharedInstance.port}/ws';
      _webSocket = await WebSocket.connect(_serverUrl);
      _isClientConnected = true;
      print('Connected to WebSocket server at $_serverUrl');

      _webSocket!.listen((data) {
        print('Received from WebSocket: $data');
      });
    } catch (e) {
      print('Failed to connect to WebSocket server: $e');
    }
  }

  void send(String message) {
    if (_isClientConnected && _webSocket!.readyState == WebSocket.open) {
      _webSocket!.add(message);
      print('Sent message: $message');
    } else {
      print('WebSocket is not connected or is closed. Unable to send message.');
    }
  }

  Future<void> disconnect() async {
    if (_isClientConnected) {
      await _webSocket!.close();
      _isClientConnected = false;
      print('Disconnected from WebSocket server.');
    }
  }
}
