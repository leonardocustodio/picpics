import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:share_extend/share_extend.dart';

part 'gallery_store.g.dart';

class GalleryStore = _GalleryStore with _$GalleryStore;

abstract class _GalleryStore with Store {
  final AppStore appStore;

  _GalleryStore({this.appStore}) {
    loadAssetsPath();

    autorun((_) {
      if (currentPic.tags.length > 0) {
        if (untaggedPics.contains(currentPic)) {
          taggedPics.add(currentPic);
          untaggedPics.remove(currentPic);
          print('this pic now has tags!');
        }
      } else {
        if (taggedPics.contains(currentPic)) {
          untaggedPics.add(currentPic);
          taggedPics.remove(currentPic);
          print('this pic now doesnt have tags!');
        }
      }
    });
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
  ObservableList<PicStore> taggedPics = ObservableList<PicStore>();
  ObservableList<PicStore> filteredPics = ObservableList<PicStore>();
  ObservableList<PicStore> thumbnailsPics = ObservableList<PicStore>();
  ObservableSet<String> selectedPics = ObservableSet<String>();

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
  void setSelectedPics({String photoId, bool picIsTagged}) {
    if (selectedPics.contains(photoId)) {
      selectedPics.remove(photoId);
    } else {
      selectedPics.add(photoId);
    }
    selectedPicsAreTagged = picIsTagged;
  }

  @action
  void clearSelectedPics() {
    selectedPicsAreTagged = null;
    selectedPics.clear();
  }

  ObservableList<String> multiPicTagKeys = ObservableList<String>();

  @action
  void addToMultiPicTagKeys(String tagKey) {
    if (!multiPicTagKeys.contains(tagKey)) {
      multiPicTagKeys.add(tagKey);
    }
  }

  @action
  void removeFromMultiPicTagKeys(String tagKey) {
    if (multiPicTagKeys.contains(tagKey)) {
      multiPicTagKeys.remove(tagKey);
    }
  }

  @action
  void clearMultiPicTagKeys() {
    multiPicTagKeys.clear();
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
      tags.addAll(element.tagsKeys);
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
        taggedPics.add(pic);
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
      taggedPics.remove(picStore);
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
  Future<void> sharePics({List<String> photoIds}) async {
    var imageList = List<String>();

    for (var photoId in photoIds) {
      AssetEntity data;

      data = allPics.firstWhere((element) => element.photoId == photoId, orElse: () => null).entity;

      if (data == null) {
        continue;
      }

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

      taggedPics.forEach((element) {
        if (getTag.photoId.contains(element.photoId)) {
          element.tags.remove(tagsStore);
        }
      });

      taggedPics.forEach((element) {
        if (getTag.photoId.contains(element.photoId)) {
          if (element.tags.length == 0 && element != currentPic) {
            print('this pic is not tagged anymore!');
            untaggedPics.add(element);
            taggedPics.remove(element);
          }
        }
      });

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

    filteredPics.addAll(taggedPics.where((element) => tempPhotosIds.contains(element.photoId)).toList());
    print('Search Photos: $filteredPics');
    print('Searcing Tags Keys: $searchingTags');

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
    addTagToRecent(tagKey: tagKey);

    Analytics.sendEvent(Event.created_tag);
  }

  @action
  void addTagsToSelectedPics() {
    var tagsBox = Hive.box('tags');

    for (String photoId in selectedPics) {
      PicStore picStore = selectedPicsAreTagged
          ? taggedPics.firstWhere((element) => element.photoId == photoId)
          : untaggedPics.firstWhere((element) => element.photoId == photoId);

      if (!selectedPicsAreTagged) {
        taggedPics.add(picStore);
        untaggedPics.remove(picStore);
        swipePics.remove(picStore);
      }

      for (String tagKey in multiPicTagKeys) {
        Tag getTag = tagsBox.get(tagKey);

        if (getTag.photoId.contains(photoId)) {
          print('this tag is already in this picture');
          continue;
        }

        getTag.photoId.add(photoId);
        tagsBox.put(tagKey, getTag);

        picStore.addTagToPic(
          tagKey: tagKey,
          photoId: photoId,
          tagName: getTag.name,
        );

        print('update pictures in tag');
        Analytics.sendEvent(Event.added_tag);
      }
    }
  }

  @action
  void addTagToRecent({String tagKey}) {
    print('adding tag to recent: $tagKey');

    var userBox = Hive.box('user');
    User getUser = userBox.getAt(0);

    if (getUser.recentTags.contains(tagKey)) {
      getUser.recentTags.remove(tagKey);
      getUser.recentTags.insert(0, tagKey);
      userBox.putAt(0, getUser);
      return;
    }

    if (getUser.recentTags.length >= kMaxNumOfRecentTags) {
      print('removing last');
      getUser.recentTags.removeLast();
    }

    getUser.recentTags.insert(0, tagKey);
    userBox.putAt(0, getUser);
    print('final tags in recent: ${getUser.recentTags}');
  }
}

enum PicSource {
  UNTAGGED,
  SWIPE,
  TAGGED,
  FILTERED,
}
