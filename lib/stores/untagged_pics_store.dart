import 'package:picPics/stores/pic_store.dart';

class UntaggedPicsStore {
  DateTime date;

  UntaggedPicsStore({
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
