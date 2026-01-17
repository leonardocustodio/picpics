// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:googleapis/translate/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/managers/crypto_manager.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/providers/private_photos_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/utils/labels.dart';
import 'package:share_plus/share_plus.dart';

/// Immutable state for a single photo store
class PicStoreState {

  const PicStoreState({
    required this.photoId,
    required this.photoPath, required this.thumbPath, required this.createdAt, this.entity,
    this.isStarred = false,
    this.isPrivate = false,
    this.latitude,
    this.longitude,
    this.specificLocation,
    this.generalLocation,
    this.tags = const {},
    this.searchText = '',
    this.tagsSuggestions = const [],
    this.aiTags = false,
    this.aiTagsLoaded = false,
    this.nonce = '',
    this.originalLatitude,
    this.originalLongitude,
    this.deletedFromCameraRoll = false,
  });
  // Photo identification
  final String photoId;
  final AssetEntity? entity;

  // Photo metadata
  final bool isStarred;
  final bool isPrivate;
  final double? latitude;
  final double? longitude;
  final String? specificLocation;
  final String? generalLocation;

  // Tag management
  final Map<String, TagModel> tags;
  final String searchText;
  final List<TagModel> tagsSuggestions;

  // AI features
  final bool aiTags;
  final bool aiTagsLoaded;

  // File paths (non-reactive fields from original)
  final String photoPath;
  final String thumbPath;
  final String nonce;
  final DateTime createdAt;
  final double? originalLatitude;
  final double? originalLongitude;
  final bool deletedFromCameraRoll;

  PicStoreState copyWith({
    String? photoId,
    AssetEntity? entity,
    bool? isStarred,
    bool? isPrivate,
    double? latitude,
    double? longitude,
    String? specificLocation,
    String? generalLocation,
    Map<String, TagModel>? tags,
    String? searchText,
    List<TagModel>? tagsSuggestions,
    bool? aiTags,
    bool? aiTagsLoaded,
    String? photoPath,
    String? thumbPath,
    String? nonce,
    DateTime? createdAt,
    double? originalLatitude,
    double? originalLongitude,
    bool? deletedFromCameraRoll,
  }) {
    return PicStoreState(
      photoId: photoId ?? this.photoId,
      entity: entity ?? this.entity,
      isStarred: isStarred ?? this.isStarred,
      isPrivate: isPrivate ?? this.isPrivate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      specificLocation: specificLocation ?? this.specificLocation,
      generalLocation: generalLocation ?? this.generalLocation,
      tags: tags ?? this.tags,
      searchText: searchText ?? this.searchText,
      tagsSuggestions: tagsSuggestions ?? this.tagsSuggestions,
      aiTags: aiTags ?? this.aiTags,
      aiTagsLoaded: aiTagsLoaded ?? this.aiTagsLoaded,
      photoPath: photoPath ?? this.photoPath,
      thumbPath: thumbPath ?? this.thumbPath,
      nonce: nonce ?? this.nonce,
      createdAt: createdAt ?? this.createdAt,
      originalLatitude: originalLatitude ?? this.originalLatitude,
      originalLongitude: originalLongitude ?? this.originalLongitude,
      deletedFromCameraRoll: deletedFromCameraRoll ?? this.deletedFromCameraRoll,
    );
  }
}

/// State notifier for managing a single photo's state
class PicStoreNotifier extends StateNotifier<PicStoreState> {

  PicStoreNotifier(
    this.ref, {
    required AssetEntity entityValue,
    required String photoPath,
    required String thumbPath,
    required String photoId,
    required DateTime createdAt,
    double? originalLatitude,
    double? originalLongitude,
    bool deletedFromCameraRoll = false,
  }) : super(PicStoreState(
          photoId: photoId,
          entity: entityValue,
          photoPath: photoPath,
          thumbPath: thumbPath,
          createdAt: createdAt,
          originalLatitude: originalLatitude,
          originalLongitude: originalLongitude,
          deletedFromCameraRoll: deletedFromCameraRoll,
        ),) {
    database = AppDatabase();
    unawaited(_initialize());
  }
  final Ref ref;
  late final AppDatabase database;

