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
      print('autorun');
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
  ObservableList<PicStore> pics = ObservableList<PicStore>();

  @observable
  PicStore currentPic;

  @action
  void setCurrentPic(PicStore pic) {
    currentPic = pic;
  }

  @computed
  bool get deviceHasPics {
    if (pics.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  @action
  Future<void> loadEntities() async {
    AssetPathEntity assetPathEntity = assetsPath[0];
    final List<AssetEntity> list = await assetPathEntity.getAssetListRange(start: 0, end: assetPathEntity.assetCount);

    List<PicStore> picsList = [];

    for (AssetEntity entity in list) {
      PicStore pic = PicStore(
        appStore: appStore,
        entity: entity,
        photoId: entity.id,
        createdAt: entity.createDateTime,
        originalLatitude: entity.latitude,
        originalLongitude: entity.longitude,
      );
      picsList.add(pic);
    }
    pics.addAll(picsList);

    print('#@#@#@# Total photos: ${pics.length}');

    //    _checkTaggedPics()
//
//    DatabaseManager.instance.sliderHasPics();
////      setState(() {
////        deviceHasNoPics = false;
////      });
//  }
//
//  DatabaseManager.instance.checkHasTaggedPhotos();
//  tabsStore.setCurrentTab(1);
//  setTabIndex(1);

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
      int indexOfPic = pics.indexWhere((element) => element.photoId == picStore.photoId);
      if (indexOfPic != null) {
        pics.removeAt(indexOfPic);
        print('Removed pic from gallery...');
      }
    }

    Analytics.sendEvent(Event.deleted_photo);
    print('Reaction!');
    setTrashedPic(true);

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
}
