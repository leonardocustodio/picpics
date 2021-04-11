import 'dart:io';
import 'dart:typed_data';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tagged_date_pics_store.dart';
import 'package:picPics/stores/tagged_grid_pic_store.dart';
import 'package:picPics/stores/tagged_pics_store.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/stores/untagged_grid_pic_store.dart';
import 'package:picPics/stores/untagged_pics_store.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:share/share.dart';
import 'package:collection/collection.dart';
import 'package:mime/mime.dart';

// ignore_for_file: invalid_use_of_protected_member
class GalleryStore extends GetxController {
  AppStore appStore = AppStore.to;
  static GalleryStore get to => Get.find();
  final database = AppDatabase();

  final swipeIndex = 0.obs;
  final shouldRefreshTaggedGallery = false.obs;
  final sharedPic = false.obs;
  final trashedPic = false.obs;
  final tagsSuggestions = <TagsStore>[].obs;
  final searchText = ''.obs;
  final multiPicTags = <String, TagsStore>{}.obs;
  final currentThumbnailPic = Rx<PicStore>(null);

  final searchTagsResults = <TagsStore>[].obs;

  final showSearchTagsResults = false.obs;
  final isLoaded = false.obs;
  final isFiltered = false.obs;
  final deviceHasPics = false.obs;
  final isSearching = false.obs;

  final searchingTags = <TagsStore>[].obs;

  final selectedSwipe = 0.obs;
  final selectedThumbnail = 0.obs;
  final totalTaggedPics = 0.obs;

  final assetsPath = <AssetPathEntity>[].obs;
  final allPics = <String, PicStore>{}.obs;

  final untaggedPics = <UntaggedPicsStore>[].obs;
  final untaggedGridPics = <UntaggedGridPicStore>[].obs;
  final untaggedGridPicsByMonth = <DateTime, Map<String, PicStore>>{}.obs;

  final taggedDatePics = <TaggedDatePicsStore>[].obs;
  final taggedGridPics = <TaggedGridPicStore>[].obs;
  final taggedPics = <TaggedPicsStore>[].obs;
  final filteredPics = <PicStore>[].obs;
  final swipePics = <PicStore>[].obs;
  final thumbnailsPics = <PicStore>[].obs;
  final selectedPics = <PicStore>[].obs;
  final privatePics = <PicStore>[].obs;
  final searchingTagsKeys = <String>[].obs;
  final filteredPicsKeys = <String>[].obs;
  final taggedKeys = <String>[].obs;

/*   GalleryStore({this.appStore}) {
    tagsSuggestionsCalculate();
    loadTaggedPicsStore();

    if (appStore?.tutorialCompleted ?? false) {
      loadAssetsPath();
    }
  } */

  @override
  void onInit() {
    loadAssetsPath();
    ever(taggedPics, runTotalTaggedPicsComputation);
    ever(filteredPics, runFilteredPicsKeysComputation);
    ever(searchingTags, runFilteredPicsKeysComputation);
    ever(trashedPic, (_) {
      if (trashedPic.value) {
        setSwipeIndex(swipeIndex.value);
        setTrashedPic(false);
      }
    });

    ever(isLoaded, (_) {
      if (isLoaded.value == true) {
        refreshPicThumbnails();
      }
    });

    ever(shouldRefreshTaggedGallery, (_) {
      if (shouldRefreshTaggedGallery.value) {
        refreshItems();
        //print('##### Rebuild everything!');
      }
    });

    super.onInit();
  }

  final taggedItems = [].obs;
  final isTitleWidget = <bool>[].obs;

  void refreshItems() {
    //print('Calling refresh items!!!');
    if (isTitleWidget.isEmpty || shouldRefreshTaggedGallery.value == true) {
      taggedItems.value = [];
      isTitleWidget.value = <bool>[];

      //print('Refreshing tagged library!!!!!');
      clearPicThumbnails();

      if (searchingTagsKeys.isNotEmpty) {
        if (filteredPics.isEmpty) {
          //print('Filtered Pics is empty');
          isTitleWidget.addAll([true, true]);
          taggedItems.addAll([null, null]);
        } else {
          isTitleWidget.add(true);
          taggedItems.add(null);
          isTitleWidget.addAll(List.filled(filteredPics.length, false));
          taggedItems.addAll(filteredPics);
          addPicsToThumbnails(filteredPics);
        }

        if (searchingTagsKeys.length > 1) {
          List<TaggedPicsStore> taggedPicsStores = [];
          for (String tagKey in searchingTagsKeys) {
            TaggedPicsStore findTaggedPicStore = taggedPics.firstWhere(
                (element) => element.tag.value.id == tagKey,
                orElse: () => null);
            if (findTaggedPicStore != null) {
              taggedPicsStores.add(findTaggedPicStore);
            } else {
              TaggedPicsStore createTaggedPicStore =
                  TaggedPicsStore(tagValue: AppStore.to.tags[tagKey]);
              taggedPicsStores.add(createTaggedPicStore);
            }
          }

          for (TaggedPicsStore taggedPicsStore in taggedPicsStores) {
            if (taggedPicsStore.pics.isEmpty) {
              //print('&&&& IS EMPTY &&&&');
              isTitleWidget.add(true);
              taggedItems.add(taggedPicsStore);
              isTitleWidget.add(true);
              taggedItems.add(null);
              continue;
            }

            isTitleWidget.add(true);
            taggedItems.add(taggedPicsStore);
            isTitleWidget
                .addAll(List.filled(taggedPicsStore.pics.length, false));
            taggedItems.addAll(taggedPicsStore.pics);
            addPicsToThumbnails(taggedPicsStore.pics);
          }
        }
      } else {
        for (TaggedPicsStore taggedPicsStore in taggedPics) {
          isTitleWidget.add(true);
          taggedItems.add(taggedPicsStore);
          isTitleWidget.addAll(List.filled(taggedPicsStore.pics.length, false));
          taggedItems.addAll(taggedPicsStore.pics);
          addPicsToThumbnails(taggedPicsStore.pics);
        }
      }

      //print('@@@@@ Tagged Items Length: ${taggedItems.length}');
      setShouldRefreshTaggedGallery(false);
    }
  }

