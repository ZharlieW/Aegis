import 'package:aegis/services/nip46_bunker_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Nip46BunkerUrl', () {
    group('buildBunkerUrl', () {
      test('builds bunker URL with relay and remote signer pubkey', () {
        const relayUrl = 'wss://relay.example.com';
        const pubkey =
            '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
        final url = Nip46BunkerUrl.buildBunkerUrl(
          relayUrlForDisplay: relayUrl,
          remoteSignerPubkey: pubkey,
        );
        expect(url, 'bunker://$pubkey?relay=$relayUrl');
      });
    });
  });
}
