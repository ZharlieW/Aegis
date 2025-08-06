import 'package:isar/isar.dart';

import 'db_isar.dart';

part 'signed_event_db_isar.g.dart';

@collection
class SignedEventDBISAR {
  Id id = Isar.autoIncrement;
  
  // Event identifier
  late String eventId;
  
  // Event kind
  late int eventKind;
  
  // Event content (description of what was signed)
  late String eventContent;
  
  // Application name that requested the signature
  late String? applicationName;
  
  // Application pubkey
  late String? applicationPubkey;
  
  // User's pubkey who signed the event
  late String userPubkey;
  
  // Timestamp when the event was signed
  late int signedTimestamp;
  
  // Event status (0: pending, 1: signed, 2: failed)
  late int status;
  
  // Additional metadata (JSON string)
  late String? metadata;

  SignedEventDBISAR({
    required this.eventId,
    required this.eventKind,
    required this.eventContent,
    this.applicationName,
    this.applicationPubkey,
    required this.userPubkey,
    required this.signedTimestamp,
    required this.status,
    this.metadata,
  });

  static Future<SignedEventDBISAR?> searchFromDB(String userPubkey, String eventId) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    final event = await isar.signedEventDBISARs
        .filter()
        .userPubkeyEqualTo(userPubkey)
        .eventIdEqualTo(eventId)
        .findFirst();
    return event;
  }

  static Future<List<SignedEventDBISAR>> getAllFromDB(String userPubkey) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    
    // If user is not logged in, get all events
    if (userPubkey.startsWith('default_user_')) {
      final list = await isar.signedEventDBISARs
          .where()
          .sortBySignedTimestampDesc()
          .findAll();
      return list;
    } else {
      final list = await isar.signedEventDBISARs
          .filter()
          .userPubkeyEqualTo(userPubkey)
          .sortBySignedTimestampDesc()
          .findAll();
      return list;
    }
  }

  static Future<List<SignedEventDBISAR>> getRecentFromDB(String userPubkey, {int limit = 50}) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    
    // If user is not logged in, get all events
    if (userPubkey.startsWith('default_user_')) {
      final list = await isar.signedEventDBISARs
          .where()
          .sortBySignedTimestampDesc()
          .limit(limit)
          .findAll();
      return list;
    } else {
      final list = await isar.signedEventDBISARs
          .filter()
          .userPubkeyEqualTo(userPubkey)
          .sortBySignedTimestampDesc()
          .limit(limit)
          .findAll();
      return list;
    }
  }

  static Future<void> saveFromDB(SignedEventDBISAR event, {bool isUpdate = false}) async {
    final existingEvent = await searchFromDB(event.userPubkey, event.eventId);

    if (existingEvent == null || isUpdate) {
      final isar = await DBISAR.sharedInstance.open(event.userPubkey);

      await isar.writeTxn(() async {
        await isar.signedEventDBISARs.put(event);
      });
    }
  }

  static Future<void> deleteFromDB(String userPubkey, String eventId) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);

    final target = await isar.signedEventDBISARs
        .filter()
        .userPubkeyEqualTo(userPubkey)
        .eventIdEqualTo(eventId)
        .findFirst();

    if (target != null) {
      await isar.writeTxn(() async {
        await isar.signedEventDBISARs.delete(target.id);
      });
    }
  }

  static Future<void> clearAllFromDB(String userPubkey) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);

    await isar.writeTxn(() async {
      await isar.signedEventDBISARs.clear();
    });
  }
} 