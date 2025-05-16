import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class AegisWebSocketServer {
  static final AegisWebSocketServer instance = AegisWebSocketServer._internal();
  factory AegisWebSocketServer() => instance;

  AegisWebSocketServer._internal();

  ValueNotifier<HttpServer?> serverNotifier = ValueNotifier(null);
  final List<WebSocket> clients = [];
  Function(String, WebSocket)? _onMessageReceived;
  Function(WebSocket)? _onDoneFromSocket;
  String _port = "8081";

  String ip = '127.0.0.1';

  final int restartServerDelayedTimer = 3;
  final int timeoutServer = 3;

  /// Start the WebSocket server
  Future<void> start({
    String port = "8081",
    required Function(String, WebSocket) onMessageReceived,
    required Function(WebSocket) onDoneFromSocket,
  }) async {
    bool hasConnect = await isPortAvailable();
    if(!hasConnect) return;

    if (serverNotifier.value != null) {
      print("⚠️ WebSocket server is already running on ws://127.0.0.1:$_port");
      return;
    }

    _port = port;
    _onMessageReceived = onMessageReceived;
    _onDoneFromSocket = onDoneFromSocket;

    // server = await HttpServer.bind(InternetAddress.anyIPv4, int.tryParse(_port) ?? 7651);

    HttpServer server = await HttpServer.bind(ip, int.tryParse(_port) ?? 7651);
    serverNotifier.value = server;


    serverNotifier.value!.listen((HttpRequest request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        clients.add(socket);
        socket.listen(
              (message) {
            if (message == "server_heartbeat") {
              print("💓 Received heartbeat check, sending ACK...");
              socket.add("server_heartbeat_ack");
              return;
            }

            _onMessageReceived?.call(message, socket);
          },
          onDone: () {
            print("❌ Client disconnected: ${socket.hashCode}");
            _onDoneFromSocket?.call(socket);
            clients.remove(socket);
          },
          onError: (error) {
            print("🚨 WebSocket error: $error");
            clients.remove(socket);
          },
        );
        print("🔗 Client connected: ${request.connectionInfo?.remoteAddress}");
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    });

    print("✅ WebSocket server started on ws://127.0.0.1:$_port");
  }

  Future<bool> isPortAvailable() async {
    try {
      final socket = await Socket.connect(ip, int.parse(_port), timeout: Duration(milliseconds: 300));
      socket.destroy();
      return false;
    } catch (e) {
      return true;
    }
  }

  /// Stop the WebSocket server
  Future<void> stop() async {
    if (serverNotifier.value != null) {
      print("🛑 Stopping WebSocket server...");
      await serverNotifier.value!.close();
      for (var client in clients) {

        client.close();
      }
      clients.clear();
      serverNotifier.value = null;
      print("✅ WebSocket server stopped.");
    } else {
      print("⚠️ WebSocket server is not running.");
    }
  }

  Future<void> closeClientByHashCode(int socketHashCode) async {
    final index = clients.indexWhere((s) => s.hashCode == socketHashCode);
    if (index != -1) {
      final client = clients[index];
      print("🔒 Closing client by hashCode: $socketHashCode");
      try {
        await client.close();
      } catch (e) {
        print("⚠️ Error closing client $socketHashCode: $e");
      }
      clients.removeAt(index);
      // _onDoneFromSocket?.call(client);
    } else {
      print("⚠️ No client found with hashCode: $socketHashCode");
    }
  }

}
