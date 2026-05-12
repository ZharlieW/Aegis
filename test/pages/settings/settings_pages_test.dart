import 'package:aegis/pages/settings/app_logs_page.dart';
import 'package:aegis/services/app_log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(home: child);
  }

  setUp(() {
    AppLogService.instance.clear();
  });

  testWidgets('AppLogsPage shows empty state when no logs exist',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrapWithApp(const AppLogsPage()));
    await tester.pumpAndSettle();

    expect(find.text('No logs yet.'), findsOneWidget);
  });

  testWidgets('AppLogsPage can clear logs through confirm dialog',
      (WidgetTester tester) async {
    AppLogService.instance.add(
      level: AppLogLevel.warning,
      summary: 'Test reconnect failure',
    );

    await tester.pumpWidget(wrapWithApp(const AppLogsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Test reconnect failure'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Clear logs'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(find.text('No logs yet.'), findsOneWidget);
  });

  testWidgets('AppLogsPage combines level and summary filters',
      (WidgetTester tester) async {
    AppLogService.instance.add(
      level: AppLogLevel.warning,
      source: AppLogSource.relay,
      summary: 'Network retry scheduled',
    );
    AppLogService.instance.add(
      level: AppLogLevel.error,
      source: AppLogSource.browser,
      summary: 'Network request failed',
    );
    AppLogService.instance.add(
      level: AppLogLevel.error,
      source: AppLogSource.nip46,
      summary: 'Database write failed',
    );

    await tester.pumpWidget(wrapWithApp(const AppLogsPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'ERROR'));
    await tester.pumpAndSettle();

    expect(find.text('Network request failed'), findsOneWidget);
    expect(find.text('Database write failed'), findsOneWidget);
    expect(find.text('Network retry scheduled'), findsNothing);

    await tester.enterText(find.byType(TextField), 'network');
    await tester.pumpAndSettle();

    expect(find.text('Network request failed'), findsOneWidget);
    expect(find.text('Database write failed'), findsNothing);
    expect(find.text('Network retry scheduled'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'BROWSER'));
    await tester.pumpAndSettle();

    expect(find.text('Network request failed'), findsOneWidget);
    expect(find.text('Database write failed'), findsNothing);
    expect(find.text('Network retry scheduled'), findsNothing);
  });
}
