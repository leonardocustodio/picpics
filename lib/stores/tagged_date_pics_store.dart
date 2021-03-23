import 'package:mobx/mobx.dart';
import 'package:picPics/stores/pic_store.dart';

part 'tagged_date_pics_store.g.dart';

class TaggedDatePicsStore = _TaggedDatePicsStore with _$TaggedDatePicsStore;

abstract class _TaggedDatePicsStore with Store {
  DateTime date;

  _TaggedDatePicsStore({
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
