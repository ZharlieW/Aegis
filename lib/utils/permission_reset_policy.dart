import 'package:aegis/db/clientAuthDB_isar.dart';

class PermissionResetPlan {
  final List<String> allowedMethods;
  final String appKey;

  const PermissionResetPlan({
    required this.allowedMethods,
    required this.appKey,
  });
}

class PermissionResetPolicy {
  const PermissionResetPolicy._();

  static PermissionResetPlan forApp(ClientAuthDBISAR app) {
    final appKey =
        app.clientPubkey.isNotEmpty ? app.clientPubkey : (app.remoteSignerPubkey ?? '');
    return PermissionResetPlan(
      allowedMethods: const <String>[],
      appKey: appKey,
    );
  }
}
