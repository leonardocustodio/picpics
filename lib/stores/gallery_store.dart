import 'dart:io';
import 'dart:typed_data';
import 'package:date_utils/date_utils.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart' as esys;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/secret.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
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
import 'package:share_extend/share_extend.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';

part 'gallery_store.g.dart';

class GalleryStore = _GalleryStore with _$GalleryStore;

abstract class _GalleryStore with Store {
  final AppStore appStore;
  final database = AppDatabase();

  _GalleryStore({this.appStore}) {
//    loadTaggedPicsStore();

    if (appStore.tutorialCompleted) {
      loadAssetsPath();
    }

    autorun((_) {
      print('auto run');
    });
  }

//  @action
//  void loadTaggedPicsStore() {
//    for (TagsStore tagsStore in appStore.tags) {
//      TaggedPicsStore taggedPicsStore = TaggedPicsStore(tag: tagsStore);
//      taggedPics.add(taggedPicsStore);
//    }
//    print('finished adding all tagged pics stores!');
//  }

  @computed
  int get totalTaggedPics {
    return taggedPics
        .map((element) => element.pics.length)
        .toList()
        .reduce((value, element) => value + element);
  }

  PicStore currentPic;

  void setCurrentPic(PicStore picStore) {
    currentPic = picStore;
  }

  @observable
  int swipeIndex = 0;

  int swipeCutOff = 0;

  @action
  void setSwipeIndex(int value) {
    if (swipePics.isEmpty) {
      return;
    }
//    if (value > swipeIndex && value > 5) {
//      int val = value - 5;
//      if (val > swipeCutOff) {
//        swipeCutOff = value - 5;
//        print('&&&&&&&&& setting cutoff to $swipeCutOff');
//      }
//    }

    swipeIndex = value;
    setCurrentPic(swipePics[swipeIndex]);
    Analytics.sendEvent(Event.swiped_photo);
  }

  @observable
  bool isLoaded = false;

  ObservableList<AssetPathEntity> assetsPath =
      ObservableList<AssetPathEntity>();
  ObservableList<PicStore> allPics = ObservableList<PicStore>();

  ObservableList<UntaggedPicsStore> untaggedPics =
      ObservableList<UntaggedPicsStore>();
  ObservableList<UntaggedGridPicStore> untaggedGridPics =
      ObservableList<UntaggedGridPicStore>();
  ObservableList<UntaggedGridPicStore> untaggedGridPicsByMonth =
      ObservableList<UntaggedGridPicStore>();

  ObservableList<TaggedDatePicsStore> taggedDatePics =
      ObservableList<TaggedDatePicsStore>();
  ObservableList<TaggedGridPicStore> taggedGridPics =
      ObservableList<TaggedGridPicStore>();
  ObservableList<TaggedPicsStore> taggedPics =
      ObservableList<TaggedPicsStore>();
  ObservableList<PicStore> filteredPics = ObservableList<PicStore>();

  ObservableList<PicStore> swipePics = ObservableList<PicStore>();
  ObservableList<PicStore> thumbnailsPics = ObservableList<PicStore>();
  ObservableSet<PicStore> selectedPics = ObservableSet<PicStore>();
  ObservableList<PicStore> privatePics = ObservableList<PicStore>();

  @computed
  Set<String> get allPicsKeys {
    return allPics.map((element) => element.photoId).toSet();
  }

  @computed
  List<String> get filteredPicsKeys {
    return filteredPics.map((element) => element.photoId).toList();
  }

  @action
  void clearPicThumbnails() {
    thumbnailsPics.clear();
  }

  @action
  void addPicToThumbnails(PicStore picStore) {
    if (thumbnailsPics.contains(picStore)) {
      return;
    }
    thumbnailsPics.add(picStore);
  }

  @action
  void addPicsToThumbnails(List<PicStore> picStores) {
    thumbnailsPics.addAll(picStores);
  }

  @observable
  int selectedSwipe = 0;

  @action
  void setSelectedSwipe(int value) => selectedSwipe = value;

  @observable
  int selectedThumbnail = 0;

  @action
  void setSelectedThumbnail(int value) => selectedThumbnail = value;

  @computed
  PicStore get currentThumbnailPic {
    if (thumbnailsPics == null) {
      return null;
    }
    return thumbnailsPics[selectedThumbnail];
  }

  @action
  void setInitialSelectedThumbnail(PicStore picStore) {
    int indexOf = thumbnailsPics.indexOf(picStore);
    selectedThumbnail = indexOf;
  }

  @observable
  bool isSearching = false;

  @action
  void setIsSearching(bool value) => isSearching = value;

  @action
  void clearSearchTags() {
    setSearchText('');
    setShowSearchTagsResults(false);
    setIsSearching(false);
    searchingTags.clear();
    searchTagsResults.clear();
    filteredPics.clear();
  }

