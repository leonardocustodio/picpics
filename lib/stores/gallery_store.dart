import 'package:mobx/mobx.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/pic_store.dart';

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

  @action
  void setSelectedPics(String photoId) {
    if (selectedPics.contains(photoId)) {
      selectedPics.remove(photoId);
    } else {
      selectedPics.add(photoId);
    }
  }

  @action
  void clearSelectedPics() {
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

  @action
  Future<void> sharePics({List<String> photoIds}) async {
//    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
////    Map<String, dynamic> bytesPhotos = {};
////    int x = 0;
//
//    var imageList = List<String>();
//
//    for (var photoId in photoIds) {
//      AssetEntity data = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);
//
//      if (data == null) {
//        continue;
//      }
//
//      if (Platform.isAndroid) {
//        String path = await _writeByteToImageFile(await data.originBytes);
//        imageList.add(path);
//      } else {
//        var bytes = await data.thumbDataWithSize(
//          data.size.width.toInt(),
//          data.size.height.toInt(),
//          format: ThumbFormat.jpeg,
//        );
//        String path = await _writeByteToImageFile(bytes);
//        imageList.add(path);
//      }
//
////      if (Platform.isAndroid) {
////        var bytes = await data.originBytes;
////        bytesPhotos['$x.jpg'] = bytes;
////      } else {
////        var bytes = await data.thumbDataWithSize(
////          data.size.width.toInt(),
////          data.size.height.toInt(),
////          format: ThumbFormat.jpeg,
////        );
////        bytesPhotos['$x.jpg'] = bytes;
////      }
////      x++;
//    }
//
//    Analytics.sendEvent(Event.shared_photos);
//    ShareExtend.shareMultiple(
//      imageList,
//      "image",
//    );
//
//    if (DatabaseManager.instance.multiPicBar) {
//      DatabaseManager.instance.setPicsSelected(Set());
//      DatabaseManager.instance.setMultiPicBar(false);
//    }
//
//    //    await Share.files(
////      'images',
////      {
////        ...bytesPhotos,
////      },
////      'image/jpeg',
////    );
//
//    return;
  }
}
