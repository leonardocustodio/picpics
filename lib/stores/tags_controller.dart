import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/stores/percentage_dialog_controller.dart';
import 'package:picpics/stores/private_photos_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/tagged_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';

class TagsController extends GetxController {
  /// tagKey: {
  ///           title: Name,
  ///           count: 0,
  ///           date: DateTime(),
  ///          }

  static TagsController get to => Get.find();

  final allTags = <String, Rx<TagModel>>{}.obs;
  final mostUsedTags = <String, String>{}.obs;
  final lastWeekUsedTags = <String, String>{}.obs;
  final lastMonthUsedTags = <String, String>{}.obs;

  final recentTagKeyList = <String, String>{}.obs;
  final multiPicTags = <String, String>{}.obs;
  final searchTagsResults = <TagModel>[].obs;

  final searchText = ''.obs;
  final selectedFilteringTagsKeys = <String, String>{}.obs;

  final _database = AppDatabase();

  final isSearching = false.obs;
  final tabsController = Get.find<TabsController>();

  @override
  void onInit() {
    super.onInit();
    UserController.to.createDefaultTags(Get.context).then((_) async {
      await loadAllTags();
      await TagsController.to.tagsSuggestionsCalculate();
    });

    ever(selectedFilteringTagsKeys, (_) {
      isSearching.value = TaggedController.to.searchFocusNode.hasFocus ||
          selectedFilteringTagsKeys.isNotEmpty;
    });
    ever(searchText, (_) {
      tagsSuggestionsCalculate();
    });
  }

  void setIsSearching(bool val) {
    isSearching.value = val;
    if (isSearching.value == false) {
      selectedFilteringTagsKeys.clear();
    }
  }

  void addTagKeyForFiltering(String tagKey) {
    if (selectedFilteringTagsKeys[tagKey] == null) {
      selectedFilteringTagsKeys[tagKey] = '';
    }
    tagsSuggestionsCalculate();
  }

  Future<List<TagModel>> tagsSuggestionsCalculate() async {
    //var userBox = Hive.box('user');
    //var tagsBox = Hive.box('tags');
    final tagsList = await _database.getAllLabel();
    final getUser = await _database.getSingleMoorUser();

    //List<String> multiPicTags = multiPicTagKeys.toList();
    final suggestionTags = <String>[];
    final text = searchText.trim();

    if (text.trim() == '') {
      for (final recent in getUser!.recentTags) {
        // AppLogger.d('Recent Tag: $recent');
        if (multiPicTags[recent] != null ||
            (PrivatePhotosController.to.showPrivate.value == false &&
                recent == kSecretTagKey)) {
          continue;
        }
        suggestionTags.add(recent);
      }

      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (final tag in tagsList) {
          final tagKey = tag.key;
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
          if (multiPicTags[tagKey] != null ||
              selectedFilteringTagsKeys[tagKey] != null ||
              suggestionTags.contains(tagKey) ||
              (PrivatePhotosController.to.showPrivate.value == false &&
                  tagKey == kSecretTagKey)) {
            continue;
          }
          // AppLogger.d('Adding tag key: $tagKey');
          suggestionTags.add(tagKey);
        }
      }
    } else {
      final listOfLetters = text.toLowerCase().split('');
      for (final tag in tagsList) {
        final tagKey = tag.key;
        if (PrivatePhotosController.to.showPrivate.value == false &&
            tagKey == kSecretTagKey) {
          continue;
        }
        if (selectedFilteringTagsKeys[tagKey] != null) {
          continue;
        }

        final tagsStoreValue = TagsController.to.allTags[tagKey]?.value;
        if (tagsStoreValue == null) {
          continue;
        }
        AppLogger.d(listOfLetters.toString());
        AppLogger.d(suggestionTags
            .map((e) => TagsController.to.allTags[e]!.value.title)
            .toString(),);
        AppLogger.d('------');
        doCustomisedSearching(tagsStoreValue, listOfLetters, (matched) {
          if (matched) {
            AppLogger.d(
                'searching: ${TagsController.to.allTags[tagKey]!.value.title}',);
            suggestionTags.add(tagKey);
          }
        });
        /* String tagName = Helpers.decryptTag(tagKey);
        if (tagName.startsWith(Helpers.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        } */
      }
    }

    // AppLogger.d('%%%%%%%%%% Before adding secret tag: ${suggestionTags}');
    if (multiPicTags[kSecretTagKey] == null &&
        selectedFilteringTagsKeys[kSecretTagKey] == null &&
        PrivatePhotosController.to.showPrivate.value == true &&
        text == '') {
      suggestionTags.add(kSecretTagKey);
    }

