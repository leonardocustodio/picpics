import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';

import '../constants.dart';

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

  final _database = AppDatabase();
  @override
  void onInit() {
    super.onInit();
    loadAllTags();
  }

  void loadMostUsedTags({int maxTagsLength = 12}) {
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

    if (tempTags.length > maxTagsLength) {
      tempTags = tempTags.sublist(0, maxTagsLength);
    }
    mostUsedTags.clear();
    tempTags.forEach((TagModel tag) {
      mostUsedTags[tag.key] = tag.title;
    });
  }

  void loadLastWeekUsedTags({int maxTagsLength = 12}) {
    var now = DateTime.now();
    var sevenDaysBack =
        DateTime(now.year, now.month, (now.day - now.weekday - 1));
    doSortingOfWeeksAndMonth(lastMonthUsedTags, sevenDaysBack, maxTagsLength);
  }

  void loadLastMonthUsedTags({int maxTagsLength = 12}) {
    var now = DateTime.now();
    var monthBack = DateTime(now.year, now.month, 1);
    doSortingOfWeeksAndMonth(lastMonthUsedTags, monthBack, maxTagsLength);
  }

  void doSortingOfWeeksAndMonth(
      RxMap<String, String> map, DateTime back, int maxTagsLength) {
    var tempTags = <TagModel>[];
    allTags.values.forEach((tag) {
      if (tag.value.time.isBefore(back)) {
        tempTags.add(tag.value);
      }
    });
    if (tempTags.isNotEmpty) {
      tempTags
          .sort((TagModel a, TagModel b) => b.time.day.compareTo(a.time.day));
      if (tempTags.length > maxTagsLength) {
        tempTags = tempTags.sublist(0, maxTagsLength);
      }
    }
    map.clear();
    tempTags.forEach((TagModel tag) {
      map[tag.key] = tag.title;
    });
  }

  Future<void> loadAllTags() async {
    var tagsBox = await _database.getAllLabel();

    for (Label tag in tagsBox) {
      TagModel tagModel = TagModel(
        key: tag.key,
        title: tag.title,
        count: tag.counter,
        time: tag.lastUsedAt,
      );
      allTags[tag.key] = Rx<TagModel>(tagModel);
    }

    if (allTags[kSecretTagKey] == null) {
      //print('Creating secret tag in db!');
      Label createSecretLabel = Label(
        key: kSecretTagKey,
        title: 'Secret Pics',
        photoId: [],
        counter: 1,
        lastUsedAt: DateTime.now(),
      );
      await _database.createLabel(createSecretLabel);

      TagModel tagModel = TagModel(
        key: kSecretTagKey,
        title: 'Secret Pics',
        count: 1,
        time: DateTime.now(),
      );
      allTags[tagModel.key] = Rx<TagModel>(tagModel);
    }
    loadMostUsedTags();
    loadLastWeekUsedTags();
    loadLastMonthUsedTags();
  }

  //@action
  void addTag(TagModel tagModel) {
    if (allTags[tagModel.key] == null) {
      allTags[tagModel.key] = Rx<TagModel>(tagModel);
    }
  }

  //@action
  void editTag({String oldTagKey, String newTagKey, String newName}) {
    TagModel tagModel = allTags[oldTagKey].value;

    tagModel
      ..key = newTagKey
      ..title = newName
      ..time = DateTime.now();

    allTags[newTagKey] = Rx<TagModel>(tagModel);
    allTags.remove(oldTagKey);
  }

  //@action
  void removeTag({TagModel tagModel}) {
    if (tagModel != null) {
      allTags.remove(tagModel.key);
    }
  }
}
