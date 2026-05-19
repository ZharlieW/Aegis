/// Reads the `nostr.pubkey` / `nostr.names[<local>]` fields out of a
/// Namecoin domain object's JSON value, per ifa-0001 and the N1
/// (NIP-05 over `.bit`) NIP draft.
///
/// We deliberately do NOT walk the `map` subdomain tree here — for
/// sign-time NIP-05 verification, the only identifier shapes that
/// matter are
///
///   * `_@example.bit`   → `d/example`, local `_`
///   * `alice@example.bit` → `d/example`, local `alice`
///   * `d/example` / `id/example` → root, local `_`
///
/// All of these resolve directly against the registered Namecoin name
/// value, not a subdomain object.
library;

import 'dart:convert';

/// Extracts the 64-hex pubkey that the Namecoin record claims for
/// [localPart] (use `_` for the root / "the name itself").
///
/// Lookup order (first match wins):
///   1. `names[<localPart>]` (per NIP-05 / N1)
///   2. `nostr.names[<localPart>]`
///   3. `nostr.pubkey`        (only if `localPart == '_'`)
///   4. `pubkey`              (only if `localPart == '_'`)
///
/// Returns `null` if the JSON is malformed, no claim is recorded, or
/// the claimed value isn't a 64-hex-character string.
String? extractClaimedPubkey(String rawValueJson, String localPart) {
  final Map<String, dynamic> root;
  try {
    final decoded = json.decode(rawValueJson);
    if (decoded is! Map<String, dynamic>) return null;
    root = decoded;
  } on FormatException {
    return null;
  }

  // 1) Top-level `names[<local>]`.
  final topNames = root['names'];
  if (topNames is Map) {
    final v = topNames[localPart];
    if (v is String && _isHexPubkey(v)) return v.toLowerCase();
  }

  // 2 + 3) `nostr.*` namespace.
  final nostr = root['nostr'];
  if (nostr is Map) {
    final nostrNames = nostr['names'];
    if (nostrNames is Map) {
      final v = nostrNames[localPart];
      if (v is String && _isHexPubkey(v)) return v.toLowerCase();
    }
    if (localPart == '_') {
      final pk = nostr['pubkey'];
      if (pk is String && _isHexPubkey(pk)) return pk.toLowerCase();
    }
  }

  // 4) Bare `pubkey` at the root, root-local only.
  if (localPart == '_') {
    final pk = root['pubkey'];
    if (pk is String && _isHexPubkey(pk)) return pk.toLowerCase();
  }

  return null;
}

bool _isHexPubkey(String s) {
  if (s.length != 64) return false;
  for (final c in s.codeUnits) {
    final isDigit = c >= 0x30 && c <= 0x39;
    final isLower = c >= 0x61 && c <= 0x66;
    final isUpper = c >= 0x41 && c <= 0x46;
    if (!isDigit && !isLower && !isUpper) return false;
  }
  return true;
}
