import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/providers/tagged_provider.dart';

/// Integration tests for tagged photos functionality
/// Tests the management of tagged photos and their display
void main() {
  group('Tagged Photos Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should have empty tagged photos', () {
      final taggedState = container.read(taggedProvider);

      expect(taggedState.taggedPicId, isEmpty);
      expect(taggedState.allTaggedPicDateWiseList, isEmpty);
      expect(taggedState.allTaggedPicIdList, isEmpty);
    });

    test('Selected multi-bar pics should be empty initially', () {
      final taggedState = container.read(taggedProvider);

      expect(taggedState.selectedMultiBarPics, isEmpty);
    });

    test('Tagged photos map should be initialized correctly', () {
      final taggedState = container.read(taggedProvider);

      expect(taggedState.taggedPicId, isA<Map<String, Map<String, String>>>());
      expect(taggedState.taggedPicId.isEmpty, isTrue);
    });

    test('Provider notifier should be accessible', () {
      final notifier = container.read(taggedProvider.notifier);

      expect(notifier, isNotNull);
      expect(notifier, isA<TaggedNotifier>());
    });

    test('Adding to multi-bar selection should update state', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add a photo to selection
      notifier.addSelectedMultiBarPic('test_photo_id');

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.containsKey('test_photo_id'), isTrue);
    });

    test('Removing from multi-bar selection should update state', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add then remove
      notifier.addSelectedMultiBarPic('test_photo_id');
      notifier.removeSelectedMultiBarPic('test_photo_id');

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.containsKey('test_photo_id'), isFalse);
    });

    test('Clearing multi-bar selection should empty the selection', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add multiple photos
      notifier.addSelectedMultiBarPic('photo1');
      notifier.addSelectedMultiBarPic('photo2');

      // Clear selection
      notifier.clearSelectedMultiBarPics();

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.isEmpty, isTrue);
    });

    test('Provider state should be immutable', () {
      final state1 = container.read(taggedProvider);
      final state2 = container.read(taggedProvider);

      expect(identical(state1, state2), isTrue);
    });

    test('Multiple provider reads should return same state', () {
      final state1 = container.read(taggedProvider);
      final state2 = container.read(taggedProvider);

      expect(state1, same(state2));
    });
  });

  group('Tagged Photos Edge Cases', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Empty tagged photos collection should be handled gracefully', () {
      final taggedState = container.read(taggedProvider);

      expect(taggedState.taggedPicId.isEmpty, isTrue);
      expect(taggedState.allTaggedPicDateWiseList.isEmpty, isTrue);
      expect(taggedState.allTaggedPicIdList.isEmpty, isTrue);
    });

    test('Multiple containers should have independent state', () {
      final container2 = ProviderContainer();

      // Add to first container's selection
      container.read(taggedProvider.notifier).addSelectedMultiBarPic('photo1');

      // Second container should be unaffected
      final state1 = container.read(taggedProvider);
      final state2 = container2.read(taggedProvider);

      expect(state1.selectedMultiBarPics.isNotEmpty, isTrue);
      expect(state2.selectedMultiBarPics.isEmpty, isTrue);

      container2.dispose();
    });

    test('Adding duplicate photo to selection should not cause errors', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add same photo twice
      notifier.addSelectedMultiBarPic('photo1');
      notifier.addSelectedMultiBarPic('photo1');

      final taggedState = container.read(taggedProvider);
      // Should still contain the photo
      expect(taggedState.selectedMultiBarPics.containsKey('photo1'), isTrue);
    });

    test('Removing non-existent photo should not cause errors', () {
      final notifier = container.read(taggedProvider.notifier);

      // Try to remove photo that was never added
      expect(() => notifier.removeSelectedMultiBarPic('non_existent'), returnsNormally);

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.isEmpty, isTrue);
    });
  });

  group('Multi-Photo Selection', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Can select multiple photos', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add multiple photos
      notifier.addSelectedMultiBarPic('photo1');
      notifier.addSelectedMultiBarPic('photo2');
      notifier.addSelectedMultiBarPic('photo3');

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.length, 3);
    });

    test('Can remove specific photo from selection', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add three photos
      notifier.addSelectedMultiBarPic('photo1');
      notifier.addSelectedMultiBarPic('photo2');
      notifier.addSelectedMultiBarPic('photo3');

      // Remove middle one
      notifier.removeSelectedMultiBarPic('photo2');

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.length, 2);
      expect(taggedState.selectedMultiBarPics.containsKey('photo1'), isTrue);
      expect(taggedState.selectedMultiBarPics.containsKey('photo2'), isFalse);
      expect(taggedState.selectedMultiBarPics.containsKey('photo3'), isTrue);
    });

    test('Clear selection should work with multiple photos', () {
      final notifier = container.read(taggedProvider.notifier);

      // Add many photos
      for (int i = 0; i < 10; i++) {
        notifier.addSelectedMultiBarPic('photo$i');
      }

      // Clear all
      notifier.clearSelectedMultiBarPics();

      final taggedState = container.read(taggedProvider);
      expect(taggedState.selectedMultiBarPics.isEmpty, isTrue);
    });
  });
}
