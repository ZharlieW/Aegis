import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/pages/request/batch_request_permission.dart';
import 'package:aegis/utils/permission_approval_batcher_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<BatchPermissionGroupView> initialGroups() {
    return const [
      BatchPermissionGroupView(
        methodKey: 'sign_event',
        description: 'Sign event',
        count: 2,
        selected: true,
        alwaysAllow: true,
        rememberTtl: RememberChoiceTtl.thirtyMinutes,
      ),
      BatchPermissionGroupView(
        methodKey: 'nip04_encrypt',
        description: 'NIP-04 Encrypt',
        count: 1,
        selected: true,
        alwaysAllow: false,
        rememberTtl: RememberChoiceTtl.fiveMinutes,
      ),
    ];
  }

  Widget buildPage({
    required ValueNotifier<List<BatchPermissionGroupView>> groupsNotifier,
    required void Function(String methodKey, bool selected) onSetSelected,
    required void Function(bool selected) onSetAllSelected,
    required void Function(String methodKey, bool alwaysAllow) onSetAlwaysAllow,
    required void Function(String methodKey, RememberChoiceTtl rememberTtl)
        onSetRememberTtl,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BatchRequestPermission(
        clientPubkey: 'client',
        sourceName: 'source',
        groupsNotifier: groupsNotifier,
        onSetSelected: onSetSelected,
        onSetAllSelected: onSetAllSelected,
        onSetAlwaysAllow: onSetAlwaysAllow,
        onSetRememberTtl: onSetRememberTtl,
        onApproveSelected: () async {},
        onRejectAll: () async {},
      ),
    );
  }

  group('BatchRequestPermission regression', () {
    testWidgets('All and None update selection for every group',
        (WidgetTester tester) async {
      final groupsNotifier = ValueNotifier<List<BatchPermissionGroupView>>(
        initialGroups(),
      );

      void updateGroup(String methodKey, BatchPermissionGroupView Function(BatchPermissionGroupView g) map) {
        groupsNotifier.value = groupsNotifier.value
            .map((g) => g.methodKey == methodKey ? map(g) : g)
            .toList();
      }

      await tester.pumpWidget(
        buildPage(
          groupsNotifier: groupsNotifier,
          onSetSelected: (methodKey, selected) {
            updateGroup(
              methodKey,
              (g) => BatchPermissionGroupView(
                methodKey: g.methodKey,
                description: g.description,
                count: g.count,
                selected: selected,
                alwaysAllow: g.alwaysAllow,
                rememberTtl: g.rememberTtl,
              ),
            );
          },
          onSetAllSelected: (selected) {
            groupsNotifier.value = groupsNotifier.value
                .map(
                  (g) => BatchPermissionGroupView(
                    methodKey: g.methodKey,
                    description: g.description,
                    count: g.count,
                    selected: selected,
                    alwaysAllow: g.alwaysAllow,
                    rememberTtl: g.rememberTtl,
                  ),
                )
                .toList();
          },
          onSetAlwaysAllow: (methodKey, alwaysAllow) {
            updateGroup(
              methodKey,
              (g) => BatchPermissionGroupView(
                methodKey: g.methodKey,
                description: g.description,
                count: g.count,
                selected: g.selected,
                alwaysAllow: alwaysAllow,
                rememberTtl: g.rememberTtl,
              ),
            );
          },
          onSetRememberTtl: (methodKey, ttl) {
            updateGroup(
              methodKey,
              (g) => BatchPermissionGroupView(
                methodKey: g.methodKey,
                description: g.description,
                count: g.count,
                selected: g.selected,
                alwaysAllow: g.alwaysAllow,
                rememberTtl: ttl,
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.deselect));
      await tester.pumpAndSettle();
      expect(groupsNotifier.value.every((g) => !g.selected), isTrue);

      await tester.tap(find.byIcon(Icons.select_all));
      await tester.pumpAndSettle();
      expect(groupsNotifier.value.every((g) => g.selected), isTrue);
    });

    testWidgets('Grant button disabled when all unchecked, enabled otherwise',
        (WidgetTester tester) async {
      final groupsNotifier = ValueNotifier<List<BatchPermissionGroupView>>(
        initialGroups(),
      );

      BatchPermissionGroupView copyWith(BatchPermissionGroupView g, {bool? selected}) {
        return BatchPermissionGroupView(
          methodKey: g.methodKey,
          description: g.description,
          count: g.count,
          selected: selected ?? g.selected,
          alwaysAllow: g.alwaysAllow,
          rememberTtl: g.rememberTtl,
        );
      }

      await tester.pumpWidget(
        buildPage(
          groupsNotifier: groupsNotifier,
          onSetSelected: (methodKey, selected) {
            groupsNotifier.value = groupsNotifier.value
                .map((g) => g.methodKey == methodKey ? copyWith(g, selected: selected) : g)
                .toList();
          },
          onSetAllSelected: (selected) {
            groupsNotifier.value =
                groupsNotifier.value.map((g) => copyWith(g, selected: selected)).toList();
          },
          onSetAlwaysAllow: (_, __) {},
          onSetRememberTtl: (_, __) {},
        ),
      );
      await tester.pumpAndSettle();

      FilledButton grantButton =
          tester.widgetList<FilledButton>(find.byType(FilledButton)).first;
      expect(grantButton.onPressed, isNotNull);

      await tester.tap(find.byIcon(Icons.deselect));
      await tester.pumpAndSettle();
      grantButton = tester.widgetList<FilledButton>(find.byType(FilledButton)).first;
      expect(grantButton.onPressed, isNull);

      await tester.tap(find.byIcon(Icons.select_all));
      await tester.pumpAndSettle();
      grantButton = tester.widgetList<FilledButton>(find.byType(FilledButton)).first;
      expect(grantButton.onPressed, isNotNull);
    });

    testWidgets('Select all / none do not mutate alwaysAllow semantics',
        (WidgetTester tester) async {
      final groupsNotifier = ValueNotifier<List<BatchPermissionGroupView>>(
        initialGroups(),
      );

      await tester.pumpWidget(
        buildPage(
          groupsNotifier: groupsNotifier,
          onSetSelected: (methodKey, selected) {
            groupsNotifier.value = groupsNotifier.value
                .map(
                  (g) => g.methodKey == methodKey
                      ? BatchPermissionGroupView(
                          methodKey: g.methodKey,
                          description: g.description,
                          count: g.count,
                          selected: selected,
                          alwaysAllow: g.alwaysAllow,
                          rememberTtl: g.rememberTtl,
                        )
                      : g,
                )
                .toList();
          },
          onSetAllSelected: (selected) {
            groupsNotifier.value = groupsNotifier.value
                .map(
                  (g) => BatchPermissionGroupView(
                    methodKey: g.methodKey,
                    description: g.description,
                    count: g.count,
                    selected: selected,
                    alwaysAllow: g.alwaysAllow,
                    rememberTtl: g.rememberTtl,
                  ),
                )
                .toList();
          },
          onSetAlwaysAllow: (methodKey, alwaysAllow) {
            groupsNotifier.value = groupsNotifier.value
                .map(
                  (g) => g.methodKey == methodKey
                      ? BatchPermissionGroupView(
                          methodKey: g.methodKey,
                          description: g.description,
                          count: g.count,
                          selected: g.selected,
                          alwaysAllow: alwaysAllow,
                          rememberTtl: g.rememberTtl,
                        )
                      : g,
                )
                .toList();
          },
          onSetRememberTtl: (_, __) {},
        ),
      );
      await tester.pumpAndSettle();

      final initialAlwaysAllow = {
        for (final g in groupsNotifier.value) g.methodKey: g.alwaysAllow,
      };

      await tester.tap(find.byIcon(Icons.deselect));
      await tester.pumpAndSettle();
      expect(
        {
          for (final g in groupsNotifier.value) g.methodKey: g.alwaysAllow,
        },
        equals(initialAlwaysAllow),
      );

      await tester.tap(find.byIcon(Icons.select_all));
      await tester.pumpAndSettle();
      expect(
        {
          for (final g in groupsNotifier.value) g.methodKey: g.alwaysAllow,
        },
        equals(initialAlwaysAllow),
      );
    });
  });
}
