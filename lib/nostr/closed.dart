import 'dart:convert';

/// CLOSED message sent by relays when they terminate a subscription.
class Closed {
  Closed(this.subscriptionId, {this.message = ""});

  Closed.deserialize(List<dynamic> input)
      : assert(input.length >= 3),
        subscriptionId = input[1] as String,
        message = input[2] as String;

  String subscriptionId;
  String message;

  String serialize() {
    return jsonEncode(["CLOSED", subscriptionId, message]);
  }
}

