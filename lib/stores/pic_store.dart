import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/secret.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/labels.dart';
import 'package:share_extend/share_extend.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:googleapis/translate/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:strings/strings.dart';
import 'package:path/path.dart' as p;
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// import 'package:image/image.dart' as img;
import 'package:metadata/metadata.dart' as md;
// import 'package:exif/exif.dart';
// import 'package:edit_exif/edit_exif.dart';
// import 'package:psd_sdk/psd_sdk.dart' as psd;
// import 'package:tflite/tflite.dart';
import 'dart:convert';

part 'pic_store.g.dart';

class PicStore = _PicStore with _$PicStore;

abstract class _PicStore with Store {
  final AppStore appStore;
  final DateTime createdAt;
  final double originalLatitude;
  final double originalLongitude;

  _PicStore({
    this.appStore,
    this.entity,
    this.photoPath,
    this.thumbPath,
    this.photoId,
    this.createdAt,
    this.originalLatitude,
    this.originalLongitude,
    this.deletedFromCameraRoll,
    this.isStarred,
  }) {
    // print('loading pic info......');
    loadPicInfo();

    autorun((_) {});
  }

  @observable
  bool isStarred;

  @action
  Future<void> setIsStarred(bool value) async {
    var picsBox = Hive.box('pics');
    Pic pic = picsBox.get(photoId);
    pic.isStarred = value;

    if (value == true) {
      var bytes = await assetOriginBytes;
      String encoded = base64.encode(bytes);
      pic.base64encoded = encoded;
      appStore.addToStarredPhotos(photoId);
    } else {
      pic.base64encoded = null;
      appStore.removeFromStarredPhotos(photoId);
    }

    pic.save();
    isStarred = value;
  }

  @observable
  String photoId;

  @action
  void setChangePhotoId(String value) {
    var tagsBox = Hive.box('tags');

    for (String tagsKeys in tagsKeys) {
      Tag getTag = tagsBox.get(tagsKeys);

      getTag.photoId.remove(photoId);
      getTag.photoId.add(value);
      print('Replaced tag in ${getTag.name} tagsbox');
      getTag.save();
    }

    photoId = value;
  }

  @observable
  AssetEntity entity;

  @action
  void changeAssetEntity(AssetEntity picEntity) {
    print('Changing asset entity of $photoId to ${picEntity.id}');

    var picsBox = Hive.box('pics');
    Pic picOld = picsBox.get(photoId);

    if (picOld != null) {
      Pic createPic = Pic(
        photoId: picEntity.id,
        createdAt: picOld.createdAt,
        originalLatitude: picOld.originalLatitude,
        originalLongitude: picOld.originalLongitude,
        latitude: picOld.latitude,
        longitude: picOld.longitude,
        specificLocation: picOld.specificLocation,
        generalLocation: picOld.generalLocation,
        tags: picOld.tags,
      );
      picsBox.put(picEntity.id, createPic);
      picOld.delete();
    }

    entity = picEntity;
    setChangePhotoId(picEntity.id);
    print('Changed asset entity');
  }

  Future<Uint8List> get assetOriginBytes async {
    if (isPrivate == false && entity != null) {
      return await entity.originBytes;
    }
    print('Returning decrypt image in privatePath: $photoPath');
    return await Crypto.decryptImage(photoPath, appStore.encryptionKey, Nonce(hex.decode(nonce)));
  }

  Future<Uint8List> get assetThumbBytes async {
    if (isPrivate == false && entity != null) {
      return await entity.thumbDataWithSize(kDefaultPreviewThumbSize[0], kDefaultPreviewThumbSize[1]);
    }
    print('Returning decrypt image in privatePath: $thumbPath');
    return await Crypto.decryptImage(thumbPath, appStore.encryptionKey, Nonce(hex.decode(nonce)));
  }

  String photoPath;
  String thumbPath;
  bool deletedFromCameraRoll;

  void setDeletedFromCameraRoll(bool value) {
    print('Setting deleted from camera roll as $value');
    deletedFromCameraRoll = value;

    var picsBox = Hive.box('pics');
    Pic pic = picsBox.get(photoId);
    pic.deletedFromCameraRoll = value;
    pic.save();
  }

