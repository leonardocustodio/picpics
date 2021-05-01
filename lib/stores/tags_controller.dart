import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/utils/helpers.dart';

import '../constants.dart';
import 'tagged_pics_store.dart';

class TagModel {
  RxMap _map = <String, dynamic>{}.obs;
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

  static TagsController get to => Get.find();

  final allTags = <String, Rx<TagModel>>{}.obs;
  final mostUsedTags = <String, String>{}.obs;
  final lastWeekUsedTags = <String, String>{}.obs;
  final lastMonthUsedTags = <String, String>{}.obs;

  final recentTagKeyList = <String>[].obs;

  final multiPicTags = <String, String>{}.obs;

  final _database = AppDatabase();

  @override
  void onInit() {
    super.onInit();
    loadAllTags();
  }

  /// load most used tags into `mostUsedTags`
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

  /// load last week used tags into `lastWeekUsedTags`
  void loadLastWeekUsedTags({int maxTagsLength = 12}) {
    var now = DateTime.now();
    var sevenDaysBack =
        DateTime(now.year, now.month, (now.day - now.weekday - 1));
    _doSortingOfWeeksAndMonth(lastMonthUsedTags, sevenDaysBack, maxTagsLength);
  }

  /// load last month used tags into `lastMonthUsedTags`
  void loadLastMonthUsedTags({int maxTagsLength = 12}) {
    var now = DateTime.now();
    var monthBack = DateTime(now.year, now.month, 1);
    _doSortingOfWeeksAndMonth(lastMonthUsedTags, monthBack, maxTagsLength);
  }

  void _doSortingOfWeeksAndMonth(
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

/*   //@action
  Future<void> loadTags() async {
    var tagsBox = await database.getAllLabel();
    tags.clear();

    for (Label tag in tagsBox) {
      TagsStore tagsStore = TagsStore(
        id: tag.key,
        name: tag.title,
        count: tag.counter,
        time: tag.lastUsedAt,
      );
      addTag(tagsStore);
    }

    /* Label secretTag = tagsBox.firstWhere(
      (Label element) => element.key == kSecretTagKey,
      orElse: () => null,
    ); */
    if (tags[kSecretTagKey] == null) {
      //print('Creating secret tag in db!');
      Label createSecretLabel = Label(
        key: kSecretTagKey,
        title: 'Secret Pics',
        photoId: [],
        counter: 1,
        lastUsedAt: DateTime.now(),
      );
      await database.createLabel(createSecretLabel);
      //tagsBox.put(kSecretTagKey, createSecretTag);

      TagsStore tagsStore = TagsStore(
        id: kSecretTagKey,
        name: 'Secret Pics',
        count: 1,
        time: DateTime.now(),
      );
      addTag(tagsStore);
    }
    loadMostUsedTags();
    loadLastWeekUsedTags();
    loadLastMonthUsedTags();

    //print('******************* loaded tags **********');
  } */

  //@action
/*   void addRecentTags(String tagKey) {
    recentTags.add(tagKey);
  } */

