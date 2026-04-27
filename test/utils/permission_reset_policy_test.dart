import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/utils/permission_reset_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PermissionResetPolicy', () {
    test('uses clientPubkey when available', () {
      final app = ClientAuthDBISAR(
        pubkey: 'user',
        clientPubkey: 'client',
        connectionType: 0,
        allowedMethodsParam: ['sign_event', 'nip44_encrypt'],
      );

      final plan = PermissionResetPolicy.forApp(app);

      expect(plan.appKey, 'client');
      expect(plan.allowedMethods, isEmpty);
    });

    test('falls back to remoteSignerPubkey when clientPubkey is empty', () {
      final app = ClientAuthDBISAR(
        pubkey: 'user',
        clientPubkey: '',
        remoteSignerPubkey: 'remote',
        connectionType: 0,
        allowedMethodsParam: ['sign_event'],
      );

      final plan = PermissionResetPolicy.forApp(app);

      expect(plan.appKey, 'remote');
      expect(plan.allowedMethods, isEmpty);
    });
  });
}