  /// Initialize state by loading photo data
  Future<void> _initialize() async {
    await isStar();
    await loadPicInfo();
  }

  /// Get encryption key from pin provider or user controller
  /// TODO(picpics): Migrate UserController to find where encryptionKey is stored
  /// For now, returning null - encryption features will need to be connected
  /// after UserController migration is complete
  cryptography.SecretKey? get _encryptionKey {
    // Original code: UserController.to.encryptionKey
    // Need to find where this is stored after UserController migration
    return null;
  }

  /// Get asset origin bytes (decrypted if needed)
  Future<Uint8List?> get assetOriginBytes async {
    if (_encryptionKey == null) {
      AppLogger.d('Cannot decrypt - encryption key not available');
      return null;
    }
    return Crypto.decryptImage(
      state.photoPath,
      _encryptionKey!,
      hex.decode(state.nonce),
    );
  }

  /// Get asset thumbnail bytes (decrypted if needed)
  Future<Uint8List?> get assetThumbBytes async {
    if (_encryptionKey == null) {
      AppLogger.d('Cannot decrypt - encryption key not available');
      return null;
    }
    return Crypto.decryptImage(
      state.thumbPath,
      _encryptionKey!,
      hex.decode(state.nonce),
    );
  }

  /// Check if photo is starred
  Future<bool> isStar() async {
    final photo = await database.getPhotoByPhotoId(state.photoId);
    final starred = photo?.isStarred ?? false;
    state = state.copyWith(isStarred: starred);
    return starred;
  }

  /// Toggle starred status
  Future<void> switchIsStarred() async {
    final newValue = !state.isStarred;
    state = state.copyWith(isStarred: newValue);

    final pic = await database.getPhotoByPhotoId(state.photoId);
    if (pic != null) {
      await database.updatePhoto(pic.copyWith(isStarred: newValue));
    }
  }

  /// Change the current photo ID
  Future<void> setChangePhotoId(String newPhotoId) async {
    state = state.copyWith(photoId: newPhotoId);
  }

  /// Change the asset entity
  Future<void> changeAssetEntity(AssetEntity? newEntity) async {
    state = state.copyWith(entity: newEntity);
  }

  /// Set deleted from camera roll status
  Future<void> setDeletedFromCameraRoll({required bool value}) async {
    final pic = await database.getPhotoByPhotoId(state.photoId);
    if (pic != null) {
      await database.updatePhoto(pic.copyWith(deletedFromCameraRoll: value));
    }
    state = state.copyWith(deletedFromCameraRoll: value);
  }

  /// Set private path for encrypted photo
  Future<bool?> setPrivatePath(
    String picPath,
    String thumbnailPath,
    String picNonce,
  ) async {
    final secret = Private(
      id: state.photoId,
      path: picPath,
      thumbPath: thumbnailPath,
      originalLatitude: state.originalLatitude,
      originalLongitude: state.originalLongitude,
      createDateTime: state.createdAt,
      nonce: picNonce,
    );

    await database.updatePrivate(secret);

    // Update state with new paths
    state = state.copyWith(
      photoPath: picPath,
      thumbPath: thumbnailPath,
      nonce: picNonce,
    );

    // Check if should delete original
    final userState = ref.read(userProvider);
    if (userState.shouldDeleteOnPrivate && state.entity != null) {
      AppLogger.d('**** Deleted original pic!!!');
      if (Platform.isAndroid) {
        await PhotoManager.editor.deleteWithIds([state.entity!.id]);
      } else {
        final result = await PhotoManager.editor.deleteWithIds([state.entity!.id]);
        if (result.isEmpty) {
          return false;
        }
      }
      await setDeletedFromCameraRoll(value: true);
      state = state.copyWith();
      return null;
    }
    await setDeletedFromCameraRoll(value: false);
    return null;
  }