  //@action
/*   Future<void> editRecentTags(String oldTagKey, String newTagKey) async {
    if (recentTags.contains(oldTagKey)) {
      //print('updating tag name in recent tags');
      int indexOfTag = recentTags.indexOf(oldTagKey);
      recentTags[indexOfTag] = newTagKey;
      /* var userBox = Hive.box('user');
      User getUser = userBox.getAt(0); */
      MoorUser currentUser = await database.getSingleMoorUser();
      int indexOfRecentTag = currentUser.recentTags.indexOf(oldTagKey);
      var tempTags = List<String>.from(currentUser.recentTags);
      tempTags[indexOfRecentTag] = newTagKey;
      await database.updateMoorUser(currentUser.copyWith(recentTags: tempTags));

/* 
      getUser.recentTags[indexOfRecentTag] = newTagKey;
      userBox.putAt(0, getUser); */
    }
  } */

  /// load all the tags async
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

      TagModel tagModel = TagModel(
        key: kSecretTagKey,
        title: 'Secret Pics',
        count: 1,
        time: DateTime.now(),
      );
      allTags[tagModel.key] = Rx<TagModel>(tagModel);

      await _database.createLabel(createSecretLabel);
    }

    /// load most used tags
    loadMostUsedTags();

    /// load last recent week used tags
    loadLastWeekUsedTags();

    /// load last recent month used tags
    loadLastMonthUsedTags();
  }

  /// add the tag
  void addTag(TagModel tagModel) {
    allTags[tagModel.key] = Rx<TagModel>(tagModel);
  }

  void addRecentTag(String tagKey) {
    if (recentTagKeyList.contains(tagKey) == false) {
      recentTagKeyList.add(tagKey);
    }
  }

  /// edit the tags name in all tags
  void _editTagInternalFunction(
      {@required String oldTagKey,
      @required String newTagKey,
      @required String newName}) {
    TagModel tagModel = allTags[oldTagKey].value;

    /// remove the oldTagKey because it will help us to make is un-listenable
    /// as it might be used somewhere else
    allTags.remove(oldTagKey);

    tagModel
      ..key = newTagKey
      ..title = newName
      ..time = DateTime.now();

    allTags[newTagKey] = Rx<TagModel>(tagModel);
  }

  /// remove Tag from all tags
  void removeTag(TagModel tagModel) {
    if (tagModel != null) {
      allTags.remove(tagModel.key);
    }
  }

  Future<void> editTagName(
      {@required String oldTagKey, @required String newName}) async {
    /// create a new tagKey
    String newTagKey = Helpers.encryptTag(newName);

    /// use that new tagKey to make the ui changes fastly
    _editTagInternalFunction(
        oldTagKey: oldTagKey, newTagKey: newTagKey, newName: newName);

    /// as soon as the `ui` changes are done - now secretly do the background changes in async manner

    /// fetch the `Label` from the `oldTagKey`
    Label oldTag = await _database.getLabelByLabelKey(oldTagKey);

    /// Creating new label
    Label createTag = Label(
        key: newTagKey,
        title: newName,
        photoId: oldTag.photoId,
        counter: oldTag.counter < 1 ? 1 : oldTag.counter,
        lastUsedAt: DateTime.now());

    await _database.createLabel(createTag);

    await Future.wait(
      [
        Future.forEach(createTag.photoId, (photoId) async {
          Photo pic = await _database.getPhotoByPhotoId(photoId);
          //Pic pic = picsBox.get(photoId);
          int indexOfOldTag = pic.tags.indexOf(oldTagKey);
          // //print('Tags in this picture: ${pic.tags}');
          if (indexOfOldTag > -1) {
            pic.tags[indexOfOldTag] = newTagKey;
          }
          await _database.updatePhoto(pic);
          //picsBox.put(photoId, pic);
          // //print('updated tag in pic ${pic.id}');
        })
      ],
    );

    await _database.deleteLabelByLabelId(oldTagKey);
    Analytics.sendEvent(Event.edited_tag);
  }

  /// untag the pic with tags as `tagKey`
  Future<void> deleteTagFromPic({String tagKey}) async {
    //var tagsBox = Hive.box('tags');

    var label = await _database.getLabelByLabelKey(tagKey);

    if (label != null) {
      // //print('found tag going to delete it');
      // Remove a tag das fotos já taggeadas
      TagModel tagsStore = allTags[tagKey].value;
      // //print('TagsStore Tag: ${tagsStore.name}');
      /*  TaggedPicsStore taggedPicsStore =
          taggedPics.firstWhere((element) => element.tag == tagsStore);
      for (PicStore picTagged in taggedPicsStore.pics) {
        // //print('Tagged Pic Store Pics: ${picTagged.photoId}');
        await picTagged.removeTagFromPic(tagKey: tagsStore.id);
        if (picTagged.tags.length == 0 && picTagged != currentPic) {
          // //print('this pic is not tagged anymore!');
          addPicToUntaggedPics(picStore: picTagged);
        }
      }
      taggedPics.remove(taggedPicsStore);
      recentTagKeyList.removeWhere((element) => element == tagKey);
      //appStore.removeTagFromRecent(tagKey: tagKey);
      removeTag(tagModel: tagsStore);
      await _database.deleteLabelByLabelId(tagKey); */
      //tagsBox.delete(tagKey);
      // //print('deleted from tags db');
      Analytics.sendEvent(Event.deleted_tag);
    }
  }
}
