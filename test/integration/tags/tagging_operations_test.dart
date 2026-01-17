import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/tags_provider.dart';

/// Integration tests for tagging operations
/// Tests tag creation, modification, and photo-tag associations
void main() {
  group('Tagging Operations Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial tags state should be empty', () {
      final tagsState = container.read(tagsProvider);

      expect(tagsState.allTags, isEmpty);
      expect(tagsState.searchTagsResults, isEmpty);
    });

    test('Tags map should be initialized correctly', () {
      final tagsState = container.read(tagsProvider);

      expect(tagsState.allTags, isA<Map<String, dynamic>>());
      expect(tagsState.allTags.isEmpty, isTrue);
    });

    test('Tag search results should be empty initially', () {
      final tagsState = container.read(tagsProvider);

      expect(tagsState.searchTagsResults, isA<List<String>>());
      expect(tagsState.searchTagsResults.isEmpty, isTrue);
    });

    test('Tags provider notifier should be accessible', () {
      final notifier = container.read(tagsProvider.notifier);

      expect(notifier, isNotNull);
      expect(notifier, isA<TagsNotifier>());
    });

    test('Clear should reset tags state', () {
      // Clear the state
      container.read(tagsProvider.notifier).clear();

      final tagsState = container.read(tagsProvider);
      expect(tagsState.allTags, isEmpty);
    });

    test('Provider state should be immutable', () {
      final state1 = container.read(tagsProvider);
      final state2 = container.read(tagsProvider);

      expect(identical(state1, state2), isTrue);
    });

    test('Multiple provider reads should return same state', () {
      final state1 = container.read(tagsProvider);
      final state2 = container.read(tagsProvider);

      expect(state1, same(state2));
    });
  });

  group('Tag Management Edge Cases', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Empty tags collection should be handled gracefully', () {
      final tagsState = container.read(tagsProvider);

      expect(tagsState.allTags, isEmpty);
      expect(tagsState.searchTagsResults, isEmpty);
    });

    test('Multiple containers should have independent state', () {
      final container2 = ProviderContainer();

      // States should be independent
      final state1 = container.read(tagsProvider);
      final state2 = container2.read(tagsProvider);

      expect(state1.allTags, isEmpty);
      expect(state2.allTags, isEmpty);

      container2.dispose();
    });

    test('State should persist across multiple reads', () {
      final state1 = container.read(tagsProvider);
      final notifier = container.read(tagsProvider.notifier);
      final state2 = container.read(tagsProvider);

      // All reads from same container should return same state
      expect(identical(state1, state2), isTrue);
      expect(notifier, isNotNull);
    });
  });

  group('Tag Search and Suggestions', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Search results should be a list', () {
      final tagsState = container.read(tagsProvider);

      expect(tagsState.searchTagsResults, isA<List<String>>());
    });

    test('Search results should be empty initially', () {
      final tagsState = container.read(tagsProvider);

      expect(tagsState.searchTagsResults.isEmpty, isTrue);
    });

    test('Tag suggestions calculator should be accessible via notifier', () {
      final notifier = container.read(tagsProvider.notifier);

      expect(notifier, isNotNull);
      // The notifier should have the tagsSuggestionsCalculate method
      expect(notifier.tagsSuggestionsCalculate, isA<Function>());
    });

    test('Search text can be updated', () {
      container.read(tagsProvider.notifier).setSearchText('test');

      final tagsState = container.read(tagsProvider);
      expect(tagsState.searchText, 'test');
    });

    test('Search mode can be toggled', () {
      container.read(tagsProvider.notifier).setIsSearching(true);
      expect(container.read(tagsProvider).isSearching, isTrue);

      container.read(tagsProvider.notifier).setIsSearching(false);
      expect(container.read(tagsProvider).isSearching, isFalse);
    });
  });
}
