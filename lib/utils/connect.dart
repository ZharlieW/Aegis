import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:nostr_core_dart/nostr.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/thread_pool_manager.dart';
import 'package:aegis/utils/logger.dart';

/// notice callback
typedef NoticeCallBack = void Function(String notice, String relay);

/// send event callback
typedef OKCallBack = void Function(OKEvent ok, String relay);

/// request callback
typedef EventCallBack = void Function(Event event, String relay);
typedef EOSECallBack = void Function(
    String requestId, OKEvent ok, String relay, List<String> unCompletedRelays);

/// connect callback
typedef ConnectStatusCallBack = void Function(String relay, int status, List<RelayKind> relayKinds);

class Sends {
  String sendsId;
  List<String> relays;
  int sendsTime;
  String eventId;
  OKCallBack? okCallBack;
  String eventString;

  Sends(this.sendsId, this.relays, this.sendsTime, this.eventId, this.okCallBack, this.eventString);
}

class Requests {
  String requestId;
  List<String> relays;
  int requestTime;
  Map<String, String> subscriptions;
  EventCallBack? eventCallBack;
  EOSECallBack? eoseCallBack;
  String subscriptionString;
  bool closeSubscription;

  Requests(this.requestId, this.relays, this.requestTime, this.subscriptions, this.eventCallBack,
      this.eoseCallBack, this.subscriptionString, this.closeSubscription);
}

class AuthData {
  String challenge;
  String eventId;
  List<String> resendDatas;

  AuthData(this.challenge, this.eventId, this.resendDatas);
}

class ISocket {
  WebSocket? socket;

  /// connecting = 0;
  /// open = 1;
  /// closing = 2;
  /// closed = 3;
  int connectStatus;
  List<RelayKind> relayKinds = [];

  ISocket(this.socket, this.connectStatus, this.relayKinds);
}

enum RelayKind {
  general,
  dm,
  inbox,
  outbox,
  remoteSigner,
  notification,
  temp,
}

class Connect {
  Connect._internal() {
    startHeartBeat();
    listenConnectivity();
  }
  factory Connect() => sharedInstance;
  static final Connect sharedInstance = Connect._internal();

  static const int timeout = 10;
  static const int MAX_SUBSCRIPTIONS_COUNT = 15;

  NoticeCallBack? noticeCallBack;
  StreamSubscription? _connectivitySubscription;

  /// sockets
  Map<String, ISocket> webSockets = {};

  // subscriptionId+relay, Requests
  Map<String, Requests> requestsMap = {};
  // send event callback
  Map<String, Sends> sendsMap = {};
  // ConnectStatus listeners
  List<ConnectStatusCallBack> connectStatusListeners = [];
  // for timeout
  Timer? timer;
  // relay AUTH
  Map<String, AuthData> auths = {};

  Map<String, List<Future<bool>>> eventCheckerFutures = {};

  Map<String, List<String>> subscriptionsWaitingQueue = {};

  // Track active reconnection tasks for proper cleanup
  final Map<String, Timer> _reconnectionTimers = {};

