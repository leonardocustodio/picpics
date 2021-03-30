import 'package:flutter/material.dart';

class TagsStore {
  TagsStore({this.id, this.name, @required this.count, @required this.time});

  @observable
  String id;

  @observable
  String name;

  @observable
  int count;

  @observable
  DateTime time;

  //@action
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
