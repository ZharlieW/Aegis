import 'dart:async';
import '../nostr/keychain.dart';
import '../nostr/nips/nip19/nip19.dart';

abstract mixin class AccountObservers {
  void didLoginSuccess();

  void didSwitchUser();

  void didLogout();

  void didUpdateUserInfo() {}
}

class Account {
  Account._internal();
  factory Account() => sharedInstance;
  static final Account sharedInstance = Account._internal();

  final List<AccountObservers> _observers = <AccountObservers>[];

  String currentPubkey = '';
  String currentPrivkey = '';

  void addObserver(AccountObservers observer) => _observers.add(observer);

  bool removeObserver(AccountObservers observer) => _observers.remove(observer);

  Future<void> loginSuccess() async {
    for (AccountObservers observer in _observers) {
      observer.didLoginSuccess();
    }
  }

  bool isValidPubKey(String pubKey) {
    final pattern = RegExp(r'^[a-fA-F0-9]{64}$');
    return pattern.hasMatch(pubKey);
  }

  static String getPrivateKey(String nsec){
    return Nip19.decodePrivkey(nsec);
  }

  static Keychain generateNewKeychain() {
    return Keychain.generate();
  }

  static String getPublicKey(String privkey) {
    return Keychain.getPublicKey(privkey);
  }

  static String getNupPublicKey(String publicKey) {
    return Nip19.encodePubkey(publicKey);
  }

  static bool validateNsec(String nsecBase64) {
    try {
      if (nsecBase64.length != 63) {
        return false;
      }
      if (!nsecBase64.startsWith('nsec')) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {

  }
}