    // AppLogger.d('find suggestions: $searchText - exclude tags: $multiPicTags');
    // AppLogger.d(suggestionTags);
    // AppLogger.d('UserController Tags: ${TagsController.to.allTags}');
    /* List<TagsStore> suggestions = TagsController.to.allTags
        .where((element) => suggestionTags.contains(element.id))
        .toList(); */
    final suggestions = <TagModel>[];
    for (final suggestedTag in suggestionTags) {
      if (TagsController.to.allTags[suggestedTag] != null) {
        suggestions.add(TagsController.to.allTags[suggestedTag]!.value);
      }
    }
    // AppLogger.d('Suggestions Tag Store: $suggestions');
    searchTagsResults.clear();
    searchTagsResults.value = List<TagModel>.from(suggestions);
    AppLogger.d('$suggestions:');
    AppLogger.d(suggestions.toString());
    return suggestions;
  }

  void removeTagKeyFromFiltering(String tagKey) {
    if (selectedFilteringTagsKeys[tagKey] != null) {
      selectedFilteringTagsKeys.remove(tagKey);
    }
    tagsSuggestionsCalculate();
  }

  Future<void> removeAllPrivatePics() async {
    /// TODO: implement the private pic section
    /*  for (PicStore private in privatePics) {
      removePicFromTaggedPics(picStore: private, forceDelete: true);
      filteredPics.remove(private);
      thumbnailsPics.remove(private);
      selectedPics.remove(private);
      swipePics.remove(private);
      removePicFromUntaggedPics(picStore: private);
      allPics.value.remove(private);
    }
    privatePics.clear(); */
  }

  /// load most used tags into `mostUsedTags`
  void loadMostUsedTags({int maxTagsLength = 12}) {
    var tempTags = <TagModel>[];
    allTags.forEach((_, value) {
      tempTags.add(value.value);
    });

    tempTags.sort((a, b) {
      final count = b.count.compareTo(a.count);
      if (count == 0) {
        return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      }
      return count;
    });

    if (tempTags.length > maxTagsLength) {
      tempTags = tempTags.sublist(0, maxTagsLength);
    }
    mostUsedTags.clear();
    for (final tag in tempTags) {
      mostUsedTags[tag.key] = tag.title;
    }
  }

  /// load last week used tags into `lastWeekUsedTags`
  void loadLastWeekUsedTags({int maxTagsLength = 12}) {
    final now = DateTime.now();
    final sevenDaysBack =
        DateTime(now.year, now.month, now.day - now.weekday - 1);
    _doSortingOfWeeksAndMonth(lastMonthUsedTags, sevenDaysBack, maxTagsLength);
  }

  /// load last month used tags into `lastMonthUsedTags`
  void loadLastMonthUsedTags({int maxTagsLength = 12}) {
    final now = DateTime.now();
    final monthBack = DateTime(now.year, now.month);
    _doSortingOfWeeksAndMonth(lastMonthUsedTags, monthBack, maxTagsLength);
  }

  void _doSortingOfWeeksAndMonth(
      RxMap<String, String> map, DateTime back, int maxTagsLength,) {
    var tempTags = <TagModel>[];
    for (final tag in allTags.values) {
      if (tag.value.time.isBefore(back)) {
        tempTags.add(tag.value);
      }
    }
    if (tempTags.isNotEmpty) {
      tempTags
          .sort((TagModel a, TagModel b) => b.time.day.compareTo(a.time.day));
      if (tempTags.length > maxTagsLength) {
        tempTags = tempTags.sublist(0, maxTagsLength);
      }
    }
    map.clear();
    for (final tag in tempTags) {
      map[tag.key] = tag.title;
    }
  }

  Future<String> createTag(String tagName) async {
    //var tagsBox = Hive.box('tags');
    /*// AppLogger.d(tagsBox.keys); */

    final tagKey = Helpers.encryptTag(tagName);
    // AppLogger.d('Adding tag: $tagName');

    final lab = await _database.getLabelByLabelKey(tagKey);

    if (lab != null) {
      // AppLogger.d('user already has this tag');
      return tagKey;
    }

    // AppLogger.d('adding tag to database...');
    await _database.createLabel(Label(
        key: tagKey,
        title: tagName,
        photoId: <String, String>{},
        counter: 1,
        lastUsedAt: DateTime.now(),),);
    //tagsBox.put(tagKey, Tag(tagName, []));

    final tagModel =
        TagModel(key: tagKey, title: tagName, count: 1, time: DateTime.now());
    addTag(tagModel);
    addRecentTag(tagKey);

    await Analytics.sendEvent(
      Event.created_tag,
      params: {'tagName': tagName},
    );
    return tagKey;
  }

  /// load all the tags async
  Future<void> loadAllTags() async {
    final tagsBox = await _database.getAllLabel();

    for (final tag in tagsBox) {
      final tagModel = TagModel(
        key: tag.key,
        title: tag.title,
        count: tag.counter,
        time: tag.lastUsedAt,
      );
      allTags[tag.key] = Rx<TagModel>(tagModel);
    }

    if (allTags[kSecretTagKey] == null) {
      AppLogger.d('Creating secret tag in db!');
      final createSecretLabel = Label(
        key: kSecretTagKey,
        title: 'Secret Pics',
        photoId: <String, String>{},
        counter: 1,
        lastUsedAt: DateTime.now(),
      );

      final tagModel = TagModel(
        key: kSecretTagKey,
        title: 'Secret Pics',
        count: 1,
        time: DateTime.now(),
      );
      allTags[tagModel.key] = Rx<TagModel>(tagModel);

      await _database.createLabel(createSecretLabel);
    }

    /// load most used tags
    loadMostUsedTags();

    /// load last recent week used tags
    loadLastWeekUsedTags();

    /// load last recent month used tags
    loadLastMonthUsedTags();
  }

  /// add the tag
  void addTag(TagModel tagModel) {
    allTags[tagModel.key] = Rx<TagModel>(tagModel);
  }

  ///
  ///
  /// ---------- START ----------
  ///
  /// Multiple Tags Removing Functionality
  ///
  ///
  ///

  Future<void> removeTagsFromPicsMainFunction(
      {required Map<String, Map<String, String>> picIdMapToTagKey,
      required Map<String, Map<String, String>> tagKeyMapToPicId,}) async {
    final taggedController = Get.find<TaggedController>();

    await _removeTagsFromPicsPrivate(
            picIdMapToTagKey: picIdMapToTagKey,
            tagKeyMapToTagKey: tagKeyMapToPicId,)
        .then((_) async {
      /// Clear the selectedTaggedPics as now the processing is done
      ///
      taggedController.selectedMultiBarPics.clear();

      /// Also clear the multiPicTags as we have iterated and processed through it and
      /// now we have to make it empty for the next time
      clearMultiPicTags();

      /// refresh the untaggedList and at the same time the tagged pics will also be refreshed again
      ///
      await tabsController.refreshUntaggedList();
    });
  }

  Future<void> _removeTagsFromPicsPrivate(
      {required Map<String, Map<String, String>> picIdMapToTagKey,
      required Map<String, Map<String, String>> tagKeyMapToTagKey,}) async {
    final percentageController = Get.find<PercentageDialogController>();

    /// iterate over the pictures and add tags to it
    final tabsController = Get.find<TabsController>();

    await Future.forEach(tagKeyMapToTagKey.keys, (String tagKey) async {
      await _removePhotoIdFromLabel(tagKey, tagKeyMapToTagKey[tagKey]!);
    });
    await Future.forEach(picIdMapToTagKey.keys, (String picId) async {
      final map = picIdMapToTagKey[picId]!;

      await tabsController.picStoreMap[picId]!.value
          .removeMultipleTagsFromPicsForwadFromTagsController(
              acceptedTagKeys: map,);
      await Future.delayed(Duration.zero, () {
        percentageController.increaseValue(1);
      });
    }).then((_) {
      percentageController.stop();
    });
  }

  Future<void> _removePhotoIdFromLabel(
      String tagKey, Map<String, String> picIdsMap,) async {
    final getTag = await _database.getLabelByLabelKey(tagKey);

    if (getTag == null) {
      return;
    }
    if (picIdsMap.isNotEmpty) {
      getTag.photoId.removeWhere((picId, _) => picIdsMap[picId] != null);
      await _database.updateLabel(getTag);
    }
  }

  ///
  /// Multiple Tags Removing Functionality
  ///
  /// ---------------------- END ----------------------
  ///

  Future<void> addTagsToSelectedPics({List<String>? selectedPicIds}) async {
    if (tabsController.currentTab.value == 0) {
      if (tabsController.toggleIndexUntagged.value == 0) {
        await tabsController.untaggedScrollControllerMonth.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn,);
      } else {
        await tabsController.untaggedScrollControllerDay.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn,);
      }
    }
    final taggedController = Get.find<TaggedController>();

    if (selectedPicIds == null) {
      if (tabsController.currentTab.value == 0) {
        selectedPicIds = tabsController.selectedMultiBarPics.keys.toList();
      } else if (tabsController.currentTab.value == 2) {
        selectedPicIds = tabsController.selectedMultiBarPics.keys.toList();
      }
    }
    selectedPicIds ??= <String>[];

    final map = <String, Map<String, String>>{
      // ignore: invalid_use_of_protected_member
      for (final picId in selectedPicIds) picId: multiPicTags.value,
    };

    await addTagsToPics(picIdToTagKey: map).then((_) async {
      /// Clear the selectedUntaggedPics as now the processing is done
      if (tabsController.currentTab.value == 0) {
        tabsController.clearSelectedPics();
      } else if (tabsController.currentTab.value == 2) {
        taggedController.selectedMultiBarPics.clear();
      }

      /// Also clear the multiPicTags as we have iterated and processed through it and
      /// now we have to make it empty for the next time
      clearMultiPicTags();

      /// refresh the untaggedList and at the same time the tagged pics will also be refreshed again
      ///
      await tabsController.refreshUntaggedList();
    });
  }

  Future<void> removeTagFromPic(
      {required String picId, required String tagKey,}) async {
    final taggedController = Get.find<TaggedController>();
    var picStore = tabsController.picStoreMap[picId]?.value;
    picStore ??= tabsController.explorPicStore(picId).value;
    await picStore?.removeMultipleTagFromPic(
      acceptedTags: {tagKey: ''},
    );

    /// Refreshing the tagged pic map as a tag is removed from the picstore
    await taggedController.refreshTaggedPhotos();

    if (picStore != null && picStore.tags.isEmpty) {
      /// tags are empty now the untagged list should be refreshed so that this picStore will be visible there
      await tabsController.refreshUntaggedList();
    }
  }

  /// Add All Untagged Pics To Tagged Pics with same Tags
  Future<void> _addPhotoIdToLabel(
      String tagKey, Map<String, String> picIdsMap,) async {
    final getTag = await _database.getLabelByLabelKey(tagKey);

    if (getTag == null && allTags[tagKey] != null) {
      final newLabel = Label(
          key: tagKey,
          counter: 1,
          lastUsedAt: DateTime.now(),
          title: allTags[tagKey]!.value.title,
          photoId: picIdsMap,);
      await _database.createLabel(newLabel);
      return;
    }
    if (picIdsMap.isNotEmpty) {
      getTag!.photoId.addAll(picIdsMap);
      await _database.updateLabel(getTag);
    }
  }

  Future<void> addTagsToPics(
      {required Map<String, Map<String, String>> picIdToTagKey,}) async {
    final percentageController = Get.find<PercentageDialogController>();
    percentageController.start(picIdToTagKey.keys.length + .0, 'Tagging...');

    /// iterate over the pictures and add tags to it
    final tabsController = Get.find<TabsController>();

    final tagKeyToPicId = <String, Map<String, String>>{};

    picIdToTagKey.forEach((pictureId, tagMap) {
      for (final tagKey in tagMap.keys) {
        if (tagKeyToPicId[tagKey] == null) {
          tagKeyToPicId[tagKey] = <String, String>{pictureId: ''};
        } else {
          tagKeyToPicId[tagKey]![pictureId] = '';
        }
      }
    });

    await Future.forEach(tagKeyToPicId.keys, (String tagKey) async {
      await _addPhotoIdToLabel(tagKey, tagKeyToPicId[tagKey]!);
    });
    await Future.forEach(picIdToTagKey.keys, (String picId) async {
      final map = picIdToTagKey[picId]!;

      await tabsController.picStoreMap[picId]!.value
          .addMultipleTagsToPic(acceptedTagKeys: map);
      await Future.delayed(Duration.zero, () {
        percentageController.increaseValue(1);
      });
    }).then((_) {
      percentageController.stop();
    });
  }

  void clearMultiPicTags() {
    multiPicTags.clear();
  }

  /// Add the picId to the taggedMap in the 3rdTab (Tagged Tab)
  ///
  /// TagKey : {
  ///           picId: '',
  ///           picId2: '',
  ///         },
  /// OtherTagKey: {
  ///             picId56: '',
  ///             picId5: '',
  ///           }

  /// add the tagKey to the recentTagKeyList
  void addRecentTag(String tagKey) {
    if (recentTagKeyList[tagKey] == null) {
      recentTagKeyList[tagKey] = '';
    }
  }

  /// edit the tags name
  void _editTagInternalFunction(
      {required String oldTagKey,
      required String newTagKey,
      required String newName,}) {
    final tagModel = allTags[oldTagKey]!.value;

    /// remove the oldTagKey because it will help us to make it un-listenable
    /// as it might be used somewhere else and we don't need un necessary frame updates
    allTags.remove(oldTagKey);

    tagModel
      ..key = newTagKey
      ..title = newName
      ..time = DateTime.now();

    allTags[newTagKey] = Rx<TagModel>(tagModel);
    addNewTagReferences(newTagKey);
    removeOldTagReferences(oldTagKey);
  }

  /// when the tag is renamed into new one or if the tag is deleted then
  /// this function will help to remove it's occurences from everywhere
  void removeOldTagReferences(String oldTagKey) {
    multiPicTags.remove(oldTagKey);
    recentTagKeyList.remove(oldTagKey);
    mostUsedTags.remove(oldTagKey);
    lastWeekUsedTags.remove(oldTagKey);
    lastMonthUsedTags.remove(oldTagKey);
  }

  /// when the name of oldTagKey is renamed or a new tag is created then the
  /// newTagKey should be placed on those places. right!!
  void addNewTagReferences(String newTagKey) {
    multiPicTags[newTagKey] = '';
    recentTagKeyList[newTagKey] = '';
    mostUsedTags[newTagKey] = '';
    lastWeekUsedTags[newTagKey] = '';
    lastMonthUsedTags[newTagKey] = '';
  }

  /// remove Tag from all tags
  void removeTag(TagModel tagModel) {
    allTags.remove(tagModel.key);
  }

  Future<void> editTagName(
      {required String oldTagKey, required String newName,}) async {
    /// create a new tagKey
    final newTagKey = Helpers.encryptTag(newName);

    /// use that new tagKey to make the ui changes fastly
    _editTagInternalFunction(
        oldTagKey: oldTagKey, newTagKey: newTagKey, newName: newName,);

    /// as soon as the `ui` changes are done - now secretly do the background changes in async manner

    /// fetch the `Label` from the `oldTagKey`
    final oldTag = await _database.getLabelByLabelKey(oldTagKey);

    /// Creating new label
    final createTag = Label(
      key: newTagKey,
      title: newName,
      photoId: oldTag!.photoId,
      counter: oldTag.counter < 1 ? 1 : oldTag.counter,
      lastUsedAt: DateTime.now(),
    );

    await _database.createLabel(createTag);

    await Future.wait(
      [
        Future.forEach(createTag.photoId.keys, (String photoId) async {
          final pic = await _database.getPhotoByPhotoId(photoId);
          if (pic != null) {
            //Pic pic = picsBox.get(photoId);
            pic.tags[oldTagKey] = newTagKey;
            await _database.updatePhoto(pic);
            //picsBox.put(photoId, pic);
            // AppLogger.d('updated tag in pic ${pic.id}');
          }
        }),
      ],
    );

    await _database.deleteLabelByLabelId(oldTagKey);
    await Analytics.sendEvent(Event.edited_tag);
  }

  /// untag the pic with tags as `tagKey`
  Future<void> deleteTagFromPic({required String tagKey}) async {
    //var tagsBox = Hive.box('tags');

    final label = await _database.getLabelByLabelKey(tagKey);

    if (label != null && allTags[tagKey] != null) {
      // AppLogger.d('found tag going to delete it');
      // Remove a tag das fotos já taggeadas
      final tagsStore = allTags[tagKey]!.value;
      // AppLogger.d('TagsStore Tag: ${tagsStore.name}');
      /*  TaggedPicsStore taggedPicsStore =
          taggedPics.firstWhere((element) => element.tag == tagsStore);
      for (PicStore picTagged in taggedPicsStore.pics) {
        // AppLogger.d('Tagged Pic Store Pics: ${picTagged.photoId}');
        await picTagged.removeTagFromPic(tagKey: tagsStore.id);
        if (picTagged.tags.length == 0 && picTagged != currentPic) {
          // AppLogger.d('this pic is not tagged anymore!');
          addPicToUntaggedPics(picStore: picTagged);
        }
      }
      taggedPics.remove(taggedPicsStore);
      recentTagKeyList.removeWhere((element) => element == tagKey);
      //appStore.removeTagFromRecent(tagKey: tagKey);
      removeTag(tagModel: tagsStore);
      await _database.deleteLabelByLabelId(tagKey); */
      //tagsBox.delete(tagKey);
      // AppLogger.d('deleted from tags db');
      await Analytics.sendEvent(Event.deleted_tag);
      removeOldTagReferences(tagKey);
    }
  }
}
