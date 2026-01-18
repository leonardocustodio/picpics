import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/providers/tags_provider.dart';

/// Unit tests for TagsProvider state management
/// Tests focus on pure state logic without database interactions
/// Database-dependent methods (addTagKeyForFiltering, removeTagKeyFromFiltering,
/// setSearchText) are covered in integration tests
void main() {
  group('TagsState', () {
    test('default constructor should create empty state', () {
      final state = TagsState();

      expect(state.allTags, isEmpty);
      expect(state.mostUsedTags, isEmpty);
      expect(state.lastWeekUsedTags, isEmpty);
      expect(state.lastMonthUsedTags, isEmpty);
      expect(state.recentTagKeyList, isEmpty);
      expect(state.multiPicTags, isEmpty);
      expect(state.searchTagsResults, isEmpty);
      expect(state.searchText, isEmpty);
      expect(state.selectedFilteringTagsKeys, isEmpty);
      expect(state.isSearching, isFalse);
    });

    test('copyWith should preserve unmodified fields', () {
      final initial = TagsState(
        searchText: 'test',
        isSearching: true,
        multiPicTags: {'tag1': ''},
      );

      final updated = initial.copyWith(searchText: 'new text');

      expect(updated.searchText, equals('new text'));
      expect(updated.isSearching, isTrue); // preserved
      expect(updated.multiPicTags, equals({'tag1': ''})); // preserved
    });

    test('copyWith should update specified fields', () {
      final initial = TagsState();

      final updated = initial.copyWith(
        searchText: 'search',
        isSearching: true,
        multiPicTags: {'key1': '', 'key2': ''},
        selectedFilteringTagsKeys: {'filter1': ''},
      );

      expect(updated.searchText, equals('search'));
      expect(updated.isSearching, isTrue);
      expect(updated.multiPicTags.length, equals(2));
      expect(updated.selectedFilteringTagsKeys.length, equals(1));
    });

    test('copyWith with allTags should update tag map', () {
      final tags = {
        'key1': TagModel(key: 'key1', title: 'Tag 1'),
        'key2': TagModel(key: 'key2', title: 'Tag 2'),
      };

      final state = TagsState().copyWith(allTags: tags);

      expect(state.allTags.length, equals(2));
      expect(state.allTags['key1']?.title, equals('Tag 1'));
      expect(state.allTags['key2']?.title, equals('Tag 2'));
    });

    test('copyWith with searchTagsResults should update list', () {
      final results = [
        TagModel(key: 'result1', title: 'Result 1'),
        TagModel(key: 'result2', title: 'Result 2'),
      ];

      final state = TagsState().copyWith(searchTagsResults: results);

      expect(state.searchTagsResults.length, equals(2));
      expect(state.searchTagsResults[0].title, equals('Result 1'));
    });

    test('copyWith should allow clearing collections', () {
      final initial = TagsState(
        multiPicTags: {'tag1': '', 'tag2': ''},
        recentTagKeyList: {'recent1': ''},
      );

      final cleared = initial.copyWith(
        multiPicTags: {},
        recentTagKeyList: {},
      );

      expect(cleared.multiPicTags, isEmpty);
      expect(cleared.recentTagKeyList, isEmpty);
    });

    test('copyWith with mostUsedTags should update', () {
      final mostUsed = {'tag1': 'value1', 'tag2': 'value2'};

      final state = TagsState().copyWith(mostUsedTags: mostUsed);

      expect(state.mostUsedTags.length, equals(2));
      expect(state.mostUsedTags['tag1'], equals('value1'));
    });

    test('copyWith with lastWeekUsedTags and lastMonthUsedTags', () {
      final weekly = {'weekly1': ''};
      final monthly = {'monthly1': '', 'monthly2': ''};

      final state = TagsState().copyWith(
        lastWeekUsedTags: weekly,
        lastMonthUsedTags: monthly,
      );

      expect(state.lastWeekUsedTags.length, equals(1));
      expect(state.lastMonthUsedTags.length, equals(2));
    });

    test('multiple copyWith calls should chain correctly', () {
      final state1 = TagsState();
      final state2 = state1.copyWith(searchText: 'step1');
      final state3 = state2.copyWith(isSearching: true);
      final state4 = state3.copyWith(multiPicTags: {'tag1': ''});

      expect(state4.searchText, equals('step1'));
      expect(state4.isSearching, isTrue);
      expect(state4.multiPicTags.containsKey('tag1'), isTrue);
    });

    test('modifying returned map should not affect other copies of state', () {
      final initial = TagsState(multiPicTags: {'tag1': ''});

      // Create a new state by modifying a copy of the map
      final modifiedMap = Map<String, String>.from(initial.multiPicTags);
      modifiedMap['newKey'] = '';

      final newState = initial.copyWith(multiPicTags: modifiedMap);

      // Original state should be unaffected
      expect(initial.multiPicTags.length, equals(1));
      expect(initial.multiPicTags.containsKey('newKey'), isFalse);

      // New state should have the modification
      expect(newState.multiPicTags.length, equals(2));
      expect(newState.multiPicTags.containsKey('newKey'), isTrue);
    });
  });

  group('TagModel', () {
    test('should create with required fields', () {
      final tag = TagModel(key: 'key1', title: 'Title');

      expect(tag.key, equals('key1'));
      expect(tag.title, equals('Title'));
      expect(tag.count, equals(0)); // default
    });

    test('should create with all fields', () {
      final now = DateTime.now();
      final tag = TagModel(key: 'key1', title: 'Title', count: 5, time: now);

      expect(tag.key, equals('key1'));
      expect(tag.title, equals('Title'));
      expect(tag.count, equals(5));
      expect(tag.time, equals(now));
    });

    test('copyWith should update specified fields', () {
      final original = TagModel(key: 'key1', title: 'Original', count: 1);

      final updated = original.copyWith(title: 'Updated', count: 10);

      expect(updated.key, equals('key1')); // preserved
      expect(updated.title, equals('Updated'));
      expect(updated.count, equals(10));
    });

    test('copyWith with no args should preserve all fields', () {
      final now = DateTime.now();
      final original = TagModel(key: 'key1', title: 'Title', count: 5, time: now);

      final copy = original.copyWith();

      expect(copy.key, equals(original.key));
      expect(copy.title, equals(original.title));
      expect(copy.count, equals(original.count));
      expect(copy.time, equals(original.time));
    });

    test('copyWith should allow updating time', () {
      final original = TagModel(key: 'key1', title: 'Title');
      final newTime = DateTime(2024, 1, 15);

      final updated = original.copyWith(time: newTime);

      expect(updated.time, equals(newTime));
    });

    test('should handle special characters in title', () {
      final tag = TagModel(key: 'key1', title: 'Émoji 🎉 & Spëcîàl');

      expect(tag.title, equals('Émoji 🎉 & Spëcîàl'));
    });

    test('should handle empty title', () {
      final tag = TagModel(key: 'key1', title: '');

      expect(tag.title, isEmpty);
    });

    test('should handle zero count', () {
      final tag = TagModel(key: 'key1', title: 'Title');

      expect(tag.count, equals(0));
    });

    test('should handle large count values', () {
      final tag = TagModel(key: 'key1', title: 'Title', count: 999999);

      expect(tag.count, equals(999999));
    });
  });

  group('TagsState selectedFilteringTagsKeys manipulation', () {
    test('copyWith can add to selectedFilteringTagsKeys', () {
      final initial = TagsState();

      final newFiltering = Map<String, String>.from(initial.selectedFilteringTagsKeys);
      newFiltering['tag1'] = '';

      final updated = initial.copyWith(selectedFilteringTagsKeys: newFiltering);

      expect(updated.selectedFilteringTagsKeys.containsKey('tag1'), isTrue);
      expect(updated.selectedFilteringTagsKeys.length, equals(1));
    });

    test('copyWith can remove from selectedFilteringTagsKeys', () {
      final initial = TagsState(
        selectedFilteringTagsKeys: {'tag1': '', 'tag2': '', 'tag3': ''},
      );

      final newFiltering = Map<String, String>.from(initial.selectedFilteringTagsKeys)..remove('tag2');

      final updated = initial.copyWith(selectedFilteringTagsKeys: newFiltering);

      expect(updated.selectedFilteringTagsKeys.length, equals(2));
      expect(updated.selectedFilteringTagsKeys.containsKey('tag1'), isTrue);
      expect(updated.selectedFilteringTagsKeys.containsKey('tag2'), isFalse);
      expect(updated.selectedFilteringTagsKeys.containsKey('tag3'), isTrue);
    });

    test('copyWith can clear selectedFilteringTagsKeys', () {
      final initial = TagsState(
        selectedFilteringTagsKeys: {'tag1': '', 'tag2': ''},
      );

      final updated = initial.copyWith(selectedFilteringTagsKeys: {});

      expect(updated.selectedFilteringTagsKeys, isEmpty);
    });
  });

  group('TagsState multiPicTags manipulation', () {
    test('copyWith can add to multiPicTags', () {
      final initial = TagsState();

      final newMulti = Map<String, String>.from(initial.multiPicTags);
      newMulti['tag1'] = '';

      final updated = initial.copyWith(multiPicTags: newMulti);

      expect(updated.multiPicTags.containsKey('tag1'), isTrue);
    });

    test('copyWith can remove from multiPicTags', () {
      final initial = TagsState(multiPicTags: {'tag1': '', 'tag2': ''});

      final newMulti = Map<String, String>.from(initial.multiPicTags)..remove('tag1');

      final updated = initial.copyWith(multiPicTags: newMulti);

      expect(updated.multiPicTags.containsKey('tag1'), isFalse);
      expect(updated.multiPicTags.containsKey('tag2'), isTrue);
    });

    test('copyWith can clear multiPicTags', () {
      final initial = TagsState(multiPicTags: {'tag1': '', 'tag2': '', 'tag3': ''});

      final updated = initial.copyWith(multiPicTags: {});

      expect(updated.multiPicTags, isEmpty);
    });
  });

  group('TagsState recentTagKeyList manipulation', () {
    test('copyWith can add to recentTagKeyList', () {
      final initial = TagsState();

      final newRecent = Map<String, String>.from(initial.recentTagKeyList);
      newRecent['recent1'] = '';

      final updated = initial.copyWith(recentTagKeyList: newRecent);

      expect(updated.recentTagKeyList.containsKey('recent1'), isTrue);
    });

    test('copyWith can manage multiple recent tags', () {
      final recent = {'r1': '', 'r2': '', 'r3': '', 'r4': '', 'r5': ''};

      final state = TagsState().copyWith(recentTagKeyList: recent);

      expect(state.recentTagKeyList.length, equals(5));
    });
  });

  group('TagsState isSearching manipulation', () {
    test('copyWith can set isSearching to true', () {
      final initial = TagsState();

      final updated = initial.copyWith(isSearching: true);

      expect(updated.isSearching, isTrue);
    });

    test('copyWith can set isSearching to false', () {
      final initial = TagsState(isSearching: true);

      final updated = initial.copyWith(isSearching: false);

      expect(updated.isSearching, isFalse);
    });

    test('setting isSearching false does not automatically clear filtering (state only)', () {
      // Note: In the actual notifier, setIsSearching(val: false) clears filtering
      // But at the state level, copyWith doesn't have that logic
      final initial = TagsState(
        isSearching: true,
        selectedFilteringTagsKeys: {'filter1': ''},
      );

      final updated = initial.copyWith(isSearching: false);

      // State level doesn't clear - that's notifier logic
      expect(updated.isSearching, isFalse);
      expect(updated.selectedFilteringTagsKeys.containsKey('filter1'), isTrue);
    });
  });

  group('TagsState searchText manipulation', () {
    test('copyWith can set searchText', () {
      final initial = TagsState();

      final updated = initial.copyWith(searchText: 'hello world');

      expect(updated.searchText, equals('hello world'));
    });

    test('copyWith can clear searchText', () {
      final initial = TagsState(searchText: 'some text');

      final updated = initial.copyWith(searchText: '');

      expect(updated.searchText, isEmpty);
    });

    test('searchText preserves unicode', () {
      final state = TagsState().copyWith(searchText: '日本語 🎉');

      expect(state.searchText, equals('日本語 🎉'));
    });
  });

  group('TagsState allTags manipulation', () {
    test('can build allTags map from multiple tags', () {
      final tags = <String, TagModel>{};
      tags['key1'] = TagModel(key: 'key1', title: 'Vacation', count: 10);
      tags['key2'] = TagModel(key: 'key2', title: 'Family', count: 25);
      tags['key3'] = TagModel(key: 'key3', title: 'Work', count: 5);

      final state = TagsState().copyWith(allTags: tags);

      expect(state.allTags.length, equals(3));
      expect(state.allTags['key1']?.count, equals(10));
      expect(state.allTags['key2']?.count, equals(25));
      expect(state.allTags['key3']?.count, equals(5));
    });

    test('allTags can be updated incrementally via copyWith', () {
      final initial = TagsState(
        allTags: {'key1': TagModel(key: 'key1', title: 'Tag1')},
      );

      final newTags = Map<String, TagModel>.from(initial.allTags);
      newTags['key2'] = TagModel(key: 'key2', title: 'Tag2');

      final updated = initial.copyWith(allTags: newTags);

      expect(updated.allTags.length, equals(2));
    });

    test('allTags can have tag removed via copyWith', () {
      final initial = TagsState(
        allTags: {
          'key1': TagModel(key: 'key1', title: 'Tag1'),
          'key2': TagModel(key: 'key2', title: 'Tag2'),
        },
      );

      final newTags = Map<String, TagModel>.from(initial.allTags)..remove('key1');

      final updated = initial.copyWith(allTags: newTags);

      expect(updated.allTags.length, equals(1));
      expect(updated.allTags.containsKey('key1'), isFalse);
      expect(updated.allTags.containsKey('key2'), isTrue);
    });
  });

  group('TagsState searchTagsResults manipulation', () {
    test('can set searchTagsResults', () {
      final results = [
        TagModel(key: 'r1', title: 'Result 1'),
        TagModel(key: 'r2', title: 'Result 2'),
        TagModel(key: 'r3', title: 'Result 3'),
      ];

      final state = TagsState().copyWith(searchTagsResults: results);

      expect(state.searchTagsResults.length, equals(3));
      expect(state.searchTagsResults[0].title, equals('Result 1'));
      expect(state.searchTagsResults[2].title, equals('Result 3'));
    });

    test('can clear searchTagsResults', () {
      final initial = TagsState(
        searchTagsResults: [TagModel(key: 'r1', title: 'Result')],
      );

      final updated = initial.copyWith(searchTagsResults: []);

      expect(updated.searchTagsResults, isEmpty);
    });

    test('searchTagsResults order is preserved', () {
      final results = [
        TagModel(key: 'z', title: 'Zebra'),
        TagModel(key: 'a', title: 'Apple'),
        TagModel(key: 'm', title: 'Mango'),
      ];

      final state = TagsState().copyWith(searchTagsResults: results);

      expect(state.searchTagsResults[0].key, equals('z'));
      expect(state.searchTagsResults[1].key, equals('a'));
      expect(state.searchTagsResults[2].key, equals('m'));
    });
  });

  group('Complex state scenarios', () {
    test('full search state setup', () {
      final allTags = {
        'vacation': TagModel(key: 'vacation', title: 'Vacation', count: 15),
        'beach': TagModel(key: 'beach', title: 'Beach', count: 8),
        'sunset': TagModel(key: 'sunset', title: 'Sunset', count: 12),
      };

      final searchResults = [
        TagModel(key: 'sunset', title: 'Sunset', count: 12),
      ];

      final state = TagsState(
        allTags: allTags,
        searchText: 'sun',
        isSearching: true,
        searchTagsResults: searchResults,
        selectedFilteringTagsKeys: {'vacation': ''},
      );

      expect(state.allTags.length, equals(3));
      expect(state.searchText, equals('sun'));
      expect(state.isSearching, isTrue);
      expect(state.searchTagsResults.length, equals(1));
      expect(state.selectedFilteringTagsKeys.length, equals(1));
    });

    test('multi-pic tagging state setup', () {
      final state = TagsState(
        multiPicTags: {'tag1': '', 'tag2': '', 'tag3': ''},
        recentTagKeyList: {'tag1': '', 'tag4': ''},
        allTags: {
          'tag1': TagModel(key: 'tag1', title: 'Tag 1'),
          'tag2': TagModel(key: 'tag2', title: 'Tag 2'),
          'tag3': TagModel(key: 'tag3', title: 'Tag 3'),
          'tag4': TagModel(key: 'tag4', title: 'Tag 4'),
        },
      );

      expect(state.multiPicTags.length, equals(3));
      expect(state.recentTagKeyList.length, equals(2));
      expect(state.allTags.length, equals(4));
    });

    test('state reset simulation', () {
      final populated = TagsState(
        searchText: 'test',
        isSearching: true,
        multiPicTags: {'tag1': ''},
        selectedFilteringTagsKeys: {'filter1': ''},
        recentTagKeyList: {'recent1': ''},
      );

      // Simulate full reset
      final reset = populated.copyWith(
        searchText: '',
        isSearching: false,
        multiPicTags: {},
        selectedFilteringTagsKeys: {},
        searchTagsResults: [],
      );

      expect(reset.searchText, isEmpty);
      expect(reset.isSearching, isFalse);
      expect(reset.multiPicTags, isEmpty);
      expect(reset.selectedFilteringTagsKeys, isEmpty);
      expect(reset.searchTagsResults, isEmpty);
      // recentTagKeyList is preserved (not reset)
      expect(reset.recentTagKeyList.containsKey('recent1'), isTrue);
    });
  });
}
