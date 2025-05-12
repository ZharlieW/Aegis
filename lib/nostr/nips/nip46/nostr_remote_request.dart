import 'dart:convert';

import 'package:aegis/db/userDB_isar.dart';
import 'package:aegis/utils/account.dart';

import '../../signer/local_nostr_signer.dart';
import '../../signer/nostr_signer.dart';
import '../../string_util.dart';
import '../nip04/nip04.dart';

class NostrRemoteRequest {
  String id;

  String method;

  List<String?> params;

  NostrRemoteRequest(this.method, this.params) : id = StringUtil.rndNameStr(12);

  Future<String?> encrypt(NostrSigner signer, String pubkey) async {
    Map<String, dynamic> jsonMap = {};
    jsonMap["id"] = id;
    jsonMap["method"] = method;
    jsonMap["params"] = params;

    var jsonStr = jsonEncode(jsonMap);
    return await signer.nip44Encrypt(pubkey, jsonStr);
  }

  static Future<NostrRemoteRequest?> decrypt(
      String ciphertext, String pubkey,LocalNostrSigner localNostrSigner) async {
    try {
      String? plaintext;
      bool isNip04 = ciphertext.contains('?iv=');
      if(isNip04){
        plaintext = NIP04.decrypt(ciphertext, localNostrSigner.getAgreement(clientPubkey: pubkey), pubkey);
      }else{
        plaintext = await localNostrSigner.nip44Decrypt(pubkey, ciphertext);
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
      }
    }
    catch (e) {
      print("NostrRemoteRequest decrypt error===$e");
    }

    return null;
  }
}
