import 'package:isar/isar.dart';

import 'db_isar.dart';

part 'clientAuthDB_isar.g.dart';

enum EConnectionType { bunker, nostrconnect, nip55 }

extension ConnectionTypeEx on EConnectionType {
  int get toInt {
    switch (this) {
      case EConnectionType.bunker:
        return 0;
      case EConnectionType.nostrconnect:
        return 1;
      case EConnectionType.nip55:
        return 2;
    }
  }

  static EConnectionType fromToEnum(int num) {
    switch (num) {
      case 0:
        return EConnectionType.bunker;
      case 1:
        return EConnectionType.nostrconnect;
      case 2:
        return EConnectionType.nip55;
      default:
        return EConnectionType.bunker;
    }
  }

  String get toStr {
    switch (this) {
      case EConnectionType.bunker:
        return 'bunker';
      case EConnectionType.nostrconnect:
        return 'nostrconnect';
      case EConnectionType.nip55:
        return 'nip55';
    }
  }
}

@collection
class ClientAuthDBISAR {
  Id id = Isar.autoIncrement;
  // remote signer pubkey
  late String pubkey; // user pubkey
  late String? remoteSignerPubkey; // remote signer pubkey (nullable for backward compatibility)
  late String? remoteSignerPrivateKey; // remote signer private key (nullable for backward compatibility)
  late String clientPubkey; // client pubkey

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
  late int? updateTimestamp;

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
    this.updateTimestamp,
    required this.pubkey,
    required this.clientPubkey,
    required this.connectionType,
    this.remoteSignerPubkey,
    this.remoteSignerPrivateKey,
  });

  static Future<ClientAuthDBISAR?> searchFromDB(String pubkey, String clientPubkey) async {
    final isar = await DBISAR.sharedInstance.open(pubkey);
    final application = await isar.clientAuthDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .clientPubkeyEqualTo(clientPubkey)
        .findFirst();
    return application;
  }

  static Future<List<ClientAuthDBISAR>> getAllFromDB(String pubkey) async {
    final isar = await DBISAR.sharedInstance.open(pubkey);
    final list = await isar.clientAuthDBISARs.where().findAll();
    return list;
  }

  static Future<void> saveFromDB(ClientAuthDBISAR client, {bool isUpdate = false}) async {
    final existingClient = await searchFromDB(client.pubkey, client.clientPubkey);

    if (existingClient == null || isUpdate) {
      final isar = await DBISAR.sharedInstance.open(client.pubkey);

      await isar.writeTxn(() async {
        // If creating new client, set both createTimestamp and updateTimestamp
        if (existingClient == null) {
          final now = DateTime.now().millisecondsSinceEpoch;
          client.createTimestamp ??= now;
          client.updateTimestamp ??= now;
        } else {
          // If updating, preserve createTimestamp and update updateTimestamp
          client.createTimestamp ??= existingClient.createTimestamp;
          client.updateTimestamp = DateTime.now().millisecondsSinceEpoch;
        }
        await isar.clientAuthDBISARs.put(client);
      });
    }
  }

  /// Update the updateTimestamp for an application when there's activity
  static Future<void> updateActivityTimestamp(String pubkey, String clientPubkey) async {
    final existingClient = await searchFromDB(pubkey, clientPubkey);
    if (existingClient != null) {
      existingClient.updateTimestamp = DateTime.now().millisecondsSinceEpoch;
      await saveFromDB(existingClient, isUpdate: true);
    }
  }

  static Future<void> deleteFromDB(String pubkey, String clientPubkey) async {
    final isar = await DBISAR.sharedInstance.open(pubkey);

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

  /// Delete application by ID (useful when clientPubkey is empty)
  static Future<void> deleteFromDBById(String pubkey, Id id) async {
    final isar = await DBISAR.sharedInstance.open(pubkey);
    
    final target = await isar.clientAuthDBISARs.get(id);
    if (target != null) {
      await isar.writeTxn(() async {
        await isar.clientAuthDBISARs.delete(id);
      });
    }
  }

  /// Delete application by remote signer pubkey (useful when clientPubkey is empty)
  static Future<void> deleteFromDBByRemoteSignerPubkey(String pubkey, String remoteSignerPubkey) async {
    final isar = await DBISAR.sharedInstance.open(pubkey);
    
    final target = await isar.clientAuthDBISARs
        .filter()
        .pubkeyEqualTo(pubkey)
        .remoteSignerPubkeyEqualTo(remoteSignerPubkey)
        .findFirst();
    
    if (target != null) {
      await isar.writeTxn(() async {
        await isar.clientAuthDBISARs.delete(target.id);
      });
    }
  }

  /// Delete all applications for a user
  static Future<void> deleteAllFromDB(String pubkey) async {
    final isar = await DBISAR.sharedInstance.open(pubkey);
    final allClients = await isar.clientAuthDBISARs.where().findAll();
    
    if (allClients.isNotEmpty) {
      await isar.writeTxn(() async {
        for (final client in allClients) {
          await isar.clientAuthDBISARs.delete(client.id);
        }
      });
    }
  }
}
