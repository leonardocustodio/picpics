import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
/* import 'package:picPics/stores/tagged_controller.dart'; */
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/utils/helpers.dart';
import '../constants.dart';
import 'package:picPics/model/tag_model.dart';
import 'database_controller.dart';

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
  final selectedFilteringTagsKeys = <String>[].obs;

  final _database = AppDatabase();

  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    UserController.to.createDefaultTags(Get.context).then((_) async {
      await loadAllTags();
      await TagsController.to.loadRecentTags();
    });
    ever(searchText, (_) => tagsSuggestionsCalculate(null));
  }

  void setIsSearching(bool val) {
    isSearching.value = val;
    if (isSearching.value == false) {
      selectedFilteringTagsKeys.clear();
    }
  }

  void selectTagKeyForFiltering(String tagKey) {
    if (!selectedFilteringTagsKeys.contains(tagKey)) {
      selectedFilteringTagsKeys.add(tagKey);
    }
    tagsSuggestionsCalculate(null);
  }

  Future<List<TagModel>> tagsSuggestionsCalculate(_) async {
    //var userBox = Hive.box('user');
    //var tagsBox = Hive.box('tags');
    var tagsList = await _database.getAllLabel();
    MoorUser getUser = await _database.getSingleMoorUser();

    //List<String> multiPicTags = multiPicTagKeys.toList();
    var suggestionTags = <String>[];
    var text = searchText.trim();

    if (text == '') {
      for (var recent in getUser.recentTags) {
        // //print('Recent Tag: $recent');
        if (multiPicTags[recent] != null || recent == kSecretTagKey) {
          continue;
        }
        suggestionTags.add(recent);
      }

      // //print('Sugestion Length: ${suggestionTags.length} - Num of Suggestions: ${kMaxNumOfSuggestions}');

//      while (suggestions.length < maxNumOfSuggestions) {
//          if (excludeTags.contains('Hey}')) {
//            continue;
//          }
      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (var tag in tagsList) {
          var tagKey = tag.key;
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
          if (multiPicTags[tagKey] != null ||
              selectedFilteringTagsKeys.contains(tagKey) ||
              suggestionTags.contains(tagKey) ||
              tagKey == kSecretTagKey) {
            continue;
          }
          // //print('Adding tag key: $tagKey');
          suggestionTags.add(tagKey);
        }
      }
//      }
    } else {
      var listOfLetters = text.toLowerCase().split('');
      for (var tag in tagsList) {
        var tagKey = tag.key;
        if (tagKey == kSecretTagKey) {
          continue;
        }
        if (selectedFilteringTagsKeys.contains(tagKey)) {
          continue;
        }

        var tagsStoreValue = TagsController.to.allTags[tagKey].value;
        doCustomisedSearching(tagsStoreValue, listOfLetters, (matched) {
          if (matched) {
            suggestionTags.add(tagKey);
          }
        });
        /* String tagName = Helpers.decryptTag(tagKey);
        if (tagName.startsWith(Helpers.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        } */
      }
    }

    // //print('%%%%%%%%%% Before adding secret tag: ${suggestionTags}');
    if (multiPicTags[kSecretTagKey] == null &&
        !selectedFilteringTagsKeys.contains(kSecretTagKey) &&
        PrivatePhotosController.to.showPrivate.value == true &&
        text == '') {
      suggestionTags.add(kSecretTagKey);
    }

    // //print('find suggestions: $searchText - exclude tags: $multiPicTags');
    // //print(suggestionTags);
    // //print('UserController Tags: ${TagsController.to.allTags}');
    /* List<TagsStore> suggestions = TagsController.to.allTags
        .where((element) => suggestionTags.contains(element.id))
        .toList(); */
    var suggestions = <TagModel>[];
    suggestionTags.forEach((suggestedTag) {
      if (TagsController.to.allTags[suggestedTag] != null) {
        suggestions.add(TagsController.to.allTags[suggestedTag].value);
      }
    });
    // //print('Suggestions Tag Store: $suggestions');
    searchTagsResults.value = List<TagModel>.from(suggestions);
    return suggestions;
  }

  void removeTagKeyFromFiltering(String tagKey) {
    if (selectedFilteringTagsKeys.contains(tagKey)) {
      selectedFilteringTagsKeys.remove(tagKey);
    }
    tagsSuggestionsCalculate(null);
  }

