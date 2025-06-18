import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../signer/local_nostr_signer.dart';
import '../../string_util.dart';

class NostrRemoteRequest {
  String id;

  String method;

  List<String?> params;

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
        var jsonMap = jsonDecode(plaintext!);
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
