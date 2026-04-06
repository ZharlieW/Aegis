import 'dart:convert';

/// Canonical methodKey mapping used across NIP-46 handlers.
/// Keep this as the single source of truth for permission keys.
class Nip46MethodKey {
  /// Ordered list for permissions UI and persistence.
  static const List<String> supportedPermissionMethodKeys = [
    'get_public_key',
    'nip04_encrypt',
    'nip04_decrypt',
    'nip44_decrypt',
    'nip44_encrypt',
    'sign_event:0',
    'sign_event:1',
    'sign_event:3',
    'sign_event:4',
    'sign_event:5',
    'sign_event:6',
    'sign_event:7',
    'sign_event:9734',
    'sign_event:9735',
    'sign_event:10000',
    'sign_event:10002',
    'sign_event:10003',
    'sign_event:10013',
    'sign_event:31234',
    'sign_event:30078',
    'sign_event:22242',
    'sign_event:27235',
    'sign_event:30023',
  ];

  /// Extract event kind from sign_event params[0] JSON.
  static int? extractSignEventKind(List<String?> params) {
    if (params.isEmpty) return null;
    final content = params[0];
    if (content == null || content.isEmpty) return null;
    try {
      final decoded = jsonDecode(content);
      if (decoded is! Map) return null;
      final kindVal = decoded['kind'];
      if (kindVal is int) return kindVal;
      if (kindVal is num) return kindVal.toInt();
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Map NIP-46 method + params to stable methodKey.
  static String resolve(String method, List<String?> params) {
    if (method == 'sign_event') {
      final kind = extractSignEventKind(params);
      if (kind != null) return 'sign_event:$kind';
      return 'sign_event';
    }
    return method;
  }
}

