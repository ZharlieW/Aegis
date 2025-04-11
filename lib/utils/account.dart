import 'dart:async';
import 'package:aegis/db/userDB_isar.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/common_constant.dart';
import '../db/clientAuthDB_isar.dart';
import '../db/db_isar.dart';
import '../navigator/navigator.dart';
import '../nostr/keychain.dart';
import '../nostr/nips/nip19/nip19.dart';
import '../nostr/signer/local_nostr_signer.dart';
import '../nostr/utils.dart';
import '../pages/request/request_permission.dart';
import 'nostr_wallet_connection_parser.dart';

abstract mixin class AccountObservers {
  void didLoginSuccess();

  void didSwitchUser();

  void didLogout();

  void didAddBunkerSocketMap();

  void didAddClientRequestMap();
}

class Account {
  Account._internal();
  factory Account() => sharedInstance;
  static final Account sharedInstance = Account._internal();

  final List<AccountObservers> _observers = <AccountObservers>[];

  // key: createTimestamp + port
  final ValueNotifier<Map<String, BunkerSocket>> bunkerSocketMap =
      ValueNotifier({});

  final ValueNotifier<List<ClientAuthDBISAR>> clientAuthList =
      ValueNotifier([]);

  // key : pubkey.toLowerCase()
  final ValueNotifier<Map<String, Nip46NostrConnectInfo>>
      nip46NostrConnectInfoMap = ValueNotifier({});

  // key: pubkey.toLowerCase()
  // value : []
  final Map<String, List> clientReqMap = {};

  String _currentPubkey = '';
  String _currentPrivkey = '';

  void addObserver(AccountObservers observer) => _observers.add(observer);

  bool removeObserver(AccountObservers observer) => _observers.remove(observer);

  String get currentPubkey {
    return _currentPubkey;
  }

  String get currentPrivkey {
    return _currentPrivkey;
  }

  bool isValidPubKey(String pubKey) {
    final pattern = RegExp(r'^[a-fA-F0-9]{64}$');
    return pattern.hasMatch(pubKey);
  }

  static String getPrivateKey(String nsec) {
    return Nip19.decodePrivkey(nsec);
  }

  static Keychain generateNewKeychain() {
    return Keychain.generate();
  }

  static String getPublicKey(String privkey) {
    return Keychain.getPublicKey(privkey);
  }

  static String getNupPublicKey(String publicKey) {
    return Nip19.encodePubkey(publicKey);
  }

  static bool validateNsec(String nsecBase64) {
    try {
      if (nsecBase64.length != 63) {
        return false;
      }
      if (!nsecBase64.startsWith('nsec')) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _currentPubkey = '';
    _currentPrivkey = '';

    // 🔹 clean local cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pubkey');
    await prefs.remove('privkey');

    AegisWebSocketServer.instance.stop();
    bunkerSocketMap.value.clear();
    clientAuthList.value.clear();
    nip46NostrConnectInfoMap.value.clear();
    clientReqMap.clear();

    for (AccountObservers observer in _observers) {
      observer.didLogout();
    }
  }

  Future<void> loginSuccess(String pubkey, String? privkey) async {
    _currentPubkey = pubkey;

    await DBISAR.sharedInstance.open(pubkey);

    try {
      if (privkey == null) {
        final user = await _getUserFromDB(pubkey);
        if (user == null) return;

        final decryptedPrivkey = _decryptPrivkey(user);
        _currentPrivkey = bytesToHex(decryptedPrivkey);
      } else {

        _currentPrivkey = privkey;

        final defaultPassword = generateStrongPassword(16);
        final encrypted = encryptPrivateKey(hexToBytes(privkey), defaultPassword);

        final user = UserDBISAR(
          pubkey: pubkey,
          encryptedPrivkey: bytesToHex(encrypted),
          defaultPassword: defaultPassword,
        );

        await DBISAR.sharedInstance.saveToDB(user);
      }

      final list = await DBISAR.sharedInstance.isar.clientAuthDBISARs.where().findAll();
      clientAuthList.value.addAll(list);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pubkey', pubkey);

      LocalNostrSigner.instance.init();
      await ServerNIP46Signer.instance.start('8081');

      for (final observer in _observers) {
        observer.didLoginSuccess();
      }
    } catch (e, stack) {
      print('loginSuccess error: $e\n$stack');
    }
  }


  void addBunkerSocketMap(BunkerSocket bunkerSocket) {
    String key = '${bunkerSocket.createTimestamp}${bunkerSocket.port}';
    bunkerSocketMap.value[key] = bunkerSocket;
    for (AccountObservers observer in _observers) {
      observer.didAddBunkerSocketMap();
    }
  }

  void addNip46NostrConnectInfoMap(Nip46NostrConnectInfo info) {
    ValueListenable<Map<String, Nip46NostrConnectInfo>> valueMap =
        Account.sharedInstance.nip46NostrConnectInfoMap;
    Map<String, Nip46NostrConnectInfo> newValue = Map.from(valueMap.value);
    newValue[info.pubkey] = info;
    Account.sharedInstance.nip46NostrConnectInfoMap.value = newValue;
  }

  void removeBunkerSocketMap(BunkerSocket bunkerSocket) {
    String key = '${bunkerSocket.createTimestamp}${bunkerSocket.port}';
    bunkerSocketMap.value[key] = bunkerSocket;
    for (AccountObservers observer in _observers) {
      observer.didAddBunkerSocketMap();
    }
  }

  void addClientRequestList(ClientAuthDBISAR clientAuthDBISAR) {
    clientAuthList.value.add(clientAuthDBISAR);
    for (AccountObservers observer in _observers) {
      observer.didAddClientRequestMap();
    }
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? pubkey = prefs.getString('pubkey');

    if (pubkey != null) {
      await loginSuccess(pubkey, null);
      print(
          "🔹 The session is automatically resumed after the user logs in. Procedure");
    }
    else {
      print(
          "🔹 No login information is detected. The user needs to log in again");
    }
  }

  bool isValidNostrConnectSchemeUri(String uri) {
    if (uri.isEmpty || !(uri.contains(NIP46_NOSTR_CONNECT_PROTOCOL)))
      return false;
    return true;
  }

  static Future<bool> clientAuth({
    required String pubkey,
    required String clientPubkey,
    required EConnectionType connectionType,
    String? image,
    String? name,
    String? relay,
  }) async {
    bool isAuthorized = await ServerNIP46Signer.instance.isClientAuthorized(
      Account.sharedInstance.currentPubkey,
      clientPubkey,
    );

    if (!isAuthorized) {
      final status = await AegisNavigator.presentPage(
          AegisNavigator.navigatorKey.currentContext,
          (context) => RequestPermission(),
          fullscreenDialog: false);

      if (status == null || status == false) return false;
      await ServerNIP46Signer.instance.saveClientAuth(
        pubkey: Account.sharedInstance.currentPubkey,
        clientPubkey: clientPubkey,
        connectionType: connectionType,
        image: image,
        name: name,
        relay: relay,
      );
      return true;
    }

    return true;
  }

  Future<UserDBISAR?> _getUserFromDB(String pubkey) {
    return DBISAR.sharedInstance.isar.userDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .findFirst();
  }

  Uint8List _decryptPrivkey(UserDBISAR user) {
    final encryptedBytes = hexToBytes(user.encryptedPrivkey!);
    return decryptPrivateKey(encryptedBytes, user.defaultPassword!);
  }
}
