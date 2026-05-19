/// Sign-time `.bit` NIP-05 verifier.
///
/// NIP-05 verification *normally* happens in the clients that
/// consume events. The signer, however, sees a kind:0 metadata event
/// BEFORE it ships — which is the perfect choke point to catch a
/// user accidentally publishing a kind:0 with the wrong key under a
/// `.bit` claim. Most reader clients won't surface a mismatch until
/// later (if at all); the signer can warn before the event is even
/// broadcast.
///
/// This module is intentionally narrow: it only inspects kind:0
/// events whose parsed `content` carries a `nip05` field ending in
/// `.bit`. All other events pass through unchanged. The verifier
/// itself is also fail-open: any network or parse error returns a
/// "network failure" verdict that the caller MUST treat as
/// non-blocking — we never block signing on Namecoin reachability.
library;

import 'dart:convert';

import 'package:aegis/utils/logger.dart';

import 'electrumx_client.dart';
import 'identifier.dart';
import 'record.dart';

/// Outcome of a sign-time `.bit` check.
enum BitClaimVerdict {
  /// Event has no `.bit` NIP-05 claim — nothing to do. Sign as normal.
  notBitClaim,

  /// Resolved Namecoin record claims the same pubkey we're about to
  /// sign with. Safe to sign; UI MAY show a positive indicator.
  match,

  /// Resolved Namecoin record claims a DIFFERENT pubkey. The signer
  /// SHOULD warn the user before letting the event through.
  mismatch,

  /// Network or parse failure (servers unreachable, malformed
  /// record, etc.). Fail-open — caller MUST allow signing to proceed.
  networkFailure,

  /// Name doesn't exist on the chain, or is expired. Treated like a
  /// soft mismatch: the claim is false on its face, so we warn.
  notFound,
}

/// Reason text bundled with a verdict for UI/logging.
class BitClaimResult {
  final BitClaimVerdict verdict;

  /// `_@example.bit` / `alice@example.bit` / `d/example` — the raw
  /// NIP-05 value as it appeared in the event. `null` when [verdict]
  /// is [BitClaimVerdict.notBitClaim] or `nip05` was missing.
  final String? claimed;

  /// The 64-hex pubkey the Namecoin record points at, if we got one.
  final String? resolvedPubkey;

  /// The 64-hex pubkey the event is about to be signed with.
  final String? signingPubkey;

  /// Human-readable explanation (English; localised at the call site).
  final String? message;

  const BitClaimResult({
    required this.verdict,
    this.claimed,
    this.resolvedPubkey,
    this.signingPubkey,
    this.message,
  });

  bool get shouldWarn =>
      verdict == BitClaimVerdict.mismatch ||
      verdict == BitClaimVerdict.notFound;
}

/// Sign-time verification gate. Stateless; safe to call from any of
/// the sign surfaces (NIP-46, NIP-07, NIP-55).
class BitSignTimeVerifier {
  /// Resolver used to perform `name_show`. Test code can inject a
  /// fake by passing a custom [NameResolver]; production code uses
  /// [ElectrumxClient] with [defaultElectrumxServers].
  final NameResolver Function() resolverFactory;

  const BitSignTimeVerifier({this.resolverFactory = _defaultResolver});

