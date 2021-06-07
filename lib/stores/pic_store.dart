import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:googleapis/translate/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
/* import 'package:metadata/metadata.dart' as md; */
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_extend/share_extend.dart';
import 'package:strings/strings.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/labels.dart';

import 'tags_controller.dart';

class PicStore extends GetxController {
  final DateTime createdAt;
  final double originalLatitude;
  final double originalLongitude;

  final AppDatabase database = AppDatabase();

  //ObservableMap<String, tagModel> tags = ObservableMap<String, tagModel>();
  var tags = <String, Rx<TagModel>>{}.obs;

  //var aiSuggestions = <tagModel>[];

  // @observable
  final aiTags = false.obs;

  // @observable
  final aiTagsLoaded = false.obs;

  // @observable
  final searchText = ''.obs;

  // @observable
  final latitude = RxDouble(null);

  // @observable
  final longitude = RxDouble(null);

  // @observable
  final specificLocation = RxString(null);

  // @observable
  final generalLocation = RxString(null);

  String nonce;

  // @observable
  final isPrivate = false.obs;

  // @observable
  final isStarred = false.obs;

  // @observable
  final photoId = RxString(null);

  // @observable
  final entity = Rx<AssetEntity>(null);

  // @observable
  final tagsSuggestions = <TagModel>[].obs;

  PicStore({
    @required AssetEntity entityValue,
    this.photoPath,
    this.thumbPath,
    @required String photoIdValue,
    this.createdAt,
    this.originalLatitude,
    this.originalLongitude,
    this.deletedFromCameraRoll,
    @required bool isStarredValue,
  }) {
    isStarred.value = isStarredValue ?? false;
    photoId.value = photoIdValue;
    entity.value = entityValue;
  }
  /*  {
    //print('loading pic info......');
    tagsSuggestionsCalculate();
    loadPicInfo();
  } */

  //@action
  Future<void> switchIsStarred() async {
    isStarred.value = !isStarred.value;
    //print('Setting starred photo $photoId to $value');

    //var picsBox = Hive.box('pics');
    Photo pic = await database.getPhotoByPhotoId(photoId.value);
    //pic.isStarred = value;
    String base64encoded;
    //print('teste');
    if (isStarred.value) {
      var bytes = await entity.value.thumbDataWithSize(300, 300);
      String encoded = base64.encode(bytes);
      base64encoded = encoded;
      UserController.to.addToStarredPhotos(photoId.value);
    } else {
      UserController.to.removeFromStarredPhotos(photoId.value);
    }

    /// Do the database writting
    await database.updatePhoto(
      pic.copyWith(
        base64encoded: base64encoded,
        isStarred: isStarred.value,
      ),
    );
    //print('isStarred value: $isStarred');
  }

  //@action
  Future<void> setChangePhotoId(String value) async {
    //var tagsBox = Hive.box('tags');

    var tagKeys = tags.keys.toList();
    tagKeys.forEach((tKeys) async {
      Label getTag = await database.getLabelByLabelKey(tKeys);

      getTag.photoId.remove(photoId);
      getTag.photoId.add(value);
      //print('Replaced tag in ${getTag.title} tagsbox');
      await database.updateLabel(getTag);
    });

    photoId.value = value;
  }

  //@action
  Future<void> changeAssetEntity(AssetEntity picEntity) async {
    //print('Changing asset entity of $photoId to ${picEntity.id}');

    //var picsBox = Hive.box('pics');
    //Pic picOld = picsBox.get(photoId);
    Photo picOld = await database.getPhotoByPhotoId(photoId.value);

    if (picOld != null) {
      Photo createPic = Photo(
        id: picEntity.id,
        createdAt: picOld.createdAt,
        originalLatitude: picOld.originalLatitude,
        originalLongitude: picOld.originalLongitude,
        latitude: picOld.latitude,
        longitude: picOld.longitude,
        specificLocation: picOld.specificLocation,
        generalLocation: picOld.generalLocation,
        tags: picOld.tags,
        isPrivate: picOld.isPrivate ?? false,
        deletedFromCameraRoll: picOld.deletedFromCameraRoll ?? false,
        isStarred: picOld.isStarred ?? false,
      );
      //picsBox.put(picEntity.id, createPic);
      await database.createPhoto(createPic);
      //picOld.delete();
      await database.deletePhoto(picOld);
    }

    entity.value = picEntity;
    await setChangePhotoId(picEntity.id);
    //print('Changed asset entity');
  }

