import 'package:aegis/utils/namecoin/identifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isBitNip05', () {
    test('accepts canonical .bit shapes', () {
      expect(isBitNip05('example.bit'), isTrue);
      expect(isBitNip05('alice@example.bit'), isTrue);
      expect(isBitNip05('_@example.bit'), isTrue);
      expect(isBitNip05('d/example'), isTrue);
      expect(isBitNip05('id/alice'), isTrue);
      expect(isBitNip05('nostr:example.bit'), isTrue);
      expect(isBitNip05('ALICE@EXAMPLE.BIT'), isTrue);
    });

    test('rejects non-.bit identifiers', () {
      expect(isBitNip05(null), isFalse);
      expect(isBitNip05(''), isFalse);
      expect(isBitNip05('alice@example.com'), isFalse);
      expect(isBitNip05('example.com'), isFalse);
      expect(isBitNip05('not.a.bit.com'), isFalse);
    });
  });

  group('parseBitIdentifier', () {
    test('bare .bit normalises to d/<name>, local _', () {
      final p = parseBitIdentifier('mstrofnone.bit')!;
      expect(p.namecoinName, 'd/mstrofnone');
      expect(p.localPart, '_');
      expect(p.isDomain, isTrue);
    });

    test('user@domain.bit splits cleanly', () {
      final p = parseBitIdentifier('alice@mstrofnone.bit')!;
      expect(p.namecoinName, 'd/mstrofnone');
      expect(p.localPart, 'alice');
      expect(p.isDomain, isTrue);
    });

    test('_@domain.bit collapses to local _', () {
      final p = parseBitIdentifier('_@mstrofnone.bit')!;
      expect(p.localPart, '_');
    });

    test('d/<name> and id/<name> are accepted', () {
      final d = parseBitIdentifier('d/example')!;
      expect(d.namecoinName, 'd/example');
      expect(d.isDomain, isTrue);

      final id = parseBitIdentifier('id/alice')!;
      expect(id.namecoinName, 'id/alice');
      expect(id.isDomain, isFalse);
    });

    test('strips a leading nostr: prefix', () {
      final p = parseBitIdentifier('nostr:alice@example.bit')!;
      expect(p.namecoinName, 'd/example');
      expect(p.localPart, 'alice');
    });

    test('rejects multi-label .bit hosts (those are relay URLs)', () {
      // `sub.example.bit` is a relay-host shape, not a NIP-05 shape.
      expect(parseBitIdentifier('sub.example.bit'), isNull);
    });

    test('rejects bare .bit and empty domains', () {
      expect(parseBitIdentifier('.bit'), isNull);
      expect(parseBitIdentifier('@example.bit'), isNotNull); // user="_"
      expect(parseBitIdentifier('alice@.bit'), isNull);
    });
  });
}
