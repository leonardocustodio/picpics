// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GalleryStore on _GalleryStore, Store {
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
  String toString() {
    return '''
swipeIndex: ${swipeIndex},
isLoaded: ${isLoaded},
currentPic: ${currentPic},
trashedPic: ${trashedPic},
deviceHasPics: ${deviceHasPics}
    ''';
  }
}
