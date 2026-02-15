import 'package:aegis/nostr/event.dart';
import 'package:aegis/nostr/utils.dart';

/// NIP-40 helpers for expiration timestamps.
class Nip40 {
  static int? getExpiration(Event event) {
    for (final tag in event.tags) {
      if (tag.length >= 2 && tag[0] == 'expiration') {
        return int.tryParse(tag[1]);
      }
    }
    return null;
  }

  static bool expired(Event event) {
    final expiredTime = getExpiration(event);
    return expiredTime != null &&
        expiredTime > 0 &&
        expiredTime < currentUnixTimestampSeconds();
  }
}