  ObservableList<TagsStore> searchingTags = ObservableList<TagsStore>();

  @computed
  List<String> get searchingTagsKeys {
    return searchingTags.map((element) => element.id).toList();
  }

  @computed
  bool get isFiltered {
    if (searchingTags.length > 0) {
      return true;
    }
    return false;
  }

  ObservableList<TagsStore> searchTagsResults = ObservableList<TagsStore>();

  @observable
  bool showSearchTagsResults = false;

  @action
  void setShowSearchTagsResults(bool value) => showSearchTagsResults = value;

  bool selectedPicsAreTagged;

  @action
  void setSelectedPics({PicStore picStore, bool picIsTagged}) {
    if (selectedPics.contains(picStore)) {
      selectedPics.remove(picStore);
    } else {
      selectedPics.add(picStore);
    }
    selectedPicsAreTagged = picIsTagged;
  }

  @action
  void clearSelectedPics() {
    selectedPicsAreTagged = null;
    selectedPics.clear();
  }

  ObservableList<TagsStore> multiPicTags = ObservableList<TagsStore>();

  @computed
  List<String> get multiPicTagKeys {
    return multiPicTags.map((element) => element.id).toList();
  }

  @action
  void addToMultiPicTags(String tagKey) {
    if (!multiPicTagKeys.contains(tagKey)) {
      TagsStore tagsStore =
          appStore.tags.firstWhere((element) => element.id == tagKey);
      multiPicTags.add(tagsStore);
    }
  }

  @action
  void removeFromMultiPicTags(String tagKey) {
    if (multiPicTagKeys.contains(tagKey)) {
      TagsStore tagsStore =
          appStore.tags.firstWhere((element) => element.id == tagKey);
      multiPicTags.remove(tagsStore);
    }
  }

  @action
  void clearMultiPicTags() {
    multiPicTags.clear();
  }

  @observable
  String searchText = '';

  @action
  void setSearchText(String value) => searchText = value;

  Future<List<Label>> getLabels() async {
    return await database.getAllLabel();
  }

  Future<MoorUser> getUser() async {
    return await database.getSingleMoorUser();
  }

