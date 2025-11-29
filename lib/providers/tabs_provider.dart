import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/managers/widget_manager.dart';
import 'package:picpics/stores/percentage_dialog_controller.dart';
import 'package:picpics/stores/pic_store.dart';
import 'package:picpics/stores/private_photos_controller.dart';
import 'package:picpics/stores/swiper_tab_controller.dart';
import 'package:picpics/stores/tagged_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/utils/refresh_everything.dart';
import 'package:share_plus/share_plus.dart';

/// Tabs state for managing tab navigation, photo selection, and photo management
class TabsState {
  // Core tab state (6 properties - existing)
  final int currentIndex;
  final bool isTagging;
  final bool isMultiSelecting;
  final List<String> selectedPhotos;
  final bool multiTagSheet;
  final bool multiPicBar;

  // Core photo management (5 properties)
  final Map<String, AssetEntity> assetMap;
  final List<AssetEntity> assetEntityList;
  final Map<String, Rx<PicStore>> picStoreMap;
  final Map<String, bool> starredPicMap;
  final Status status;

  // Untagged photos management (3 properties)
  final Map<String, String> allUnTaggedPics;
  final List<dynamic> allUnTaggedPicsMonth;
  final List<dynamic> allUnTaggedPicsDay;

  // UI state (11 properties)
  final int toggleIndexUntagged;
  final int toggleIndexTagged;
  final double topOffsetFirstTab;
  final int tutorialIndex;
  final bool showDeleteSecretModal;
  final bool isScrolling;
  final bool isToggleBarVisible;
  final bool isLoading;
  final bool isUntaggedPicsLoaded;
  final bool modalCard;

  // UI controllers (2 properties)
  final ExpandableController expandableController;
  final ExpandableController expandablePaddingController;

  const TabsState({
    // Core tab state
    this.currentIndex = 0,
    this.isTagging = false,
    this.isMultiSelecting = false,
    this.selectedPhotos = const [],
    this.multiTagSheet = false,
    this.multiPicBar = false,
    // Core photo management
    this.assetMap = const {},
    this.assetEntityList = const [],
    this.picStoreMap = const {},
    this.starredPicMap = const {},
    this.status = Status.loading,
    // Untagged photos
    this.allUnTaggedPics = const {},
    this.allUnTaggedPicsMonth = const [],
    this.allUnTaggedPicsDay = const [],
    // UI state
    this.toggleIndexUntagged = 1,
    this.toggleIndexTagged = 1,
    this.topOffsetFirstTab = 64.0,
    this.tutorialIndex = 0,
    this.showDeleteSecretModal = false,
    this.isScrolling = false,
    this.isToggleBarVisible = true,
    this.isLoading = false,
    this.isUntaggedPicsLoaded = false,
    this.modalCard = false,
    // UI controllers
    required this.expandableController,
    required this.expandablePaddingController,
  });

