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
  int swipeIndex = 0;

  @action
  void setSwipeIndex(int value) {
    swipeIndex = value;
    setCurrentPic(untaggedPics[value]);
  }

  @observable
  bool isLoaded = false;

  ObservableList<AssetPathEntity> assetsPath = ObservableList<AssetPathEntity>();
  ObservableList<PicStore> untaggedPics = ObservableList<PicStore>();
  ObservableList<PicStore> taggedPics = ObservableList<PicStore>();
  ObservableSet<String> selectedPics = ObservableSet<String>();

  @observable
  bool isSearching = false;

  @action
  void setIsSearching(bool value) => isSearching = value;

  ObservableList<String> searchingTagsKeys = ObservableList<String>();
  ObservableList<String> searchTagsResults = ObservableList<String>();

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

  @computed
  List<String> get taggedKeys {
    Set<String> tags = Set();
    taggedPics.forEach((element) {
      tags.addAll(element.tagsKeys);
    });
    print('Tagged Keys: ${tags}');
    return tags.toList();
  }

  @observable
  PicStore currentPic;

  @action
  void setCurrentPic(PicStore pic) {
    currentPic = pic;
  }

  @computed
  bool get deviceHasPics {
    if (untaggedPics.length == 0 && taggedPics.length == 0) {
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

      if (pic.tags.length > 0) {
        print('has pic info! and this pic has tags in it!!!!');
        taggedPics.add(pic);
      } else {
        print('has pic info! and this pic doesnt have tag!!!!');
        untaggedPics.add(pic);
      }
    }

    print('#@#@#@# Total photos: ${taggedPics.length + untaggedPics.length}');
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
//    print('Going to trash pic!');
//    bool deleted = await picStore.deletePic();
//    print('Deleted pic: $deleted');
//
//    if (deleted) {
//      int indexOfPic = pics.indexWhere((element) => element.photoId == picStore.photoId);
//      if (indexOfPic != null) {
//        pics.removeAt(indexOfPic);
//        print('Removed pic from gallery...');
//      }
//    }
//
//    Analytics.sendEvent(Event.deleted_photo);
//    print('Reaction!');
//    setTrashedPic(true);

//    if (indexInOrderedList != null) {
//      pathProvider.orderedList.remove(entity);
//
//      // Supondo que pic está nas não taggeadas
//      DatabaseManager.instance.reorderSliderIndex(indexInOrderedList);
//      DatabaseManager.instance.picHasTag.removeAt(indexInOrderedList);
//      print('Removed pic in ordered list number $indexInOrderedList');
//    }
//
//
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

      if (selectedPicsAreTagged) {
        data = taggedPics.firstWhere((element) => element.photoId == photoId, orElse: () => null).entity;
      } else {
        data = untaggedPics.firstWhere((element) => element.photoId == photoId, orElse: () => null).entity;
      }

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

    setSharedPic(true);

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

    String newTagKey = DatabaseManager.instance.encryptTag(newName);

    if (tagsBox.containsKey(oldTagKey)) {
      print('found tag with this name');

      Tag getTag = tagsBox.get(oldTagKey);

      Tag newTag = Tag(newName, getTag.photoId);
      tagsBox.put(newTagKey, newTag);
      tagsBox.delete(oldTagKey);

      print('updated tag');

      for (String photoId in newTag.photoId) {
        Pic pic = picsBox.get(photoId);

        int indexOfOldTag = pic.tags.indexOf(oldTagKey);
        print('Tags in this picture: ${pic.tags}');
        pic.tags[indexOfOldTag] = newTagKey;
        picsBox.put(photoId, pic);
        print('updated tag in pic ${pic.photoId}');
      }

      // Substitui as tags nas fotos já taggeadas
      taggedPics.forEach((element) {
        if (newTag.photoId.contains(element.photoId)) {
          int indexOfTagStore = element.tags.indexWhere((tagStore) => tagStore.id == oldTagKey);
          TagsStore tagsStore = TagsStore(id: newTagKey, name: newName);
          element.tags[indexOfTagStore] = tagsStore;
        }
      });

      // Recarrega as infos da foto atual // rever isso pois muda a ordem das sugestions
//      currentPic.tagsSuggestions[1] = 'abc';

      User getUser = userBox.getAt(0);
      if (getUser.recentTags.contains(oldTagKey)) {
        print('updating tag name in recent tags');
        int indexOfRecentTag = getUser.recentTags.indexOf(oldTagKey);
        getUser.recentTags[indexOfRecentTag] = newTagKey;
        userBox.putAt(0, getUser);
      }

//      print('updating in all suggestions');
//      if (DatabaseManager.instance.suggestionTags.contains(oldTagKey)) {
//        int indexOfSuggestionTag = DatabaseManager.instance.suggestionTags.indexOf(oldTagKey);
//        DatabaseManager.instance.suggestionTags[indexOfSuggestionTag] = newTagKey;
//      }
//
//      if (DatabaseManager.instance.searchResults.isNotEmpty) {
//        print('fixing in search result');
//        if (DatabaseManager.instance.searchResults.contains(oldTagKey)) {
//          int indexOfSearchResultTag = DatabaseManager.instance.searchResults.indexOf(oldTagKey);
//          DatabaseManager.instance.searchResults[indexOfSearchResultTag] = newTagKey;
//        }
//      }
//
//      if (DatabaseManager.instance.searchActiveTags.isNotEmpty) {
//        print('fixing in search active tags');
//        if (DatabaseManager.instance.searchActiveTags.contains(oldTagKey)) {
//          int indexOfSearchActiveTags = DatabaseManager.instance.searchActiveTags.indexOf(oldTagKey);
//          DatabaseManager.instance.searchActiveTags[indexOfSearchActiveTags] = newTagKey;
//        }
//      }

      print('finished updating all tags');
      Analytics.sendEvent(Event.edited_tag);
    }
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
      taggedPics.forEach((element) {
        if (getTag.photoId.contains(element.photoId)) {
          element.tags.removeWhere((tagStore) => tagStore.id == tagKey);
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
    searchingTagsKeys.add(DatabaseManager.instance.selectedTagKey);
    print('searching tags: $searchingTagsKeys');
    searchPicsWithTags();
  }

  void removeTagFromSearchFilter() {
    if (searchingTagsKeys.contains(DatabaseManager.instance.selectedTagKey)) {
      searchingTagsKeys.remove(DatabaseManager.instance.selectedTagKey);
      print('searching tags: $searchingTagsKeys');
      searchPicsWithTags();
    }
  }

  @action
  void searchPicsWithTags() {
//    var tagsBox = Hive.box('tags');
//
//    searchPhotosIds.clear();
//    List<String> tempPhotosIds = [];
//    bool firstInteraction = true;
//
//    for (var tagKey in searchingTagsKeys) {
//      print('filtering tag: $tagKey');
//      Tag getTag = tagsBox.get(tagKey);
//      List<String> photosIds = getTag.photoId;
//      print('photos Ids in this tag: $photosIds');
//
//      if (firstInteraction) {
//        print('adding all photos because it is firt interaction');
//        tempPhotosIds.addAll(photosIds);
//        firstInteraction = false;
//      } else {
//        print('tempPhotoId: $tempPhotosIds');
//        List<String> auxArray = [];
//        auxArray.addAll(tempPhotosIds);
//
//        for (var photoId in tempPhotosIds) {
//          print('checking if photoId is there: $photoId');
//          if (!photosIds.contains(photoId)) {
//            auxArray.remove(photoId);
//            print('removing $photoId because doesnt have $tagKey');
//          }
//        }
//        tempPhotosIds = auxArray;
//      }
//    }
//    searchPhotosIds = tempPhotosIds;
//    slideThumbPhotoIds = tempPhotosIds;
//    print('Search Photos Ids: $searchPhotosIds');
//
//    Analytics.sendEvent(Event.searched_photos);
  }

  @action
  void searchResultsTags(String text) {
    var tagsBox = Hive.box('tags');

    if (text == '') {
      searchTagsResults.clear();
      return;
    }

    searchTagsResults.clear();
    for (var tagKey in tagsBox.keys) {
      String tagName = DatabaseManager.instance.decryptTag(tagKey);
      if (tagName.startsWith(DatabaseManager.instance.stripTag(text))) {
        searchTagsResults.add(tagKey);
      }
    }
  }

  // Create tag for using in multipic
  void createTag(String tagName) {
    var tagsBox = Hive.box('tags');
    print(tagsBox.keys);

    String tagKey = DatabaseManager.instance.encryptTag(tagName);
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
  void addTagsToPics({List<String> tagsKeys, List<String> photosIds, List<AssetEntity> entities}) {
//    var tagsBox = Hive.box('tags');
//
//    for (String photoId in photosIds) {
//      for (String tagKey in tagsKeys) {
//        Tag getTag = tagsBox.get(tagKey);
//
//        if (getTag.photoId.contains(photoId)) {
//          print('this tag is already in this picture');
//          continue;
//        }
//
//        getTag.photoId.add(photoId);
//        tagsBox.put(tagKey, getTag);
//        addTagToPic(
//          tagKey: tagKey,
//          photoId: photoId,
//          entities: entities,
//        );
//        print('update pictures in tag');
//        Analytics.sendEvent(Event.added_tag);
//      }
//    }
//
//    notifyListeners();
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
