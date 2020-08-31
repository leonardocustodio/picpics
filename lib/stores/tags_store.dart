import 'package:mobx/mobx.dart';

part 'tags_store.g.dart';

class TagsStore = _TagsStore with _$TagsStore;

abstract class _TagsStore with Store {
  final String id;
  final String name;

  _TagsStore({this.id, this.name}) {
    autorun((_) {
      print('autorun');
    });
  }
}
