import 'package:aegis/utils/browser_history_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('add stores recent urls as deduped LRU list', () async {
    await BrowserHistoryStore.add('https://a.example/path');
    await BrowserHistoryStore.add('https://b.example/');
    await BrowserHistoryStore.add('https://a.example/path');

    expect(await BrowserHistoryStore.load(), [
      'https://a.example/path',
      'https://b.example/',
    ]);
  });

  test('add ignores non-web urls and caps history', () async {
    await BrowserHistoryStore.add('nostr:abc');
    for (var i = 0; i < BrowserHistoryStore.maxEntries + 2; i++) {
      await BrowserHistoryStore.add('https://$i.example/');
    }

    final history = await BrowserHistoryStore.load();
    expect(history.length, BrowserHistoryStore.maxEntries);
    expect(history.first,
        'https://${BrowserHistoryStore.maxEntries + 1}.example/');
    expect(history.last, 'https://2.example/');
  });

  test('remove and clear update only saved history', () async {
    await BrowserHistoryStore.add('https://a.example/');
    await BrowserHistoryStore.add('https://b.example/');

    await BrowserHistoryStore.remove('https://a.example/');
    expect(await BrowserHistoryStore.load(), ['https://b.example/']);

    await BrowserHistoryStore.clear();
    expect(await BrowserHistoryStore.load(), isEmpty);
  });
}
