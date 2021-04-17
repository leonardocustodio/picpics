import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagModel extends GetxController {
  RxMap _map;
  TagModel(
      {@required String key,
      @required String title,
      @required int count,
      @required DateTime time}) {
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

class TagsController extends GetxController {
  /// tagKey: {
  ///           title: Name,
  ///           count: 0,
  ///           date: DateTime(),
  ///          }

  final allTags = <String, Rx<TagModel>>{}.obs;
  final mostUsedTags = <String, String>{}.obs;
  final lastWeekUsedTags = <String, String>{}.obs;
  final lastMonthUsedTags = <String, String>{}.obs;
  @override
  void onInit() {
    super.onInit();
    loadAllTags();
  }

  void loadMostUsedTags({int maxTagsLength = 12}) {
    mostUsedTags.clear();
    var tempTags = <TagModel>[];
    allTags.forEach((_, value) {
      tempTags.add(value.value);
    });

    tempTags.sort((a, b) {
      var count = b.count.compareTo(a.count);
      if (count == 0)
        return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      return count;
    });

    tempTags = tempTags.sublist(0, maxTagsLength);
    if (mostUsedTags.length > maxTagsLength)
      mostUsedTags.value = mostUsedTags.sublist(0, maxTagsLength);
  }

  void loadLastWeekUsedTags({int maxTagsLength = 12}) {
    lastWeekUsedTags.clear();
    var now = DateTime.now();
    var sevenDaysBack =
        DateTime(now.year, now.month, (now.day - now.weekday - 1));
    doSortingOfWeeksAndMonth(lastMonthUsedTags, sevenDaysBack, maxTagsLength);
  }

  void loadLastMonthUsedTags({int maxTagsLength = 12}) {
    lastMonthUsedTags.clear();
    var now = DateTime.now();
    var monthBack = DateTime(now.year, now.month, 1);
    doSortingOfWeeksAndMonth(lastMonthUsedTags, monthBack, maxTagsLength);
  }

  void doSortingOfWeeksAndMonth(
      RxList<TagsStore> list, DateTime back, int maxTagsLength) {
    tags.values.forEach((element) {
      if (element.time.isBefore(back)) {
        list.add(element);
      }
    });
    if (list.isNotEmpty) {
      list.sort((TagsStore a, TagsStore b) => b.time.day.compareTo(a.time.day));
      if (list.length > maxTagsLength)
        list.value = List<TagsStore>.from(list.sublist(0, maxTagsLength));
    }
  }

  Future<void> loadAllTags() async {}
}
