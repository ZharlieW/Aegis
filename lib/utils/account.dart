import 'dart:async';
import 'package:aegis/db/userDB_isar.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../common/common_constant.dart';
import '../db/clientAuthDB_isar.dart';
import '../db/db_isar.dart';
import '../navigator/navigator.dart';
import '../nostr/keychain.dart';
import '../nostr/nips/nip19/nip19.dart';
import '../nostr/signer/local_nostr_signer.dart';
import '../nostr/utils.dart';
import '../pages/login/login.dart';
import '../pages/request/request_permission.dart';
import 'local_storage.dart';

abstract mixin class AccountObservers {
  void didLoginSuccess();

  void didSwitchUser();

  void didLogout();

  void didAddApplicationMap();

  void didRemoveApplicationMap();

  void didUpdateApplicationMap();
}

class Account {
  Account._internal();
  factory Account() => sharedInstance;
  static final Account sharedInstance = Account._internal();

  final List<AccountObservers> _observers = <AccountObservers>[];

  // key: clientPubkey
  Map<String, ValueNotifier<ClientAuthDBISAR>> applicationMap = {};

  // key : pubkey.toLowerCase()
  final Map<String, ClientAuthDBISAR> authToNostrConnectInfo = {};

  // key: pubkey.toLowerCase()
  // value : []
  final Map<String, List> clientReqMap = {};

  final Map<String, UserDBISAR> accountMap = {};

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

  void clear(){
    _currentPubkey = '';
    _currentPrivkey = '';
    authToNostrConnectInfo.clear();
    clientReqMap.clear();
  }

  Future<void> logout() async {
    await AccountManager.deleteAccount(_currentPubkey);
    Account.sharedInstance.clear();

    final allAccount = await AccountManager.getAllAccount();
    if (allAccount.isNotEmpty) {
      final nextUser = allAccount.values.first;
      String pubkey = nextUser.pubkey;
      await LocalStorage.set('pubkey', pubkey);
      Account.sharedInstance.loginSuccess(pubkey, null);
    } else {
      AegisWebSocketServer.instance.stop();
      await LocalStorage.remove('pubkey');
      AegisNavigator.pushPage(AegisNavigator.navigatorKey.currentContext, (context) => const Login(
        isLaunchLogin: true,
      ));
    }

    for (AccountObservers observer in _observers) {
      observer.didLogout();
    }
  }

  Future<void> loginSuccess(String pubkey, String? privkey) async {
    clear();
    _currentPubkey = pubkey;

    await DBISAR.sharedInstance.open(pubkey);

    UserDBISAR? user;
    try {
      if (privkey == null) {
        user = await UserDBISAR.searchFromDB(pubkey);
        if (user == null) return;

        final decryptedPrivkey = decryptPrivkey(user);
        _currentPrivkey = bytesToHex(decryptedPrivkey);
      } else {
        _currentPrivkey = privkey;

        final defaultPassword = generateStrongPassword(16);
        final encrypted = encryptPrivateKey(hexToBytes(privkey), defaultPassword);

        user = UserDBISAR(
          pubkey: pubkey,
          // privkey: privkey,
          encryptedPrivkey: bytesToHex(encrypted),
          defaultPassword: defaultPassword,
        );

        await DBISAR.sharedInstance.saveToDB(user);
      }

      final clientList = await ClientAuthDBISAR.getAllFromDB();
      clientList.map(( item ) => addApplicationMap(item)).toList();

      await LocalStorage.set('pubkey', pubkey);

      await AccountManager.saveAccount(user);

      LocalNostrSigner.instance.init();
      accountMap[user.pubkey] = user;
      await ServerNIP46Signer.instance.start('8081');

      for (final observer in _observers) {

        observer.didLoginSuccess();
      }
    } catch (e, stack) {
      print('loginSuccess error: $e\n$stack');
    }
  }

  Future<void> autoLogin() async {
    String? pubkey = LocalStorage.get('pubkey');

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

  Uint8List decryptPrivkey(UserDBISAR user) {
    final encryptedBytes = hexToBytes(user.encryptedPrivkey!);
    return decryptPrivateKey(encryptedBytes, user.defaultPassword!);
  }

  void addApplicationMap(ClientAuthDBISAR client,{bool isUpdate = false}) {
    String clientPubkey = client.clientPubkey;
    ValueNotifier<ClientAuthDBISAR>? clientNotifier = applicationMap[clientPubkey];
    if (clientNotifier != null && !isUpdate) return;

    if(clientNotifier == null){
      applicationMap[clientPubkey] = ValueNotifier<ClientAuthDBISAR>(client);
    } else {
      clientNotifier.value = client;
    }

    for (final observer in _observers) {
      observer.didAddApplicationMap();
    }
  }

  void addAuthToNostrConnectInfo(ClientAuthDBISAR client){
    authToNostrConnectInfo[client.clientPubkey] = client;
  }

  void removeApplicationMap(String clientPubkey){
    applicationMap.remove(clientPubkey);
    for (final observer in _observers) {
      observer.didRemoveApplicationMap();
    }
  }

  void updateApplicationMap(String clientPubkey){
  }
}
