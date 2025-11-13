import 'dart:convert';

import 'auth.dart';
import 'close.dart';
import 'closed.dart';
import 'event.dart';
import 'ok_event.dart';
import 'request.dart';

/// General purpose wrapper for decoded Nostr relay messages.
class Message {
  Message();

  late String type;
  late dynamic message;

  static Future<Message> deserialize(String payload) async {
    final Message result = Message();
    final dynamic data = jsonDecode(payload);

    const supportedMessages = <String>{
      "EVENT",
      "REQ",
      "CLOSE",
      "CLOSED",
      "NOTICE",
      "NOTIFY",
      "EOSE",
      "OK",
      "AUTH",
    };

    assert(
      data is List &&
          data.isNotEmpty &&
          supportedMessages.contains(data[0]),
      "Unsupported payload (or NIP) : $data",
    );

    result.type = data[0] as String;
    switch (result.type) {
      case "OK":
        result.message = OKEvent.deserialize(data as List<dynamic>);
        break;
      case "EVENT":
        result.message =
            await Event.deserialize(data as List<dynamic>, verify: false);
        break;
      case "REQ":
        result.message = Request.deserialize(data as List<dynamic>);
        break;
      case "CLOSE":
        result.message = Close.deserialize(data as List<dynamic>);
        break;
      case "CLOSED":
        result.message = Closed.deserialize(data as List<dynamic>);
        break;
      case "AUTH":
        result.message = Auth.deserialize(data as List<dynamic>);
        break;
      default:
        result.message = jsonEncode(
          (data as List<dynamic>).sublist(1),
        );
        break;
    }

    return result;
  }
}

