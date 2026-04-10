class Nip46Error {
  static String invalidParams(String method) {
    switch (method) {
      case 'nip04_encrypt':
        return 'invalid params: expected [peer_pubkey, plaintext]';
      case 'nip04_decrypt':
        return 'invalid params: expected [peer_pubkey, ciphertext]';
      case 'nip44_encrypt':
        return 'invalid params: expected [peer_pubkey, plaintext]';
      case 'nip44_decrypt':
        return 'invalid params: expected [peer_pubkey, ciphertext]';
      case 'sign_event':
        return 'invalid params: expected [event_json]';
      default:
        return 'invalid params';
    }
  }
}

