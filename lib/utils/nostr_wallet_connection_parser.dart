import 'dart:convert';

import 'package:aegis/utils/server_nip46_signer.dart';
import '../common/common_constant.dart';
import '../nostr/event.dart';
import '../nostr/signer/local_nostr_signer.dart';
import 'account.dart';
import 'aegis_websocket_server.dart';
import 'launch_scheme_utils.dart';

class Nip46NostrConnectInfo {
  final String server;
  final String secret;
  final String pubkey;
  final String scheme;
  final String image;
  final String name;
  final String relay;
  final int createTimestamp;

  Nip46NostrConnectInfo({
    required this.server,
    required this.secret,
    required this.pubkey,
    required this.scheme,
    required this.image,
    required this.name,
    required this.relay,
    required this.createTimestamp,
  });
}


class NostrWalletConnectionParserHandler {
  static Nip46NostrConnectInfo? parseUri(String? uri) {
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

      var pubkey = decodedUri.authority;

      print('🛜 server: $server');
      print('📶 relays: $relays');
      print('🔑 secret: $secret');
      print('🔑 pubkey: $pubkey');
      print('⏫ scheme: $scheme');
      print('🌲 lud16: $lud16');

      int timestamp = DateTime.now().millisecondsSinceEpoch;

      return Nip46NostrConnectInfo(
        image: image,
        name: name,
        relay: relays[0],
        createTimestamp: timestamp,
        server: server,
        secret: secret,
        pubkey: pubkey,
        scheme: scheme,
      );
    } catch (e) {
      print('Error parsing URI: $e');
      return null;
    }
  }

  static Future<String?> signAndEncrypt(
      String clientPubkey, String message) async {
    try {
      return await LocalNostrSigner.instance
          .nip44Encrypt(clientPubkey, message);
    } catch (e) {
      print('Error during encryption: $e');
      return null;
    }
  }

  static void sendEvent(
      String clientPubkey, String subscriptionId, String content) {
    if (AegisWebSocketServer.instance.clients.isEmpty) return;
    final socket = AegisWebSocketServer.instance.clients[0];
    final signEvent = Event.from(
      subscriptionId: subscriptionId,
      kind: 24133,
      tags: [
        ['p', clientPubkey]
      ],
      content: content,
      pubkey: LocalNostrSigner.instance.publicKey,
      privkey: LocalNostrSigner.instance.privateKey,
    );
    socket.add(signEvent.serialize());
    print('Event sent: ${signEvent.serialize()}');
  }

  static void sendAuthUrl(
    String subscriptionId,
    Nip46NostrConnectInfo connectInfo,
  ) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    final authResponse = jsonEncode({
      'id': 'nostr-connect-$timestamp',
      'result': 'auth_url',
      'error': '',
    });

    final authEncrypted =
        await signAndEncrypt(connectInfo.pubkey, authResponse);
    if (authEncrypted != null) {
      sendEvent(connectInfo.pubkey, subscriptionId, authEncrypted);
    }

    final secretResponse = jsonEncode({
      'id': 'nostr-connect-$timestamp',
      'result': connectInfo.secret,
    });

    final secretEncrypted =
        await signAndEncrypt(connectInfo.pubkey, secretResponse);
    if (secretEncrypted != null) {
      sendEvent(connectInfo.pubkey, subscriptionId, secretEncrypted);
    }
  }

  static Future<void> handleScheme(String? url) async {
    if (url == null) return;
    Nip46NostrConnectInfo? result = parseUri(url);

    if (result == null) return;
    Map<String, Nip46NostrConnectInfo> connectInfoList = Account.sharedInstance.nip46NostrConnectInfoMap.value;
    String clientPubkey = result.pubkey;
    connectInfoList[clientPubkey] = result;

    await Account.clientAuth(clientPubkey);

    List<dynamic>? reqInfo = Account.sharedInstance.clientReqMap[clientPubkey];
    if (reqInfo != null) {
      sendAuthUrl(reqInfo[1], result);
    }
    LaunchSchemeUtils.open(result.scheme);
  }
}
