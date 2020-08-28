import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/analytics_manager.dart';
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
  }

  @observable
  bool isLoaded = false;

  ObservableList<AssetPathEntity> assetsPath = ObservableList<AssetPathEntity>();
  ObservableList<PicStore> untaggedPics = ObservableList<PicStore>();
  ObservableList<PicStore> taggedPics = ObservableList<PicStore>();
  ObservableSet<String> selectedPics = ObservableSet<String>();
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
}
