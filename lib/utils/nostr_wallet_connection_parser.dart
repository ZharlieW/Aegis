import 'dart:convert';

import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/common/common_constant.dart';
import 'package:aegis/nostr/nostr.dart' show Event;
import 'package:aegis/nostr/signer/local_nostr_signer.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/connect.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:aegis/utils/url_scheme_handler.dart';
import 'package:aegis/utils/logger.dart';

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
      var urlParam = queryParams['url']?.first ?? '';
      if (scheme.isEmpty && urlParam.isNotEmpty) {
        scheme = urlParam.startsWith('http') ? urlParam : 'https://$urlParam';
      }
      var image = queryParams['image']?.first ?? '';
      var name = queryParams['name']?.first ?? '';

      // Parse perms from query param and/or metadata JSON (Amber-style). Comma-separated: "get_public_key,sign_event:0,..."
      List<String> allowedMethods = _parsePermsFromUri(queryParams, decodedUri);

      var clientPubkey = decodedUri.authority;

      print('🛜 server: $server');
      print('📶 relays: $relays');
      print('🔑 secret: $secret');
      print('🔑 clientPubkey: $clientPubkey');
      print('⏫ scheme: $scheme');
      print('🌲 lud16: $lud16');

      final relayList =
          relays.cast<String>().where((r) => r.startsWith('ws')).toList();
      if (relayList.isEmpty) return null;

      int timestamp = DateTime.now().millisecondsSinceEpoch;
      return ClientAuthDBISAR(
        clientPubkey: clientPubkey,
        image: image,
        name: name,
        relay: relayList[0],
        createTimestamp: timestamp,
        server: server,
        secret: secret,
        pubkey: Account.sharedInstance.currentPubkey,
        scheme: scheme,
        connectionType: EConnectionType.nostrconnect.toInt,
        allRelays: relayList,
        allowedMethodsParam: allowedMethods,
        declaredMethodsParam: allowedMethods,
      );
    } catch (e) {
      print('Error parsing URI: $e');
      return null;
    }
  }

  /// Parses perms from Nostr Connect URI (query param "perms" and/or "metadata" JSON).
  /// Returns list of allowed methods (e.g. get_public_key, sign_event:0).
  /// If client does not declare perms, returns empty list so permission page shows "will request as needed"; used methods are added at runtime via _addUsedMethodToApp.
  static List<String> _parsePermsFromUri(
    Map<String, List<String>> queryParamsAll,
    Uri decodedUri,
  ) {
    final supported = ServerNIP46Signer.supportedNip46Methods;
    final Set<String> collected = {};

    void addPerms(String? raw) {
      if (raw == null || raw.isEmpty) return;
      for (final p in raw.split(',')) {
        final s = p.trim();
        if (s.isEmpty) continue;
        if (supported.contains(s)) {
          collected.add(s);
        }
      }
    }

    addPerms(queryParamsAll['perms']?.first);
    final metadataStr = queryParamsAll['metadata']?.first;
    if (metadataStr != null && metadataStr.isNotEmpty) {
      try {
        final map = jsonDecode(metadataStr) as Map<String, dynamic>?;
        final perms = map?['perms'];
        if (perms is String) addPerms(perms);
      } catch (_) {}
    }

    if (collected.isEmpty) return [];
    return collected.toList()
      ..sort((a, b) => supported.indexOf(a).compareTo(supported.indexOf(b)));
  }

  static Future<String?> signAndEncrypt(
      String serverPrivate, String message, String clientPubkey) async {
    try {
      return await LocalNostrSigner.instance
          .nip44Encrypt(serverPrivate, message, clientPubkey);
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
      final signEvent = Event.from(
        kind: 24133,
        tags: [
          ['p', clientPubkey]
        ],
        content: content,
        pubkey: instance.getPublicKey(clientPubkey) ?? '',
        privkey: instance.getPrivateKey(clientPubkey) ?? '',
      );

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

    final authEncrypted = await signAndEncrypt(
        serverPrivate, authResponse, connectInfo.clientPubkey);
    if (authEncrypted != null) {
      sendEvent(connectInfo.clientPubkey, subscriptionId, authEncrypted);
    }

    final secretResponse = jsonEncode({
      'id': 'nostr-connect-$timestamp',
      'result': connectInfo.secret,
    });

    final secretEncrypted = await signAndEncrypt(
        serverPrivate, secretResponse, connectInfo.clientPubkey);
    if (secretEncrypted != null) {
      sendEvent(connectInfo.clientPubkey, subscriptionId, secretEncrypted);
    }
  }

  static Future<void> handleScheme(String? url) async {
    await UrlSchemeHandler.handleScheme(url);
  }
}