/*   void searchForTagName(_) {
    var text = searchText.value;
    text = text.trim();
    searchTagsResults.clear();
    if (text == '') {
      /* setShowSearchTagsResults(false); */
      return;
    }
    var listOfLetters = text.toLowerCase().split('');

    /* setShowSearchTagsResults(true); */

    for (MapEntry<String, Rx<TagModel>> map in allTags.entries) {
      TagModel tagStore = map.value.value;
      if (tagStore.key == kSecretTagKey) {
        continue;
      }
      if (selectedFilteringTagsKeys.contains(tagStore.key)) {
        continue;
      }

      doCustomisedSearching(tagStore, listOfLetters, (matched) {
        if (matched) searchTagsResults.add(tagStore);
      });
      /* if (Helpers.stripTag(tagStore.name).startsWith(Helpers.stripTag(text))) {
        searchTagsResults.add(tagStore);
      } */
    }
  } */

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
      var count = b.count.compareTo(a.count);
      if (count == 0) {
        return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      }
      return count;
    });

    if (tempTags.length > maxTagsLength) {
      tempTags = tempTags.sublist(0, maxTagsLength);
    }
    mostUsedTags.clear();
    tempTags.forEach((TagModel tag) {
      mostUsedTags[tag.key] = tag.title;
    });
  }

  /// load last week used tags into `lastWeekUsedTags`
  void loadLastWeekUsedTags({int maxTagsLength = 12}) {
    var now = DateTime.now();
    var sevenDaysBack =
        DateTime(now.year, now.month, (now.day - now.weekday - 1));
    _doSortingOfWeeksAndMonth(lastMonthUsedTags, sevenDaysBack, maxTagsLength);
  }

  /// load last month used tags into `lastMonthUsedTags`
  void loadLastMonthUsedTags({int maxTagsLength = 12}) {
    var now = DateTime.now();
    var monthBack = DateTime(now.year, now.month, 1);
    _doSortingOfWeeksAndMonth(lastMonthUsedTags, monthBack, maxTagsLength);
  }

  void _doSortingOfWeeksAndMonth(
      RxMap<String, String> map, DateTime back, int maxTagsLength) {
    var tempTags = <TagModel>[];
    allTags.values.forEach((tag) {
      if (tag.value.time.isBefore(back)) {
        tempTags.add(tag.value);
      }
    });
    if (tempTags.isNotEmpty) {
      tempTags
          .sort((TagModel a, TagModel b) => b.time.day.compareTo(a.time.day));
      if (tempTags.length > maxTagsLength) {
        tempTags = tempTags.sublist(0, maxTagsLength);
      }
    }
    map.clear();
    tempTags.forEach((TagModel tag) {
      map[tag.key] = tag.title;
    });
  }

/*   //@action
  Future<void> loadTags() async {
    var tagsBox = await database.getAllLabel();
    tags.clear();

    for (Label tag in tagsBox) {
      TagsStore tagsStore = TagsStore(
        id: tag.key,
        name: tag.title,
        count: tag.counter,
        time: tag.lastUsedAt,
      );
      addTag(tagsStore);
    }

    /* Label secretTag = tagsBox.firstWhere(
      (Label element) => element.key == kSecretTagKey,
      orElse: () => null,
    ); */
    if (tags[kSecretTagKey] == null) {
      //print('Creating secret tag in db!');
      Label createSecretLabel = Label(
        key: kSecretTagKey,
        title: 'Secret Pics',
        photoId: [],
        counter: 1,
        lastUsedAt: DateTime.now(),
      );
      await database.createLabel(createSecretLabel);
      //tagsBox.put(kSecretTagKey, createSecretTag);

      TagsStore tagsStore = TagsStore(
        id: kSecretTagKey,
        name: 'Secret Pics',
        count: 1,
        time: DateTime.now(),
      );
      addTag(tagsStore);
    }
    loadMostUsedTags();
    loadLastWeekUsedTags();
    loadLastMonthUsedTags();

    //print('******************* loaded tags **********');
  } */

  //@action
/*   void addRecentTags(String tagKey) {
    recentTags.add(tagKey);
  } */

  //@action
