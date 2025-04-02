import 'dart:async';
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
  final ValueListenable<Map<String,BunkerSocket>> bunkerSocketMap = ValueNotifier({});

  final ValueListenable<List<ClientAuthDBISAR>> clientAuthList = ValueNotifier([]);

  // key : pubkey.toLowerCase()
  final ValueListenable<Map<String,Nip46NostrConnectInfo>> nip46NostrConnectInfoMap = ValueNotifier({});

  // key: pubkey.toLowerCase()
  // value : []
  final Map<String,List> clientReqMap = {};

  String nostrWalletConnectSchemeUri = '';

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

  static String getPrivateKey(String nsec){
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

    for (AccountObservers observer in _observers) {
      observer.didLogout();
    }
  }

  Future<void> loginSuccess(String pubkey,String privkey) async {
    _currentPubkey = pubkey;
    _currentPrivkey = privkey;

    await DBISAR.sharedInstance.open(pubkey);
    List<ClientAuthDBISAR> list = await DBISAR.sharedInstance.isar.clientAuthDBISARs.where().findAll();
    clientAuthList.value.addAll(list);

    // 🔹 save pubkey 和 privkey
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pubkey', pubkey);
    await prefs.setString('privkey', privkey);
    LocalNostrSigner.instance.init();
    await ServerNIP46Signer.instance.start('8081');
    for (AccountObservers observer in _observers) {
      observer.didLoginSuccess();
    }
  }

  void addBunkerSocketMap(BunkerSocket bunkerSocket){
    String key = '${bunkerSocket.createTimestamp}${bunkerSocket.port}';
    bunkerSocketMap.value[key] = bunkerSocket;
    for (AccountObservers observer in _observers) {
      observer.didAddBunkerSocketMap();
    }
  }

  void removeBunkerSocketMap(BunkerSocket bunkerSocket){
    String key = '${bunkerSocket.createTimestamp}${bunkerSocket.port}';
    bunkerSocketMap.value[key] = bunkerSocket;
    for (AccountObservers observer in _observers) {
      observer.didAddBunkerSocketMap();
    }
  }

  void addClientRequestList(ClientAuthDBISAR clientAuthDBISAR){
    clientAuthList.value.add(clientAuthDBISAR);
    for (AccountObservers observer in _observers) {
      observer.didAddClientRequestMap();
    }
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? pubkey = prefs.getString('pubkey');
    String? privkey = prefs.getString('privkey');

    if (pubkey != null && privkey != null) {
      print("🔹 The session is automatically resumed after the user logs in. Procedure");
      await loginSuccess(pubkey, privkey);
    } else {
      print("🔹 No login information is detected. The user needs to log in again");
    }
  }

  bool isValidNostrConnectSchemeUri (String uri) {
    if(uri.isEmpty || !(uri.contains(NIP46_NOSTR_CONNECT_PROTOCOL))) return false;
    return true;
  }

  static Future<void> clientAuth(String pubkey) async {
    bool isAuthorized = await ServerNIP46Signer.instance.isClientAuthorized(
      Account.sharedInstance.currentPubkey,
      pubkey,
    );

    if (!isAuthorized) {
      final status = await AegisNavigator.presentPage(
          AegisNavigator.navigatorKey.currentContext,
              (context) => RequestPermission(),
          fullscreenDialog: false);

      if (status == null || status == false) return;

      await ServerNIP46Signer.instance.saveClientAuth(
        Account.sharedInstance.currentPubkey,
        pubkey,
      );
      return;
    }
  }
}
