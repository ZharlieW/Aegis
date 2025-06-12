import 'dart:typed_data';

import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/thread_pool_manager.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/lru_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';
import '../../utils/aegis_isolate.dart';
import '../event.dart';
import '../nips/nip04/nip04.dart';
import '../nips/nip04/nip04_native_channel.dart';
import '../nips/nip44/nip44_v2.dart';
import '../nips/nip44/nip44_native_channel.dart';
import 'nostr_signer.dart';

class LocalNostrSigner implements NostrSigner {
  static final LocalNostrSigner instance = LocalNostrSigner._internal();
  factory LocalNostrSigner() => instance;
  LocalNostrSigner._internal();

  late String privateKey;
  late String publicKey;

  final ThreadPoolManager _threadPool = ThreadPoolManager();
  final LRUCache<String, ECDHBasicAgreement> _agreementCache = 
      LRUCache(maxSize: 100, defaultTtl: const Duration(minutes: 15));
  final LRUCache<String, Uint8List> _nip44KeyCache = 
      LRUCache(maxSize: 200, defaultTtl: const Duration(minutes: 15));
  final NIP44NativeChannel _nativeChannel = NIP44NativeChannel();
  final NIP04NativeChannel _nip04NativeChannel = NIP04NativeChannel();

  void init() {
    privateKey = Account.sharedInstance.currentPrivkey;
    publicKey = Account.sharedInstance.currentPubkey;
  }

  Future<void> _ensureThreadPoolInitialized() async {
    try {
      await _threadPool.initialize();
    } catch (e) {
      AegisLogger.error('ThreadPool initialization failed', e);
    }
  }

  String? getPublicKey(String clientPubkey) {
    return AccountManager
            .sharedInstance.applicationMap[clientPubkey]?.value.pubkey ??
        publicKey;
  }

