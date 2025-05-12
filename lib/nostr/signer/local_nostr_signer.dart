import 'package:aegis/utils/account.dart';
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
    return Account.sharedInstance.applicationMap[clientPubkey]?.value.pubkey ?? publicKey;
  }

  String? getPrivateKey(String clientPubkey) {
    Account instance = Account.sharedInstance;
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
    Account instance = Account.sharedInstance;
    final pubkey = clientPubkey != null
        ? instance.applicationMap[clientPubkey]?.value.pubkey
        : null;

    final privateKeyToUse = instance.accountMap[pubkey]?.getPrivkey ?? privateKey;

    return NIP04.getAgreement(privateKeyToUse);
  }

  @override
  Future<String?> nip44Decrypt(clientPubkey, ciphertext,{String? shareSecretPubkey}) async {
    Account instance = Account.sharedInstance;
    final pubkey = instance.applicationMap[clientPubkey]?.value.pubkey;
    final privateKeyToUse = instance.accountMap[pubkey]?.getPrivkey ?? privateKey;

    final sealKey = NIP44V2.shareSecret(privateKeyToUse, shareSecretPubkey ?? clientPubkey);
    return await NIP44V2.decrypt(ciphertext, sealKey);
  }

  @override
  Future<String?> nip44Encrypt(clientPubkey, plaintext,{String? shareSecretPubkey}) async {
    Account instance = Account.sharedInstance;
    final pubkey = instance.applicationMap[clientPubkey]?.value.pubkey;
    final privateKeyToUse = instance.accountMap[pubkey]?.getPrivkey ?? privateKey;

    final conversationKey = NIP44V2.shareSecret(privateKeyToUse,shareSecretPubkey ??  clientPubkey);
    return await NIP44V2.encrypt(plaintext, conversationKey);
  }

  @override
  Future<String?> decrypt(clientPubkey, ciphertext) async {
    var agreement = getAgreement(clientPubkey:clientPubkey);
    return NIP04.decrypt(ciphertext, agreement, clientPubkey);
  }

  @override
  Future<String?> encrypt(clientPubkey, plaintext) async {
    var agreement = getAgreement(clientPubkey:clientPubkey);
    return NIP04.encrypt(plaintext, agreement, clientPubkey);
  }
}