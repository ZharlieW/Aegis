import 'dart:async';
import 'dart:io';

import 'package:aegis/db/userDB_isar.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'clientAuthDB_isar.dart';

class DBISAR {
  static final DBISAR sharedInstance = DBISAR._internal();
  DBISAR._internal();
  factory DBISAR() => sharedInstance;

  late Isar isar;

  final Map<Type, List<dynamic>> _buffers = {};

  Timer? _timer;

  List<CollectionSchema<dynamic>> schemas = [
    UserDBISARSchema,
    ClientAuthDBISARSchema
  ];

  Future<Isar> open(String pubkey) async {
    bool isOS = Platform.isIOS || Platform.isMacOS;
    Directory directory = isOS ? await getLibraryDirectory() : await getApplicationDocumentsDirectory();
    var dbPath = directory.path;
    print(() => 'DBISAR open: $dbPath, pubkey: $pubkey');
    isar = Isar.getInstance(pubkey) ??
        await Isar.open(
          schemas,
          directory: dbPath,
          name: pubkey,
        );
    return isar;
  }

  Map<Type, List<dynamic>> getBuffers() {
    return Map.from(_buffers);
  }

  Future<void> saveObjectsToDB<T>(List<T> objects) async {
    for (var object in objects) {
      await saveToDB(object);
    }
  }

  Future<void> saveToDB<T>(T object) async {
    final type = T;
    if (!_buffers.containsKey(type)) {
      _buffers[type] = <T>[];
    }
    _buffers[type]!.add(object);

    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 200), () async {
      await _putAll();
    });
  }

  Future<void> _putAll() async {
    _timer?.cancel();
    _timer = null;

    if (_buffers.isEmpty) return;

    final Map<Type, List<dynamic>> typeMap = Map.from(_buffers);
    _buffers.clear();

    await isar.writeTxn(() async {
      await Future.forEach(typeMap.keys, (type) async {
        await _saveTOISAR(typeMap[type]!, type);
      });
    });
  }

  Future<void> _saveTOISAR(List<dynamic> objects, Type type) async {
    String typeName = type.toString().replaceAll('?', '');
    IsarCollection? collection = isar.getCollectionByNameInternal(typeName);
    if (collection != null) {
      await collection.putAll(objects);
    }
  }

  Future<void> closeDatabase() async {
    _buffers.clear();
    _timer?.cancel();
    _timer = null;
    if (isar.isOpen) await isar.close();
  }

  Future<void> closeDatabaseFor(String pubkey) async {
    final instance = Isar.getInstance(pubkey);
    if (instance != null && instance.isOpen) {
      await instance.close();
    }
  }
}
