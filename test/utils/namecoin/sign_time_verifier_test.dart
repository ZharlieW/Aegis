import 'dart:convert';

import 'package:aegis/utils/namecoin/electrumx_client.dart';
import 'package:aegis/utils/namecoin/sign_time_verifier.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeResolver implements NameResolver {
  final Map<String, String> values;
  final Object? throwInstead;
  int calls = 0;
  _FakeResolver({this.values = const {}, this.throwInstead});

  @override
  Future<String> nameShow(String name) async {
    calls++;
    if (throwInstead != null) throw throwInstead!;
    final v = values[name];
    if (v == null) throw NameNotFoundException(name);
    return v;
  }

  @override
  Future<void> close() async {}
}

void main() {
  const signingPk =
      '43185edecb675892824b1a37a57f3e407fbde2eda7201a3829b8cf4ba7c5b4f0';
  const otherPk =
      '0000000000000000000000000000000000000000000000000000000000000001';

  String kind0WithNip05(String nip05, {String? pubkey}) => json.encode({
        'kind': 0,
        'pubkey': pubkey ?? signingPk,
        'content': json.encode({'name': 'm', 'nip05': nip05}),
        'tags': [],
        'created_at': 1700000000,
      });

  test('non-kind-0 events are skipped (notBitClaim)', () async {
    final v = BitSignTimeVerifier(resolverFactory: () => _FakeResolver());
    final ev = json.encode({
      'kind': 1,
      'content': '{"nip05":"_@mstrofnone.bit"}',
    });
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.notBitClaim);
  });

  test('kind:0 with no nip05 is skipped', () async {
    final fake = _FakeResolver();
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = json.encode({
      'kind': 0,
      'content': json.encode({'name': 'm'}),
    });
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.notBitClaim);
    expect(fake.calls, 0, reason: 'must not hit the network');
  });

  test('kind:0 with non-.bit nip05 is skipped', () async {
    final fake = _FakeResolver();
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = kind0WithNip05('alice@example.com');
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.notBitClaim);
    expect(fake.calls, 0);
  });

  test('match: resolved pubkey == signing pubkey', () async {
    final fake = _FakeResolver(values: {
      'd/mstrofnone': '{"nostr":{"pubkey":"$signingPk"}}',
    });
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = kind0WithNip05('_@mstrofnone.bit');
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.match);
    expect(r.resolvedPubkey, signingPk);
  });

  test('mismatch: resolved pubkey differs from signing pubkey', () async {
    final fake = _FakeResolver(values: {
      'd/mstrofnone': '{"nostr":{"pubkey":"$otherPk"}}',
    });
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = kind0WithNip05('_@mstrofnone.bit');
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.mismatch);
    expect(r.resolvedPubkey, otherPk);
    expect(r.signingPubkey, signingPk);
    expect(r.shouldWarn, isTrue);
  });

  test('notFound on NameNotFoundException', () async {
    final fake = _FakeResolver(); // no values → throws NameNotFound
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = kind0WithNip05('_@nopejpg.bit');
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.notFound);
    expect(r.shouldWarn, isTrue);
  });

  test('networkFailure on ElectrumxUnreachable (fail-open semantics)',
      () async {
    final fake = _FakeResolver(
      throwInstead: const ElectrumxUnreachableException('boom'),
    );
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = kind0WithNip05('_@mstrofnone.bit');
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.networkFailure);
    expect(r.shouldWarn, isFalse,
        reason: 'network failures must NEVER block signing.');
  });

  test('record present but missing nostr pubkey → notFound', () async {
    final fake = _FakeResolver(values: {
      'd/mstrofnone': '{"ip":["1.2.3.4"]}',
    });
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = kind0WithNip05('_@mstrofnone.bit');
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.notFound);
  });

  test('case-insensitive match for the signing pubkey', () async {
    final fake = _FakeResolver(values: {
      'd/mstrofnone':
          '{"nostr":{"pubkey":"${signingPk.toUpperCase()}"}}',
    });
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = kind0WithNip05('_@mstrofnone.bit');
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.match);
  });

  test('alice@domain.bit reads names[alice]', () async {
    final fake = _FakeResolver(values: {
      'd/mstrofnone':
          '{"nostr":{"names":{"alice":"$signingPk"}}}',
    });
    final v = BitSignTimeVerifier(resolverFactory: () => fake);
    final ev = kind0WithNip05('alice@mstrofnone.bit');
    final r = await v.verifyEventJson(ev, signingPubkey: signingPk);
    expect(r.verdict, BitClaimVerdict.match);
  });
}
