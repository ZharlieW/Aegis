import 'dart:async';
import 'dart:io';

class AegisWebSocketServer {
  static final AegisWebSocketServer sharedInstance = AegisWebSocketServer._internal();

  HttpServer? _server;
  late StreamSubscription _subscription;
  final String port = '8080';


  AegisWebSocketServer._internal();

  factory AegisWebSocketServer() {
    return sharedInstance;
  }


  Future<void> start() async {
    if (_server != null) {
      print('WebSocket server is already running.');
      return;
    }

    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, int.parse(port));
      print('WebSocket server started on ws://127.0.0.1:$port');

      _subscription = _server!.listen((HttpRequest request) async {
        if (request.headers.value('upgrade') == 'websocket') {
          WebSocket socket = await WebSocketTransformer.upgrade(request);
          print('New connection from ${request.connectionInfo?.remoteAddress}');

          socket.listen((message) {
              print('Received message: $message');
              socket.add('Hello from server: $message');
            },
            onDone: () => _onClientDisconnected(socket),
            onError: (error) => _onError(socket, error),
          );
        } else {
          request.response.statusCode = HttpStatus.badRequest;
          request.response.write('Invalid request');
          await request.response.close();
        }
      });
    } catch (e) {
      print('Error starting WebSocket server: $e');
    }
  }

  void _onClientDisconnected(WebSocket socket) {
    print('Client disconnected');
    socket.close();
  }

  void _onError(WebSocket socket, error) {
    print('Error occurred: $error');
    socket.close();
  }

  Future<void> stop() async {
    if (_server == null) {
      print('WebSocket server is not running.');
      return;
    }
    await _server?.close();
    await _subscription.cancel();
    _server = null;
    print('WebSocket server stopped');
  }

  static Future<String> getLocalIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (!addr.isLoopback) {
            return addr.address;
          }
        }
      }
      throw Exception('Unable to find a valid local IP address');
    } catch (e) {
      throw Exception('Error getting local IP address: $e');
    }
  }
}