// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GalleryStore on _GalleryStore, Store {
  Computed<int> _$totalTaggedPicsComputed;

  @override
  int get totalTaggedPics =>
      (_$totalTaggedPicsComputed ??= Computed<int>(() => super.totalTaggedPics,
              name: '_GalleryStore.totalTaggedPics'))
          .value;
  Computed<Set<String>> _$allPicsKeysComputed;

  @override
  Set<String> get allPicsKeys =>
      (_$allPicsKeysComputed ??= Computed<Set<String>>(() => super.allPicsKeys,
              name: '_GalleryStore.allPicsKeys'))
          .value;
  Computed<List<String>> _$filteredPicsKeysComputed;

  @override
  List<String> get filteredPicsKeys => (_$filteredPicsKeysComputed ??=
          Computed<List<String>>(() => super.filteredPicsKeys,
              name: '_GalleryStore.filteredPicsKeys'))
      .value;
  Computed<PicStore> _$currentThumbnailPicComputed;

  @override
  PicStore get currentThumbnailPic => (_$currentThumbnailPicComputed ??=
          Computed<PicStore>(() => super.currentThumbnailPic,
              name: '_GalleryStore.currentThumbnailPic'))
      .value;
  Computed<List<String>> _$searchingTagsKeysComputed;

  @override
  List<String> get searchingTagsKeys => (_$searchingTagsKeysComputed ??=
          Computed<List<String>>(() => super.searchingTagsKeys,
              name: '_GalleryStore.searchingTagsKeys'))
      .value;
  Computed<bool> _$isFilteredComputed;

  @override
  bool get isFiltered =>
      (_$isFilteredComputed ??= Computed<bool>(() => super.isFiltered,
              name: '_GalleryStore.isFiltered'))
          .value;
  Computed<List<String>> _$multiPicTagKeysComputed;

  @override
  List<String> get multiPicTagKeys => (_$multiPicTagKeysComputed ??=
          Computed<List<String>>(() => super.multiPicTagKeys,
              name: '_GalleryStore.multiPicTagKeys'))
      .value;
  Computed<List<TagsStore>> _$tagsSuggestionsComputed;

  @override
  List<TagsStore> get tagsSuggestions => (_$tagsSuggestionsComputed ??=
          Computed<List<TagsStore>>(() => super.tagsSuggestions,
              name: '_GalleryStore.tagsSuggestions'))
      .value;
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

  final _$selectedThumbnailAtom = Atom(name: '_GalleryStore.selectedThumbnail');

  @override
  int get selectedThumbnail {
    _$selectedThumbnailAtom.reportRead();
    return super.selectedThumbnail;
  }

  @override
  set selectedThumbnail(int value) {
    _$selectedThumbnailAtom.reportWrite(value, super.selectedThumbnail, () {
      super.selectedThumbnail = value;
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

  final _$showSearchTagsResultsAtom =
      Atom(name: '_GalleryStore.showSearchTagsResults');

  @override
  bool get showSearchTagsResults {
    _$showSearchTagsResultsAtom.reportRead();
    return super.showSearchTagsResults;
  }

  @override
  set showSearchTagsResults(bool value) {
    _$showSearchTagsResultsAtom.reportWrite(value, super.showSearchTagsResults,
        () {
      super.showSearchTagsResults = value;
    });
  }

  final _$searchTextAtom = Atom(name: '_GalleryStore.searchText');

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

  final _$shouldRefreshTaggedGalleryAtom =
      Atom(name: '_GalleryStore.shouldRefreshTaggedGallery');

  @override
  bool get shouldRefreshTaggedGallery {
    _$shouldRefreshTaggedGalleryAtom.reportRead();
    return super.shouldRefreshTaggedGallery;
  }

  @override
  set shouldRefreshTaggedGallery(bool value) {
    _$shouldRefreshTaggedGalleryAtom
        .reportWrite(value, super.shouldRefreshTaggedGallery, () {
      super.shouldRefreshTaggedGallery = value;
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

  final _$trashMultiplePicsAsyncAction =
      AsyncAction('_GalleryStore.trashMultiplePics');

  @override
  Future<void> trashMultiplePics(Set<PicStore> selectedPics) {
    return _$trashMultiplePicsAsyncAction
        .run(() => super.trashMultiplePics(selectedPics));
  }

  final _$trashPicAsyncAction = AsyncAction('_GalleryStore.trashPic');

  @override
  Future<void> trashPic(PicStore picStore) {
    return _$trashPicAsyncAction.run(() => super.trashPic(picStore));
  }

  final _$sharePicsAsyncAction = AsyncAction('_GalleryStore.sharePics');

  @override
  Future<void> sharePics({List<PicStore> picsStores}) {
    return _$sharePicsAsyncAction
        .run(() => super.sharePics(picsStores: picsStores));
  }

  final _$_onAssetChangeAsyncAction =
      AsyncAction('_GalleryStore._onAssetChange');

  @override
  Future<void> _onAssetChange(MethodCall call) {
    return _$_onAssetChangeAsyncAction.run(() => super._onAssetChange(call));
  }

  final _$removeAllPrivatePicsAsyncAction =
      AsyncAction('_GalleryStore.removeAllPrivatePics');

  @override
  Future<void> removeAllPrivatePics() {
    return _$removeAllPrivatePicsAsyncAction
        .run(() => super.removeAllPrivatePics());
  }

  final _$checkIsLibraryUpdatedAsyncAction =
      AsyncAction('_GalleryStore.checkIsLibraryUpdated');

  @override
  Future<void> checkIsLibraryUpdated() {
    return _$checkIsLibraryUpdatedAsyncAction
        .run(() => super.checkIsLibraryUpdated());
  }

  final _$_GalleryStoreActionController =
      ActionController(name: '_GalleryStore');

  @override
  void setCurrentPic(PicStore picStore) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setCurrentPic');
    try {
      return super.setCurrentPic(picStore);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

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
  void clearPicThumbnails() {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.clearPicThumbnails');
    try {
      return super.clearPicThumbnails();
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPicToThumbnails(PicStore picStore) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addPicToThumbnails');
    try {
      return super.addPicToThumbnails(picStore);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPicsToThumbnails(List<PicStore> picStores) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addPicsToThumbnails');
    try {
      return super.addPicsToThumbnails(picStores);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedThumbnail(int value) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setSelectedThumbnail');
    try {
      return super.setSelectedThumbnail(value);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInitialSelectedThumbnail(PicStore picStore) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setInitialSelectedThumbnail');
    try {
      return super.setInitialSelectedThumbnail(picStore);
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
  void clearSearchTags() {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.clearSearchTags');
    try {
      return super.clearSearchTags();
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowSearchTagsResults(bool value) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setShowSearchTagsResults');
    try {
      return super.setShowSearchTagsResults(value);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPics({PicStore picStore, bool picIsTagged}) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setSelectedPics');
    try {
      return super
          .setSelectedPics(picStore: picStore, picIsTagged: picIsTagged);
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
  void addToMultiPicTags(String tagKey) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addToMultiPicTags');
    try {
      return super.addToMultiPicTags(tagKey);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromMultiPicTags(String tagKey) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.removeFromMultiPicTags');
    try {
      return super.removeFromMultiPicTags(tagKey);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearMultiPicTags() {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.clearMultiPicTags');
    try {
      return super.clearMultiPicTags();
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchText(String value) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setSearchText');
    try {
      return super.setSearchText(value);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPicToTaggedPics({PicStore picStore, bool toInitialIndex = false}) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addPicToTaggedPics');
    try {
      return super.addPicToTaggedPics(
          picStore: picStore, toInitialIndex: toInitialIndex);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePicFromTaggedPics({PicStore picStore, bool deepScan = false}) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.removePicFromTaggedPics');
    try {
      return super
          .removePicFromTaggedPics(picStore: picStore, deepScan: deepScan);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteEntity(String entityId) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.deleteEntity');
    try {
      return super.deleteEntity(entityId);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addEntity(AssetEntity entity) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addEntity');
    try {
      return super.addEntity(entity);
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
  void addTagsToSelectedPics() {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.addTagsToSelectedPics');
    try {
      return super.addTagsToSelectedPics();
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShouldRefreshTaggedGallery(bool value) {
    final _$actionInfo = _$_GalleryStoreActionController.startAction(
        name: '_GalleryStore.setShouldRefreshTaggedGallery');
    try {
      return super.setShouldRefreshTaggedGallery(value);
    } finally {
      _$_GalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPic: ${currentPic},
swipeIndex: ${swipeIndex},
isLoaded: ${isLoaded},
selectedThumbnail: ${selectedThumbnail},
isSearching: ${isSearching},
showSearchTagsResults: ${showSearchTagsResults},
searchText: ${searchText},
trashedPic: ${trashedPic},
sharedPic: ${sharedPic},
shouldRefreshTaggedGallery: ${shouldRefreshTaggedGallery},
totalTaggedPics: ${totalTaggedPics},
allPicsKeys: ${allPicsKeys},
filteredPicsKeys: ${filteredPicsKeys},
currentThumbnailPic: ${currentThumbnailPic},
searchingTagsKeys: ${searchingTagsKeys},
isFiltered: ${isFiltered},
multiPicTagKeys: ${multiPicTagKeys},
tagsSuggestions: ${tagsSuggestions},
taggedKeys: ${taggedKeys},
deviceHasPics: ${deviceHasPics}
    ''';
  }
}
