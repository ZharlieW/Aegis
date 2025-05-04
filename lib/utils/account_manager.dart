import 'local_storage.dart';

class AccountManager {
  static const String _accountPrefix = 'account_';

  static Future<Map<String, Map<String, dynamic>>> getAllAccounts() async {
    await LocalStorage.init();
    final keys = await LocalStorage.getKeys();
    final accounts = <String, Map<String, dynamic>>{};

    for (var key in keys) {
      if (key.startsWith(_accountPrefix)) {
        final data = LocalStorage.get(key);
        if (data != null && data is Map<String, dynamic>) {
          accounts[key.replaceFirst(_accountPrefix, '')] = data;
        }
      }
    }
    return accounts;
  }

  static Future<void> saveAccount(String pubkey, Map<String, dynamic> accountData) async {
    await LocalStorage.set('$_accountPrefix$pubkey', accountData);
  }

  static Future<void> deleteAccount(String pubkey) async {
    await LocalStorage.remove('$_accountPrefix$pubkey');
  }
}