import 'dart:convert';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/common_constant.dart';
import '../navigator/navigator.dart';
import '../nostr/event.dart';
import '../nostr/signer/local_nostr_signer.dart';
import '../pages/request/request_permission.dart';
import 'account.dart';
import 'aegis_websocket_server.dart';

class NostrWalletConnectionParserHandler {
  static Map<String, dynamic>? parseUri(String? uri) {
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

      return {
        'server': server,
        'relays': relays,
        'secret': secret,
        'pubkey': pubkey,
        'lud16': lud16,
        'scheme': scheme,
        'image': image,
        'name' : name,
      };
    } catch (e) {
      print('Error parsing URI: $e');
      return null;
    }
  }

  static Future<String?> signAndEncrypt(String clientPubkey, String message) async {
    try {
      return await LocalNostrSigner.instance.nip44Encrypt(clientPubkey, message);
    } catch (e) {
      print('Error during encryption: $e');
      return null;
    }
  }

  static void sendEvent(String clientPubkey, String subscriptionId, String content) {
    print('==AegisWebSocketServer.instance.clients==${AegisWebSocketServer.instance.clients}');
    if(AegisWebSocketServer.instance.clients.isEmpty) return;
    final socket = AegisWebSocketServer.instance.clients[0];
    final signEvent = Event.from(
      subscriptionId: subscriptionId,
      kind: 24133,
      tags: [['p', clientPubkey]],
      content: content,
      pubkey: LocalNostrSigner.instance.publicKey,
      privkey: LocalNostrSigner.instance.privateKey,
    );
    socket.add(signEvent.serialize());
    print('Event sent: ${signEvent.serialize()}');
  }

  static Future<void> launchScheme(String scheme) async {
    final uri = Uri.tryParse(scheme);
    if (uri != null) {
      await launchUrl(uri);
    } else {
      print('Invalid scheme URL');
    }
  }

  static Future<void> handleScheme(String? url) async {
    if (url == null) return;

    var result = parseUri(url);
    if (result == null) return;

    bool isAuthorized = await ServerNIP46Signer.instance.isClientAuthorized(Account.sharedInstance.currentPubkey,result['pubkey']);
    print('===isAuthorized===$isAuthorized');
    if(!isAuthorized){
      final status = await AegisNavigator.presentPage(
          AegisNavigator.navigatorKey.currentContext,
              (context) => RequestPermission(),
          fullscreenDialog: false);
      if (status == null || status == false) return null;
     await ServerNIP46Signer.instance.saveClientAuth(Account.sharedInstance.currentPubkey,result['pubkey']);
    }

    launchScheme(result['scheme']);

    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      final clientPubkey = result['pubkey'];
      if(Account.sharedInstance.clientReqMap[clientPubkey] == null) {
        return;
      }
      String subscriptionId = Account.sharedInstance.clientReqMap[clientPubkey]?[1];

      final authResponse = jsonEncode({
        'id': 'nostr-connect-$timestamp',
        'result': 'auth_url',
        'error': '',
      });

      final authEncrypted = await signAndEncrypt(clientPubkey, authResponse);
      if (authEncrypted != null) {
        sendEvent(clientPubkey, subscriptionId, authEncrypted);
      }

      final secretResponse = jsonEncode({
        'id': 'nostr-connect-$timestamp',
        'result': result['secret'],
      });

      final secretEncrypted = await signAndEncrypt(clientPubkey, secretResponse);
      if (secretEncrypted != null) {
        sendEvent(clientPubkey, subscriptionId, secretEncrypted);
      }

      Nip46NostrConnectInfo info = Nip46NostrConnectInfo(
          logo: result['image'],
          name: result['name'],
          relay: result['relays'][0],
          createTimestamp: timestamp,
      );
      Account.sharedInstance.nip46NostrConnectInfoList.value.add(info);
    } catch (e) {
      print('Error handling scheme: $e');
    }
  }
}
