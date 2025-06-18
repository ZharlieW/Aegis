import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../signer/local_nostr_signer.dart';
import '../../string_util.dart';
import 'package:aegis/utils/thread_pool_manager.dart';

class NostrRemoteRequest {
  String id;

  String method;

  List<String?> params;

  // Thread pool for JSON parsing (lazy initialization)
  static final ThreadPoolManager _threadPool = ThreadPoolManager();

  NostrRemoteRequest(this.method, this.params) : id = StringUtil.rndNameStr(12);


  static Future<NostrRemoteRequest?> decrypt(
      String ciphertext, String clientPubkey,LocalNostrSigner localNostrSigner,String serverPrivate) async {
    try {
      String? plaintext;
      bool isNip04 = ciphertext.contains('?iv=');
      if(isNip04){
        plaintext = await localNostrSigner.decrypt(clientPubkey, ciphertext);
      }else{
        plaintext = await localNostrSigner.nip44Decrypt(serverPrivate,ciphertext,clientPubkey);
      }
      if (StringUtil.isNotBlank(plaintext)) {
        // Ensure the thread pool is ready
        if (!_threadPool.isInitialized) {
          try {
            await _threadPool.initialize();
          } catch (e) {
            // If initialization fails, fall back to synchronous parsing
          }
        }

        Map<String, dynamic> jsonMap;
        if (_threadPool.isInitialized) {
          jsonMap = await _threadPool.runOtherTask(() async => jsonDecode(plaintext!));
        } else {
          jsonMap = jsonDecode(plaintext!);
        }
        var id = jsonMap["id"];
        var method = jsonMap["method"];
        var _params = jsonMap["params"];
        List<String?> params = [];
        if (_params != null && _params is List) {
          for (var param in _params) {
            params.add(param);
          }
        }

        if (id != null && id is String && method != null && method is String) {
          var request = NostrRemoteRequest(method, params);
          request.id = id;
          return request;
        }
      }else{
        return null;
      }
    }
    catch (e) {
      print("NostrRemoteRequest decrypt error===$e");
    }

    return null;
  }
}
