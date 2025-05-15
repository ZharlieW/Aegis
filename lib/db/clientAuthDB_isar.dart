import 'package:isar/isar.dart';

import 'db_isar.dart';

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

  static EConnectionType fromToEnum(int num) {
    switch (num) {
      case 0:
        return EConnectionType.bunker;
      case 1:
        return EConnectionType.nostrconnect;
      default:
        return EConnectionType.bunker;
    }
  }

  String get toStr {
    switch (this) {
      case EConnectionType.bunker:
        return 'bunker://';
      case EConnectionType.nostrconnect:
        return 'nostrconnect://';
    }
  }
}

@collection
class ClientAuthDBISAR {
  Id id = Isar.autoIncrement;
  // remote signer pubkey
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

  //  0 : bunker://
  //  1 : nostrconnect://
  late int connectionType;

  @ignore
  int? socketHashCode;

  ClientAuthDBISAR({
    this.image,
    this.name,
    this.relay,
    this.secret,
    this.scheme,
    this.server,
    this.socketHashCode,
    this.createTimestamp,
    required this.pubkey,
    required this.clientPubkey,
    required this.connectionType,
  });

  static Future<ClientAuthDBISAR?> searchFromDB(String pubkey, String clientPubkey) async {
    final application = await DBISAR.sharedInstance.isar.clientAuthDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .clientPubkeyEqualTo(clientPubkey)
        .findFirst();
    return application;
  }

  static Future<List<ClientAuthDBISAR>> getAllFromDB() async {
    final list =
        await DBISAR.sharedInstance.isar.clientAuthDBISARs.where().findAll();
    return list;
  }

  static Future<void> saveFromDB(ClientAuthDBISAR client,
      {bool isUpdate = false}) async {
    final existingClient =
        await searchFromDB(client.pubkey, client.clientPubkey);

    if (existingClient == null || isUpdate) {
      await DBISAR.sharedInstance.isar.writeTxn(() async {
        await DBISAR.sharedInstance.isar.clientAuthDBISARs.put(client);
      });
    }
  }

  static Future<void> deleteFromDB(String pubkey, String clientPubkey) async {
    final isar = DBISAR.sharedInstance.isar;
    final target = await isar.clientAuthDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .clientPubkeyEqualTo(clientPubkey)
        .findFirst();

    if (target != null) {
      await isar.writeTxn(() async {
        await isar.clientAuthDBISARs.delete(target.id);
      });
    }
  }
}