  TabsState copyWith({
    // Core tab state
    int? currentIndex,
    bool? isTagging,
    bool? isMultiSelecting,
    List<String>? selectedPhotos,
    bool? multiTagSheet,
    bool? multiPicBar,
    // Core photo management
    Map<String, AssetEntity>? assetMap,
    List<AssetEntity>? assetEntityList,
    Map<String, Rx<PicStore>>? picStoreMap,
    Map<String, bool>? starredPicMap,
    Status? status,
    // Untagged photos
    Map<String, String>? allUnTaggedPics,
    List<dynamic>? allUnTaggedPicsMonth,
    List<dynamic>? allUnTaggedPicsDay,
    // UI state
    int? toggleIndexUntagged,
    int? toggleIndexTagged,
    double? topOffsetFirstTab,
    int? tutorialIndex,
    bool? showDeleteSecretModal,
    bool? isScrolling,
    bool? isToggleBarVisible,
    bool? isLoading,
    bool? isUntaggedPicsLoaded,
    bool? modalCard,
    // UI controllers
    ExpandableController? expandableController,
    ExpandableController? expandablePaddingController,
  }) {
    return TabsState(
      // Core tab state
      currentIndex: currentIndex ?? this.currentIndex,
      isTagging: isTagging ?? this.isTagging,
      isMultiSelecting: isMultiSelecting ?? this.isMultiSelecting,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      multiTagSheet: multiTagSheet ?? this.multiTagSheet,
      multiPicBar: multiPicBar ?? this.multiPicBar,
      // Core photo management
      assetMap: assetMap ?? this.assetMap,
      assetEntityList: assetEntityList ?? this.assetEntityList,
      picStoreMap: picStoreMap ?? this.picStoreMap,
      starredPicMap: starredPicMap ?? this.starredPicMap,
      status: status ?? this.status,
      // Untagged photos
      allUnTaggedPics: allUnTaggedPics ?? this.allUnTaggedPics,
      allUnTaggedPicsMonth: allUnTaggedPicsMonth ?? this.allUnTaggedPicsMonth,
      allUnTaggedPicsDay: allUnTaggedPicsDay ?? this.allUnTaggedPicsDay,
      // UI state
      toggleIndexUntagged: toggleIndexUntagged ?? this.toggleIndexUntagged,
      toggleIndexTagged: toggleIndexTagged ?? this.toggleIndexTagged,
      topOffsetFirstTab: topOffsetFirstTab ?? this.topOffsetFirstTab,
      tutorialIndex: tutorialIndex ?? this.tutorialIndex,
      showDeleteSecretModal: showDeleteSecretModal ?? this.showDeleteSecretModal,
      isScrolling: isScrolling ?? this.isScrolling,
      isToggleBarVisible: isToggleBarVisible ?? this.isToggleBarVisible,
      isLoading: isLoading ?? this.isLoading,
      isUntaggedPicsLoaded: isUntaggedPicsLoaded ?? this.isUntaggedPicsLoaded,
      modalCard: modalCard ?? this.modalCard,
      // UI controllers
      expandableController: expandableController ?? this.expandableController,
      expandablePaddingController: expandablePaddingController ?? this.expandablePaddingController,
    );
  }
}

/// Notifier for tabs state
/// Manages tab navigation, photo selection, and photo operations
class TabsNotifier extends StateNotifier<TabsState> {
  TabsNotifier()
      : super(TabsState(
          expandableController: ExpandableController(initialExpanded: false),
          expandablePaddingController: ExpandableController(initialExpanded: false),
        ));

  // Scroll controllers (instance variables, not state)
  late ScrollController untaggedScrollControllerMonth;
  late ScrollController untaggedScrollControllerDay;

  // ============================================================
  // INITIALIZATION & LIFECYCLE
  // ============================================================

