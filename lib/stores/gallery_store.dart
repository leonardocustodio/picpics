import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tagged_pics_store.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:share_extend/share_extend.dart';
import 'package:collection/collection.dart';

part 'gallery_store.g.dart';

class GalleryStore = _GalleryStore with _$GalleryStore;

abstract class _GalleryStore with Store {
  final AppStore appStore;

  _GalleryStore({this.appStore}) {
//    loadTaggedPicsStore();
    loadAssetsPath();

    autorun((_) {
      if (currentPic.tags.length > 0) {
        if (untaggedPics.contains(currentPic)) {
          addPicToTaggedPics(picStore: currentPic);
          untaggedPics.remove(currentPic);
          print('this pic now has tags!');
        }
      } else {
        if (taggedPics.contains(currentPic)) {
          untaggedPics.add(currentPic);
          removePicFromTaggedPics(picStore: currentPic);
          print('this pic now doesnt have tags!');
        }
      }
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
    return taggedPics.map((element) => element.pics.length).toList().reduce((value, element) => value + element);
  }

  @observable
  PicStore currentPic;

  @action
  void setCurrentPic(PicStore picStore) {
    currentPic = picStore;
  }

  @observable
  int swipeIndex = 0;

  int swipeCutOff = 0;

  @action
  void setSwipeIndex(int value) {
    if (!appStore.hasSwiped) {
      appStore.setHasSwiped(true);
    }

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

  ObservableList<AssetPathEntity> assetsPath = ObservableList<AssetPathEntity>();
  ObservableList<PicStore> allPics = ObservableList<PicStore>();
  ObservableList<PicStore> untaggedPics = ObservableList<PicStore>();
  ObservableList<PicStore> swipePics = ObservableList<PicStore>();
  ObservableList<TaggedPicsStore> taggedPics = ObservableList<TaggedPicsStore>();
  ObservableList<PicStore> filteredPics = ObservableList<PicStore>();
  ObservableList<PicStore> thumbnailsPics = ObservableList<PicStore>();
  ObservableSet<PicStore> selectedPics = ObservableSet<PicStore>();

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
      TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == tagKey);
      multiPicTags.add(tagsStore);
    }
  }

