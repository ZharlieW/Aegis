import 'dart:convert';

import 'filter.dart';

/// REQ message carrying requested filters from clients to relays.
class Request {
  Request(this.subscriptionId, this.filters);

  Request.deserialize(List<dynamic> input) {
    assert(input.length >= 3);
    subscriptionId = input[1] as String;
    filters = [];
    for (var i = 2; i < input.length; i++) {
      filters.add(Filter.fromJson(input[i] as Map<String, dynamic>));
    }
  }

  late String subscriptionId;
  late List<Filter> filters;

  String serialize() {
    final filtersJson =
        jsonEncode(filters.map((filter) => filter.toJson()).toList());
    final header = jsonEncode(["REQ", subscriptionId]);

    return '${header.substring(0, header.length - 1)},${filtersJson.substring(1, filtersJson.length)}';
  }
}

