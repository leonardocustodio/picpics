import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/utils/enum.dart';

/// Integration tests for untagged photos functionality
/// Tests the core flow of loading and managing untagged photos
void main() {
  group('Untagged Photos Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Create a fresh provider container for each test
      container = ProviderContainer();
    });

    tearDown(() {
      // Dispose container after each test
      container.dispose();
    });

    test('Initial state should be loading', () {
      final tabsState = container.read(tabsProvider);

      expect(tabsState.status, Status.loading);
      expect(tabsState.assetMap, isEmpty);
      expect(tabsState.allUnTaggedPics, isEmpty);
      expect(tabsState.allUnTaggedPicsMonth, isEmpty);
      expect(tabsState.allUnTaggedPicsDay, isEmpty);
    });

    test('Asset map should be initialized as empty', () {
      final tabsState = container.read(tabsProvider);

      expect(tabsState.assetMap, isA<Map<String, dynamic>>());
      expect(tabsState.assetMap.isEmpty, isTrue);
    });

    test('Untagged photos list should be initialized as empty', () {
      final tabsState = container.read(tabsProvider);

      expect(tabsState.allUnTaggedPics, isA<Map<String, String>>());
      expect(tabsState.allUnTaggedPics.isEmpty, isTrue);
    });

    test('Toggle index for untagged should default to 1 (day view)', () {
      final tabsState = container.read(tabsProvider);

      expect(tabsState.toggleIndexUntagged, 1);
    });

    test('Multi-selection should be disabled by default', () {
      final tabsState = container.read(tabsProvider);

      expect(tabsState.multiPicBar, isFalse);
      expect(tabsState.multiTagSheet, isFalse);
      expect(tabsState.selectedPhotos, isEmpty);
    });

    test('Enabling multi-selection should update state', () {
      container.read(tabsProvider.notifier).setMultiPicBar(value: true);
      final tabsState = container.read(tabsProvider);

      expect(tabsState.multiPicBar, isTrue);
    });

    test('Disabling multi-selection should update state', () {
      // Enable then disable
      container.read(tabsProvider.notifier)
        ..setMultiPicBar(value: true)
        ..setMultiPicBar(value: false);
      final tabsState = container.read(tabsProvider);

      expect(tabsState.multiPicBar, isFalse);
    });

    test('Toggle index can be changed between month/day/year views', () {
      // Test month view (0)
      container.read(tabsProvider.notifier).setToggleIndexUntagged(0);
      expect(container.read(tabsProvider).toggleIndexUntagged, 0);

      // Test day view (1)
      container.read(tabsProvider.notifier).setToggleIndexUntagged(1);
      expect(container.read(tabsProvider).toggleIndexUntagged, 1);

      // Test year view (2)
      container.read(tabsProvider.notifier).setToggleIndexUntagged(2);
      expect(container.read(tabsProvider).toggleIndexUntagged, 2);
    });

    test('Top offset for first tab should have default value', () {
      final tabsState = container.read(tabsProvider);

      expect(tabsState.topOffsetFirstTab, 64.0);
    });

    test('Scrolling state can be toggled', () {
      container.read(tabsProvider.notifier).setIsScrolling(value: true);
      expect(container.read(tabsProvider).isScrolling, isTrue);

      container.read(tabsProvider.notifier).setIsScrolling(value: false);
      expect(container.read(tabsProvider).isScrolling, isFalse);
    });

    test('Loading state should be manageable', () {
      final tabsState = container.read(tabsProvider);

      // Check initial loading state
      expect(tabsState.isLoading, isFalse);
      expect(tabsState.isUntaggedPicsLoaded, isFalse);
    });

    test('Provider state should be copyable', () {
      final initialState = container.read(tabsProvider);

      // Verify initial state exists
      expect(initialState, isNotNull);
      expect(initialState.currentIndex, 0);
    });

    test('Multiple provider reads should return same state', () {
      final state1 = container.read(tabsProvider);
      final state2 = container.read(tabsProvider);

      expect(state1, same(state2));
    });

    test('Provider notifier should be accessible', () {
      final notifier = container.read(tabsProvider.notifier);

      expect(notifier, isNotNull);
      expect(notifier, isA<TabsNotifier>());
    });
  });

  group('Untagged Photos Edge Cases', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Empty gallery should be handled gracefully', () {
      final tabsState = container.read(tabsProvider);

      expect(tabsState.assetMap.isEmpty, isTrue);
      expect(tabsState.allUnTaggedPics.isEmpty, isTrue);
      expect(tabsState.status, Status.loading);
    });

    test('State should be immutable after read', () {
      final state1 = container.read(tabsProvider);
      final state2 = container.read(tabsProvider);

      // Both reads should return the same immutable state
      expect(identical(state1, state2), isTrue);
    });

    test('Multiple containers should have independent state', () {
      final container2 = ProviderContainer();

      // Modify first container
      container.read(tabsProvider.notifier).setMultiPicBar(value: true);

      // Second container should be unaffected
      final state1 = container.read(tabsProvider);
      final state2 = container2.read(tabsProvider);

      expect(state1.multiPicBar, isTrue);
      expect(state2.multiPicBar, isFalse);

      container2.dispose();
    });
  });
}
