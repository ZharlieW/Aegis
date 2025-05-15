import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:pointycastle/export.dart';
import '../event.dart';
import '../nips/nip04/nip04.dart';
import '../nips/nip44/nip44_v2.dart';
import 'nostr_signer.dart';

class LocalNostrSigner implements NostrSigner {

  static final LocalNostrSigner instance = LocalNostrSigner._internal();
  factory LocalNostrSigner() => instance;
  LocalNostrSigner._internal();

  late String privateKey;
  late String publicKey;

  void init(){
    privateKey = Account.sharedInstance.currentPrivkey;
    publicKey = Account.sharedInstance.currentPubkey;
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

  ECDHBasicAgreement getAgreement({String? clientPubkey}) {
    AccountManager instance = AccountManager.sharedInstance;
    final pubkey = clientPubkey != null
        ? instance.applicationMap[clientPubkey]?.value.pubkey
        : null;

    final privateKeyToUse = instance.accountMap[pubkey]?.getPrivkey ?? privateKey;

    return NIP04.getAgreement(privateKeyToUse);
  }

  @override
  Future<String?> nip44Decrypt(String serverPrivate,String ciphertext,String clientPubkey) async {
    try{
      final sealKey = NIP44V2.shareSecret(serverPrivate, clientPubkey);
      return await NIP44V2.decrypt(ciphertext, sealKey);
    }catch(e){
      print('nip44Decrypt:=====>>>$e');
      return null;
    }
  }

  @override
  Future<String?> nip44Encrypt(String serverPrivate,String plaintext,String clientPubkey) async {
    try{
      final conversationKey = NIP44V2.shareSecret(serverPrivate, clientPubkey);
      return await NIP44V2.encrypt(plaintext, conversationKey);
    }catch(e){
      print('nip44Encrypt:=====>>>$e');
      return null;
    }
  }

  @override
  Future<String?> decrypt(clientPubkey, ciphertext) async {
   try{
     var agreement = getAgreement(clientPubkey:clientPubkey);
     return NIP04.decrypt(ciphertext, agreement, clientPubkey);
   }catch(e){
     print('decrypt:=====>>>$e');
     return null;
   }
  }

  @override
  Future<String?> encrypt(clientPubkey, plaintext) async {
    try{
      var agreement = getAgreement(clientPubkey:clientPubkey);
      return NIP04.encrypt(plaintext, agreement, clientPubkey);
    }catch(e){
      print('encrypt:=====>>>$e');
      return null;
    }

  }
}