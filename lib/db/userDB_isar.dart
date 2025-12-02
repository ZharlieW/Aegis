import 'package:isar/isar.dart';

import '../nostr/utils.dart';
import '../utils/account.dart';
import '../utils/account_manager.dart';
import 'db_isar.dart';

part 'userDB_isar.g.dart';

@collection
class UserDBISAR {
  Id id = Isar.autoIncrement;
  late String pubkey;
  late String? privkey;

  late String? encryptedPrivkey;
  late String? defaultPassword;

  UserDBISAR({
    required this.pubkey,
    this.privkey,
    this.encryptedPrivkey,
    this.defaultPassword,
    this.username,
  });

  @ignore
  String? username;

  // For backward compatibility,
  String get getPrivkey {
    if(privkey != null && privkey!.isNotEmpty) {
      if(AccountManager.sharedInstance.accountMap[pubkey] != null) {
        AccountManager.sharedInstance.accountMap[pubkey]!.privkey = privkey;
      }
      return privkey!;
    }
    // For backward compatibility, return cached private key if available
    // This maintains the synchronous interface for Isar
    return AccountManager.sharedInstance.accountMap[pubkey]?.privkey ?? '';
  }

  /// Async method to get private key with decryption
  Future<String> getPrivkeyAsync() async {
    if(privkey != null && privkey!.isNotEmpty) {
      if(AccountManager.sharedInstance.accountMap[pubkey] != null) {
        AccountManager.sharedInstance.accountMap[pubkey]!.privkey = privkey;
      }
      return privkey!;
    }
    final decryptedPrivkey = await Account.sharedInstance.decryptPrivkey(this);
    return bytesToHex(decryptedPrivkey);
  }

  static Future<UserDBISAR?> searchFromDB(String pubkey) async {
    final isar = await DBISAR.sharedInstance.open(pubkey);

    return await isar.userDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .findFirst();
  }

  /// Delete user from database
  static Future<void> deleteFromDB(String pubkey) async {
    final isar = await DBISAR.sharedInstance.open(pubkey);
    final user = await searchFromDB(pubkey);
    
    if (user != null) {
      await isar.writeTxn(() async {
        await isar.userDBISARs.delete(user.id);
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'pubkey': pubkey,
    'privkey': privkey,
    'encryptedPrivkey':encryptedPrivkey,
    'defaultPassword':defaultPassword,
    if (username != null) 'username': username,
  };

  static UserDBISAR fromJson(Map<String, dynamic> json) => UserDBISAR(
    pubkey: json['pubkey'],
    privkey: json['privkey'],
    encryptedPrivkey: json['encryptedPrivkey'],
    defaultPassword: json['defaultPassword'],
    username: json['username'],
  );
}
