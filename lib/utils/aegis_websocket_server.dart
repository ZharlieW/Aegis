import 'dart:io';
import 'dart:async';

class AegisWebSocketServer {
  final String port;
  final Function(String, WebSocket) onMessageReceived;

  AegisWebSocketServer({required this.port, required this.onMessageReceived});

  Future<void> start() async {
    HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, int.tryParse(port) ?? 7651);
    server.listen((HttpRequest request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        socket.listen(
          (message) => onMessageReceived(message, socket),
          onDone: () => print("❌ The client is disconnected"),
          onError: (error) => print("🚨 WebSocket error: $error"),
        );
        print("🔗 The client is disconnected: ${request.connectionInfo?.remoteAddress}");
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    });
    print("✅ WebSocket The server runs on ws://127.0.0.1:$port");
  }

  void stop() {
    //
  }
}
