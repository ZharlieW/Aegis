import 'package:isar/isar.dart';

part 'userDB_isar.g.dart';

@collection
class UserDBISAR {
  Id id = Isar.autoIncrement;
  late String pubkey;
  late String privkey;

  late String encryptedPrivkey;

  UserDBISAR({
    required this.pubkey,
    required this.privkey,
    required this.encryptedPrivkey,
  });
}