  /// Inspects [eventJson] (the JSON string the signer is about to
  /// hand off to its low-level signing function) and returns a
  /// [BitClaimResult].
  ///
  /// Only kind:0 metadata events are inspected. Any failure path
  /// (parse error, unknown shape, network unreachable) resolves to
  /// either [BitClaimVerdict.notBitClaim] (when there's nothing to
  /// check) or [BitClaimVerdict.networkFailure] (when we tried and
  /// couldn't reach the chain). Both are caller-non-blocking.
  Future<BitClaimResult> verifyEventJson(
    String eventJson, {
    required String signingPubkey,
  }) async {
    Map<String, dynamic>? event;
    try {
      final decoded = json.decode(eventJson);
      if (decoded is Map<String, dynamic>) event = decoded;
    } on FormatException {
      return const BitClaimResult(verdict: BitClaimVerdict.notBitClaim);
    }
    if (event == null) {
      return const BitClaimResult(verdict: BitClaimVerdict.notBitClaim);
    }

    final kind = event['kind'];
    if (kind is! int || kind != 0) {
      return const BitClaimResult(verdict: BitClaimVerdict.notBitClaim);
    }

    final content = event['content'];
    if (content is! String || content.isEmpty) {
      return const BitClaimResult(verdict: BitClaimVerdict.notBitClaim);
    }

    Map<String, dynamic>? metadata;
    try {
      final decoded = json.decode(content);
      if (decoded is Map<String, dynamic>) metadata = decoded;
    } on FormatException {
      return const BitClaimResult(verdict: BitClaimVerdict.notBitClaim);
    }
    if (metadata == null) {
      return const BitClaimResult(verdict: BitClaimVerdict.notBitClaim);
    }

    final nip05 = metadata['nip05'];
    if (nip05 is! String || nip05.isEmpty) {
      return const BitClaimResult(verdict: BitClaimVerdict.notBitClaim);
    }
    if (!isBitNip05(nip05)) {
      return const BitClaimResult(verdict: BitClaimVerdict.notBitClaim);
    }

    final parsed = parseBitIdentifier(nip05);
    if (parsed == null) {
      return BitClaimResult(
        verdict: BitClaimVerdict.notBitClaim,
        claimed: nip05,
      );
    }

    final NameResolver resolver = resolverFactory();
    String rawValue;
    try {
      rawValue = await resolver.nameShow(parsed.namecoinName);
    } on NameNotFoundException catch (e) {
      AegisLogger.info('bit-verify: name not found: ${e.name}');
      return BitClaimResult(
        verdict: BitClaimVerdict.notFound,
        claimed: nip05,
        signingPubkey: signingPubkey,
        message: 'Namecoin name ${parsed.namecoinName} is not registered.',
      );
    } on NameExpiredException catch (e) {
      AegisLogger.info('bit-verify: name expired: ${e.name}');
      return BitClaimResult(
        verdict: BitClaimVerdict.notFound,
        claimed: nip05,
        signingPubkey: signingPubkey,
        message: 'Namecoin name ${parsed.namecoinName} has expired.',
      );
    } on Object catch (e) {
      AegisLogger.info('bit-verify: network failure: $e');
      return BitClaimResult(
        verdict: BitClaimVerdict.networkFailure,
        claimed: nip05,
        signingPubkey: signingPubkey,
        message: 'Could not reach Namecoin: $e',
      );
    } finally {
      try {
        await resolver.close();
      } on Object {/* ignore */}
    }

    final claimedPubkey = extractClaimedPubkey(rawValue, parsed.localPart);
    if (claimedPubkey == null) {
      return BitClaimResult(
        verdict: BitClaimVerdict.notFound,
        claimed: nip05,
        signingPubkey: signingPubkey,
        message:
            'Namecoin record for ${parsed.namecoinName} does not carry a Nostr pubkey claim for "${parsed.localPart}".',
      );
    }

    final signingLower = signingPubkey.toLowerCase();
    if (claimedPubkey == signingLower) {
      return BitClaimResult(
        verdict: BitClaimVerdict.match,
        claimed: nip05,
        resolvedPubkey: claimedPubkey,
        signingPubkey: signingLower,
      );
    }
    return BitClaimResult(
      verdict: BitClaimVerdict.mismatch,
      claimed: nip05,
      resolvedPubkey: claimedPubkey,
      signingPubkey: signingLower,
      message:
          'Namecoin record for $nip05 points at $claimedPubkey but the event is about to be signed with $signingLower.',
    );
  }
}

NameResolver _defaultResolver() => ElectrumxClient();
