import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/percentage_dialog_provider.dart';
import 'package:picpics/providers/photo_screen_provider.dart';
import 'package:picpics/providers/progress_provider.dart';
import 'package:picpics/providers/swiper_tab_provider.dart';

/// Unit tests for provider state classes
/// Tests focus on pure state management without external dependencies
void main() {
  group('ProgressState', () {
    group('Constructor and defaults', () {
      test('default constructor should create initial state', () {
        const state = ProgressState();

        expect(state.total, equals(0.0));
        expect(state.value, equals(0.0));
        expect(state.show, isFalse);
        expect(state.text, isNull);
      });

      test('constructor with all parameters', () {
        const state = ProgressState(
          total: 100,
          value: 50,
          show: true,
          text: 'Loading...',
        );

        expect(state.total, equals(100.0));
        expect(state.value, equals(50.0));
        expect(state.show, isTrue);
        expect(state.text, equals('Loading...'));
      });
    });

    group('copyWith', () {
      test('copyWith with no arguments should preserve all values', () {
        const original = ProgressState(
          total: 100,
          value: 25,
          show: true,
          text: 'Processing',
        );

        final copy = original.copyWith();

        expect(copy.total, equals(original.total));
        expect(copy.value, equals(original.value));
        expect(copy.show, equals(original.show));
        expect(copy.text, equals(original.text));
      });

      test('copyWith should update only specified fields', () {
        const original = ProgressState(
          total: 100,
          value: 25,
          show: true,
          text: 'Processing',
        );

        final updated = original.copyWith(value: 75);

        expect(updated.total, equals(100.0));
        expect(updated.value, equals(75.0));
        expect(updated.show, isTrue);
        expect(updated.text, equals('Processing'));
      });

      test('copyWith all fields', () {
        const original = ProgressState();

        final updated = original.copyWith(
          total: 200,
          value: 100,
          show: true,
          text: 'Complete',
        );

        expect(updated.total, equals(200.0));
        expect(updated.value, equals(100.0));
        expect(updated.show, isTrue);
        expect(updated.text, equals('Complete'));
      });
    });

    group('State transitions', () {
      test('simulate progress workflow', () {
        var state = const ProgressState();

        // Start progress
        state = state.copyWith(
          total: 100,
          value: 0,
          show: true,
          text: 'Starting...',
        );
        expect(state.show, isTrue);
        expect(state.total, equals(100.0));

        // Update progress
        state = state.copyWith(value: 50, text: '50% complete');
        expect(state.value, equals(50.0));

        // Complete
        state = state.copyWith(value: 100, text: 'Done!');
        expect(state.value, equals(100.0));

        // Hide
        state = state.copyWith(show: false, value: 0);
        expect(state.show, isFalse);
      });

      test('progress percentage calculation', () {
        const state = ProgressState(total: 100, value: 75);

        final percentage = state.value / state.total * 100;
        expect(percentage, equals(75.0));
      });
    });
  });

  group('ProgressNotifier', () {
    late ProviderContainer container;
    late ProgressNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(progressProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('start should set state correctly', () {
      notifier.start(100, 'Loading');

      final state = container.read(progressProvider);
      expect(state.show, isTrue);
      expect(state.total, equals(100.0));
      expect(state.value, equals(0.0));
      expect(state.text, equals('Loading'));
    });

    test('start should not override if already showing', () {
      notifier
        ..start(100, 'First')
        ..start(200, 'Second');

      final state = container.read(progressProvider);
      expect(state.total, equals(100.0)); // First value preserved
      expect(state.text, equals('First'));
    });

    test('increaseValue should update value', () {
      notifier
        ..start(100)
        ..increaseValue(25);

      expect(container.read(progressProvider).value, equals(25.0));
    });

    test('increaseValue should stop when reaching total', () {
      notifier
        ..start(100)
        ..increaseValue(100);

      expect(container.read(progressProvider).show, isFalse);
    });

    test('stop should hide and reset value', () {
      notifier
        ..start(100, 'Test')
        ..increaseValue(50)
        ..stop();

      final state = container.read(progressProvider);
      expect(state.show, isFalse);
      expect(state.value, equals(0.0));
    });
  });

  group('PercentageDialogState', () {
    group('Constructor and defaults', () {
      test('default constructor should create initial state', () {
        final state = PercentageDialogState();

        expect(state.isShowing, isFalse);
        expect(state.progress, equals(0.0));
        expect(state.message, isEmpty);
      });

      test('constructor with all parameters', () {
        final state = PercentageDialogState(
          isShowing: true,
          progress: 0.5,
          message: 'Processing...',
        );

        expect(state.isShowing, isTrue);
        expect(state.progress, equals(0.5));
        expect(state.message, equals('Processing...'));
      });
    });

    group('copyWith', () {
      test('copyWith with no arguments should preserve all values', () {
        final original = PercentageDialogState(
          isShowing: true,
          progress: 0.75,
          message: 'Loading',
        );

        final copy = original.copyWith();

        expect(copy.isShowing, equals(original.isShowing));
        expect(copy.progress, equals(original.progress));
        expect(copy.message, equals(original.message));
      });

      test('copyWith should update only specified fields', () {
        final original = PercentageDialogState(
          isShowing: true,
          progress: 0.5,
          message: 'Loading',
        );

        final updated = original.copyWith(progress: 0.75);

        expect(updated.isShowing, isTrue);
        expect(updated.progress, equals(0.75));
        expect(updated.message, equals('Loading'));
      });
    });

    group('State transitions', () {
      test('simulate dialog workflow', () {
        var state = PercentageDialogState();

        // Show dialog
        state = state.copyWith(isShowing: true, message: 'Uploading...');
        expect(state.isShowing, isTrue);

        // Update progress
        state = state.copyWith(progress: 0.5);
        expect(state.progress, equals(0.5));

        // Complete
        state = state.copyWith(progress: 1, message: 'Complete');
        expect(state.progress, equals(1.0));

        // Hide
        state = PercentageDialogState(); // Reset
        expect(state.isShowing, isFalse);
        expect(state.progress, equals(0.0));
      });
    });
  });

  group('PercentageDialogNotifier', () {
    late ProviderContainer container;
    late PercentageDialogNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(percentageDialogProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('show should set state correctly', () {
      notifier.show('Uploading');

      final state = container.read(percentageDialogProvider);
      expect(state.isShowing, isTrue);
      expect(state.message, equals('Uploading'));
      expect(state.progress, equals(0.0));
    });

    test('updateProgress should update progress', () {
      notifier
        ..show('Test')
        ..updateProgress(0.5);

      expect(container.read(percentageDialogProvider).progress, equals(0.5));
    });

    test('updateMessage should update message', () {
      notifier
        ..show('Original')
        ..updateMessage('Updated');

      expect(container.read(percentageDialogProvider).message, equals('Updated'));
    });

    test('hide should reset state', () {
      notifier
        ..show('Test')
        ..updateProgress(0.5)
        ..hide();

      final state = container.read(percentageDialogProvider);
      expect(state.isShowing, isFalse);
      expect(state.progress, equals(0.0));
      expect(state.message, isEmpty);
    });
  });

  group('SwiperTabState', () {
    group('Constructor and defaults', () {
      test('default constructor should create initial state', () {
        final state = SwiperTabState();

        expect(state.currentIndex, equals(0));
        expect(state.photoIds, isEmpty);
        expect(state.isZoomed, isFalse);
        expect(state.isLoaded, isFalse);
      });

      test('constructor with all parameters', () {
        final state = SwiperTabState(
          currentIndex: 5,
          photoIds: ['photo1', 'photo2', 'photo3'],
          isZoomed: true,
          isLoaded: true,
        );

        expect(state.currentIndex, equals(5));
        expect(state.photoIds.length, equals(3));
        expect(state.isZoomed, isTrue);
        expect(state.isLoaded, isTrue);
      });
    });

    group('copyWith', () {
      test('copyWith with no arguments should preserve all values', () {
        final original = SwiperTabState(
          currentIndex: 3,
          photoIds: ['a', 'b', 'c'],
          isZoomed: true,
          isLoaded: true,
        );

        final copy = original.copyWith();

        expect(copy.currentIndex, equals(original.currentIndex));
        expect(copy.photoIds, equals(original.photoIds));
        expect(copy.isZoomed, equals(original.isZoomed));
        expect(copy.isLoaded, equals(original.isLoaded));
      });

      test('copyWith should update only specified fields', () {
        final original = SwiperTabState(
          photoIds: ['a', 'b', 'c'],
        );

        final updated = original.copyWith(currentIndex: 2);

        expect(updated.currentIndex, equals(2));
        expect(updated.photoIds, equals(['a', 'b', 'c']));
      });
    });

    group('State transitions', () {
      test('simulate photo browsing', () {
        var state = SwiperTabState(
          photoIds: ['photo1', 'photo2', 'photo3', 'photo4'],
        );

        // Move to next
        state = state.copyWith(currentIndex: 1);
        expect(state.currentIndex, equals(1));

        // Move to next again
        state = state.copyWith(currentIndex: 2);
        expect(state.currentIndex, equals(2));
      });

      test('zoom state toggle', () {
        var state = SwiperTabState();

        state = state.copyWith(isZoomed: true);
        expect(state.isZoomed, isTrue);

        state = state.copyWith(isZoomed: false);
        expect(state.isZoomed, isFalse);
      });
    });
  });

  group('SwiperTabNotifier', () {
    late ProviderContainer container;
    late SwiperTabNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(swiperTabProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('setPhotoIds should set photo list', () {
      notifier.setPhotoIds(['a', 'b', 'c']);

      expect(container.read(swiperTabProvider).photoIds, equals(['a', 'b', 'c']));
    });

    test('setCurrentIndex should update index', () {
      notifier
        ..setPhotoIds(['a', 'b', 'c'])
        ..setCurrentIndex(2);

      expect(container.read(swiperTabProvider).currentIndex, equals(2));
    });

    test('nextPhoto should increment index', () {
      notifier
        ..setPhotoIds(['a', 'b', 'c'])
        ..setCurrentIndex(0)
        ..nextPhoto();

      expect(container.read(swiperTabProvider).currentIndex, equals(1));
    });

    test('nextPhoto should not exceed bounds', () {
      notifier
        ..setPhotoIds(['a', 'b', 'c'])
        ..setCurrentIndex(2)
        ..nextPhoto();

      expect(container.read(swiperTabProvider).currentIndex, equals(2));
    });

    test('previousPhoto should decrement index', () {
      notifier
        ..setPhotoIds(['a', 'b', 'c'])
        ..setCurrentIndex(2)
        ..previousPhoto();

      expect(container.read(swiperTabProvider).currentIndex, equals(1));
    });

    test('previousPhoto should not go below 0', () {
      notifier
        ..setPhotoIds(['a', 'b', 'c'])
        ..setCurrentIndex(0)
        ..previousPhoto();

      expect(container.read(swiperTabProvider).currentIndex, equals(0));
    });

    test('setZoomed should update zoom state', () {
      notifier.setZoomed(zoomed: true);
      expect(container.read(swiperTabProvider).isZoomed, isTrue);

      notifier.setZoomed(zoomed: false);
      expect(container.read(swiperTabProvider).isZoomed, isFalse);
    });

    test('removePhotoId should remove photo from list', () {
      notifier
        ..setPhotoIds(['a', 'b', 'c'])
        ..removePhotoId('b');

      expect(container.read(swiperTabProvider).photoIds, equals(['a', 'c']));
    });

    test('setLoaded should update loaded state', () {
      notifier.setLoaded(loaded: true);
      expect(container.read(swiperTabProvider).isLoaded, isTrue);

      notifier.setLoaded(loaded: false);
      expect(container.read(swiperTabProvider).isLoaded, isFalse);
    });
  });

  group('PhotoScreenState', () {
    group('Constructor and defaults', () {
      test('default constructor should create initial state', () {
        final state = PhotoScreenState();

        expect(state.currentPhotoId, isEmpty);
        expect(state.photoIds, isEmpty);
        expect(state.currentIndex, equals(0));
        expect(state.isEditing, isFalse);
      });

      test('constructor with all parameters', () {
        final state = PhotoScreenState(
          currentPhotoId: 'photo2',
          photoIds: ['photo1', 'photo2', 'photo3'],
          currentIndex: 1,
          isEditing: true,
        );

        expect(state.currentPhotoId, equals('photo2'));
        expect(state.photoIds.length, equals(3));
        expect(state.currentIndex, equals(1));
        expect(state.isEditing, isTrue);
      });
    });

    group('copyWith', () {
      test('copyWith with no arguments should preserve all values', () {
        final original = PhotoScreenState(
          currentPhotoId: 'photo1',
          photoIds: ['photo1', 'photo2'],
          isEditing: true,
        );

        final copy = original.copyWith();

        expect(copy.currentPhotoId, equals(original.currentPhotoId));
        expect(copy.photoIds, equals(original.photoIds));
        expect(copy.currentIndex, equals(original.currentIndex));
        expect(copy.isEditing, equals(original.isEditing));
      });

      test('copyWith should update only specified fields', () {
        final original = PhotoScreenState(
          currentPhotoId: 'photo1',
          photoIds: ['photo1', 'photo2', 'photo3'],
        );

        final updated = original.copyWith(
          currentIndex: 2,
          currentPhotoId: 'photo3',
        );

        expect(updated.currentIndex, equals(2));
        expect(updated.currentPhotoId, equals('photo3'));
        expect(updated.photoIds, equals(original.photoIds));
      });
    });

    group('State transitions', () {
      test('simulate photo navigation', () {
        var state = PhotoScreenState(
          photoIds: ['a', 'b', 'c', 'd'],
          currentPhotoId: 'a',
        );

        // Navigate to next
        state = state.copyWith(currentIndex: 1, currentPhotoId: 'b');
        expect(state.currentIndex, equals(1));
        expect(state.currentPhotoId, equals('b'));

        // Navigate to last
        state = state.copyWith(currentIndex: 3, currentPhotoId: 'd');
        expect(state.currentIndex, equals(3));
        expect(state.currentPhotoId, equals('d'));
      });

      test('editing mode toggle', () {
        var state = PhotoScreenState();

        state = state.copyWith(isEditing: true);
        expect(state.isEditing, isTrue);

        state = state.copyWith(isEditing: false);
        expect(state.isEditing, isFalse);
      });
    });
  });

  group('PhotoScreenNotifier', () {
    late ProviderContainer container;
    late PhotoScreenNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(photoScreenProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initialize should set up state correctly', () {
      notifier.initialize('photo2', ['photo1', 'photo2', 'photo3']);

      final state = container.read(photoScreenProvider);
      expect(state.currentPhotoId, equals('photo2'));
      expect(state.photoIds, equals(['photo1', 'photo2', 'photo3']));
      expect(state.currentIndex, equals(1));
    });

    test('initialize with non-existent photo should default to index 0', () {
      notifier.initialize('nonexistent', ['photo1', 'photo2', 'photo3']);

      final state = container.read(photoScreenProvider);
      expect(state.currentPhotoId, equals('nonexistent'));
      expect(state.currentIndex, equals(0));
    });

    test('setCurrentPhoto should update photo and index', () {
      notifier
        ..initialize('photo1', ['photo1', 'photo2', 'photo3'])
        ..setCurrentPhoto('photo3');

      final state = container.read(photoScreenProvider);
      expect(state.currentPhotoId, equals('photo3'));
      expect(state.currentIndex, equals(2));
    });

    test('nextPhoto should advance to next photo', () {
      notifier
        ..initialize('photo1', ['photo1', 'photo2', 'photo3'])
        ..nextPhoto();

      final state = container.read(photoScreenProvider);
      expect(state.currentIndex, equals(1));
      expect(state.currentPhotoId, equals('photo2'));
    });

    test('nextPhoto should not exceed bounds', () {
      notifier
        ..initialize('photo3', ['photo1', 'photo2', 'photo3'])
        ..nextPhoto();

      final state = container.read(photoScreenProvider);
      expect(state.currentIndex, equals(2));
      expect(state.currentPhotoId, equals('photo3'));
    });

    test('previousPhoto should go to previous photo', () {
      notifier
        ..initialize('photo2', ['photo1', 'photo2', 'photo3'])
        ..previousPhoto();

      final state = container.read(photoScreenProvider);
      expect(state.currentIndex, equals(0));
      expect(state.currentPhotoId, equals('photo1'));
    });

    test('previousPhoto should not go below 0', () {
      notifier
        ..initialize('photo1', ['photo1', 'photo2', 'photo3'])
        ..previousPhoto();

      final state = container.read(photoScreenProvider);
      expect(state.currentIndex, equals(0));
      expect(state.currentPhotoId, equals('photo1'));
    });

    test('setEditing should update editing state', () {
      notifier.setEditing(editing: true);
      expect(container.read(photoScreenProvider).isEditing, isTrue);

      notifier.setEditing(editing: false);
      expect(container.read(photoScreenProvider).isEditing, isFalse);
    });

    test('setSelectedIndex should update index and photo', () {
      notifier
        ..initialize('photo1', ['photo1', 'photo2', 'photo3'])
        ..setSelectedIndex(2);

      final state = container.read(photoScreenProvider);
      expect(state.currentIndex, equals(2));
      expect(state.currentPhotoId, equals('photo3'));
    });

    test('setSelectedIndex with invalid index should not change state', () {
      notifier
        ..initialize('photo1', ['photo1', 'photo2', 'photo3'])
        ..setSelectedIndex(10); // Out of bounds

      final state = container.read(photoScreenProvider);
      expect(state.currentIndex, equals(0)); // Unchanged
      expect(state.currentPhotoId, equals('photo1'));
    });

    test('setSelectedIndex with negative index should not change state', () {
      notifier
        ..initialize('photo2', ['photo1', 'photo2', 'photo3'])
        ..setSelectedIndex(-1);

      final state = container.read(photoScreenProvider);
      expect(state.currentIndex, equals(1)); // Unchanged
    });
  });

  group('Provider independence', () {
    test('multiple containers should have independent state', () {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();

      container1.read(progressProvider.notifier).start(100, 'Container 1');
      container2.read(progressProvider.notifier).start(200, 'Container 2');

      expect(container1.read(progressProvider).total, equals(100.0));
      expect(container2.read(progressProvider).total, equals(200.0));

      container1.dispose();
      container2.dispose();
    });

    test('different providers should be independent', () {
      final container = ProviderContainer();

      container.read(progressProvider.notifier).start(100, 'Progress');
      container.read(percentageDialogProvider.notifier).show('Dialog');
      container.read(swiperTabProvider.notifier).setPhotoIds(['a', 'b']);
      container.read(photoScreenProvider.notifier).initialize('c', ['c', 'd']);

      expect(container.read(progressProvider).text, equals('Progress'));
      expect(container.read(percentageDialogProvider).message, equals('Dialog'));
      expect(container.read(swiperTabProvider).photoIds, equals(['a', 'b']));
      expect(container.read(photoScreenProvider).currentPhotoId, equals('c'));

      container.dispose();
    });
  });

  group('Edge cases', () {
    test('empty photo lists', () {
      final swiperState = SwiperTabState(photoIds: []);
      final photoState = PhotoScreenState(photoIds: []);

      expect(swiperState.photoIds, isEmpty);
      expect(photoState.photoIds, isEmpty);
    });

    test('single photo in list', () {
      final container = ProviderContainer();
      container.read(photoScreenProvider.notifier)
        ..initialize('only', ['only'])
        ..nextPhoto()
        ..previousPhoto();

      expect(container.read(photoScreenProvider).currentIndex, equals(0));

      container.dispose();
    });

    test('progress with zero total', () {
      const state = ProgressState();
      expect(state.total, equals(0.0));
    });

    test('unicode in photo ids', () {
      final state = SwiperTabState(
        photoIds: ['phöto_日本語', '📸_image', 'normal_photo'],
      );
      expect(state.photoIds.length, equals(3));
    });
  });
}
