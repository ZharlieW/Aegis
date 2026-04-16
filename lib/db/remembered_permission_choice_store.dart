import 'package:aegis/db/db_isar.dart';
import 'package:aegis/db/remembered_permission_choice_isar.dart';
import 'package:isar/isar.dart';

/// Persistence for batch-dialog "remember this permission" (not URI [allowedMethods]).
class RememberedPermissionChoiceStore {
  RememberedPermissionChoiceStore._();

  static Future<bool> isValid({
    required String userPubkey,
    required String clientPubkey,
    required String methodKey,
  }) async {
    if (clientPubkey.isEmpty || methodKey.isEmpty) return false;
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = await isar.rememberedPermissionChoiceDBISARs
        .filter()
        .clientPubkeyEqualTo(clientPubkey)
        .findAll();
    RememberedPermissionChoiceDBISAR? row;
    for (final r in rows) {
      if (r.methodKey == methodKey) {
        row = r;
        break;
      }
    }
    if (row == null) return false;
    if (row.expiresAtMs <= now) {
      final id = row.id;
      await isar.writeTxn(() async {
        await isar.rememberedPermissionChoiceDBISARs.delete(id);
      });
      return false;
    }
    return true;
  }

  static Future<void> upsert({
    required String userPubkey,
    required String clientPubkey,
    required String methodKey,
    required int expiresAtMs,
  }) async {
    if (clientPubkey.isEmpty || methodKey.isEmpty) return;
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    final rows = await isar.rememberedPermissionChoiceDBISARs
        .filter()
        .clientPubkeyEqualTo(clientPubkey)
        .findAll();
    RememberedPermissionChoiceDBISAR? existing;
    for (final r in rows) {
      if (r.methodKey == methodKey) {
        existing = r;
        break;
      }
    }
    await isar.writeTxn(() async {
      if (existing != null) {
        existing.expiresAtMs = expiresAtMs;
        await isar.rememberedPermissionChoiceDBISARs.put(existing);
      } else {
        await isar.rememberedPermissionChoiceDBISARs.put(
          RememberedPermissionChoiceDBISAR(
            clientPubkey: clientPubkey,
            methodKey: methodKey,
            expiresAtMs: expiresAtMs,
          ),
        );
      }
    });
  }

  static Future<void> deleteAllForClient({
    required String userPubkey,
    required String clientPubkey,
  }) async {
    if (clientPubkey.isEmpty) return;
    final isar = await DBISAR.sharedInstance.open(userPubkey);
    await isar.writeTxn(() async {
      await isar.rememberedPermissionChoiceDBISARs
          .filter()
          .clientPubkeyEqualTo(clientPubkey)
          .deleteAll();
    });
  }

}
