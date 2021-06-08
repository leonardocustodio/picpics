/* import 'package:get/get.dart';
import 'package:picPics/stores/pic_store.dart';

class TaggedDatePicsStore extends GetxController {
  DateTime date;

  TaggedDatePicsStore({
    this.date,
  });

  final picStores = <String, PicStore>{}.obs;

  //@action
  void addPicStore(PicStore picStore) {
    picStores.value[picStore.photoId.value] = picStore;
  }

  //@action
  void removePicStore(PicStore picStore) {
    picStores.remove(picStore.photoId);
  }
}
 */
