import 'package:aegis/utils/tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ToolKit', () {
    group('hexStringToBytes', () {
      test('converts hex string to bytes', () {
        expect(ToolKit.hexStringToBytes(''), isEmpty);
        expect(ToolKit.hexStringToBytes('00'), [0]);
        expect(ToolKit.hexStringToBytes('ff'), [255]);
        expect(ToolKit.hexStringToBytes('0102'), [1, 2]);
        expect(ToolKit.hexStringToBytes('deadbeef'), [222, 173, 190, 239]);
      });
    });

    group('bytesToHexString', () {
      test('converts bytes to hex string', () {
        expect(ToolKit.bytesToHexString([]), '');
        expect(ToolKit.bytesToHexString([0]), '00');
        expect(ToolKit.bytesToHexString([255]), 'ff');
        expect(ToolKit.bytesToHexString([1, 2]), '0102');
      });

      test('round-trip with hexStringToBytes', () {
        const hex = 'deadbeef0123456789abcdef';
        expect(
          ToolKit.bytesToHexString(ToolKit.hexStringToBytes(hex)),
          hex,
        );
      });
    });

    group('getShortStrByHex64 / decodeHex64', () {
      test('round-trip for hex64', () {
        const hex64 =
            '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
        final short = ToolKit.getShortStrByHex64(hex64);
        expect(short, isNotEmpty);
        expect(ToolKit.decodeHex64(short), hex64);
      });
    });

    group('formatTimestamp', () {
      test('formats milliseconds since epoch', () {
        // 1 Jan 2024 12:00:00 UTC = 1704110400000 ms (approx)
        const ts = 1704110400000;
        final s = ToolKit.formatTimestamp(ts);
        expect(s, isNotEmpty);
        expect(s.contains('Jan') || s.contains('12') || s.contains('00'), true);
      });
    });
  });
}
