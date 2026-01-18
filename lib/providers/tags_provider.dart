import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';

class TagsState {
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
  TagsNotifier(this.ref) : super(TagsState());
  final AppDatabase _database = AppDatabase();
  final Ref ref;

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

  void setIsSearching({required bool val}) {
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
    unawaited(tagsSuggestionsCalculate());
  }

  void removeTagKeyFromFiltering(String tagKey) {
    final newFiltering = Map<String, String>.from(state.selectedFilteringTagsKeys)..remove(tagKey);
    state = state.copyWith(selectedFilteringTagsKeys: newFiltering);
    unawaited(tagsSuggestionsCalculate());
  }

  void setSearchText(String text) {
    state = state.copyWith(searchText: text);
    unawaited(tagsSuggestionsCalculate());
  }

  Future<List<TagModel>> tagsSuggestionsCalculate() async {
    final tagsList = await _database.getAllLabel();
    final getUser = await _database.getSingleMoorUser();

    final suggestionTags = <String>[];
    final text = state.searchText.trim();

    if (text.isEmpty) {
      // Add recent tags to suggestions
      for (final recent in getUser?.recentTags ?? <String>[]) {
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
    final newMulti = Map<String, String>.from(state.multiPicTags)..remove(tagKey);
    state = state.copyWith(multiPicTags: newMulti);
  }

  void clearMultiPicTags() {
    state = state.copyWith(multiPicTags: {});
  }

  void clear() {
    clearMultiPicTags();
  }

  Future<String> createTag(String title) async {
    try {
      // Generate encrypted key from title
      final tagKey = Helpers.encryptTag(title);

      // Check if tag already exists
      final existingTag = await _database.getLabelByLabelKey(tagKey);
      if (existingTag != null) {
        AppLogger.d('Tag already exists: $tagKey');
        return tagKey;
      }

      // Create new label in database
      final label = Label(
        key: tagKey,
        title: title,
        counter: 0,
        lastUsedAt: DateTime.now(),
        photoId: {},
      );

      await _database.createLabel(label);

      // Add to allTags state
      final newAllTags = Map<String, TagModel>.from(state.allTags);
      newAllTags[tagKey] = TagModel(
        key: tagKey,
        title: title,
        time: DateTime.now(),
      );
      state = state.copyWith(allTags: newAllTags);

      AppLogger.d('Created new tag: $title with key: $tagKey');
      return tagKey;
    } on Exception catch (e) {
      AppLogger.e('Error creating tag: $e');
      rethrow;
    }
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
    } on Exception catch (e) {
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
    } on Exception catch (e) {
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
    try {
      // Get the photo from database
      final photo = await _database.getPhotoByPhotoId(picId);
      if (photo == null) {
        AppLogger.w('Photo $picId not found');
        return;
      }

      // Remove the tag from photo
      photo.tags.remove(tagKey);
      await _database.updatePhoto(photo);

      // Update the label to remove photo reference
      final label = await _database.getLabelByLabelKey(tagKey);
      if (label != null) {
        label.photoId.remove(picId);
        final newCounter = label.counter > 0 ? label.counter - 1 : 0;
        await _database.updateLabel(label.copyWith(counter: newCounter));

        // Update allTags state
        final newAllTags = Map<String, TagModel>.from(state.allTags);
        if (newAllTags.containsKey(tagKey)) {
          newAllTags[tagKey] = newAllTags[tagKey]!.copyWith(count: newCounter);
          state = state.copyWith(allTags: newAllTags);
        }
      }

      AppLogger.d('Removed tag $tagKey from pic $picId');
    } on Exception catch (e) {
      AppLogger.e('Error removing tag from pic: $e');
    }
  }

  Future<void> addTagsToSelectedPics({
    List<String>? selectedPicIds,
  }) async {
    if (state.multiPicTags.isEmpty) {
      AppLogger.d('No multi-pic tags to add');
      clearMultiPicTags();
      return;
    }

    // If no pics specified, just clear and return
    if (selectedPicIds == null || selectedPicIds.isEmpty) {
      AppLogger.d('No pics selected for tagging');
      clearMultiPicTags();
      return;
    }

    try {
      for (final tagKey in state.multiPicTags.keys) {
        // Get or create the label
        final label = await _database.getLabelByLabelKey(tagKey);
        if (label == null) {
          // Tag doesn't exist, skip
          AppLogger.w('Tag $tagKey not found, skipping');
          continue;
        }

        for (final picId in selectedPicIds) {
          // Get or create the photo
          var photo = await _database.getPhotoByPhotoId(picId);
          if (photo == null) {
            // Create new photo entry
            photo = Photo(
              id: picId,
              createdAt: DateTime.now(),
              tags: {tagKey: ''},
              isStarred: false,
              isPrivate: false,
              deletedFromCameraRoll: false,
            );
            await _database.createPhoto(photo);
          } else {
            // Add tag to existing photo
            if (!photo.tags.containsKey(tagKey)) {
              photo.tags[tagKey] = '';
              await _database.updatePhoto(photo);
            }
          }

          // Update label with photo reference
          if (!label.photoId.containsKey(picId)) {
            label.photoId[picId] = '';
          }
        }

        // Update label counter (photoId is a Map, use length)
        final updatedLabel = label.copyWith(
          counter: label.photoId.length,
          lastUsedAt: DateTime.now(),
        );
        await _database.updateLabel(updatedLabel);

        // Update allTags state
        final newAllTags = Map<String, TagModel>.from(state.allTags);
        if (newAllTags.containsKey(tagKey)) {
          newAllTags[tagKey] = newAllTags[tagKey]!.copyWith(
            count: label.photoId.length,
            time: DateTime.now(),
          );
          state = state.copyWith(allTags: newAllTags);
        }
      }

      AppLogger.d('Added ${state.multiPicTags.length} tags to ${selectedPicIds.length} pics');
    } on Exception catch (e) {
      AppLogger.e('Error adding tags to pics: $e');
    } finally {
      clearMultiPicTags();
    }
  }
}

// Provider
final tagsProvider = StateNotifierProvider<TagsNotifier, TagsState>((ref) {
  return TagsNotifier(ref);
});
