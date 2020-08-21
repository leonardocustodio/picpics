import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/stores/tags_store.dart';

part 'pic_store.g.dart';

class PicStore = _PicStore with _$PicStore;

abstract class _PicStore with Store {
  final AssetEntity entity;
  final String photoId;
  final DateTime createdAt;
  final double originalLatitude;
  final double originalLongitude;

  _PicStore({
    this.entity,
    this.photoId,
    this.createdAt,
    this.originalLatitude,
    this.originalLongitude,
  }) {
    autorun((_) {
      print('autorun');
    });
  }

  @observable
  double latitude;

  @observable
  double longitude;

  @observable
  String specificLocation;

  @observable
  String generalLocation;

  ObservableList<TagsStore> tags = ObservableList<TagsStore>();

  @computed
  List<String> get tagsKeys {
    print('####!!!! Tags Keys: $tags');
    return tags.map((element) => element.id).toList();
  }

  @action
  Future<void> addTag({String tagName, String photoId}) async {
    var tagsBox = Hive.box('tags');
    print(tagsBox.keys);

    String tagKey = DatabaseManager.instance.encryptTag(tagName);
    print('Adding tag: $tagName');

    if (tagsBox.containsKey(tagKey)) {
      print('user already has this tag');

      Tag getTag = tagsBox.get(tagKey);

      if (getTag.photoId.contains(photoId)) {
        print('this tag is already in this picture');
        return;
      }

      getTag.photoId.add(photoId);
      tagsBox.put(tagKey, getTag);
      await addTagToPic(
        tagKey: tagKey,
        photoId: photoId,
        tagName: tagName,
      );
      DatabaseManager.instance.addTagToRecent(tagKey: tagKey);
      print('updated pictures in tag');
      return;
    }

    Analytics.sendEvent(Event.created_tag);
    print('adding tag to database...');
    tagsBox.put(tagKey, Tag(tagName, [photoId]));
    await addTagToPic(
      tagKey: tagKey,
      tagName: tagName,
      photoId: photoId,
    );
    DatabaseManager.instance.addTagToRecent(tagKey: tagKey);
  }

  @action
  Future<void> addTagToPic({String tagKey, String tagName, String photoId, List<AssetEntity> entities}) async {
    var picsBox = Hive.box('pics');

    if (picsBox.containsKey(photoId)) {
      print('this picture is in db going to update');

      Pic getPic = picsBox.get(photoId);

      if (getPic.tags.contains(tagKey)) {
        print('this tag is already in this picture');
        return;
      }

//      if (noTaggedPhoto == true) {
//        noTaggedPhoto = false;
//      }

      getPic.tags.add(tagKey);
      print('photoId: ${getPic.photoId} - tags: ${getPic.tags}');
      picsBox.put(photoId, getPic);
      print('updated picture');

      tags.add(TagsStore(
        id: tagKey,
        name: tagName,
      ));

//      checkPicHasTags(photoId);
      Analytics.sendEvent(Event.added_tag);
      return;
    }

    print('this picture is not in db, adding it...');
    print('Photo Id: $photoId');

    tags.add(TagsStore(
      id: tagKey,
      name: tagName,
    ));

    Pic pic = Pic(
      photoId,
      createdAt,
      latitude,
      longitude,
      null,
      null,
      null,
      null,
      [tagKey],
    );

//    if (selectedPhoto != null) {
//      print('Pic Info Localization: ${selectedPhoto.latitude} - ${selectedPhoto.longitude} - ${selectedPhoto.createDateTime}');
//
//      pic = Pic(
//        photoId,
//        selectedPhoto.createDateTime,
//        selectedPhoto.latitude,
//        selectedPhoto.longitude,
//        null,
//        null,
//        null,
//        null,
//        [tagKey],
//      );
//    } else {
//      AssetEntity entity = entities.firstWhere((element) => element.id == photoId, orElse: () => null);
//      if (entity == null) {
//        pic = Pic(
//          photoId,
//          null,
//          null,
//          null,
//          null,
//          null,
//          null,
//          null,
//          [tagKey],
//        );
//      } else {
//        pic = Pic(
//          photoId,
//          entity.createDateTime,
//          entity.latitude,
//          entity.longitude,
//          null,
//          null,
//          null,
//          null,
//          [tagKey],
//        );
//      }
//    }
    await picsBox.put(photoId, pic);
    print('@@@@@@@@ tagsKey: ${tagKey}');
//    checkPicHasTags(photoId);
//    if (noTaggedPhoto == true) {
//      noTaggedPhoto = false;
//    }

    // Increase today tagged pics everytime it adds a new pic to database.
    DatabaseManager.instance.increaseTodayTaggedPics();
    Analytics.sendEvent(Event.added_tag);
  }
}