  void startHeartBeat() {
    if (timer == null || timer!.isActive == false) {
      timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
        _checkTimeout();
      });
    }
    resetConnection(force: false);
  }

  Future<void> resetConnection({bool force = true}) async {
    for (var relay in webSockets.keys) {
      if (webSockets[relay]?.connectStatus != 3 && force) {
        webSockets[relay]?.connectStatus = 3;
        await webSockets[relay]?.socket?.close();
      }
      for (var relayKind in webSockets[relay]?.relayKinds ?? []) {
        connect(relay, relayKind: relayKind);
      }
    }
  }

  void listenConnectivity() {
    _connectivitySubscription ??=
        Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
          if (results.any((result) => result != ConnectivityResult.none)) {
            resetConnection(force: false);
          }
        });
  }

  // void _stopCheckTimeOut() {
  //   if (timer != null && timer!.isActive) {
  //     timer!.cancel();
  //   }
  // }

  void _checkTimeout() {
    var now = DateTime.now().millisecondsSinceEpoch;
    Iterable<String> okMapKeys = List<String>.from(sendsMap.keys);
    for (var eventId in okMapKeys) {
      var start = sendsMap[eventId]!.sendsTime;
      if (now - start > timeout * 1000) {
        // ok timeout
        OKEvent ok = OKEvent(eventId, false, 'Time Out');
        Iterable<String> relays = List<String>.from(sendsMap[eventId]!.relays);
        for (var relay in relays) {
          _handleOk(ok, relay);
        }
      }
    }
    Iterable<String> requestMapKeys = List<String>.from(requestsMap.keys);
    for (var requestMapKey in requestMapKeys) {
      var request = requestsMap[requestMapKey];
      if (request != null) {
        // call closeSubscription type eoseCallBack only once
        if (request.closeSubscription == false && request.eoseCallBack == null) continue;
        var start = request.requestTime;
        if (start > 0 && now - start > timeout * 1000) {
          // request timeout
          String relay = requestMapKey.substring(64);
          _handleEOSE(jsonEncode([request.requestId]), relay, true);
        }
      }
    }
  }

  void _setConnectStatus(String relay, int status) {
    webSockets[relay]?.connectStatus = status;
    for (var callBack in connectStatusListeners) {
      callBack(relay, status, webSockets[relay]?.relayKinds ?? []);
    }
  }

  void addConnectStatusListener(ConnectStatusCallBack callBack) {
    if (!connectStatusListeners.contains(callBack)) {
      connectStatusListeners.add(callBack);
    }
  }

  void removeConnectStatusListener(ConnectStatusCallBack callBack) {
    if (connectStatusListeners.contains(callBack)) {
      connectStatusListeners.remove(callBack);
    }
  }

  List<String> relays({List<RelayKind> relayKinds = const [RelayKind.general]}) {
    List<String> result = [];
    for (var relay in webSockets.keys) {
      if (webSockets[relay]?.connectStatus == 1 &&
          webSockets[relay]!.relayKinds.any((e) => relayKinds.contains(e))) {
        result.add(relay);
      }
    }
    return result;
  }

  Future<void> connect(String relay, {RelayKind relayKind = RelayKind.general}) async {
    AegisLogger.debug('connect to $relay, kind: ${relayKind.name}');
    if (relay.isEmpty) return;

    List<RelayKind> relayKinds = webSockets[relay]?.relayKinds ?? [relayKind];
    if (!relayKinds.contains(relayKind)) {
      relayKinds.add(relayKind);
    }
    webSockets[relay]?.relayKinds = relayKinds;
    // connecting or open
    if (webSockets[relay]?.connectStatus == 0 || webSockets[relay]?.connectStatus == 1) return;
    AegisLogger.debug("connecting... $relay");
    webSockets[relay] = ISocket(null, 0, relayKinds);
    try {
      WebSocket? socket;
      socket = await _connectWs(relay);
      if (socket != null) {
        socket.done.then((dynamic _) => _onDisconnected(relay, relayKind));
        _listenEvent(socket, relay, relayKind);
        webSockets[relay] = ISocket(socket, 1, relayKinds);
        AegisLogger.debug("$relay connection initialized");
        _setConnectStatus(relay, 1);
      }
    } catch (_) {
      _onDisconnected(relay, relayKind);
    }
  }

  Future<bool> connectRelays(List<String> relays, {RelayKind relayKind = RelayKind.general}) async {
    final completer = Completer<bool>();
    if (relays.isEmpty && !completer.isCompleted) completer.complete(true);
    if (relayKind == RelayKind.temp) {
      // timeout for temp relays
      Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          completer.complete(false);
          closeConnects(relays, relayKind);
        }
      });
    }
    for (String relay in relays) {
      connect(relay, relayKind: relayKind).then((value) {
        if (!completer.isCompleted) completer.complete(true);
      });
    }
    return completer.future;
  }

  Future closeConnects(List<String> relays, RelayKind relayKind) async {
    await Future.forEach(relays, (relay) async {
      webSockets[relay]?.relayKinds.removeWhere((e) => (e == RelayKind.temp || e == relayKind));
      if (webSockets[relay]?.relayKinds.isEmpty == true) {
        await closeConnect(relay);
      }
    });
  }

  Future closeTempConnects(List<String> relays) async {
    await closeConnects(relays, RelayKind.temp);
  }

  Future closeAllConnects() async {
    // Cancel all pending reconnection timers
    for (var timer in _reconnectionTimers.values) {
      timer.cancel();
    }
    _reconnectionTimers.clear();

    await Future.forEach(List.from(webSockets.keys), (relay) async {
      await closeConnect(relay);
    });

    // Clear all state
    sendsMap.clear();
    requestsMap.clear();
    auths.clear();
    eventCheckerFutures.clear();
    subscriptionsWaitingQueue.clear();
  }

  Future closeConnect(String relay) async {
    AegisLogger.debug('closeConnect ${webSockets[relay]?.socket}');
    final socket = webSockets[relay]?.socket;

    webSockets.remove(relay);

    // Cancel any pending reconnection for this relay
    _reconnectionTimers[relay]?.cancel();
    _reconnectionTimers.remove(relay);

    await socket?.close();
  }

  String addSubscription(List<Filter> filters,
      {EventCallBack? eventCallBack,
      EOSECallBack? eoseCallBack,
      List<String>? relays,
      List<RelayKind> relayKinds = const [RelayKind.general],
      bool closeSubscription = true}) {
    Map<String, List<Filter>> result = {};
    List<String> rs = [];
    if (relays != null) {
      rs = List.from(relays
          .where((relay) =>
              relay.isNotEmpty && (relay.startsWith('ws://') || relay.startsWith('wss://')))
          .toList());
    }
    List<String> subscriptionRelays =
        rs.isNotEmpty == true ? rs : Connect.sharedInstance.relays(relayKinds: relayKinds);
    if (subscriptionRelays.isEmpty) {
      eoseCallBack?.call('', OKEvent('', false, 'no relays connected'), '', []);
      return '';
    }
    for (var relay in subscriptionRelays) {
      result[relay] = filters;
    }
    return addSubscriptions(result,
        eventCallBack: eventCallBack,
        eoseCallBack: eoseCallBack,
        closeSubscription: closeSubscription);
  }

  String addSubscriptions(Map<String, List<Filter>> filters,
      {EventCallBack? eventCallBack, EOSECallBack? eoseCallBack, bool closeSubscription = true}) {
    /// Create a subscription message request with one or many filters
    String requestsId = generate64RandomHexChars();
    for (String relay in filters.keys) {
      Request requestWithFilter = Request(requestsId, filters[relay]!);
      String subscriptionString = requestWithFilter.serialize();

      /// add request to request map
      Requests requests = Requests(requestsId, filters.keys.toList(), 0, {}, eventCallBack,
          eoseCallBack, subscriptionString, closeSubscription);
      requests.subscriptions[relay] = requestWithFilter.subscriptionId;
      requestsMap[requestWithFilter.subscriptionId + relay] = requests;

      /// Send a request message to the WebSocket server
      _addSubscriptionToQueue(requestsId, relay);

      AegisLogger.debug('$subscriptionString, $relay');
    }
    return requestsId;
  }

  void _addSubscriptionToQueue(String subscriptionId, String relay) {
    var waitingQueue = subscriptionsWaitingQueue[relay] ?? [];
    if (!waitingQueue.contains(subscriptionId)) {
      waitingQueue.add(subscriptionId);
      subscriptionsWaitingQueue[relay] = waitingQueue;
    }
    _sendSubscription(relay);
  }

  void _sendSubscription(String relay) {
    var sendingQueue = 0;
    for (var key in requestsMap.keys) {
      if (key.contains(relay) &&
          requestsMap[key]!.relays.contains(relay) &&
          requestsMap[key]!.requestTime > 0) {
        ++sendingQueue;
      }
    }
    var waitingQueue = subscriptionsWaitingQueue[relay] ?? [];

    if (sendingQueue < MAX_SUBSCRIPTIONS_COUNT && waitingQueue.isNotEmpty) {
      String subscriptionId = waitingQueue.removeAt(0);
      var request = requestsMap[subscriptionId + relay];
      if (request != null) {
        requestsMap[subscriptionId + relay]!.requestTime = DateTime.now().millisecondsSinceEpoch;
        _send(request.subscriptionString, toRelays: [relay]);
      }
      } else {
        AegisLogger.debug(
            'sendingQueue: $sendingQueue, waitingQueue: ${waitingQueue.length}, $relay');
      }
  }

  Future _closeSubscription(String subscriptionId, String relay) async {
    AegisLogger.debug('send ${Close(subscriptionId).serialize()}, $relay');
    if (subscriptionId.isNotEmpty) {
      _send(Close(subscriptionId).serialize(), toRelays: [relay]);
      // remove the mapping
      requestsMap.remove(subscriptionId + relay);
      _sendSubscription(relay);
    }
  }

  Future closeRequests(String requestId, {String? relay}) async {
    Iterable<String> requestsMapKeys = List<String>.from(requestsMap.keys);
    for (var key in requestsMapKeys) {
      var requests = requestsMap[key];
      if (requests!.requestId == requestId) {
        if (relay != null) {
          if (requests.subscriptions[relay] != null) {
            await _closeSubscription(requests.subscriptions[relay]!, relay);
          }
        } else {
          for (var relay in relays()) {
            if (requests.subscriptions[relay] != null) {
              await _closeSubscription(requests.subscriptions[relay]!, relay);
            }
          }
        }
        return;
      }
    }
  }

  /// send an event to relay/relays
  void sendEvent(Event event,
      {OKCallBack? sendCallBack,
      List<String>? toRelays,
      List<RelayKind> relayKinds = const [
        RelayKind.general,
        RelayKind.outbox,
      ]}) {
    String eventString = event.serialize();
    List<String> rs = (toRelays == null || toRelays.isEmpty)
        ? relays(relayKinds: relayKinds)
        : List.from(toRelays);
    AegisLogger.debug('send event toRelays: ${jsonEncode(rs)}, eventString: $eventString');
    Sends sends = Sends(generate64RandomHexChars(), rs, DateTime.now().millisecondsSinceEpoch,
        event.id, sendCallBack, eventString);
    sendsMap[event.id] = sends;
    _send(eventString, toRelays: rs);
  }

  void _send(String data, {List<String>? toRelays, String? eventId, String? subscriptionId}) {
    if (toRelays != null && toRelays.isNotEmpty) {
      toRelays = Set.from(toRelays).cast<String>().toList();
      for (var relay in toRelays) {
        if (webSockets.containsKey(relay)) {
          var socket = webSockets[relay]?.socket;
          if (webSockets[relay]?.connectStatus == 1 && socket != null) {
            socket.add(data);
          } else if (eventId != null) {
            _handleOk(OKEvent(eventId, false, 'not connect to relay'), relay);
          } else if (subscriptionId != null) {
            _handleCLOSED(Closed(subscriptionId), relay);
          }
        } else if (eventId != null) {
          _handleOk(OKEvent(eventId, false, 'not connect to relay'), relay);
        } else if (subscriptionId != null) {
          _handleCLOSED(Closed(subscriptionId), relay);
        }
      }
    } else {
      webSockets.forEach((url, socket) {
        if (webSockets[url]?.connectStatus == 1 && socket.socket != null) {
          socket.socket?.add(data);
        } else if (eventId != null) {
          _handleOk(OKEvent(eventId, false, 'not connect to relay'), url);
        } else if (subscriptionId != null) {
          _handleCLOSED(Closed(subscriptionId), url);
        }
      });
    }
  }

  static Future<Message> _deserializeMessage(String message) async {
    return await Message.deserialize(message);
  }

  Future<void> _handleMessage(String message, String relay) async {
    var m = await ThreadPoolManager.sharedInstance.runOtherTask(() => _deserializeMessage(message));
    switch (m.type) {
      case "EVENT":
        _handleEvent(m.message, relay);
        break;
      case "EOSE":
        _handleEOSE(m.message, relay, false);
        break;
      case "CLOSED":
        _handleCLOSED(m.message, relay);
        break;
      case "NOTICE":
      case "NOTIFY":
        _handleNotice(m.message, relay);
        break;
      case "OK":
        _handleOk(m.message, relay);
        break;
      case "AUTH":
        _handleAuth(m.message, relay);
        break;
      default:
        AegisLogger.debug('Received message not supported: $message');
        break;
    }
  }

  Future<bool> _checkValidEvent(Event event, String relay) async {
    String? subscriptionId = event.subscriptionId;
    if (subscriptionId != null) {
      String requestsMapKey = subscriptionId + relay;
      if (subscriptionId.isNotEmpty && requestsMap.containsKey(requestsMapKey)) {
        // reset requestTime
        requestsMap[requestsMapKey]!.requestTime = DateTime.now().millisecondsSinceEpoch;
        EventCallBack? callBack = requestsMap[requestsMapKey]!.eventCallBack;
        if (callBack != null) {
          // check sign
          if (await event.isValid() == false) {
            return false;
          }
          callBack(event, relay);
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _handleEvent(Event event, String relay) async {
    AegisLogger.debug('Received event, subscriptionId: ${event.subscriptionId}, ${event.toJson()}');
    // ignore the expired event
    if (Nip40.expired(event)) {
      return;
    }

    Future<bool> future = _checkValidEvent(event, relay);
    if (event.subscriptionId != null && event.subscriptionId!.isNotEmpty) {
      eventCheckerFutures[event.subscriptionId! + relay] ??= [];
      eventCheckerFutures[event.subscriptionId! + relay]?.add(future);
    }
  }

  Future<void> _handleEOSE(String eose, String relay, bool timeout) async {
    AegisLogger.debug('receive EOSE: $eose, $relay, timeout: $timeout');
    String subscriptionId = jsonDecode(eose)[0];
    String requestsMapKey = subscriptionId + relay;
    if (subscriptionId.isNotEmpty && requestsMap.containsKey(requestsMapKey)) {
      if (eventCheckerFutures.containsKey(requestsMapKey)) {
        await Future.wait(eventCheckerFutures[requestsMapKey]!);
        eventCheckerFutures.remove(requestsMapKey);
      }
      _removeRequestsMapRelay(subscriptionId, relay, timeout);
    }
  }

  void _handleCLOSED(Closed closed, String relay) {
    AegisLogger.debug('receive closed: ${closed.serialize()}, $relay');
    String subscriptionId = closed.subscriptionId;
    String requestsMapKey = subscriptionId + relay;
    if (subscriptionId.isNotEmpty && requestsMap.containsKey(requestsMapKey)) {
      // check auth
      if (Nip42.authRequired(closed.message)) {
        String subscriptionString = requestsMap[requestsMapKey]!.subscriptionString;
        if (auths[relay]?.resendDatas.contains(subscriptionString) == false) {
          auths[relay]?.resendDatas.add(subscriptionString);
        }
        _sendAuth(relay);
        return;
      }
      _removeRequestsMapRelay(subscriptionId, relay, true);
    }
  }

  void _handleNotice(String notice, String relay) {
    AegisLogger.debug('receive notice: $notice, $relay');
    String n = jsonDecode(notice)[0];

    List<String> requestsMapKeys =
        requestsMap.keys.where((element) => element.contains(relay)).toList();
    for (var requestsMapKey in requestsMapKeys) {
      _removeRequestsMapRelay(requestsMapKey.replaceAll(relay, ''), relay, true);
    }

    noticeCallBack?.call(n, relay);
  }

  Future<void> _handleOk(OKEvent ok, String relay) async {
    AegisLogger.debug('receive ok: ${ok.serialize()}, $relay');
    // check auth response
    if (auths[relay]?.eventId == ok.eventId) {
      if (ok.status) {
        for (var data in auths[relay]?.resendDatas ?? []) {
          AegisLogger.debug('re-send: $data');
          _send(data, toRelays: [relay]);
        }
      }
      auths.remove(relay);
      return;
    }
    if (sendsMap.containsKey(ok.eventId)) {
      // check need auth
      if (!ok.status && Nip42.authRequired(ok.message)) {
        String eventString = sendsMap[ok.eventId]!.eventString;
        if (auths[relay]?.resendDatas.contains(eventString) == false) {
          auths[relay]?.resendDatas.add(eventString);
        }
        _sendAuth(relay);
        return;
      }
      // callback
      if (sendsMap[ok.eventId]!.okCallBack != null) {
        var relays = sendsMap[ok.eventId]!.relays;
        relays.remove(relay);
        if (ok.status || relays.isEmpty) {
          sendsMap[ok.eventId]!.okCallBack!(ok, relay);
          sendsMap.remove(ok.eventId);
        } else if (!ok.status && ok.eventId.isEmpty) {
          List<String> requestsMapKeys =
              requestsMap.keys.where((element) => element.contains(relay)).toList();
          for (var requestsMapKey in requestsMapKeys) {
            _removeRequestsMapRelay(requestsMapKey.replaceAll(relay, ''), relay, true);
          }
        }
      } else {
        var relays = sendsMap[ok.eventId]!.relays;
        relays.remove(relay);
        if (relays.isEmpty) sendsMap.remove(ok.eventId);
      }
    }
  }

  void _handleAuth(Auth auth, String relay) {
    AegisLogger.debug('receive auth: ${auth.challenge}');
    if (!auths.containsKey(relay)) {
      auths[relay] = AuthData(auth.challenge, '', []);
    } else if (auths[relay]?.challenge != auth.challenge) {
      auths[relay]?.challenge = auth.challenge;
      auths[relay]?.eventId = '';
    }
  }

  void _removeRequestsMapRelay(String subscriptionId, String removeRelay, bool error) {
    var requestsMapKey = subscriptionId + removeRelay;
    var request = requestsMap[requestsMapKey];
    if (request == null) return;
    request.relays.remove(removeRelay);
    // remove others relay
    for (var r in requestsMap.values) {
      if (r.requestId == request.requestId) {
        r.relays.remove(removeRelay);
      }
    }
    // all relays have EOSE
    EOSECallBack? callBack = request.eoseCallBack;
    OKEvent ok = OKEvent(subscriptionId, !error, '');
    if (callBack != null) callBack(subscriptionId, ok, removeRelay, request.relays);
    requestsMap[requestsMapKey]?.eoseCallBack = null;
    if (request.closeSubscription) _closeSubscription(subscriptionId, removeRelay);
  }

  Future<void> _sendAuth(String relay) async {
    String? challenge = auths[relay]?.challenge;
    if (challenge == null || challenge.isEmpty) return;
    String? eventId = auths[relay]?.eventId;
    if (eventId?.isNotEmpty == true) return;
    auths[relay]!.eventId = 'sending...';
    Event event = await Nip42.encode(challenge, relay, Account.sharedInstance.currentPubkey,
        Account.sharedInstance.currentPrivkey);
    var authJson = Nip42.authString(event);
    auths[relay]!.eventId = event.id;
    AegisLogger.debug('send auth: $authJson');
    _send(authJson, toRelays: [relay]);
  }

  Future<void> _reConnectToRelay(String relay, RelayKind relayKind) async {
    _setConnectStatus(relay, 3); // closed

    // Check if this relay is still managed (not closed)
    if (!webSockets.containsKey(relay)) {
      AegisLogger.debug('Skipping reconnection for relay no longer managed: $relay');
      return;
    }

    // Cancel any existing reconnection timer for this relay
    _reconnectionTimers[relay]?.cancel();

    // Schedule new reconnection attempt
    _reconnectionTimers[relay] = Timer(const Duration(milliseconds: 3000), () {
      // Double check if reconnection is still needed
      if (webSockets.containsKey(relay)) {
        connect(relay, relayKind: relayKind);
      }
      // Clean up the timer reference
      _reconnectionTimers.remove(relay);
    });
  }

  void _listenEvent(WebSocket socket, String relay, RelayKind relayKind) {
    socket.listen((message) async {
      await _handleMessage(message, relay);
    }, onDone: () async {
      AegisLogger.debug("connect aborted");
      await _reConnectToRelay(relay, relayKind);
    }, onError: (e) async {
      AegisLogger.debug('Server error: $e');
      await _reConnectToRelay(relay, relayKind);
    });
  }

  Future _connectWs(String relay) async {
    try {
      _setConnectStatus(relay, 0); // connecting
      return await _connectWsSetting(relay);
    } catch (e) {
      AegisLogger.debug("Error! can not connect WS connectWs $e relay:$relay");
      _setConnectStatus(relay, 3); // closed

      List<RelayKind>? relayKinds = webSockets[relay]?.relayKinds;
      bool hasNonTempKind = relayKinds?.any((kind) => kind != RelayKind.temp) ?? false;
      if (hasNonTempKind && webSockets.containsKey(relay)) {
        // Cancel any existing reconnection timer for this relay
        _reconnectionTimers[relay]?.cancel();

        // Schedule new connection attempt
        _reconnectionTimers[relay] = Timer(const Duration(milliseconds: 3000), () {
          if (webSockets.containsKey(relay)) {
            _connectWs(relay);
          }
          _reconnectionTimers.remove(relay);
        });
      }
    }
  }

  Future _connectWsSetting(String relay) async {
    return await WebSocket.connect(relay);
  }

  Future<void> _onDisconnected(String relay, RelayKind relayKind) async {
    AegisLogger.debug("_onDisconnected");
    return await _reConnectToRelay(relay, relayKind);
  }
}
