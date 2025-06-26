import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'logger.dart';

extension AegisWebSocket on WebSocket {
  void send(String message) {
    AegisWebSocketServer.instance.out(this, message);
  }
}

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

  final Map<int, StreamController<String>> _sendControllers = {};

  /// Start the WebSocket server
  Future<void> start({
    String port = "8081",
    required Function(String, WebSocket) onMessageReceived,
    required Function(WebSocket) onDoneFromSocket,
  }) async {
    bool hasConnect = await isPortAvailable();
    if(!hasConnect) return;

    if (serverNotifier.value != null) {
      AegisLogger.warning("⚠️ WebSocket server is already running on ws://127.0.0.1:$_port");
      return;
    }

    _port = port;
    _onMessageReceived = onMessageReceived;
    _onDoneFromSocket = onDoneFromSocket;

    // server = await HttpServer.bind(InternetAddress.anyIPv4, int.tryParse(_port) ?? 7651);

    HttpServer server = await HttpServer.bind(ip, int.tryParse(_port) ?? 8081);
    serverNotifier.value = server;


    serverNotifier.value!.listen((HttpRequest request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        final id = socket.hashCode;
        clients.add(socket);

        // Create a single-subscription controller for outgoing messages
        final controller = StreamController<String>();
        _sendControllers[id] = controller;
        controller.stream
            .asyncMap((msg) => socket.add(msg))
            .listen(null, onDone: () {
          controller.close();
          _sendControllers.remove(id);
        });


        socket.listen(
              (message) {
            if (message == "server_heartbeat") {
              AegisLogger.debug("💓 Received heartbeat check, sending ACK...");
              out(socket, "server_heartbeat_ack");
              return;
            }

            _onMessageReceived?.call(message, socket);
          },
          onDone: () {
            AegisLogger.info("❌ Client disconnected: $id");
            _onDoneFromSocket?.call(socket);
            clients.remove(socket);
            _sendControllers.remove(id)?.close();
          },
          onError: (error) {
            AegisLogger.error("🚨 WebSocket error", error);
            clients.remove(socket);
            _sendControllers.remove(id)?.close();
          },
        );
        AegisLogger.info("🔗 Client connected: ${request.connectionInfo?.remoteAddress}");
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    });

    AegisLogger.info("✅ WebSocket server started on ws://127.0.0.1:$_port");
  }

  /// Enqueue an outgoing message; messages are sent in order
  void out(WebSocket socket, String message) {
    final controller = _sendControllers[socket.hashCode];
    if (controller != null && !controller.isClosed) {
      controller.add(message);
    } else {
      // Fallback if controller not ready
      socket.add(message);
    }
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
      AegisLogger.info("🛑 Stopping WebSocket server...");
      await serverNotifier.value!.close();
      for (var client in clients) {
        client.close();
        _sendControllers.remove(client.hashCode)?.close();
      }
      clients.clear();
      serverNotifier.value = null;
      AegisLogger.info("✅ WebSocket server stopped.");
    } else {
      AegisLogger.warning("⚠️ WebSocket server is not running.");
    }
  }

  /// Close a single client by its hashCode
  Future<void> closeClientByHashCode(int socketHashCode) async {
    final index = clients.indexWhere((s) => s.hashCode == socketHashCode);
    if (index != -1) {
      final client = clients[index];
      AegisLogger.info("🔒 Closing client by hashCode: $socketHashCode");
      try {
        await client.close();
      } catch (e) {
        AegisLogger.warning("⚠️ Error closing client $socketHashCode", e);
      }
      clients.removeAt(index);
      _sendControllers.remove(socketHashCode)?.close();
    } else {
      AegisLogger.warning("⚠️ No client found with hashCode: $socketHashCode");
    }
  }
}
