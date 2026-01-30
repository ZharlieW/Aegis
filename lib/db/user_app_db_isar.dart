import 'dart:convert';
import 'package:isar/isar.dart';

import 'db_isar.dart';

part 'user_app_db_isar.g.dart';

@collection
class UserAppDBISAR {
  Id id = Isar.autoIncrement;
  
  // Application ID (unique identifier)
  late String appId;
  
  // Application URL (required, used for deduplication, indexed)
  @Index()
  late String url;
  
  // Application name
  late String name;
  
  // Application icon URL
  late String icon;
  
  // Application description
  late String description;
  
  // Platforms list (JSON string, e.g., ["web"])
  late String? platformsJson;
  
  // Metadata (JSON string)
  late String? metadataJson;
  
  // Creation timestamp (indexed for sorting)
  @Index()
  late int createTimestamp;
  
  // Favorite status (indexed for fast queries)
  @Index()
  late bool isFavorite;
  
  // Whether this is a preset app (from JSON file)
  late bool isPreset;

  UserAppDBISAR({
    required this.appId,
    required this.url,
    required this.name,
    required this.icon,
    required this.description,
    this.platformsJson,
    this.metadataJson,
    required this.createTimestamp,
    this.isFavorite = false,
    this.isPreset = false,
  });

  /// Save app to database (update if URL already exists)
  static Future<void> saveFromDB(UserAppDBISAR app) async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    
    // Check if app with same URL exists
    final existing = await isar.userAppDBISARs
        .filter()
        .urlEqualTo(app.url)
        .findFirst();
    
    await isar.writeTxn(() async {
      if (existing != null) {
        // Update existing app
        app.id = existing.id;
        await isar.userAppDBISARs.put(app);
      } else {
        // Insert new app
        await isar.userAppDBISARs.put(app);
      }
    });
  }

  /// Get all apps from database
  static Future<List<UserAppDBISAR>> getAllFromDB() async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    return await isar.userAppDBISARs
        .where()
        .sortByCreateTimestampDesc()
        .findAll();
  }

  /// Get app by URL
  static Future<UserAppDBISAR?> getByUrl(String url) async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    return await isar.userAppDBISARs
        .filter()
        .urlEqualTo(url)
        .findFirst();
  }

  /// Delete app by URL
  static Future<void> deleteFromDB(String url) async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    final app = await getByUrl(url);
    if (app != null) {
      await isar.writeTxn(() async {
        await isar.userAppDBISARs.delete(app.id);
      });
    }
  }

  /// Delete all apps from database
  static Future<void> deleteAllFromDB() async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    final apps = await isar.userAppDBISARs.where().findAll();
    if (apps.isNotEmpty) {
      await isar.writeTxn(() async {
        for (final app in apps) {
          await isar.userAppDBISARs.delete(app.id);
        }
      });
    }
  }

  /// Check if preset apps have been imported
  static Future<bool> isPresetAppsImported() async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    final count = await isar.userAppDBISARs
        .filter()
        .isPresetEqualTo(true)
        .count();
    return count > 0;
  }

  /// Import preset apps from JSON
  static Future<void> importPresetApps(List<Map<String, dynamic>> apps) async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    
    await isar.writeTxn(() async {
      for (final appMap in apps) {
        try {
          final appId = appMap['id'] as String? ?? '';
          final url = appMap['url'] as String? ?? '';
          final name = appMap['name'] as String? ?? '';
          final icon = appMap['icon'] as String? ?? '';
          final description = appMap['description'] as String? ?? '';
          final platforms = appMap['platforms'] as List<dynamic>?;
          final metadata = appMap['metadata'] as Map<String, dynamic>?;
          
          if (url.isEmpty) continue;
          
          // Check if app already exists
          final existing = await isar.userAppDBISARs
              .filter()
              .urlEqualTo(url)
              .findFirst();
          
          String? platformsJson;
          if (platforms != null && platforms.isNotEmpty) {
            platformsJson = jsonEncode(platforms);
          }
          
          String? metadataJson;
          if (metadata != null && metadata.isNotEmpty) {
            metadataJson = jsonEncode(metadata);
          }
          
          final dbApp = UserAppDBISAR(
            appId: appId,
            url: url,
            name: name,
            icon: icon,
            description: description,
            platformsJson: platformsJson,
            metadataJson: metadataJson,
            createTimestamp: DateTime.now().millisecondsSinceEpoch,
            isFavorite: false,
            isPreset: true,
          );
          
          if (existing != null) {
            // Update existing app but preserve favorite status
            dbApp.id = existing.id;
            dbApp.isFavorite = existing.isFavorite;
            await isar.userAppDBISARs.put(dbApp);
          } else {
            // Insert new app
            await isar.userAppDBISARs.put(dbApp);
          }
        } catch (e) {
          // Skip invalid apps
          continue;
        }
      }
    });
  }

  /// Get all favorite apps
  static Future<List<UserAppDBISAR>> getFavoriteApps() async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    return await isar.userAppDBISARs
        .filter()
        .isFavoriteEqualTo(true)
        .sortByCreateTimestampDesc()
        .findAll();
  }

  /// Toggle favorite status for an app
  static Future<void> toggleFavorite(String url, bool isFavorite) async {
    final isar = await DBISAR.sharedInstance.open('browser_apps');
    final app = await getByUrl(url);
    if (app != null) {
      await isar.writeTxn(() async {
        app.isFavorite = isFavorite;
        await isar.userAppDBISARs.put(app);
      });
    }
  }
}