  //@action
  void loadTaggedPicsStore() {
    for (TagsStore tagsStore in appStore.tags.values.toList()) {
      TaggedPicsStore taggedPicsStore = TaggedPicsStore(tagValue: tagsStore);
      taggedPics.add(taggedPicsStore);
    }

    //print('finished adding all tagged pics stores!');
  }

  void runTotalTaggedPicsComputation(_) {
    totalTaggedPics.value = taggedPics
        .map((element) => element.pics.length)
        .toList()
        .reduce((value, element) => value + element);
  }

  void runTaggedKeysComputation(_) {
    var tags = <String, String>{};
    taggedPics.forEach((element) {
      tags[element.tag.value.id] = '';
    });
    taggedKeys.value = tags.keys.toList();
  }

  /*  @computed
  List<String> get taggedKeys {
    Set<String> tags = Set();
    taggedPics.forEach((element) {
      tags.add(element.tag.id);
    });
    // //print('Tagged Keys: ${tags}');
    return tags.toList();
  } */

  void runDeviceHasPics(_) {
    deviceHasPics.value = allPics.value.length != 0;
  }

/*   @computed
  bool get deviceHasPics {
    if (allPics.value.length == 0) {
      return false;
    } else {
      return true;
    }
  } */

  void runFilteredPicsKeysComputation(_) {
    filteredPicsKeys.value = List<String>.from(
        filteredPics.map((element) => element.photoId).toList());
  }

  void runSearchingTagsKeysComputation(_) {
    searchingTagsKeys.value =
        searchingTags.map((element) => element.id).toList();
  }

  void runIsFilteredComputation(_) {
    isFiltered.value = searchingTags.length > 0;
  }

  /*  @computed
  bool get isFiltered {
    if (searchingTags.length > 0) {
      return true;
    }
    return false;
  } */

  /*  @computed
  List<String> get searchingTagsKeys {
    //print('${count++} :searchingTagsKeys');
    return searchingTags.map((element) => element.id).toList();
  } */

  PicStore currentPic;

  void setCurrentPic(PicStore picStore) {
    currentPic = picStore;
  }

  int swipeCutOff = 0;

  //@action
  void setSwipeIndex(int value) {
    if (swipePics.isEmpty) {
      return;
    }
//    if (value > swipeIndex && value > 5) {
//      int val = value - 5;
//      if (val > swipeCutOff) {
//        swipeCutOff = value - 5;
    // //print('&&&&&&&&& setting cutoff to $swipeCutOff');
//      }
//    }

    swipeIndex.value = value;
    setCurrentPic(swipePics[swipeIndex.value]);
    Analytics.sendEvent(Event.swiped_photo);
  }

  //@action
  void clearPicThumbnails() {
    thumbnailsPics.clear();
  }

  //@action
  void addPicToThumbnails(PicStore picStore) {
    if (thumbnailsPics.contains(picStore)) {
      return;
    }
    thumbnailsPics.add(picStore);
  }

  //@action
  void addPicsToThumbnails(List<PicStore> picStores) {
    thumbnailsPics.addAll(picStores);
  }

  //@action
  void setSelectedSwipe(int value) => selectedSwipe.value = value;

  //@action
  void setSelectedThumbnail(int value) => selectedThumbnail.value = value;

  //@computed
  void runcurrentThumbnailPicComputation(_) {
    currentThumbnailPic.value = (thumbnailsPics == null ||
            selectedThumbnail.value >= thumbnailsPics.length)
        ? null
        : thumbnailsPics[selectedThumbnail.value];
  }

  //@action
  void setInitialSelectedThumbnail(PicStore picStore) {
    int indexOf = thumbnailsPics.indexOf(picStore);
    selectedThumbnail.value = indexOf;
  }

  //@action
  void setIsSearching(bool value) => isSearching.value = value;
  int count = 0;

  //@action
  void clearSearchTags() {
    setSearchText('');
    setShowSearchTagsResults(false);
    setIsSearching(false);
    searchingTags.clear();
    searchTagsResults.clear();
    filteredPics.clear();
  }

  //@action
  void setShowSearchTagsResults(bool value) =>
      showSearchTagsResults.value = value;

  bool selectedPicsAreTagged;

  //@action
  void setSelectedPics({PicStore picStore, bool picIsTagged}) {
    if (selectedPics.contains(picStore)) {
      selectedPics.remove(picStore);
    } else {
      selectedPics.add(picStore);
    }
    selectedPicsAreTagged = picIsTagged;
  }

  //@action
  void clearSelectedPics() {
    selectedPicsAreTagged = null;
    selectedPics.clear();
  }

  //@action
  void addToMultiPicTags(String tagKey) {
    if (multiPicTags[tagKey] == null && appStore.tags[tagKey] != null) {
      /* TagsStore tagsStore =
          appStore.tags.firstWhere((element) => element.id == tagKey);
      multiPicTags[tagKey] = tagsStore; */
      multiPicTags[tagKey] = appStore.tags[tagKey];
    }
  }

  //@action
  void removeFromMultiPicTags(String tagKey) {
    if (multiPicTags[tagKey] != null) {
      //TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == tagKey);
      multiPicTags.remove(tagKey);
    }
  }

  //@action
  void clearMultiPicTags() {
    multiPicTags.clear();
  }

  //@action
  void setSearchText(String value) {
    searchText.value = value;
    tagsSuggestionsCalculate();
  }

/*   Future<List<Label>> getLabels() async {
    return await database.getAllLabel();
  }

  Future<MoorUser> getUser() async {
    return await database.getSingleMoorUser();
  } */

  Future<List<TagsStore>> tagsSuggestionsCalculate() async {
    //var userBox = Hive.box('user');
    //var tagsBox = Hive.box('tags');
    var tagsList = await database.getAllLabel();
    MoorUser getUser = await database.getSingleMoorUser();

    //List<String> multiPicTags = multiPicTagKeys.toList();
    List<String> suggestionTags = [];
    searchText.value = searchText.trim();

    if (searchText == '') {
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

        var tagsStoreValue = appStore.tags[tagKey];
        doCustomisedSearching(tagsStoreValue, listOfLetters, (matched) {
          suggestionTags.add(tagKey);
        });
        /* String tagName = Helpers.decryptTag(tagKey);
        if (tagName.startsWith(Helpers.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        } */
      }
    }

