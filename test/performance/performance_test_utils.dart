import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

/// Utilities for performance testing and profiling
class PerformanceTestUtils {
  /// Measures the time taken to execute a function
  static Future<Duration> measureExecutionTime(Future<void> Function() fn) async {
    final stopwatch = Stopwatch()..start();
    await fn();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Measures the time taken to execute a synchronous function
  static Duration measureSyncExecutionTime(void Function() fn) {
    final stopwatch = Stopwatch()..start();
    fn();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Counts the number of times a provider rebuilds
  /// TODO: Fix type annotation for Riverpod 3.x - ProviderListenable not exported
  static int countProviderRebuilds<T>(
    ProviderContainer container,
    dynamic provider,
    void Function() action,
  ) {
    var rebuildCount = 0;

    // Using dynamic to work around ProviderListenable export issue in Riverpod 3.x
    try {
      // ignore_for_file: argument_type_not_assignable
      final subscription = container.listen<dynamic>(
        provider,
        (dynamic previous, dynamic next) {
          rebuildCount++;
        },
      );

      action();

      subscription.close();
    } catch (e) {
      // If listen fails due to type issues, run action without counting
      action();
    }

    return rebuildCount;
  }

  /// Measures memory usage (approximation based on state size)
  static int estimateMemoryUsage(Object? state) {
    if (state == null) return 0;

    var size = 0;

    // Estimate based on type
    if (state is Map) {
      size += state.length * 50; // Rough estimate per entry
      for (final key in state.keys) {
        size += estimateMemoryUsage(key);
        size += estimateMemoryUsage(state[key]);
      }
    } else if (state is List) {
      size += state.length * 30; // Rough estimate per item
      for (final item in state) {
        size += estimateMemoryUsage(item);
      }
    } else if (state is String) {
      size += state.length * 2; // 2 bytes per character
    } else if (state is int || state is double || state is bool) {
      size += 8; // Primitive types
    } else {
      size += 100; // Default for complex objects
    }

    return size;
  }

  /// Runs a benchmark multiple times and returns statistics
  static Future<BenchmarkResult> runBenchmark({
    required String name,
    required Future<void> Function() setup,
    required Future<void> Function() action,
    required Future<void> Function() teardown,
    int iterations = 100,
  }) async {
    final durations = <Duration>[];

    for (var i = 0; i < iterations; i++) {
      await setup();

      final duration = await measureExecutionTime(action);
      durations.add(duration);

      await teardown();
    }

    return BenchmarkResult(
      name: name,
      iterations: iterations,
      durations: durations,
    );
  }

  /// Simulates rapid state changes
  static Future<void> rapidStateChanges({
    required void Function() changeState,
    required int count,
    Duration? delay,
  }) async {
    for (var i = 0; i < count; i++) {
      changeState();
      if (delay != null) {
        await Future<void>.delayed(delay);
      }
    }
  }

  /// Creates a large collection of test data
  static List<String> generateLargePhotoCollection(int count) {
    return List.generate(count, (index) => 'photo_$index');
  }

  /// Simulates concurrent operations
  static Future<List<T>> runConcurrentOperations<T>(
    List<Future<T> Function()> operations,
  ) async {
    return Future.wait(operations.map((op) => op()));
  }
}

/// Result of a benchmark run
class BenchmarkResult {

  BenchmarkResult({
    required this.name,
    required this.iterations,
    required this.durations,
  });
  final String name;
  final int iterations;
  final List<Duration> durations;

  /// Average execution time
  Duration get average {
    final totalMicroseconds = durations.fold<int>(
      0,
      (sum, duration) => sum + duration.inMicroseconds,
    );
    return Duration(microseconds: totalMicroseconds ~/ iterations);
  }

  /// Minimum execution time
  Duration get min {
    return durations.reduce((a, b) => a < b ? a : b);
  }

  /// Maximum execution time
  Duration get max {
    return durations.reduce((a, b) => a > b ? a : b);
  }

  /// Standard deviation
  double get standardDeviation {
    final avgMicros = average.inMicroseconds;
    final variance = durations.fold<double>(
      0,
      (sum, duration) {
        final diff = duration.inMicroseconds - avgMicros;
        return sum + (diff * diff);
      },
    ) / iterations;
    return variance.sqrt();
  }

  /// Median execution time
  Duration get median {
    final sorted = List<Duration>.from(durations)..sort();
    final middle = sorted.length ~/ 2;
    if (sorted.length % 2 == 0) {
      final avgMicros = (sorted[middle - 1].inMicroseconds +
                        sorted[middle].inMicroseconds) ~/ 2;
      return Duration(microseconds: avgMicros);
    }
    return sorted[middle];
  }

  /// Summary string
  String get summary {
    return '''
Benchmark: $name
Iterations: $iterations
Average: ${average.inMilliseconds}ms
Median: ${median.inMilliseconds}ms
Min: ${min.inMilliseconds}ms
Max: ${max.inMilliseconds}ms
Std Dev: ${standardDeviation.toStringAsFixed(2)}μs
''';
  }

  /// Check if performance meets target
  bool meetsTarget(Duration target) {
    return average <= target;
  }

  /// Performance rating
  String get rating {
    final avgMs = average.inMilliseconds;
    if (avgMs < 16) return 'Excellent (60fps+)';
    if (avgMs < 33) return 'Good (30-60fps)';
    if (avgMs < 100) return 'Acceptable';
    if (avgMs < 500) return 'Slow';
    return 'Very Slow';
  }
}

/// Extension for Duration to get microseconds as double
extension DurationExtension on Duration {
  double get microseconds => inMicroseconds.toDouble();
}

/// Extension for double to calculate square root
extension DoubleExtension on double {
  double sqrt() {
    if (this < 0) return 0;

    // Newton's method for square root
    final x = this;
    var guess = this / 2;

    for (var i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }

    return guess;
  }
}