  List<TagsStore> continueTagSuggestions(List<Label> tagsList, MoorUser user) {
    List<String> multiPicTags = multiPicTagKeys.toList();
    List<String> suggestionTags = [];

    if (searchText == '') {
      for (var recent in user.recentTags) {
        print('Recent Tag: $recent');
        if (multiPicTags.contains(recent) || recent == kSecretTagKey) {
          continue;
        }
        suggestionTags.add(recent);
      }

      print(
          'Sugestion Length: ${suggestionTags.length} - Num of Suggestions: ${kMaxNumOfSuggestions}');

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
          if (multiPicTagKeys.contains(tagKey) ||
              suggestionTags.contains(tagKey) ||
              tagKey == kSecretTagKey) {
            continue;
          }
          print('Adding tag key: $tagKey');
          suggestionTags.add(tagKey);
        }
      }
//      }
    } else {
      for (Label tag in tagsList) {
        var tagKey = tag.key;
        if (tagKey == kSecretTagKey) continue;

        String tagName = Helpers.decryptTag(tagKey);
        if (tagName.startsWith(Helpers.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        }
      }
    }

    print('%%%%%%%%%% Before adding secret tag: ${suggestionTags}');
    if (!multiPicTagKeys.contains(kSecretTagKey) &&
        !searchingTagsKeys.contains(kSecretTagKey) &&
        appStore.secretPhotos == true &&
        searchText == '') {
      suggestionTags.add(kSecretTagKey);
    }

    print('find suggestions: $searchText - exclude tags: $multiPicTags');
    print(suggestionTags);
    print('AppStore Tags: ${appStore.tags}');
    List<TagsStore> suggestions = appStore.tags
        .where((element) => suggestionTags.contains(element.id))
        .toList();
    print('Suggestions Tag Store: $suggestions');
    return suggestions;
  }

  @computed
  List<TagsStore> get tagsSuggestions {
    //var userBox = Hive.box('user');
    //var tagsBox = Hive.box('tags');

    List<Label> tagsList;
    MoorUser user;

    getLabels().then((value) {
      tagsList = value;
      getUser().then((value) {
        user = value;
        return continueTagSuggestions(tagsList, user);
      });
    });
  }

  @computed
  List<String> get taggedKeys {
    Set<String> tags = Set();
    taggedPics.forEach((element) {
      tags.add(element.tag.id);
    });
    print('Tagged Keys: ${tags}');
    return tags.toList();
  }

  @computed
  bool get deviceHasPics {
    if (allPics.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  @action
  void addPicToTaggedPics({PicStore picStore, bool toInitialIndex = false}) {
    for (TagsStore tag in picStore.tags) {
      TaggedPicsStore taggedPicsStore = taggedPics
          .firstWhere((element) => element.tag == tag, orElse: () => null);

      if (taggedPicsStore == null) {
        taggedPicsStore = TaggedPicsStore(tag: tag);
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

    print('Find right place to add tagged ${picStore.photoId}');
    DateTime picDate = picStore.createdAt;
    TaggedDatePicsStore taggedDatePicsStore = taggedDatePics.firstWhere(
        (element) => Utils.isSameDay(element.date, picDate),
        orElse: () => null);
    if (taggedDatePicsStore == null) {
      taggedDatePicsStore = TaggedDatePicsStore(date: picDate);

      if (taggedDatePics.length == 0) {
        print('Adding picStore from $picDate to index 0');
        taggedDatePics.add(taggedDatePicsStore);
      } else {
        bool hasAdded = false;
        for (int x = 0; x < taggedDatePics.length; x++) {
          if (taggedDatePics[x].date.isBefore(picDate)) {
            print('Adding picStore from $picDate to index $x');
            taggedDatePics.insert(x, taggedDatePicsStore);
            hasAdded = true;
            break;
          }
        }
        if (hasAdded == false) {
          print('Adding picStore from $picDate to last index');
          taggedDatePics.add(taggedDatePicsStore);
        }
      }
    }

    var date = taggedDatePicsStore.date;
    var newPicStore = TaggedGridPicStore(picStore: picStore);

    var gridPicIndex =
        taggedGridPics.indexWhere((element) => element.date == date);

    if (gridPicIndex != -1) {
      print('Different than null');
      taggedGridPics.insert(gridPicIndex + 1, newPicStore);
    } else {
      print('Is null');
      for (int x = 0; x < taggedGridPics.length; x++) {
        if (taggedGridPics[x].date == null) {
          continue;
        }
        if (taggedGridPics[x].date.isBefore(date)) {
          print('Date is before');
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

  @action
  void removePicFromTaggedPics({PicStore picStore, bool forceDelete = false}) {
    print('removePicFromTaggedPics');
    List<TaggedPicsStore> toDelete = [];

    for (TaggedPicsStore taggedPicsStore in taggedPics) {
      if (picStore.tags.contains(taggedPicsStore.tag) && forceDelete == false) {
        // print();
        print('this tag should not be removed');
        continue;
      }

      if (taggedPicsStore.pics.contains(picStore)) {
        print('Removed ${picStore.photoId} from ${taggedPicsStore.tag.name}');
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
  }

  @action
  void deleteEntity(String entityId) {
    print('Deleting entity...');

    if (!allPicsKeys.contains(entityId)) {
      print('This pic is not on picPics!!!');
      return;
    }

    PicStore picStore =
        allPics.firstWhere((element) => element.photoId == entityId);
    removePicFromTaggedPics(picStore: picStore, forceDelete: true);
    removePicFromUntaggedPics(picStore: picStore);
    filteredPics.remove(picStore);
    swipePics.remove(picStore);
    allPics.remove(picStore);

    print('#@#@#@# Total photos: ${allPics.length}');
  }

  @action
  void addEntity(AssetEntity entity) {
    print('Adding new entity....');

    if (allPicsKeys.contains(entity.id)) {
      print('This pic is already in picPics!!!');
      return;
    }

    PicStore pic = PicStore(
      appStore: appStore,
      entity: entity,
      photoId: entity.id,
      createdAt: entity.createDateTime,
      originalLatitude: entity.latitude,
      originalLongitude: entity.longitude,
    );

    if (pic.isPrivate == true) {
      print('This pic is private not loading it!');
      return;
    }

    allPics.insert(0, pic);
    if (pic.tags.length > 0) {
      // print('has pic info! and this pic has tags in it!!!!');
      addPicToTaggedPics(picStore: pic, toInitialIndex: true);
    } else {
      // print('has pic info! and this pic doesnt have tag!!!!');
      swipePics.insert(0, pic);
      addPicToUntaggedPics(picStore: pic);
    }

    print('#@#@#@# Total photos: ${allPics.length}');
  }

  @action
  void addPicToUntaggedPics({PicStore picStore}) {
    DateTime picDate = picStore.createdAt;

    UntaggedPicsStore untaggedPicsStore = untaggedPics.firstWhere(
        (element) => Utils.isSameDay(element.date, picDate),
        orElse: () => null);
    if (untaggedPicsStore == null) {
      untaggedPicsStore = UntaggedPicsStore(date: picDate);

      if (untaggedPics.length == 0) {
        print('Adding picStore from $picDate to index 0');
        untaggedPics.add(untaggedPicsStore);
      } else {
        bool hasAdded = false;
        for (int x = 0; x < untaggedPics.length; x++) {
          if (untaggedPics[x].date.isBefore(picDate)) {
            print('Adding picStore from $picDate to index $x');
            untaggedPics.insert(x, untaggedPicsStore);
            hasAdded = true;
            break;
          }
        }
        if (hasAdded == false) {
          print('Adding picStore from $picDate to last index');
          untaggedPics.add(untaggedPicsStore);
        }
      }
    }

    var date = untaggedPicsStore.date;
    var newPicStore = UntaggedGridPicStore(picStore: picStore);

    var gridPicIndex =
        untaggedGridPics.indexWhere((element) => element.date == date);

    if (gridPicIndex != -1) {
      print('Different than null');
      untaggedGridPics.insert(gridPicIndex + 1, newPicStore);
    } else {
      print('Is null');
      for (int x = 0; x < untaggedGridPics.length; x++) {
        if (untaggedGridPics[x].date == null) {
          continue;
        }
        if (untaggedGridPics[x].date.isBefore(date)) {
          print('Date is Before');
          var newDateStore = UntaggedGridPicStore(date: date);
          untaggedGridPics.insert(x, newPicStore);
          untaggedGridPics.insert(x, newDateStore);
          break;
        }
      }
    }

    var gridPicMonthIndex = untaggedGridPicsByMonth.indexWhere(
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
    }

    untaggedPicsStore.addPicStore(picStore);
  }

  @action
  void removePicFromUntaggedPics({PicStore picStore}) {
    List<UntaggedPicsStore> toDelete = [];

    for (var untaggedPicStore in untaggedPics) {
      if (untaggedPicStore.picStoresIds.contains(picStore.photoId)) {
        print('Removing ${picStore.photoId} from untagged pic store');
        untaggedPicStore.removePicStore(picStore);
        untaggedGridPics.removeWhere((element) => element.picStore == picStore);
        untaggedGridPicsByMonth
            .removeWhere((element) => element.picStore == picStore);

        if (untaggedPicStore.picStoresIds.length == 0) {
          print('Removing untaggedPicStore since there are no more pics in it');
          toDelete.add(untaggedPicStore);
        }
        break;
      }
    }

    for (var untaggedPicStore in toDelete) {
      untaggedPics.remove(untaggedPicStore);
      untaggedGridPics
          .removeWhere((element) => element.date == untaggedPicStore.date);

      int indexOfMonth = untaggedGridPicsByMonth.indexWhere((element) =>
          element.date ==
          DateTime.utc(
              untaggedPicStore.date.year, untaggedPicStore.date.month));
      print('Index of Month: $indexOfMonth');

      if (indexOfMonth >= untaggedGridPicsByMonth.length - 1) {
        continue;
      }

      if (untaggedGridPicsByMonth[indexOfMonth + 1].date != null) {
        untaggedGridPicsByMonth.removeAt(indexOfMonth);
      }
    }
  }

  @action
  Future<void> loadEntities() async {
    if (assetsPath.isEmpty) {
      return;
    }

    AssetPathEntity assetPathEntity = assetsPath[0];
    final List<AssetEntity> list = await assetPathEntity.getAssetListRange(
        start: 0, end: assetPathEntity.assetCount);

    DateTime currentDate = DateTime(1000);

    for (AssetEntity entity in list) {
      print(entity.id);

      PicStore pic = PicStore(
        appStore: appStore,
        entity: entity,
        photoId: entity.id,
        createdAt: entity.createDateTime,
        originalLatitude: entity.latitude,
        originalLongitude: entity.longitude,
      );
      // debugPrint('Created At: ${entity.modifiedDateTime}');

      if (pic.isPrivate == true) {
        print('This pic is private not loading it!');
        continue;
      }

      allPics.add(pic);

      if (pic.tags.length > 0) {
        // print('has pic info! and this pic has tags in it!!!!');
        addPicToTaggedPics(picStore: pic);
      } else {
        // print('has pic info! and this pic doesnt have tag!!!!');
        swipePics.add(pic);
        addPicToUntaggedPics(picStore: pic);
      }
    }

    sortUntaggedPhotos();
    sortTaggedPhotos();
    appStore.setDefaultWidgetImage(allPics[0].entity);
    print('#@#@#@# Total photos: ${allPics.length}');
  }

  @action
  void sortTaggedPhotos() {
    taggedGridPics.clear();

    for (var taggedPic in taggedDatePics) {
      taggedGridPics.add(TaggedGridPicStore(date: taggedPic.date));

      for (var picStore in taggedPic.picStores) {
        var gridPicStore = TaggedGridPicStore(picStore: picStore);
        taggedGridPics.add(gridPicStore);
      }
    }
  }

  @action
  void sortUntaggedPhotos() {
    untaggedGridPics.clear();

    DateTime currentMonth;

    for (var untaggedPic in untaggedPics) {
      untaggedGridPics.add(UntaggedGridPicStore(date: untaggedPic.date));

      var monthDate =
          DateTime.utc(untaggedPic.date.year, untaggedPic.date.month);
      if (currentMonth != monthDate) {
        untaggedGridPicsByMonth.add(UntaggedGridPicStore(date: monthDate));
        currentMonth = monthDate;
        print('Adding month date: $monthDate');
      }

      for (var picStore in untaggedPic.picStores) {
        var gridPicStore = UntaggedGridPicStore(picStore: picStore);
        untaggedGridPics.add(gridPicStore);
        untaggedGridPicsByMonth.add(gridPicStore);
      }
    }
  }

  @action
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
    print('#@#@#@# Total galleries: ${assetsPath.length}');
    await loadEntities();
    await loadPrivateAssets();

    setSwipeIndex(0);
    isLoaded = true;
  }

  @action
  Future<void> loadPrivateAssets() async {
    if (appStore.secretPhotos != true) {
      print('Secret photos is off - not loading private pics');
      return;
    }
/* 
    var secretBox = Hive.box('secrets'); */
    var secretBox = await database.getAllPrivate();

    for (Private secretPic in secretBox) {
      PicStore pic = PicStore(
        appStore: appStore,
        entity: null,
        photoId: secretPic.id,
        createdAt: secretPic.createDateTime,
        originalLatitude: secretPic.originalLatitude,
        originalLongitude: secretPic.originalLongitude,
      );

      allPics.insert(0, pic);

      if (pic.tags.length > 0) {
        print('has pic info! and this pic has tags in it!!!!');
        addPicToTaggedPics(picStore: pic);
      } else {
        print('has pic info! and this pic doesnt have tag!!!!');
        swipePics.insert(0, pic);
        addPicToUntaggedPics(picStore: pic);
      }

      if (pic.isPrivate == true) {
        print('Adding pic to private pics!!!');
        privatePics.add(pic);
      }
    }

    print('#@#@#@# Total photos with private photos: ${allPics.length}');
  }

  @observable
  bool trashedPic = false;

  @action
  void setTrashedPic(bool value) => trashedPic = value;

  @action
  Future<void> trashMultiplePics(Set<PicStore> selectedPics) async {
    List<String> selectedPicsIds = selectedPics.map((e) => e.photoId).toList();

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
          Photo pic = await database.getPhotoByPhotoId(picStore.photoId);

          if (pic != null) {
            print('pic is in db... removing it from db!');
            List<String> picTags = List<String>.from(pic.tags);
            Future.wait([
              Future.forEach(picTags, (tagKey) async {
                Label tag = await database.getLabelByLabelKey(tagKey);
                tag.photoId.remove(picStore.photoId);
                print('removed ${picStore.photoId} from tag ${tag.title}');
                await database.updateLabel(tag);
                //tagsBox.put(tagKey, tag);

                if (tagKey == kSecretTagKey) {
                  picStore.removePrivatePath();
                  picStore.deleteEncryptedPic();
                }
              })
            ]);

            //picsBox.delete(picStore.photoId);
            await database.deletePhotoByPhotoId(picStore.photoId);
            print('removed ${picStore.photoId} from database');
          }

          filteredPics.remove(picStore);
          removePicFromTaggedPics(picStore: picStore, forceDelete: true);
          swipePics.remove(picStore);
          removePicFromUntaggedPics(picStore: picStore);
          allPics.remove(picStore);
          appStore.setDefaultWidgetImage(allPics[0].entity);
        })
      ]);

      Analytics.sendEvent(Event.deleted_photo);
      print('Reaction!');
      selectedPics.clear();
      setTrashedPic(true);
    }
  }

  @action
  Future<void> trashPic(PicStore picStore) async {
    print('Going to trash pic!');
    bool deleted = await picStore.deletePic();
    print('Deleted pic: $deleted');

    if (deleted) {
      filteredPics.remove(picStore);
      removePicFromTaggedPics(picStore: picStore, forceDelete: true);
      swipePics.remove(picStore);
      removePicFromUntaggedPics(picStore: picStore);
      allPics.remove(picStore);
      appStore.setDefaultWidgetImage(allPics[0].entity);
    }

    Analytics.sendEvent(Event.deleted_photo);
    print('Reaction!');
    setTrashedPic(true);
  }

  Future<String> _writeByteToImageFile(Uint8List byteData) async {
    Directory tempDir = await getTemporaryDirectory();
    File imageFile = new File(
        '${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData);
    return imageFile.path;
  }

  @observable
  bool sharedPic = false;

  @action
  void setSharedPic(bool value) => sharedPic = value;

  @action
  Future<void> sharePics({List<PicStore> picsStores}) async {
    var imageList = List<String>();
    var mimeList = List<String>();

    for (PicStore pic in picsStores) {
      AssetEntity data = pic.entity;

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

    print('Image List: $imageList');
    print('Mime List: $mimeList');

    Analytics.sendEvent(Event.shared_photos);

    Share.shareFiles(
      imageList,
      mimeTypes: mimeList,
    );

//    setSharedPic(true);

    return;
  }

  @action
  Future<void> editTag({String oldTagKey, String newName}) async {
    var tagsBox = Hive.box('tags');
    var picsBox = Hive.box('pics');

    String newTagKey = Helpers.encryptTag(newName);
    Tag oldTag = tagsBox.get(oldTagKey);

    // Creating new tag
    Tag createTag = Tag(newName, oldTag.photoId);
    tagsBox.put(newTagKey, createTag);

    for (String photoId in createTag.photoId) {
      Pic pic = picsBox.get(photoId);
      int indexOfOldTag = pic.tags.indexOf(oldTagKey);
      print('Tags in this picture: ${pic.tags}');
      pic.tags[indexOfOldTag] = newTagKey;
      picsBox.put(photoId, pic);
      print('updated tag in pic ${pic.photoId}');
    }

    // Altera a tag
    appStore.editTag(
        oldTagKey: oldTagKey, newTagKey: newTagKey, newName: newName);
    appStore.editRecentTags(oldTagKey, newTagKey);
    tagsBox.delete(oldTagKey);

    print('finished updating all tags');
    Analytics.sendEvent(Event.edited_tag);
  }

  @action
  void deleteTag({String tagKey}) {
    var tagsBox = Hive.box('tags');

    if (tagsBox.containsKey(tagKey)) {
      print('found tag going to delete it');

      // Remove a tag das fotos já taggeadas
      TagsStore tagsStore =
          appStore.tags.firstWhere((element) => element.id == tagKey);
      print('TagsStore Tag: ${tagsStore.name}');
      TaggedPicsStore taggedPicsStore =
          taggedPics.firstWhere((element) => element.tag == tagsStore);
      for (PicStore picTagged in taggedPicsStore.pics) {
        print('Tagged Pic Store Pics: ${picTagged.photoId}');
        picTagged.removeTagFromPic(tagKey: tagsStore.id);
        if (picTagged.tags.length == 0 && picTagged != currentPic) {
          print('this pic is not tagged anymore!');
          addPicToUntaggedPics(picStore: picTagged);
        }
      }
      taggedPics.remove(taggedPicsStore);
      appStore.removeTagFromRecent(tagKey: tagKey);
      appStore.removeTag(tagsStore: tagsStore);
      tagsBox.delete(tagKey);
      print('deleted from tags db');
      Analytics.sendEvent(Event.deleted_tag);
    }
  }

  @action
  void addTagToSearchFilter() {
    if (searchingTagsKeys.contains(DatabaseManager.instance.selectedTagKey)) {
      return;
    }

    TagsStore tagsStore = appStore.tags.firstWhere(
        (element) => element.id == DatabaseManager.instance.selectedTagKey);
    searchingTags.add(tagsStore);
    print('searching tags: $searchingTags');
    searchPicsWithTags();
  }

  void removeTagFromSearchFilter() {
    if (searchingTagsKeys.contains(DatabaseManager.instance.selectedTagKey)) {
      TagsStore tagsStore = appStore.tags.firstWhere(
          (element) => element.id == DatabaseManager.instance.selectedTagKey);
      searchingTags.remove(tagsStore);
      print('searching tags: $searchingTags');
      searchPicsWithTags();
    }
  }

  @action
  void searchPicsWithTags() {
    var tagsBox = Hive.box('tags');
    print('%%%% Tags Keys: ${tagsBox.keys}');

    filteredPics.clear();

    List<String> tempPhotosIds = [];
    bool firstInteraction = true;

    for (var tagKey in searchingTagsKeys) {
      print('filtering tag: $tagKey');
      Tag getTag = tagsBox.get(tagKey);
      List<String> photosIds = getTag.photoId;
      print('photos Ids in this tag: $photosIds');

      if (firstInteraction) {
        print('adding all photos because it is firt interaction');
        tempPhotosIds.addAll(photosIds);
        firstInteraction = false;
      } else {
        // print('tempPhotoId: $tempPhotosIds');
        List<String> auxArray = [];
        auxArray.addAll(tempPhotosIds);

        for (var photoId in tempPhotosIds) {
          print('checking if photoId is there: $photoId');
          if (!photosIds.contains(photoId)) {
            auxArray.remove(photoId);
            print('removing $photoId because doesnt have $tagKey');
          }
        }
        tempPhotosIds = auxArray;
      }
    }

    // print('Temp photos ids: $tempPhotosIds');
    // print('All Pics: ${allPicsKeys}');
    filteredPics.addAll(allPics
        .where((element) => tempPhotosIds.contains(element.photoId))
        .toList()); // Verificar essa classe para otimizar
    // print('Search Photos: $filteredPics');
    print('Searcing Tags Keys: $searchingTags');

    setShouldRefreshTaggedGallery(true);
    Analytics.sendEvent(Event.searched_photos);
  }

  @action
  void searchResultsTags(String text) {
    if (text == '') {
      setShowSearchTagsResults(false);
      searchTagsResults.clear();
      return;
    }

    setShowSearchTagsResults(true);
    searchTagsResults.clear();

    for (TagsStore tagStore in appStore.tags) {
      if (Helpers.stripTag(tagStore.name).startsWith(Helpers.stripTag(text))) {
        if (tagStore.id == kSecretTagKey) {
          continue;
        }
        searchTagsResults.add(tagStore);
      }
    }
  }

  // Create tag for using in multipic
  void createTag(String tagName) {
    var tagsBox = Hive.box('tags');
    print(tagsBox.keys);

    String tagKey = Helpers.encryptTag(tagName);
    print('Adding tag: $tagName');

    if (tagsBox.containsKey(tagKey)) {
      print('user already has this tag');
      return;
    }

    print('adding tag to database...');
    tagsBox.put(tagKey, Tag(tagName, []));

    TagsStore tagsStore = TagsStore(id: tagKey, name: tagName);
    appStore.addTag(tagsStore);
    appStore.addTagToRecent(tagKey: tagKey);

    Analytics.sendEvent(
      Event.created_tag,
      params: {'tagName': tagName},
    );
  }

  @action
  Future<void> addTagsToSelectedPics() async {
    var tagsBox = Hive.box('tags');

    for (PicStore picStore in selectedPics) {
      for (String tagKey in multiPicTagKeys) {
        if (picStore.tagsKeys.contains(tagKey)) {
          print('this tag is already in this picture');
          continue;
        }
        if (tagKey == kSecretTagKey) {
          print('Should add secret tag in the end!!!');
          if (!privatePics.contains(picStore)) {
            await picStore.setIsPrivate(true);
            await Crypto.encryptImage(picStore, appStore.encryptionKey);
            print('this pic now is private');
            privatePics.add(picStore);
          } else {
            print('this pic is already private');
          }
          continue;
        }

        Tag getTag = tagsBox.get(tagKey);
        getTag.photoId.add(picStore.photoId);
        tagsBox.put(tagKey, getTag);

        await picStore.addTagToPic(
          tagKey: tagKey,
          photoId: picStore.photoId,
        );

        print('update pictures in tag');
      }

      if (selectedPicsAreTagged != true) {
        print('Adding pic to tagged pics!');
        await addPicToTaggedPics(picStore: picStore);
        removePicFromUntaggedPics(picStore: picStore);
        swipePics.remove(picStore);
      }
    }

    clearSelectedPics();
    clearMultiPicTags();
  }

//  void registerObserve() {
//    try {
//      print('%%%%%% Registered change notifier');
//      PhotoManager.addChangeCallback(_onAssetChange);
//      PhotoManager.startChangeNotify();
//    } catch (e) {
//      print('Error when registering assets callback: $e');
//    }
//  }

  @action
  Future<void> _onAssetChange(MethodCall call) async {
//    print('#!#!#!#!#!#! asset changed: ${call.arguments}');
//
//    List<dynamic> createdPics = call.arguments['create'];
//    List<dynamic> deletedPics = call.arguments['delete'];
//
//    return;
//
//    print(deletedPics);
//
//    if (deletedPics.length > 0) {
//      print('### deleted pics from library!');
//      for (var pic in deletedPics) {
//        print('Pic deleted Id: ${pic['id']}');
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
//        print('Pic created Id: ${pic['id']}');
//        AssetEntity picEntity = await AssetEntity.fromId(pic['id']);
//        addEntity(picEntity);
//      }
//    }
  }

  @action
  Future<void> removeAllPrivatePics() async {
    for (PicStore private in privatePics) {
      removePicFromTaggedPics(picStore: private, forceDelete: true);
      filteredPics.remove(private);
      thumbnailsPics.remove(private);
      selectedPics.remove(private);
      swipePics.remove(private);
      removePicFromUntaggedPics(picStore: private);
      allPics.remove(private);
    }
    privatePics.clear();
  }

  @action
  Future<void> checkIsLibraryUpdated() async {
    print('Scanning library again....');

    final List<AssetPathEntity> assets = await PhotoManager.getAssetPathList(
      hasAll: true,
      type: RequestType.image,
      onlyAll: true,
    );

    final AssetPathEntity assetPathEntity = assets[0];
    final List<AssetEntity> assetList = await assetPathEntity.getAssetListRange(
        start: 0, end: assetPathEntity.assetCount);
    final Set<String> entitiesIds = assetList.map((e) => e.id).toSet();
    final bool isEqual = SetEquality().equals(entitiesIds, allPicsKeys);

    if (isEqual) {
      print('Library is updated!!!!!!');
      print('#@#@#@# Total photos: ${allPics.length}');
    } else {
      print('Library not updated!!!');

      final Set<String> createdPics = entitiesIds.difference(allPicsKeys);
      final Set<String> deletedPics = allPicsKeys.difference(entitiesIds);

      print('Created: $createdPics');
      print('Deleted: $deletedPics');

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

  @observable
  bool shouldRefreshTaggedGallery = false;

  @action
  void setShouldRefreshTaggedGallery(bool value) =>
      shouldRefreshTaggedGallery = value;

  @action
  void removeTagFromPic({PicStore picStore, String tagKey}) {
    picStore.removeTagFromPic(tagKey: tagKey);
    removePicFromTaggedPics(picStore: picStore);

    if (picStore.tags.isEmpty) {
      addPicToUntaggedPics(picStore: picStore);
      print('this pic now doesnt have tags!');
    }
  }

  @action
  Future<void> addTagToPic({PicStore picStore, String tagName}) async {
    if (picStore.tags.isEmpty) {
      print('this pic now has tags!');
      removePicFromUntaggedPics(picStore: picStore);
    }

    await picStore.addTag(
      tagName: tagName,
    );

    addPicToTaggedPics(picStore: picStore);
  }

  @action
  Future<void> setPrivatePic({PicStore picStore, bool private}) async {
    String originalPhotoId = '${currentPic.photoId}';
    await currentPic.setIsPrivate(private);

    if (currentPic.isPrivate == true) {
      if (!privatePics.contains(currentPic)) {
        await Crypto.encryptImage(picStore, appStore.encryptionKey);

        print('this pic now is private');
        privatePics.add(currentPic);

        if (currentPic.tags.length == 1) {
          print('this pic now has tags!');
          removePicFromUntaggedPics(picStore: currentPic);
        }

        addPicToTaggedPics(picStore: currentPic);
      }
    } else {
      if (privatePics.contains(currentPic)) {
        print('removing pic from private pics');
        privatePics.remove(currentPic);
        removePicFromTaggedPics(picStore: currentPic);

        if (currentPic.tags.isEmpty) {
          addPicToUntaggedPics(picStore: currentPic);
          print('this pic now doesnt have tags!');
        }
        // else {
        //   if (originalPhotoId != currentPic.photoId) {
        //     print('##### PHOTO ID HAS CHANGED... REFRESHING IDS IN TAGS');
        //     // setShouldRefreshTaggedGallery(true);
        //
        //     for (TagsStore tagStore in currentPic.tags) {
        //       TaggedPicsStore taggedPicsStore = taggedPics.firstWhere(
        //           (element) => element.tag == tagStore,
        //           orElse: () => null);
        //       if (taggedPicsStore != null) {
        //         print('Replacing id in ${taggedPicsStore.tag.name}');
        //         PicStore picStore = taggedPicsStore.pics.firstWhere(
        //             (e) => e.photoId == currentPic.photoId,
        //             orElse: () => null);
        //         if (picStore != null) {
        //           print(
        //               'Found pic ${currentPic.photoId} in taggedPicsStore ${taggedPicsStore.tag.name}');
        //           var tagsBox = Hive.box('tags');
        //           Tag tag = tagsBox.get(taggedPicsStore.tag.id);
        //           print(
        //               'Tag contains new photo id: ${tag.photoId.contains(currentPic.photoId)}');
        //           print(
        //               'Tag contains original photo id: ${tag.photoId.contains(originalPhotoId)}');
        //         }
        //       }
        //     }
        //   }
        // }
      }
    }
  }

  List<TagsStore> tagsFromPic({PicStore picStore}) {
    List<TagsStore> tagsList = picStore.tags.toList();
    if (picStore.isPrivate == true) {
      tagsList.removeWhere((element) => element.id == kSecretTagKey);
    }
    return tagsList;
  }

  @action
  void refreshPicThumbnails() {
    clearPicThumbnails();

    for (var store in untaggedPics) {
      addPicsToThumbnails(store.picStores);
    }
  }
}

enum PicSource {
  UNTAGGED,
  SWIPE,
  TAGGED,
  FILTERED,
}
