import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/aegis_websocket_server.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:aegis/utils/logger.dart';

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
import 'package:aegis/utils/key_manager.dart';

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
      final decryptedPrivkey = await decryptPrivkey(user);
      _currentPrivkey = bytesToHex(decryptedPrivkey);

      final all = await AccountManager.getAllAccount();
      final local = all[pubkey];
      if (local?.username != null) {
        user.username = local!.username;
      }
    } else {
      _currentPrivkey = privkey;
      
      // Use Keychain for password management
      final password = await DBKeyManager.generateUserPrivkeyKey(pubkey);
      final encrypted = encryptPrivateKey(hexToBytes(privkey), password);
      
      user = UserDBISAR(
        pubkey: pubkey,
        encryptedPrivkey: bytesToHex(encrypted),
        defaultPassword: null, // No longer store password in database
      );
      await DBISAR.sharedInstance.saveToDB(user.pubkey,user);
    }

    final clientList = await ClientAuthDBISAR.getAllFromDB(user.pubkey);
    
    // Process bunker applications with proper indexing and database updates
    await _processBunkerApplicationsWithDBUpdate(clientList);
    
    // Add all applications to AccountManager
    for (final item in clientList) {
      AccountManager.sharedInstance.addApplicationMap(item);
    }

    user.privkey = _currentPrivkey;
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
      AegisLogger.info("🔹 The session is automatically resumed after the user logs in. Procedure");
    } else {
      AegisLogger.info("🔹 No login information is detected. The user needs to log in again");
    }
  }

  static Future<bool> authToClient() async {
    final status = await AegisNavigator.presentPage<bool>(
      AegisNavigator.navigatorKey.currentContext,
          (context) => const RequestPermission(),
      fullscreenDialog: false,
      screenDialogHeight: 0.75,
    );
    return status == true;
  }

  Future<Uint8List> decryptPrivkey(UserDBISAR user) async {
    final encryptedBytes = hexToBytes(user.encryptedPrivkey!);

    // Try to get password from Keychain first
    String? password;

    // For existing users, migrate from database to Keychain if needed
    if (user.defaultPassword != null && user.defaultPassword!.isNotEmpty) {
      // Store the old password before clearing it
      final oldPassword = user.defaultPassword;

      // Migrate old password to Keychain
      try {
        await DBKeyManager.migrateUserPrivkeyKey(user.pubkey, oldPassword);
        // Clear the password from database after successful migration
        user.defaultPassword = null;
        await DBISAR.sharedInstance.saveToDB(user.pubkey, user);
        print('[Migration] Cleared password from database for user: ${user.pubkey}');

        // Get the migrated password from Keychain
        password = await DBKeyManager.getUserPrivkeyKey(user.pubkey);
      } catch (error) {
        print('[Migration] Failed to migrate password for user: ${user.pubkey}, error: $error');
        // Fallback to database password (keep the old password in database)
        password = oldPassword;
      }
    } else {
      // Try to get from Keychain
      password = await DBKeyManager.getUserPrivkeyKey(user.pubkey);
    }

    if (password == null || password.isEmpty) {
      throw Exception('Failed to get encryption password for user: ${user.pubkey}');
    }

    return decryptPrivateKey(encryptedBytes, password);
  }

  void addAuthToNostrConnectInfo(ClientAuthDBISAR client) {
    authToNostrConnectInfo[client.clientPubkey] = client;
  }

  /// Process bunker applications with proper indexing and database updates
  Future<void> _processBunkerApplicationsWithDBUpdate(List<ClientAuthDBISAR> clientList) async {
    // Get all bunker applications
    final bunkerApplications = clientList
        .where((app) => app.connectionType == EConnectionType.bunker.toInt)
        .toList();
    
    // Sort by creation timestamp to maintain consistent ordering
    bunkerApplications.sort((a, b) => 
        (a.createTimestamp ?? 0).compareTo(b.createTimestamp ?? 0));
    
    // Process each bunker application
    for (int i = 0; i < bunkerApplications.length; i++) {
      final item = bunkerApplications[i];
      final index = i + 1;
      
      // Check if name needs to be updated
      if (_shouldUpdateApplicationName(item.name)) {
        final oldName = item.name;
        item.name = 'application #$index';
        
        // Update database
        try {
          await ClientAuthDBISAR.saveFromDB(item, isUpdate: true);
          AegisLogger.info('Updated bunker application name in DB: $oldName -> application #$index (${item.clientPubkey})');
        } catch (e) {
          AegisLogger.error('Failed to update application name in database: ${item.clientPubkey}', e);
        }
      }
    }
  }

  /// Check if application name should be updated
  bool _shouldUpdateApplicationName(String? name) {
    if (name == null || name.isEmpty) {
      return true;
    }
    
    // Update if name is a pubkey (64 hex characters)
    if (name.length == 64 && RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(name)) {
      return true;
    }
    
    // Update if name contains ':' (likely a pubkey with prefix)
    if (name.contains(':')) {
      return true;
    }
    
    // Update if name is too long (likely a pubkey or complex identifier)
    if (name.length > 20) {
      return true;
    }
    
    return false;
  }
}
