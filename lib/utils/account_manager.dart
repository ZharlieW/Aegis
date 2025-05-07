import '../db/userDB_isar.dart';
import 'local_storage.dart';

class AccountManager {
  static const String _accountPrefix = 'aegis_account_map';

  static Future<Map<String, UserDBISAR>> getAllAccount() async {
    final rawMap = await LocalStorage.get(_accountPrefix) ?? {};
    return Map<String, UserDBISAR>.fromEntries(
      (rawMap as Map<String, dynamic>).entries.map(
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
  }

  static Future<void> deleteAccount(String pubkey) async {
    final allAccount = await getAllAccount();
    allAccount.remove(pubkey);
    await LocalStorage.set(
      _accountPrefix,
      allAccount.map((k, v) => MapEntry(k, v.toJson())),
    );
  }
}
