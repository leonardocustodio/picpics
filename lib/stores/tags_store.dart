import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'tags_store.g.dart';

class TagsStore = _TagsStore with _$TagsStore;

abstract class _TagsStore with Store {
  _TagsStore({this.id, this.name, @required this.count, @required this.time}) {
    autorun((_) {
      //print('autorun');
    });
  }

  @observable
  String id;

  @observable
  String name;

  @observable
  int count;

  @observable
  DateTime time;

  @action
  void setTagInfo(
      {String tagId,
      String tagName,
      @required int count,
      @required DateTime time}) {
    //print('Setting new tag info!!!!!!');
    id = tagId;
    name = tagName;
    count = count;
    time = time;
  }

  @override
  int get hashCode {
    return this.id.hashCode ^
        this.name.hashCode ^
        this.count.hashCode ^
        this.time.hashCode;
  }
}
