import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'performance_test_utils.dart';

/// Edge case performance tests
/// Tests extreme scenarios to ensure robustness
void main() {
  group('Edge Case: Empty Gallery', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Empty gallery - state access performance', () {
      final duration = PerformanceTestUtils.measureSyncExecutionTime(() {
        final tabsState = container.read(tabsProvider);
        // Access empty collections
        expect(tabsState.assetMap.isEmpty, isTrue);
        expect(tabsState.allUnTaggedPics.isEmpty, isTrue);
      });

      expect(duration.inMilliseconds, lessThan(1),
          reason: 'Empty state access should be instant');
    });

    test('Empty gallery - operations on empty state', () {
      final duration = PerformanceTestUtils.measureSyncExecutionTime(() {
        final notifier = container.read(tabsProvider.notifier);
        // Perform operations on empty state
        notifier.setMultiPicBar(true);
        notifier.setToggleIndexUntagged(1);
        notifier.setMultiPicBar(false);
      });

      expect(duration.inMilliseconds, lessThan(5),
          reason: 'Operations on empty state should be fast');
    });

    test('Empty gallery - no memory leaks', () {
      final memoryBefore = PerformanceTestUtils.estimateMemoryUsage(
        container.read(tabsProvider).assetMap,
      );

      // Perform many operations
      final notifier = container.read(tabsProvider.notifier);
      for (int i = 0; i < 1000; i++) {
        notifier.setMultiPicBar(i % 2 == 0);
      }

      final memoryAfter = PerformanceTestUtils.estimateMemoryUsage(
        container.read(tabsProvider).assetMap,
      );

      expect(memoryAfter, equals(memoryBefore),
          reason: 'Operations should not leak memory in empty state');
    });
  });

  group('Edge Case: Large Gallery (1000+ photos)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Large selection - 1000 photos', () async {
      final notifier = container.read(taggedProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        for (int i = 0; i < 1000; i++) {
          notifier.addSelectedMultiBarPic('photo_$i');
        }
      });

      debugPrint('Selecting 1000 photos: ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(1000),
          reason: 'Selecting 1000 photos should be under 1 second');

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.length, equals(1000));
    });

    test('Large selection - memory usage', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add 1000 selections
      for (int i = 0; i < 1000; i++) {
        notifier.addSelectedMultiBarPic('photo_$i');
      }

      final state = container.read(taggedProvider);
      final memoryUsage = PerformanceTestUtils.estimateMemoryUsage(
        state.selectedMultiBarPics,
      );

      debugPrint('1000 selections memory: ${memoryUsage / 1024}KB');
      expect(memoryUsage, lessThan(500000),
          reason: '1000 selections should use less than 500KB');
    });

    test('Large selection - clear performance', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add 1000 selections
      for (int i = 0; i < 1000; i++) {
        notifier.addSelectedMultiBarPic('photo_$i');
      }

      final duration = PerformanceTestUtils.measureSyncExecutionTime(() {
        notifier.clearSelectedMultiBarPics();
      });

      debugPrint('Clearing 1000 selections: ${duration.inMicroseconds}μs');
      expect(duration.inMilliseconds, lessThan(10),
          reason: 'Clearing should be under 10ms');

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.isEmpty, isTrue);
    });

    test('Large selection - individual removal performance', () async {
      final notifier = container.read(taggedProvider.notifier);

      // Add 1000 selections
      for (int i = 0; i < 1000; i++) {
        notifier.addSelectedMultiBarPic('photo_$i');
      }

      // Remove 100 photos and measure
      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        for (int i = 0; i < 100; i++) {
          notifier.removeSelectedMultiBarPic('photo_$i');
        }
      });

      debugPrint('Removing 100 from 1000: ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(100),
          reason: 'Removing 100 photos should be under 100ms');

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.length, equals(900));
    });
  });

  group('Edge Case: Rapid State Changes', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Rapid toggle - 1000 changes', () async {
      final notifier = container.read(tabsProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        await PerformanceTestUtils.rapidStateChanges(
          changeState: () => notifier.setMultiPicBar(!container.read(tabsProvider).multiPicBar),
          count: 1000,
        );
      });

      debugPrint('1000 rapid toggles: ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(500),
          reason: '1000 toggles should be under 500ms');
    });

    test('Rapid selection changes - 500 add/remove cycles', () async {
      final notifier = container.read(taggedProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        for (int i = 0; i < 500; i++) {
          notifier.addSelectedMultiBarPic('photo_$i');
          notifier.removeSelectedMultiBarPic('photo_$i');
        }
      });

      debugPrint('500 add/remove cycles: ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(250),
          reason: '500 cycles should be under 250ms');

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.isEmpty, isTrue);
    });

    test('Rapid view switching - 100 changes', () async {
      final notifier = container.read(tabsProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        for (int i = 0; i < 100; i++) {
          notifier.setToggleIndexUntagged(i % 3); // Month/Day/Year rotation
        }
      });

      debugPrint('100 view switches: ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(100),
          reason: '100 view switches should be under 100ms');
    });

    test('Stress test - multiple concurrent operations', () async {
      final tabsNotifier = container.read(tabsProvider.notifier);
      final taggedNotifier = container.read(taggedProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        // Simulate concurrent user actions
        await PerformanceTestUtils.runConcurrentOperations([
          () async {
            for (int i = 0; i < 50; i++) {
              tabsNotifier.setMultiPicBar(i % 2 == 0);
            }
          },
          () async {
            for (int i = 0; i < 50; i++) {
              taggedNotifier.addSelectedMultiBarPic('photo_$i');
            }
          },
          () async {
            for (int i = 0; i < 50; i++) {
              tabsNotifier.setToggleIndexUntagged(i % 3);
            }
          },
        ]);
      });

      debugPrint('Concurrent operations: ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(200),
          reason: 'Concurrent operations should complete quickly');
    });
  });

  group('Edge Case: State Consistency Under Stress', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('State consistency after 1000 operations', () async {
      final notifier = container.read(taggedProvider.notifier);

      // Perform 1000 random operations
      for (int i = 0; i < 1000; i++) {
        switch (i % 4) {
          case 0:
            notifier.addSelectedMultiBarPic('photo_$i');
            break;
          case 1:
            if (i > 0) notifier.removeSelectedMultiBarPic('photo_${i - 1}');
            break;
          case 2:
            notifier.clearSelectedMultiBarPics();
            break;
          case 3:
            // Read state without modification
            container.read(taggedProvider);
            break;
        }
      }

      // Verify state is consistent
      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics, isA<Map<String, bool>>());

      // Verify we can still perform operations
      notifier.addSelectedMultiBarPic('final_photo');
      expect(container.read(taggedProvider).selectedMultiBarPics.containsKey('final_photo'),
          isTrue);
    });

    test('No memory leaks after repeated clear operations', () {
      final notifier = container.read(taggedProvider.notifier);

      final initialMemory = PerformanceTestUtils.estimateMemoryUsage(
        container.read(taggedProvider).selectedMultiBarPics,
      );

      // Repeatedly add and clear selections
      for (int cycle = 0; cycle < 100; cycle++) {
        // Add 100 selections
        for (int i = 0; i < 100; i++) {
          notifier.addSelectedMultiBarPic('photo_$i');
        }

        // Clear
        notifier.clearSelectedMultiBarPics();
      }

      final finalMemory = PerformanceTestUtils.estimateMemoryUsage(
        container.read(taggedProvider).selectedMultiBarPics,
      );

      expect(finalMemory, equals(initialMemory),
          reason: 'Memory should return to baseline after clear operations');
    });

    test('Provider rebuild count stays reasonable under stress', () {
      int rebuildCount = 0;

      final subscription = container.listen<TabsState>(
        tabsProvider,
        (previous, next) => rebuildCount++,
        fireImmediately: false,
      );

      final notifier = container.read(tabsProvider.notifier);

      // Perform 100 state changes
      for (int i = 0; i < 100; i++) {
        notifier.setMultiPicBar(i % 2 == 0);
        notifier.setToggleIndexUntagged(i % 3);
      }

      subscription.close();

      debugPrint('Rebuilds for 200 operations: $rebuildCount');
      expect(rebuildCount, equals(200),
          reason: 'Each state change should trigger exactly one rebuild');
    });
  });

  group('Edge Case: Boundary Conditions', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Maximum safe selection size (10,000 photos)', () async {
      final notifier = container.read(taggedProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        for (int i = 0; i < 10000; i++) {
          notifier.addSelectedMultiBarPic('photo_$i');
        }
      });

      debugPrint('Selecting 10,000 photos: ${duration.inMilliseconds}ms');

      final state = container.read(taggedProvider);
      expect(state.selectedMultiBarPics.length, equals(10000));

      // Verify operations still work
      notifier.removeSelectedMultiBarPic('photo_0');
      expect(container.read(taggedProvider).selectedMultiBarPics.length, equals(9999));
    });

    test('Zero-delay rapid changes', () async {
      final notifier = container.read(tabsProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        await PerformanceTestUtils.rapidStateChanges(
          changeState: () => notifier.setMultiPicBar(!container.read(tabsProvider).multiPicBar),
          count: 100,
          delay: Duration.zero,
        );
      });

      debugPrint('100 zero-delay changes: ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(50),
          reason: 'Zero-delay changes should be very fast');
    });

    test('Alternating provider access', () async {
      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        for (int i = 0; i < 1000; i++) {
          if (i % 3 == 0) {
            container.read(tabsProvider);
          } else if (i % 3 == 1) {
            container.read(taggedProvider);
          } else {
            container.read(tagsProvider);
          }
        }
      });

      debugPrint('1000 alternating reads: ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(100),
          reason: 'Alternating provider reads should be fast');
    });
  });
}
