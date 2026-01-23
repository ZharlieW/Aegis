import 'dart:convert';
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
    
    if (_isDefaultUser(userPubkey)) {
      return await isar.signedEventDBISARs
          .where()
          .sortBySignedTimestampDesc()
          .findAll();
    } else {
      return await isar.signedEventDBISARs
          .filter()
          .userPubkeyEqualTo(userPubkey)
          .sortBySignedTimestampDesc()
          .findAll();
    }
  }

  /// Get events by application pubkey
  static Future<List<SignedEventDBISAR>> getByApplicationPubkey(String userPubkey, String applicationPubkey) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    
    if (_isDefaultUser(userPubkey)) {
      return await isar.signedEventDBISARs
          .filter()
          .applicationPubkeyEqualTo(applicationPubkey)
          .sortBySignedTimestampDesc()
          .findAll();
    } else {
      return await isar.signedEventDBISARs
          .filter()
          .userPubkeyEqualTo(userPubkey)
          .applicationPubkeyEqualTo(applicationPubkey)
          .sortBySignedTimestampDesc()
          .findAll();
    }
  }

  /// Get count of events for specific application pubkey
  static Future<int> getEventCountByApplicationPubkey(String userPubkey, String applicationPubkey) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    
    if (_isDefaultUser(userPubkey)) {
      return await isar.signedEventDBISARs
          .filter()
          .applicationPubkeyEqualTo(applicationPubkey)
          .count();
    } else {
      return await isar.signedEventDBISARs
          .filter()
          .userPubkeyEqualTo(userPubkey)
          .applicationPubkeyEqualTo(applicationPubkey)
          .count();
    }
  }

  /// Helper method to check if user is default user
  static bool _isDefaultUser(String userPubkey) {
    return userPubkey.startsWith('default_user_');
  }

  /// Delete old events for specific application pubkey, keeping only the latest ones
  static Future<void> deleteOldEventsForApplication(String userPubkey, String applicationPubkey, {int keepCount = 50}) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    
    // Get the total count of events for this application
    final totalCount = await getEventCountByApplicationPubkey(userPubkey, applicationPubkey);
    
    // Only delete if we have more than keepCount events
    if (totalCount > keepCount) {
      List<SignedEventDBISAR> eventsToDelete;
      
      if (_isDefaultUser(userPubkey)) {
        eventsToDelete = await isar.signedEventDBISARs
            .filter()
            .applicationPubkeyEqualTo(applicationPubkey)
            .sortBySignedTimestampDesc()
            .offset(keepCount)
            .findAll();
      } else {
        eventsToDelete = await isar.signedEventDBISARs
            .filter()
            .userPubkeyEqualTo(userPubkey)
            .applicationPubkeyEqualTo(applicationPubkey)
            .sortBySignedTimestampDesc()
            .offset(keepCount)
            .findAll();
      }
      
      // Delete old events
      if (eventsToDelete.isNotEmpty) {
        await isar.writeTxn(() async {
          for (final event in eventsToDelete) {
            await isar.signedEventDBISARs.delete(event.id);
          }
        });
        print('🗑️ [SignedEventDBISAR] Deleted ${eventsToDelete.length} old events for application: $applicationPubkey (kept $keepCount latest)');
      }
    } else {
      print('📊 [SignedEventDBISAR] No cleanup needed for $applicationPubkey (current count: $totalCount, max: $keepCount)');
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

  /// Delete all signed events for a user
  static Future<void> deleteAllFromDB(String userPubkey) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    
    List<SignedEventDBISAR> eventsToDelete;
    if (_isDefaultUser(userPubkey)) {
      eventsToDelete = await isar.signedEventDBISARs.where().findAll();
    } else {
      eventsToDelete = await isar.signedEventDBISARs
          .filter()
          .userPubkeyEqualTo(userPubkey)
          .findAll();
    }
    
    if (eventsToDelete.isNotEmpty) {
      await isar.writeTxn(() async {
        for (final event in eventsToDelete) {
          await isar.signedEventDBISARs.delete(event.id);
        }
      });
    }
  }

  /// Delete all signed events for a specific application
  static Future<void> deleteAllEventsForApplication(String userPubkey, String applicationPubkey) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    
    List<SignedEventDBISAR> eventsToDelete;
    if (_isDefaultUser(userPubkey)) {
      eventsToDelete = await isar.signedEventDBISARs
          .filter()
          .applicationPubkeyEqualTo(applicationPubkey)
          .findAll();
    } else {
      eventsToDelete = await isar.signedEventDBISARs
          .filter()
          .userPubkeyEqualTo(userPubkey)
          .applicationPubkeyEqualTo(applicationPubkey)
          .findAll();
    }
    
    if (eventsToDelete.isNotEmpty) {
      await isar.writeTxn(() async {
        for (final event in eventsToDelete) {
          await isar.signedEventDBISARs.delete(event.id);
        }
      });
    }
  }

  /// Get events by connection type (from metadata)
  static Future<List<SignedEventDBISAR>> getByConnectionType(String userPubkey, String connectionType) async {
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    
    // Get all events first (since metadata is JSON string, we need to filter in memory)
    List<SignedEventDBISAR> allEvents;
    if (_isDefaultUser(userPubkey)) {
      allEvents = await isar.signedEventDBISARs
          .where()
          .sortBySignedTimestampDesc()
          .findAll();
    } else {
      allEvents = await isar.signedEventDBISARs
          .filter()
          .userPubkeyEqualTo(userPubkey)
          .sortBySignedTimestampDesc()
          .findAll();
    }
    
    // Filter by connection_type in metadata
    return allEvents.where((event) {
      if (event.metadata == null || event.metadata!.isEmpty) {
        return false;
      }
      try {
        final metadata = json.decode(event.metadata!);
        return metadata['connection_type'] == connectionType;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// Get unique applications by connection type
  /// Returns a map of applicationPubkey -> (latest event, applicationName, url, icon)
  static Future<Map<String, Map<String, dynamic>>> getUniqueApplicationsByConnectionType(
    String userPubkey,
    String connectionType,
  ) async {
    final events = await getByConnectionType(userPubkey, connectionType);
    
    // Group by applicationPubkey and keep the latest event for each
    final Map<String, SignedEventDBISAR> latestEvents = {};
    for (final event in events) {
      if (event.applicationPubkey == null || event.applicationPubkey!.isEmpty) {
        continue;
      }
      
      final pubkey = event.applicationPubkey!;
      if (!latestEvents.containsKey(pubkey) ||
          event.signedTimestamp > latestEvents[pubkey]!.signedTimestamp) {
        latestEvents[pubkey] = event;
      }
    }
    
    // Extract application info from events
    final Map<String, Map<String, dynamic>> applications = {};
    for (final entry in latestEvents.entries) {
      final event = entry.value;
      String? url;
      String? title;
      String? icon;
      
      // Extract from metadata
      if (event.metadata != null && event.metadata!.isNotEmpty) {
        try {
          final metadata = json.decode(event.metadata!);
          url = metadata['url'] as String?;
          title = metadata['title'] as String?;
          icon = metadata['icon'] as String?;
        } catch (e) {
          // Ignore parse errors
        }
      }
      
      applications[entry.key] = {
        'applicationPubkey': entry.key,
        'applicationName': event.applicationName ?? title ?? url ?? entry.key,
        'url': url ?? entry.key,
        'title': title ?? event.applicationName ?? entry.key,
        'icon': icon,
        'lastUsedTimestamp': event.signedTimestamp,
        'eventCount': events.where((e) => e.applicationPubkey == entry.key).length,
      };
    }
    
    return applications;
  }
}
 