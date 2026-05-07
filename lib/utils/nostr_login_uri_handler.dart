import 'package:aegis/nostr/nips/nip46/nostr_remote_signer_info.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/remote_relay_nip46_session.dart';

/// Outcome of handling a pasted or scanned Nostr login URI (Nostr Connect, Aegis, etc.).
enum NostrLoginUriOutcomeKind {
  success,
  invalid,
  unsupported,
  bunkerNotApplicable,
  notLoggedIn,
  error,
}

class NostrLoginUriOutcome {
  const NostrLoginUriOutcome._(this.kind, [this.debugDetail]);

  final NostrLoginUriOutcomeKind kind;

  /// Optional detail for logging or generic error display.
  final String? debugDetail;

  static const NostrLoginUriOutcome success =
      NostrLoginUriOutcome._(NostrLoginUriOutcomeKind.success);

  static NostrLoginUriOutcome invalid([String? detail]) =>
      NostrLoginUriOutcome._(NostrLoginUriOutcomeKind.invalid, detail);

  static NostrLoginUriOutcome unsupported([String? detail]) =>
      NostrLoginUriOutcome._(NostrLoginUriOutcomeKind.unsupported, detail);

  static const NostrLoginUriOutcome bunkerNotApplicable =
      NostrLoginUriOutcome._(NostrLoginUriOutcomeKind.bunkerNotApplicable);

  static const NostrLoginUriOutcome notLoggedIn =
      NostrLoginUriOutcome._(NostrLoginUriOutcomeKind.notLoggedIn);

  static NostrLoginUriOutcome error([String? detail]) =>
      NostrLoginUriOutcome._(NostrLoginUriOutcomeKind.error, detail);
}

/// Shared logic for QR scan and paste flows: same entry as [ScanQrLoginPage].
class NostrLoginUriHandler {
  NostrLoginUriHandler._();

  /// Parse and dispatch [raw] the same way as a successful QR scan.
  static Future<NostrLoginUriOutcome> handle(String raw) async {
    final url = raw.trim();
    if (url.isEmpty) {
      return NostrLoginUriOutcome.invalid('empty');
    }

    late final Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      AegisLogger.error('NostrLoginUriHandler: parse failed', e);
      return NostrLoginUriOutcome.invalid(e.toString());
    }

    final scheme = uri.scheme.toLowerCase();

    if (scheme == 'bunker') {
      if (NostrRemoteSignerInfo.isBunkerUrl(url) &&
          NostrRemoteSignerInfo.parseBunkerUrl(url) != null) {
        return NostrLoginUriOutcome.bunkerNotApplicable;
      }
      return NostrLoginUriOutcome.invalid('bad_bunker');
    }

    if (scheme == 'aegis' || scheme == 'nostrsigner') {
      try {
        await LaunchSchemeUtils.handleSchemeData(url);
        return NostrLoginUriOutcome.success;
      } catch (e) {
        AegisLogger.error('NostrLoginUriHandler: handleSchemeData failed', e);
        return NostrLoginUriOutcome.error(e.toString());
      }
    }

    if (scheme == 'nostrconnect') {
      final started = await RemoteRelayNip46Session.startFromNostrConnectUri(url);
      if (started) {
        return NostrLoginUriOutcome.success;
      }
      final reason = RemoteRelayNip46Session.lastFailureReason;
      if (reason == 'not_logged_in') {
        return NostrLoginUriOutcome.notLoggedIn;
      }
      return NostrLoginUriOutcome.error(reason);
    }

    return NostrLoginUriOutcome.unsupported(scheme);
  }
}
