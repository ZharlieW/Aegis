import 'dart:io';
import 'dart:async';

class AegisWebSocketServer {
  static final AegisWebSocketServer instance = AegisWebSocketServer._internal();
  factory AegisWebSocketServer() => instance;

  AegisWebSocketServer._internal();

  HttpServer? _server;
  final List<WebSocket> _clients = [];
  Function(String, WebSocket)? _onMessageReceived;
  String _port = "7651"; 

  Future<void> start({String port = "7651", required Function(String, WebSocket) onMessageReceived}) async {
    if (_server != null) {
      print("⚠️ WebSocket server is already running on ws://127.0.0.1:$_port");
      return;
    }

    _port = port;
    _onMessageReceived = onMessageReceived;

    _server = await HttpServer.bind(InternetAddress.anyIPv4, int.tryParse(_port) ?? 7651);
    _server!.listen((HttpRequest request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        _clients.add(socket);
        socket.listen(
              (message) => _onMessageReceived?.call(message, socket),
          onDone: () {
            print("❌ The client is disconnected: ${socket.hashCode}");
            _clients.remove(socket);
          },
          onError: (error) {
            print("🚨 WebSocket error: $error");
            _clients.remove(socket);
          },
        );
        print("🔗 The client is connected: ${request.connectionInfo?.remoteAddress}");
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    });

    print("✅ WebSocket server is running on ws://127.0.0.1:$_port");
  }

  Future<void> stop() async {
    if (_server != null) {
      print("🛑 Stopping WebSocket server...");
      await _server!.close();
      for (var client in _clients) {
        client.close();
      }
      _clients.clear();
      _server = null;
      print("✅ WebSocket server stopped.");
    } else {
      print("⚠️ WebSocket server is not running.");
    }
  }
}