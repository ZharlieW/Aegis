/// Read-only view of current account for dependency injection.
/// Allows tests to inject a mock without touching Account singleton.
abstract class ICurrentAccount {
  String get currentPubkey;
  String get currentPrivkey;
  bool get isLoggedIn;
}