  Future<Uint8List> get assetOriginBytes async {
    if (isPrivate == false && entity != null) {
      return await entity.value.originBytes;
    }
    //print('Returning decrypt image in privatePath: $photoPath');
    return await Crypto.decryptImage(
        photoPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
  }

  Future<Uint8List> get assetThumbBytes async {
    if (isPrivate == false && entity != null) {
      return await entity.value.thumbDataWithSize(
          kDefaultPreviewThumbSize[0], kDefaultPreviewThumbSize[1]);
    }
    //print('Returning decrypt image in privatePath: $thumbPath');
    return await Crypto.decryptImage(
        thumbPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
  }

  String photoPath;
  String thumbPath;
  bool deletedFromCameraRoll;

  Future<void> setDeletedFromCameraRoll(bool value) async {
    //print('Setting deleted from camera roll as $value');
    deletedFromCameraRoll = value;

    //var picsBox = Hive.box('pics');
    //Pic pic = picsBox.get(photoId);
    Photo pic = await database.getPhotoByPhotoId(photoId.value);
    //pic.deletedFromCameraRoll = value;
    //pic.save();
    await database.updatePhoto(pic.copyWith(deletedFromCameraRoll: value));
  }

  //@action
  Future<void> setPrivatePath(
      String picPath, String thumbnailPath, String picNonce) async {
    //var secretBox = Hive.box('secrets');
    Private secret = Private(
      id: photoId.value,
      path: picPath,
      thumbPath: thumbnailPath,
      originalLatitude: originalLatitude,
      originalLongitude: originalLongitude,
      createDateTime: createdAt,
      nonce: picNonce,
    );
    //secretBox.put(photoId, secret);
    await database.updatePrivate(secret);
    photoPath = picPath;
    thumbPath = thumbnailPath;
    nonce = picNonce;

    if (UserController.to.shouldDeleteOnPrivate == true) {
      //print('**** Deleted original pic!!!');
      if (Platform.isAndroid) {
        await PhotoManager.editor.deleteWithIds([entity.value.id]);
      } else {
        final List<String> result =
            await PhotoManager.editor.deleteWithIds([entity.value.id]);
        if (result.isEmpty) {
          return false;
        }
      }
      setDeletedFromCameraRoll(true);
      entity.value = null;
      return;
    }
    setDeletedFromCameraRoll(false);
  }

  //@action
  Future<void> removePrivatePath() async {
    //print('Removing pic from secrets box...');

    //var secretBox = Hive.box('secrets');
    //Secret secretPic = secretBox.get(photoId);
    Private secretPic = await database.getPrivateByPhotoId(photoId.value);

    if (secretPic != null) {
      //secretPic.delete();
      await database.deletePrivate(secretPic);
      //print('Pic deleted from secrets box!!!');
      return;
    }

    //print('Did not find the pic in secretbox');
  }

  Future<void> deleteEncryptedPic({bool copyToCameraRoll = false}) async {
    //print('Deleting $photoPath and $thumbPath');

    if (copyToCameraRoll == true && deletedFromCameraRoll == true) {
      //print('Pic has entity? ${entity == null ? false : true}');
      Uint8List picData = await assetOriginBytes;
      final AssetEntity imageEntity =
          await PhotoManager.editor.saveImage(picData);
      await changeAssetEntity(imageEntity);
      //print('copied image back to gallery with id: ${imageEntity.id}');
    }
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    File photoFile = File(p.join(appDocumentsDir.path, photoPath));
    File thumbFile = File(p.join(appDocumentsDir.path, thumbPath));

    photoFile.delete();
    thumbFile.delete();
    //print('Removed both files...');
  }

/*   Future<void> loadExifData() async {
    File originFile = await entity.value.originFile;
    var originBytes = originFile.readAsBytesSync();

    var mapResult = md.MetaData.extractXMP(originBytes, raw: true);
    //print(mapResult['dc:subject']);
  } */

  //@action
  Future<void> loadPicInfo() async {
    // loadExifData();

    //var picsBox = Hive.box('pics');
    //var secretBox = Hive.box('secrets');
    Photo pic = await database.getPhotoByPhotoId(photoId.value);
    if (pic != null) {
      //print('pic $photoId exists, loading data....');
      //Pic pic = picsBox.get(photoId);

      latitude.value = pic.latitude;
      longitude.value = pic.longitude;
      specificLocation.value = pic.specificLocation;
      generalLocation.value = pic.generalLocation;
      isPrivate.value = pic.isPrivate ?? false;
      deletedFromCameraRoll = pic.deletedFromCameraRoll ?? false;
      isStarred.value = pic.isStarred ?? false;

      //print('Is private: $isPrivate');
      if (isPrivate == true) {
        Private secretPic = await database.getPrivateByPhotoId(photoId.value);

        if (secretPic != null) {
          photoPath = secretPic.path;
          thumbPath = secretPic.thumbPath;
          nonce = secretPic.nonce;
          //print('Setting private path to: $photoPath - Thumb: $thumbPath - Nonce: $nonce');
        }
      }

      for (String tagKey in pic.tags) {
        var tagModel = TagsController.to.allTags[tagKey];
        if (tagModel == null) {
          //print('&&&&##### DID NOT FIND TAG: ${tagKey}');
          continue;
        }
        tags[tagKey] = tagModel;
      }
    }
    /* else {
      //print('pic $photoId doesnt exists in database');
    } */
  }

  //@action
  Future<void> setIsPrivate(bool value) async {
    if (value) {
      await addSecretTagToPic();
    } else {
      await removeSecretTagFromPic();
      await deleteEncryptedPic(copyToCameraRoll: true);
    }

    isPrivate.value = value;
    //print('Pic isPrivate: $value');
    //print('Pic Entity Exists: ${entity == null ? false : true}');
    //print('Photo Id: ${photoId} - Entity Id: ${entity != null ? entity.id : null}');

    //var picsBox = Hive.box('pics');
    Photo getPic = await database.getPhotoByPhotoId(photoId.value);
    //getPic.isPrivate = value;
    //picsBox.put(photoId, getPic);
    await database.updatePhoto(getPic.copyWith(isPrivate: value));
  }

  Future<void> addSecretTagToPic() async {
    //var tagsBox = Hive.box('tags');
    //Tag getTag = tagsBox.get(kSecretTagKey);
    Label getTag = await database.getLabelByLabelKey(kSecretTagKey);

    if (getTag.photoId.contains(photoId)) {
      //print('this tag is already in this picture');
      return;
    }

    getTag.photoId.add(photoId.value);
    //tagsBox.put(kSecretTagKey, getTag);
    await database.updateLabel(getTag);

    await addTagToPic(
      tagKey: kSecretTagKey,
      photoId: photoId.value,
    );
    await tagsSuggestionsCalculate();
    //print('Added secret tag to pic!');
  }

  Future<void> removeSecretTagFromPic() async {
    await removeTagFromPic(tagKey: kSecretTagKey);
    await tagsSuggestionsCalculate();
    //print('Added secret tag to pic!');
  }

  //@action
  void setSearchText(String value) {
    searchText.value = value;
    setAiTags(false);
    tagsSuggestionsCalculate();
  }

  Future<List<TagModel>> tagsSuggestionsCalculate() async {
    //var tagsBox = Hive.box('tags');
    var tagsBox = await database.getAllLabel();
    var tagsBoxKeys = tagsBox.map((e) => e.key);
    tagsSuggestions.clear();
    searchText.value = searchText.trim();

    if (searchText == '') {
      var suggestions = <TagModel>[];
      var suggestionTags = <String>[];
      var tagsKeys = tags.keys.toList();

      for (var recent in UserController.to.recentTags) {
        if (tagsKeys.contains(recent)) continue;
        suggestionTags.add(recent);
      }

      //print('Sugestion Length: ${suggestionTags.length} - Num of Suggestions: ${kMaxNumOfSuggestions}');

//      while (suggestions.length < maxNumOfSuggestions) {
//          if (excludeTags.contains('Hey}')) {
//            continue;
//          }
      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (var tagKey in tagsBoxKeys) {
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
          if (tagsKeys.contains(tagKey) ||
              suggestionTags.contains(tagKey) ||
              tagKey == kSecretTagKey) {
            continue;
          }
          suggestionTags.add(tagKey);
        }
      }

      for (String tagId in suggestionTags) {
        suggestions.add(TagsController.to.allTags[tagId].value);
      }

      tagsSuggestions.value = suggestions;
//      }
    } else {
      var listOfLetters = searchText.toLowerCase().split('');
      for (var tagKey in tagsBoxKeys) {
        if (tagKey == kSecretTagKey) continue;
        var tagName = Helpers.decryptTag(tagKey);
        doCustomisedSearching(
          tagName,
          listOfLetters,
          (matched) {
            if (matched && TagsController.to.allTags[tagKey].value != null)
              tagsSuggestions.add(TagsController.to.allTags[tagKey].value);
          },
        );
        /* if (tagName.startsWith(Helpers.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        } */
      }
    }
    //print('find suggestions: $searchText');

    return <TagModel>[];
  }

  //@action
  Future<void> addTag({String tagName}) async {
    //var tagsBox = Hive.box('tags');
    /* //print(tagsBox.keys); */

    String tagKey = Helpers.encryptTag(tagName);
    //print('Adding tag: $tagName');
    Label getTag = await database.getLabelByLabelKey(tagKey);

    if (getTag != null) {
      //print('user already has this tag');

      //Tag getTag = tagsBox.get(tagKey);

      if (getTag.photoId.contains(photoId)) {
        //print('this tag is already in this picture');
        return;
      }

      getTag.photoId.add(photoId.value);

      /// Updating the last used time and also incrementing the counter.
      var count = getTag.counter + 1;
      if (count < 0) count = 1;
      var updatedTag =
          getTag.copyWith(counter: count, lastUsedAt: DateTime.now());
      //tagsBox.put(tagKey, getTag);
      await database.updateLabel(updatedTag);
      await addTagToPic(
        tagKey: tagKey,
        photoId: photoId.value,
      );

      await UserController.to.addTagToRecent(tagKey: tagKey);
      //print('updated pictures in tag');
      //print('Tag photos ids: ${getTag.photoId}');
    }

    Analytics.sendEvent(
      Event.created_tag,
      params: {'tagName': tagName},
    );
    //print('adding tag to database...');
    TagModel tagModel =
        TagModel(key: tagKey, title: tagName, count: 1, time: DateTime.now());
    TagsController.to.addTag(tagModel);

    //tagsBox.put(tagKey, Tag(tagName, [photoId]));
    await database.createLabel(Label(
        key: tagKey,
        title: tagName,
        photoId: [photoId.value],
        counter: 1,
        lastUsedAt: DateTime.now()));
    await addTagToPic(
      tagKey: tagKey,
      photoId: photoId.value,
    );
    await UserController.to.addTagToRecent(tagKey: tagKey);
  }

  //@action
  Future<void> addTagToPic(
      {String tagKey,
      String tagNameX,
      String photoId,
      List<AssetEntity> entities}) async {
    //var picsBox = Hive.box('pics');
    Photo getPic = await database.getPhotoByPhotoId(photoId);

    if (getPic != null) {
      //print('this picture is in db going to update');

      //Pic getPic = picsBox.get(photoId);

      if (getPic.tags.contains(tagKey)) {
        //print('this tag is already in this picture');
        await tagsSuggestionsCalculate();
        return;
      }

      getPic.tags.add(tagKey);
      //print('photoId: ${getPic.id} - tags: ${getPic.tags}');
      //picsBox.put(photoId, getPic);
      await database.updatePhoto(getPic);
      //print('updated picture');

      var tagModel = TagsController.to.allTags[tagKey];

      tags[tagKey] = tagModel;

      await tagsSuggestionsCalculate();

      Analytics.sendEvent(
        Event.added_tag,
        params: {'tagName': tagModel.value.title},
      );
      return;
    }

    //print('this picture is not in db, adding it...');
    //print('Photo Id: $photoId');

    var tagModel = TagsController.to.allTags[tagKey];
    tags[tagKey] = tagModel;

    Photo pic = Photo(
      id: photoId,
      createdAt: createdAt,
      originalLatitude: originalLatitude,
      originalLongitude: originalLongitude,
      latitude: null,
      longitude: null,
      specificLocation: null,
      generalLocation: null,
      tags: [tagKey],
      isStarred: false,
      deletedFromCameraRoll: false,
      isPrivate: tagKey == kSecretTagKey ? true : false,
    );

    //await picsBox.put(photoId, pic);
    await database.createPhoto(pic);
    //print('@@@@@@@@ tagsKey: ${tagKey}');

    // Increase today tagged pics everytime it adds a new pic to database.
    UserController.to.increaseTodayTaggedPics();

    await tagsSuggestionsCalculate();
    Analytics.sendEvent(
      Event.added_tag,
      params: {'tagName': tagModel.value.title},
    );
  }

  Future<String> _writeByteToImageFile(Uint8List byteData) async {
    Directory tempDir = await getTemporaryDirectory();
    File imageFile = File(
        '${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData);
    return imageFile.path;
  }

  //@action
  Future<void> sharePic() async {
    String path = '';

    if (Platform.isAndroid) {
      path = await _writeByteToImageFile(entity == null
          ? await assetOriginBytes
          : await entity.value.originBytes);
    } else {
      if (entity == null) {
        var bytes = await assetOriginBytes;
        path = await _writeByteToImageFile(bytes);
      } else {
        var bytes = await entity.value.thumbDataWithSize(
          entity.value.size.width.toInt(),
          entity.value.size.height.toInt(),
          format: ThumbFormat.jpeg,
        );
        path = await _writeByteToImageFile(bytes);
      }
    }

    if (path == '' || path == null) {
      return;
    }

    Analytics.sendEvent(Event.shared_photo);
    ShareExtend.share(path, "image");
  }

  //@action
  Future<bool> deletePic() async {
    //print('Before photo manager delete: ${entity.id}');

    if (Platform.isAndroid) {
      PhotoManager.editor.deleteWithIds([entity.value.id]);
    } else {
      final List<String> result =
          await PhotoManager.editor.deleteWithIds([entity.value.id]);
      if (result.isEmpty) {
        return false;
      }
    }

    //var picsBox = Hive.box('pics');
    //Pic pic = picsBox.get(photoId);
    Photo pic = await database.getPhotoByPhotoId(photoId.value);

    if (pic != null) {
      //print('pic is in db... removing it from db!');
      List<String> picTags = List<String>.from(pic.tags);
      for (String tagKey in picTags) {
        await removeTagFromPic(tagKey: tagKey);

        if (tagKey == kSecretTagKey) {
          deleteEncryptedPic();
        }
      }
      //picsBox.delete(photoId);
      await database.deletePhotoByPhotoId(photoId.value);
      //print('removed ${photoId} from database');
    }

    return true;
  }

  //@action
  Future<void> removeTagFromPic({String tagKey}) async {
    Label getTag = await database.getLabelByLabelKey(tagKey);

    int indexOfPicInTag = getTag.photoId.indexOf(photoId.value);

    if (indexOfPicInTag != -1) {
      getTag.photoId.removeAt(indexOfPicInTag);
      await database.updateLabel(getTag);
    }

    Photo getPic = await database.getPhotoByPhotoId(photoId.value);
    int indexOfTagInPic = getPic.tags.indexOf(tagKey);

    if (indexOfTagInPic != -1) {
      getPic.tags.removeAt(indexOfTagInPic);
      await database.updatePhoto(getPic);
      tags.remove(tagKey);
    }

    if (tagKey == kSecretTagKey) {
      removePrivatePath();
    }

    await tagsSuggestionsCalculate();

    Analytics.sendEvent(
      Event.removed_tag,
      params: {'tagName': getTag.title},
    );
  }

  //@action
  Future<void> saveLocation(
      {double lat, double long, String specific, String general}) async {
    //var picsBox = Hive.box('pics');

    //Pic getPic = picsBox.get(photoId);
    Photo getPic = await database.getPhotoByPhotoId(photoId.value);

    if (getPic != null) {
      //print('found pic');

      //getPic.latitude = lat;
      //getPic.longitude = long;
      //getPic.specificLocation = specific;
      //getPic.generalLocation = general;
      //getPic.save();
      await database.updatePhoto(getPic.copyWith(
        latitude: lat,
        longitude: long,
        specificLocation: specific,
        generalLocation: general,
      ));
      //print('updated pic with new values');
    } else {
      //print('Did not found pic!');
      Photo createPic = Photo(
        id: photoId.value,
        createdAt: createdAt,
        originalLatitude: originalLatitude,
        originalLongitude: originalLongitude,
        latitude: latitude.value,
        longitude: longitude.value,
        specificLocation: specificLocation.value,
        generalLocation: generalLocation.value,
        tags: [],
        isStarred: false,
        isPrivate: false,
        deletedFromCameraRoll: false,
      );
      //picsBox.put(photoId, createPic);
      await database.createPhoto(createPic);
      //print('Saved pic to database!');
    }

    latitude.value = lat;
    longitude.value = long;
    specificLocation.value = specific;
    generalLocation.value = general;
  }

  //@action
  void setAiTags(bool value) => aiTags.value = value;

  //@action
  void switchAiTags() {
    aiTags.value = !aiTags.value;

    if (aiTags == true) {
      //getAiSuggestions(context);
    }
  }

  //@action
  void setAiTagsLoaded(bool value) => aiTagsLoaded.value = value;

  Future<List<String>> translateTags(
      List<String> tagsText, BuildContext context) async {
    var lang = UserController.to.appLanguage.split('_')[0];
    if (lang == 'pt' || lang == 'es' || lang == 'de' || lang == 'ja') {
      //print('Offline translating it...');
      return tagsText
          .map((e) => PredefinedLabels.labelTranslation(e, context))
          .toList();
    }

    final _credentials = ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "picpics",
  "private_key_id": "c3dd82e591d63cbb5b6ab4b7756ebc1e5a6aae10",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCvQhYWho56yC6F\nHqt9l5pcmuzhS/pR19P2L1JgETfVI8PL36lyJc2lIVbLyWJjCxeUk7gdR2G2lknf\n/ulh1il/Ig8PebrvlCC0oN1jsJ9YPh1DOsj5fd5p25XgRc32FM+EcEhQB/5V+pIa\n/K8X5BY9igN6LKNAIkQpJDjtc9udbp0//BX3jpVQp/hfOnV+kMhfdb0hoBS5BpNZ\nmYBxPYXo08yLkvk2AH71GfSjEUAb0X6SsHONlMX6lp9xhrQmhbH4Fog6oAkbk2T8\n+DILqscxRGP+QBpq+msfYVAuRWTIubMOSDaf03W0HxdZIoRI5IDsis7lcNDhTbeC\nsyNNouTlAgMBAAECggEAILDKjvQVYpixeLpCUcB0Fh793X5/GEIScwLbsjiz+elc\nbcxv/m9HvywLVSLg28mnYdr2BlwYwWaiLAqP/ORmRCUVuxTBRkwSl67D7QL2jg60\nBaTS9RrB4GwJtlY+905lcPZCvs7m5aHCHA+TF3k/nsX+JQ1rfByIK0Zq6fvo9KHr\n/r13R/rP6VgBxAJFy7mtuvVD1i+KPJinFqaA92TXD4YLS3K+q3QWyQlJQkxoLtsS\nm5GBvevyc/FRtIcUVRQzk9sl7/RGpqPVNjyKwE7XQzJXrgotn2YY/lEM/PtawKyL\n2hQYYmc3h3ho5nEQRG2NkmylgHNsx6yxXQqaM7vjoQKBgQD2QsQJrlZ/BEIVxp6U\nj4u+bpgA4fYsFaiW4108/DkHz5L1uBdmDqGjSZoDwGdNlYQiQeFEP28oYmtcmSDQ\nk8hUAtG4UUIBR0ssCL5zQyA23YBJFNh1EjP36Puc5ZANWDHG1CpJWO9Bok5lspgL\n3tp0A3SpBVVfPTIdZntqcqijkQKBgQC2MHa3E3MfpUPiXY2MWc0a2Su/NoPL92Bh\nT12vC+Ufgi3BNu7ty46u/7xUiLS44KOBI2/iPenMdsLyueQDK7Izr7TqptzpylMi\n2Udo7RfCvkMY52Bi4G4RiEx69gYhEHHhmLiyOMZSO2KuIq7k0X6JrkSA7WAN140i\nxRdPWETaFQKBgAKFdnpe5ZXRVlfgu7jrq1Oc0EOaDKow4pQA6fB46KCS2H9ZjivG\nVJNWapRFQQmDUWIEaKkJOTshntXI35QjHzb0/G61rkZTE4r03/ZQJqFJLUoSQ5EX\nSZ7tLL5Tf2ETmRbfDzvHBFQYtFLIPFRKyNPNQUGFw3UBLGUuqm7Rk7ZxAoGAXpLh\nzT9Hb5H2nzc5FzY2hk1drDC8UdDkMx9j3k4qbiTBY58EgGQ+eRE/zhH43k+eEJc4\nqRTCnOS5Zg6hEhRIuRPosjZUTvg8F8b6jrkksG7bnb3eBvXBrVA3g0za+abztsv0\ndG+MY3t4SjSu3RDywr23ycVvK0BNf1MYOpPzidECgYAOzBUT9BfUz7V916120dTd\nX6lfibdQ33QcghlDlw/ci+6pSruq0v/AQrhE0EIebWQ7T78MJs5dWhUnlvfIJ+BK\nP2UMYn4AVfNuSO+YDvO/JWW06ejnzBQfnnJoj9GhUfe8vHhiOs/rl41SGvtDfi9j\n13h9Ezm1pbTm9zyNUIXppw==\n-----END PRIVATE KEY-----\n",
  "client_email": "picpics-translation@picpics.iam.gserviceaccount.com",
  "client_id": "105726646433560994347",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/picpics-translation%40picpics.iam.gserviceaccount.com"
}
''');

    const _SCOPES = const [TranslateApi.CloudTranslationScope];
    List<String> translatedStrings;

    await clientViaServiceAccount(_credentials, _SCOPES)
        .then((http_client) async {
      var translate = TranslateApi(http_client);
      var request = TranslateTextRequest();
      request.contents = tagsText;
      request.mimeType = 'text/plain';
      request.sourceLanguageCode = 'en-US';
      request.targetLanguageCode =
          UserController.to.appLanguage.replaceAll('_', '-');
      request.model = 'projects/picpics/locations/global/models/general/nmt';

      var response =
          await translate.projects.translateText(request, 'projects/picpics');
      var translations = response.translations;
      translatedStrings =
          translations.map((e) => capitalize(e.translatedText)).toList();
    });

    return translatedStrings;
  }

  // Uint8List imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
  //   var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  //   var buffer = Float32List.view(convertedBytes.buffer);
  //   int pixelIndex = 0;
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) {
  //       var pixel = image.getPixel(j, i);
  //       buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
  //       buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
  //       buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
  //     }
  //   }
  //   return convertedBytes.buffer.asUint8List();
  // }
  //
  // Uint8List imageToByteListUint8(img.Image image, int inputSize) {
  //   var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
  //   var buffer = Uint8List.view(convertedBytes.buffer);
  //   int pixelIndex = 0;
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) {
  //       var pixel = image.getPixel(j, i);
  //       buffer[pixelIndex++] = img.getRed(pixel);
  //       buffer[pixelIndex++] = img.getGreen(pixel);
  //       buffer[pixelIndex++] = img.getBlue(pixel);
  //     }
  //   }
  //   return convertedBytes.buffer.asUint8List();
  // }

  // Float32List imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
  //   var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  //   var buffer = Float32List.view(convertedBytes.buffer);
  //
  //   int pixelIndex = 0;
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) {
  //       var pixel = image.getPixel(j, i);
  //       buffer[pixelIndex++] = (img.getRed(pixel) / mean) - 1;
  //       buffer[pixelIndex++] = (img.getGreen(pixel) / mean) - 1;
  //       buffer[pixelIndex++] = (img.getBlue(pixel) / mean) - 1;
  //     }
  //   }
  //
  //   double minValue = buffer.reduce(min);
  //   double maxValue = buffer.reduce(max);
  //
  /* //print('Min: $minValue - Max: $maxValue - Mean: $mean'); */
  //
  //   return convertedBytes.buffer.asFloat32List();
  // }

//   Uint8List imageToByteListUint8(img.Image image, int inputSize) {
//     var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
//     var buffer = Uint8List.view(convertedBytes.buffer);
//     int pixelIndex = 0;
//     for (var i = 0; i < inputSize; i++) {
//       for (var j = 0; j < inputSize; j++) {
//         var pixel = image.getPixel(j, i);
//         buffer[pixelIndex++] = img.getRed(pixel);
//         buffer[pixelIndex++] = img.getGreen(pixel);
//         buffer[pixelIndex++] = img.getBlue(pixel);
//       }
//     }
//     return convertedBytes.buffer.asUint8List();
//   }
//
//   img.Image resizeImage(ByteBuffer imageBytes, int inputSize) {
// //var imageBytes = (await rootBundle.load(image.path)).buffer;
//     img.Image oriImage = img.decodeJpg(imageBytes.asUint8List());
//     img.Image resizedImage = img.copyResize(oriImage, height: inputSize, width: inputSize);
//     return resizedImage;
//   }
//
//   img.Image getImage(ByteBuffer imageBytes) {
//     return img.decodeJpg(imageBytes.asUint8List());
//   }

  //@action
  /* Future<void> getAiSuggestions(BuildContext context) async {
    if (aiTagsLoaded == true) {
      return;
    }

    aiSuggestions.clear();

    // final stopwatch = Stopwatch()..start();
    // final int inputSize = 224;
    //
    // // img.Image oriImage = getImage((await entity.originFile).readAsBytesSync().buffer);
    //
    // var imageBytes = (await entity.file).readAsBytesSync().buffer;
    // var resizedImage = resizeImage(imageBytes, inputSize);
    // var input = imageToByteListFloat32(resizedImage, inputSize, 127.5, 255).reshape([1, 224, 224, 3]);
    /* //print('Input: $input'); */
    //
    // //print(input.)
    //
    // final interpreter = await tfl.Interpreter.fromAsset('model.tflite');
    // var output = List(1 * 1000).reshape([1, 1000]);
    //
    // interpreter.run(input, output);
    /* //print(output); */
    // interpreter.close();
    /* //print('doSomething() executed in ${stopwatch.elapsed}'); */

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(await entity.value.file);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    List<String> tags = [];
    for (ImageLabel label in labels) {
      final String labelText = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      //print('Label: $labelText - Entity: $entityId - Confidence: $confidence');
      tags.add(labelText);
    }

    List<String> translatedTags = UserController.to.appLanguage.split('_')[0] != 'en'
        ? await translateTags(tags, context)
        : tags;

    for (String translated in translatedTags) {
      String tagKey = Helpers.encryptTag(translated);
      tagModel tagStore = UserController.to.tags[tagKey];
      if (tagStore == null) {
        tagStore = tagModel(
          id: tagKey,
          name: translated,
        );
      }
      aiSuggestions.add(tagStore);
    }
    aiTagsLoaded.value = true;
    labeler.close();
  } */
}
