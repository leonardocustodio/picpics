import 'package:mobx/mobx.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/stores/tags_store.dart';

part 'pic_store.g.dart';

class PicStore = _PicStore with _$PicStore;

abstract class _PicStore with Store {
  final AssetEntity entity;
  final String photoId;
  final DateTime createdAt;
  final double originalLatitude;
  final double originalLongitude;

  _PicStore({
    this.entity,
    this.photoId,
    this.createdAt,
    this.originalLatitude,
    this.originalLongitude,
  }) {
    autorun((_) {
      print('autorun');
    });
  }

  @observable
  double latitude;

  @observable
  double longitude;

  @observable
  String specificLocation;

  @observable
  String generalLocation;

  ObservableList<TagsStore> tags;
}
