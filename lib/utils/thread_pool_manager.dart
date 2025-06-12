import 'dart:async';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'logger.dart';

class ThreadPoolManager {
  late Isolate _databaseIsolate;
  late Isolate _algorithmIsolate;
  late Isolate _otherIsolate;
  late SendPort _databaseSendPort;
  late SendPort _algorithmSendPort;
  late SendPort _otherSendPort;
  final RootIsolateToken? _rootIsolateToken;
  
  bool _isInitialized = false;
  Future<void>? _initializationFuture;

  /// singleton
  ThreadPoolManager._internal(this._rootIsolateToken);
  factory ThreadPoolManager() => sharedInstance;
  static final ThreadPoolManager sharedInstance =
  ThreadPoolManager._internal(RootIsolateToken.instance);

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    
    if (_initializationFuture != null) {
      return _initializationFuture!;
    }
    
    _initializationFuture = _doInitialize();
    return _initializationFuture!;
  }

  Future<void> _doInitialize() async {
    try {
      AegisLogger.info('start init ThreadPoolManager...');
      
      _databaseSendPort = await _createIsolate((sendPort) {
        _databaseIsolate = sendPort.isolate;
        return sendPort.sendPort;
      });
      
      _algorithmSendPort = await _createIsolate((sendPort) {
        _algorithmIsolate = sendPort.isolate;
        return sendPort.sendPort;
      });
      
      _otherSendPort = await _createIsolate((sendPort) {
        _otherIsolate = sendPort.isolate;
        return sendPort.sendPort;
      });
      
      _isInitialized = true;
      AegisLogger.info('ThreadPoolManager init success');
    } catch (e) {
      _initializationFuture = null; 
      AegisLogger.error('ThreadPoolManager init fail', e);
      rethrow;
    }
  }

  Future<SendPort> _createIsolate(Function(IsolateConfig) isolateConfig) async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
    final sendPort = await receivePort.first as SendPort;
    isolateConfig(IsolateConfig(isolate, sendPort));
    return sendPort;
  }

  Future<dynamic> _runTask(
      Future<dynamic> Function() task, SendPort sendPort, String taskType) async {
   
    if (!_isInitialized) {
      throw StateError('ThreadPoolManager has not been initialized yet. Please call the initialize() method first. Current task type: $taskType');
    }
    
    final completer = Completer<dynamic>();
    final port = ReceivePort();
    sendPort.send([task, port.sendPort, _rootIsolateToken]);
    
    Timer? timeoutTimer;
    timeoutTimer = Timer(Duration(seconds: 30), () {
      if (!completer.isCompleted) {
        port.close();
        completer.completeError(TimeoutException('$taskType time out', Duration(seconds: 30)));
        timeoutTimer?.cancel();
      }
    });
    
    port.listen((message) {
      timeoutTimer?.cancel();
      port.close();
      
      if (message is String && message.startsWith('Error: ')) {
        completer.completeError(Exception('$taskType task fail: $message'));
      } else {
        completer.complete(message);
      }
    });
    return completer.future;
  }

  Future<dynamic> runDatabaseTask(Future<dynamic> Function() task) {
    return _runTask(task, _databaseSendPort, 'Database');
  }

  Future<dynamic> runAlgorithmTask(Future<dynamic> Function() task) {
    return _runTask(task, _algorithmSendPort, 'Algorithm');
  }

  Future<dynamic> runOtherTask(Future<dynamic> Function() task) {
    return _runTask(task, _otherSendPort, 'Other');
  }

  void dispose() {
    if (_isInitialized) {
      _databaseIsolate.kill(priority: Isolate.immediate);
      _algorithmIsolate.kill(priority: Isolate.immediate);
      _otherIsolate.kill(priority: Isolate.immediate);
      _isInitialized = false;
      _initializationFuture = null;
      AegisLogger.info('ThreadPoolManager dispose');
    }
  }
}

class IsolateConfig {
  Isolate isolate;
  SendPort sendPort;
  IsolateConfig(this.isolate, this.sendPort);
}

void _isolateEntry(SendPort sendPort) {
  final port = ReceivePort();
  sendPort.send(port.sendPort);
  port.listen((message) async {
    if (message is List && message.length == 3) {
      final task = message[0] as Future Function();
      final replyPort = message[1] as SendPort;
      final rootIsolateToken = message[2] as RootIsolateToken?;
      try {
        // Attach root isolate token to the current isolate if available
        if (rootIsolateToken != null) {
          BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        }
        final result = await task();
        replyPort.send(result);
      } catch (e, stackTrace) {
        AegisLogger.error('_isolateEntry Error: $e', stackTrace);
        replyPort.send("Error: $e");
      }
    }
  });
}
