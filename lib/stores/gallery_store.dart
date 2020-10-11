import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
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

  ObservableList<AssetPathEntity> assetsPath =
      ObservableList<AssetPathEntity>();
  ObservableList<PicStore> allPics = ObservableList<PicStore>();
  ObservableList<PicStore> untaggedPics = ObservableList<PicStore>();
  ObservableList<PicStore> swipePics = ObservableList<PicStore>();
  ObservableList<TaggedPicsStore> taggedPics =
      ObservableList<TaggedPicsStore>();
  ObservableList<PicStore> filteredPics = ObservableList<PicStore>();
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

  @computed
  List<TagsStore> get tagsSuggestions {
    var userBox = Hive.box('user');
    var tagsBox = Hive.box('tags');
    User getUser = userBox.getAt(0);

    List<String> multiPicTags = multiPicTagKeys.toList();
    List<String> suggestionTags = [];

    if (searchText == '') {
      for (var recent in getUser.recentTags) {
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
        for (var tagKey in tagsBox.keys) {
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
      for (var tagKey in tagsBox.keys) {
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

    setShouldRefreshTaggedGallery(true);
  }

  @action
  void removePicFromTaggedPics({PicStore picStore, bool forceDelete = false}) {
    List<TaggedPicsStore> toDelete = [];

    for (TaggedPicsStore taggedPicsStore in taggedPics) {
      if (picStore.tags.contains(taggedPicsStore.tag) && forceDelete == false) {
        print('this tag should not be removed');
        continue;
      }

      if (taggedPicsStore.pics.contains(picStore)) {
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

    if (pic.isPrivate == true) {
      print('This pic is private not loading it!');
      return;
    }

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
    if (assetsPath.isEmpty) {
      return;
    }

    AssetPathEntity assetPathEntity = assetsPath[0];
    final List<AssetEntity> list = await assetPathEntity.getAssetListRange(
        start: 0, end: assetPathEntity.assetCount);

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

      if (pic.isPrivate == true) {
        print('This pic is private not loading it!');
        continue;
      }

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

    var secretBox = Hive.box('secrets');

    for (Secret secretPic in secretBox.values) {
      PicStore pic = PicStore(
        appStore: appStore,
        entity: null,
        photoId: secretPic.photoId,
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
        untaggedPics.insert(0, pic);
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

    if (Platform.isAndroid) {
      PhotoManager.editor.deleteWithIds(selectedPicsIds);
      deleted = true;
    } else {
      final List<String> result =
          await PhotoManager.editor.deleteWithIds(selectedPicsIds);
      if (result.isNotEmpty) {
        deleted = true;
      }
    }

    if (deleted) {
      var picsBox = Hive.box('pics');
      var tagsBox = Hive.box('tags');

      for (PicStore picStore in selectedPics) {
        Pic pic = picsBox.get(picStore.photoId);

        if (pic != null) {
          print('pic is in db... removing it from db!');
          List<String> picTags = List.of(pic.tags);
          for (String tagKey in picTags) {
            Tag tag = tagsBox.get(tagKey);
            tag.photoId.remove(picStore.photoId);
            print('removed ${picStore.photoId} from tag ${tag.name}');
            tagsBox.put(tagKey, tag);

            if (tagKey == kSecretTagKey) {
              picStore.removePrivatePath();
              picStore.deleteEncryptedPic();
            }
          }
          picsBox.delete(picStore.photoId);
          print('removed ${picStore.photoId} from database');
        }

        filteredPics.remove(picStore);
        removePicFromTaggedPics(picStore: picStore, forceDelete: true);
        swipePics.remove(picStore);
        untaggedPics.remove(picStore);
        allPics.remove(picStore);
      }

      Analytics.sendEvent(Event.deleted_photo);
      print('Reaction!');
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
      untaggedPics.remove(picStore);
      allPics.remove(picStore);
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

    for (PicStore pic in picsStores) {
      AssetEntity data = pic.entity;

      if (Platform.isAndroid) {
        String path = await _writeByteToImageFile(pic.isPrivate == true
            ? await pic.assetOriginBytes
            : await data.originBytes);
        imageList.add(path);
      } else {
        if (data == null) {
          var bytes = await pic.assetOriginBytes;
          String path = await _writeByteToImageFile(bytes);
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
          untaggedPics.insert(0, picTagged);
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

    print('Temp photos ids: $tempPhotosIds');
    print('All Pics: ${allPicsKeys}');
    filteredPics.addAll(allPics
        .where((element) => tempPhotosIds.contains(element.photoId))
        .toList()); // Verificar essa classe para otimizar
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

    Analytics.sendEvent(Event.created_tag);
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
        Analytics.sendEvent(Event.added_tag);
      }

      if (selectedPicsAreTagged != true) {
        print('Adding pic to tagged pics!');
        await addPicToTaggedPics(picStore: picStore);
        untaggedPics.remove(picStore);
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
      untaggedPics.remove(private);
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
      untaggedPics.insert(0, picStore);
      print('this pic now doesnt have tags!');
    }
  }

  @action
  Future<void> addTagToPic({PicStore picStore, String tagName}) async {
    if (picStore.tags.isEmpty) {
      print('this pic now has tags!');
      untaggedPics.remove(picStore);
    }

    await picStore.addTag(
      tagName: tagName,
    );

    addPicToTaggedPics(picStore: picStore);
  }

  @action
  Future<void> setPrivatePic({PicStore picStore, bool private}) async {
    currentPic.setIsPrivate(private);

    if (currentPic.isPrivate == true) {
      if (!privatePics.contains(currentPic)) {
        await Crypto.encryptImage(picStore, appStore.encryptionKey);

        print('this pic now is private');
        privatePics.add(currentPic);

        if (currentPic.tags.length == 1) {
          print('this pic now has tags!');
          untaggedPics.remove(currentPic);
        }

        addPicToTaggedPics(picStore: currentPic);
      }
    } else {
      if (privatePics.contains(currentPic)) {
        print('removing pic from private pics');
        privatePics.remove(currentPic);
        removePicFromTaggedPics(picStore: currentPic);

        if (currentPic.tags.isEmpty) {
          untaggedPics.insert(0, currentPic);
          print('this pic now doesnt have tags!');
        }
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
}

enum PicSource {
  UNTAGGED,
  SWIPE,
  TAGGED,
  FILTERED,
}
