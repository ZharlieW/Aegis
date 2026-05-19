/// Glue between [BitSignTimeVerifier] and the three sign surfaces
/// (NIP-46 server, NIP-07 browser handler, NIP-55 Android intent).
///
/// Why a separate gate?
///   * The verifier is pure logic (testable, no Flutter deps).
///   * The gate owns the side effects: reading the user toggle from
///     [LocalStorage], showing the warning dialog, and producing the
///     final boolean "may we sign this?" answer.
///
/// Fail-open contract: any path that ends without a confirmed
/// mismatch returns `true`. Network errors NEVER block signing.
library;

import 'package:aegis/common/destructive_confirmation_dialog.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/utils/logger.dart';

import 'sign_time_verifier.dart';

/// LocalStorage key. Default-on: a missing key (e.g. fresh install)
/// is treated as enabled.
const String kBitSignTimeVerifyEnabledKey = 'namecoin_bit_sign_verify_enabled';

bool isBitSignTimeVerifyEnabled() {
  try {
    final v = LocalStorage.get(kBitSignTimeVerifyEnabledKey);
    if (v is bool) return v;
    return true; // default-on (missing key, wrong type, etc.)
  } on Object {
    return true;
  }
}

Future<void> setBitSignTimeVerifyEnabled(bool enabled) {
  return LocalStorage.set(kBitSignTimeVerifyEnabledKey, enabled);
}

class BitSignTimeGate {
  final BitSignTimeVerifier _verifier;

  BitSignTimeGate({BitSignTimeVerifier? verifier})
      : _verifier = verifier ?? const BitSignTimeVerifier();

  /// Inspects [eventJson] and decides whether to let the signer
  /// proceed.
  ///
  /// Returns `true` on:
  ///   * feature disabled
  ///   * event isn't a kind:0 with a `.bit` `nip05` claim
  ///   * `.bit` claim resolved and matches the signing key
  ///   * any network/transport failure (fail-open)
  ///   * user clicked "Sign anyway" on the mismatch dialog
  ///
  /// Returns `false` only when there was a definitive mismatch /
  /// missing record AND the user chose to cancel.
  Future<bool> mayProceed({
    required String eventJson,
    required String signingPubkey,
  }) async {
    if (!isBitSignTimeVerifyEnabled()) return true;

    final BitClaimResult result;
    try {
      result = await _verifier.verifyEventJson(
        eventJson,
        signingPubkey: signingPubkey,
      );
    } on Object catch (e) {
      AegisLogger.error('bit-verify: unexpected error (fail-open)', e);
      return true;
    }

    switch (result.verdict) {
      case BitClaimVerdict.notBitClaim:
      case BitClaimVerdict.match:
      case BitClaimVerdict.networkFailure:
        return true;
      case BitClaimVerdict.mismatch:
      case BitClaimVerdict.notFound:
        return await _confirmAnyway(result);
    }
  }

  Future<bool> _confirmAnyway(BitClaimResult result) async {
    final ctx = AegisNavigator.navigatorKey.currentContext;
    if (ctx == null) {
      AegisLogger.info(
          'bit-verify: no UI context — failing open on ${result.verdict}');
      // No way to ask the user; fail-open per the gate's contract.
      return true;
    }
    // English-only on purpose: we deliberately do NOT add l10n keys
    // here because that would require touching ~30 translation files
    // for a feature most users will never see. If maintainers want
    // this localised, the strings below are the only ones to lift.
    final title = result.verdict == BitClaimVerdict.mismatch
        ? '.bit identity does not match'
        : '.bit identity not found';
    final body = _composeBody(result);
    try {
      return await showDestructiveConfirmationDialog(
        context: ctx,
        title: title,
        message: body,
        confirmLabel: 'Sign anyway',
      );
    } on Object catch (e) {
      AegisLogger.error('bit-verify: dialog failed (fail-open)', e);
      return true;
    }
  }

  String _composeBody(BitClaimResult result) {
    final claimed = result.claimed ?? '';
    final signing = result.signingPubkey ?? '?';
    if (result.verdict == BitClaimVerdict.mismatch) {
      final resolved = result.resolvedPubkey ?? '?';
      return 'You are about to sign a profile event that claims the '
          '.bit identity "$claimed".\n\n'
          'Namecoin says that identity belongs to:\n  $resolved\n\n'
          'But you are about to sign with:\n  $signing\n\n'
          'Anyone who looks up "$claimed" will get a different key. '
          'Sign anyway?';
    }
    // notFound
    return 'You are about to sign a profile event that claims the '
        '.bit identity "$claimed", but no matching Namecoin record '
        'was found (the name may be unregistered, expired, or '
        'missing a Nostr pubkey field).\n\n'
        'Signing key: $signing\n\n'
        'Sign anyway?';
  }
}
