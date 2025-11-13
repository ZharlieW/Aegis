import 'dart:convert';

import '../event.dart';

/// NIP-42 helpers for relay authentication.
class Nip42 {
  static Future<Event> encode(
    String challenge,
    String relay,
    String pubkey,
    String privkey,
  ) {
    final event = Event.from(
      kind: 22242,
      tags: [
        ["relay", relay],
        ["challenge", challenge],
      ],
      content: "",
      pubkey: pubkey,
      privkey: privkey,
    );
    return Future.value(event);
  }

  static String authString(Event event) {
    return jsonEncode(["AUTH", event.toJson()]);
  }

  static bool authRequired(String message) {
    return message.startsWith('auth-required: ');
  }

  static bool restricted(String message) {
    return message.startsWith('restricted: ');
  }
}

