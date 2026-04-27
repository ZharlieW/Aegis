import 'package:aegis/utils/nip46_crypto_request_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Nip46CryptoRequestValidator', () {
    test('nip04 params require two non-null values', () {
      expect(
        Nip46CryptoRequestValidator.hasValidNip04Params(const ['pubkey', 'text']),
        isTrue,
      );
      expect(
        Nip46CryptoRequestValidator.hasValidNip04Params(const ['pubkey']),
        isFalse,
      );
      expect(
        Nip46CryptoRequestValidator.hasValidNip04Params(const ['pubkey', null]),
        isFalse,
      );
      expect(
        Nip46CryptoRequestValidator.hasValidNip04Params(const [null, 'text']),
        isFalse,
      );
    });

    test('nip44 params require non-empty server key and two strings', () {
      expect(
        Nip46CryptoRequestValidator.hasValidNip44Params(
          serverPrivate: 'privkey',
          params: const ['peerPubkey', 'cipherText'],
        ),
        isTrue,
      );
      expect(
        Nip46CryptoRequestValidator.hasValidNip44Params(
          serverPrivate: '',
          params: const ['peerPubkey', 'cipherText'],
        ),
        isFalse,
      );
      expect(
        Nip46CryptoRequestValidator.hasValidNip44Params(
          serverPrivate: 'privkey',
          params: const ['peerPubkey'],
        ),
        isFalse,
      );
      expect(
        Nip46CryptoRequestValidator.hasValidNip44Params(
          serverPrivate: 'privkey',
          params: const ['peerPubkey', 1],
        ),
        isFalse,
      );
    });
  });
}
