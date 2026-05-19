/// Parses Namecoin / `.bit` NIP-05 identifiers into the
/// `(namecoinName, localPart, isDomain)` triple used by the
/// sign-time `.bit` verifier.
///
/// Wire-format compatible with the references:
///   * Kotlin: `vitorpamplona/amethyst` `BitNip05Identifier.kt`
///   * Swift:  `nostur-com/Nostur` PR #60
///   * Dart:   `ethicnology/dart-nostr` PR #44 `identifier.dart`
///   * JS:     `nbd-wtf/nostr-tools` PR #533, `hzrd149/nostrudel` PR #352
///
/// Accepted shapes (case-insensitive, optionally `nostr:`-prefixed):
///
///   * `<anything>.bit`
///   * `alice@<anything>.bit`
///   * `d/<name>`
///   * `id/<name>`
library;

class ParsedBitIdentifier {
  /// The Namecoin name to query, e.g. `d/example` or `id/alice`.
  final String namecoinName;

  /// Local-part within the name's value. `_` means "the root" /
  /// "the name itself" per the NIP-05 / `.bit` convention.
  final String localPart;

  /// `true` for `d/` names (domain namespace, expecting a `names`
  /// map); `false` for `id/` names (identity namespace).
  final bool isDomain;

  const ParsedBitIdentifier({
    required this.namecoinName,
    required this.localPart,
    required this.isDomain,
  });
}

/// Cheap front-door check so callers can branch out of the hot path
/// before doing any parsing work.
bool isBitNip05(String? identifier) {
  if (identifier == null || identifier.isEmpty) return false;
  var s = identifier.trim().toLowerCase();
  if (s.startsWith('nostr:')) s = s.substring(6);
  if (s.startsWith('d/') || s.startsWith('id/')) return true;
  return s.endsWith('.bit');
}

/// Parses [raw] into a [ParsedBitIdentifier], or returns `null` if
/// the shape is not a `.bit` identifier.
ParsedBitIdentifier? parseBitIdentifier(String raw) {
  var input = raw.trim();
  if (input.length >= 6 && input.substring(0, 6).toLowerCase() == 'nostr:') {
    input = input.substring(6);
  }
  final lower = input.toLowerCase();

  if (lower.startsWith('d/')) {
    return ParsedBitIdentifier(
      namecoinName: lower,
      localPart: '_',
      isDomain: true,
    );
  }
  if (lower.startsWith('id/')) {
    return ParsedBitIdentifier(
      namecoinName: lower,
      localPart: '_',
      isDomain: false,
    );
  }

  // user@domain.bit
  if (input.contains('@') && lower.endsWith('.bit')) {
    final atIdx = input.indexOf('@');
    final localRaw = input.substring(0, atIdx);
    final local = localRaw.isEmpty ? '_' : localRaw.toLowerCase();
    final domain = input
        .substring(atIdx + 1)
        .toLowerCase()
        .replaceFirst(RegExp(r'\.bit$'), '');
    if (domain.isEmpty) return null;
    return ParsedBitIdentifier(
      namecoinName: 'd/$domain',
      localPart: local,
      isDomain: true,
    );
  }

  // bare.bit (single-label-only — multi-label hosts like
  // `sub.example.bit` are NOT NIP-05 identifiers; they are relay
  // hostnames handled elsewhere)
  if (lower.endsWith('.bit')) {
    final withoutTld = lower.substring(0, lower.length - 4);
    if (withoutTld.isEmpty || withoutTld.contains('.')) return null;
    return ParsedBitIdentifier(
      namecoinName: 'd/$withoutTld',
      localPart: '_',
      isDomain: true,
    );
  }

  return null;
}
