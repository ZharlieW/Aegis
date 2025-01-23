import 'dart:async';
import 'dart:io';

class AegisHttpServer {
  static final AegisHttpServer sharedInstance = AegisHttpServer._internal();

  HttpServer? _server;
  late StreamSubscription _subscription;
  final String port = '8080';

  AegisHttpServer._internal();

  factory AegisHttpServer() {
    return sharedInstance;
  }


  Future<void> start() async {
    if (_server != null) {
      print('HTTP server is already running.');
      return;
    }

    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, int.parse(port));
      print('HTTP server started on http://127.0.0.1:$port');

      _subscription = _server!.listen((HttpRequest request) {
        _handleRequest(request);
      });
    } catch (e) {
      print('Error starting HTTP server: $e');
    }
  }

  void _handleRequest(HttpRequest request) {
    if (request.uri.path == '/hello') {
      request.response.statusCode = HttpStatus.ok;
      request.response.write('Hello, HTTP server!');
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not Found');
    }
    request.response.close();
  }

  Future<void> stop() async {
    if (_server == null) {
      print('HTTP server is not running.');
      return;
    }
    await _server?.close();
    await _subscription.cancel();
    _server = null;
    print('HTTP server stopped');
  }
}
