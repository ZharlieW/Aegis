import 'package:isar/isar.dart';

import '../nostr/utils.dart';
import '../utils/account.dart';
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
  });

  String get getPrivkey {
    final decryptedPrivkey = Account.sharedInstance.decryptPrivkey(this);
    return bytesToHex(decryptedPrivkey);
  }

  static Future<UserDBISAR?> searchFromDB(String pubkey) {
    return DBISAR.sharedInstance.isar.userDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .findFirst();
  }

  Map<String, dynamic> toJson() => {
    'pubkey': pubkey,
    'privkey': privkey,
    'encryptedPrivkey':encryptedPrivkey,
    'defaultPassword':defaultPassword
  };

  static UserDBISAR fromJson(Map<String, dynamic> json) => UserDBISAR(
    pubkey: json['pubkey'],
    privkey: json['privkey'],
    encryptedPrivkey: json['encryptedPrivkey'],
    defaultPassword: json['defaultPassword'],
  );
}