  /// Remove private path
  Future<void> removePrivatePath() async {
    AppLogger.d('Removing pic from secrets box...');

    final secretPic = await database.getPrivateByPhotoId(state.photoId);

    if (secretPic != null) {
      await database.deletePrivate(secretPic);
      AppLogger.d('Pic deleted from secrets box!!!');
      return;
    }

    AppLogger.d('Did not find the pic in secretbox');
  }

  /// Delete encrypted photo files
  Future<void> deleteEncryptedPic({bool copyToCameraRoll = false}) async {
    AppLogger.d('Deleting ${state.photoPath} and ${state.thumbPath}');

    if (copyToCameraRoll && state.deletedFromCameraRoll) {
      AppLogger.d('Pic has entity? ${true}');
      final picData = await assetOriginBytes;

      if (picData == null) {
        return;
      }

      final imageEntity = await PhotoManager.editor.saveImage(
        picData,
        title: '',
        filename: 'picpics_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await changeAssetEntity(imageEntity);
      AppLogger.d('copied image back to gallery with id: ${imageEntity.id}');
    }

    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final photoFile = File(p.join(appDocumentsDir.path, state.photoPath));
    final thumbFile = File(p.join(appDocumentsDir.path, state.thumbPath));

    await photoFile.delete();
    await thumbFile.delete();
    AppLogger.d('Removed both files...');
  }

  /// Load photo information from database
  Future<void> loadPicInfo() async {
    final pic = await database.getPhotoByPhotoId(state.photoId);
    if (pic == null) return;

    AppLogger.d('pic ${state.photoId} exists, loading data....');

    // Load basic photo data
    state = state.copyWith(
      latitude: pic.latitude,
      longitude: pic.longitude,
      specificLocation: pic.specificLocation,
      generalLocation: pic.generalLocation,
      isPrivate: pic.isPrivate,
      deletedFromCameraRoll: pic.deletedFromCameraRoll,
      isStarred: pic.isStarred,
    );

    AppLogger.d('Is private: ${state.isPrivate}');

    // Load private photo paths if needed
    if (state.isPrivate) {
      final secretPic = await database.getPrivateByPhotoId(state.photoId);

      if (secretPic != null) {
        state = state.copyWith(
          photoPath: secretPic.path,
          thumbPath: secretPic.thumbPath ?? state.thumbPath,
          nonce: secretPic.nonce,
        );
        AppLogger.d(
          'Setting private path to: ${state.photoPath} - Thumb: ${state.thumbPath} - Nonce: ${state.nonce}',
        );
      }
    }

    // Load tags
    final tagsMap = <String, TagModel>{};
    final allTags = ref.read(tagsProvider).allTags;

    for (final tagKey in pic.tags.keys) {
      final tagModel = allTags[tagKey];
      if (tagModel == null) {
        AppLogger.d('&&&&##### DID NOT FIND TAG: $tagKey');
        continue;
      }
      tagsMap[tagKey] = tagModel;
    }

    state = state.copyWith(tags: tagsMap);
  }

  /// Set private status
  Future<void> setIsPrivate({required bool value}) async {
    if (value) {
      await addSecretTagToPic();
    } else {
      await removeSecretTagFromPic();
      await deleteEncryptedPic(copyToCameraRoll: true);
    }

    state = state.copyWith(isPrivate: value);
    AppLogger.d('Pic isPrivate: $value');
    AppLogger.d('Pic Entity Exists: ${true}');
    AppLogger.d('Photo Id: ${state.photoId} - Entity Id: ${state.entity?.id}');

    final getPic = await database.getPhotoByPhotoId(state.photoId);
    if (getPic != null) {
      await database.updatePhoto(getPic.copyWith(isPrivate: value));
    }
  }

  /// Add secret tag to photo
  Future<void> addSecretTagToPic() async {
    await addMultipleTagsToPic(
      acceptedTagKeys: {kSecretTagKey: ''},
    );
    await tagsSuggestionsCalculate();
    AppLogger.d('Added secret tag to pic!');
  }

  /// Remove secret tag from photo
  Future<void> removeSecretTagFromPic() async {
    await removeMultipleTagFromPic(
      acceptedTags: <String, String>{kSecretTagKey: ''},
    );
    await tagsSuggestionsCalculate();
    AppLogger.d('Removed secret tag from pic!');
  }

  /// Set search text for tag suggestions
  void setSearchText(String value) {
    state = state.copyWith(searchText: value.trim());
    setAiTags(value: false);
    unawaited(tagsSuggestionsCalculate());
  }

  /// Calculate tag suggestions based on search text
  Future<List<TagModel>> tagsSuggestionsCalculate() async {
    final tagsBox = await database.getAllLabel();
    final tagsBoxKeys = tagsBox.map((e) => e.key).toSet().toList();
    final suggestions = <TagModel>[];

    if (state.searchText.isEmpty) {
      // Show recent tags when no search
      final suggestionTags = <String>[];
      final tagsKeys = state.tags.keys.toList();
      final recentTags = ref.read(userProvider).recentTags;
      final showPrivate = ref.read(privatePhotosProvider).showPrivate;

      for (final recent in recentTags) {
        if (tagsKeys.contains(recent) || suggestionTags.contains(recent) || (!showPrivate && recent == kSecretTagKey)) {
          continue;
        }
        suggestionTags.add(recent);
      }

      if (suggestionTags.length < kMaxNumOfSuggestions) {
        for (final tagKey in tagsBoxKeys) {
          if (tagsKeys.contains(tagKey) ||
              suggestionTags.contains(tagKey) ||
              (!showPrivate && tagKey == kSecretTagKey)) {
            continue;
          }
          suggestionTags.add(tagKey);
          if (suggestionTags.length == kMaxNumOfSuggestions) {
            break;
          }
        }
      }

      final allTags = ref.read(tagsProvider).allTags;
      for (final tagId in suggestionTags) {
        if (allTags[tagId] != null) {
          suggestions.add(allTags[tagId]!);
        }
      }

      state = state.copyWith(tagsSuggestions: suggestions);
    } else {
      // Search through tags
      final listOfLetters = state.searchText.toLowerCase().split('');
      final showPrivate = ref.read(privatePhotosProvider).showPrivate;
      final allTags = ref.read(tagsProvider).allTags;

      for (final tagKey in tagsBoxKeys) {
        // Check if secret tag
        if (tagKey == kSecretTagKey) {
          if (!showPrivate) {
            continue;
          }
          if (allTags[tagKey] != null) {
            suggestions.add(allTags[tagKey]!);
          }
          continue;
        }

        final tagName = Helpers.decryptTag(tagKey);
        doCustomisedSearching(
          tagName,
          listOfLetters,
          ({required bool matched}) {
            if (matched && allTags[tagKey] != null) {
              suggestions.add(allTags[tagKey]!);
            }
          },
        );
      }

      state = state.copyWith(tagsSuggestions: suggestions);
    }

    AppLogger.d('find suggestions: ${state.searchText}');
    return suggestions;
  }

  /// Remove photo ID from label
  Future<String> _removePhotoIdFromLabel(Map<String, String> selectedTags) async {
    final list = <String>[];
    for (final entry in selectedTags.entries) {
      final getTag = await database.getLabelByLabelKey(entry.key);

      if (getTag != null) {
        list.add(getTag.title);
        getTag.photoId.remove(state.photoId);
        await database.updateLabel(getTag);
      }
    }

    return list.join(', ');
  }

  /// Create photo object
  Photo photoObject(Map<String, String> tagsMap, {required bool isPrivate}) {
    return Photo(
      id: state.photoId,
      createdAt: state.createdAt,
      originalLatitude: state.originalLatitude,
      originalLongitude: state.originalLongitude,
      tags: tagsMap,
      isStarred: false,
      deletedFromCameraRoll: false,
      isPrivate: isPrivate,
    );
  }

  /// Remove multiple tags from pic (called from TagsController)
  Future<void> removeMultipleTagsFromPicsForwardFromTagsController({
    required Map<String, String> acceptedTagKeys,
    String? name,
  }) async {
    final getPic = await database.getPhotoByPhotoId(state.photoId);

    if (getPic == null) {
      return;
    }

    if (acceptedTagKeys.isEmpty) {
      AppLogger.d('this tag is already in this picture');
      return;
    }

    getPic.tags.removeWhere((tagKey, _) => acceptedTagKeys[tagKey] != null);
    AppLogger.d('photoId: ${getPic.id} - tags: ${getPic.tags}');
    await database.updatePhoto(getPic);

    if (name != null) {
      await Analytics.sendEvent(
        Event.removed_tag,
        params: {'tagName': name},
      );
    }
  }

  /// Add multiple tags to pic
  Future<void> addMultipleTagsToPic({
    required Map<String, String> acceptedTagKeys,
    String? name,
  }) async {
    final getPic = await database.getPhotoByPhotoId(state.photoId);

    if (getPic != null) {
      AppLogger.d('this picture is in db going to update');

      if (acceptedTagKeys.isEmpty) {
        AppLogger.d('this tag is already in this picture');
        return;
      }

      getPic.tags.addAll(acceptedTagKeys);
      AppLogger.d('photoId: ${getPic.id} - tags: ${getPic.tags}');
      await database.updatePhoto(getPic);

      if (name != null) {
        await Analytics.sendEvent(
          Event.added_tag,
          params: {'tagName': name},
        );
      }
      return;
    }

    AppLogger.d('this picture is not in db, adding it...');
    AppLogger.d('Photo Id: ${state.photoId}');

    final pic = photoObject(acceptedTagKeys, isPrivate: acceptedTagKeys[kSecretTagKey] != null);

    await database.createPhoto(pic);

    if (name != null) {
      await Analytics.sendEvent(
        Event.added_tag,
        params: {'tagName': name},
      );
    }
  }

  /// Write bytes to temp image file
  Future<String?> _writeByteToImageFile(Uint8List? byteData) async {
    if (byteData == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    final imageFile = File(
      '${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg',
    )
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteData);
    return imageFile.path;
  }

  /// Share photo
  Future<void> sharePic() async {
    String? path;

    if (Platform.isAndroid) {
      path =
          await _writeByteToImageFile(state.entity == null ? await assetOriginBytes : await state.entity!.originBytes);
    } else {
      if (state.entity == null) {
        final bytes = await assetOriginBytes;
        path = await _writeByteToImageFile(bytes);
      } else {
        final bytes = await state.entity!.thumbnailDataWithSize(
          ThumbnailSize(
            state.entity!.size.width.toInt(),
            state.entity!.size.height.toInt(),
          ),
        );
        path = await _writeByteToImageFile(bytes);
      }
    }

    if (path == '' || path == null) {
      return;
    }

    await Analytics.sendEvent(Event.shared_photo);
    await Share.shareXFiles([XFile(path)]);
  }

  /// Delete photo
  Future<bool> deletePic() async {
    AppLogger.d('Before photo manager delete: ${state.entity?.id}');

    if (state.entity == null) {
      return false;
    }

    if (Platform.isAndroid) {
      await PhotoManager.editor.deleteWithIds([state.entity!.id]);
    } else {
      final result = await PhotoManager.editor.deleteWithIds([state.entity!.id]);
      if (result.isEmpty) {
        return false;
      }
    }

    final pic = await database.getPhotoByPhotoId(state.photoId);

    if (pic != null) {
      AppLogger.d('pic is in db... removing it from db!');
      final picTags = List<String>.from(pic.tags.keys);
      for (final tagKey in picTags) {
        await removeMultipleTagFromPic(
          acceptedTags: <String, String>{tagKey: ''},
        );

        if (tagKey == kSecretTagKey) {
          await deleteEncryptedPic();
        }
      }
      await database.deletePhotoByPhotoId(state.photoId);
      AppLogger.d('removed ${state.photoId} from database');
    }

    return true;
  }

  /// Remove multiple tags from pic
  Future<void> removeMultipleTagFromPic({
    required Map<String, String> acceptedTags,
  }) async {
    final title = await _removePhotoIdFromLabel(acceptedTags);

    final getPic = await database.getPhotoByPhotoId(state.photoId);

    if (getPic != null) {
      getPic.tags.removeWhere((key, _) => acceptedTags[key] != null);
      await database.updatePhoto(getPic);

      // Update local tags state
      final updatedTags = Map<String, TagModel>.from(state.tags)
        ..removeWhere((key, _) => acceptedTags[key] != null);
      state = state.copyWith(tags: updatedTags);

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

  /// Save location information
  Future<void> saveLocation({
    required double lat,
    required double long,
    String? specific,
    String? general,
  }) async {
    final getPic = await database.getPhotoByPhotoId(state.photoId);

    if (getPic != null) {
      AppLogger.d('found pic');

      await database.updatePhoto(
        getPic.copyWith(
          latitude: drift.Value(lat),
          longitude: drift.Value(long),
          specificLocation: drift.Value(specific),
          generalLocation: drift.Value(general),
        ),
      );
      AppLogger.d('updated pic with new values');
    } else {
      AppLogger.d('Did not found pic!');
      final createPic = Photo(
        id: state.photoId,
        createdAt: state.createdAt,
        originalLatitude: state.originalLatitude,
        originalLongitude: state.originalLongitude,
        latitude: lat,
        longitude: long,
        specificLocation: specific,
        generalLocation: general,
        tags: <String, String>{},
        isStarred: false,
        isPrivate: false,
        deletedFromCameraRoll: false,
      );
      await database.createPhoto(createPic);
      AppLogger.d('Saved pic to database!');
    }

    state = state.copyWith(
      latitude: lat,
      longitude: long,
      specificLocation: specific,
      generalLocation: general,
    );
  }

  /// Set AI tags mode
  void setAiTags({required bool value}) {
    state = state.copyWith(aiTags: value);
  }

  /// Switch AI tags mode
  void switchAiTags() {
    state = state.copyWith(aiTags: !state.aiTags);
  }

  /// Set AI tags loaded status
  void setAiTagsLoaded({required bool value}) {
    state = state.copyWith(aiTagsLoaded: value);
  }

  /// Translate tags to user's language
  /// Note: This method requires BuildContext, so it should be called from widget layer
  /// TODO(picpics): Consider refactoring to avoid BuildContext dependency
  Future<List<String>> translateTags(
    List<String> tagsText,
    WidgetRef widgetRef,
  ) async {
    final lang = ref.read(userProvider).appLanguage.split('_')[0];
    if (lang == 'pt' || lang == 'es' || lang == 'de' || lang == 'ja') {
      AppLogger.d('Offline translating it...');
      return tagsText.map((e) => PredefinedLabels.labelTranslation(e, widgetRef)).toList();
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

    const scopes = [TranslateApi.cloudTranslationScope];
    final translatedStrings = <String>[];

    await clientViaServiceAccount(credentials, scopes).then((httpClient) async {
      final translate = TranslateApi(httpClient);
      final request = TranslateTextRequest()
        ..contents = tagsText
        ..mimeType = 'text/plain'
        ..sourceLanguageCode = 'en-US'
        ..targetLanguageCode = ref.read(userProvider).appLanguage.replaceAll('_', '-')
        ..model = 'projects/picpics/locations/global/models/general/nmt';

      final response = await translate.projects.translateText(request, 'projects/picpics');
      final translations = response.translations;
      if (translations != null) {
        for (final element in translations) {
          if (element.translatedText != null) {
            translatedStrings.add(element.translatedText!);
          }
        }
      }
    });

    return translatedStrings;
  }
}

// Note: PicStore instances are managed by tabs_provider in a picStoreMap
// This provider declaration is for reference but instances are created directly
final StateNotifierProviderFamily<PicStoreNotifier, PicStoreState, String> picStoreProvider = StateNotifierProvider.family<PicStoreNotifier, PicStoreState, String>(
  (ref, photoId) {
    throw UnimplementedError(
      'PicStore instances should be created via tabs_provider.explorPicStore()',
    );
  },
);
