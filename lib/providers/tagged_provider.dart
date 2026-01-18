import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/utils/app_logger.dart';

/// Tagged photos state for managing tagged photo collections
class TaggedState {
  const TaggedState({
    required this.expandableController,
    required this.expandablePaddingController,
    this.bottomOptionsBar = 0,
    this.taggedPicId = const {},
    this.allTaggedPicIdList = const {},
    this.picWiseTags = const {},
    this.isTaggedPicsLoaded = false,
    this.multiPicBar = false,
    this.multiTagSheet = false,
    this.toggleIndexTagged = 1,
    this.selectedMultiBarPics = const {},
    this.isScrolling = false,
    this.hideTitleThirdTab = false,
    this.allTaggedPicDateWiseList = const [],
  });
  final int bottomOptionsBar;

  /// Map of tagKey to map of picId
  final Map<String, Map<String, String>> taggedPicId;

  final Map<String, String> allTaggedPicIdList;
  final Map<String, Map<String, String>> picWiseTags;
  final bool isTaggedPicsLoaded;

  final bool multiPicBar;
  final bool multiTagSheet;
  final ExpandableController expandableController;
  final ExpandableController expandablePaddingController;
  final int toggleIndexTagged;

  final Map<String, bool> selectedMultiBarPics;
  final bool isScrolling;

  final bool hideTitleThirdTab;
  final List<dynamic> allTaggedPicDateWiseList;

  TaggedState copyWith({
    int? bottomOptionsBar,
    Map<String, Map<String, String>>? taggedPicId,
    Map<String, String>? allTaggedPicIdList,
    Map<String, Map<String, String>>? picWiseTags,
    bool? isTaggedPicsLoaded,
    bool? multiPicBar,
    bool? multiTagSheet,
    ExpandableController? expandableController,
    ExpandableController? expandablePaddingController,
    int? toggleIndexTagged,
    Map<String, bool>? selectedMultiBarPics,
    bool? isScrolling,
    bool? hideTitleThirdTab,
    List<dynamic>? allTaggedPicDateWiseList,
  }) {
    return TaggedState(
      bottomOptionsBar: bottomOptionsBar ?? this.bottomOptionsBar,
      taggedPicId: taggedPicId ?? this.taggedPicId,
      allTaggedPicIdList: allTaggedPicIdList ?? this.allTaggedPicIdList,
      picWiseTags: picWiseTags ?? this.picWiseTags,
      isTaggedPicsLoaded: isTaggedPicsLoaded ?? this.isTaggedPicsLoaded,
      multiPicBar: multiPicBar ?? this.multiPicBar,
      multiTagSheet: multiTagSheet ?? this.multiTagSheet,
      expandableController: expandableController ?? this.expandableController,
      expandablePaddingController: expandablePaddingController ?? this.expandablePaddingController,
      toggleIndexTagged: toggleIndexTagged ?? this.toggleIndexTagged,
      selectedMultiBarPics: selectedMultiBarPics ?? this.selectedMultiBarPics,
      isScrolling: isScrolling ?? this.isScrolling,
      hideTitleThirdTab: hideTitleThirdTab ?? this.hideTitleThirdTab,
      allTaggedPicDateWiseList: allTaggedPicDateWiseList ?? this.allTaggedPicDateWiseList,
    );
  }
}

/// Notifier for tagged photos state
/// Manages tagged photo collections, multi-selection, and photo operations
class TaggedNotifier extends StateNotifier<TaggedState> {
  TaggedNotifier()
      : super(
          TaggedState(
            expandableController: ExpandableController(initialExpanded: false),
            expandablePaddingController: ExpandableController(initialExpanded: false),
          ),
        );

  final AppDatabase _database = AppDatabase();

  // Text editing controller and focus node for search
  final TextEditingController searchEditingController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // Scroll controller for third tab
  late ScrollController scrollControllerThirdTab;
  double offsetThirdTab = 0;

  void setMultiPicBar({required bool value}) {
    state = state.copyWith(multiPicBar: value);
  }

