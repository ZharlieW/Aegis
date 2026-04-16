import 'package:isar/isar.dart';

part 'remembered_permission_choice_isar.g.dart';

/// Milliseconds since epoch; values beyond practical range mean "no expiry".
const int kRememberPermissionChoiceNoExpiryMs = 253402300799000;

/// Per-app remembered manual-approval choice: only [clientPubkey], [methodKey], [expiresAtMs].
/// Stored in a separate Isar collection so [ClientAuthDBISAR] stays unchanged.
@collection
class RememberedPermissionChoiceDBISAR {
  Id id = Isar.autoIncrement;

  /// Connected application pubkey (same key used in [PermissionApprovalBatcher] queues).
  @Index()
  late String clientPubkey;

  late String methodKey;

  /// Grant valid while `DateTime.now().millisecondsSinceEpoch < expiresAtMs`.
  late int expiresAtMs;

  RememberedPermissionChoiceDBISAR({
    required this.clientPubkey,
    required this.methodKey,
    required this.expiresAtMs,
  });
}
