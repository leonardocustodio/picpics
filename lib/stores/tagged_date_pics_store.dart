import 'package:mobx/mobx.dart';
import 'package:picPics/stores/pic_store.dart';

part 'tagged_date_pics_store.g.dart';

class TaggedDatePicsStore = _TaggedDatePicsStore with _$TaggedDatePicsStore;

abstract class _TaggedDatePicsStore with Store {
  DateTime date;

  _TaggedDatePicsStore({
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
