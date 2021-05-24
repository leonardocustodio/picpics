import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
/* import 'package:picPics/stores/tagged_controller.dart'; */
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/utils/helpers.dart';
import '../constants.dart';
import 'database_controller.dart';
import 'swiper_tab_controller.dart';

class TagModel extends GetxController {
  RxMap _map = <String, dynamic>{}.obs;
  TagModel(
      {@required String key,
      @required String title,
      @required int count,
      @required DateTime time}) {
    assert(key != null && title != null);
    _map = RxMap<String, dynamic>(<String, dynamic>{
      'key': key,
      'title': title,
      'count': count ?? 0,
      'time': time ?? DateTime.now(),
    });
  }

  String get key => _map['key'];
  void set key(String val) => _map['key'] = val;

  String get title => _map['title'];
  void set title(String val) => _map['title'] = val;

  int get count => _map['count'];
  void set count(int val) => _map['count'] = val;

  DateTime get time => _map['time'];
  void set time(DateTime val) => _map['time'] = val;
}

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

  AppDatabase _database = AppDatabase();

  @override
  void onInit() {
    super.onInit();
    UserController.to.createDefaultTags(Get.context).then((_) async {
      await loadAllTags();
      await TagsController.to.loadRecentTags();
    });
  }

  /// load most used tags into `mostUsedTags`
  void loadMostUsedTags({int maxTagsLength = 12}) {
    var tempTags = <TagModel>[];
    allTags.forEach((_, value) {
      tempTags.add(value.value);
    });

    tempTags.sort((a, b) {
      var count = b.count.compareTo(a.count);
      if (count == 0)
        return b.title.toLowerCase().compareTo(a.title.toLowerCase());
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

  Future<void> createTag(String tagName) async {
    //var tagsBox = Hive.box('tags');
    /*// //print(tagsBox.keys); */

    String tagKey = Helpers.encryptTag(tagName);
    // //print('Adding tag: $tagName');

    Label lab = await _database.getLabelByLabelKey(tagKey);

    if (lab != null) {
      // //print('user already has this tag');
      return;
    }

    // //print('adding tag to database...');
    await _database.createLabel(Label(
        key: tagKey,
        title: tagName,
        photoId: <String>[],
        counter: 1,
        lastUsedAt: DateTime.now()));
    //tagsBox.put(tagKey, Tag(tagName, []));

    TagModel tagModel =
        TagModel(key: tagKey, title: tagName, count: 1, time: DateTime.now());
    addTag(tagModel);
    addRecentTag(tagKey);

    Analytics.sendEvent(
      Event.created_tag,
      params: {'tagName': tagName},
    );
  }

  final searchText = ''.obs;

  Future<Map<String, String>> loadRecentTags() async {
    //var userBox = Hive.box('user');
    //var tagsBox = Hive.box('tags');
    var tagsList = await _database.getAllLabel();

    MoorUser getUser = await DatabaseController.to.getUser();

    //List<String> multiPicTags = multiPicTagKeys.toList();
    List<String> suggestionTags = [];
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
        for (Label tag in tagsList) {
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
      for (Label tag in tagsList) {
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
        UserController.to.secretPhotos == true &&
        searchText == '') {
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
    return recentTagKeyList.value;
  }

  /// load all the tags async
  Future<void> loadAllTags() async {
    var tagsBox = await _database.getAllLabel();

    for (Label tag in tagsBox) {
      TagModel tagModel = TagModel(
        key: tag.key,
        title: tag.title,
        count: tag.counter,
        time: tag.lastUsedAt,
      );
      allTags[tag.key] = Rx<TagModel>(tagModel);
    }

    if (allTags[kSecretTagKey] == null) {
      //print('Creating secret tag in db!');
      Label createSecretLabel = Label(
        key: kSecretTagKey,
        title: 'Secret Pics',
        photoId: [],
        counter: 1,
        lastUsedAt: DateTime.now(),
      );

      TagModel tagModel = TagModel(
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

    var selectedPicIds = TabsController.to.selectedUntaggedPics.keys.toList();
    var multiTags = multiPicTags.keys.toList();

    await Future.wait(
      [
        Future.forEach(selectedPicIds, (String picId) async {
          for (var tagKey in multiTags) {
            await addTagToPic(picId: picId,tagKey: tagKey);
          }
          /* 
          var picStore = TabsController.to.picStoreMap[picId]?.value;
          if (picStore == null) {
            var fetchedPicStore =
                (await TabsController.to.explorPicStore(picId));
            TabsController.to.picStoreMap[picId] = fetchedPicStore;
            picStore = fetchedPicStore.value;
          }
          for (String tagKey in multiTags) {
            /// add the picId to the Tagged tab list for showing this picture there
            //addPicIdToTaggedList(tagKey, picId);

            /// remove this pic from the untaggedPicIdList list for hiding it from the untagged tab
            /* TabsController.to.allUnTaggedPicsDay.remove(tagKey);
            TabsController.to.allUnTaggedPicsMonth.remove(tagKey); */

            /// TODO: check this is working or not, when swipe implementation is done !!
            SwiperTabController.to.swiperPicIdList.remove(picStore);

            if (picStore.tags[tagKey] != null) {
              // //print('this tag is already in this picture');
              continue;
            }
            if (tagKey == kSecretTagKey) {
              // //print('Should add secret tag in the end!!!');
              if (TabsController.to.secretPicIds[picId] == null ||
                  TabsController.to.secretPicIds[picId] ==
                      false /* !privatePics.contains(picStore) */) {
                await picStore.setIsPrivate(true);
                await Crypto.encryptImage(
                    picStore, UserController.to.encryptionKey);
                // //print('this pic now is private');
                TabsController.to.secretPicIds[picId] = true;
                //privatePics.add(picStore);
              }
              /* else {
                // //print('this pic is already private');
              } */
              continue;
            }

            //Tag getTag = tagsBox.get(tagKey);
            Label getTag = await _database.getLabelByLabelKey(tagKey);
            getTag.photoId.add(picStore.photoId.value);
            await _database.updateLabel(getTag);
            //tagsBox.put(tagKey, getTag);

            await picStore.addTagToPic(
              tagKey: tagKey,
              photoId: picStore.photoId.value,
            );

            // //print('update pictures in tag');
          }

          /*  if (selectedPicsAreTagged != true) {
            // //print('Adding pic to tagged pics!');

            addPicToTaggedPics(picStore: picStore);
            removePicFromUntaggedPics(picStore: picStore);
          } */ */
        }),
      ],
    ).then((_) {
      /// Clear the selectedUntaggedPics as now the processing is done
      TabsController.to.clearSelectedUntaggedPics();

      /// Also clear the multiPicTags as we have iterated and processed through it and
      /// now we have to make it empty for the next time
      clearMultiPicTags();

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        /// refresh the untaggedList and at the same time the tagged pics will also be refreshed again
        await TabsController.to.refreshUntaggedList();
      });
    });
  }

  Future<void> removeTagFromPic({String picId, String tagKey}) async {
    var picStore = TabsController.to.picStoreMap[picId]?.value;
    if (picStore == null) {
      picStore = TabsController.to.explorPicStore(picId)?.value;
    }
    await picStore.removeTagFromPic(tagKey: tagKey);

    /// Refreshing the tagged pic map as a tag is removed from the picstore
    await TaggedController.to.refreshTaggedPhotos();

    if (picStore.tags.isEmpty) {
      /// tags are empty now the untagged list should be refreshed so that this picStore will be visible there
      await TabsController.to.refreshUntaggedList();
    }
  }

  Future<void> addTagToPic({String picId, String tagKey}) async {
    var picStore = TabsController.to.picStoreMap[picId]?.value;
    if (picStore == null) {
      var fetchedPicStore = (await TabsController.to.explorPicStore(picId));
      TabsController.to.picStoreMap[picId] = fetchedPicStore;
      picStore = fetchedPicStore.value;
    }

    /// TODO: check this is working or not, when swipe implementation is done !!
    SwiperTabController.to.swiperPicIdList.remove(picStore);

    if (picStore.tags[tagKey] != null) {
      // //print('this tag is already in this picture');
      return;
    }
    if (tagKey == kSecretTagKey) {
      // //print('Should add secret tag in the end!!!');
      if (TabsController.to.secretPicIds[picId] == null ||
          TabsController.to.secretPicIds[picId] ==
              false /* !privatePics.contains(picStore) */) {
        await picStore.setIsPrivate(true);
        await Crypto.encryptImage(picStore, UserController.to.encryptionKey);
        // //print('this pic now is private');
        TabsController.to.secretPicIds[picId] = true;
        //privatePics.add(picStore);
      }
      return;
    }
    Label getTag = await _database.getLabelByLabelKey(tagKey);
    getTag.photoId.add(picStore.photoId.value);
    await _database.updateLabel(getTag);

    await picStore.addTagToPic(
      tagKey: tagKey,
      photoId: picStore.photoId.value,
    );
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
      {@required String oldTagKey,
      @required String newTagKey,
      @required String newName}) {
    TagModel tagModel = allTags[oldTagKey].value;

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
      {@required String oldTagKey, @required String newName}) async {
    /// create a new tagKey
    String newTagKey = Helpers.encryptTag(newName);

    /// use that new tagKey to make the ui changes fastly
    _editTagInternalFunction(
        oldTagKey: oldTagKey, newTagKey: newTagKey, newName: newName);

    /// as soon as the `ui` changes are done - now secretly do the background changes in async manner

    /// fetch the `Label` from the `oldTagKey`
    Label oldTag = await _database.getLabelByLabelKey(oldTagKey);

    /// Creating new label
    Label createTag = Label(
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
          int indexOfOldTag = pic.tags.indexOf(oldTagKey);
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
    Analytics.sendEvent(Event.edited_tag);
  }

  /// untag the pic with tags as `tagKey`
  Future<void> deleteTagFromPic({String tagKey}) async {
    //var tagsBox = Hive.box('tags');

    var label = await _database.getLabelByLabelKey(tagKey);

    if (label != null) {
      // //print('found tag going to delete it');
      // Remove a tag das fotos já taggeadas
      TagModel tagsStore = allTags[tagKey].value;
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
      Analytics.sendEvent(Event.deleted_tag);
      removeOldTagReferences(tagKey);
    }
  }
}
