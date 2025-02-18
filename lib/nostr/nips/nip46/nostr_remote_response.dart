import 'dart:convert';
import '../../signer/local_nostr_signer.dart';
import '../../signer/nostr_signer.dart';
import '../../string_util.dart';
import '../nip04/nip04.dart';

class NostrRemoteResponse {
  String id;

  String result;

  String? error;

  NostrRemoteResponse(this.id, this.result, {this.error});

  static Future<NostrRemoteResponse?> decrypt(
      String ciphertext, NostrSigner signer, String pubkey, LocalNostrSigner localNostrSigner) async {
    String? plaintext;
    bool isNip04 = ciphertext.contains('?iv=');
    if(isNip04){
      plaintext = NIP04.decrypt(ciphertext, localNostrSigner.getAgreement(), pubkey);
    }else{
      plaintext = await signer.nip44Decrypt(pubkey, ciphertext);
    }
    if (StringUtil.isNotBlank(plaintext)) {

      var jsonMap = plaintext is String ? jsonDecode(plaintext) : plaintext;
      var id = jsonMap["id"];
      var result =  jsonMap["result"];

      if (id != null && id is String && result != null && result is String) {
        return NostrRemoteResponse(id, result, error: '');
      }
    }

    return null;
  }

  Future<String?> encrypt(NostrSigner signer, String pubkey) async {
    Map<String, dynamic> jsonMap = {};
    jsonMap["id"] = id;
    jsonMap["result"] = result;
    if (StringUtil.isNotBlank(error)) {
      jsonMap["error"] = error;
    }

    var jsonStr = jsonEncode(jsonMap);
    return await signer.nip44Encrypt(pubkey, jsonStr);
  }

  @override
  String toString() {
    return "$id $result $error";
  }
}
