import 'dart:typed_data';

import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/thread_pool_manager.dart';
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
  final Map<String, ECDHBasicAgreement> _agreementCache = {};
  final Map<String, Uint8List> _nip44KeyCache = {};
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
      print('ThreadPool init fail: $e');
    }
  }

  String? getPublicKey(String clientPubkey) {
    return AccountManager.sharedInstance.applicationMap[clientPubkey]?.value.pubkey ?? publicKey;
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
    return _agreementCache.putIfAbsent(key, () {
      return NIP04.getAgreement(priv);
    });
  }

  @override
  Future<String?> nip44Decrypt(
      String serverPrivate, String ciphertext, String clientPubkey) async {
    try {
      final cacheKey = '$serverPrivate|$clientPubkey';
      final convKey = _nip44KeyCache.putIfAbsent(cacheKey, () {
        return NIP44V2.shareSecret(serverPrivate, clientPubkey);
      });
      
      try {
        final nativeResult = await _nativeChannel.nativeDecrypt(ciphertext, convKey);
        if (nativeResult != null) {
          print('Native NIP44 decryption successful');
          return nativeResult;
        }
      } catch (e) {
        print('Native NIP44 decryption failed, fallback to Flutter: $e');
      }
      
      await _ensureThreadPoolInitialized();
      
      try {
        return await _threadPool.runAlgorithmTask(() async {
          return await AegisIsolate.nip44DecryptIsolate({
            'ciphertext':ciphertext,
            'convKey':convKey,
          });
        });
      } catch (e) {
        print('Thread pool decryption failed. Use the main thread: $e');
        return await AegisIsolate.nip44DecryptIsolate({
          'ciphertext': ciphertext,
          'convKey': convKey,
        });

      }
    } catch (e) {
      print('nip44Decrypt error: $e');
      return null;
    }
  }

  @override
  Future<String?> nip44Encrypt(
      String serverPrivate, String plaintext, String clientPubkey) async {
    try {
      final cacheKey = '$serverPrivate|$clientPubkey';
      final convKey = _nip44KeyCache.putIfAbsent(cacheKey, () {
        return NIP44V2.shareSecret(serverPrivate, clientPubkey);
      });
      
      try {
        final nativeResult = await _nativeChannel.nativeEncrypt(plaintext, convKey);
        if (nativeResult != null) {
          print('Native NIP44 encryption successful');
          return nativeResult;
        }
      } catch (e) {
        print('Native NIP44 encryption failed, fallback to Flutter: $e');
      }
      
      await _ensureThreadPoolInitialized();
      
      try {
        return await _threadPool.runAlgorithmTask(() async {
          return await AegisIsolate.nip44EncryptIsolate(
              {
                'plaintext':plaintext,
                'convKey':convKey,
              }
          );

        });
      } catch (e) {
        print('Thread pool encryption failed. Use the main thread: $e');
        return await AegisIsolate.nip44EncryptIsolate(
            {
              'plaintext':plaintext,
              'convKey':convKey,
            }
        );

      }
    } catch (e) {
      print('nip44Encrypt error: $e');
      return null;
    }
  }

  @override
  Future<String?> decrypt(clientPubkey, ciphertext) async {
   try{
     final serverPrivate = getPrivateKey(clientPubkey)!;
     
     try {
       final nativeResult = await _nip04NativeChannel.nativeNip04Decrypt(
         ciphertext, 
         serverPrivate, 
         clientPubkey
       );
       if (nativeResult != null) {
         print('Native NIP04 decryption successful');
         return nativeResult;
       }
     } catch (e) {
       print('Native NIP04 decryption failed, fallback to Flutter: $e');
     }
     
     var agreement = getAgreement(clientPubkey);

     await _ensureThreadPoolInitialized();
     
     try {
       return await _threadPool.runAlgorithmTask(() async {
                 return await AegisIsolate.nip04DecryptIsolate(
             {
               'ciphertext':ciphertext,
               'clientPubkey':clientPubkey,
               'agreement':agreement
             }
         );
       });
     } catch (e) {
       print('Thread pool decryption failed. Use the main thread: $e');
       return await AegisIsolate.nip04DecryptIsolate(
           {
             'ciphertext':ciphertext,
             'clientPubkey':clientPubkey,
             'agreement':agreement
           }
       );

     }

   }catch(e){
     print('decrypt:=====>>>$e');
     return null;
   }
  }

  @override
  Future<String?> encrypt(clientPubkey, plaintext) async {
    try{
      final serverPrivate = getPrivateKey(clientPubkey)!;
      
      try {
        final nativeResult = await _nip04NativeChannel.nativeNip04Encrypt(
          plaintext, 
          serverPrivate, 
          clientPubkey
        );
        if (nativeResult != null) {
          print('Native NIP04 encryption successful');
          return nativeResult;
        }
      } catch (e) {
        print('Native NIP04 encryption failed, fallback to Flutter: $e');
      }
      
      var agreement = getAgreement(clientPubkey);
      
      await _ensureThreadPoolInitialized();
      
      try {
        return await _threadPool.runAlgorithmTask(() async {
          return AegisIsolate.nip04EncryptIsolate(
              {
                'plaintext':plaintext,
                'clientPubkey':clientPubkey,
                'agreement':agreement
              }
          );

        });
      } catch (e) {
        print('Thread pool encryption failed. Use the main thread: $e');
        return await AegisIsolate.nip04EncryptIsolate(
            {
              'plaintext':plaintext,
              'clientPubkey':clientPubkey,
              'agreement':agreement
            }
        );
      }

    }catch(e){
      print('encrypt:=====>>>$e');
      return null;
    }
  }
}