    // //print('%%%%%%%%%% Before adding secret tag: ${suggestionTags}');
    if (multiPicTags[kSecretTagKey] == null &&
        !searchingTagsKeys.contains(kSecretTagKey) &&
        appStore.secretPhotos == true &&
        searchText == '') {
      suggestionTags.add(kSecretTagKey);
    }

    // //print('find suggestions: $searchText - exclude tags: $multiPicTags');
    // //print(suggestionTags);
    // //print('AppStore Tags: ${appStore.tags}');
    /* List<TagsStore> suggestions = appStore.tags
        .where((element) => suggestionTags.contains(element.id))
        .toList(); */
    var suggestions = <TagsStore>[];
    suggestionTags.forEach((suggestedTag) {
      if (appStore.tags[suggestedTag] != null) {
        suggestions.add(appStore.tags[suggestedTag]);
      }
    });
    // //print('Suggestions Tag Store: $suggestions');
    tagsSuggestions.value = suggestions;
    return suggestions;
  }

  //@action
  void addPicToTaggedPics({PicStore picStore, bool toInitialIndex = false}) {
    for (TagsStore tag in picStore.tags.values.toList()) {
      TaggedPicsStore taggedPicsStore = taggedPics
          .firstWhere((element) => element.tag == tag, orElse: () => null);

      if (taggedPicsStore == null) {
        taggedPicsStore = TaggedPicsStore(tagValue: tag);
        taggedPics.add(taggedPicsStore);
      }

      if (taggedPicsStore.pics.contains(picStore)) {
        continue;
      }

      if (toInitialIndex) {
        taggedPicsStore.pics.insert(0, picStore);
      } else {
        taggedPicsStore.pics.add(picStore);
      }
    }

    // //print('Find right place to add tagged ${picStore.photoId}');
    DateTime picDate = picStore.createdAt;
    TaggedDatePicsStore taggedDatePicsStore = taggedDatePics.firstWhere(
        (element) => Utils.isSameDay(element.date, picDate),
        orElse: () => null);
    if (taggedDatePicsStore == null) {
      taggedDatePicsStore = TaggedDatePicsStore(date: picDate);

      if (taggedDatePics.length == 0) {
        // //print('Adding picStore from $picDate to index 0');
        taggedDatePics.add(taggedDatePicsStore);
      } else {
        bool hasAdded = false;
        for (int x = 0; x < taggedDatePics.length; x++) {
          if (taggedDatePics[x].date.isBefore(picDate)) {
            // //print('Adding picStore from $picDate to index $x');
            taggedDatePics.insert(x, taggedDatePicsStore);
            hasAdded = true;
            break;
          }
        }
        if (hasAdded == false) {
          // //print('Adding picStore from $picDate to last index');
          taggedDatePics.add(taggedDatePicsStore);
        }
      }
    }

    var date = taggedDatePicsStore.date;
    var newPicStore = TaggedGridPicStore(picStore: picStore);

    var gridPicIndex =
        taggedGridPics.indexWhere((element) => element.date == date);

    if (gridPicIndex != -1) {
      // //print('Different than null');
      taggedGridPics.insert(gridPicIndex + 1, newPicStore);
    } else {
      // //print('Is null');
      for (int x = 0; x < taggedGridPics.length; x++) {
        if (taggedGridPics[x].date == null) {
          continue;
        }
        if (taggedGridPics[x].date.isBefore(date)) {
          // //print('Date is before');
          var newDateStore = TaggedGridPicStore(date: date);
          taggedGridPics.insert(x, newPicStore);
          taggedGridPics.insert(x, newDateStore);
          break;
        }
      }
    }

    taggedDatePicsStore.addPicStore(picStore);
    setShouldRefreshTaggedGallery(true);
  }

  //@action
  void removePicFromTaggedPics({PicStore picStore, bool forceDelete = false}) {
    // //print('removePicFromTaggedPics');
    List<TaggedPicsStore> toDelete = [];

    for (TaggedPicsStore taggedPicsStore in taggedPics) {
      if (picStore.tags[taggedPicsStore.tag.value.id] != null &&
          forceDelete == false) {
        // //print('this tag should not be removed');
        continue;
      }

      if (taggedPicsStore.pics.contains(picStore)) {
        // //print('Removed ${picStore.photoId} from ${taggedPicsStore.tag.name}');
        taggedPicsStore.pics.remove(picStore);
        if (taggedPicsStore.pics.isEmpty) {
          toDelete.add(taggedPicsStore);
        }
      }
    }

    for (TaggedPicsStore deleteStore in toDelete) {
      taggedPics.remove(deleteStore);
    }

    setShouldRefreshTaggedGallery(true);
    tagsSuggestionsCalculate();
  }

  //@action
  void deleteEntity(String entityId) {
    // //print('Deleting entity...');

    if (allPics.value[entityId] == null) {
      // //print('This pic is not on picPics!!!');
      return;
    }

    PicStore picStore = allPics.value[entityId];
    removePicFromTaggedPics(picStore: picStore, forceDelete: true);
    removePicFromUntaggedPics(picStore: picStore);
    filteredPics.remove(picStore);
    swipePics.remove(picStore);
    allPics.value.remove(picStore);

    // //print('#@#@#@# Total photos: ${allPics.value.length}');
  }

  //@action
  Future<void> addEntity(AssetEntity entity) async {
    // //print('Adding new entity....');

    if (allPics.value[entity.id] != null) {
      // //print('This pic is already in picPics!!!');
      return;
    }

    PicStore pic = PicStore(
      entityValue: entity,
      photoIdValue: entity.id,
      createdAt: entity.createDateTime,
      originalLatitude: entity.latitude,
      originalLongitude: entity.longitude,
      isStarredValue: null,
    );
    await pic.tagsSuggestionsCalculate();
    await pic.loadPicInfo();

    if (pic.isPrivate == true) {
      // //print('This pic is private not loading it!');
      return;
    }

    allPics.value[pic.photoId.value] = pic;
    if (pic.tags.length > 0) {
      //print('has pic info! and this pic has tags in it!!!!');
      addPicToTaggedPics(picStore: pic, toInitialIndex: true);
    } else {
      //print('has pic info! and this pic doesnt have tag!!!!');
      swipePics.insert(0, pic);
      addPicToUntaggedPics(picStore: pic);
    }

    // //print('#@#@#@# Total photos: ${allPics.value.length}');
  }

  //@action
  void addPicToUntaggedPics({PicStore picStore}) {
    DateTime picDate = picStore.createdAt;

    UntaggedPicsStore untaggedPicsStore = untaggedPics.firstWhere(
        (element) => Utils.isSameDay(element.date, picDate),
        orElse: () => null);
    if (untaggedPicsStore == null) {
      untaggedPicsStore = UntaggedPicsStore(date: picDate);

      if (untaggedPics.length == 0) {
        // //print('Adding picStore from $picDate to index 0');
        untaggedPics.add(untaggedPicsStore);
      } else {
        bool hasAdded = false;
        for (int x = 0; x < untaggedPics.length; x++) {
          if (untaggedPics[x].date.isBefore(picDate)) {
            // //print('Adding picStore from $picDate to index $x');
            untaggedPics.insert(x, untaggedPicsStore);
            hasAdded = true;
            break;
          }
        }
        if (hasAdded == false) {
          // //print('Adding picStore from $picDate to last index');
          untaggedPics.add(untaggedPicsStore);
        }
      }
    }

    var date = untaggedPicsStore.date;
    var newPicStore = UntaggedGridPicStore(picStore: picStore);
    var dateTime = DateTime.utc(date.year, date.month);
    if (untaggedGridPicsByMonth[dateTime] == null) {
      untaggedGridPicsByMonth[dateTime] = Map<String, PicStore>();
    }
    untaggedGridPicsByMonth[dateTime][newPicStore.picStore.photoId.value] =
        newPicStore.picStore;

    var gridPicIndex =
        untaggedGridPics.indexWhere((element) => element.date == date);

    if (gridPicIndex != -1) {
      // //print('Different than null');
      untaggedGridPics.insert(gridPicIndex + 1, newPicStore);
    } else {
      // //print('Is null');
      for (int x = 0; x < untaggedGridPics.length; x++) {
        if (untaggedGridPics[x].date == null) {
          continue;
        }
        if (untaggedGridPics[x].date.isBefore(date)) {
          // //print('Date is Before');
          var newDateStore = UntaggedGridPicStore(date: date);
          untaggedGridPics.insert(x, newPicStore);
          untaggedGridPics.insert(x, newDateStore);
          break;
        }
      }
    }

/*     var gridPicMonthIndex = untaggedGridPicsByMonth.indexWhere(
        (element) => element.date == DateTime.utc(date.year, date.month));
    if (gridPicMonthIndex != -1) {
      untaggedGridPicsByMonth.insert(gridPicMonthIndex + 1, newPicStore);
    } else {
      for (int x = 0; x < untaggedGridPicsByMonth.length; x++) {
        if (untaggedGridPicsByMonth[x].date == null) {
          continue;
        }
        if (untaggedGridPicsByMonth[x].date.isBefore(date)) {
          var newDateStore =
              UntaggedGridPicStore(date: DateTime.utc(date.year, date.month));
          untaggedGridPicsByMonth.insert(x, newPicStore);
          untaggedGridPicsByMonth.insert(x, newDateStore);
          break;
        }
      }
    } */

    untaggedPicsStore.addPicStore(picStore);

    //tagsSuggestionsCalculate();
  }

  //@action
  void removePicFromUntaggedPics({PicStore picStore}) {
    var toDelete = <UntaggedPicsStore>[];

    for (var untaggedPicStore in untaggedPics) {
      if (untaggedPicStore.picStores[picStore.photoId] != null) {
        // //print('Removing ${picStore.photoId} from untagged pic store');
        untaggedPicStore.removePicStore(picStore);
        untaggedGridPics.removeWhere((element) => element.picStore == picStore);
        var dateTime =
            DateTime.utc(picStore.createdAt.year, picStore.createdAt.month);
        if (untaggedGridPicsByMonth[dateTime] != null) {
          untaggedGridPicsByMonth[dateTime].remove(picStore.photoId);
        }
        /* untaggedGridPicsByMonth
            .removeWhere((element) => element.picStore == picStore); */

        if (untaggedPicStore.picStores.length == 0) {
          // //print('Removing untaggedPicStore since there are no more pics in it');
          toDelete.add(untaggedPicStore);
        }
        break;
      }
    }

    for (var untaggedPicStore in toDelete) {
      untaggedPics.remove(untaggedPicStore);
      untaggedGridPics
          .removeWhere((element) => element.date == untaggedPicStore.date);

      /* int indexOfMonth = untaggedGridPicsByMonth.indexWhere((element) =>
          element.date ==
          DateTime.utc(
              untaggedPicStore.date.year, untaggedPicStore.date.month)); */
      // //print('Index of Month: $indexOfMonth');

      /* if (indexOfMonth >= untaggedGridPicsByMonth.length - 1) {
        continue;
      } */
      var dateTime =
          DateTime.utc(untaggedPicStore.date.year, untaggedPicStore.date.month);

      if (untaggedGridPicsByMonth[dateTime] != null) {}

      /* if (untaggedGridPicsByMonth[indexOfMonth + 1].date != null) {
        untaggedGridPicsByMonth.removeAt(indexOfMonth);
      } */
    }
  }

  //@action
  Future<void> loadEntities() async {
    if (assetsPath.isEmpty) {
      return;
    }

    AssetPathEntity assetPathEntity = assetsPath[0];
    final List<AssetEntity> list = await assetPathEntity.getAssetListRange(
        start: 0, end: assetPathEntity.assetCount);
    var privatePhotoIdMap = <String, int>{};
    int index = 0;

    (await database.getNonPrivatePhotoIdList()).forEach((photo) {
      privatePhotoIdMap[photo.id] = index;
      index += 1;
    });
    list.sort((a, b) {
      var year = b.createDateTime.year.compareTo(a.createDateTime.year);
      if (year == 0)
        return b.createDateTime.month.compareTo(a.createDateTime.month);
      return year;
    });

    list.forEach((entity) {
      if (privatePhotoIdMap[entity.id] == null) {
        var dateTime = DateTime.utc(
            entity.createDateTime.year, entity.createDateTime.month);
        if (untaggedGridPicsByMonth[dateTime] == null) {
          untaggedGridPicsByMonth[dateTime] = Map<String, PicStore>();
        }
        untaggedGridPicsByMonth[dateTime][entity.id] = null;
      }
    });
    isLoaded.value = true;

    //DateTime currentDate = DateTime(1000);
    // //print(entity.id);
    // debug//print('Created At: ${entity.modifiedDateTime}');
    Future.delayed(Duration(milliseconds: 200), () {
      Future.forEach(list, (entity) async {
        if (privatePhotoIdMap[entity.id] == null) {
          //print('This pic is not private loading it!');

          PicStore pic = PicStore(
            isStarredValue: null,
            entityValue: entity,
            photoIdValue: entity.id,
            createdAt: entity.createDateTime,
            originalLatitude: entity.latitude,
            originalLongitude: entity.longitude,
          );
          await pic.tagsSuggestionsCalculate();
          await pic.loadPicInfo();

          allPics.value[pic.photoId.value] = pic;

          if (pic.tags.length > 0) {
            // //print('has pic info! and this pic has tags in it!!!!');
            addPicToTaggedPics(picStore: pic);
          } else {
            // //print('has pic info! and this pic doesnt have tag!!!!');
            addPicToUntaggedPics(picStore: pic);

            swipePics.add(pic);
          }
          if (allPics.value.length > 0 && allPics.value.length < 2)
            appStore.setDefaultWidgetImage(
                allPics.value[allPics.value.keys.toList()[0]].entity.value);
        }
      }).then((_) {
        sortUntaggedPhotos();
        sortTaggedPhotos();
      });
    });
/* 
    
 */
    // //print('#@#@#@# Total photos: ${allPics.value.length}');
  }

  //@action
  void sortTaggedPhotos() {
    taggedGridPics.clear();

    for (var taggedPic in taggedDatePics) {
      taggedGridPics.add(TaggedGridPicStore(date: taggedPic.date));

      for (var picStore in taggedPic.picStores.values) {
        var gridPicStore = TaggedGridPicStore(picStore: picStore);
        taggedGridPics.add(gridPicStore);
      }
    }
  }

  //@action
  void sortUntaggedPhotos() {
    //untaggedGridPics.clear();

    //DateTime currentMonth;

    /* for (var untaggedPic in untaggedPics) {
      untaggedGridPics.add(UntaggedGridPicStore(date: untaggedPic.date));

      var monthDate =
          DateTime.utc(untaggedPic.date.year, untaggedPic.date.month);
      if (currentMonth != monthDate) {
        untaggedGridPicsByMonth.add(UntaggedGridPicStore(date: monthDate));
        currentMonth = monthDate;
        // //print('Adding month date: $monthDate');
      }

      for (var picStore in untaggedPic.picStores.values) {
        var gridPicStore = UntaggedGridPicStore(picStore: picStore);
        untaggedGridPics.add(gridPicStore);
        untaggedGridPicsByMonth.add(gridPicStore);
      }
    } */
  }

  //@action
  Future<void> loadAssetsPath() async {
    FilterOptionGroup filterOptionGroup = FilterOptionGroup();
    filterOptionGroup.addOrderOption(
      OrderOption(
        type: OrderOptionType.updateDate,
        asc: false,
      ),
    );

    final List<AssetPathEntity> assets = await PhotoManager.getAssetPathList(
      hasAll: true,
      type: RequestType.image,
      onlyAll: true,
      filterOption: filterOptionGroup,
    );
    assetsPath.addAll(assets);
    // //print('#@#@#@# Total galleries: ${assetsPath.length}');
    isLoaded.value = true;
    await loadEntities();
    await loadPrivateAssets();

    setSwipeIndex(0);
  }

  //@action
  Future<void> loadPrivateAssets() async {
    if (appStore.secretPhotos != true) {
      // //print('Secret photos is off - not loading private pics');
      return;
    }
/* 
    var secretBox = Hive.box('secrets'); */
    var secretBox = await database.getAllPrivate();

    for (Private secretPic in secretBox) {
      PicStore pic = PicStore(
        entityValue: null,
        isStarredValue: null,
        photoIdValue: secretPic.id,
        createdAt: secretPic.createDateTime,
        originalLatitude: secretPic.originalLatitude,
        originalLongitude: secretPic.originalLongitude,
      );
      await pic.tagsSuggestionsCalculate();
      await pic.loadPicInfo();

      allPics.value[pic.photoId.value] = pic;

      if (pic.tags.length > 0) {
        // //print('has pic info! and this pic has tags in it!!!!');
        addPicToTaggedPics(picStore: pic);
      } else {
        // //print('has pic info! and this pic doesnt have tag!!!!');
        swipePics.insert(0, pic);
        addPicToUntaggedPics(picStore: pic);
      }

      if (pic.isPrivate == true) {
        // //print('Adding pic to private pics!!!');
        privatePics.add(pic);
      }
    }

    // //print('#@#@#@# Total photos with private photos: ${allPics.value.length}');
  }

  //@action
  void setTrashedPic(bool value) => trashedPic.value = value;

  //@action
  Future<void> trashMultiplePics(Set<PicStore> selectedPics) async {
    List<String> selectedPicsIds =
        selectedPics.map((e) => e.photoId.value).toList();

    bool deleted = false;

    final List<String> result =
        await PhotoManager.editor.deleteWithIds(selectedPicsIds);
    if (result.isNotEmpty) {
      deleted = true;
    }

    if (deleted) {
      /* var picsBox = Hive.box('pics');
      var tagsBox = Hive.box('tags'); */

      Future.wait([
        Future.forEach(selectedPics, (PicStore picStore) async {
          Photo pic = await database.getPhotoByPhotoId(picStore.photoId.value);

          if (pic != null) {
            // //print('pic is in db... removing it from db!');
            List<String> picTags = List<String>.from(pic.tags);
            Future.wait([
              Future.forEach(picTags, (tagKey) async {
                Label tag = await database.getLabelByLabelKey(tagKey);
                tag.photoId.remove(picStore.photoId);
                // //print('removed ${picStore.photoId} from tag ${tag.title}');
                await database.updateLabel(tag);
                //tagsBox.put(tagKey, tag);

                if (tagKey == kSecretTagKey) {
                  picStore.removePrivatePath();
                  picStore.deleteEncryptedPic();
                }
              })
            ]);

            //picsBox.delete(picStore.photoId);
            await database.deletePhotoByPhotoId(picStore.photoId.value);
            // //print('removed ${picStore.photoId} from database');
          }

          filteredPics.remove(picStore);
          removePicFromTaggedPics(picStore: picStore, forceDelete: true);
          swipePics.remove(picStore);
          removePicFromUntaggedPics(picStore: picStore);
          allPics.value.remove(picStore);
          appStore.setDefaultWidgetImage(allPics.value[0].entity.value);
        })
      ]);

      Analytics.sendEvent(Event.deleted_photo);
      // //print('Reaction!');
      selectedPics.clear();
      setTrashedPic(true);
    }
  }

  //@action
  Future<void> trashPic(PicStore picStore) async {
    // //print('Going to trash pic!');
    bool deleted = await picStore.deletePic();
    // //print('Deleted pic: $deleted');

    if (deleted) {
      filteredPics.remove(picStore);
      removePicFromTaggedPics(picStore: picStore, forceDelete: true);
      swipePics.remove(picStore);
      removePicFromUntaggedPics(picStore: picStore);
      allPics.value.remove(picStore);
      appStore.setDefaultWidgetImage(allPics.value[0].entity.value);
    }

    Analytics.sendEvent(Event.deleted_photo);
    // //print('Reaction!');
    setTrashedPic(true);
  }

  Future<String> _writeByteToImageFile(Uint8List byteData) async {
    Directory tempDir = await getTemporaryDirectory();
    File imageFile = File(
        '${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData);
    return imageFile.path;
  }

  //@action
  void setSharedPic(bool value) => sharedPic.value = value;

  //@action
  Future<void> sharePics({List<PicStore> picsStores}) async {
    var imageList = <String>[], mimeList = <String>[];

    for (PicStore pic in picsStores) {
      AssetEntity data = pic.entity.value;

      if (data == null) {
        var bytes = await pic.assetOriginBytes;
        String path = await _writeByteToImageFile(bytes);
        imageList.add(path);
        mimeList.add(lookupMimeType(path));
      } else {
        // var bytes = await data.thumbDataWithSize(
        //   600,
        //   800,
        //   format: ThumbFormat.jpeg,
        // );
        // String path = await _writeByteToImageFile(bytes);

        String path = (await data.file).path;
        String mime = lookupMimeType(path);
        imageList.add(path);
        mimeList.add(mime);
      }

//      if (Platform.isAndroid) {
//        var bytes = await data.originBytes;
//        bytesPhotos['$x.jpg'] = bytes;
//      } else {
//        var bytes = await data.thumbDataWithSize(
//          data.size.width.toInt(),
//          data.size.height.toInt(),
//          format: ThumbFormat.jpeg,
//        );
//        bytesPhotos['$x.jpg'] = bytes;
//      }
//      x++;
    }

    // //print('Image List: $imageList');
    // //print('Mime List: $mimeList');

    Analytics.sendEvent(Event.shared_photos);

    Share.shareFiles(
      imageList,
      mimeTypes: mimeList,
    );

//    setSharedPic(true);

    return;
  }

  //@action
  Future<void> editTag({String oldTagKey, String newName}) async {
    //var tagsBox = Hive.box('tags');
    //var picsBox = Hive.box('pics');

    String newTagKey = Helpers.encryptTag(newName);
    Label oldTag = await database.getLabelByLabelKey(oldTagKey);

    // Creating new label
    Label createTag = Label(
        key: newTagKey,
        title: newName,
        photoId: oldTag.photoId,
        counter: oldTag.counter < 1 ? 1 : oldTag.counter,
        lastUsedAt: DateTime.now());
    await database.createLabel(createTag);
    //tagsBox.put(newTagKey, createTag);

    await Future.wait(
      [
        Future.forEach(createTag.photoId, (photoId) async {
          Photo pic = await database.getPhotoByPhotoId(photoId);
          //Pic pic = picsBox.get(photoId);
          int indexOfOldTag = pic.tags.indexOf(oldTagKey);
          // //print('Tags in this picture: ${pic.tags}');
          pic.tags[indexOfOldTag] = newTagKey;
          await database.updatePhoto(pic);
          //picsBox.put(photoId, pic);
          // //print('updated tag in pic ${pic.id}');
        })
      ],
    );

    // Altera a tag
    appStore.editTag(
        oldTagKey: oldTagKey, newTagKey: newTagKey, newName: newName);
    appStore.editRecentTags(oldTagKey, newTagKey);
    await database.deleteLabelByLabelId(oldTagKey);
    //tagsBox.delete(oldTagKey);

    // //print('finished updating all tags');
    Analytics.sendEvent(Event.edited_tag);
  }

  //@action
  Future<void> deleteTag({String tagKey}) async {
    //var tagsBox = Hive.box('tags');

    var label = await database.getLabelByLabelKey(tagKey);

    if (label != null) {
      // //print('found tag going to delete it');

      // Remove a tag das fotos já taggeadas
      TagsStore tagsStore = appStore.tags[tagKey];
      // //print('TagsStore Tag: ${tagsStore.name}');
      TaggedPicsStore taggedPicsStore =
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
      appStore.removeTagFromRecent(tagKey: tagKey);
      appStore.removeTag(tagsStore: tagsStore);
      await database.deleteLabelByLabelId(tagKey);
      //tagsBox.delete(tagKey);
      // //print('deleted from tags db');
      Analytics.sendEvent(Event.deleted_tag);
    }
  }

  //@action
  void addTagToSearchFilter() {
    if (searchingTagsKeys.contains(DatabaseManager.instance.selectedTagKey)) {
      return;
    }

    TagsStore tagsStore =
        appStore.tags[DatabaseManager.instance.selectedTagKey];
    searchingTags.add(tagsStore);
    // //print('searching tags: $searchingTags');
    searchPicsWithTags();
  }

  void removeTagFromSearchFilter() {
    if (searchingTagsKeys.contains(DatabaseManager.instance.selectedTagKey)) {
      TagsStore tagsStore =
          appStore.tags[DatabaseManager.instance.selectedTagKey];
      searchingTags.remove(tagsStore);
      // //print('searching tags: $searchingTags');
      searchPicsWithTags();
    }
  }

  //@action
  Future<void> searchPicsWithTags() async {
    //var tagsBox = Hive.box('tags');
    /*// //print('%%%% Tags Keys: ${tagsBox.keys}'); */

    filteredPics.clear();

    var tempPhotosIds = <String>[];
    bool firstInteraction = true;

    Future.wait(
      [
        Future.forEach(searchingTagsKeys, (tagKey) async {
          // //print('filtering tag: $tagKey');
          Label getTag = await database.getLabelByLabelKey(tagKey);
          //Tag getTag = tagsBox.get(tagKey);
          List<String> photosIds = getTag.photoId;
          // //print('photos Ids in this tag: $photosIds');

          if (firstInteraction) {
            // //print('adding all photos because it is firt interaction');
            tempPhotosIds.addAll(photosIds);
            firstInteraction = false;
          } else {
            // //print('tempPhotoId: $tempPhotosIds');
            List<String> auxArray = [];
            auxArray.addAll(tempPhotosIds);

            for (var photoId in tempPhotosIds) {
              // //print('checking if photoId is there: $photoId');
              if (!photosIds.contains(photoId)) {
                auxArray.remove(photoId);
                // //print('removing $photoId because doesnt have $tagKey');
              }
            }
            tempPhotosIds = auxArray;
          }
        }),
      ],
    );

    // //print('Temp photos ids: $tempPhotosIds');
    // //print('All Pics: ${allPics.valueKeys}');
    filteredPics.addAll(tempPhotosIds
        .where((photoId) => allPics.value[photoId] != null)
        .map((e) => allPics.value[e])
        .toList()); // Verificar essa classe para otimizar
    // //print('Search Photos: $filteredPics');
    // //print('Searcing Tags Keys: $searchingTags');

    setShouldRefreshTaggedGallery(true);
    Analytics.sendEvent(Event.searched_photos);
  }

  //@action
  void searchResultsTags(String text) {
    text = text.trim();
    searchTagsResults.clear();
    if (text == '') {
      setShowSearchTagsResults(false);
      return;
    }
    var listOfLetters = text.toLowerCase().split('');

    setShowSearchTagsResults(true);

    for (MapEntry<String, TagsStore> map in appStore.tags.entries) {
      TagsStore tagStore = map.value;
      if (tagStore.id == kSecretTagKey) {
        continue;
      }

      doCustomisedSearching(tagStore, listOfLetters, (matched) {
        if (matched) searchTagsResults.add(tagStore);
      });
      /* if (Helpers.stripTag(tagStore.name).startsWith(Helpers.stripTag(text))) {
        searchTagsResults.add(tagStore);
      } */
    }
  }

  // Create tag for using in multipic
  Future<void> createTag(String tagName) async {
    //var tagsBox = Hive.box('tags');
    /*// //print(tagsBox.keys); */

    String tagKey = Helpers.encryptTag(tagName);
    // //print('Adding tag: $tagName');

    Label lab = await database.getLabelByLabelKey(tagKey);

    if (lab != null) {
      // //print('user already has this tag');
      return;
    }

    // //print('adding tag to database...');
    await database.createLabel(Label(
        key: tagKey,
        title: tagName,
        photoId: <String>[],
        counter: 1,
        lastUsedAt: DateTime.now()));
    //tagsBox.put(tagKey, Tag(tagName, []));

    TagsStore tagsStore =
        TagsStore(id: tagKey, name: tagName, count: 1, time: DateTime.now());
    appStore.addTag(tagsStore);
    appStore.addTagToRecent(tagKey: tagKey);

    Analytics.sendEvent(
      Event.created_tag,
      params: {'tagName': tagName},
    );
  }

  //@action
  Future<void> addTagsToSelectedPics() async {
    //var tagsBox = Hive.box('tags');

    Future.wait(
      [
        Future.forEach(selectedPics, (PicStore picStore) async {
          for (String tagKey in multiPicTags.keys.toList()) {
            if (picStore.tags[tagKey] != null) {
              // //print('this tag is already in this picture');
              continue;
            }
            if (tagKey == kSecretTagKey) {
              // //print('Should add secret tag in the end!!!');
              if (!privatePics.contains(picStore)) {
                await picStore.setIsPrivate(true);
                await Crypto.encryptImage(picStore, appStore.encryptionKey);
                // //print('this pic now is private');
                privatePics.add(picStore);
              } else {
                // //print('this pic is already private');
              }
              continue;
            }

            //Tag getTag = tagsBox.get(tagKey);
            Label getTag = await database.getLabelByLabelKey(tagKey);
            getTag.photoId.add(picStore.photoId.value);
            await database.updateLabel(getTag);
            //tagsBox.put(tagKey, getTag);

            await picStore.addTagToPic(
              tagKey: tagKey,
              photoId: picStore.photoId.value,
            );

            // //print('update pictures in tag');
          }

          if (selectedPicsAreTagged != true) {
            // //print('Adding pic to tagged pics!');
            addPicToTaggedPics(picStore: picStore);
            removePicFromUntaggedPics(picStore: picStore);
            swipePics.remove(picStore);
          }
        }),
      ],
    );

    clearSelectedPics();
    clearMultiPicTags();
  }

//  void registerObserve() {
//    try {
/*// //print('%%%%%% Registered change notifier'); */
//      PhotoManager.addChangeCallback(_onAssetChange);
//      PhotoManager.startChangeNotify();
//    } catch (e) {
/*// //print('Error when registering assets callback: $e'); */
//    }
//  }

  //@action
  Future<void> _onAssetChange(MethodCall call) async {
    // //print('#!#!#!#!#!#! asset changed: ${call.arguments}');
//
//    List<dynamic> createdPics = call.arguments['create'];
//    List<dynamic> deletedPics = call.arguments['delete'];
//
//    return;
//
/*// //print(deletedPics); */
//
//    if (deletedPics.length > 0) {
    // //print('### deleted pics from library!');
//      for (var pic in deletedPics) {
/*// //print('Pic deleted Id: ${pic['id']}'); */
////        AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
////        AssetEntity entity = pathProvider.orderedList.firstWhere((element) => element.id == pic['id'], orElse: () => null);
////
////        if (entity != null) {
////          galleryStore.trashPic(picStore)
////          DatabaseManager.instance.deletedPic(
////            entity,
////            removeFromDb: false,
////          );
////        }
//      }
//    }
//
//    if (createdPics.length > 0) {
//      for (var pic in createdPics) {
/*// //print('Pic created Id: ${pic['id']}'); */
//        AssetEntity picEntity = await AssetEntity.fromId(pic['id']);
//        addEntity(picEntity);
//      }
//    }
  }

  //@action
  Future<void> removeAllPrivatePics() async {
    for (PicStore private in privatePics) {
      removePicFromTaggedPics(picStore: private, forceDelete: true);
      filteredPics.remove(private);
      thumbnailsPics.remove(private);
      selectedPics.remove(private);
      swipePics.remove(private);
      removePicFromUntaggedPics(picStore: private);
      allPics.value.remove(private);
    }
    privatePics.clear();
  }

  //@action
  Future<void> checkIsLibraryUpdated() async {
    // //print('Scanning library again....');

    final List<AssetPathEntity> assets = await PhotoManager.getAssetPathList(
      hasAll: true,
      type: RequestType.image,
      onlyAll: true,
    );

    final AssetPathEntity assetPathEntity = assets[0];
    final List<AssetEntity> assetList = await assetPathEntity.getAssetListRange(
        start: 0, end: assetPathEntity.assetCount);
    final Set<String> entitiesIds = assetList.map((e) => e.id).toSet();
    final bool isEqual =
        SetEquality().equals(entitiesIds, allPics.value.keys.toSet());

    if (isEqual) {
      // //print('Library is updated!!!!!!');
      // //print('#@#@#@# Total photos: ${allPics.value.length}');
    } else {
      // //print('Library not updated!!!');

      final Set<String> createdPics =
          entitiesIds.difference(allPics.value.keys.toSet());
      final Set<String> deletedPics =
          allPics.value.keys.toSet().difference(entitiesIds);

      // //print('Created: $createdPics');
      // //print('Deleted: $deletedPics');

      for (String created in createdPics) {
        AssetEntity entity = await AssetEntity.fromId(created);
        addEntity(entity);
      }

      for (String deleted in deletedPics) {
        deleteEntity(deleted);
      }
    }

    await loadPrivateAssets();
  }

  //@action
  void setShouldRefreshTaggedGallery(bool value) =>
      shouldRefreshTaggedGallery.value = value;

  //@action
  Future<void> removeTagFromPic({PicStore picStore, String tagKey}) async {
    await picStore.removeTagFromPic(tagKey: tagKey);
    removePicFromTaggedPics(picStore: picStore);

    if (picStore.tags.isEmpty) {
      addPicToUntaggedPics(picStore: picStore);
      // //print('this pic now doesnt have tags!');
    }
    await tagsSuggestionsCalculate();
  }

  //@action
  Future<void> addTagToPic({PicStore picStore, String tagName}) async {
    if (picStore.tags.isEmpty) {
      // //print('this pic now has tags!');
      removePicFromUntaggedPics(picStore: picStore);
    }

    await picStore.addTag(tagName: tagName);

    await addPicToTaggedPics(picStore: picStore);
    await tagsSuggestionsCalculate();
  }

  //@action
  Future<void> setPrivatePic({PicStore picStore, bool private}) async {
    String originalPhotoId = '${currentPic.photoId}';
    await currentPic.setIsPrivate(private);

    if (currentPic.isPrivate == true) {
      if (!privatePics.contains(currentPic)) {
        await Crypto.encryptImage(picStore, appStore.encryptionKey);

        // //print('this pic now is private');
        privatePics.add(currentPic);

        if (currentPic.tags.length == 1) {
          // //print('this pic now has tags!');
          removePicFromUntaggedPics(picStore: currentPic);
        }

        addPicToTaggedPics(picStore: currentPic);
      }
    } else {
      if (privatePics.contains(currentPic)) {
        // //print('removing pic from private pics');
        privatePics.remove(currentPic);
        removePicFromTaggedPics(picStore: currentPic);

        if (currentPic.tags.isEmpty) {
          addPicToUntaggedPics(picStore: currentPic);
          // //print('this pic now doesnt have tags!');
        }
        // else {
        //   if (originalPhotoId != currentPic.photoId) {
        // //print('##### PHOTO ID HAS CHANGED... REFRESHING IDS IN TAGS');
        //     // setShouldRefreshTaggedGallery(true);
        //
        //     for (TagsStore tagStore in currentPic.tags) {
        //       TaggedPicsStore taggedPicsStore = taggedPics.firstWhere(
        //           (element) => element.tag == tagStore,
        //           orElse: () => null);
        //       if (taggedPicsStore != null) {
        /*// //print('Replacing id in ${taggedPicsStore.tag.name}'); */
        //         PicStore picStore = taggedPicsStore.pics.firstWhere(
        //             (e) => e.photoId == currentPic.photoId,
        //             orElse: () => null);
        //         if (picStore != null) {
        /*// //print(         'Found pic ${currentPic.photoId} in taggedPicsStore ${taggedPicsStore.tag.name}'); */
        //           var tagsBox = Hive.box('tags');
        //           Tag tag = tagsBox.get(taggedPicsStore.tag.id);
        /*// //print(               'Tag contains new photo id: ${tag.photoId.contains(currentPic.photoId)}');
       // //print(           'Tag contains original photo id: ${tag.photoId.contains(originalPhotoId)}'); */
        //         }
        //       }
        //     }
        //   }
        // }
      }
    }
  }

  List<TagsStore> tagsFromPic({PicStore picStore}) {
    var tagsList = picStore.tags.values.toList();
    if (picStore.isPrivate == true) {
      tagsList.removeWhere((element) => element.id == kSecretTagKey);
    }
    return tagsList;
  }

  //@action
  void refreshPicThumbnails() {
    clearPicThumbnails();

    for (var store in untaggedPics) {
      addPicsToThumbnails(store.picStores.values.toList());
    }
  }
}

enum PicSource {
  UNTAGGED,
  SWIPE,
  TAGGED,
  FILTERED,
}
