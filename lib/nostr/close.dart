import 'dart:convert';

/// CLOSE message to terminate a subscription.
class Close {
  Close(this.subscriptionId);

  Close.deserialize(List<dynamic> input)
      : assert(input.length >= 2),
        subscriptionId = input[1] as String;

  String subscriptionId;

  String serialize() {
    return jsonEncode(["CLOSE", subscriptionId]);
  }
}

