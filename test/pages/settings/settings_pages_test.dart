import 'package:aegis/pages/settings/app_logs_page.dart';
import 'package:aegis/pages/settings/feedback_page.dart';
import 'package:aegis/services/app_log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _wrapWithApp(Widget child) {
    return MaterialApp(home: child);
  }

  setUp(() {
    AppLogService.instance.clear();
  });

  testWidgets('AppLogsPage shows empty state when no logs exist',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrapWithApp(const AppLogsPage()));
    await tester.pumpAndSettle();

    expect(find.text('No logs yet.'), findsOneWidget);
  });

  testWidgets('AppLogsPage can clear logs through confirm dialog',
      (WidgetTester tester) async {
    AppLogService.instance.add(
      level: AppLogLevel.warning,
      summary: 'Test reconnect failure',
    );

    await tester.pumpWidget(_wrapWithApp(const AppLogsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Test reconnect failure'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Clear logs'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(find.text('No logs yet.'), findsOneWidget);
  });

  testWidgets('Feedback send button enabled only when title and details filled',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrapWithApp(const FeedbackPage()));
    await tester.pumpAndSettle();

    final sendButtonFinder = find.byKey(const Key('feedback_send_button'));
    dynamic sendButton = tester.widget(sendButtonFinder);
    expect(sendButton.onPressed, isNull);

    await tester.enterText(
        find.widgetWithText(TextField, 'Title'), 'Crash on login');
    await tester.pumpAndSettle();
    sendButton = tester.widget(sendButtonFinder);
    expect(sendButton.onPressed, isNull);

    await tester.enterText(
      find.widgetWithText(TextField, 'Details'),
      'App crashes when tapping login button.',
    );
    await tester.pumpAndSettle();
    sendButton = tester.widget(sendButtonFinder);
    expect(sendButton.onPressed, isNotNull);
  });
}
