// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GalleryStore on _GalleryStore, Store {
  Computed<List<String>> _$taggedKeysComputed;

  @override
  List<String> get taggedKeys =>
      (_$taggedKeysComputed ??= Computed<List<String>>(() => super.taggedKeys,
              name: '_GalleryStore.taggedKeys'))
          .value;
  Computed<bool> _$deviceHasPicsComputed;

  @override
  bool get deviceHasPics =>
      (_$deviceHasPicsComputed ??= Computed<bool>(() => super.deviceHasPics,
              name: '_GalleryStore.deviceHasPics'))
          .value;

  final _$swipeIndexAtom = Atom(name: '_GalleryStore.swipeIndex');

  @override
  int get swipeIndex {
    _$swipeIndexAtom.reportRead();
    return super.swipeIndex;
  }

  @override
  set swipeIndex(int value) {
    _$swipeIndexAtom.reportWrite(value, super.swipeIndex, () {
      super.swipeIndex = value;
    });
  }

  final _$isLoadedAtom = Atom(name: '_GalleryStore.isLoaded');

  @override
  bool get isLoaded {
    _$isLoadedAtom.reportRead();
    return super.isLoaded;
  }

  @override
  set isLoaded(bool value) {
    _$isLoadedAtom.reportWrite(value, super.isLoaded, () {
      super.isLoaded = value;
    });
  }

  final _$isSearchingAtom = Atom(name: '_GalleryStore.isSearching');

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  final _$currentPicAtom = Atom(name: '_GalleryStore.currentPic');

  @override
  PicStore get currentPic {
    _$currentPicAtom.reportRead();
    return super.currentPic;
  }

  @override
  set currentPic(PicStore value) {
    _$currentPicAtom.reportWrite(value, super.currentPic, () {
      super.currentPic = value;
    });
  }

  final _$trashedPicAtom = Atom(name: '_GalleryStore.trashedPic');

  @override
  bool get trashedPic {
    _$trashedPicAtom.reportRead();
    return super.trashedPic;
  }

  @override
  set trashedPic(bool value) {
    _$trashedPicAtom.reportWrite(value, super.trashedPic, () {
      super.trashedPic = value;
    });
  }

  final _$sharedPicAtom = Atom(name: '_GalleryStore.sharedPic');

  @override
  bool get sharedPic {
    _$sharedPicAtom.reportRead();
    return super.sharedPic;
  }

  @override
  set sharedPic(bool value) {
    _$sharedPicAtom.reportWrite(value, super.sharedPic, () {
      super.sharedPic = value;
    });
  }

  final _$loadEntitiesAsyncAction = AsyncAction('_GalleryStore.loadEntities');

  @override
  Future<void> loadEntities() {
    return _$loadEntitiesAsyncAction.run(() => super.loadEntities());
  }

  final _$loadAssetsPathAsyncAction =
      AsyncAction('_GalleryStore.loadAssetsPath');

  @override
  Future<void> loadAssetsPath() {
    return _$loadAssetsPathAsyncAction.run(() => super.loadAssetsPath());
  }

  final _$trashPicAsyncAction = AsyncAction('_GalleryStore.trashPic');

  @override
  Future<void> trashPic(PicStore picStore) {
    return _$trashPicAsyncAction.run(() => super.trashPic(picStore));
  }

  final _$sharePicsAsyncAction = AsyncAction('_GalleryStore.sharePics');

  @override
  Future<void> sharePics({List<String> photoIds}) {
    return _$sharePicsAsyncAction
        .run(() => super.sharePics(photoIds: photoIds));
  }

  final _$_GalleryStoreActionController =
      ActionController(name: '_GalleryStore');

  @override
  void setSwipeIndex(int value) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setSwipeIndex');
    try {
      return super.setSwipeIndex(value);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsSearching(bool value) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setIsSearching');
    try {
      return super.setIsSearching(value);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPics({String photoId, bool picIsTagged}) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setSelectedPics');
    try {
      return super.setSelectedPics(photoId: photoId, picIsTagged: picIsTagged);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelectedPics() {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.clearSelectedPics');
    try {
      return super.clearSelectedPics();
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentPic(PicStore pic) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setCurrentPic');
    try {
      return super.setCurrentPic(pic);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTrashedPic(bool value) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setTrashedPic');
    try {
      return super.setTrashedPic(value);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSharedPic(bool value) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setSharedPic');
    try {
      return super.setSharedPic(value);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editTag({String oldTagKey, String newName}) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.editTag');
    try {
      return super.editTag(oldTagKey: oldTagKey, newName: newName);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteTag({String tagKey}) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.deleteTag');
    try {
      return super.deleteTag(tagKey: tagKey);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTagToSearchFilter() {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addTagToSearchFilter');
    try {
      return super.addTagToSearchFilter();
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchPicsWithTags() {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.searchPicsWithTags');
    try {
      return super.searchPicsWithTags();
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchResultsTags(String text) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.searchResultsTags');
    try {
      return super.searchResultsTags(text);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTagsToPics(
      {List<String> tagsKeys,
      List<String> photosIds,
      List<AssetEntity> entities}) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addTagsToPics');
    try {
      return super.addTagsToPics(
          tagsKeys: tagsKeys, photosIds: photosIds, entities: entities);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTagToRecent({String tagKey}) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addTagToRecent');
    try {
      return super.addTagToRecent(tagKey: tagKey);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
swipeIndex: ${swipeIndex},
isLoaded: ${isLoaded},
isSearching: ${isSearching},
currentPic: ${currentPic},
trashedPic: ${trashedPic},
sharedPic: ${sharedPic},
taggedKeys: ${taggedKeys},
deviceHasPics: ${deviceHasPics}
    ''';
  }
}
