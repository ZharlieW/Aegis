import 'dart:io';
import 'dart:async';

class AegisWebSocketServer {
  final int port;
  final Function(String, WebSocket) onMessageReceived;

  AegisWebSocketServer({required this.port, required this.onMessageReceived});

  Future<void> start() async {
    HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    server.listen((HttpRequest request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        socket.listen(
          (message) => onMessageReceived(message, socket),
          onDone: () => print("❌ 客户端断开连接"),
          onError: (error) => print("🚨 WebSocket 错误: $error"),
        );
        print("🔗 客户端连接: ${request.connectionInfo?.remoteAddress}");
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    });
    print("✅ WebSocket 服务器运行在 ws://127.0.0.1:$port");
  }

  void stop() {
    // 关闭 WebSocket 服务器
  }
}

// class AegisWebSocketServer {
//   /// 单例实例
//   static final AegisWebSocketServer _instance =
//       AegisWebSocketServer._internal();
//
//   /// 获取单例
//   static AegisWebSocketServer get sharedInstance => _instance;
//
//   Function(String)? onMessageReceived; // 外部消息接收回调
//   Function(WebSocket)? onClientConnected; // 外部连接回调
//   Function(WebSocket)? onClientDisconnected; // 外部断开连接回调
//   Function(dynamic)? onErrorOccurred; // 外部错误回调
//
//   HttpServer? _server;
//   final List<WebSocket> _clients = [];
//   bool _isStarted = false;
//
//   /// 私有构造函数，防止外部实例化
//   AegisWebSocketServer._internal();
//
//   /// 启动 WebSocket 服务器
//   Future<void> start({int port = 8080}) async {
//     if (_isStarted) {
//       print("⚠️ WebSocket 服务器已经运行");
//       return;
//     }
//
//     try {
//       _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
//       _isStarted = true;
//       print("✅ WebSocket 服务器运行在 ws://127.0.0.1:$port");
//
//       _server?.listen((HttpRequest request) async {
//         if (WebSocketTransformer.isUpgradeRequest(request)) {
//           WebSocket socket = await WebSocketTransformer.upgrade(request);
//           _clients.add(socket);
//           print("🔗 客户端连接: ${request.connectionInfo?.remoteAddress}");
//
//           socket.listen(
//             (message) {
//               print("📥 收到消息: $message");
//               onMessageReceived?.call(message);
//               _broadcast(message);
//             },
//             onDone: () => _onClientDisconnected(socket),
//             onError: (error) => _onError(socket, error),
//           );
//         } else {
//           request.response
//             ..statusCode = HttpStatus.forbidden
//             ..close();
//         }
//       });
//     } catch (e) {
//       print("❌ 启动 WebSocket 服务器失败: $e");
//     }
//   }
//
//   /// 广播消息给所有客户端
//   void _broadcast(String message) {
//     for (var client in _clients) {
//       if (client.readyState == WebSocket.open) {
//         client.add(message);
//       }
//     }
//   }
//
//   /// 处理客户端断开连接
//   void _onClientDisconnected(WebSocket socket) {
//     _clients.remove(socket);
//     print("❌ 客户端断开: ${socket.hashCode}");
//     socket.close();
//   }
//
//   /// 处理 WebSocket 错误
//   void _onError(WebSocket socket, error) {
//     print("🚨 WebSocket 错误: $error");
//     socket.close();
//   }
//
//   /// 停止 WebSocket 服务器
//   Future<void> stop() async {
//     if (!_isStarted) {
//       print("⚠️ WebSocket 服务器未运行");
//       return;
//     }
//
//     await _server?.close();
//     _server = null;
//     _isStarted = false;
//
//     for (var client in _clients) {
//       client.close();
//     }
//     _clients.clear();
//
//     print("🛑 WebSocket 服务器已停止");
//   }
//
//   /// WebSocket 服务器是否已启动
//   bool isStarted() => _isStarted;
// }
