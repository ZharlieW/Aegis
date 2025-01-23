import 'dart:convert';
import 'dart:io';

class AegisHttpServerClient {
  static final AegisHttpServerClient sharedInstance = AegisHttpServerClient._internal();

  final HttpClient _client;
  AegisHttpServerClient._internal() : _client = HttpClient();

  factory AegisHttpServerClient() {
    return sharedInstance;
  }

  Future<void> sendGetRequest(String url) async {
    try {
      final request = await _client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        print('Received response: $responseBody');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to send GET request: $e');
    }
  }

  Future<void> sendPostRequest(String url, Map<String, String> data) async {
    try {
      final request = await _client.postUrl(Uri.parse(url));
      print('===url==$request');

      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.write(data.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&'));
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        print('Received response: $responseBody');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to send POST request: $e');
    }
  }
}
