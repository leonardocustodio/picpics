import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagModel extends GetxController {
  RxMap _map = <String, dynamic>{}.obs;
  TagModel(
      {required String key,
      required String title,
      required int count,
      required DateTime time}) {
    assert(key != null && title != null);
    _map = RxMap<String, dynamic>(<String, dynamic>{
      'key': key,
      'title': title,
      'count': count ?? 0,
      'time': time ?? DateTime.now(),
    });
  }

  String get key => _map['key'];
  void set key(String val) => _map['key'] = val;

  String get title => _map['title'];
  void set title(String val) => _map['title'] = val;

  int get count => _map['count'];
  void set count(int val) => _map['count'] = val;

  DateTime get time => _map['time'];
  void set time(DateTime val) => _map['time'] = val;
}
