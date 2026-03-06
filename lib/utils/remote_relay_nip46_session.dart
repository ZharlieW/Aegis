import 'dart:async';
import 'dart:convert';

import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/nostr/nostr.dart' show Event, Filter;
import 'package:aegis/nostr/nips/nip46/nostr_remote_request.dart';
import 'package:aegis/nostr/signer/local_nostr_signer.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/connect.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/nostr_wallet_connection_parser.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;

/// One-time NIP-46 signer session on a **remote** relay (e.g. from scanned QR).
/// Connects to the given relay, subscribes for kind 24133 with p = current user,
/// and handles connect/get_public_key (and optionally sign_event) from the given client.
/// Session is closed after first successful get_public_key or on TTL timeout.
class RemoteRelayNip46Session {
  RemoteRelayNip46Session._();

  static final RemoteRelayNip46Session instance = RemoteRelayNip46Session._();

  static const int _ttlMinutes = 10;

  String? _relayUrl;
  String? _clientPubkey;
  String? _subscriptionId;
  Timer? _ttlTimer;
  bool _closed = false;

  /// Whether a session is currently active (connected and listening).
  bool get isActive =>
      _relayUrl != null &&
      _clientPubkey != null &&
      _subscriptionId != null &&
      !_closed;

  /// Start a one-time remote signer session from a nostrconnect URI.
  /// Parses relay and client pubkey, saves app to DB, connects to relay,
  /// subscribes for kind 24133 (p = current user), and starts TTL timer.
  /// Returns true if session was started; false if already active or parse/login failed.
  static Future<bool> startFromNostrConnectUri(String nostrConnectUri) async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty || account.currentPrivkey.isEmpty) {
      AegisLogger.warning('RemoteRelayNip46Session: not logged in');
      return false;
    }

    final parsed = NostrWalletConnectionParserHandler.parseUri(nostrConnectUri);
    if (parsed == null) {
      AegisLogger.warning('RemoteRelayNip46Session: failed to parse nostrconnect URI');
      return false;
    }

    final relayUrl = parsed.relay;
    final clientPubkey = parsed.clientPubkey;
    if (relayUrl == null ||
        relayUrl.isEmpty ||
        clientPubkey.isEmpty ||
        !relayUrl.startsWith('ws')) {
      AegisLogger.warning(
          'RemoteRelayNip46Session: invalid relay or clientPubkey from URI');
      return false;
    }

    if (instance.isActive) {
      AegisLogger.info('RemoteRelayNip46Session: already active, closing previous');
      await instance.close();
    }

    return instance._start(relayUrl: relayUrl, clientPubkey: clientPubkey, app: parsed);
  }

  Future<bool> _start({
    required String relayUrl,
    required String clientPubkey,
    required ClientAuthDBISAR app,
  }) async {
    _relayUrl = relayUrl;
    _clientPubkey = clientPubkey;
    _closed = false;

    AccountManager.sharedInstance.addApplicationMap(app);
    Account.sharedInstance.addAuthToNostrConnectInfo(app);
    try {
      await ClientAuthDBISAR.saveFromDB(app);
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: failed to save app', e);
      _relayUrl = null;
      _clientPubkey = null;
      return false;
    }

    final connect = Connect.sharedInstance;
    connect.addConnectStatusListener(_onConnectStatus);
    await connect.connect(relayUrl, relayKind: RelayKind.remoteSigner);

    // If relay was already connected, we won't get status callback; subscribe now.
    final socket = connect.webSockets[relayUrl];
    if (socket?.connectStatus == 1) _subscribe();

    _ttlTimer = Timer(Duration(minutes: _ttlMinutes), () {
      AegisLogger.info('RemoteRelayNip46Session: TTL expired');
      close();
    });

    AegisLogger.info(
        'RemoteRelayNip46Session: started for relay=$relayUrl client=${clientPubkey.substring(0, 8)}...');
    return true;
  }

  void _onConnectStatus(String relay, int status, List<RelayKind> relayKinds) {
    if (relay != _relayUrl ||
        status != 1 ||
        !relayKinds.contains(RelayKind.remoteSigner)) return;
    _subscribe();
  }

  void _subscribe() {
    final relayUrl = _relayUrl;
    final clientPubkey = _clientPubkey;
    if (relayUrl == null || clientPubkey == null || _closed) return;

    final userPubkey = Account.sharedInstance.currentPubkey;
    if (userPubkey.isEmpty) return;

    if (_subscriptionId != null && _subscriptionId!.isNotEmpty) {
      Connect.sharedInstance.closeRequests(_subscriptionId!, relay: relayUrl);
    }

    final filter = Filter(kinds: [24133], p: [userPubkey]);
    _subscriptionId = Connect.sharedInstance.addSubscription(
      [filter],
      relays: [relayUrl],
      relayKinds: [RelayKind.remoteSigner],
      eventCallBack: _onEvent,
      closeSubscription: false,
    );
    AegisLogger.info('RemoteRelayNip46Session: subscribed on $relayUrl');
  }

  void _onEvent(Event event, String relay) {
    if (_closed || relay != _relayUrl) return;
    if (event.pubkey != _clientPubkey) return;

    _handleEvent(event);
  }

  Future<void> _handleEvent(Event event) async {
    final relayUrl = _relayUrl;
    final clientPubkey = _clientPubkey;
    if (relayUrl == null || clientPubkey == null || _closed) return;

    final userPubkey = Account.sharedInstance.currentPubkey;
    final serverPrivate = Account.sharedInstance.currentPrivkey;
    if (serverPrivate.isEmpty) return;

    NostrRemoteRequest? req;
    try {
      req = await NostrRemoteRequest.decrypt(
        event.content,
        event.pubkey,
        LocalNostrSigner.instance,
        serverPrivate,
      );
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: decrypt failed', e);
      return;
    }
    if (req == null) return;

    Map<String, dynamic> responseJson;
    try {
      responseJson = await _processRequest(req, event, serverPrivate, userPubkey);
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: process failed', e);
      responseJson = {'id': req.id, 'result': '', 'error': e.toString()};
    }

    final oneTimeDone = req.method == 'get_public_key' || req.method == 'connect';
    if (oneTimeDone) close();

    String? encrypted;
    try {
      encrypted = await LocalNostrSigner.instance.nip44Encrypt(
        serverPrivate,
        jsonEncode(responseJson),
        event.pubkey,
      );
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: encrypt response failed', e);
      return;
    }

    final responseEvent = Event.from(
      kind: event.kind,
      tags: [['p', event.pubkey]],
      content: encrypted ?? '',
      pubkey: userPubkey,
      privkey: serverPrivate,
    );

    try {
      Connect.sharedInstance.sendEvent(
        responseEvent,
        toRelays: [relayUrl],
        relayKinds: [RelayKind.remoteSigner],
      );
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: send response failed', e);
    }
  }

  Future<Map<String, dynamic>> _processRequest(
    NostrRemoteRequest req,
    Event event,
    String serverPrivate,
    String userPubkey,
  ) async {
    switch (req.method) {
      case 'connect':
        await _recordSignedEvent(
          eventId: req.id,
          eventKind: 24133,
          eventContent: 'Connection',
          pubkey: event.pubkey,
        );
        return {'id': req.id, 'result': 'ack', 'error': ''};

      case 'ping':
        await _recordSignedEvent(
          eventId: req.id,
          eventKind: 24133,
          eventContent: 'Ping',
          pubkey: event.pubkey,
        );
        return {'id': req.id, 'result': 'pong', 'error': ''};

      case 'get_public_key':
        await _recordSignedEvent(
          eventId: req.id,
          eventKind: 24133,
          eventContent: 'get_public_key',
          pubkey: event.pubkey,
        );
        return {'id': req.id, 'result': userPubkey, 'error': ''};

      case 'sign_event': {
        final contentStr = req.params.isNotEmpty ? req.params[0] : null;
        if (contentStr == null || contentStr.isEmpty) {
          return {'id': req.id, 'result': '', 'error': 'missing event json'};
        }
        try {
          final signed = await rust_api.signEvent(
            eventJson: contentStr,
            privateKey: serverPrivate,
          );
          await _recordSignedEvent(
            eventId: req.id,
            eventKind: 24133,
            eventContent: 'Signed event',
            pubkey: event.pubkey,
          );
          return {'id': req.id, 'result': signed, 'error': ''};
        } catch (e) {
          return {'id': req.id, 'result': '', 'error': e.toString()};
        }
      }

      default:
        return {'id': req.id, 'result': '', 'error': 'no ${req.method} method'};
    }
  }

  Future<void> _recordSignedEvent({
    required String eventId,
    required int eventKind,
    required String eventContent,
    required String pubkey,
  }) async {
    try {
      final app = AccountManager.sharedInstance.applicationMap[pubkey]?.value;
      await SignedEventManager.sharedInstance.recordSignedEvent(
        eventId: eventId,
        eventKind: eventKind,
        eventContent: eventContent,
        applicationName: app?.name ?? pubkey,
        applicationPubkey: pubkey,
        status: 1,
      );
    } catch (e) {
      AegisLogger.error('RemoteRelayNip46Session: recordSignedEvent failed', e);
    }
  }

  /// Close the session: unsubscribe and close the relay connection for remoteSigner.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _ttlTimer?.cancel();
    _ttlTimer = null;

    final relayUrl = _relayUrl;
    final subId = _subscriptionId;
    _relayUrl = null;
    _clientPubkey = null;
    _subscriptionId = null;

    if (relayUrl != null && subId != null && subId.isNotEmpty) {
      try {
        Connect.sharedInstance.closeRequests(subId, relay: relayUrl);
      } catch (e) {
        AegisLogger.error('RemoteRelayNip46Session: closeRequests failed', e);
      }
    }
    if (relayUrl != null) {
      try {
        await Connect.sharedInstance.closeConnects(
          [relayUrl],
          RelayKind.remoteSigner,
        );
      } catch (e) {
        AegisLogger.error('RemoteRelayNip46Session: closeConnects failed', e);
      }
    }
    Connect.sharedInstance.removeConnectStatusListener(_onConnectStatus);
    AegisLogger.info('RemoteRelayNip46Session: closed');
  }
}
