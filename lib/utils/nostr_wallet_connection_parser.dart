import 'dart:convert';

import 'package:aegis/db/clientAuthDB_isar.dart';
import '../common/common_constant.dart';
import '../nostr/event.dart' as local_event;
import '../nostr/signer/local_nostr_signer.dart';
import 'package:nostr_core_dart/nostr.dart' show Event;
import 'account.dart';
import 'connect.dart';
import 'url_scheme_handler.dart';
import 'logger.dart';

class NostrWalletConnectionParserHandler {
  static ClientAuthDBISAR? parseUri(String? uri) {
    if (uri == null) return null;
    String decodeUri = Uri.decodeComponent(uri);
    if (!decodeUri.startsWith(NIP46_NOSTR_CONNECT_PROTOCOL)) return null;

    try {
      var decodedUri = Uri.parse(decodeUri);
      var server = decodedUri.host;
      var queryParams = decodedUri.queryParametersAll;
      var relays = queryParams['relay'] ?? [];
      var secret = queryParams['secret']?.first ?? '';
      var lud16 = queryParams['lud16']?.first;
      var scheme = queryParams['scheme']?.first ?? '';
      var image = queryParams['image']?.first ?? '';
      var name = queryParams['name']?.first ?? '';

      var clientPubkey = decodedUri.authority;

      print('🛜 server: $server');
      print('📶 relays: $relays');
      print('🔑 secret: $secret');
      print('🔑 clientPubkey: $clientPubkey');
      print('⏫ scheme: $scheme');
      print('🌲 lud16: $lud16');

      int timestamp = DateTime.now().millisecondsSinceEpoch;

      return ClientAuthDBISAR(
        clientPubkey: clientPubkey,
        image: image,
        name: name,
        relay: relays[0],
        createTimestamp: timestamp,
        server: server,
        secret: secret,
        pubkey: Account.sharedInstance.currentPubkey,
        scheme: scheme,
        connectionType: EConnectionType.nostrconnect.toInt,
      );
    } catch (e) {
      print('Error parsing URI: $e');
      return null;
    }
  }

  static Future<String?> signAndEncrypt(
      String serverPrivate, String message,String clientPubkey) async {
    try {
      return await LocalNostrSigner.instance.nip44Encrypt(serverPrivate, message,clientPubkey);
    } catch (e) {
      print('Error during encryption: $e');
      return null;
    }
  }

  static void sendEvent(
      String clientPubkey,
      String subscriptionId,
      String content,
      ) async {
    try {
      LocalNostrSigner instance = LocalNostrSigner.instance;
      // Use local Event.from to create and sign the event
      final localSignEvent = local_event.Event.from(
        kind: 24133,
        tags: [
          ['p', clientPubkey]
        ],
        content: content,
        pubkey: instance.getPublicKey(clientPubkey) ?? '',
        privkey: instance.getPrivateKey(clientPubkey) ?? '',
      );
      
      // Convert to nostr_core_dart Event using fromJson (async)
      final signEvent = await Event.fromJson(localSignEvent.toJson());
      
      // Use Connect to send event
      final connect = Connect();
      // Find the relay URL for this client pubkey from account
      final account = Account.sharedInstance;
      final client = account.authToNostrConnectInfo[clientPubkey];
      final relay = client?.relay;
      if (relay != null && relay.isNotEmpty) {
        // Connect to the relay if not already connected
        await connect.connect(relay, relayKind: RelayKind.general);
        // Send event using Connect
        connect.sendEvent(
          signEvent,
          toRelays: [relay],
          relayKinds: [RelayKind.general],
        );
      }
    } catch (e) {
      AegisLogger.error('Failed to send event', e);
    }
  }

  static void sendAuthUrl(
    String subscriptionId,
    ClientAuthDBISAR connectInfo,
  ) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    final authResponse = jsonEncode({
      'id': 'nostr-connect-$timestamp',
      'result': 'auth_url',
      'error': '',
    });

    String serverPrivate = Account.sharedInstance.currentPrivkey;

    final authEncrypted = await signAndEncrypt(serverPrivate, authResponse,connectInfo.clientPubkey);
    if (authEncrypted != null) {
      sendEvent(connectInfo.clientPubkey, subscriptionId, authEncrypted);
    }

    final secretResponse = jsonEncode({
      'id': 'nostr-connect-$timestamp',
      'result': connectInfo.secret,
    });

    final secretEncrypted =
        await signAndEncrypt(serverPrivate, secretResponse,connectInfo.clientPubkey);
    if (secretEncrypted != null) {
      sendEvent(connectInfo.clientPubkey, subscriptionId, secretEncrypted);
    }
  }

  static Future<void> handleScheme(String? url) async {
    await UrlSchemeHandler.handleScheme(url);
  }
}

