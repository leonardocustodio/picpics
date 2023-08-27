import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;
import 'package:googleapis/translate/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
/* import 'package:metadata/metadata.dart' as md; */
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/model/tag_model.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:share_extend/share_extend.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/labels.dart';

import 'tags_controller.dart';

class PicStore extends GetxController {
  final DateTime createdAt;
  final double? originalLatitude;
  final double? originalLongitude;

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
  final latitude = RxnDouble(null);

  // @observable
  final longitude = RxnDouble(null);

  // @observable
  final specificLocation = RxnString(null);

  // @observable
  final generalLocation = RxnString(null);

  String nonce = '';

  // @observable
  final isPrivate = false.obs;

  // @observable
  final isStarred = false.obs;

  // @observable
  final photoId = ''.obs;

  // @observable
  final entity = Rxn<AssetEntity>();

  final tagsSuggestions = <TagModel>[].obs;

  PicStore({
    required AssetEntity entityValue,
    required this.photoPath,
    required this.thumbPath,
    required String photoId,
    required this.createdAt,
    this.originalLatitude,
    this.originalLongitude,
    this.deletedFromCameraRoll = false,
  }) {
    this.photoId.value = photoId;
    entity.value = entityValue;
    isStar();
  }
  /*  {
    print('loading pic info......');
    tagsSuggestionsCalculate();
    loadPicInfo();
  } */

  Future<bool> isStar() async {
    final photo = await database.getPhotoByPhotoId(photoId.value);
    isStarred.value = photo?.isStarred ?? false;
    return isStarred.value;
  }

  Future<bool?> switchIsStarred() async {
    var pic = await database.getPhotoByPhotoId(photoId.value);
    if (pic == null) {
      return null;
    }
    await database.updatePhoto(
      pic.copyWith(isStarred: !isStarred.value),
    );
    return await isStar();
    //pic.isStarred = value;
    /* String? base64encoded;
    print('teste');
    if (isStarred.value) {
      //var bytes = await entity.value?.thumbDataWithSize(300, 300);

      /// TODO: what to do in this case scenario
      /* if (bytes == null) {
        return;
      } */
      /* var encoded = base64.encode(bytes);
      base64encoded = encoded; */
      /* await UserController.to.addToStarredPhotos(photoId.value); */
    } else {
      /* await UserController.to.removeFromStarredPhotos(photoId.value); */
    } */

    /// Do the database writting

