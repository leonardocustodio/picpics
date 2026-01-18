import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/generated/l10n.dart' as lang;
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/error_dialog.dart';
import 'package:picpics/widgets/error_state_widget.dart';

/// Helper widget wrapper that provides localization for tests
Widget wrapWithLocalization(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      lang.S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: lang.S.delegate.supportedLocales,
    home: Scaffold(body: child),
  );
}

/// Error handling tests for the application
/// Tests error recovery, error widgets, and edge cases
void main() {
  setUpAll(AppLogger.init);

  group('ErrorStateWidget Tests', () {
    testWidgets('renders in compact mode without localization', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(compact: true),
          ),
        ),
      );

      // Should render the widget
      expect(find.byType(ErrorStateWidget), findsOneWidget);
      // Should have an error icon
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('renders with custom message (compact avoids localization)', (tester) async {
      await tester.pumpWidget(
        wrapWithLocalization(
          const ErrorStateWidget(
            message: 'Custom error message',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom error message'), findsOneWidget);
    });

    testWidgets('renders with custom icon in compact mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              icon: Icons.warning_amber,
              compact: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry provided (full mode)', (tester) async {
      var retryCount = 0;

      await tester.pumpWidget(
        wrapWithLocalization(
          ErrorStateWidget(
            onRetry: () => retryCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should have a retry button
      expect(find.byType(CupertinoButton), findsOneWidget);

      // Tap retry
      await tester.tap(find.byType(CupertinoButton));
      await tester.pump();

      expect(retryCount, 1);
    });

    testWidgets('hides retry button when onRetry is null (compact)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(compact: true),
          ),
        ),
      );

      // Should NOT have refresh icon (no retry in compact mode)
      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('compact mode renders smaller widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              compact: true,
            ),
          ),
        ),
      );

      // Should render compact version
      expect(find.byType(ErrorStateWidget), findsOneWidget);
      // Compact version uses smaller icon size
      final icon = tester.widget<Icon>(find.byType(Icon).first);
      expect(icon.size, 24.0);
    });

    testWidgets('full mode renders with padding', (tester) async {
      await tester.pumpWidget(
        wrapWithLocalization(
          const ErrorStateWidget(
            compact: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should have padding
      final paddings = tester.widgetList<Padding>(find.byType(Padding));
      expect(paddings.any((p) {
        if (p.padding is EdgeInsets) {
          final ei = p.padding as EdgeInsets;
          return ei.left == 24 && ei.right == 24;
        }
        return false;
      }), isTrue);
    });

    testWidgets('compact mode retry button works', (tester) async {
      var retryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              compact: true,
              onRetry: () => retryTapped = true,
            ),
          ),
        ),
      );

      // Find and tap the refresh icon (wrapped in GestureDetector in compact mode)
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      expect(retryTapped, isTrue);
    });
  });

  group('PhotoErrorWidget Tests', () {
    testWidgets('renders with broken image icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhotoErrorWidget(),
          ),
        ),
      );

      expect(find.byType(PhotoErrorWidget), findsOneWidget);
      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    });

    testWidgets('shows refresh button when onRetry provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoErrorWidget(
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('hides refresh when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhotoErrorWidget(),
          ),
        ),
      );

      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('retry callback is invoked on tap', (tester) async {
      var retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoErrorWidget(
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      expect(retryCalled, isTrue);
    });
  });

  group('ErrorDialog Tests', () {
    testWidgets('renders with message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            lang.S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: lang.S.delegate.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const ErrorDialog(
                      message: 'Test error message',
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('renders with custom title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            lang.S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: lang.S.delegate.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const ErrorDialog(
                      message: 'Error',
                      title: 'Custom Title',
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Title'), findsOneWidget);
    });

    testWidgets('dismiss button closes dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            lang.S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: lang.S.delegate.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => ErrorDialog(
                      message: 'Test error',
                      onDismiss: () => Navigator.of(context).pop(),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.text('Test error'), findsOneWidget);

      // Tap close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.text('Test error'), findsNothing);
    });

    testWidgets('retry button is shown when onRetry provided', (tester) async {
      var retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            lang.S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: lang.S.delegate.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => ErrorDialog(
                      message: 'Test error',
                      onRetry: () => retryCalled = true,
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Should have three CupertinoButtons (close icon, dismiss button, retry button)
      expect(find.byType(CupertinoButton), findsNWidgets(3));
    });

    testWidgets('custom button text is displayed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            lang.S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: lang.S.delegate.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => ErrorDialog(
                      message: 'Test error',
                      dismissButtonText: 'Cancel',
                      retryButtonText: 'Retry Now',
                      onRetry: () {},
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Retry Now'), findsOneWidget);
    });
  });

  group('Provider Error Recovery Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('TagsProvider handles clear gracefully', () {
      final notifier = container.read(tagsProvider.notifier);

      // Should not throw
      expect(() => notifier.clear(), returnsNormally);

      final state = container.read(tagsProvider);
      expect(state.allTags, isEmpty);
    });

    test('TaggedProvider handles invalid photo operations', () {
      final notifier = container.read(taggedProvider.notifier);

      // Adding non-existent photo should not throw
      expect(() => notifier.addSelectedMultiBarPic('non_existent_id'), returnsNormally);

      // Removing non-existent photo should not throw
      expect(() => notifier.removeSelectedMultiBarPic('non_existent_id'), returnsNormally);

      // Clearing empty selections should not throw
      expect(() => notifier.clearSelectedMultiBarPics(), returnsNormally);
    });

    test('TabsProvider handles toggle with invalid index gracefully', () {
      final notifier = container.read(tabsProvider.notifier);

      // Setting various toggle indices should not throw
      expect(() => notifier.setToggleIndexUntagged(0), returnsNormally);
      expect(() => notifier.setToggleIndexUntagged(1), returnsNormally);
      expect(() => notifier.setToggleIndexUntagged(2), returnsNormally);
    });

    test('Multiple rapid state changes do not cause inconsistency', () {
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Rapid add/remove cycles
      for (var i = 0; i < 100; i++) {
        taggedNotifier
          ..addSelectedMultiBarPic('photo_$i')
          ..removeSelectedMultiBarPic('photo_$i');
      }

      // State should be consistent (empty)
      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics, isEmpty);
    });

    test('State recovery after clear operations', () {
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Add some selections
      for (var i = 0; i < 10; i++) {
        taggedNotifier.addSelectedMultiBarPic('photo_$i');
      }

      expect(container.read(taggedProvider).selectedMultiBarPics.length, 10);

      // Clear
      taggedNotifier.clearSelectedMultiBarPics();
      expect(container.read(taggedProvider).selectedMultiBarPics, isEmpty);

      // Should be able to add again
      taggedNotifier.addSelectedMultiBarPic('new_photo');
      expect(container.read(taggedProvider).selectedMultiBarPics.length, 1);
    });
  });

  group('Input Validation Edge Cases', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('empty string photo ID handling', () {
      final notifier = container.read(taggedProvider.notifier);

      // Should handle empty string
      expect(() => notifier.addSelectedMultiBarPic(''), returnsNormally);
      expect(() => notifier.removeSelectedMultiBarPic(''), returnsNormally);
    });

    test('very long photo ID handling', () {
      final notifier = container.read(taggedProvider.notifier);
      final longId = 'a' * 10000;

      // Should handle very long IDs
      expect(() => notifier.addSelectedMultiBarPic(longId), returnsNormally);

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.containsKey(longId), isTrue);
    });

    test('special characters in photo ID handling', () {
      final notifier = container.read(taggedProvider.notifier);
      const specialId = '!@#\$%^&*()_+-=[]{}|;:,.<>?/~`';

      expect(() => notifier.addSelectedMultiBarPic(specialId), returnsNormally);

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.containsKey(specialId), isTrue);
    });

    test('unicode characters in photo ID handling', () {
      final notifier = container.read(taggedProvider.notifier);
      const unicodeId = '日本語_한국어_中文_العربية_🎉';

      expect(() => notifier.addSelectedMultiBarPic(unicodeId), returnsNormally);

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.containsKey(unicodeId), isTrue);
    });

    test('null-like string values handling', () {
      final notifier = container.read(taggedProvider.notifier);

      expect(() => notifier.addSelectedMultiBarPic('null'), returnsNormally);
      expect(() => notifier.addSelectedMultiBarPic('undefined'), returnsNormally);
      expect(() => notifier.addSelectedMultiBarPic('nil'), returnsNormally);

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.length, 3);
    });
  });

  group('State Consistency Under Failure Conditions', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('provider state remains valid after many operations', () {
      final taggedNotifier = container.read(taggedProvider.notifier);
      final tabsNotifier = container.read(tabsProvider.notifier);

      // Perform many mixed operations
      for (var i = 0; i < 1000; i++) {
        if (i % 5 == 0) {
          taggedNotifier.addSelectedMultiBarPic('photo_$i');
        } else if (i % 5 == 1) {
          taggedNotifier.removeSelectedMultiBarPic('photo_${i - 1}');
        } else if (i % 5 == 2) {
          tabsNotifier.setMultiPicBar(value: i.isEven);
        } else if (i % 5 == 3) {
          tabsNotifier.setToggleIndexUntagged(i % 3);
        } else {
          // Just read state
          container.read(taggedProvider);
          container.read(tabsProvider);
        }
      }

      // State should still be valid and accessible
      final taggedState = container.read(taggedProvider);
      final tabsState = container.read(tabsProvider);

      expect(taggedState.selectedMultiBarPics, isA<Map<String, bool>>());
      expect(tabsState.multiPicBar, isA<bool>());
      expect(tabsState.toggleIndexUntagged, isA<int>());
    });

    test('independent containers do not affect each other', () {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();

      // Modify first container
      container1.read(taggedProvider.notifier).addSelectedMultiBarPic('photo1');
      container1.read(tabsProvider.notifier).setMultiPicBar(value: true);

      // Second container should be unaffected
      final state2 = container2.read(taggedProvider);
      final tabsState2 = container2.read(tabsProvider);

      expect(state2.selectedMultiBarPics, isEmpty);
      expect(tabsState2.multiPicBar, isFalse);

      container1.dispose();
      container2.dispose();
    });

    test('disposed container throws appropriate error', () {
      final tempContainer = ProviderContainer();
      tempContainer.dispose();

      // Should throw when accessing disposed container
      expect(
        () => tempContainer.read(taggedProvider),
        throwsA(isA<StateError>()),
      );
    });
  });
}
