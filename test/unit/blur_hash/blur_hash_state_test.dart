import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/blur_hash_provider.dart';

/// Unit tests for BlurHashState
/// Tests focus on pure state management without database interactions
void main() {
  group('BlurHashState', () {
    group('Constructor and defaults', () {
      test('default constructor should create empty state', () {
        final state = BlurHashState();

        expect(state.blurHashes, isEmpty);
        expect(state.isEnabled, isTrue);
        expect(state.isGenerating, isFalse);
      });

      test('constructor with all parameters', () {
        final state = BlurHashState(
          blurHashes: {'photo1': 'hash1', 'photo2': 'hash2'},
          isEnabled: false,
          isGenerating: true,
        );

        expect(state.blurHashes.length, equals(2));
        expect(state.blurHashes['photo1'], equals('hash1'));
        expect(state.isEnabled, isFalse);
        expect(state.isGenerating, isTrue);
      });

      test('blurHash alias should return blurHashes', () {
        final state = BlurHashState(
          blurHashes: {'photo1': 'hash1'},
        );

        expect(state.blurHash, equals(state.blurHashes));
      });
    });

    group('copyWith', () {
      test('copyWith with no arguments should preserve all values', () {
        final original = BlurHashState(
          blurHashes: {'photo1': 'hash1'},
          isEnabled: false,
          isGenerating: true,
        );

        final copy = original.copyWith();

        expect(copy.blurHashes, equals(original.blurHashes));
        expect(copy.isEnabled, equals(original.isEnabled));
        expect(copy.isGenerating, equals(original.isGenerating));
      });

      test('copyWith should update only specified fields', () {
        final original = BlurHashState(
          blurHashes: {'photo1': 'hash1'},
        );

        final updated = original.copyWith(isEnabled: false);

        expect(updated.blurHashes, equals(original.blurHashes));
        expect(updated.isEnabled, isFalse);
        expect(updated.isGenerating, equals(original.isGenerating));
      });

      test('copyWith blurHashes', () {
        final state = BlurHashState().copyWith(
          blurHashes: {'photo1': 'hash1', 'photo2': 'hash2'},
        );

        expect(state.blurHashes.length, equals(2));
        expect(state.blurHashes['photo1'], equals('hash1'));
        expect(state.blurHashes['photo2'], equals('hash2'));
      });

      test('copyWith isEnabled', () {
        final state = BlurHashState().copyWith(isEnabled: false);
        expect(state.isEnabled, isFalse);

        final enabled = state.copyWith(isEnabled: true);
        expect(enabled.isEnabled, isTrue);
      });

      test('copyWith isGenerating', () {
        final state = BlurHashState().copyWith(isGenerating: true);
        expect(state.isGenerating, isTrue);

        final notGenerating = state.copyWith(isGenerating: false);
        expect(notGenerating.isGenerating, isFalse);
      });

      test('copyWith multiple fields at once', () {
        final state = BlurHashState().copyWith(
          blurHashes: {'id': 'hash'},
          isEnabled: false,
          isGenerating: true,
        );

        expect(state.blurHashes['id'], equals('hash'));
        expect(state.isEnabled, isFalse);
        expect(state.isGenerating, isTrue);
      });

      test('chained copyWith calls', () {
        final state1 = BlurHashState();
        final state2 = state1.copyWith(isEnabled: false);
        final state3 = state2.copyWith(isGenerating: true);
        final state4 = state3.copyWith(blurHashes: {'photo': 'hash'});

        expect(state4.isEnabled, isFalse);
        expect(state4.isGenerating, isTrue);
        expect(state4.blurHashes['photo'], equals('hash'));
      });
    });

    group('State transitions', () {
      test('simulate enabling blur hash feature', () {
        var state = BlurHashState(isEnabled: false);

        state = state.copyWith(isEnabled: true);
        expect(state.isEnabled, isTrue);
      });

      test('simulate disabling blur hash feature', () {
        var state = BlurHashState();

        state = state.copyWith(isEnabled: false);
        expect(state.isEnabled, isFalse);
      });

      test('simulate blur hash generation workflow', () {
        var state = BlurHashState();

        // Start generating
        state = state.copyWith(isGenerating: true);
        expect(state.isGenerating, isTrue);

        // Add generated hash
        final hashes = Map<String, String>.from(state.blurHashes);
        hashes['photo1'] = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
        state = state.copyWith(
          blurHashes: hashes,
          isGenerating: false,
        );

        expect(state.isGenerating, isFalse);
        expect(state.blurHashes['photo1'], isNotEmpty);
      });

      test('simulate batch blur hash generation', () {
        var state = BlurHashState();

        // Add multiple hashes
        final hashes = <String, String>{
          'photo1': 'hash1',
          'photo2': 'hash2',
          'photo3': 'hash3',
        };

        state = state.copyWith(blurHashes: hashes);

        expect(state.blurHashes.length, equals(3));
        expect(state.blurHashes.containsKey('photo1'), isTrue);
        expect(state.blurHashes.containsKey('photo2'), isTrue);
        expect(state.blurHashes.containsKey('photo3'), isTrue);
      });

      test('simulate clearing blur hashes', () {
        var state = BlurHashState(
          blurHashes: {'photo1': 'hash1', 'photo2': 'hash2'},
        );

        state = state.copyWith(blurHashes: {});

        expect(state.blurHashes, isEmpty);
      });
    });

    group('Edge cases', () {
      test('empty blur hash map', () {
        final state = BlurHashState(blurHashes: {});
        expect(state.blurHashes, isEmpty);
      });

      test('large number of blur hashes', () {
        final hashes = <String, String>{};
        for (var i = 0; i < 1000; i++) {
          hashes['photo$i'] = 'hash$i';
        }

        final state = BlurHashState(blurHashes: hashes);
        expect(state.blurHashes.length, equals(1000));
      });

      test('special characters in photo id', () {
        final state = BlurHashState(
          blurHashes: {
            'photo/with/slashes': 'hash1',
            'photo:with:colons': 'hash2',
            'photo with spaces': 'hash3',
          },
        );

        expect(state.blurHashes['photo/with/slashes'], equals('hash1'));
        expect(state.blurHashes['photo:with:colons'], equals('hash2'));
        expect(state.blurHashes['photo with spaces'], equals('hash3'));
      });

      test('unicode in photo id', () {
        final state = BlurHashState(
          blurHashes: {'phöto_日本語': 'hash1'},
        );

        expect(state.blurHashes['phöto_日本語'], equals('hash1'));
      });

      test('very long blur hash string', () {
        final longHash = 'A' * 1000;
        final state = BlurHashState(
          blurHashes: {'photo1': longHash},
        );

        expect(state.blurHashes['photo1']?.length, equals(1000));
      });
    });

    group('Map immutability', () {
      test('modifying original map should not affect state when using copyWith', () {
        final originalHashes = {'photo1': 'hash1'};
        final state = BlurHashState(blurHashes: originalHashes);

        // Create a new state with modified hashes
        final modifiedHashes = Map<String, String>.from(state.blurHashes);
        modifiedHashes['photo2'] = 'hash2';
        final newState = state.copyWith(blurHashes: modifiedHashes);

        // Original state should be unchanged
        expect(state.blurHashes.length, equals(1));
        expect(newState.blurHashes.length, equals(2));
      });

      test('adding hash via copyWith should not modify original', () {
        final state1 = BlurHashState(blurHashes: {'photo1': 'hash1'});

        final hashes = Map<String, String>.from(state1.blurHashes);
        hashes['photo2'] = 'hash2';
        final state2 = state1.copyWith(blurHashes: hashes);

        expect(state1.blurHashes.length, equals(1));
        expect(state2.blurHashes.length, equals(2));
      });
    });

    group('Boolean state combinations', () {
      test('default booleans', () {
        final state = BlurHashState();

        expect(state.isEnabled, isTrue);
        expect(state.isGenerating, isFalse);
      });

      test('all booleans false', () {
        final state = BlurHashState(
          isEnabled: false,
        );

        expect(state.isEnabled, isFalse);
        expect(state.isGenerating, isFalse);
      });

      test('all booleans true', () {
        final state = BlurHashState(
          isGenerating: true,
        );

        expect(state.isEnabled, isTrue);
        expect(state.isGenerating, isTrue);
      });

      test('toggle isEnabled', () {
        var state = BlurHashState();

        state = state.copyWith(isEnabled: false);
        expect(state.isEnabled, isFalse);

        state = state.copyWith(isEnabled: true);
        expect(state.isEnabled, isTrue);
      });

      test('toggle isGenerating', () {
        var state = BlurHashState();

        state = state.copyWith(isGenerating: true);
        expect(state.isGenerating, isTrue);

        state = state.copyWith(isGenerating: false);
        expect(state.isGenerating, isFalse);
      });
    });

    group('Helper pattern tests', () {
      test('check if hash exists for photo', () {
        final state = BlurHashState(
          blurHashes: {'photo1': 'hash1'},
        );

        expect(state.blurHashes.containsKey('photo1'), isTrue);
        expect(state.blurHashes.containsKey('photo2'), isFalse);
      });

      test('get hash with null safety', () {
        final state = BlurHashState(
          blurHashes: {'photo1': 'hash1'},
        );

        expect(state.blurHashes['photo1'], equals('hash1'));
        expect(state.blurHashes['nonexistent'], isNull);
      });

      test('check if generating and has hashes', () {
        final state = BlurHashState(
          blurHashes: {'photo1': 'hash1'},
          isGenerating: true,
        );

        expect(state.isGenerating && state.blurHashes.isNotEmpty, isTrue);
      });

      test('check if feature enabled but no hashes', () {
        final state = BlurHashState();

        expect(state.isEnabled && state.blurHashes.isEmpty, isTrue);
      });
    });
  });
}
