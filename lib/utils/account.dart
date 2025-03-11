import 'dart:async';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:flutter/foundation.dart';

import '../nostr/event.dart';
import '../nostr/keychain.dart';
import '../nostr/nips/nip19/nip19.dart';

abstract mixin class AccountObservers {
  void didLoginSuccess();

  void didSwitchUser();

  void didLogout();

  void didAddBunkerSocketMap();

  void didAddClientRequestMap();
}

class Account {
  Account._internal();
  factory Account() => sharedInstance;
  static final Account sharedInstance = Account._internal();

  final List<AccountObservers> _observers = <AccountObservers>[];

  // key: createTimestamp + port
  final ValueListenable<Map<String,BunkerSocket>> bunkerSocketMap = ValueNotifier({});

  final ValueListenable<List<ClientRequest>> clientRequestList = ValueNotifier([]);

  String _currentPubkey = '';
  String _currentPrivkey = '';

  void addObserver(AccountObservers observer) => _observers.add(observer);

  bool removeObserver(AccountObservers observer) => _observers.remove(observer);

  String get currentPubkey {
    return _currentPubkey;
  }

  String get currentPrivkey {
    return _currentPrivkey;
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
    _currentPubkey = '';
    _currentPrivkey = '';
    for (AccountObservers observer in _observers) {
      observer.didLogout();
    }
  }

  Future<void> loginSuccess(String pubkey,String privkey) async {
    _currentPubkey = pubkey;
    _currentPrivkey = privkey;
    for (AccountObservers observer in _observers) {
      observer.didLoginSuccess();
    }
  }

  void addBunkerSocketMap(BunkerSocket bunkerSocket){
    String key = '${bunkerSocket.createTimestamp}${bunkerSocket.port}';
    bunkerSocketMap.value[key] = bunkerSocket;
    for (AccountObservers observer in _observers) {
      observer.didAddBunkerSocketMap();
    }
  }

  void removeBunkerSocketMap(BunkerSocket bunkerSocket){
    String key = '${bunkerSocket.createTimestamp}${bunkerSocket.port}';
    bunkerSocketMap.value[key] = bunkerSocket;
    for (AccountObservers observer in _observers) {
      observer.didAddBunkerSocketMap();
    }
  }

  void addClientRequestList(ClientRequest clientRequest){
    clientRequestList.value.add(clientRequest);
    for (AccountObservers observer in _observers) {
      observer.didAddClientRequestMap();
    }
  }
}
