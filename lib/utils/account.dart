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

abstract mixin class AccountObservers {
  void didLoginSuccess();

  void didSwitchUser();

  void didLogout();
}

class Account {
  Account._internal();
  factory Account() => sharedInstance;
  static final Account sharedInstance = Account._internal();

  final List<AccountObservers> _observers = <AccountObservers>[];

  // key: clientPubkey
  final ValueNotifier<Map<String, ClientAuthDBISAR>> applicationValueNotifier = ValueNotifier({});

  // key : pubkey.toLowerCase()
  final Map<String, ClientAuthDBISAR> authToNostrConnectInfo = {};

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

  Future<void> logout() async {
    _currentPubkey = '';
    _currentPrivkey = '';

    // 🔹 clean local cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pubkey');
    await prefs.remove('privkey');

    AegisWebSocketServer.instance.stop();
    authToNostrConnectInfo.clear();
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
        final user = await UserDBISAR.searchFromDB(pubkey);
        if (user == null) return;

        final decryptedPrivkey = _decryptPrivkey(user);
        _currentPrivkey = bytesToHex(decryptedPrivkey);
      } else {
        _currentPrivkey = privkey;

        final defaultPassword = generateStrongPassword(16);
        final encrypted =
            encryptPrivateKey(hexToBytes(privkey), defaultPassword);

        final user = UserDBISAR(
          pubkey: pubkey,
          encryptedPrivkey: bytesToHex(encrypted),
          defaultPassword: defaultPassword,
        );

        await DBISAR.sharedInstance.saveToDB(user);
      }


      final clientList = await ClientAuthDBISAR.getAllFromDB();

      Map<String, ClientAuthDBISAR> applicationMap = {
        for (var client in clientList) client.clientPubkey: client,
      };
      applicationValueNotifier.value = applicationMap;


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

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? pubkey = prefs.getString('pubkey');

    if (pubkey != null) {
      await loginSuccess(pubkey, null);
      print(
          "🔹 The session is automatically resumed after the user logs in. Procedure");
    } else {
      print(
          "🔹 No login information is detected. The user needs to log in again");
    }
  }

  bool isValidNostrConnectSchemeUri(String uri) {
    if (uri.isEmpty || !(uri.contains(NIP46_NOSTR_CONNECT_PROTOCOL))){
      return false;
    }
    return true;
  }

  static Future<bool> authToClient() async {
    final status = await AegisNavigator.presentPage(
      AegisNavigator.navigatorKey.currentContext,
      (context) => RequestPermission(),
      fullscreenDialog: false,
    );

    if (status == null || status == false) return false;
    return true;
  }

  Uint8List _decryptPrivkey(UserDBISAR user) {
    final encryptedBytes = hexToBytes(user.encryptedPrivkey!);
    return decryptPrivateKey(encryptedBytes, user.defaultPassword!);
  }

  void addApplicationValueNotifier(ClientAuthDBISAR client,{bool isUpdate = false}) {
    Map<String, ClientAuthDBISAR> applicationNotifier = applicationValueNotifier.value;
    String clientPubkey = client.clientPubkey;
    if (applicationNotifier[clientPubkey] != null && !isUpdate) return;

    Map<String, ClientAuthDBISAR> newApplicationNotifier = Map.from(applicationNotifier);
    newApplicationNotifier[clientPubkey] = client;
    Account.sharedInstance.applicationValueNotifier.value = newApplicationNotifier;
  }
}
