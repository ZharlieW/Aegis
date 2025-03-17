import 'dart:async';
import 'dart:io';

class AegisWebSocketServer {
  static final AegisWebSocketServer instance = AegisWebSocketServer._internal();
  factory AegisWebSocketServer() => instance;

  AegisWebSocketServer._internal();

  HttpServer? _server;
  final List<WebSocket> _clients = [];
  Function(String, WebSocket)? _onMessageReceived;
  String _port = "7651";

  Timer? _heartbeatTimer;
  Timer? _heartbeatTimeoutTimer;
  WebSocket? _selfSocket; // The WebSocket client of the server itself

  final int restartServerDelayedTimer = 3;
  final int timeoutServer = 3;

  /// Start the WebSocket server
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
              (message) {
            if (message == "server_heartbeat") {
              // After receiving a heartbeat request, the server directly replies without entering _onMessageReceived
              print("💓 Received heartbeat check, sending ACK...");
              socket.add("server_heartbeat_ack");
              return;
            }

            // Normal messages are handled by onMessageReceived
            _onMessageReceived?.call(message, socket);
          },
          onDone: () {
            print("❌ Client disconnected: ${socket.hashCode}");
            _clients.remove(socket);
          },
          onError: (error) {
            print("🚨 WebSocket error: $error");
            _clients.remove(socket);
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

    // Example Start the server self-check heartbeat
    _startSelfHeartbeat();
  }

  /// Stop the WebSocket server
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

  /// The server self-checks the heartbeat
  void _startSelfHeartbeat() async {
    try {
      _selfSocket = await WebSocket.connect("ws://127.0.0.1:$_port");
      print("🔄 Server self-check WebSocket connected.");

      _selfSocket!.listen(
            (message) {
          if (message == "server_heartbeat_ack") {
            print("💓 Server heartbeat acknowledged. Resetting timer...");
            _resetHeartbeatTimeout();
          }
        },
        onDone: _handleServerDisconnect,
        onError: (error) {
          print("🚨 Self WebSocket error: $error");
          _handleServerDisconnect();
        },
      );

      // Sending a heartbeat every 10 seconds
      _heartbeatTimer = Timer.periodic(Duration(seconds: 10), (timer) {
        if (_selfSocket!.readyState == WebSocket.open) {
          print("💓 Sending self-check heartbeat...");
          _selfSocket!.add("server_heartbeat");

          // If no ACK is received within 3 seconds, the server is offline
          _heartbeatTimeoutTimer?.cancel();
          _heartbeatTimeoutTimer = Timer(Duration(seconds: 3), () {
            print("⚠️ No server heartbeat ACK received! Restarting server...");
            _restartServer();
          });
        } else {
          print("⚠️ Self WebSocket is closed. Stopping heartbeat.");
          _heartbeatTimer?.cancel();
        }
      });

    } catch (e) {
      print("🚨 Failed to connect to self WebSocket: $e");
      _scheduleServerRestart();
    }
  }

  /// Reset the heartbeat timeout timer
  void _resetHeartbeatTimeout() {
    _heartbeatTimeoutTimer?.cancel();
  }

  /// The server is offline. Procedure
  void _handleServerDisconnect() {
    print("❌ Self WebSocket disconnected. Restarting server...");
    _restartServer();
  }

  /// Restart the WebSocket server
  void _restartServer() {
    stop().then((_) {
      Future.delayed(Duration(seconds: restartServerDelayedTimer), () => start(port: _port, onMessageReceived: _onMessageReceived!));
    });
  }

  /// Plan to restart the server in 3 seconds
  void _scheduleServerRestart() {
    Future.delayed(Duration(seconds: timeoutServer), _restartServer);
  }
}
