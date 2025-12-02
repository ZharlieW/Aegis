import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/thread_pool_manager.dart';
import 'package:aegis/utils/logger.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;
import '../event.dart';
import 'nostr_signer.dart';

class LocalNostrSigner implements NostrSigner {
  static final LocalNostrSigner instance = LocalNostrSigner._internal();
  factory LocalNostrSigner() => instance;
  LocalNostrSigner._internal();

  late String privateKey;
  late String publicKey;

  final ThreadPoolManager _threadPool = ThreadPoolManager();

  void init() {
    privateKey = Account.sharedInstance.currentPrivkey;
    publicKey = Account.sharedInstance.currentPubkey;
    _threadPool.initialize();
  }

  Future<void> _ensureThreadPoolInitialized() async {
    try {
      await _threadPool.initialize();
    } catch (e) {
      AegisLogger.error('ThreadPool initialization failed', e);
    }
  }

  String? getPublicKey(String clientPubkey) {
    return AccountManager.sharedInstance.applicationMap[clientPubkey]?.value.pubkey ?? publicKey;
  }

  String? getPrivateKey(String clientPubkey) {
    AccountManager instance = AccountManager.sharedInstance;
    final pubkey = instance.applicationMap[clientPubkey]?.value.pubkey;
    if (pubkey != null && instance.accountMap[pubkey] != null) {
      // Return the cached private key if available
      return instance.accountMap[pubkey]!.privkey ?? privateKey;
    }
    return privateKey;
  }

  /// Async method to get private key with decryption support
  Future<String?> getPrivateKeyAsync(String clientPubkey) async {
    AccountManager instance = AccountManager.sharedInstance;
    final pubkey = instance.applicationMap[clientPubkey]?.value.pubkey;
    if (pubkey != null && instance.accountMap[pubkey] != null) {
      return await instance.accountMap[pubkey]!.getPrivkeyAsync();
    }
    return privateKey;
  }

  @override
  Future<Map?> getRelays() async {
    return null;
  }

  @override
  Future<Event?> signEvent(Event event) async {
    // event.sign(privateKey);
    return event;
  }

  @override
  Future<String?> nip44Decrypt(String serverPrivate, String ciphertext, String clientPubkey) async {
    try {
      await _ensureThreadPoolInitialized();

      try {
        final nativeResult = await rust_api.nip44Decrypt(
          ciphertext: ciphertext,
          publicKey: clientPubkey,
          privateKey: serverPrivate,
        );
        AegisLogger.crypto('NIP44 decryption', true, true);
        return nativeResult;
      } catch (e) {
        AegisLogger.crypto('NIP44 decryption', true, false, e.toString());
      }
    } catch (e) {
      AegisLogger.error('nip44Decrypt error', e);
      return null;
    }
    return null;
  }

  @override
  Future<String?> nip44Encrypt(String serverPrivate, String plaintext, String clientPubkey) async {
    try {
      await _ensureThreadPoolInitialized();

      try {
        final nativeResult = await rust_api.nip44Encrypt(
          plaintext: plaintext,
          publicKey: clientPubkey,
          privateKey: serverPrivate,
        );
        AegisLogger.crypto('NIP44 encryption', true, true);
        return nativeResult;
      } catch (e) {
        AegisLogger.crypto('NIP44 encryption', true, false, e.toString());
      }
    } catch (e) {
      AegisLogger.error('nip44Encrypt error', e);
      return null;
    }
    return null;
  }

  @override
  Future<String?> decrypt(clientPubkey, ciphertext) async {
    try {
      final serverPrivate = getPrivateKey(clientPubkey);
      if (serverPrivate == null) return null;

      try {
        final nativeResult = await rust_api.nip04Decrypt(
          ciphertext: ciphertext,
          publicKey: clientPubkey,
          privateKey: serverPrivate,
        );
        AegisLogger.crypto('NIP04 decryption', true, true);
        return nativeResult;
      } catch (e) {
        AegisLogger.crypto('NIP04 decryption', true, false, e.toString());
      }
    } catch (e) {
      AegisLogger.error('NIP04 decrypt error', e);
      return null;
    }
    return null;
  }

  @override
  Future<String?> encrypt(clientPubkey, plaintext) async {
    try {
      final serverPrivate = getPrivateKey(clientPubkey);
      if (serverPrivate == null) return null;

      try {
        final nativeResult = await rust_api.nip04Encrypt(
          plaintext: plaintext,
          publicKey: clientPubkey,
          privateKey: serverPrivate,
        );
        AegisLogger.crypto('NIP04 encryption', true, true);
        return nativeResult;
      } catch (e) {
        AegisLogger.crypto('NIP04 encryption', true, false, e.toString());
      }
    } catch (e) {
      AegisLogger.error('NIP04 encrypt error', e);
      return null;
    }
    return null;
  }
}
