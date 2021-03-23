import 'package:mobx/mobx.dart';
import 'package:picPics/stores/pic_store.dart';

part 'untagged_pics_store.g.dart';

class UntaggedPicsStore = _UntaggedPicsStore with _$UntaggedPicsStore;

abstract class _UntaggedPicsStore with Store {
  DateTime date;

  _UntaggedPicsStore({
    this.date,
  });

  ObservableMap<String, PicStore> picStores = ObservableMap<String, PicStore>();

  @action
  void addPicStore(PicStore picStore) {
    picStores[picStore.photoId] = picStore;
  }

  @action
  void removePicStore(PicStore picStore) {
    picStores.remove(picStore.photoId);
  }
}
