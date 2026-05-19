import 'package:aegis/utils/namecoin/record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const pk = 'abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789';

  test('extractClaimedPubkey reads nostr.pubkey for root local', () {
    const raw = '{"nostr":{"pubkey":"$pk"}}';
    expect(extractClaimedPubkey(raw, '_'), pk);
  });

  test('extractClaimedPubkey reads nostr.names[<local>]', () {
    const raw = '{"nostr":{"names":{"alice":"$pk"}}}';
    expect(extractClaimedPubkey(raw, 'alice'), pk);
  });

  test('top-level names[<local>] is honoured (NIP-05 convention)', () {
    const raw = '{"names":{"alice":"$pk"}}';
    expect(extractClaimedPubkey(raw, 'alice'), pk);
  });

  test('top-level pubkey only counts for root local', () {
    const raw = '{"pubkey":"$pk"}';
    expect(extractClaimedPubkey(raw, '_'), pk);
    expect(extractClaimedPubkey(raw, 'alice'), isNull);
  });

  test('non-64-hex values are rejected', () {
    expect(extractClaimedPubkey('{"nostr":{"pubkey":"not-hex"}}', '_'),
        isNull);
    expect(extractClaimedPubkey('{"nostr":{"pubkey":"$pk-"}}', '_'),
        isNull);
  });

  test('malformed JSON returns null', () {
    expect(extractClaimedPubkey('not json', '_'), isNull);
    expect(extractClaimedPubkey('[]', '_'), isNull);
  });

  test('case-insensitive: claimed pubkey is normalised to lowercase', () {
    final upper = pk.toUpperCase();
    final raw = '{"nostr":{"pubkey":"$upper"}}';
    expect(extractClaimedPubkey(raw, '_'), pk);
  });
}
