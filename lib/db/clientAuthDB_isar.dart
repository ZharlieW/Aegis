import 'package:isar/isar.dart';

part 'clientAuthDB_isar.g.dart';

enum EConnectionType { bunker, nostrconnect }

extension ConnectionTypeEx on EConnectionType {
  int get toInt {
    switch (this) {
      case EConnectionType.bunker:
        return 0;
      case EConnectionType.nostrconnect:
        return 1;
    }
  }
}

@collection
class ClientAuthDBISAR {
  Id id = Isar.autoIncrement;
  late String pubkey;
  late String clientPubkey;

  // client image
  late String? image;
  // client name
  late String? name;
  // client relay
  late String? relay;
  // client server
  late String? server;
  // client secret
  late String? secret;
  // client scheme
  late String? scheme;
  late int? createTimestamp;
  late bool isAuthorized;

  //  0 : bunker://
  //  1 : nostrconnect://
  late int connectionType;

  ClientAuthDBISAR({
    this.image,
    this.name,
    this.relay,
    this.secret,
    this.scheme,
    this.server,
    this.createTimestamp,
    required this.pubkey,
    required this.clientPubkey,
    required this.isAuthorized,
    required this.connectionType,
  });
}
