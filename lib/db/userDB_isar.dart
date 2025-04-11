import 'package:isar/isar.dart';

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
}
