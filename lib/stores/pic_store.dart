import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:share_extend/share_extend.dart';

part 'pic_store.g.dart';

class PicStore = _PicStore with _$PicStore;

abstract class _PicStore with Store {
  final AppStore appStore;
  final AssetEntity entity;
  final String photoId;
  final DateTime createdAt;
  final double originalLatitude;
  final double originalLongitude;

  _PicStore({
    this.appStore,
    this.entity,
    this.photoId,
    this.createdAt,
    this.originalLatitude,
    this.originalLongitude,
  }) {
    print('loading pic info......');
    loadPicInfo();

    autorun((_) {
      print('autorun');
    });
  }

  @action
  void loadPicInfo() {
    var picsBox = Hive.box('pics');
    var tagsBox = Hive.box('tags');

    if (picsBox.containsKey(photoId)) {
      print('pic $photoId exists, loading data....');
      Pic pic = picsBox.get(photoId);

      latitude = pic.latitude;
      longitude = pic.longitude;
      specificLocation = pic.specificLocation;
      generalLocation = pic.generalLocation;

      for (String tagKey in pic.tags) {
        Tag tag = tagsBox.get(tagKey);
        TagsStore tagsStore = TagsStore(id: tagKey, name: tag.name);
        tags.add(tagsStore);
      }
    } else {
      print('pic $photoId doesnt exists in database');
    }
  }

  @observable
  double latitude;

  @observable
  double longitude;

  @observable
  String specificLocation;

  @observable
  String generalLocation;

  @observable
  String searchText = '';

  @action
  void setSearchText(String value) => searchText = value;

  ObservableList<TagsStore> tags = ObservableList<TagsStore>();

  @computed
  List<String> get tagsKeys {
    print('####!!!! Tags Keys: $tags');
    return tags.map((element) => element.id).toList();
  }

  @computed
  List<String> get tagsSuggestions {
//    tagsSuggestions(String text, String photoId, {List<String> excludeTags, bool notify = true}) {
    var userBox = Hive.box('user');
    var tagsBox = Hive.box('tags');
    User getUser = userBox.getAt(0);

    List<String> suggestionTags = [];

    if (searchText == '') {
      for (var recent in getUser.recentTags) {
        if (tagsKeys.contains(recent)) {
          continue;
        }
        suggestionTags.add(recent);
      }

      print('Sugestion Length: ${suggestionTags.length} - Num of Suggestions: ${kMaxNumOfSuggestions}');

//      while (suggestions.length < maxNumOfSuggestions) {
//          if (excludeTags.contains('Hey}')) {
//            continue;
//          }
      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (var tagKey in tagsBox.keys) {
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
          if (tagsKeys.contains(tagKey) || suggestionTags.contains(tagKey)) {
            continue;
          }
          suggestionTags.add(tagKey);
        }
      }
//      }
    } else {
      for (var tagKey in tagsBox.keys) {
        String tagName = DatabaseManager.instance.decryptTag(tagKey);
        if (tagName.startsWith(DatabaseManager.instance.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        }
      }
    }
    print('find suggestions: $searchText - exclude: $tagsKeys');
    print(suggestionTags);

    return suggestionTags;
  }

  @action
  Future<void> addTag({String tagName}) async {
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
//      DatabaseManager.instance.addTagToRecent(tagKey: tagKey);
      print('updated pictures in tag');
      print('Tag photos ids: ${getTag.photoId}');
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
//    DatabaseManager.instance.addTagToRecent(tagKey: tagKey);
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
      photoId: photoId,
      createdAt: createdAt,
      originalLatitude: originalLatitude,
      originalLongitude: originalLongitude,
      latitude: null,
      longitude: null,
      specificLocation: null,
      generalLocation: null,
      tags: [tagKey],
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
    appStore.increaseTodayTaggedPics();
    Analytics.sendEvent(Event.added_tag);
  }

  Future<String> _writeByteToImageFile(Uint8List byteData) async {
    Directory tempDir = await getTemporaryDirectory();
    File imageFile = new File('${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData);
    return imageFile.path;
  }

  @action
  Future<void> sharePic() async {
    String path = '';

    if (Platform.isAndroid) {
      path = await _writeByteToImageFile(await entity.originBytes);
    } else {
      var bytes = await entity.thumbDataWithSize(
        entity.size.width.toInt(),
        entity.size.height.toInt(),
        format: ThumbFormat.jpeg,
      );
      path = await _writeByteToImageFile(bytes);
    }

    if (path == '' || path == null) {
      return;
    }

    Analytics.sendEvent(Event.shared_photo);
    ShareExtend.share(path, "image");
  }

  @action
  Future<bool> deletePic() async {
    print('Before photo manager delete');
    List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
    print('Photo Editor Result: ${result}');

    if (result.isNotEmpty) {
      var picsBox = Hive.box('pics');
      var tagsBox = Hive.box('tags');

      Pic pic = picsBox.get(photoId);
      if (pic != null) {
        print('pic is in db... removing it from db!');

        for (var tag in pic.tags) {
          String tagKey = DatabaseManager.instance.stripTag(tag);

          Tag getTag = tagsBox.get(tagKey);
          getTag.photoId.remove(entity.id);
          print('removed ${entity.id} from $tag');
          tagsBox.put(tagKey, getTag);
        }
        print('removed ${entity.id} from database');
        picsBox.delete(photoId);
      }
      return true;
    }
    return false;
  }

  @action
  void removeTagFromPic({String tagKey}) {
    print('removing tag: $tagKey from pic $photoId');
    var tagsBox = Hive.box('tags');
    var picsBox = Hive.box('pics');

    Tag getTag = tagsBox.get(tagKey);

    print('Tag photos ids: ${getTag.photoId}');
    int indexOfPicInTag = getTag.photoId.indexOf(photoId);
    print('Tag index to remove: $indexOfPicInTag');
    if (indexOfPicInTag != null) {
      getTag.photoId.removeAt(indexOfPicInTag);
      tagsBox.put(tagKey, getTag);
      print('removed pic from tag');
    }

    Pic getPic = picsBox.get(photoId);
    int indexOfTagInPic = getPic.tags.indexOf(tagKey);

    if (indexOfTagInPic != null) {
      getPic.tags.removeAt(indexOfTagInPic);
      picsBox.put(photoId, getPic);
      print('removed tag from pic');
      tags.removeWhere((element) => element.id == tagKey);
    }
    Analytics.sendEvent(Event.removed_tag);
  }

  @action
  void saveLocation({double lat, double long, String specific, String general}) {
    var picsBox = Hive.box('pics');

    Pic getPic = picsBox.get(photoId);
    if (getPic != null) {
      print('found pic');

      getPic.latitude = lat;
      getPic.longitude = long;
      getPic.specificLocation = specific;
      getPic.generalLocation = general;
      getPic.save();
      print('updated pic with new values');
    } else {
      print('Did not found pic!');
      Pic createPic = Pic(
        photoId: photoId,
        createdAt: createdAt,
        originalLatitude: originalLatitude,
        originalLongitude: originalLongitude,
        latitude: latitude,
        longitude: longitude,
        specificLocation: specificLocation,
        generalLocation: generalLocation,
        tags: [],
      );
      picsBox.put(photoId, createPic);
      print('Saved pic to database!');
    }

    latitude = lat;
    longitude = long;
    specificLocation = specific;
    generalLocation = general;
  }
}
