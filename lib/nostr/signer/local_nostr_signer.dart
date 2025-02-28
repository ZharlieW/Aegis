import 'package:aegis/utils/account.dart';
import 'package:pointycastle/export.dart';
import '../event.dart';
import '../keychain.dart';
import '../nips/nip04/nip04.dart';
import '../nips/nip19/nip19.dart';
import '../nips/nip44/nip44_v2.dart';
import 'nostr_signer.dart';

class LocalNostrSigner implements NostrSigner {

  static final LocalNostrSigner instance = LocalNostrSigner._internal();
  factory LocalNostrSigner() => instance;
  LocalNostrSigner._internal();

  late String privateKey;
  late String publicKey;
  ECDHBasicAgreement? _agreement;

  void init(){
    privateKey = Account.sharedInstance.currentPrivkey;

    publicKey = Account.sharedInstance.currentPubkey;
  }


  @override
  Future<String?> getPublicKey() async {
    return publicKey;
  }

  Future<String?> getPrivateKey() async {
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

  ECDHBasicAgreement getAgreement() {
    _agreement ??= NIP04.getAgreement(privateKey);
    return _agreement!;
  }

  @override
  Future<String?> nip44Decrypt(pubkey, ciphertext) async {
    var sealKey = NIP44V2.shareSecret(privateKey, pubkey);
    return await NIP44V2.decrypt(ciphertext, sealKey);
  }

  @override
  Future<String?> nip44Encrypt(pubkey, plaintext) async {
    var conversationKey = NIP44V2.shareSecret(privateKey, pubkey);
    return await NIP44V2.encrypt(plaintext, conversationKey);
  }

  @override
  Future<String?> decrypt(pubkey, ciphertext) async {
    var agreement = getAgreement();
    return NIP04.decrypt(ciphertext, agreement, pubkey);
  }

  @override
  Future<String?> encrypt(pubkey, plaintext) async {
    var agreement = getAgreement();
    return NIP04.encrypt(plaintext, agreement, pubkey);
  }
}