import 'dart:convert';

import 'package:aegis/common/common_tips.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TookKit{
  static String getShortStrByHex64(String hex64){
    // First, the hexadecimal string is converted to an array of bytes
    List<int> bytes = hexStringToBytes(hex64);

    // The byte array is then converted to a short string using Base64 encoding
    String base64String = base64Encode(bytes);
    return base64String;
  }

  static String decodeHex64(String base64String){

    // Use Base64 decoding to restore a short string to an array of bytes
    List<int> decodedBytes = base64Decode(base64String);
    // Finally, the byte array is converted back to a hexadecimal string
    String decodedHex64 = bytesToHexString(decodedBytes);
    print('The decoded hexadecimal string: $decodedHex64');
    return decodedHex64;
  }


  static List<int> hexStringToBytes(String hex) {
    int length = hex.length;
    List<int> bytes = List<int>.generate(length ~/ 2, (index) => 0);

    for (int i = 0; i < length; i += 2) {
      bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }

    return bytes;
  }

  static String bytesToHexString(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  static Future<void> copyKey(BuildContext context, String keyContent) async {
    await Clipboard.setData(
      ClipboardData(
        text: keyContent,
      ),
    );
    CommonTips.success(context, 'copied successfully');
  }

  static String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateFormat formatter = DateFormat('MM Feb HH:mm');
    return formatter.format(date);
  }
}