  @action
  Future<void> setPrivatePath(String picPath, String thumbnailPath, String picNonce) async {
    var secretBox = Hive.box('secrets');
    Secret secret = Secret(
      photoId: photoId,
      photoPath: picPath,
      thumbPath: thumbnailPath,
      originalLatitude: originalLatitude,
      originalLongitude: originalLongitude,
      createDateTime: createdAt,
      nonce: picNonce,
    );
    secretBox.put(photoId, secret);
    photoPath = picPath;
    thumbPath = thumbnailPath;
    nonce = picNonce;

    if (appStore.shouldDeleteOnPrivate == true) {
      print('**** Deleted original pic!!!');
      if (Platform.isAndroid) {
        PhotoManager.editor.deleteWithIds([entity.id]);
      } else {
        final List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
        if (result.isEmpty) {
          return false;
        }
      }
      setDeletedFromCameraRoll(true);
      entity = null;
      return;
    }
    setDeletedFromCameraRoll(false);
  }

  @action
  Future<void> removePrivatePath() async {
    print('Removing pic from secrets box...');

    var secretBox = Hive.box('secrets');
    Secret secretPic = secretBox.get(photoId);

    if (secretPic != null) {
      secretPic.delete();
      print('Pic deleted from secrets box!!!');
      return;
    }

    print('Did not find the pic in secretbox');
  }

  Future<void> deleteEncryptedPic({bool copyToCameraRoll = false}) async {
    print('Deleting $photoPath and $thumbPath');
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    File photoFile = File(p.join(appDocumentsDir.path, photoPath));
    File thumbFile = File(p.join(appDocumentsDir.path, thumbPath));

    if (copyToCameraRoll == true && deletedFromCameraRoll == true) {
      print('Pic has entity? ${entity == null ? false : true}');
      Uint8List picData = await assetOriginBytes;
      final AssetEntity imageEntity = await PhotoManager.editor.saveImage(picData);
      changeAssetEntity(imageEntity);
      print('copied image back to gallery with id: ${imageEntity.id}');
    }

    photoFile.delete();
    thumbFile.delete();
    print('Removed both files...');
  }

  Future<void> loadExifData() async {
    File originFile = await entity.originFile;
    var originBytes = originFile.readAsBytesSync();

    var mapResult = md.MetaData.extractXMP(originBytes, raw: true);
    print(mapResult['dc:subject']);
  }