  Future<void> initialization() async {
    await initPlatformState();
    await loadAssetPath();

    // Setup keyboard listener for tag sheet
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (state.multiTagSheet) {
        state.expandablePaddingController.expanded = visible;
      }
    });
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch for widget updates
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: false,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
      ),
      (String taskId) async {
        AppLogger.d('[BackgroundFetch] Event received $taskId');
        await WidgetManager.sendAndUpdate();
        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        AppLogger.d('[BackgroundFetch] TIMEOUT: $taskId');
        BackgroundFetch.finish(taskId);
      },
    );
  }

  // ============================================================
  // PHOTO MANAGER INTEGRATION
  // ============================================================

  Future<void> loadAssetPath() async {
    // Request gallery permissions
    final permitted = await UserController.to.requestGalleryPermission();
    if (permitted == false) {
      return;
    }

    setIsUntaggedPicsLoaded(false);

    final filterOptionGroup = FilterOptionGroup()
      ..addOrderOption(
        const OrderOption(
          type: OrderOptionType.createDate,
          asc: false,
        ),
      );

    final assets = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
      filterOption: filterOptionGroup,
    );

    await loadEntities(assets);
  }

  Future<void> loadEntities(List<AssetPathEntity> assetsPath) async {
    if (assetsPath.isEmpty) {
      state = state.copyWith(status: Status.deviceHasNoPics);
      return;
    }

    final assetPathEntity = assetsPath[0];
    final assetCount = await assetPathEntity.assetCountAsync;
    final assets = await assetPathEntity.getAssetListRange(start: 0, end: assetCount);

    state = state.copyWith(assetEntityList: List<AssetEntity>.from(assets));
    await refreshUntaggedList();
  }

  void sortAssetEntityList() {
    final sorted = List<AssetEntity>.from(state.assetEntityList);
    sorted.sort((a, b) {
      return DateTime(b.createDateTime.year, b.createDateTime.month, b.createDateTime.day)
          .compareTo(DateTime(a.createDateTime.year, a.createDateTime.month, a.createDateTime.day));
    });
    state = state.copyWith(assetEntityList: sorted);
  }

  // ============================================================
  // PICSTORE MANAGEMENT
  // ============================================================

  Rx<PicStore> explorPicStore(String picId, {bool silent = false}) {
    var picStoreValue = state.picStoreMap[picId];

    if (picStoreValue == null) {
      var entity = state.assetMap[picId];
      if (entity == null) {
        // Asset map not updated, refresh everything
        refreshEverything();
        entity = state.assetMap[picId];
      }

      if (entity != null) {
        picStoreValue = Rx<PicStore>(PicStore(
          entityValue: entity,
          createdAt: entity.createDateTime,
          originalLatitude: entity.latitude,
          originalLongitude: entity.longitude,
          photoId: picId,
          photoPath: '',
          thumbPath: '',
        ));

        // Add to picStoreMap
        final newPicStoreMap = Map<String, Rx<PicStore>>.from(state.picStoreMap);
        newPicStoreMap[picId] = picStoreValue;
        state = state.copyWith(picStoreMap: newPicStoreMap);
      }
    }

    return picStoreValue!;
  }

  // ============================================================
  // UNTAGGED PHOTOS MANAGEMENT
  // ============================================================

  Future<void> filterUntaggedPhotos() async {
    // Refresh tagged and private photos first
    await TaggedController.to.refreshTaggedPhotos();
    await PrivatePhotosController.to.refreshPrivatePics();

    DateTime? previousDay;
    DateTime? previousMonth;

    final newAssetMap = <String, AssetEntity>{};
    final newAllUnTaggedPics = <String, String>{};
    final newAllUnTaggedPicsMonth = <dynamic>[];
    final newAllUnTaggedPicsDay = <dynamic>[];
    final newPicStoreMap = Map<String, Rx<PicStore>>.from(state.picStoreMap);

    for (final entity in state.assetEntityList) {
      newAssetMap[entity.id] = entity;

      // Check if photo is untagged and not private
      if (TaggedController.to.allTaggedPicIdList[entity.id] == null &&
          PrivatePhotosController.to.privateMap[entity.id] == null) {
        final dateTime = DateTime.utc(
          entity.createDateTime.year,
          entity.createDateTime.month,
          entity.createDateTime.day,
        );

        if (previousDay == null || previousMonth == null) {
          previousDay = dateTime;
          previousMonth = dateTime;
          newAllUnTaggedPicsMonth.add(dateTime);
          newAllUnTaggedPicsDay.add(dateTime);
        }

        if (previousDay.year != dateTime.year ||
            previousDay.month != dateTime.month ||
            previousDay.day != dateTime.day) {
          if (previousDay.day != dateTime.day) {
            newAllUnTaggedPicsDay.add(dateTime);
          }
          if (previousDay.month != dateTime.month) {
            newAllUnTaggedPicsMonth.add(dateTime);
            previousMonth = dateTime;
          }
          previousDay = dateTime;
        }

        newAllUnTaggedPicsMonth.add(entity.id);
        newAllUnTaggedPicsDay.add(entity.id);
        newAllUnTaggedPics[entity.id] = '';
      }

      // Ensure picStore exists for this entity
      if (newPicStoreMap[entity.id] == null) {
        newPicStoreMap[entity.id] = explorPicStore(entity.id);
      }
    }

    state = state.copyWith(
      assetMap: newAssetMap,
      allUnTaggedPics: newAllUnTaggedPics,
      allUnTaggedPicsMonth: newAllUnTaggedPicsMonth,
      allUnTaggedPicsDay: newAllUnTaggedPicsDay,
      picStoreMap: newPicStoreMap,
    );
  }

  Future<void> refreshUntaggedList() async {
    setIsUntaggedPicsLoaded(false);
    sortAssetEntityList();
    await filterUntaggedPhotos();
    setIsUntaggedPicsLoaded(true);
  }

  void removePicFromUI(String picId) {
    final newAllUnTaggedPicsDay = List<dynamic>.from(state.allUnTaggedPicsDay);
    final newAllUnTaggedPicsMonth = List<dynamic>.from(state.allUnTaggedPicsMonth);
    final newAllUnTaggedPics = Map<String, String>.from(state.allUnTaggedPics);
    final newAssetMap = Map<String, AssetEntity>.from(state.assetMap);
    final newAssetEntityList = List<AssetEntity>.from(state.assetEntityList);

    newAllUnTaggedPicsDay.remove(picId);
    newAllUnTaggedPicsMonth.remove(picId);
    newAllUnTaggedPics.remove(picId);
    newAssetMap.remove(picId);
    newAssetEntityList.removeWhere((element) => element.id == picId);

    // Update swiper tab controller
    final index = SwiperTabController.to.swipeIndex.value;
    SwiperTabController.to.swiperPicIdList.remove(picId);
    if (SwiperTabController.to.swiperPicIdList.isNotEmpty) {
      SwiperTabController.to.swipeIndex.value = index + 1;
    }

    state = state.copyWith(
      allUnTaggedPicsDay: newAllUnTaggedPicsDay,
      allUnTaggedPicsMonth: newAllUnTaggedPicsMonth,
      allUnTaggedPics: newAllUnTaggedPics,
      assetMap: newAssetMap,
      assetEntityList: newAssetEntityList,
    );
  }

  // ============================================================
  // TAB NAVIGATION & BASIC SETTERS
  // ============================================================

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void setCurrentTab(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void setIsTagging(bool value) {
    state = state.copyWith(isTagging: value);
  }

  void setIsMultiSelecting(bool value) {
    state = state.copyWith(isMultiSelecting: value);
    if (!value) {
      clearSelectedPhotos();
    }
  }

  void setMultiTagSheet(bool value) {
    state = state.copyWith(multiTagSheet: value);
  }

  void setMultiPicBar(bool value) {
    state = state.copyWith(multiPicBar: value);
  }

  // ============================================================
  // PHOTO SELECTION
  // ============================================================

  void togglePhotoSelection(String photoId) {
    final photos = List<String>.from(state.selectedPhotos);
    if (photos.contains(photoId)) {
      photos.remove(photoId);
    } else {
      photos.add(photoId);
    }
    state = state.copyWith(selectedPhotos: photos);
  }

  void clearSelectedPhotos() {
    state = state.copyWith(selectedPhotos: []);
  }

  void selectAllPhotos(List<String> photoIds) {
    state = state.copyWith(selectedPhotos: photoIds);
  }

  // ============================================================
  // UI STATE SETTERS
  // ============================================================

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setModalCard(bool value) {
    state = state.copyWith(modalCard: value);
  }

  void setTutorialIndex(int value) {
    state = state.copyWith(tutorialIndex: value);
  }

  void setTopOffsetFirstTab(double value) {
    state = state.copyWith(topOffsetFirstTab: value);
  }

  void setShowDeleteSecretModal(bool value) {
    state = state.copyWith(showDeleteSecretModal: value);
  }

  void setIsScrolling(bool value) {
    state = state.copyWith(isScrolling: value);
  }

  void setIsToggleBarVisible(bool value) {
    state = state.copyWith(isToggleBarVisible: value);
  }

  void setToggleIndexUntagged(int value) {
    state = state.copyWith(toggleIndexUntagged: value);
  }

  void setToggleIndexTagged(int value) {
    state = state.copyWith(toggleIndexTagged: value);
  }

  void setIsUntaggedPicsLoaded(bool value) {
    state = state.copyWith(isUntaggedPicsLoaded: value);
  }

  void setStatus(Status value) {
    state = state.copyWith(status: value);
  }

  // ============================================================
  // ACTION HANDLERS
  // ============================================================

  void returnAction() {
    state = state.copyWith(
      selectedPhotos: [],
      multiPicBar: false,
    );
  }

  void tagAction() {
    setMultiTagSheet(true);
    Future.delayed(const Duration(milliseconds: 200), () {
      state.expandableController.expanded = true;
    });
  }

  Future<bool> shouldPopOut() async {
    AppLogger.d('WillPopScope tabsController');

    if (state.multiTagSheet) {
      AppLogger.d('WillPopScope multiTagSheet');
      TagsController.to.multiPicTags.clear();
      setMultiTagSheet(false);
      return false;
    }

    if (state.selectedPhotos.isNotEmpty) {
      clearSelectedPhotos();
      return false;
    }

    if (state.multiPicBar) {
      AppLogger.d('WillPopScope multiPicBar');
      setMultiPicBar(false);
      return false;
    }

    if (state.currentIndex != 0) {
      setCurrentIndex(0);
      return false;
    }

    AppLogger.d('WillPopScope onPoppingOut');
    onPoppingOut();
    return true;
  }

  void onPoppingOut() {
    clearSelectedPhotos();
    TagsController.to.multiPicTags.clear();
  }

  void setTabIndex(int index) {
    setCurrentIndex(index);
  }

  // ============================================================
  // MULTI-PHOTO OPERATIONS
  // ============================================================

  Future<void> trashMultiplePics(Set<String> selectedPicsIds) async {
    var deleted = false;
    final percentageController = Get.find<PercentageDialogController>();
    percentageController.stop();

    // Delete photos from device using PhotoManager
    final result = await PhotoManager.editor.deleteWithIds(selectedPicsIds.toList());
    if (result.isNotEmpty) {
      deleted = true;
    }

    if (deleted) {
      final database = AppDatabase();
      percentageController.start(selectedPicsIds.length + .0);

      await Future.forEach(selectedPicsIds.toList(), (String picId) async {
        final picStore = state.picStoreMap[picId]?.value ?? explorPicStore(picId).value;

        if (true) {
          removePicFromUI(picId);

          final pic = await database.getPhotoByPhotoId(picStore.photoId.value);

          if (pic != null && pic.tags.isNotEmpty) {
            final picTags = List<String>.from(pic.tags.keys);
            await Future.forEach(picTags, (String tagKey) async {
              final tag = await database.getLabelByLabelKey(tagKey);
              if (tag != null) {
                tag.photoId.remove(picStore.photoId.value);
                await database.updateLabel(tag);

                // Handle private photos (secret tag)
                if (tagKey == kSecretTagKey) {
                  await picStore.removePrivatePath();
                  await picStore.deleteEncryptedPic();
                }
              }
            });

            await database.deletePhotoByPhotoId(picStore.photoId.value);
            await Future.delayed(Duration.zero, () {
              percentageController.value.value += 1.0;
            });
          }
        }
      }).then((_) {
        percentageController.stop();
        refreshUntaggedList();
        // SwiperTabController refresh will be handled separately
      });

      await Analytics.sendEvent(Event.deleted_photo);
      clearSelectedPhotos();
    }
  }

  Future<void> trashPic(String picId) async {
    final picStore = state.picStoreMap[picId]?.value ?? explorPicStore(picId).value;
    await picStore.deletePic();
    await Analytics.sendEvent(Event.deleted_photo);
  }

  void deletePic(String picId, bool removeFromGallery) {
    removePicFromUI(picId);
  }

  Future<void> shareAction() async {
    if (state.selectedPhotos.isEmpty) {
      return;
    }

    AppLogger.d('sharing selected pics....');
    setIsLoading(true);
    await _sharePics(picKeys: state.selectedPhotos);
    setIsLoading(false);
  }

  Future<void> _sharePics({required List<String> picKeys}) async {
    final imageList = <String>[];
    final mimeList = <String>[];

    for (final picKey in picKeys) {
      if (state.assetMap[picKey] == null) {
        continue;
      }

      final data = state.assetMap[picKey];
      if (data == null) {
        continue;
      }

      final path = (await data.file)?.path;
      if (path != null) {
        final mime = lookupMimeType(path);
        if (mime != null) {
          imageList.add(path);
          mimeList.add(mime);
        }
      }
    }

    await Analytics.sendEvent(Event.shared_photos);
    await Share.shareXFiles(imageList.map(XFile.new).toList());
  }

  void trashAction() {
    if (state.selectedPhotos.isEmpty) {
      return;
    }
    trashMultiplePics(state.selectedPhotos.toSet());
  }

  void clearSelectedPics() {
    clearSelectedPhotos();
  }

  bool get deviceHasPics {
    return state.assetMap.isNotEmpty;
  }

  // ============================================================
  // SCROLL CONTROLLER MANAGEMENT
  // ============================================================

  void initScrollControllers() {
    untaggedScrollControllerMonth = ScrollController();
    untaggedScrollControllerDay = ScrollController();
  }

  @override
  void dispose() {
    if (untaggedScrollControllerMonth.hasClients) {
      untaggedScrollControllerMonth.dispose();
    }
    if (untaggedScrollControllerDay.hasClients) {
      untaggedScrollControllerDay.dispose();
    }
    super.dispose();
  }
}

final tabsProvider = StateNotifierProvider<TabsNotifier, TabsState>((ref) {
  return TabsNotifier();
});
