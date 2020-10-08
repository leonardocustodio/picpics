import 'package:mobx/mobx.dart';

part 'tags_store.g.dart';

class TagsStore = _TagsStore with _$TagsStore;

abstract class _TagsStore with Store {
  _TagsStore({this.id, this.name}) {
    autorun((_) {
      print('autorun');
    });
  }

  @observable
  String id;

  @observable
  String name;

  @action
  void setTagInfo({String tagId, tagName}) {
    print('Setting new tag info!!!!!!');
    id = tagId;
    name = tagName;
  }
}
