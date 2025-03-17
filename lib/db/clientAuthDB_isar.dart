import 'package:isar/isar.dart';

part 'clientAuthDB_isar.g.dart';

@collection
class ClientAuthDBISAR {
  Id id = Isar.autoIncrement;
  late String pubkey;
  late String clientPubkey;
  late bool isAuthorized;

  ClientAuthDBISAR({
    required this.pubkey,
    required this.clientPubkey,
    required this.isAuthorized,
  });
}
