import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/private_photos_provider.dart';

/// Integration tests for private photos functionality
void main() {
  group('Private Photos Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be correct', () {
      final privateState = container.read(privatePhotosProvider);

      expect(privateState.showPrivate, isFalse);
      expect(privateState.privatePhotoIds, isEmpty);
      expect(privateState.privateMap, isEmpty);
    });

    test('Toggle showPrivate should update state', () {
      container.read(privatePhotosProvider.notifier).toggleShowPrivate();

      final privateState = container.read(privatePhotosProvider);
      expect(privateState.showPrivate, isTrue);

      container.read(privatePhotosProvider.notifier).toggleShowPrivate();
      expect(container.read(privatePhotosProvider).showPrivate, isFalse);
    });

    test('Set showPrivate should update state', () {
      container.read(privatePhotosProvider.notifier).setShowPrivate(true);
      expect(container.read(privatePhotosProvider).showPrivate, isTrue);

      container.read(privatePhotosProvider.notifier).setShowPrivate(false);
      expect(container.read(privatePhotosProvider).showPrivate, isFalse);
    });

    test('Add private photo should update state', () {
      container.read(privatePhotosProvider.notifier).addPrivatePhoto('photo1');

      final privateState = container.read(privatePhotosProvider);
      expect(privateState.privatePhotoIds.contains('photo1'), isTrue);
      expect(privateState.privatePhotoIds.length, equals(1));
    });

    test('Add duplicate private photo should be ignored', () {
      container.read(privatePhotosProvider.notifier)
        ..addPrivatePhoto('photo1')
        ..addPrivatePhoto('photo1'); // Duplicate

      final privateState = container.read(privatePhotosProvider);
      expect(privateState.privatePhotoIds.length, equals(1));
    });

    test('Add multiple private photos', () {
      container.read(privatePhotosProvider.notifier)
        ..addPrivatePhoto('photo1')
        ..addPrivatePhoto('photo2')
        ..addPrivatePhoto('photo3');

      final privateState = container.read(privatePhotosProvider);
      expect(privateState.privatePhotoIds.length, equals(3));
      expect(privateState.privatePhotoIds.contains('photo1'), isTrue);
      expect(privateState.privatePhotoIds.contains('photo2'), isTrue);
      expect(privateState.privatePhotoIds.contains('photo3'), isTrue);
    });

    test('Remove private photo should update state', () {
      // Add some photos first then remove one
      container.read(privatePhotosProvider.notifier)
        ..addPrivatePhoto('photo1')
        ..addPrivatePhoto('photo2')
        ..removePrivatePhoto('photo1');

      final privateState = container.read(privatePhotosProvider);
      expect(privateState.privatePhotoIds.contains('photo1'), isFalse);
      expect(privateState.privatePhotoIds.contains('photo2'), isTrue);
      expect(privateState.privatePhotoIds.length, equals(1));
    });

    test('Remove non-existent photo should not crash', () {
      final notifier = container.read(privatePhotosProvider.notifier);

      // Try removing a photo that doesn't exist
      expect(() => notifier.removePrivatePhoto('nonexistent'), returnsNormally);
    });

    test('State should be immutable', () {
      final state1 = container.read(privatePhotosProvider);
      final state2 = container.read(privatePhotosProvider);

      expect(identical(state1, state2), isTrue);
    });

    test('Multiple reads should return same state', () {
      final state1 = container.read(privatePhotosProvider);
      final state2 = container.read(privatePhotosProvider);
      final state3 = container.read(privatePhotosProvider);

      expect(identical(state1, state2), isTrue);
      expect(identical(state2, state3), isTrue);
    });

    test('Multiple containers should have independent state', () {
      final container2 = ProviderContainer();

      // Modify first container
      container.read(privatePhotosProvider.notifier).setShowPrivate(true);
      container.read(privatePhotosProvider.notifier).addPrivatePhoto('photo1');

      // Second container should be unaffected
      final state1 = container.read(privatePhotosProvider);
      final state2 = container2.read(privatePhotosProvider);

      expect(state1.showPrivate, isTrue);
      expect(state2.showPrivate, isFalse);
      expect(state1.privatePhotoIds.length, equals(1));
      expect(state2.privatePhotoIds.length, equals(0));

      container2.dispose();
    });

    test('Complete workflow: show/hide private photos', () {
      // 1. Start with show private = false
      expect(container.read(privatePhotosProvider).showPrivate, isFalse);

      // 2. Add some private photos
      container.read(privatePhotosProvider.notifier)
        ..addPrivatePhoto('photo1')
        ..addPrivatePhoto('photo2');

      // 3. Enable showing private photos
      container.read(privatePhotosProvider.notifier).setShowPrivate(true);
      expect(container.read(privatePhotosProvider).showPrivate, isTrue);

      // 4. Verify photos are in the list
      final state = container.read(privatePhotosProvider);
      expect(state.privatePhotoIds.length, equals(2));

      // 5. Hide private photos again
      container.read(privatePhotosProvider.notifier).setShowPrivate(false);
      expect(container.read(privatePhotosProvider).showPrivate, isFalse);

      // 6. Photos should still be in the list (just hidden)
      expect(container.read(privatePhotosProvider).privatePhotoIds.length, equals(2));
    });
  });
}
