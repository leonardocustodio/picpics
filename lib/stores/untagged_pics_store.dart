import 'package:mobx/mobx.dart';
import 'package:picPics/stores/pic_store.dart';

part 'untagged_pics_store.g.dart';

class UntaggedPicsStore = _UntaggedPicsStore with _$UntaggedPicsStore;

abstract class _UntaggedPicsStore with Store {
  DateTime date;

  _UntaggedPicsStore({
    this.date,
  });

  ObservableList<PicStore> picStores = ObservableList<PicStore>();

  @computed
  List<String> get picStoresIds {
    return picStores.map((element) => element.photoId).toList();
  }

  @action
  void addPicStore(PicStore picStore) {
    picStores.add(picStore);
  }

  @action
  void removePicStore(PicStore picStore) {
    picStores.remove(picStore);
  }
}