  @action
  void loadPicInfo() {
    // loadExifData();

    var picsBox = Hive.box('pics');
    var secretBox = Hive.box('secrets');

    if (picsBox.containsKey(photoId)) {
      // print('pic $photoId exists, loading data....');
      Pic pic = picsBox.get(photoId);

      latitude = pic.latitude;
      longitude = pic.longitude;
      specificLocation = pic.specificLocation;
      generalLocation = pic.generalLocation;
      isPrivate = pic.isPrivate;
      deletedFromCameraRoll = pic.deletedFromCameraRoll ?? false;

      print('Is private: $isPrivate');
      if (isPrivate == true) {
        Secret secretPic = secretBox.get(photoId);

        if (secretPic != null) {
          photoPath = secretPic.photoPath;
          thumbPath = secretPic.thumbPath;
          nonce = secretPic.nonce;
          print('Setting private path to: $photoPath - Thumb: $thumbPath - Nonce: $nonce');
        }
      }

      for (String tagKey in pic.tags) {
        TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == tagKey, orElse: () => null);
        if (tagsStore == null) {
          print('&&&&##### DID NOT FIND TAG: ${tagKey}');
          continue;
        }
        tags.add(tagsStore);
      }
    } else {
      // print('pic $photoId doesnt exists in database');
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

  String nonce;

  @observable
  bool isPrivate = false;

  @action
  Future<void> setIsPrivate(bool value) async {
    if (value) {
      await addSecretTagToPic();
    } else {
      await removeSecretTagFromPic();
      await deleteEncryptedPic(copyToCameraRoll: true);
    }

    isPrivate = value;
    print('Pic isPrivate: $value');
    print('Pic Entity Exists: ${entity == null ? false : true}');
    print('Photo Id: ${photoId} - Entity Id: ${entity != null ? entity.id : null}');

    var picsBox = Hive.box('pics');
    Pic getPic = picsBox.get(photoId);
    getPic.isPrivate = value;
    picsBox.put(photoId, getPic);
  }

  Future<void> addSecretTagToPic() async {
    var tagsBox = Hive.box('tags');
    Tag getTag = tagsBox.get(kSecretTagKey);

    if (getTag.photoId.contains(photoId)) {
      print('this tag is already in this picture');
      return;
    }

    getTag.photoId.add(photoId);
    tagsBox.put(kSecretTagKey, getTag);

    await addTagToPic(
      tagKey: kSecretTagKey,
      photoId: photoId,
    );
    print('Added secret tag to pic!');
  }

  Future<void> removeSecretTagFromPic() async {
    await removeTagFromPic(tagKey: kSecretTagKey);
    print('Added secret tag to pic!');
  }

  @observable
  String searchText = '';

  @action
  void setSearchText(String value) {
    searchText = value;
    aiTags = false;
  }

  ObservableList<TagsStore> tags = ObservableList<TagsStore>();

  @computed
  List<String> get tagsKeys {
    print('####!!!! Tags Keys: $tags');
    return tags.map((element) => element.id).toList();
  }

  @computed
  List<TagsStore> get tagsSuggestions {
    var tagsBox = Hive.box('tags');
    List<String> suggestionTags = [];

    if (searchText == '') {
      for (var recent in appStore.recentTags) {
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
          if (tagsKeys.contains(tagKey) || suggestionTags.contains(tagKey) || tagKey == kSecretTagKey) {
            continue;
          }
          suggestionTags.add(tagKey);
        }
      }
//      }
    } else {
      for (var tagKey in tagsBox.keys) {
        if (tagKey == kSecretTagKey) continue;

        String tagName = Helpers.decryptTag(tagKey);
        if (tagName.startsWith(Helpers.stripTag(searchText))) {
          suggestionTags.add(tagKey);
        }
      }
    }
    print('find suggestions: $searchText - exclude: $tagsKeys');
    print(suggestionTags);

    List<TagsStore> suggestions = [];
    for (String tagId in suggestionTags) {
      suggestions.add(appStore.tags.firstWhere((element) => element.id == tagId));
    }
    return suggestions;
  }

  @action
  Future<void> addTag({String tagName}) async {
    var tagsBox = Hive.box('tags');
    print(tagsBox.keys);

    String tagKey = Helpers.encryptTag(tagName);
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
      );