  String? getPrivateKey(String clientPubkey) {
    AccountManager instance = AccountManager.sharedInstance;
    final pubkey = instance.applicationMap[clientPubkey]?.value.pubkey;
    return instance.accountMap[pubkey]?.getPrivkey ?? privateKey;
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

  ECDHBasicAgreement getAgreement(String clientPubkey) {
    final priv = getPrivateKey(clientPubkey)!;
    final key = '$priv|$clientPubkey';
    
    final cached = _agreementCache.get(key);
    if (cached != null) return cached;
    
    final agreement = NIP04.getAgreement(priv);
    _agreementCache.put(key, agreement);
    return agreement;
  }

  @override
  Future<String?> nip44Decrypt(
      String serverPrivate, String ciphertext, String clientPubkey) async {
    try {
      final cacheKey = '$serverPrivate|$clientPubkey';
      var convKey = _nip44KeyCache.get(cacheKey);
      if (convKey == null) {
        convKey = NIP44V2.shareSecret(serverPrivate, clientPubkey);
        _nip44KeyCache.put(cacheKey, convKey);
      }

      try {
        final nativeResult =
            await _nativeChannel.nativeDecrypt(ciphertext, convKey);
        if (nativeResult != null) {
          AegisLogger.crypto('NIP44 decryption', true, true);
          return nativeResult;
        }
      } catch (e) {
        AegisLogger.crypto('NIP44 decryption', true, false, e.toString());
      }

      await _ensureThreadPoolInitialized();

      try {
        return await _threadPool.runAlgorithmTask(() async {
          return await AegisIsolate.nip44DecryptIsolate({
            'ciphertext': ciphertext,
            'convKey': convKey,
          });
        });
      } catch (e) {
        AegisLogger.warning('Thread pool decryption failed, using main thread', e);
        return await AegisIsolate.nip44DecryptIsolate({
          'ciphertext': ciphertext,
          'convKey': convKey,
        });
      }
    } catch (e) {
      AegisLogger.error('nip44Decrypt error', e);
      return null;
    }
  }

  @override
  Future<String?> nip44Encrypt(
      String serverPrivate, String plaintext, String clientPubkey) async {
    try {
      final cacheKey = '$serverPrivate|$clientPubkey';
      var convKey = _nip44KeyCache.get(cacheKey);
      if (convKey == null) {
        convKey = NIP44V2.shareSecret(serverPrivate, clientPubkey);
        _nip44KeyCache.put(cacheKey, convKey);
      }

      try {
        final nativeResult =
            await _nativeChannel.nativeEncrypt(plaintext, convKey);
        if (nativeResult != null) {
          AegisLogger.crypto('NIP44 encryption', true, true);
          return nativeResult;
        }
      } catch (e) {
        AegisLogger.crypto('NIP44 encryption', true, false, e.toString());
      }

      await _ensureThreadPoolInitialized();

      try {
        return await _threadPool.runAlgorithmTask(() async {
          return await AegisIsolate.nip44EncryptIsolate({
            'plaintext': plaintext,
            'convKey': convKey,
          });
        });
      } catch (e) {
        AegisLogger.warning('Thread pool encryption failed, using main thread', e);
        return await AegisIsolate.nip44EncryptIsolate({
          'plaintext': plaintext,
          'convKey': convKey,
        });
      }
    } catch (e) {
      AegisLogger.error('nip44Encrypt error', e);
      return null;
    }
  }

  @override
  Future<String?> decrypt(clientPubkey, ciphertext) async {
    try {
      final serverPrivate = getPrivateKey(clientPubkey)!;

      try {
        final nativeResult = await _nip04NativeChannel.nativeNip04Decrypt(
            ciphertext, serverPrivate, clientPubkey);
        if (nativeResult != null) {
          AegisLogger.crypto('NIP04 decryption', true, true);
          return nativeResult;
        }
      } catch (e) {
        AegisLogger.crypto('NIP04 decryption', true, false, e.toString());
      }

      var agreement = getAgreement(clientPubkey);

      await _ensureThreadPoolInitialized();

      try {
        return await _threadPool.runAlgorithmTask(() async {
          return await AegisIsolate.nip04DecryptIsolate({
            'ciphertext': ciphertext,
            'clientPubkey': clientPubkey,
            'agreement': agreement
          });
        });
      } catch (e) {
        AegisLogger.warning('Thread pool decryption failed, using main thread', e);
        return await AegisIsolate.nip04DecryptIsolate({
          'ciphertext': ciphertext,
          'clientPubkey': clientPubkey,
          'agreement': agreement
        });
      }
    } catch (e) {
      AegisLogger.error('NIP04 decrypt error', e);
      return null;
    }
  }

  @override
  Future<String?> encrypt(clientPubkey, plaintext) async {
    try {
      final serverPrivate = getPrivateKey(clientPubkey)!;

      try {
        final nativeResult = await _nip04NativeChannel.nativeNip04Encrypt(
            plaintext, serverPrivate, clientPubkey);
        if (nativeResult != null) {
          AegisLogger.crypto('NIP04 encryption', true, true);
          return nativeResult;
        }
      } catch (e) {
        AegisLogger.crypto('NIP04 encryption', true, false, e.toString());
      }

      var agreement = getAgreement(clientPubkey);

      await _ensureThreadPoolInitialized();

      try {
        return await _threadPool.runAlgorithmTask(() async {
          return AegisIsolate.nip04EncryptIsolate({
            'plaintext': plaintext,
            'clientPubkey': clientPubkey,
            'agreement': agreement
          });
        });
      } catch (e) {
        AegisLogger.warning('Thread pool encryption failed, using main thread', e);
        return await AegisIsolate.nip04EncryptIsolate({
          'plaintext': plaintext,
          'clientPubkey': clientPubkey,
          'agreement': agreement
        });
      }
    } catch (e) {
      AegisLogger.error('NIP04 encrypt error', e);
      return null;
    }
  }
}