  void returnAction() {
    state = state.copyWith(
      selectedMultiBarPics: {},
      multiPicBar: false,
    );
  }

  void setMultiTagSheet({required bool value}) {
    state = state.copyWith(multiTagSheet: value);
  }

  void tagAction() {
    setMultiTagSheet(value: true);
    Future.delayed(const Duration(milliseconds: 200), () {
      state.expandableController.expanded = true;
    });
  }

  void setBottomOptionsBar(int value) {
    state = state.copyWith(bottomOptionsBar: value);
  }

  void setToggleIndexTagged(int value) {
    state = state.copyWith(toggleIndexTagged: value);
  }

  void onPoppingOut() {
    state = state.copyWith(selectedMultiBarPics: {});
  }

  Future<bool> shouldPopOut() async {
    if (state.multiTagSheet) {
      state = state.copyWith(multiTagSheet: false);
      return false;
    }
    if (state.multiPicBar) {
      state = state.copyWith(multiPicBar: false);
      return false;
    }

    onPoppingOut();
    return true;
  }

  void setHideTitleThirdTab({required bool value}) {
    if (value == state.hideTitleThirdTab) {
      return;
    }
    state = state.copyWith(hideTitleThirdTab: value);
  }

  void refreshGridPositionThirdTab() {
    final offset = scrollControllerThirdTab.hasClients
        ? scrollControllerThirdTab.offset
        : scrollControllerThirdTab.initialScrollOffset;

    if (offset >= 40) {
      setHideTitleThirdTab(value: true);
    } else if (offset <= 0) {
      setHideTitleThirdTab(value: false);
    }

    if (scrollControllerThirdTab.hasClients) {
      offsetThirdTab = scrollControllerThirdTab.offset;
    }
  }

  void setIsScrolling({required bool value}) {
    state = state.copyWith(isScrolling: value);
  }

  Future<void> refreshTaggedPhotos() async {
    state = state.copyWith(isTaggedPicsLoaded: false);

    final taggedPhotoIdList = await _database.getAllPhoto();

    final newAllTaggedPicIdList = <String, String>{};
    final newAllTaggedPicDateWiseList = <dynamic>[];
    final newTaggedPicId = <String, Map<String, String>>{};
    final newPicWiseTags = <String, Map<String, String>>{};

    // Load all tags first
    // await tagsController.loadAllTags();

    for (final photo in taggedPhotoIdList) {
      if (photo.tags.isNotEmpty) {
        photo.tags.forEach((tagKey, _) {
          if (newTaggedPicId[tagKey] == null) {
            newTaggedPicId[tagKey] = {};
          }
          newTaggedPicId[tagKey]![photo.id] = '';

          if (newPicWiseTags[photo.id] == null) {
            newPicWiseTags[photo.id] = {};
          }
          newPicWiseTags[photo.id]![tagKey] = '';
        });
        newAllTaggedPicIdList[photo.id] = '';
      }
    }

    /// Sorting the photo-ids on basis of their creation datetime
    taggedPhotoIdList.sort((a, b) {
      final year = b.createdAt.year.compareTo(a.createdAt.year);
      if (year == 0) {
        final month = b.createdAt.month.compareTo(a.createdAt.month);
        if (month == 0) {
          final day = b.createdAt.day.compareTo(a.createdAt.day);
          return day;
        }
        return month;
      }
      return year;
    });

    DateTime? previousMonth;
    var previousDatePicIdList = <String>[];

    for (final photo in taggedPhotoIdList) {
      if (photo.tags.isNotEmpty) {
        final dateTime = DateTime.utc(
          photo.createdAt.year,
          photo.createdAt.month,
          photo.createdAt.day,
        );

        if (previousMonth == null) {
          previousMonth = dateTime;
          newAllTaggedPicDateWiseList.add(dateTime);
        }

        if (previousMonth.year != dateTime.year ||
            previousMonth.month != dateTime.month ||
            previousMonth.day != dateTime.day) {
          if (previousMonth.month != dateTime.month) {
            previousDatePicIdList = <String>[];
            newAllTaggedPicDateWiseList.add(dateTime);
            previousMonth = dateTime;
          }
        }
        newAllTaggedPicDateWiseList.add(photo.id);
        previousDatePicIdList.add(photo.id);
      }
    }

    state = state.copyWith(
      allTaggedPicIdList: newAllTaggedPicIdList,
      allTaggedPicDateWiseList: newAllTaggedPicDateWiseList,
      taggedPicId: newTaggedPicId,
      picWiseTags: newPicWiseTags,
      isTaggedPicsLoaded: true,
    );
  }

