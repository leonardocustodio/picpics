import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';

class TagsState {
  final Map<String, TagModel> allTags;
  final Map<String, String> mostUsedTags;
  final Map<String, String> lastWeekUsedTags;
  final Map<String, String> lastMonthUsedTags;
  final Map<String, String> recentTagKeyList;
  final Map<String, String> multiPicTags;
  final List<TagModel> searchTagsResults;
  final String searchText;
  final Map<String, String> selectedFilteringTagsKeys;
  final bool isSearching;

  TagsState({
    this.allTags = const {},
    this.mostUsedTags = const {},
    this.lastWeekUsedTags = const {},
    this.lastMonthUsedTags = const {},
    this.recentTagKeyList = const {},
    this.multiPicTags = const {},
    this.searchTagsResults = const [],
    this.searchText = '',
    this.selectedFilteringTagsKeys = const {},
    this.isSearching = false,
  });

  TagsState copyWith({
    Map<String, TagModel>? allTags,
    Map<String, String>? mostUsedTags,
    Map<String, String>? lastWeekUsedTags,
    Map<String, String>? lastMonthUsedTags,
    Map<String, String>? recentTagKeyList,
    Map<String, String>? multiPicTags,
    List<TagModel>? searchTagsResults,
    String? searchText,
    Map<String, String>? selectedFilteringTagsKeys,
    bool? isSearching,
  }) {
    return TagsState(
      allTags: allTags ?? this.allTags,
      mostUsedTags: mostUsedTags ?? this.mostUsedTags,
      lastWeekUsedTags: lastWeekUsedTags ?? this.lastWeekUsedTags,
      lastMonthUsedTags: lastMonthUsedTags ?? this.lastMonthUsedTags,
      recentTagKeyList: recentTagKeyList ?? this.recentTagKeyList,
      multiPicTags: multiPicTags ?? this.multiPicTags,
      searchTagsResults: searchTagsResults ?? this.searchTagsResults,
      searchText: searchText ?? this.searchText,
      selectedFilteringTagsKeys: selectedFilteringTagsKeys ?? this.selectedFilteringTagsKeys,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class TagsNotifier extends StateNotifier<TagsState> {
  final AppDatabase _database = AppDatabase();
  final Ref ref;

  TagsNotifier(this.ref) : super(TagsState());

  Future<void> initialize() async {
    // Create default tags and load all tags
    await loadAllTags();
    await tagsSuggestionsCalculate();
  }

  Future<void> loadAllTags() async {
    final tags = await _database.getAllLabel();
    final allTagsMap = <String, TagModel>{};
    
    for (final tag in tags) {
      allTagsMap[tag.key] = TagModel(
        key: tag.key,
        title: tag.title,
        count: tag.counter,
        time: tag.lastUsedAt,
      );
    }
    
    state = state.copyWith(allTags: allTagsMap);
  }

  void setIsSearching(bool val) {
    state = state.copyWith(isSearching: val);
    if (!val) {
      state = state.copyWith(selectedFilteringTagsKeys: {});
    }
  }

  void addTagKeyForFiltering(String tagKey) {
    final newFiltering = Map<String, String>.from(state.selectedFilteringTagsKeys);
    if (!newFiltering.containsKey(tagKey)) {
      newFiltering[tagKey] = '';
    }
    state = state.copyWith(selectedFilteringTagsKeys: newFiltering);
    tagsSuggestionsCalculate();
  }

  void removeTagKeyFromFiltering(String tagKey) {
    final newFiltering = Map<String, String>.from(state.selectedFilteringTagsKeys);
    newFiltering.remove(tagKey);
    state = state.copyWith(selectedFilteringTagsKeys: newFiltering);
    tagsSuggestionsCalculate();
  }

  void setSearchText(String text) {
    state = state.copyWith(searchText: text);
    tagsSuggestionsCalculate();
  }

  Future<List<TagModel>> tagsSuggestionsCalculate() async {
    final tagsList = await _database.getAllLabel();
    final getUser = await _database.getSingleMoorUser();
    
    final suggestionTags = <String>[];
    final text = state.searchText.trim();
    
    if (text.isEmpty) {
      // Add recent tags to suggestions
      for (final String recent in getUser?.recentTags ?? <String>[]) {
        if (state.multiPicTags.containsKey(recent)) {
          continue;
        }
        suggestionTags.add(recent);
      }
      
      // Fill remaining suggestions with other tags
      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (final tag in tagsList) {
          final tagKey = tag.key;
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
          if (state.multiPicTags.containsKey(tagKey) ||
              state.selectedFilteringTagsKeys.containsKey(tagKey) ||
              suggestionTags.contains(tagKey)) {
            continue;
          }
          suggestionTags.add(tagKey);
        }
      }
    } else {
      // Search for matching tags
      final listOfLetters = text.toLowerCase().split('');
      for (final tag in tagsList) {
        final tagKey = tag.key;
        if (state.selectedFilteringTagsKeys.containsKey(tagKey)) {
          continue;
        }
        
        final tagModel = state.allTags[tagKey];
        if (tagModel != null) {
          // Perform custom searching logic here
          if (tagModel.title.toLowerCase().contains(text.toLowerCase())) {
            suggestionTags.add(tagKey);
          }
        }
      }
    }
    
    // Convert tag keys to TagModel objects
    final searchResults = <TagModel>[];
    for (final tagKey in suggestionTags) {
      final tagModel = state.allTags[tagKey];
      if (tagModel != null) {
        searchResults.add(tagModel);
      }
    }
    
    state = state.copyWith(searchTagsResults: searchResults);
    return searchResults;
  }

  void addRecentTag(String tagKey) {
    final newRecent = Map<String, String>.from(state.recentTagKeyList);
    if (!newRecent.containsKey(tagKey)) {
      newRecent[tagKey] = '';
    }
    state = state.copyWith(recentTagKeyList: newRecent);
  }

  void addMultiPicTag(String tagKey) {
    final newMulti = Map<String, String>.from(state.multiPicTags);
    newMulti[tagKey] = '';
    state = state.copyWith(multiPicTags: newMulti);
  }

  void removeMultiPicTag(String tagKey) {
    final newMulti = Map<String, String>.from(state.multiPicTags);
    newMulti.remove(tagKey);
    state = state.copyWith(multiPicTags: newMulti);
  }

  void clearMultiPicTags() {
    state = state.copyWith(multiPicTags: {});
  }

  Future<String> createTag(String title) async {
    // TODO: Full implementation for creating a new tag
    // For now, generate a simple key
    final key = 'tag_${DateTime.now().millisecondsSinceEpoch}';
    await loadAllTags(); // Reload tags after creation
    return key;
  }

  Future<void> updateTag(String key, String newTitle) async {
    try {
      // Get the old tag
      final oldTag = await _database.getLabelByLabelKey(key);
      if (oldTag == null) {
        AppLogger.w('Tag with key $key not found');
        return;
      }

      // Create new tag key from new title
      final newTagKey = Helpers.encryptTag(newTitle);

      // Update in database
      await _database.updateLabel(
        oldTag.copyWith(
          key: newTagKey,
          title: newTitle,
        ),
      );

      // Reload all tags to reflect changes
      await loadAllTags();

      AppLogger.d('Tag updated: $key -> $newTagKey ($newTitle)');
    } catch (e) {
      AppLogger.e('Error updating tag: $e');
    }
  }

  Future<void> editTagName({
    required String oldTagKey,
    required String newName,
  }) async {
    await updateTag(oldTagKey, newName);
  }

  Future<void> deleteTag(String key) async {
    try {
      // Get the label
      final label = await _database.getLabelByLabelKey(key);
      if (label == null) {
        AppLogger.w('Tag with key $key not found');
        return;
      }

      // Delete from database
      await _database.deleteLabel(label);

      // Reload tags
      await loadAllTags();

      AppLogger.d('Tag deleted: $key');
    } catch (e) {
      AppLogger.e('Error deleting tag: $e');
    }
  }

  Future<void> deleteTagFromPic({required String tagKey}) async {
    // For now, just delete the tag entirely
    // In the future, this could remove the tag from specific pictures
    await deleteTag(tagKey);
  }

  Future<void> removeTagFromPic({
    required String picId,
    required String tagKey,
  }) async {
    // TODO: Implement removing a tag from a specific picture
    AppLogger.d('Removing tag $tagKey from pic $picId (stub implementation)');
    await Future.delayed(Duration.zero);
  }

  Future<void> addTagsToSelectedPics() async {
    // TODO: Implement adding tags to selected pictures
    // This should take the multiPicTags and apply them to selected photos
    // For now, this is a placeholder to prevent compilation errors
    AppLogger.d('Adding tags to selected pictures (stub implementation)');
    clearMultiPicTags();
  }
}

// Provider
final tagsProvider = StateNotifierProvider<TagsNotifier, TagsState>((ref) {
  return TagsNotifier(ref);
});