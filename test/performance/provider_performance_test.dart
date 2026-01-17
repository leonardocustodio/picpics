import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';

import 'performance_test_utils.dart';

/// Performance benchmarks for Riverpod providers
/// Tests measure execution time, rebuild frequency, and memory usage
void main() {
  group('Provider Performance Benchmarks', () {
    test('Tabs provider initialization performance', () async {
      final result = await PerformanceTestUtils.runBenchmark(
        name: 'Tabs Provider Initialization',
        setup: () async {},
        action: () async {
          final container = ProviderContainer()
            ..read(tabsProvider)
            ..dispose();
        },
        teardown: () async {},
      );

      debugPrint(result.summary);
      expect(result.average.inMilliseconds, lessThan(10),
          reason: 'Provider initialization should be under 10ms',);
    });

    test('Tagged provider initialization performance', () async {
      final result = await PerformanceTestUtils.runBenchmark(
        name: 'Tagged Provider Initialization',
        setup: () async {},
        action: () async {
          final container = ProviderContainer()
            ..read(taggedProvider)
            ..dispose();
        },
        teardown: () async {},
      );

      debugPrint(result.summary);
      expect(result.average.inMilliseconds, lessThan(10));
    });

    test('Tags provider initialization performance', () async {
      final result = await PerformanceTestUtils.runBenchmark(
        name: 'Tags Provider Initialization',
        setup: () async {},
        action: () async {
          final container = ProviderContainer()
            ..read(tagsProvider)
            ..dispose();
        },
        teardown: () async {},
      );

      debugPrint(result.summary);
      expect(result.average.inMilliseconds, lessThan(10));
    });

    test('Multi-selection toggle performance', () async {
      final container = ProviderContainer();

      final result = await PerformanceTestUtils.runBenchmark(
        name: 'Multi-selection Toggle',
        setup: () async {},
        action: () async {
          container.read(tabsProvider.notifier)
            ..setMultiPicBar(true)
            ..setMultiPicBar(false);
        },
        teardown: () async {},
        iterations: 1000,
      );

      debugPrint(result.summary);
      expect(result.average.inMicroseconds, lessThan(1000),
          reason: 'Toggle should be under 1ms',);

      container.dispose();
    });

    test('Photo selection performance', () async {
      final container = ProviderContainer();

      final result = await PerformanceTestUtils.runBenchmark(
        name: 'Photo Selection',
        setup: () async {},
        action: () async {
          container.read(taggedProvider.notifier)
            ..addSelectedMultiBarPic('photo_test')
            ..removeSelectedMultiBarPic('photo_test');
        },
        teardown: () async {},
        iterations: 1000,
      );

      debugPrint(result.summary);
      expect(result.average.inMicroseconds, lessThan(500),
          reason: 'Selection should be under 0.5ms',);

      container.dispose();
    });

    test('Bulk photo selection performance', () async {
      final container = ProviderContainer();
      final notifier = container.read(taggedProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        // Select 100 photos
        for (var i = 0; i < 100; i++) {
          notifier.addSelectedMultiBarPic('photo_$i');
        }
      });

      debugPrint('Bulk selection (100 photos): ${duration.inMilliseconds}ms');
      expect(duration.inMilliseconds, lessThan(100),
          reason: 'Selecting 100 photos should be under 100ms',);

      container.dispose();
    });

    test('Provider rebuild count - single update', () {
      final container = ProviderContainer();

      final rebuildCount = PerformanceTestUtils.countProviderRebuilds<TabsState>(
        container,
        tabsProvider,
        () {
          container.read(tabsProvider.notifier).setMultiPicBar(true);
        },
      );

      expect(rebuildCount, equals(1),
          reason: 'Single update should trigger exactly 1 rebuild',);

      container.dispose();
    });

    test('Provider rebuild count - multiple updates', () {
      final container = ProviderContainer();

      final rebuildCount = PerformanceTestUtils.countProviderRebuilds<TabsState>(
        container,
        tabsProvider,
        () {
          container.read(tabsProvider.notifier)
            ..setMultiPicBar(true)
            ..setMultiTagSheet(true)
            ..setToggleIndexUntagged(1);
        },
      );

      expect(rebuildCount, equals(3),
          reason: '3 updates should trigger 3 rebuilds',);

      container.dispose();
    });

    test('Memory usage estimation - empty state', () {
      final container = ProviderContainer();
      final tabsState = container.read(tabsProvider);

      final memoryUsage = PerformanceTestUtils.estimateMemoryUsage(tabsState.assetMap);
      debugPrint('Empty state memory: $memoryUsage bytes');

      expect(memoryUsage, lessThan(1000),
          reason: 'Empty state should use minimal memory',);

      container.dispose();
    });

    test('Memory usage estimation - with selections', () {
      final container = ProviderContainer();
      final notifier = container.read(taggedProvider.notifier);

      // Add 100 selections
      for (var i = 0; i < 100; i++) {
        notifier.addSelectedMultiBarPic('photo_$i');
      }

      final taggedState = container.read(taggedProvider);
      final memoryUsage = PerformanceTestUtils.estimateMemoryUsage(
        taggedState.selectedMultiBarPics,
      );

      debugPrint('100 selections memory: $memoryUsage bytes');
      expect(memoryUsage, lessThan(50000),
          reason: '100 selections should use less than 50KB',);

      container.dispose();
    });
  });

  group('Provider Performance Targets', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('State read performance target: < 1ms', () {
      final duration = PerformanceTestUtils.measureSyncExecutionTime(() {
        for (var i = 0; i < 1000; i++) {
          container.read(tabsProvider);
        }
      });

      final avgPerRead = duration.inMicroseconds / 1000;
      debugPrint('Average state read: ${avgPerRead.toStringAsFixed(2)}μs');

      expect(avgPerRead, lessThan(1000),
          reason: 'State read should be under 1ms average',);
    });

    test('Notifier access performance target: < 1ms', () {
      final duration = PerformanceTestUtils.measureSyncExecutionTime(() {
        for (var i = 0; i < 1000; i++) {
          container.read(tabsProvider.notifier);
        }
      });

      final avgPerRead = duration.inMicroseconds / 1000;
      debugPrint('Average notifier access: ${avgPerRead.toStringAsFixed(2)}μs');

      expect(avgPerRead, lessThan(1000));
    });

    test('State update performance target: < 5ms', () async {
      final notifier = container.read(tabsProvider.notifier);

      final duration = await PerformanceTestUtils.measureExecutionTime(() async {
        for (var i = 0; i < 100; i++) {
          notifier.setMultiPicBar(i % 2 == 0);
        }
      });

      final avgPerUpdate = duration.inMicroseconds / 100;
      debugPrint('Average state update: ${avgPerUpdate.toStringAsFixed(2)}μs');

      expect(avgPerUpdate, lessThan(5000),
          reason: 'State update should be under 5ms average',);
    });
  });

  group('Performance Regression Detection', () {
    test('Baseline: Provider creation overhead', () async {
      final results = <String, Duration>{};

      // Tabs provider
      results['tabs'] = await PerformanceTestUtils.measureExecutionTime(() async {
        final container = ProviderContainer()
          ..read(tabsProvider)
          ..dispose();
      });

      // Tagged provider
      results['tagged'] = await PerformanceTestUtils.measureExecutionTime(() async {
        final container = ProviderContainer()
          ..read(taggedProvider)
          ..dispose();
      });

      // Tags provider
      results['tags'] = await PerformanceTestUtils.measureExecutionTime(() async {
        final container = ProviderContainer()
          ..read(tagsProvider)
          ..dispose();
      });

      debugPrint('\n=== Provider Creation Baseline ===');
      // Print timing and verify all should be under 10ms
      results.forEach((provider, duration) {
        debugPrint('$provider: ${duration.inMicroseconds}μs');
        expect(duration.inMilliseconds, lessThan(10),
            reason: '$provider creation should be under 10ms',);
      });
    });

    test('Baseline: Common operations timing', () async {
      final container = ProviderContainer();
      final timings = <String, Duration>{};

      // Multi-selection enable
      timings['enable_multi_select'] = PerformanceTestUtils.measureSyncExecutionTime(() {
        container.read(tabsProvider.notifier).setMultiPicBar(true);
      });

      // Photo selection
      timings['select_photo'] = PerformanceTestUtils.measureSyncExecutionTime(() {
        container.read(taggedProvider.notifier).addSelectedMultiBarPic('photo1');
      });

      // Photo deselection
      timings['deselect_photo'] = PerformanceTestUtils.measureSyncExecutionTime(() {
        container.read(taggedProvider.notifier).removeSelectedMultiBarPic('photo1');
      });

      // Clear selections
      timings['clear_selections'] = PerformanceTestUtils.measureSyncExecutionTime(() {
        container.read(taggedProvider.notifier).clearSelectedMultiBarPics();
      });

      debugPrint('\n=== Common Operations Baseline ===');
      timings.forEach((operation, duration) {
        debugPrint('$operation: ${duration.inMicroseconds}μs');
      });

      container.dispose();
    });
  });
}
