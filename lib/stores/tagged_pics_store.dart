import 'package:get/get.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tags_store.dart';

class TaggedPicsStore extends GetxController {
  TaggedPicsStore({TagsStore tagValue}) {
    tag.value = tagValue;
  }

  /* @observable */
  final tag = Rx<TagsStore>(null);

  /*  @observable */
  final pics = <PicStore>[].obs;
}
