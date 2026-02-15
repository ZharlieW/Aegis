import 'package:aegis/nostr/event.dart';

abstract class NostrSigner {

  Future<Event?> signEvent(Event event);

  Future<Map?> getRelays();

  Future<String?> encrypt(pubkey, plaintext);

  Future<String?> decrypt(pubkey, ciphertext);

  Future<String?> nip44Encrypt(String serverPrivate,String plaintext,String clientPubkey);

  Future<String?> nip44Decrypt(String serverPrivate,String ciphertext,String clientPubkey);
}
