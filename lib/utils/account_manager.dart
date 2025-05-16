import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:flutter/cupertino.dart';

import '../db/db_isar.dart';
import '../db/userDB_isar.dart';
import '../nostr/utils.dart';
import 'account.dart';
import 'local_storage.dart';

abstract mixin class AccountManagerObservers {
  void didAddApplicationMap();
  void didRemoveApplicationMap();
  void didUpdateApplicationMap();
}

class AccountManager {
  AccountManager._internal();
  factory AccountManager() => sharedInstance;
  static final AccountManager sharedInstance = AccountManager._internal();

  static const String _accountPrefix = 'aegis_account_map';

  final Map<String, ValueNotifier<ClientAuthDBISAR>> applicationMap = {};
  final Map<String, UserDBISAR> accountMap = {};
  final List<AccountManagerObservers> _observers = <AccountManagerObservers>[];

  void addObserver(AccountManagerObservers observer) => _observers.add(observer);
  bool removeObserver(AccountManagerObservers observer) => _observers.remove(observer);

  void _notify(void Function(AccountManagerObservers) fn) {
    for (final o in _observers) {
      fn(o);
    }
  }

  void addApplicationMap(ClientAuthDBISAR client) {
    applicationMap[client.clientPubkey] = ValueNotifier<ClientAuthDBISAR>(client);
    _notify((o) => o.didAddApplicationMap());
  }

  void removeApplicationMap(String clientPubkey) {
    if (applicationMap.remove(clientPubkey) != null) {
      _notify((o) => o.didRemoveApplicationMap());
    }
  }

  void updateApplicationMap(ClientAuthDBISAR client) {
    final key = client.clientPubkey;
    final notifier = applicationMap[key];
    if(notifier == null) return;
    notifier.value = client;
    _notify((o) => o.didUpdateApplicationMap());
  }


  static Future<Map<String, UserDBISAR>> getAllAccount() async {
    final raw = await LocalStorage.get(_accountPrefix) as Map<String, dynamic>? ?? {};
    return raw.map((k, v) => MapEntry(k, UserDBISAR.fromJson(v)));
  }

  Future<void> saveAccount(UserDBISAR user) async {
    final raw = await LocalStorage.get(_accountPrefix) as Map<String, dynamic>? ?? {};
    raw[user.pubkey] = user.toJson();
    await LocalStorage.set(_accountPrefix, raw);
    accountMap[user.pubkey] = user;
  }

  static Future<void> deleteAccount(String pubkey) async {
    final all = await getAllAccount();
    all.remove(pubkey);
    await LocalStorage.set(_accountPrefix, all.map((k, v) => MapEntry(k, v.toJson())));
  }

  Future<void> initAccountList() async {
    final storedAccounts = await getAllAccount();
    final autoPubkey = LocalStorage.get('pubkey');
    for (final entry in storedAccounts.entries) {
      final pubkey = entry.key;
      if (pubkey == autoPubkey) continue;

      await DBISAR.sharedInstance.open(pubkey);
      final user = await UserDBISAR.searchFromDB(pubkey);
      if (user != null) {
        user.privkey = bytesToHex(Account.sharedInstance.decryptPrivkey(user));
        accountMap[pubkey] = user;
      }

      final clients = await ClientAuthDBISAR.getAllFromDB(pubkey);
      for (final client in clients) {
        addApplicationMap(client);
      }

      await DBISAR.sharedInstance.closeDatabaseFor(pubkey);
    }
  }
}