    print('isStarred value: $isStarred');
  }

  //@action
  Future<void> setChangePhotoId(String value) async {
    //var tagsBox = Hive.box('tags');

    var tagKeys = tags.keys.toList();
    tagKeys.forEach((tKeys) async {
      final getTag = await database.getLabelByLabelKey(tKeys);
      if (getTag != null) {
        getTag.photoId.remove(photoId);
        getTag.photoId[value] = '';
        print('Replaced tag in ${getTag.title} tagsbox');
        await database.updateLabel(getTag);
      }
    });

    photoId.value = value;
  }

  //@action
  Future<void> changeAssetEntity(AssetEntity picEntity) async {
    print('Changing asset entity of $photoId to ${picEntity.id}');

    //var picsBox = Hive.box('pics');
    //Pic picOld = picsBox.get(photoId);
    var picOld = await database.getPhotoByPhotoId(photoId.value);

    if (picOld != null) {
      var createPic = Photo(
        id: picEntity.id,
        createdAt: picOld.createdAt,
        originalLatitude: picOld.originalLatitude,
        originalLongitude: picOld.originalLongitude,
        latitude: picOld.latitude,
        longitude: picOld.longitude,
        specificLocation: picOld.specificLocation,
        generalLocation: picOld.generalLocation,
        tags: picOld.tags,
        isPrivate: picOld.isPrivate,
        deletedFromCameraRoll: picOld.deletedFromCameraRoll,
        isStarred: picOld.isStarred,
      );
      //picsBox.put(picEntity.id, createPic);
      await database.createPhoto(createPic);
      //picOld.delete();
      await database.deletePhoto(picOld);
    }

    entity.value = picEntity;
    await setChangePhotoId(picEntity.id);
    print('Changed asset entity');
  }

  Future<Uint8List?> get assetOriginBytes async {
    if (isPrivate.value == false) {
      return await entity.value?.originBytes;
    }
    print('Returning decrypt image in privatePath: $photoPath');
    if (UserController.to.encryptionKey == null) {
      return null;
    }
    return await Crypto.decryptImage(
        photoPath, UserController.to.encryptionKey!, hex.decode(nonce));
  }

  Future<Uint8List?> get assetThumbBytes async {
    if (isPrivate.value == false) {
      return await entity.value?.thumbnailDataWithSize(ThumbnailSize(
          kDefaultPreviewThumbSize[0], kDefaultPreviewThumbSize[1]));
    }
    print('Returning decrypt image in privatePath: $photoPath');
    if (UserController.to.encryptionKey == null) {
      return null;
    }
    return await Crypto.decryptImage(
        thumbPath, UserController.to.encryptionKey!, hex.decode(nonce));
  }

  String photoPath;
  String thumbPath;
  bool deletedFromCameraRoll = false;

  Future<void> setDeletedFromCameraRoll(bool value) async {
    print('Setting deleted from camera roll as $value');
    deletedFromCameraRoll = value;

    //var picsBox = Hive.box('pics');
    //Pic pic = picsBox.get(photoId);
    var pic = await database.getPhotoByPhotoId(photoId.value);
    //pic.deletedFromCameraRoll = value;
    //pic.save();

    await database.updatePhoto(pic!.copyWith(deletedFromCameraRoll: value));
  }

  //@action
  Future<bool?> setPrivatePath(
      String picPath, String thumbnailPath, String picNonce) async {
    //var secretBox = Hive.box('secrets');
    var secret = Private(
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

    if (UserController.to.shouldDeleteOnPrivate.value == true &&
        entity.value != null) {
      print('**** Deleted original pic!!!');
      if (Platform.isAndroid) {
        await PhotoManager.editor.deleteWithIds([entity.value!.id]);
      } else {
        final result =
            await PhotoManager.editor.deleteWithIds([entity.value!.id]);
        if (result.isEmpty) {
          return false;
        }
      }
      await setDeletedFromCameraRoll(true);
      entity.value = null;
      return null;
    }
    await setDeletedFromCameraRoll(false);
    return null;
  }

  //@action
  Future<void> removePrivatePath() async {
    print('Removing pic from secrets box...');

    //var secretBox = Hive.box('secrets');
    //Secret secretPic = secretBox.get(photoId);
    var secretPic = await database.getPrivateByPhotoId(photoId.value);

    if (secretPic != null) {
      //secretPic.delete();
      await database.deletePrivate(secretPic);
      print('Pic deleted from secrets box!!!');
      return;
    }

    print('Did not find the pic in secretbox');
  }

  Future<void> deleteEncryptedPic({bool copyToCameraRoll = false}) async {
    print('Deleting $photoPath and $thumbPath');

    if (copyToCameraRoll == true && deletedFromCameraRoll == true) {
      print('Pic has entity? ${entity == null ? false : true}');
      var picData = await assetOriginBytes;

      /// TODO: returning is picData is null
      if (null == picData) {
        return;
      }
      final imageEntity = await PhotoManager.editor.saveImage(
        picData,
        title: '',
      );

      /// TODO: what to do if the imageEntity is null ??
      /// doing temporary thing
      if (null == imageEntity) {
        return;
      }
      await changeAssetEntity(imageEntity);
      print('copied image back to gallery with id: ${imageEntity.id}');
    }
    var appDocumentsDir = await getApplicationDocumentsDirectory();

    var photoFile = File(p.join(appDocumentsDir.path, photoPath));
    var thumbFile = File(p.join(appDocumentsDir.path, thumbPath));

    await photoFile.delete();
    await thumbFile.delete();
    print('Removed both files...');
  }

/*   Future<void> loadExifData() async {
    File originFile = await entity.value.originFile;
    var originBytes = originFile.readAsBytesSync();

    var mapResult = md.MetaData.extractXMP(originBytes, raw: true);
    print(mapResult['dc:subject']);
  } */

  //@action
  Future<void> loadPicInfo() async {
    // loadExifData();

    //var picsBox = Hive.box('pics');
    //var secretBox = Hive.box('secrets');
    var pic = await database.getPhotoByPhotoId(photoId.value);
    if (pic != null) {
      print('pic $photoId exists, loading data....');
      //Pic pic = picsBox.get(photoId);

      latitude.value = pic.latitude;
      longitude.value = pic.longitude;
      specificLocation.value = pic.specificLocation;
      generalLocation.value = pic.generalLocation;
      isPrivate.value = pic.isPrivate;
      deletedFromCameraRoll = pic.deletedFromCameraRoll;
      isStarred.value = pic.isStarred;

      print('Is private: $isPrivate');
      if (isPrivate.value == true) {
        var secretPic = await database.getPrivateByPhotoId(photoId.value);

        if (secretPic != null) {
          photoPath = secretPic.path;
          thumbPath = secretPic.thumbPath!;
          nonce = secretPic.nonce;
          print(
              'Setting private path to: $photoPath - Thumb: $thumbPath - Nonce: $nonce');
        }
      }

      for (var tagKey in pic.tags.keys) {
        var tagModel = TagsController.to.allTags[tagKey];
        if (tagModel == null) {
          print('&&&&##### DID NOT FIND TAG: $tagKey');
          continue;
        }
        tags[tagKey] = tagModel;
      }
    }
    /* else {
      print('pic $photoId doesnt exists in database');
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
    print('Pic isPrivate: $value');
    print('Pic Entity Exists: ${entity == null ? false : true}');
    print('Photo Id: $photoId - Entity Id: ${entity.value?.id}');

    //var picsBox = Hive.box('pics');
    var getPic = await database.getPhotoByPhotoId(photoId.value);
    //getPic.isPrivate = value;
    //picsBox.put(photoId, getPic);
    if (getPic != null) {
      await database.updatePhoto(getPic.copyWith(isPrivate: value));
    }
  }

  Future<void> addSecretTagToPic() async {
    await addMultipleTagsToPic(
      acceptedTagKeys: {kSecretTagKey: ''},
    );
    await tagsSuggestionsCalculate();
    print('Added secret tag to pic!');
  }

  Future<void> removeSecretTagFromPic() async {
    await removeMultipleTagFromPic(
        acceptedTags: <String, String>{kSecretTagKey: ''});
    await tagsSuggestionsCalculate();
    print('Added secret tag to pic!');
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
    var tagsBoxKeys = tagsBox.map((e) => e.key).toSet().toList();
    tagsSuggestions.clear();
    searchText.value = searchText.trim();

    if (searchText.value == '') {
      var suggestions = <TagModel>[];
      var suggestionTags = <String>[];
      var tagsKeys = tags.keys.toList();

      for (var recent in UserController.to.recentTags) {
        if (tagsKeys.contains(recent) ||
            suggestionTags.contains(recent) ||
            (PrivatePhotosController.to.showPrivate.value == false &&
                recent == kSecretTagKey)) {
          continue;
        }
        suggestionTags.add(recent);
      }

      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (var tagKey in tagsBoxKeys) {
          if (tagsKeys.contains(tagKey) ||
              suggestionTags.contains(tagKey) ||
              (PrivatePhotosController.to.showPrivate.value == false &&
                  tagKey == kSecretTagKey)) {
            continue;
          }
          suggestionTags.add(tagKey);
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
        }
      }

      for (var tagId in suggestionTags) {
        if (TagsController.to.allTags[tagId] != null) {
          suggestions.add(TagsController.to.allTags[tagId]!.value);
        }
      }

      tagsSuggestions.value = suggestions;
    } else {
      var listOfLetters = searchText.toLowerCase().split('');
      for (var tagKey in tagsBoxKeys) {
        /// check whether it is a kSecretTagKey
        if (tagKey == kSecretTagKey) {
          ///
          /// check whether the secret tag is to be shown or not
          ///
          if (PrivatePhotosController.to.showPrivate.value == false) {
            /// If no then continue
            continue;
          }

          /// come here if the showPrivate is set to True.
          tagsSuggestions.add(TagsController.to.allTags[tagKey]!.value);
          continue;
        }
        var tagName = Helpers.decryptTag(tagKey);
        doCustomisedSearching(
          tagName,
          listOfLetters,
          (matched) {
            if (matched && TagsController.to.allTags[tagKey] != null) {
              tagsSuggestions.add(TagsController.to.allTags[tagKey]!.value);
            }
          },
        );
      }
    }
    print('find suggestions: $searchText');

    return <TagModel>[];
  }

  //@action
  /* Future<void> addTag({required String tagName}) async {
    //var tagsBox = Hive.box('tags');
    /* print(tagsBox.keys); */

    var tagKey = Helpers.encryptTag(tagName);
    print('Adding tag: $tagName');
    final getTag = await database.getLabelByLabelKey(tagKey);

    if (getTag != null) {
      TagsController.to.addTag(
        TagModel(
          key: tagKey,
          title: tagName,
          count: 1,
          time: DateTime.now(),
        ),
      );

      await database.createLabel(Label(
          key: tagKey,
          title: tagName,
          photoId: <String, String>{photoId.value: ''},
          counter: 1,
          lastUsedAt: DateTime.now()));
    }

    print('adding tag to database...');

    await addMultipleTagsToPic(acceptedTagKeys: <String, String>{tagKey: ''});
    await UserController.to.addTagToRecent(tagKey: tagKey);
    await Analytics.sendEvent(
      Event.created_tag,
      params: {'tagName': tagName},
    );
  }
 */

  /// Will remove the photoId from the labels Table
  Future<String> _removePhotoIdFromLabel(
      Map<String, String> selectedTags) async {
    final list = <String>[];
    selectedTags.forEach((tagKey, _) async {
      final getTag = await database.getLabelByLabelKey(tagKey);

      if (getTag != null) {
        list.add(getTag.title);
        getTag.photoId.remove(photoId.value);
        await database.updateLabel(getTag);
      }
    });

    return list.join(', ');
  }

  Photo photoObject(Map<String, String> tagsMap, bool isPrivate) {
    return Photo(
      id: photoId.value,
      createdAt: createdAt,
      originalLatitude: originalLatitude,
      originalLongitude: originalLongitude,
      latitude: null,
      longitude: null,
      specificLocation: null,
      generalLocation: null,
      tags: tagsMap,
      isStarred: false,
      deletedFromCameraRoll: false,
      isPrivate: isPrivate,
    );
  }

  //@action
  Future<void> removeMultipleTagsFromPicsForwadFromTagsController(
      {required Map<String, String> acceptedTagKeys, String? name}) async {
    var getPic = await database.getPhotoByPhotoId(photoId.value);

    if (getPic == null) {
      return;
    }

    if (acceptedTagKeys.isEmpty) {
      print('this tag is already in this picture');
      return;
    }

    getPic.tags.removeWhere((tagKey, _) => acceptedTagKeys[tagKey] != null);
    print('photoId: ${getPic.id} - tags: ${getPic.tags}');
    await database.updatePhoto(getPic);

    if (name != null) {
      await Analytics.sendEvent(
        Event.removed_tag,
        params: {'tagName': name},
      );
    }
  }

  //@action
  Future<void> addMultipleTagsToPic(
      {required Map<String, String> acceptedTagKeys, String? name}) async {
    var getPic = await database.getPhotoByPhotoId(photoId.value);

    if (getPic != null) {
      print('this picture is in db going to update');

      if (acceptedTagKeys.isEmpty) {
        print('this tag is already in this picture');
        return;
      }

      getPic.tags.addAll(acceptedTagKeys);
      print('photoId: ${getPic.id} - tags: ${getPic.tags}');
      await database.updatePhoto(getPic);

      if (name != null) {
        await Analytics.sendEvent(
          Event.added_tag,
          params: {'tagName': name},
        );
      }
      return;
    }

    print('this picture is not in db, adding it...');
    print('Photo Id: $photoId');

    var pic =
        photoObject(acceptedTagKeys, acceptedTagKeys[kSecretTagKey] != null);

    await database.createPhoto(pic);

    if (name != null) {
      await Analytics.sendEvent(
        Event.added_tag,
        params: {'tagName': name},
      );
    }
  }

  Future<String?> _writeByteToImageFile(Uint8List? byteData) async {
    if (byteData == null) {
      return null;
    }
    var tempDir = await getTemporaryDirectory();
    var imageFile = File(
        '${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData);
    return imageFile.path;
  }

  //@action
  Future<void> sharePic() async {
    String? path;

    if (Platform.isAndroid) {
      path = await _writeByteToImageFile(entity.value == null
          ? await assetOriginBytes
          : await entity.value!.originBytes);
    } else {
      if (entity.value == null) {
        var bytes = await assetOriginBytes;
        path = await _writeByteToImageFile(bytes);
      } else {
        var bytes = await entity.value!.thumbnailDataWithSize(ThumbnailSize(
            entity.value!.size.width.toInt(),
            entity.value!.size.height.toInt()));
        path = await _writeByteToImageFile(bytes);
      }
    }

    if (path == '' || path == null) {
      return;
    }

    await Analytics.sendEvent(Event.shared_photo);
    await ShareExtend.share(path, 'image');
  }

  //@action
  Future<bool> deletePic() async {
    print('Before photo manager delete: ${entity.value?.id}');

    /// TODO: Is this I am doing, This I will check once again
    if (entity.value == null) {
      return false;
    }
    if (Platform.isAndroid) {
      await PhotoManager.editor.deleteWithIds([entity.value!.id]);
    } else {
      final result =
          await PhotoManager.editor.deleteWithIds([entity.value!.id]);
      if (result.isEmpty) {
        return false;
      }
    }

    //var picsBox = Hive.box('pics');
    //Pic pic = picsBox.get(photoId);
    var pic = await database.getPhotoByPhotoId(photoId.value);

    if (pic != null) {
      print('pic is in db... removing it from db!');
      var picTags = List<String>.from(pic.tags.keys);
      for (var tagKey in picTags) {
        await removeMultipleTagFromPic(
          acceptedTags: <String, String>{tagKey: ''},
        );

        if (tagKey == kSecretTagKey) {
          await deleteEncryptedPic();
        }
      }
      //picsBox.delete(photoId);
      await database.deletePhotoByPhotoId(photoId.value);
      print('removed $photoId from database');
    }

    return true;
  }

  //@action
  Future<void> removeMultipleTagFromPic(
      {required Map<String, String> acceptedTags}) async {
    var title = await _removePhotoIdFromLabel(acceptedTags);

    var getPic = await database.getPhotoByPhotoId(photoId.value);

    if (getPic != null) {
      getPic.tags.removeWhere((key, _) => acceptedTags[key] != null);
      await database.updatePhoto(getPic);
      tags.removeWhere((key, _) => acceptedTags[key] != null);

      if (acceptedTags[kSecretTagKey] != null) {
        await removePrivatePath();
      }
    }

    await tagsSuggestionsCalculate();

    await Analytics.sendEvent(
      Event.removed_tag,
      params: {'tagName': title},
    );
  }

  //@action
  Future<void> saveLocation(
      {required double lat,
      required double long,
      String? specific,
      String? general}) async {
    //var picsBox = Hive.box('pics');

    //Pic getPic = picsBox.get(photoId);
    var getPic = await database.getPhotoByPhotoId(photoId.value);

    if (getPic != null) {
      print('found pic');

      //getPic.latitude = lat;
      //getPic.longitude = long;
      //getPic.specificLocation = specific;
      //getPic.generalLocation = general;
      //getPic.save();
      await database.updatePhoto(getPic.copyWith(
        latitude: drift.Value(lat),
        longitude: drift.Value(long),
        specificLocation: drift.Value(specific),
        generalLocation: drift.Value(general),
      ));
      print('updated pic with new values');
    } else {
      print('Did not found pic!');
      var createPic = Photo(
        id: photoId.value,
        createdAt: createdAt,
        originalLatitude: originalLatitude,
        originalLongitude: originalLongitude,
        latitude: latitude.value,
        longitude: longitude.value,
        specificLocation: specificLocation.value,
        generalLocation: generalLocation.value,
        tags: <String, String>{},
        isStarred: false,
        isPrivate: false,
        deletedFromCameraRoll: false,
      );
      //picsBox.put(photoId, createPic);
      await database.createPhoto(createPic);
      print('Saved pic to database!');
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

    if (aiTags.value == true) {
      //getAiSuggestions(context);
    }
  }

  //@action
  void setAiTagsLoaded(bool value) => aiTagsLoaded.value = value;

  Future<List<String>> translateTags(
      List<String> tagsText, BuildContext context) async {
    var lang = UserController.to.appLanguage.split('_')[0];
    if (lang == 'pt' || lang == 'es' || lang == 'de' || lang == 'ja') {
      print('Offline translating it...');
      return tagsText
          .map((e) => PredefinedLabels.labelTranslation(e, context))
          .toList();
    }

    final credentials = ServiceAccountCredentials.fromJson(r'''
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

    final SCOPES = [TranslateApi.cloudTranslationScope];
    var translatedStrings = <String>[];

    await clientViaServiceAccount(credentials, SCOPES)
        .then((httpClient) async {
      var translate = TranslateApi(httpClient);
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
      if (translations != null) {
        for (var element in translations) {
          if (element.translatedText != null) {
            // TODO: Removed this to compile
            // translatedStrings.add(Strings.properCase(element.translatedText!));
          }
        }
      }
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
  /* print('Min: $minValue - Max: $maxValue - Mean: $mean'); */
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
    /* print('Input: $input'); */
    //
    // print(input.)
    //
    // final interpreter = await tfl.Interpreter.fromAsset('model.tflite');
    // var output = List(1 * 1000).reshape([1, 1000]);
    //
    // interpreter.run(input, output);
    /* print(output); */
    // interpreter.close();
    /* print('doSomething() executed in ${stopwatch.elapsed}'); */

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(await entity.value.file);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    List<String> tags = [];
    for (ImageLabel label in labels) {
      final String labelText = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print('Label: $labelText - Entity: $entityId - Confidence: $confidence');
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
