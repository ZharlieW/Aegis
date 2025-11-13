import 'dart:convert';

/// OK message returned by relays after sending events.
class OKEvent {
  OKEvent(this.eventId, this.status, this.message);

  OKEvent.deserialize(List<dynamic> input)
      : assert(input.length >= 4),
        eventId = input[1] as String,
        status = input[2] as bool,
        message = input[3] as String;

  String eventId;
  bool status;
  String message;

  String serialize() {
    return jsonEncode(["OK", eventId, status, message]);
  }
}

