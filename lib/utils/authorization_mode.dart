import 'package:aegis/utils/local_storage.dart';

/// Authorization mode for new app connections: full access or selective permissions.
enum AuthorizationMode {
  full,
  selective,
}

/// Storage key and default for authorization mode (used by Settings and NIP-46 flow).
const String kAuthorizationModeKey = 'authorization_mode';
const String kAuthorizationModeFull = 'full';
const String kAuthorizationModeSelective = 'selective';

/// Reads current authorization mode from local storage. Defaults to [AuthorizationMode.full].
/// Call after [LocalStorage.init] (e.g. app bootstrap).
AuthorizationMode getAuthorizationMode() {
  final value = LocalStorage.get(kAuthorizationModeKey);
  if (value == null) return AuthorizationMode.full;
  if (value == kAuthorizationModeSelective) return AuthorizationMode.selective;
  return AuthorizationMode.full;
}

/// Persists authorization mode. Call [LocalStorage.init] before first use if needed.
Future<bool> setAuthorizationMode(AuthorizationMode mode) async {
  final value = mode == AuthorizationMode.selective
      ? kAuthorizationModeSelective
      : kAuthorizationModeFull;
  return LocalStorage.set(kAuthorizationModeKey, value);
}
