import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/model/pic.dart';
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
  bool isLoaded = false;

  ObservableList<AssetPathEntity> assetsPath = ObservableList<AssetPathEntity>();
  ObservableList<PicStore> pics = ObservableList<PicStore>();

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
}