/*   Future<void> editRecentTags(String oldTagKey, String newTagKey) async {
    if (recentTags.contains(oldTagKey)) {
      //print('updating tag name in recent tags');
      int indexOfTag = recentTags.indexOf(oldTagKey);
      recentTags[indexOfTag] = newTagKey;
      /* var userBox = Hive.box('user');
      User getUser = userBox.getAt(0); */
      MoorUser currentUser = await database.getSingleMoorUser();
      int indexOfRecentTag = currentUser.recentTags.indexOf(oldTagKey);
      var tempTags = List<String>.from(currentUser.recentTags);
      tempTags[indexOfRecentTag] = newTagKey;
      await database.updateMoorUser(currentUser.copyWith(recentTags: tempTags));

/* 
      getUser.recentTags[indexOfRecentTag] = newTagKey;
      userBox.putAt(0, getUser); */
    }
  } */

  Future<String> createTag(String tagName) async {
    //var tagsBox = Hive.box('tags');
    /*// //print(tagsBox.keys); */

    var tagKey = Helpers.encryptTag(tagName);
    // //print('Adding tag: $tagName');

    final lab = await _database.getLabelByLabelKey(tagKey);

    if (lab != null) {
      // //print('user already has this tag');
      return tagKey;
    }

    // //print('adding tag to database...');
    await _database.createLabel(Label(
        key: tagKey,
        title: tagName,
        photoId: <String>[],
        counter: 1,
        lastUsedAt: DateTime.now()));
    //tagsBox.put(tagKey, Tag(tagName, []));

    var tagModel =
        TagModel(key: tagKey, title: tagName, count: 1, time: DateTime.now());
    addTag(tagModel);
    addRecentTag(tagKey);

    await Analytics.sendEvent(
      Event.created_tag,
      params: {'tagName': tagName},
    );
    return tagKey;
  }

  Future<Map<String, String>> loadRecentTags() async {
    //var userBox = Hive.box('user');
    //var tagsBox = Hive.box('tags');
    var tagsList = await _database.getAllLabel();

    var getUser = await DatabaseController.to.getUser();

    //List<String> multiPicTags = multiPicTagKeys.toList();
    var suggestionTags = <String>[];
    /* searchText.value = searchText.trim(); */

    if (searchText.trim() == '') {
      for (var recent in getUser.recentTags) {
        // //print('Recent Tag: $recent');
        if (multiPicTags[recent] != null || recent == kSecretTagKey) {
          continue;
        }
        suggestionTags.add(recent);
      }

      // //print('Sugestion Length: ${suggestionTags.length} - Num of Suggestions: ${kMaxNumOfSuggestions}');

//      while (suggestions.length < maxNumOfSuggestions) {
//          if (excludeTags.contains('Hey}')) {
//            continue;
//          }
      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (var tag in tagsList) {
          var tagKey = tag.key;
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
          if (multiPicTags[tagKey] != null ||
              suggestionTags.contains(tagKey) ||
              tagKey == kSecretTagKey) {
            continue;
          }
          // //print('Adding tag key: $tagKey');
          suggestionTags.add(tagKey);
        }
      }
//      }
    } else {
      var listOfLetters = searchText.toLowerCase().split('');
      for (var tag in tagsList) {
        var tagKey = tag.key;
        if (tagKey == kSecretTagKey) continue;
        if (allTags[tagKey] != null && multiPicTags[tagKey] == null) {
          var tagsStoreValue = /* TagsController.to. */ allTags[tagKey].value;
          doCustomisedSearching(tagsStoreValue, listOfLetters, (matched) {
            suggestionTags.add(tagKey);
          });
        }
        /* String tagName = Helpers.decryptTag(tagKey);
        if (tagName.startsWith(Helpers.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        } */
      }
    }

    // //print('%%%%%%%%%% Before adding secret tag: ${suggestionTags}');
    if (multiPicTags[kSecretTagKey] == null &&
        /* !searchingTagsKeys.contains(kSecretTagKey) && */
        PrivatePhotosController.to.showPrivate.value == true &&
        searchText.value == '') {
      suggestionTags.add(kSecretTagKey);
    }

    // //print('find suggestions: $searchText - exclude tags: $multiPicTags');
    // //print(suggestionTags);
    // //print('UserController Tags: ${TagsController.to.allTags}');
    /* List<TagsStore> suggestions = TagsController.to.allTags
        .where((element) => suggestionTags.contains(element.id))
        .toList(); */
    //var suggestionsTags = <String, String>{};
    recentTagKeyList.clear();
    suggestionTags.forEach((suggestedTag) {
      if (allTags[suggestedTag] != null) {
        recentTagKeyList[suggestedTag] = '';
        //suggestions.add(TagsController.to.allTags[suggestedTag].value);
      }
    });
    // //print('Suggestions Tag Store: $suggestions');
    //tagsSuggestions.value = suggestions;
    // ignore: invalid_use_of_protected_member
    return recentTagKeyList.value;
  }

  /// load all the tags async
  Future<void> loadAllTags() async {
    var tagsBox = await _database.getAllLabel();

    for (var tag in tagsBox) {
      var tagModel = TagModel(
        key: tag.key,
        title: tag.title,
        count: tag.counter,
        time: tag.lastUsedAt,
      );
      allTags[tag.key] = Rx<TagModel>(tagModel);
    }

    if (allTags[kSecretTagKey] == null) {
      //print('Creating secret tag in db!');
      var createSecretLabel = Label(
        key: kSecretTagKey,
        title: 'Secret Pics',
        photoId: [],
        counter: 1,
        lastUsedAt: DateTime.now(),
      );

      var tagModel = TagModel(
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

  Future<void> addTagsToSelectedPics() async {
    //var tagsBox = Hive.box('tags');

    var selectedPicIds = <String>[];
    if (TabsController.to.currentTab.value == 0) {
      selectedPicIds = List<String>.from(
          TabsController.to.selectedMultiBarPics.keys.toList());
    } else if (TabsController.to.currentTab.value == 2) {
      selectedPicIds = List<String>.from(
          TaggedController.to.selectedMultiBarPics.keys.toList());
    }

    var multiTags = multiPicTags.keys.toList();

    await Future.wait(
      [
        Future.forEach(selectedPicIds, (String picId) async {
          for (var tagKey in multiTags) {
            await addTagToPic(picId: picId, tagKey: tagKey);
          }
        }),
      ],
    ).then((_) {
      /// Clear the selectedUntaggedPics as now the processing is done
      if (TabsController.to.currentTab.value == 0) {
        TabsController.to.clearSelectedUntaggedPics();
      } else if (TabsController.to.currentTab.value == 2) {
        TaggedController.to.selectedMultiBarPics.clear();
      }

      /// Also clear the multiPicTags as we have iterated and processed through it and
      /// now we have to make it empty for the next time
      clearMultiPicTags();

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        /// refresh the untaggedList and at the same time the tagged pics will also be refreshed again
        if (TabsController.to.currentTab.value == 0) {
          await TabsController.to.refreshUntaggedList();
        } else if (TabsController.to.currentTab.value == 2) {
          await TaggedController.to.refreshTaggedPhotos();
        }
      });
    });
  }

  Future<void> removeTagFromPic(
      {required String picId, required String tagKey}) async {
    var picStore = TabsController.to.picStoreMap[picId]?.value;
    picStore ??= TabsController.to.explorPicStore(picId).value;
    await picStore?.removeTagFromPic(tagKey: tagKey);

    /// Refreshing the tagged pic map as a tag is removed from the picstore
    await TaggedController.to.refreshTaggedPhotos();

    if (picStore.tags.isEmpty) {
      /// tags are empty now the untagged list should be refreshed so that this picStore will be visible there
      await TabsController.to.refreshUntaggedList();
    }
  }

  Future<void> addTagToPic(
      {required String picId, required String tagKey}) async {
    var picStore = TabsController.to.picStoreMap[picId]?.value;
    if (picStore == null) {
      var fetchedPicStore = TabsController.to.explorPicStore(picId);
      TabsController.to.picStoreMap[picId] = Rxn<PicStore?>(fetchedPicStore.value);
      picStore = fetchedPicStore.value;
    }

    /// TODO: check this is working or not, when swipe implementation is done !!
    //SwiperTabController.to.swiperPicIdList.remove(picStore);

    if (picStore == null || picStore.tags[tagKey] != null) {
      // //print('this tag is already in this picture');
      return;
    }
    if (tagKey == kSecretTagKey) {
      // //print('Should add secret tag in the end!!!');
      if (PrivatePhotosController.to.privateMap[picId] == null
          /* || TabsController.to.secretPicIds[picId] == false && !privatePics.contains(picStore) */) {
        await picStore.setIsPrivate(true);

        await Crypto.encryptImage(picStore, UserController.to.encryptionKey!);
        // //print('this pic now is private');
        /* TabsController.to.secretPicIds[picId] = true; */
        //privatePics.add(picStore);
      }
      return;
    }
    final getTag = await _database.getLabelByLabelKey(tagKey);
    if (getTag != null) {
      getTag.photoId?.add(picStore?.photoId.value);
      await _database.updateLabel(getTag);
      if (null != picStore) {
        await picStore.addTagToPic(
            tagKey: tagKey, photoId: picStore.photoId.value);
      }
    }
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
      required String newName}) {
    var tagModel = allTags[oldTagKey].value;

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
    if (tagModel != null) {
      allTags.remove(tagModel.key);
    }
  }

  Future<void> editTagName(
      {required String oldTagKey, required String newName}) async {
    /// create a new tagKey
    var newTagKey = Helpers.encryptTag(newName);

    /// use that new tagKey to make the ui changes fastly
    _editTagInternalFunction(
        oldTagKey: oldTagKey, newTagKey: newTagKey, newName: newName);

    /// as soon as the `ui` changes are done - now secretly do the background changes in async manner

    /// fetch the `Label` from the `oldTagKey`
    Label oldTag = await _database.getLabelByLabelKey(oldTagKey);

    /// Creating new label
    var createTag = Label(
        key: newTagKey,
        title: newName,
        photoId: oldTag.photoId,
        counter: oldTag.counter < 1 ? 1 : oldTag.counter,
        lastUsedAt: DateTime.now());

    await _database.createLabel(createTag);

    await Future.wait(
      [
        Future.forEach(createTag.photoId, (photoId) async {
          Photo pic = await _database.getPhotoByPhotoId(photoId);
          //Pic pic = picsBox.get(photoId);
          var indexOfOldTag = pic.tags.indexOf(oldTagKey);
          // //print('Tags in this picture: ${pic.tags}');
          if (indexOfOldTag > -1) {
            pic.tags[indexOfOldTag] = newTagKey;
          }
          await _database.updatePhoto(pic);
          //picsBox.put(photoId, pic);
          // //print('updated tag in pic ${pic.id}');
        })
      ],
    );

    await _database.deleteLabelByLabelId(oldTagKey);
    await Analytics.sendEvent(Event.edited_tag);
  }

  /// untag the pic with tags as `tagKey`
  Future<void> deleteTagFromPic({String tagKey}) async {
    //var tagsBox = Hive.box('tags');

    var label = await _database.getLabelByLabelKey(tagKey);

    if (label != null) {
      // //print('found tag going to delete it');
      // Remove a tag das fotos já taggeadas
      var tagsStore = allTags[tagKey].value;
      // //print('TagsStore Tag: ${tagsStore.name}');
      /*  TaggedPicsStore taggedPicsStore =
          taggedPics.firstWhere((element) => element.tag == tagsStore);
      for (PicStore picTagged in taggedPicsStore.pics) {
        // //print('Tagged Pic Store Pics: ${picTagged.photoId}');
        await picTagged.removeTagFromPic(tagKey: tagsStore.id);
        if (picTagged.tags.length == 0 && picTagged != currentPic) {
          // //print('this pic is not tagged anymore!');
          addPicToUntaggedPics(picStore: picTagged);
        }
      }
      taggedPics.remove(taggedPicsStore);
      recentTagKeyList.removeWhere((element) => element == tagKey);
      //appStore.removeTagFromRecent(tagKey: tagKey);
      removeTag(tagModel: tagsStore);
      await _database.deleteLabelByLabelId(tagKey); */
      //tagsBox.delete(tagKey);
      // //print('deleted from tags db');
      await Analytics.sendEvent(Event.deleted_tag);
      removeOldTagReferences(tagKey);
    }
  }
}
