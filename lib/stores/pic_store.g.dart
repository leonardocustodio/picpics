// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pic_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PicStore on _PicStore, Store {
  Computed<List<String>> _$tagsKeysComputed;

  @override
  List<String> get tagsKeys =>
      (_$tagsKeysComputed ??= Computed<List<String>>(() => super.tagsKeys,
              name: '_PicStore.tagsKeys'))
          .value;
  Computed<Future<List<TagsStore>>> _$tagsSuggestionsComputed;

  @override
  Future<List<TagsStore>> get tagsSuggestions => (_$tagsSuggestionsComputed ??=
          Computed<Future<List<TagsStore>>>(() => super.tagsSuggestions,
              name: '_PicStore.tagsSuggestions'))
      .value;

  final _$isStarredAtom = Atom(name: '_PicStore.isStarred');

  @override
  bool get isStarred {
    _$isStarredAtom.reportRead();
    return super.isStarred;
  }

  @override
  set isStarred(bool value) {
    _$isStarredAtom.reportWrite(value, super.isStarred, () {
      super.isStarred = value;
    });
  }

  final _$photoIdAtom = Atom(name: '_PicStore.photoId');

  @override
  String get photoId {
    _$photoIdAtom.reportRead();
    return super.photoId;
  }

  @override
  set photoId(String value) {
    _$photoIdAtom.reportWrite(value, super.photoId, () {
      super.photoId = value;
    });
  }

  final _$entityAtom = Atom(name: '_PicStore.entity');

  @override
  AssetEntity get entity {
    _$entityAtom.reportRead();
    return super.entity;
  }

  @override
  set entity(AssetEntity value) {
    _$entityAtom.reportWrite(value, super.entity, () {
      super.entity = value;
    });
  }

  final _$latitudeAtom = Atom(name: '_PicStore.latitude');

  @override
  double get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(double value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  final _$longitudeAtom = Atom(name: '_PicStore.longitude');

  @override
  double get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(double value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  final _$specificLocationAtom = Atom(name: '_PicStore.specificLocation');

  @override
  String get specificLocation {
    _$specificLocationAtom.reportRead();
    return super.specificLocation;
  }

  @override
  set specificLocation(String value) {
    _$specificLocationAtom.reportWrite(value, super.specificLocation, () {
      super.specificLocation = value;
    });
  }

  final _$generalLocationAtom = Atom(name: '_PicStore.generalLocation');

  @override
  String get generalLocation {
    _$generalLocationAtom.reportRead();
    return super.generalLocation;
  }

  @override
  set generalLocation(String value) {
    _$generalLocationAtom.reportWrite(value, super.generalLocation, () {
      super.generalLocation = value;
    });
  }

  final _$isPrivateAtom = Atom(name: '_PicStore.isPrivate');

  @override
  bool get isPrivate {
    _$isPrivateAtom.reportRead();
    return super.isPrivate;
  }

  @override
  set isPrivate(bool value) {
    _$isPrivateAtom.reportWrite(value, super.isPrivate, () {
      super.isPrivate = value;
    });
  }

  final _$searchTextAtom = Atom(name: '_PicStore.searchText');

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  final _$aiTagsAtom = Atom(name: '_PicStore.aiTags');

  @override
  bool get aiTags {
    _$aiTagsAtom.reportRead();
    return super.aiTags;
  }

  @override
  set aiTags(bool value) {
    _$aiTagsAtom.reportWrite(value, super.aiTags, () {
      super.aiTags = value;
    });
  }

  final _$aiTagsLoadedAtom = Atom(name: '_PicStore.aiTagsLoaded');

  @override
  bool get aiTagsLoaded {
    _$aiTagsLoadedAtom.reportRead();
    return super.aiTagsLoaded;
  }

  @override
  set aiTagsLoaded(bool value) {
    _$aiTagsLoadedAtom.reportWrite(value, super.aiTagsLoaded, () {
      super.aiTagsLoaded = value;
    });
  }

  final _$switchIsStarredAsyncAction = AsyncAction('_PicStore.switchIsStarred');

  @override
  Future<void> switchIsStarred() {
    return _$switchIsStarredAsyncAction.run(() => super.switchIsStarred());
  }

  final _$setChangePhotoIdAsyncAction =
      AsyncAction('_PicStore.setChangePhotoId');

  @override
  Future<void> setChangePhotoId(String value) {
    return _$setChangePhotoIdAsyncAction
        .run(() => super.setChangePhotoId(value));
  }

  final _$changeAssetEntityAsyncAction =
      AsyncAction('_PicStore.changeAssetEntity');

  @override
  Future<void> changeAssetEntity(AssetEntity picEntity) {
    return _$changeAssetEntityAsyncAction
        .run(() => super.changeAssetEntity(picEntity));
  }

  final _$setPrivatePathAsyncAction = AsyncAction('_PicStore.setPrivatePath');

  @override
  Future<void> setPrivatePath(
      String picPath, String thumbnailPath, String picNonce) {
    return _$setPrivatePathAsyncAction
        .run(() => super.setPrivatePath(picPath, thumbnailPath, picNonce));
  }

  final _$removePrivatePathAsyncAction =
      AsyncAction('_PicStore.removePrivatePath');

  @override
  Future<void> removePrivatePath() {
    return _$removePrivatePathAsyncAction.run(() => super.removePrivatePath());
  }

  final _$loadPicInfoAsyncAction = AsyncAction('_PicStore.loadPicInfo');

  @override
  Future<void> loadPicInfo() {
    return _$loadPicInfoAsyncAction.run(() => super.loadPicInfo());
  }

  final _$setIsPrivateAsyncAction = AsyncAction('_PicStore.setIsPrivate');

  @override
  Future<void> setIsPrivate(bool value) {
    return _$setIsPrivateAsyncAction.run(() => super.setIsPrivate(value));
  }

  final _$addTagAsyncAction = AsyncAction('_PicStore.addTag');

  @override
  Future<void> addTag({String tagName}) {
    return _$addTagAsyncAction.run(() => super.addTag(tagName: tagName));
  }

  final _$addTagToPicAsyncAction = AsyncAction('_PicStore.addTagToPic');

  @override
  Future<void> addTagToPic(
      {String tagKey,
      String tagNameX,
      String photoId,
      List<AssetEntity> entities}) {
    return _$addTagToPicAsyncAction.run(() => super.addTagToPic(
        tagKey: tagKey,
        tagNameX: tagNameX,
        photoId: photoId,
        entities: entities));
  }

  final _$sharePicAsyncAction = AsyncAction('_PicStore.sharePic');

  @override
  Future<void> sharePic() {
    return _$sharePicAsyncAction.run(() => super.sharePic());
  }

  final _$deletePicAsyncAction = AsyncAction('_PicStore.deletePic');

  @override
  Future<bool> deletePic() {
    return _$deletePicAsyncAction.run(() => super.deletePic());
  }

  final _$removeTagFromPicAsyncAction =
      AsyncAction('_PicStore.removeTagFromPic');

  @override
  Future<void> removeTagFromPic({String tagKey}) {
    return _$removeTagFromPicAsyncAction
        .run(() => super.removeTagFromPic(tagKey: tagKey));
  }

  final _$saveLocationAsyncAction = AsyncAction('_PicStore.saveLocation');

  @override
  Future<void> saveLocation(
      {double lat, double long, String specific, String general}) {
    return _$saveLocationAsyncAction.run(() => super.saveLocation(
        lat: lat, long: long, specific: specific, general: general));
  }

  final _$getAiSuggestionsAsyncAction =
      AsyncAction('_PicStore.getAiSuggestions');

  @override
  Future<void> getAiSuggestions(BuildContext context) {
    return _$getAiSuggestionsAsyncAction
        .run(() => super.getAiSuggestions(context));
  }

  final _$_PicStoreActionController = ActionController(name: '_PicStore');

  @override
  void setSearchText(String value) {
    final _$actionInfo = _$_PicStoreActionController.startAction(
        name: '_PicStore.setSearchText');
    try {
      return super.setSearchText(value);
    } finally {
      _$_PicStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAiTags(bool value) {
    final _$actionInfo =
        _$_PicStoreActionController.startAction(name: '_PicStore.setAiTags');
    try {
      return super.setAiTags(value);
    } finally {
      _$_PicStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void switchAiTags(BuildContext context) {
    final _$actionInfo =
        _$_PicStoreActionController.startAction(name: '_PicStore.switchAiTags');
    try {
      return super.switchAiTags(context);
    } finally {
      _$_PicStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAiTagsLoaded(bool value) {
    final _$actionInfo = _$_PicStoreActionController.startAction(
        name: '_PicStore.setAiTagsLoaded');
    try {
      return super.setAiTagsLoaded(value);
    } finally {
      _$_PicStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isStarred: ${isStarred},
photoId: ${photoId},
entity: ${entity},
latitude: ${latitude},
longitude: ${longitude},
specificLocation: ${specificLocation},
generalLocation: ${generalLocation},
isPrivate: ${isPrivate},
searchText: ${searchText},
aiTags: ${aiTags},
aiTagsLoaded: ${aiTagsLoaded},
tagsKeys: ${tagsKeys},
tagsSuggestions: ${tagsSuggestions}
    ''';
  }
}