  @action
  void removeFromMultiPicTags(String tagKey) {
    if (multiPicTagKeys.contains(tagKey)) {
      TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == tagKey);
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

  @computed
  List<TagsStore> get tagsSuggestions {
    var userBox = Hive.box('user');
    var tagsBox = Hive.box('tags');
    User getUser = userBox.getAt(0);

    List<String> multiPicTags = multiPicTagKeys.toList();
    List<String> suggestionTags = [];

    if (searchText == '') {
      for (var recent in getUser.recentTags) {
        if (multiPicTags.contains(recent)) {
          continue;
        }
        suggestionTags.add(recent);
      }

      print('Sugestion Length: ${suggestionTags.length} - Num of Suggestions: ${kMaxNumOfSuggestions}');

//      while (suggestions.length < maxNumOfSuggestions) {
//          if (excludeTags.contains('Hey}')) {
//            continue;
//          }
      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (var tagKey in tagsBox.keys) {
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
          if (multiPicTags.contains(tagKey) || suggestionTags.contains(tagKey)) {
            continue;
          }
          suggestionTags.add(tagKey);
        }
      }
//      }
    } else {
      for (var tagKey in tagsBox.keys) {
        String tagName = Helpers.decryptTag(tagKey);
        if (tagName.startsWith(Helpers.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        }
      }
    }
    print('find suggestions: $searchText - exclude tags: $multiPicTags');
    print(suggestionTags);
    List<TagsStore> suggestions = appStore.tags.where((element) => suggestionTags.contains(element.id)).toList();
    return suggestions;
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
    print('%@%@%@%@%@%@%@%@%@%@ Adding pic to tagged pics!!! %@%@%@%@%@%@%@');
    for (TagsStore tag in picStore.tags) {
      TaggedPicsStore taggedPicsStore = taggedPics.firstWhere((element) => element.tag == tag, orElse: () => null);

      if (taggedPicsStore == null) {
        taggedPicsStore = TaggedPicsStore(tag: tag);
        taggedPics.add(taggedPicsStore);
      }

      if (toInitialIndex) {
        taggedPicsStore.pics.insert(0, picStore);
      } else {
        taggedPicsStore.pics.add(picStore);
      }
    }

    setShouldRefreshTaggedGallery(true);
  }

  @action
  void removePicFromTaggedPics({PicStore picStore}) {
    for (TaggedPicsStore taggedPicsStore in taggedPics) {
      bool deleted = taggedPicsStore.pics.remove(picStore);
      if (deleted) {
        print('pic has been deleted from tagged pics');
        if (taggedPicsStore.pics.isEmpty) {
          print('this tag is now empty removing it from third tab');
          taggedPics.remove(taggedPicsStore);
        }
        break;
      }
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

    PicStore picStore = allPics.firstWhere((element) => element.photoId == entityId);
    removePicFromTaggedPics(picStore: picStore);
    untaggedPics.remove(picStore);
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

    allPics.insert(0, pic);
    if (pic.tags.length > 0) {
      print('has pic info! and this pic has tags in it!!!!');
      addPicToTaggedPics(picStore: pic, toInitialIndex: true);
    } else {
      print('has pic info! and this pic doesnt have tag!!!!');
      swipePics.insert(0, pic);
      untaggedPics.insert(0, pic);
    }

    print('#@#@#@# Total photos: ${allPics.length}');
  }

  @action
  Future<void> loadEntities() async {
    AssetPathEntity assetPathEntity = assetsPath[0];
    final List<AssetEntity> list = await assetPathEntity.getAssetListRange(start: 0, end: assetPathEntity.assetCount);

    for (AssetEntity entity in list) {
      PicStore pic = PicStore(
        appStore: appStore,
        entity: entity,
        photoId: entity.id,
        createdAt: entity.createDateTime,
        originalLatitude: entity.latitude,
        originalLongitude: entity.longitude,
      );

      allPics.add(pic);

      if (pic.tags.length > 0) {
        print('has pic info! and this pic has tags in it!!!!');
        addPicToTaggedPics(picStore: pic);
      } else {
        print('has pic info! and this pic doesnt have tag!!!!');
        swipePics.add(pic);
        untaggedPics.add(pic);
      }
    }

    print('#@#@#@# Total photos: ${allPics.length}');
    setSwipeIndex(0);
    isLoaded = true;
  }

  @action
  Future<void> loadAssetsPath() async {
    final List<AssetPathEntity> assets = await PhotoManager.getAssetPathList(
      hasAll: true,
      type: RequestType.image,
      onlyAll: true,
    );
    assetsPath.addAll(assets);
    print('#@#@#@# Total galleries: ${assetsPath.length}');
    loadEntities();
  }

  @observable
  bool trashedPic = false;

  @action
  void setTrashedPic(bool value) => trashedPic = value;

  @action
  Future<void> trashPic(PicStore picStore) async {
    print('Going to trash pic!');
    bool deleted = await picStore.deletePic();
    print('Deleted pic: $deleted');

    if (deleted) {
      filteredPics.remove(picStore);
      removePicFromTaggedPics(picStore: picStore);
      swipePics.remove(picStore);
      untaggedPics.remove(picStore);
      allPics.remove(picStore);
    }

    Analytics.sendEvent(Event.deleted_photo);
    print('Reaction!');
    setTrashedPic(true);
  }

  Future<String> _writeByteToImageFile(Uint8List byteData) async {
    Directory tempDir = await getTemporaryDirectory();
    File imageFile = new File('${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
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

    for (PicStore pic in picsStores) {
      AssetEntity data = pic.entity;

      if (Platform.isAndroid) {
        String path = await _writeByteToImageFile(await data.originBytes);
        imageList.add(path);
      } else {
        var bytes = await data.thumbDataWithSize(
          data.size.width.toInt(),
          data.size.height.toInt(),
          format: ThumbFormat.jpeg,
        );
        String path = await _writeByteToImageFile(bytes);
        imageList.add(path);
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

    Analytics.sendEvent(Event.shared_photos);
    ShareExtend.shareMultiple(
      imageList,
      "image",
    );

//    setSharedPic(true);

    //    await Share.files(
//      'images',
//      {
//        ...bytesPhotos,
//      },
//      'image/jpeg',
//    );

    return;
  }

  @action
  void editTag({String oldTagKey, String newName}) {
    // Verificar essa classe

    var tagsBox = Hive.box('tags');
    var picsBox = Hive.box('pics');
    var userBox = Hive.box('user');

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
    appStore.editTag(oldTagKey: oldTagKey, newTagKey: newTagKey, newName: newName);

    // Altera o recent
    User getUser = userBox.getAt(0);
    if (getUser.recentTags.contains(oldTagKey)) {
      print('updating tag name in recent tags');
      int indexOfRecentTag = getUser.recentTags.indexOf(oldTagKey);
      getUser.recentTags[indexOfRecentTag] = newTagKey;
      userBox.putAt(0, getUser);
      appStore.editRecentTags(oldTagKey, newTagKey);
    }

    tagsBox.delete(oldTagKey);

    print('finished updating all tags');
    Analytics.sendEvent(Event.edited_tag);
  }

  @action
  void deleteTag({String tagKey}) {
    // Verificar essa classe

    var tagsBox = Hive.box('tags');
    var picsBox = Hive.box('pics');
    var userBox = Hive.box('user');

    if (tagsBox.containsKey(tagKey)) {
      print('found tag going to delete it');

      Tag getTag = tagsBox.get(tagKey);

      for (String photoId in getTag.photoId) {
        Pic pic = picsBox.get(photoId);
        int indexOfTagInPic = pic.tags.indexOf(tagKey);
        print('getting pic: $photoId');

        if (indexOfTagInPic != null) {
          pic.tags.removeAt(indexOfTagInPic);
          picsBox.put(photoId, pic);
          print('removed tag from pic');
        }
      }

      // Remove a tag das fotos já taggeadas
      TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == tagKey);
      TaggedPicsStore taggedPicsStore = taggedPics.firstWhere((element) => element.tag == tagsStore);
      for (PicStore picTagged in taggedPicsStore.pics) {
        picTagged.tags.remove(tagsStore);
        if (picTagged.tags.length == 0 && picTagged != currentPic) {
          print('this pic is not tagged anymore!');
          untaggedPics.add(picTagged);
        }
      }
      taggedPics.remove(taggedPicsStore);

      User getUser = userBox.getAt(0);
      if (getUser.recentTags.contains(tagKey)) {
        print('recent tags: ${getUser.recentTags}');
        print('removing from recent tags');
        getUser.recentTags.remove(tagKey);
        userBox.putAt(0, getUser);
        print('recent tags after removed: ${getUser.recentTags}');
      }

      appStore.tags.remove(tagsStore);
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

    TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == DatabaseManager.instance.selectedTagKey);
    searchingTags.add(tagsStore);
    print('searching tags: $searchingTags');
    searchPicsWithTags();
  }

  void removeTagFromSearchFilter() {
    if (searchingTagsKeys.contains(DatabaseManager.instance.selectedTagKey)) {
      TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == DatabaseManager.instance.selectedTagKey);
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
        print('tempPhotoId: $tempPhotosIds');
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

    filteredPics.addAll(allPics.where((element) => tempPhotosIds.contains(element.photoId)).toList()); // Verificar essa classe para otimizar
    print('Search Photos: $filteredPics');
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

    Analytics.sendEvent(Event.created_tag);
  }

  @action
  void addTagsToSelectedPics() {
    var tagsBox = Hive.box('tags');

    for (PicStore picStore in selectedPics) {
      for (String tagKey in multiPicTagKeys) {
        if (picStore.tagsKeys.contains(tagKey)) {
          print('this tag is already in this picture');
          continue;
        }

        Tag getTag = tagsBox.get(tagKey);
        getTag.photoId.add(picStore.photoId);
        tagsBox.put(tagKey, getTag);

        picStore.addTagToPic(
          tagKey: tagKey,
          photoId: picStore.photoId,
          tagName: getTag.name,
        );

        if (!selectedPicsAreTagged) {
          addPicToTaggedPics(picStore: picStore);
          untaggedPics.remove(picStore);
          swipePics.remove(picStore);
        }

        print('update pictures in tag');
        Analytics.sendEvent(Event.added_tag);
      }
    }
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
  Future<void> checkIsLibraryUpdated() async {
    print('Scanning library again....');

    final List<AssetPathEntity> assets = await PhotoManager.getAssetPathList(
      hasAll: true,
      type: RequestType.image,
      onlyAll: true,
    );

    final AssetPathEntity assetPathEntity = assets[0];
    final List<AssetEntity> assetList = await assetPathEntity.getAssetListRange(start: 0, end: assetPathEntity.assetCount);
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
  }

  @observable
  bool shouldRefreshTaggedGallery = false;

  @action
  void setShouldRefreshTaggedGallery(bool value) => shouldRefreshTaggedGallery = value;
}

enum PicSource {
  UNTAGGED,
  SWIPE,
  TAGGED,
  FILTERED,
}
