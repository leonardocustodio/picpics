import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';

/// Integration tests for multi-photo operations
/// Tests bulk operations like multi-select, multi-tag, and multi-delete
void main() {
  group('Multi-Photo Selection Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Multi-selection mode can be enabled', () {
      final notifier = container.read(tabsProvider.notifier);

      notifier.setMultiPicBar(true);

      final tabsState = container.read(tabsProvider);
      expect(tabsState.multiPicBar, isTrue);
    });

    test('Multi-selection mode can be disabled', () {
      final notifier = container.read(tabsProvider.notifier);

      notifier.setMultiPicBar(true);
      notifier.setMultiPicBar(false);

      final tabsState = container.read(tabsProvider);
      expect(tabsState.multiPicBar, isFalse);
    });

    test('Multi-tag sheet can be toggled', () {
      final notifier = container.read(tabsProvider.notifier);

      notifier.setMultiTagSheet(true);
      expect(container.read(tabsProvider).multiTagSheet, isTrue);

      notifier.setMultiTagSheet(false);
      expect(container.read(tabsProvider).multiTagSheet, isFalse);
    });

    test('Multiple photos can be selected', () {
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Select multiple photos
      taggedNotifier.addSelectedMultiBarPic('photo1');
      taggedNotifier.addSelectedMultiBarPic('photo2');
      taggedNotifier.addSelectedMultiBarPic('photo3');

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.length, 3);
    });

    test('Selected photos can be cleared', () {
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Select photos
      taggedNotifier.addSelectedMultiBarPic('photo1');
      taggedNotifier.addSelectedMultiBarPic('photo2');

      // Clear selection
      taggedNotifier.clearSelectedMultiBarPics();

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.isEmpty, isTrue);
    });

    test('Individual photo can be removed from selection', () {
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Select multiple photos
      taggedNotifier.addSelectedMultiBarPic('photo1');
      taggedNotifier.addSelectedMultiBarPic('photo2');
      taggedNotifier.addSelectedMultiBarPic('photo3');

      // Remove one
      taggedNotifier.removeSelectedMultiBarPic('photo2');

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.length, 2);
      expect(taggedState.selectedMultiBarPics.containsKey('photo2'), isFalse);
    });

    test('Multi-selection state persists across reads', () {
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Add selections
      taggedNotifier.addSelectedMultiBarPic('photo1');
      taggedNotifier.addSelectedMultiBarPic('photo2');

      // Multiple reads should see same state
      final state1 = container.read(taggedProvider);
      final state2 = container.read(taggedProvider);

      expect(state1.selectedMultiBarPics.length, 2);
      expect(state2.selectedMultiBarPics.length, 2);
      expect(identical(state1, state2), isTrue);
    });
  });

  group('Multi-Photo Operations Coordination', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Multi-bar and multi-sheet can be coordinated', () {
      final notifier = container.read(tabsProvider.notifier);

      // Enable both
      notifier.setMultiPicBar(true);
      notifier.setMultiTagSheet(true);

      final tabsState = container.read(tabsProvider);
      expect(tabsState.multiPicBar, isTrue);
      expect(tabsState.multiTagSheet, isTrue);
    });

    test('Disabling multi-bar should work independently of multi-sheet', () {
      final notifier = container.read(tabsProvider.notifier);

      // Enable both
      notifier.setMultiPicBar(true);
      notifier.setMultiTagSheet(true);

      // Disable only multi-bar
      notifier.setMultiPicBar(false);

      final tabsState = container.read(tabsProvider);
      expect(tabsState.multiPicBar, isFalse);
      expect(tabsState.multiTagSheet, isTrue);
    });

    test('Tabs and tagged providers should be coordinated', () {
      final tabsNotifier = container.read(tabsProvider.notifier);
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Enable multi-selection in tabs
      tabsNotifier.setMultiPicBar(true);

      // Add selections in tagged
      taggedNotifier.addSelectedMultiBarPic('photo1');

      // Both should reflect coordinated state
      final tabsState = container.read(tabsProvider);
      final taggedState = container.read(taggedProvider);

      expect(tabsState.multiPicBar, isTrue);
      expect(taggedState.selectedMultiBarPics.isNotEmpty, isTrue);
    });
  });

  group('Multi-Photo Edge Cases', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Selecting zero photos should be handled gracefully', () {
      final taggedState = container.read(taggedProvider);

      expect(taggedState.selectedMultiBarPics.isEmpty, isTrue);
    });

    test('Selecting large number of photos should not crash', () {
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Select 100 photos
      for (int i = 0; i < 100; i++) {
        taggedNotifier.addSelectedMultiBarPic('photo$i');
      }

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.length, 100);
    });

    test('Clearing empty selection should not cause errors', () {
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Clear when nothing is selected
      expect(() => taggedNotifier.clearSelectedMultiBarPics(), returnsNormally);

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.isEmpty, isTrue);
    });

    test('Multiple toggles should maintain consistency', () {
      final notifier = container.read(tabsProvider.notifier);

      // Toggle multiple times rapidly
      for (int i = 0; i < 10; i++) {
        notifier.setMultiPicBar(i % 2 == 0);
      }

      final tabsState = container.read(tabsProvider);
      expect(tabsState.multiPicBar, isFalse); // Should end up false (even number of toggles)
    });

    test('State should be independent across providers', () {
      final tabsNotifier = container.read(tabsProvider.notifier);
      final taggedNotifier = container.read(taggedProvider.notifier);

      // Change tabs state
      tabsNotifier.setMultiPicBar(true);

      // Tagged selections are independent
      taggedNotifier.addSelectedMultiBarPic('photo1');

      final tabsState = container.read(tabsProvider);
      final taggedState = container.read(taggedProvider);

      // Both should have their own state
      expect(tabsState.multiPicBar, isTrue);
      expect(taggedState.selectedMultiBarPics.length, 1);
    });
  });

  group('Multi-Photo Selection Flow', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Complete multi-selection workflow', () {
      final tabsNotifier = container.read(tabsProvider.notifier);
      final taggedNotifier = container.read(taggedProvider.notifier);

      // 1. Enable multi-selection mode
      tabsNotifier.setMultiPicBar(true);
      expect(container.read(tabsProvider).multiPicBar, isTrue);

      // 2. Select multiple photos
      taggedNotifier.addSelectedMultiBarPic('photo1');
      taggedNotifier.addSelectedMultiBarPic('photo2');
      taggedNotifier.addSelectedMultiBarPic('photo3');
      expect(container.read(taggedProvider).selectedMultiBarPics.length, 3);

      // 3. Open multi-tag sheet
      tabsNotifier.setMultiTagSheet(true);
      expect(container.read(tabsProvider).multiTagSheet, isTrue);

      // 4. Clear selections after tagging (simulated)
      taggedNotifier.clearSelectedMultiBarPics();
      expect(container.read(taggedProvider).selectedMultiBarPics.isEmpty, isTrue);

      // 5. Close multi-tag sheet
      tabsNotifier.setMultiTagSheet(false);
      expect(container.read(tabsProvider).multiTagSheet, isFalse);

      // 6. Disable multi-selection mode
      tabsNotifier.setMultiPicBar(false);
      expect(container.read(tabsProvider).multiPicBar, isFalse);
    });
  });
}
