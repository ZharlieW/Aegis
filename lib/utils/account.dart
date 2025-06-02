import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/server_nip46_signer.dart';

import '../common/common_constant.dart';
import '../db/clientAuthDB_isar.dart';
import '../db/db_isar.dart';
import '../db/userDB_isar.dart';
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
}

class Account {
  Account._internal();
  factory Account() => sharedInstance;
  static final Account sharedInstance = Account._internal();

  final List<AccountObservers> _observers = <AccountObservers>[];
  final Map<String, ClientAuthDBISAR> authToNostrConnectInfo = {};
  final Map<String, List> clientReqMap = {};

  String _currentPubkey = '';
  String _currentPrivkey = '';

  String get currentPubkey => _currentPubkey;
  String get currentPrivkey => _currentPrivkey;

  bool isValidPubKey(String pubKey) =>
      RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(pubKey);

  static String getPrivateKey(String nsec) => Nip19.decodePrivkey(nsec);
  static Keychain generateNewKeychain() => Keychain.generate();
  static String getPublicKey(String privkey) => Keychain.getPublicKey(privkey);
  static String getNupPublicKey(String publicKey) => Nip19.encodePubkey(publicKey);

  void addObserver(AccountObservers observer) => _observers.add(observer);
  bool removeObserver(AccountObservers observer) => _observers.remove(observer);

  bool isValidNostrConnectSchemeUri(String uri) => uri.isNotEmpty && uri.contains(NIP46_NOSTR_CONNECT_PROTOCOL);

  void _notify(void Function(AccountObservers) fn) {
    for (final observer in _observers) {
      fn(observer);
    }
  }

  void clear() {
    _currentPubkey = '';
    _currentPrivkey = '';
    authToNostrConnectInfo.clear();
    clientReqMap.clear();
  }

  Future<void> logout() async {

    final clientList = await ClientAuthDBISAR.getAllFromDB(_currentPubkey);
    for(final client in clientList){
      AccountManager.sharedInstance.removeApplicationMap(client.clientPubkey);

      if(client.socketHashCode != null){
        AegisWebSocketServer.instance.closeClientByHashCode(client.socketHashCode!);
      }
    }


    await AccountManager.deleteAccount(_currentPubkey);
    clear();

    final allAccount = await AccountManager.getAllAccount();
    if (allAccount.isNotEmpty) {
      final nextUser = allAccount.values.first;
      await LocalStorage.set('pubkey', nextUser.pubkey);
      await loginSuccess(nextUser.pubkey, null);
    } else {
      AegisWebSocketServer.instance.stop();
      await LocalStorage.remove('pubkey');
      AegisNavigator.pushPage(
        AegisNavigator.navigatorKey.currentContext,
            (context) => const Login(isLaunchLogin: true),
      );
    }

    _notify((o) => o.didLogout());
  }

  Future<void> loginSuccess(String pubkey, String? privkey,{ bool isInit = false}) async {
    clear();
    _currentPubkey = pubkey;

    await DBISAR.sharedInstance.open(pubkey);

    UserDBISAR? user;
    if (privkey == null) {
      user = await UserDBISAR.searchFromDB(pubkey);
      if (user == null) return;
      _currentPrivkey = bytesToHex(decryptPrivkey(user));

      final all = await AccountManager.getAllAccount();
      final local = all[pubkey];
      if (local?.username != null) {
        user.username = local!.username;
      }
    } else {
      _currentPrivkey = privkey;
      final defaultPassword = generateStrongPassword(16);
      final encrypted = encryptPrivateKey(hexToBytes(privkey), defaultPassword);
      user = UserDBISAR(
        pubkey: pubkey,
        encryptedPrivkey: bytesToHex(encrypted),
        defaultPassword: defaultPassword,
      );
      await DBISAR.sharedInstance.saveToDB(user.pubkey,user);
    }

    final clientList = await ClientAuthDBISAR.getAllFromDB(user.pubkey);
    for (final item in clientList) {
      AccountManager.sharedInstance.addApplicationMap(item);
    }

    await LocalStorage.set('pubkey', pubkey);
    await AccountManager.sharedInstance.saveAccount(user);
    AccountManager.sharedInstance.accountMap[user.pubkey] = user;

    LocalNostrSigner.instance.init();
    await ServerNIP46Signer.instance.start('8081');

    if(isInit){
      await AccountManager.sharedInstance.initAccountList();
    }
    _notify((o) => o.didLoginSuccess());
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

  static Future<bool> authToClient() async {
    final status = await AegisNavigator.presentPage<bool>(
      AegisNavigator.navigatorKey.currentContext,
          (context) => const RequestPermission(),
      fullscreenDialog: false,
    );
    return status == true;
  }

  Uint8List decryptPrivkey(UserDBISAR user) {
    final encryptedBytes = hexToBytes(user.encryptedPrivkey!);
    return decryptPrivateKey(encryptedBytes, user.defaultPassword!);
  }

  void addAuthToNostrConnectInfo(ClientAuthDBISAR client) {
    authToNostrConnectInfo[client.clientPubkey] = client;
  }
}
