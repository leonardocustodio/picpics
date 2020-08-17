import 'package:mobx/mobx.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/stores/app_store.dart';

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
  ObservableList<AssetEntity> entities = ObservableList<AssetEntity>();

  @action
  Future<void> loadEntities() async {
    AssetPathEntity assetPathEntity = assetsPath[0];
    final List<AssetEntity> list = await assetPathEntity.getAssetListRange(start: 0, end: assetPathEntity.assetCount);
    entities.addAll(list);
    print('#@#@#@# Total photos: ${entities.length}');
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
