import 'package:get/get.dart';

class TagModel extends GetxController {
  TagModel(
      {required String key,
      required String title,
      int count = 0,
      DateTime? time,}) {
    _map = RxMap<String, dynamic>(<String, dynamic>{
      'key': key,
      'title': title,
      'count': count,
      'time': time,
    });
  }
  RxMap<String, dynamic> _map = <String, dynamic>{}.obs;

  String get key => _map['key'] as String;
  set key(String val) => _map['key'] = val;

  String get title => _map['title'] as String;
  set title(String val) => _map['title'] = val;

  int get count => _map['count'] as int;
  set count(int val) => _map['count'] = val;

  DateTime get time => _map['time'] as DateTime;
  set time(DateTime val) => _map['time'] = val;
}
