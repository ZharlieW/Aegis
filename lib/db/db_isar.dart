import 'dart:async';
import 'dart:io';

import 'package:aegis/db/userDB_isar.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aegis/utils/logger.dart';

import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/db/user_app_db_isar.dart';

class DBISAR {
  DBISAR._internal();
  static final DBISAR sharedInstance = DBISAR._internal();
  factory DBISAR() => sharedInstance;

  final Map<String, Isar> _instances = {};
  final Map<String, Map<Type, List<dynamic>>> _buffers = {};
  final Map<String, Timer?> _timers = {};

  final List<CollectionSchema<dynamic>> schemas = [
    UserDBISARSchema,
    ClientAuthDBISARSchema,
    SignedEventDBISARSchema,
    UserAppDBISARSchema,
  ];

  Future<Isar> open(String pubkey) async {
    if (_instances.containsKey(pubkey) && _instances[pubkey]!.isOpen) {
      return _instances[pubkey]!;
    }
    final isOS = Platform.isIOS || Platform.isMacOS;
    final dir = isOS
        ? await getLibraryDirectory()
        : await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      schemas,
      directory: dir.path,
      name: pubkey,
    );
    _instances[pubkey] = isar;
    _buffers.putIfAbsent(pubkey, () => {});
    AegisLogger.info('DBISAR open: $dir, pubkey: $pubkey');

    return isar;
  }

  Future<void> saveToDB<T>(String pubkey, T object) async {
    final isar = await open(pubkey);
    final map = _buffers[pubkey]!;
    final type = T;
    map[type] = (map[type] ?? <T>[])..add(object);

    _timers[pubkey]?.cancel();
    _timers[pubkey] = Timer(const Duration(milliseconds: 200), () async {
      await _putAll(pubkey);
    });
  }

  Future<void> _putAll(String pubkey) async {
    _timers[pubkey]?.cancel();
    _timers.remove(pubkey);

    final map = Map<Type, List<dynamic>>.from(_buffers[pubkey] ?? {});
    _buffers[pubkey]?.clear();
    if (map.isEmpty) return;

    final isar = _instances[pubkey]!;
    if (!isar.isOpen) return;

    await isar.writeTxn(() async {
      for (final entry in map.entries) {
        final name = entry.key.toString().replaceAll('?', '');
        final col = isar.getCollectionByNameInternal(name);
        if (col != null) {
          await col.putAll(entry.value);
        }
      }
    });
  }

  Future<void> closeDatabaseFor(String pubkey) async {
    final isar = _instances.remove(pubkey);
    _timers[pubkey]?.cancel();
    _timers.remove(pubkey);
    _buffers.remove(pubkey);
    if (isar != null && isar.isOpen) {
      await isar.close();
    }
  }

  Future<void> closeAllDatabases() async {
    for (final key in List<String>.from(_instances.keys)) {
      await closeDatabaseFor(key);
    }
  }

  /// Delete database files from disk for a specific user
  Future<void> deleteDatabaseFor(String pubkey) async {
    // Close the database first if it's open
    await closeDatabaseFor(pubkey);
    
    // Delete database files from disk
    final isOS = Platform.isIOS || Platform.isMacOS;
    final dir = isOS
        ? await getLibraryDirectory()
        : await getApplicationDocumentsDirectory();
    
    try {
      // Isar creates files with pattern: {name}.isar and {name}.lock
      final dbFile = File('${dir.path}/$pubkey.isar');
      final lockFile = File('${dir.path}/$pubkey.lock');
      
      if (await dbFile.exists()) {
        await dbFile.delete();
        AegisLogger.info('DBISAR deleted database file: ${dbFile.path}');
      }
      
      if (await lockFile.exists()) {
        await lockFile.delete();
        AegisLogger.info('DBISAR deleted lock file: ${lockFile.path}');
      }
      
      AegisLogger.info('DBISAR deleted database files for pubkey: $pubkey');
    } catch (e) {
      AegisLogger.error('DBISAR failed to delete database files for pubkey: $pubkey', e);
    }
  }
}