  void addPicIdToTaggedList(String tagKey, String picId) {
    final newTaggedPicId = Map<String, Map<String, String>>.from(state.taggedPicId);

    if (newTaggedPicId[tagKey] == null) {
      newTaggedPicId[tagKey] = {};
    }
    newTaggedPicId[tagKey]![picId] = '';

    state = state.copyWith(taggedPicId: newTaggedPicId);
  }

  void toggleSelectedMultiBarPic(String picId) {
    final newSelected = Map<String, bool>.from(state.selectedMultiBarPics);

    if (newSelected.containsKey(picId)) {
      newSelected.remove(picId);
    } else {
      newSelected[picId] = true;
    }

    state = state.copyWith(selectedMultiBarPics: newSelected);
  }

  void clearSelectedMultiBarPics() {
    state = state.copyWith(selectedMultiBarPics: {});
  }

  void addSelectedMultiBarPic(String picId) {
    final newSelected = Map<String, bool>.from(state.selectedMultiBarPics);
    newSelected[picId] = true;
    state = state.copyWith(selectedMultiBarPics: newSelected);
  }

  void removeSelectedMultiBarPic(String picId) {
    final newSelected = Map<String, bool>.from(state.selectedMultiBarPics)..remove(picId);
    state = state.copyWith(selectedMultiBarPics: newSelected);
  }

  Future<void> untagPicsFromTag({
    required Map<String, Map<String, String>> tagKeyMapToPicId,
  }) async {
    try {
      for (final entry in tagKeyMapToPicId.entries) {
        final tagKey = entry.key;
        final picIds = entry.value.keys.toList();

        // Get the label from database
        final label = await _database.getLabelByLabelKey(tagKey);
        if (label == null) {
          AppLogger.w('Tag $tagKey not found');
          continue;
        }

        for (final picId in picIds) {
          // Get the photo from database
          final photo = await _database.getPhotoByPhotoId(picId);
          if (photo == null) {
            AppLogger.w('Photo $picId not found');
            continue;
          }

          // Remove the tag from the photo
          if (photo.tags.containsKey(tagKey)) {
            photo.tags.remove(tagKey);
            await _database.updatePhoto(photo);
          }

          // Remove the photo ID from the label
          label.photoId.remove(picId);
        }

        // Update the label counter
        final newCounter = label.photoId.length;
        await _database.updateLabel(label.copyWith(counter: newCounter));

        AppLogger.d('Removed tag $tagKey from ${picIds.length} photos');
      }

      // Refresh tagged photos to update state
      await refreshTaggedPhotos();
    } on Exception catch (e) {
      AppLogger.e('Error untagging pics: $e');
    }
  }

  void initScrollController() {
    scrollControllerThirdTab = ScrollController(initialScrollOffset: offsetThirdTab);
    scrollControllerThirdTab.addListener(refreshGridPositionThirdTab);
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    searchFocusNode.dispose();
    // Only dispose scroll controller if it was initialized
    try {
      if (scrollControllerThirdTab.hasClients) {
        scrollControllerThirdTab.dispose();
      }
    } on Exception catch (e) {
      // scrollControllerThirdTab was never initialized, skip disposal
      AppLogger.d('Dispose skipped: $e');
    }
    super.dispose();
  }
}

final taggedProvider = StateNotifierProvider<TaggedNotifier, TaggedState>((ref) {
  return TaggedNotifier();
});