      appStore.addTagToRecent(tagKey: tagKey);
      print('updated pictures in tag');
      print('Tag photos ids: ${getTag.photoId}');
      return;
    }

    Analytics.sendEvent(
      Event.created_tag,
      params: {'tagName': tagName},
    );
    print('adding tag to database...');
    TagsStore tagsStore = TagsStore(id: tagKey, name: tagName);
    appStore.addTag(tagsStore);

    tagsBox.put(tagKey, Tag(tagName, [photoId]));
    await addTagToPic(
      tagKey: tagKey,
      photoId: photoId,
    );
    appStore.addTagToRecent(tagKey: tagKey);
  }

  @action
  Future<void> addTagToPic({String tagKey, String tagNameX, String photoId, List<AssetEntity> entities}) async {
    var picsBox = Hive.box('pics');

    if (picsBox.containsKey(photoId)) {
      print('this picture is in db going to update');

      Pic getPic = picsBox.get(photoId);

      if (getPic.tags.contains(tagKey)) {
        print('this tag is already in this picture');
        return;
      }

      getPic.tags.add(tagKey);
      print('photoId: ${getPic.photoId} - tags: ${getPic.tags}');
      picsBox.put(photoId, getPic);
      print('updated picture');

      TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == tagKey);

      tags.add(tagsStore);

      Analytics.sendEvent(
        Event.added_tag,
        params: {'tagName': tagsStore.name},
      );
      return;
    }

    print('this picture is not in db, adding it...');
    print('Photo Id: $photoId');

    TagsStore tagsStore = appStore.tags.firstWhere((element) => element.id == tagKey);
    tags.add(tagsStore);

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
      isPrivate: tagKey == kSecretTagKey ? true : false,
    );

    await picsBox.put(photoId, pic);
    print('@@@@@@@@ tagsKey: ${tagKey}');

    // Increase today tagged pics everytime it adds a new pic to database.
    appStore.increaseTodayTaggedPics();
    Analytics.sendEvent(
      Event.added_tag,
      params: {'tagName': tagsStore.name},
    );
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
      path = await _writeByteToImageFile(entity == null ? await assetOriginBytes : await entity.originBytes);
    } else {
      if (entity == null) {
        var bytes = await assetOriginBytes;
        path = await _writeByteToImageFile(bytes);
      } else {
        var bytes = await entity.thumbDataWithSize(
          entity.size.width.toInt(),
          entity.size.height.toInt(),
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

  @action
  Future<bool> deletePic() async {
    print('Before photo manager delete: ${entity.id}');

    if (Platform.isAndroid) {
      PhotoManager.editor.deleteWithIds([entity.id]);
    } else {
      final List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
      if (result.isEmpty) {
        return false;
      }
    }

    var picsBox = Hive.box('pics');
    Pic pic = picsBox.get(photoId);

    if (pic != null) {
      print('pic is in db... removing it from db!');
      List<String> picTags = List.of(pic.tags);
      for (String tagKey in picTags) {
        removeTagFromPic(tagKey: tagKey);

        if (tagKey == kSecretTagKey) {
          deleteEncryptedPic();
        }
      }
      picsBox.delete(photoId);
      print('removed ${photoId} from database');
    }

    return true;
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

    if (tagKey == kSecretTagKey) {
      removePrivatePath();
    }

    Analytics.sendEvent(
      Event.removed_tag,
      params: {'tagName': getTag.name},
    );
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

  @observable
  bool aiTags = false;

  @action
  void setAiTags(bool value) => aiTags = value;

  @action
  void switchAiTags(BuildContext context) {
    aiTags = !aiTags;

    if (aiTags == true) {
      getAiSuggestions(context);
    }
  }

  List<TagsStore> aiSuggestions = [];

  @observable
  bool aiTagsLoaded = false;

  @action
  void setAiTagsLoaded(bool value) => aiTagsLoaded = value;

  Future<List<String>> translateTags(List<String> tagsText, BuildContext context) async {
    if (appStore.appLanguage.split('_')[0] == 'pt' ||
        appStore.appLanguage.split('_')[0] == 'es' ||
        appStore.appLanguage.split('_')[0] == 'de' ||
        appStore.appLanguage.split('_')[0] == 'ja') {
      print('Offline translating it...');
      return tagsText.map((e) => Labels.labelTranslation(e, context)).toList();
    }

    final _credentials = new ServiceAccountCredentials.fromJson(r'''
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

    await clientViaServiceAccount(_credentials, _SCOPES).then((http_client) async {
      var translate = TranslateApi(http_client);
      var request = TranslateTextRequest();
      request.contents = tagsText;
      request.mimeType = 'text/plain';
      request.sourceLanguageCode = 'en-US';
      request.targetLanguageCode = appStore.appLanguage.replaceAll('_', '-');
      request.model = 'projects/picpics/locations/global/models/general/nmt';

      var response = await translate.projects.translateText(request, 'projects/picpics');
      var translations = response.translations;
      translatedStrings = translations.map((e) => capitalize(e.translatedText)).toList();
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
  //   print('Min: $minValue - Max: $maxValue - Mean: $mean');
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

  @action
  Future<void> getAiSuggestions(BuildContext context) async {
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
    // print('Input: $input');
    //
    // // print(input.)
    //
    // final interpreter = await tfl.Interpreter.fromAsset('model.tflite');
    // var output = List(1 * 1000).reshape([1, 1000]);
    //
    // interpreter.run(input, output);
    // print(output);
    // interpreter.close();
    // print('doSomething() executed in ${stopwatch.elapsed}');

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(await entity.file);
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

    List<String> translatedTags = appStore.appLanguage.split('_')[0] != 'en' ? await translateTags(tags, context) : tags;

    for (String translated in translatedTags) {
      String tagKey = Helpers.encryptTag(translated);
      TagsStore tagStore = appStore.tags.firstWhere((element) => element.id == tagKey, orElse: () => null);
      if (tagStore == null) {
        tagStore = TagsStore(
          id: tagKey,
          name: translated,
        );
      }
      aiSuggestions.add(tagStore);
    }
    aiTagsLoaded = true;
    labeler.close();
  }
}
