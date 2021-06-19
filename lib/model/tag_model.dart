import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagModel extends GetxController {
  RxMap _map = <String, dynamic>{}.obs;
  TagModel(
      {required String key,
      required String title,
      int count = 0,
      DateTime? time}) {
    _map = RxMap<String, dynamic>(<String, dynamic>{
      'key': key,
      'title': title,
      'count': count,
      'time': time,
    });
  }

  String get key => _map['key'];
  set key(String val) => _map['key'] = val;

  String get title => _map['title'];
  set title(String val) => _map['title'] = val;

  int get count => _map['count'];
  set count(int val) => _map['count'] = val;

  DateTime get time => _map['time'];
  set time(DateTime val) => _map['time'] = val;
}
