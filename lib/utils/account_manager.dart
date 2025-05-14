import 'package:aegis/db/clientAuthDB_isar.dart';

import '../db/db_isar.dart';
import '../db/userDB_isar.dart';
import '../nostr/utils.dart';
import 'account.dart';
import 'local_storage.dart';

class AccountManager {
  static const String _accountPrefix = 'aegis_account_map';


  static Future<Map<String, UserDBISAR>> getAllAccount() async {
    final rawMap = await LocalStorage.get(_accountPrefix) ?? {};

    final castedMap = Map<String, dynamic>.from(rawMap);

    return Map<String, UserDBISAR>.fromEntries(
      castedMap.entries.map(
            (e) => MapEntry(
          e.key,
          UserDBISAR.fromJson(e.value),
        ),
      ),
    );
  }

  static Future<void> saveAccount(UserDBISAR user) async {
    Map<String, dynamic> rawMap = await LocalStorage.get(_accountPrefix) ?? {};
    rawMap[user.pubkey] = user.toJson();
    await LocalStorage.set(_accountPrefix, rawMap);

    Account.sharedInstance.accountMap[user.pubkey] = user;
  }

  static Future<void> deleteAccount(String pubkey) async {
    final allAccount = await getAllAccount();
    allAccount.remove(pubkey);
    await LocalStorage.set(
      _accountPrefix,
      allAccount.map((k, v) => MapEntry(k, v.toJson())),
    );
  }

  static Future<void> initAccountList() async {
    Map<String, UserDBISAR> storedAccounts = await AccountManager.getAllAccount();
    String? getCurrentPubkey = await LocalStorage.get('pubkey');
    String? autoPubkey = LocalStorage.get('pubkey');
    for (final entry in storedAccounts.entries) {
      final pubkey = entry.key;
      if(pubkey == autoPubkey) continue;

      final isar = await DBISAR.sharedInstance.open(pubkey);

      final storedUser = await UserDBISAR.searchFromDB(pubkey);
      if (storedUser != null) {
        final decryptedPrivkey = Account.sharedInstance.decryptPrivkey(storedUser);
        storedUser.privkey = bytesToHex(decryptedPrivkey);
        Account.sharedInstance.accountMap[pubkey] = storedUser;
      }

      final storedClient = await ClientAuthDBISAR.getAllFromDB();
      storedClient.map((item) => Account.sharedInstance.addApplicationMap(item)).toList();

    }
  }
}
