import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aegis/utils/local_storage.dart';

/// Manager for handling incremental napp list updates
class NappUpdateManager {
  static const String _appliedVersionsKey = 'napp_applied_update_versions';
  static const String _updateFilePrefix = 'napp_updates_v';
  static const String _updateFileSuffix = '.json';
  static const String _updateDirectory = 'lib/assets/napp_updates/';

  /// Get list of applied update versions from LocalStorage
  static Future<List<String>> getAppliedVersions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final versions = prefs.getStringList(_appliedVersionsKey);
      if (versions != null) {
        return versions;
      }
      
      // Fallback: try to get as JSON string (for backward compatibility)
      final versionsJson = LocalStorage.get(_appliedVersionsKey);
      if (versionsJson is List) {
        return versionsJson.map((v) => v.toString()).toList();
      } else if (versionsJson is String) {
        // Handle legacy format (single version string)
        return [versionsJson];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Mark an update version as applied
  static Future<void> markVersionApplied(String version) async {
    try {
      final appliedVersions = await getAppliedVersions();
      if (!appliedVersions.contains(version)) {
        appliedVersions.add(version);
        // Use SharedPreferences directly for List<String> storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(_appliedVersionsKey, appliedVersions);
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Parse version number from filename
  /// Example: "napp_updates_v0.1.1.json" -> "0.1.1"
  static String? parseUpdateVersion(String filename) {
    try {
      if (!filename.startsWith(_updateFilePrefix) || 
          !filename.endsWith(_updateFileSuffix)) {
        return null;
      }
      
      final versionPart = filename.substring(
        _updateFilePrefix.length,
        filename.length - _updateFileSuffix.length,
      );
      return versionPart;
    } catch (e) {
      return null;
    }
  }

  /// Compare two version strings (semantic versioning)
  /// Returns: -1 if v1 < v2, 0 if v1 == v2, 1 if v1 > v2
  static int compareVersions(String v1, String v2) {
    try {
      final parts1 = v1.split('.').map((s) => int.tryParse(s) ?? 0).toList();
      final parts2 = v2.split('.').map((s) => int.tryParse(s) ?? 0).toList();
      
      // Pad shorter version with zeros
      final maxLength = parts1.length > parts2.length ? parts1.length : parts2.length;
      while (parts1.length < maxLength) parts1.add(0);
      while (parts2.length < maxLength) parts2.add(0);
      
      for (int i = 0; i < maxLength; i++) {
        if (parts1[i] < parts2[i]) return -1;
        if (parts1[i] > parts2[i]) return 1;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get list of available update files
  /// Note: In Flutter, we can't directly list assets directory,
  /// so we need to maintain a list or try to load known files
  static Future<List<String>> getAvailableUpdateFiles() async {
    // List of known update files - this should be maintained when adding new updates
    // Alternatively, we could use a manifest file that lists all available updates
    const knownFiles = [
      'napp_updates_v0.1.1.json',
      // Add more update files here as they are created
    ];

    final availableFiles = <String>[];
    
    for (final filename in knownFiles) {
      try {
        // Try to load the file to verify it exists
        await rootBundle.loadString('$_updateDirectory$filename');
        availableFiles.add(filename);
      } catch (e) {
        // File doesn't exist, skip it
        continue;
      }
    }
    
    return availableFiles;
  }

  /// Get unapplied update files, sorted by version
  static Future<List<String>> getUnappliedUpdates() async {
    try {
      final appliedVersions = await getAppliedVersions();
      final availableFiles = await getAvailableUpdateFiles();
      
      final unapplied = <String>[];
      
      for (final filename in availableFiles) {
        final version = parseUpdateVersion(filename);
        if (version != null && !appliedVersions.contains(version)) {
          unapplied.add(filename);
        }
      }
      
      // Sort by version number (ascending)
      unapplied.sort((a, b) {
        final v1 = parseUpdateVersion(a) ?? '';
        final v2 = parseUpdateVersion(b) ?? '';
        return compareVersions(v1, v2);
      });
      
      return unapplied;
    } catch (e) {
      return [];
    }
  }

  /// Load and parse an update file
  static Future<Map<String, dynamic>?> loadUpdateFile(String filename) async {
    try {
      final content = await rootBundle.loadString('$_updateDirectory$filename');
      final jsonData = jsonDecode(content) as Map<String, dynamic>;
      return jsonData;
    } catch (e) {
      return null;
    }
  }

  /// Get apps from an update file
  static Future<List<Map<String, dynamic>>> getAppsFromUpdate(String filename) async {
    try {
      final updateData = await loadUpdateFile(filename);
      if (updateData == null) return [];
      
      final apps = updateData['apps'];
      if (apps is List) {
        return apps.map((app) => app as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

