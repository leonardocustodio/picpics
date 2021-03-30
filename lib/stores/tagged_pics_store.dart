import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tags_store.dart';

class TaggedPicsStore {
  TaggedPicsStore({this.tag}) {}

  @observable
  TagsStore tag;

  @observable
  ObservableList<PicStore> pics = ObservableList<PicStore>();
}
