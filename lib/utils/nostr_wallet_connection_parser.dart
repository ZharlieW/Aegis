import 'dart:convert';

import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/utils/account_manager.dart';
import '../common/common_constant.dart';
import '../nostr/event.dart';
import '../nostr/signer/local_nostr_signer.dart';
import 'account.dart';
import 'aegis_websocket_server.dart';
import 'launch_scheme_utils.dart';

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
      ) {
    if (AegisWebSocketServer.instance.clients.isEmpty) return;
    final socket = AegisWebSocketServer.instance.clients[0];
    LocalNostrSigner instance = LocalNostrSigner.instance;
    final signEvent = Event.from(
      subscriptionId: subscriptionId,
      kind: 24133,
      tags: [
        ['p', clientPubkey]
      ],
      content: content,
      pubkey: instance.getPublicKey(clientPubkey) ?? '',
      privkey: instance.getPrivateKey(clientPubkey) ?? '',
    );
    socket.add(signEvent.serialize());
    print('Event sent: ===>${signEvent.serialize()}');
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
    if (url == null) return;

    void openError(String? cb, String code, String msg) {
      if (cb == null) return;
      final uriStr = '$cb?x-source=aegis&errorCode=$code&errorMessage=${Uri.encodeComponent(msg)}';
      LaunchSchemeUtils.open(uriStr);
    }

    void openSuccess(String? cb) {
      if (cb == null) return;
      LaunchSchemeUtils.open('$cb?x-source=aegis');
    }

    const errInvalid = 'INVALID_PARAM';
    const errCancel  = 'USER_CANCEL';
    const errParse   = 'PARSE_FAIL';

    String? encodedNc;
    String? successCallback;
    String? errorCallback;

    if (url.startsWith('aegis://')) {
      try {
        final uri = Uri.parse(Uri.decodeComponent(url));
        if (uri.host == 'x-callback-url' && uri.path == '/nip46Auth') {
          encodedNc = uri.queryParameters['nostrconnect'];
          successCallback = uri.queryParameters['x-success'];
          errorCallback = uri.queryParameters['x-error'];
          if (encodedNc == null) {
            openError(errorCallback, errInvalid, 'Missing nostrconnect parameter');
            return;
          }
          url = Uri.decodeComponent(encodedNc);
        }
      } catch (e) {
        openError(errorCallback, errParse, 'Malformed nip46Auth uri');
        return;
      }
    }

    ClientAuthDBISAR? result = parseUri(url);
    if (result == null) {
      openError(errorCallback, errParse, 'Failed to parse nostrconnect uri');
      return;
    }

    String clientPubkey = result.clientPubkey;
    Account accountInstance = Account.sharedInstance;
    AccountManager accountManagerInstance = AccountManager.sharedInstance;

    ClientAuthDBISAR? hasClient =
        accountManagerInstance.applicationMap[clientPubkey]?.value;
    if (hasClient == null) {
      bool isSuccess = await Account.authToClient();
      if (!isSuccess) {
        openError(errorCallback, errCancel, 'User cancelled authorization');
        return;
      }
    }

    accountManagerInstance.addApplicationMap(result);
    await ClientAuthDBISAR.saveFromDB(result);

    List<dynamic>? reqInfo = accountInstance.clientReqMap[clientPubkey];
    accountInstance.addAuthToNostrConnectInfo(result);
    if (reqInfo != null) {
      sendAuthUrl(reqInfo[1], result);
    }

    if (successCallback != null) {
      openSuccess(successCallback);
    } else if (result.scheme != null && result.scheme!.isNotEmpty) {
      LaunchSchemeUtils.open(result.scheme!);
    }
  }
}

