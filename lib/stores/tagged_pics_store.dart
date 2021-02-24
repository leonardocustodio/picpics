import 'package:mobx/mobx.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tags_store.dart';

part 'tagged_pics_store.g.dart';

class TaggedPicsStore = _TaggedPicsStore with _$TaggedPicsStore;

abstract class _TaggedPicsStore with Store {
  _TaggedPicsStore({this.tag}) {
    autorun((_) {
      //print('autorun');
    });
  }

  @observable
  TagsStore tag;

  @observable
  ObservableList<PicStore> pics = ObservableList<PicStore>();
}
