import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/push_notifications_manager.dart';
import 'package:picPics/managers/widget_manager.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/swiper_tab_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/refresh_everything.dart';
import 'package:picPics/widgets/confirm_pic_delete.dart';
import 'package:share/share.dart';
import 'dart:async';

import '../constants.dart';
import 'private_photos_controller.dart';

/* class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
} */

class TabsController extends GetxController {
  static TabsController get to => Get.find();
  final currentTab = 0.obs;
  final toggleIndexUntagged = 1.obs;
  final toggleIndexTagged = 1.obs;
  final topOffsetFirstTab = 64.0.obs;
  final tutorialIndex = 0.obs;
  //final showPrivatePics = false.obs;
  final multiPicBar = false.obs;
  final multiTagSheet = false.obs;
  final showDeleteSecretModal = false.obs;
  final isScrolling = false.obs;
  final isToggleBarVisible = true.obs;
  final isLoading = false.obs;
  final isUntaggedPicsLoaded = false.obs;
  final modalCard = false.obs;
  final status = Status.Loading.obs;

  final untaggedScrollControllerMonth = ScrollController();
  final untaggedScrollControllerDay = ScrollController();

  //var privatePhotoIdMap = <String, String>{};
  /* final secretPicIds = <String, bool>{}.obs;
  final secretPicData = <String, Private>{}.obs; */
  final selectedMultiBarPics = <String, bool>{}.obs;
  //final photoPathMap = <String, String>{}.obs;

  final picStoreMap = <String, Rx<PicStore>>{}.obs;

  AppDatabase database = AppDatabase();
  final allUnTaggedPicsMonth = <dynamic>[].obs;
  final allUnTaggedPicsDay = <dynamic>[].obs;
  final allUnTaggedPics = <String, String>{}.obs;

  // picId: assetPathEntity
  final assetMap = <String, AssetEntity>{}.obs;
  List<AssetEntity> assetEntityList = <AssetEntity>[];

  final starredPicMap = <String, bool>{}.obs;

  final expandableController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));
  final expandablePaddingController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));

  @override
  void onReady() {
    /// I know below line is redundant but it is used to kickstart initialization of the tags list.
    var _ = TagsController.to.allTags;
    var __ = TaggedController.to.taggedPicId;
    initialization();

    /* Future.delayed(Duration(seconds: 5), () {
      Timer.periodic(Duration(milliseconds: 4), (_) {
        print('runned');
        allUnTaggedPicsMonth.remove(allUnTaggedPicsMonth.keys.toList()[1]);
        allUnTaggedPicsDay.remove(allUnTaggedPicsDay.keys.toList()[1]);
      });
    }); */
    super.onReady();
  }

  Future<bool> shouldPopOut() async {
    /// if sheet is opened the don't allow popping and just
    if (multiTagSheet.value) {
      TagsController.to.multiPicTags.clear();
      multiTagSheet.value = false;
      return false;
    }
    if (multiPicBar.value) {
      multiPicBar.value = false;
      selectedMultiBarPics.clear();
      return false;
    }
    onPoppingOut();
    return true;
  }

  void onPoppingOut() {
    selectedMultiBarPics.clear();
    TagsController.to.multiPicTags.clear();
  }

  Future<void> initialization() async {
    await initPlatformState();
    //await BlurHashController.to.loadBlurHash();
    await loadAssetPath();

    /* ever(showPrivatePics, (_) {
      refreshUntaggedList();
    }); */

    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (multiTagSheet.value) {
        expandablePaddingController.value.expanded = visible;
      }
    });

    /* ever(GalleryStore.to.trashedPic, (_) {
      if (GalleryStore.to.trashedPic.value) {
        if (modalCard.value) {
          setModalCard(false);
        }
        if (currentTab != 1) {
          GalleryStore.to.setTrashedPic(false);
        }
      }
    });

    ever(GalleryStore.to.sharedPic, (_) {
      if (GalleryStore.to.sharedPic.value) {
        if (multiPicBar.value) {
          GalleryStore.to.clearSelectedPics();
          setMultiPicBar(false);
        }
      }
    }); */

    /*    disposer3 = reaction((_) => controller.showDeleteSecretModal, (showModal) {
      if (showModal) {
        //print('show delete secret modal!!!');
//        setState(() {
//          showEditTagModal();
//        });
//        showDeleteSecretModal(context);
      }
    }); */
    var ___ = Get.put(UserController());
    if (UserController.to.tutorialCompleted.value == true &&
        UserController.to.notifications.value == true) {
      var push = PushNotificationsManager();
      await push.init();
    }

    // Added for the case of buying premium from appstore
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (UserController.to.tryBuyId != null) {
        await Get.to(() => PremiumScreen());
      }
    });
  }

  Future<void> loadEntities(List<AssetPathEntity> assetsPath) async {
    if (assetsPath.isEmpty) {
      status.value = Status.DeviceHasNoPics;
      return;
    }

    var assetPathEntity = assetsPath[0];

    assetEntityList = List<AssetEntity>.from(await assetPathEntity
        .getAssetListRange(start: 0, end: assetPathEntity.assetCount));
    await refreshUntaggedList();
  }

  void sortAssetEntityList() {
    assetEntityList.sort((a, b) {
      return DateTime(b.createDateTime.year, b.createDateTime.month,
              b.createDateTime.day)
          .compareTo(DateTime(a.createDateTime.year, a.createDateTime.month,
              a.createDateTime.day));
    });
  }

  Future<void> filterUntaggedPhotos() async {
    /// refreshing the taggedPhotos so that we can filter out the untagged photos from the below section.
    await TaggedController.to.refreshTaggedPhotos();
    await PrivatePhotosController.to.refreshPrivatePics();

    DateTime? previousDay;
    DateTime? previousMonth;

    var previousMonthPicIdList = <String>[];
    var previousDayPicIdList = <String>[];

    /// clear the map as this function will be used to refresh from the tagging done via expandable or the swiper tags

    allUnTaggedPics.clear();
    allUnTaggedPicsMonth.clear();
    allUnTaggedPicsDay.clear();
    await Future.forEach(assetEntityList, (AssetEntity entity) async {
      assetMap[entity.id] = entity;

      /// Iterating and checking whether the picId is not a tagged pic or it's not a private pic
      if (TaggedController.to.allTaggedPicIdList[entity.id] == null &&
          PrivatePhotosController.to.privateMap[entity.id] == null) {
        var dateTime = DateTime.utc(entity.createDateTime.year,
            entity.createDateTime.month, entity.createDateTime.day);
        if (previousDay == null || previousMonth == null) {
          previousDay = dateTime;
          previousMonth = dateTime;
          allUnTaggedPicsMonth.add(dateTime);
          allUnTaggedPicsDay.add(dateTime);
        }

        if (previousDay!.year != dateTime.year ||
            previousDay!.month != dateTime.month ||
            previousDay!.day != dateTime.day) {
          if (previousDay!.day != dateTime.day) {
            allUnTaggedPicsDay.add(dateTime);
          }
          if (previousDay!.month != dateTime.month) {
            allUnTaggedPicsMonth.add(dateTime);
            previousMonth = dateTime;
          }
          previousDay = dateTime;
        }
        allUnTaggedPicsMonth.add(entity.id);
        allUnTaggedPicsDay.add(entity.id);
        allUnTaggedPics[entity.id] = '';
        previousMonthPicIdList.add(entity.id);
        previousDayPicIdList.add(entity.id);
      }
      if (picStoreMap[entity.id] == null) {
        picStoreMap[entity.id] = Rx<PicStore>(explorPicStore(entity.id).value!);
      }
      //status.value = Status.Loaded;
    });
  }

  Future<void> refreshUntaggedList() async {
    isUntaggedPicsLoaded.value = false;
    sortAssetEntityList();
    await filterUntaggedPhotos();
    isUntaggedPicsLoaded.value = true;
  }

  void deletePic(String picId, bool removeFromGallery) {
    allUnTaggedPicsDay.remove(picId);
    allUnTaggedPicsMonth.remove(picId);
    /* secretPicIds.remove(picId);
    secretPicData.remove(picId); */
    //picAssetThumbBytesMap.remove(picId);
    if (removeFromGallery) {}
  }

  /// Here only those picId will come who are untagged.
  Rx<PicStore?> explorPicStore(String picId, {bool silent = false}) {
    var picStoreValue = picStoreMap[picId];

    if (null == picStoreMap[picId]) {
      var entity = assetMap[picId];
      if (null == entity) {
        /// TODO: In worst case scenario this is telling that the asset map is not update
        /// and does not contain the image
        refresh_everything();
      }
      entity = assetMap[picId];

      picStoreValue = Rx<PicStore>(PicStore(
        entityValue: entity!,
        createdAt: entity.createDateTime,
        originalLatitude: entity.latitude,
        originalLongitude: entity.longitude,
        photoId: picId,
        photoPath: '',
        thumbPath: '',
      ));
    }
    return picStoreValue!;
  }

  Future<void> loadAssetPath() async {
    /// we are asking permission here because the PhotoManager will surely ask for permission
    /// in the below code and then we will not have acknowledgement whether the user has approved or not.
    /// and thus we can't again as the user whether he or she wants to give permission or not !!
    var permitted = await UserController.to.requestGalleryPermission();
    if (permitted == false) {
      return;
    }
    isUntaggedPicsLoaded.value = false;
    var filterOptionGroup = FilterOptionGroup()
      ..addOrderOption(
        OrderOption(
          type: OrderOptionType.createDate,
          asc: false,
        ),
      );

    final assets = await PhotoManager.getAssetPathList(
      hasAll: true,
      type: RequestType.image,
      onlyAll: true,
      filterOption: filterOptionGroup,
    );

    await loadEntities(assets);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: false,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // This is the fetch-event callback.
      //print("[BackgroundFetch] Event received $taskId");

      await WidgetManager.sendAndUpdate();

      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      //print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      //print('[BackgroundFetch] configure ERROR: $e');
    });

    // Optionally query the current BackgroundFetch status.
    // int status = await BackgroundFetch.status;
    // setState(() {
    //   _status = status;
    // });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;
  }

  void setCurrentTab(int value) {
    if (currentTab.value != value) {
      /* if (currentTab.value == 1) {
        GalleryStore.to.setSwipeIndex(GalleryStore.to.swipeIndex.value);
      } else if (currentTab.value == 2) {
        GalleryStore.to.clearSearchTags();
      } */

      Analytics.sendCurrentTab(value);
      currentTab.value = value;
    }
  }

  void setMultiPicBar(bool value) {
    if (value) {
      Analytics.sendEvent(Event.selected_photos);
    }
    multiPicBar.value = value;
  }

  void setMultiTagSheet(bool value) {
    multiTagSheet.value = value;
  }

  void setIsLoading(bool value) {
    isLoading.value = value;
  }

  void setModalCard(bool value) {
    Analytics.sendEvent(Event.showed_card);
    modalCard.value = value;
  }

  void setTutorialIndex(int value) => tutorialIndex.value = value;

  double offsetFirstTab = 0.0;

  void setTopOffsetFirstTab(double value) {
    if (value == topOffsetFirstTab.value) {
      return;
    }
    topOffsetFirstTab.value = value;
  }

  void setShowDeleteSecretModal(bool value) {
    showDeleteSecretModal.value = value;
  }

  void setIsScrolling(bool value) => isScrolling.value = value;

  void setIsToggleBarVisible(bool value) => isToggleBarVisible.value = value;

  void setToggleIndexUntagged(int value) => toggleIndexUntagged.value = value;

  void returnAction() {
    selectedMultiBarPics.clear();
    setMultiPicBar(false);
  }

  Future<void> starredAction() async {
    //await WidgetManager.saveData(picsStores: selectedUntaggedPics.toList());

    selectedMultiBarPics.forEach((picId, value) {
      var picStore = picStoreMap[picId]?.value;
      picStore ??= explorPicStore(picId).value;
      picStore?.switchIsStarred();
    });
    returnAction();
  }

  void tagAction() {
    setMultiTagSheet(true);
    Future.delayed(Duration(milliseconds: 200), () {
      expandableController.value.expanded = true;
    });
  }

  Future<void> shareAction() async {
    if (selectedMultiBarPics.isEmpty) {
      return;
    }
    //print('sharing selected pics....');
    setIsLoading(true);
    await sharePics(picKeys: selectedMultiBarPics.keys.toList());
    setIsLoading(false);
  }

  void trashAction() {
    if (selectedMultiBarPics.isEmpty) {
      return;
    }
    trashMultiplePics(selectedMultiBarPics.keys.toList().toSet());
  }

  bool get deviceHasPics {
    return assetMap.isNotEmpty;
  }

  void clearSelectedUntaggedPics() {
    selectedMultiBarPics.clear();
  }

  void setTabIndex(int index) async {
    if (!deviceHasPics || selectedMultiBarPics.isEmpty) {
      if (index == 0) {
        setMultiPicBar(false);
        clearSelectedUntaggedPics();
        TagsController.to.clearMultiPicTags();
        setCurrentTab(0);
        return;
      }
    }

    if (multiPicBar.value) {
      if (index == 0) {
        clearSelectedUntaggedPics();
        setMultiPicBar(false);
      } else if (index == 1) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          setMultiTagSheet(true);
          expandableController.value.expanded = true;
          expandablePaddingController.value.expanded = true;
        });
      } else if (index == 2) {
        if (selectedMultiBarPics.isEmpty) {
          return;
        }
        //print('sharing selected pics....');
        setIsLoading(true);
        await sharePics(picKeys: selectedMultiBarPics.keys.toList());
        setIsLoading(false);
      } else if (index == 3) {
        final picSet = selectedMultiBarPics.keys.toList().toSet();
        if (picSet.isEmpty) {
          return;
        }
        setMultiPicBar(false);
        setMultiTagSheet(false);
        await showDialog<void>(
          context: Get.context!,
          barrierDismissible: true,
          builder: (context) {
            return ConfirmPicDelete(
              onPressedDelete: () async {
                Navigator.pop(context);
                await trashMultiplePics(picSet);
              },
              deleteText:
                  'Are you sure you want to delete ${picSet.length} photos ?',
            );
          },
        );
      }
      return;
    }

    setCurrentTab(index);
  }

  Future<void> trashMultiplePics(Set<String> selectedPicsIds) async {
    /* List<String> selectedPicsIds =
        selectedPics.map((e) => e.photoId.value).toList(); */

    var deleted = false;

    final result =
        await PhotoManager.editor.deleteWithIds(selectedPicsIds.toList());
    if (result.isNotEmpty) {
      deleted = true;
    }

    if (deleted) {
      /* var picsBox = Hive.box('pics');
      var tagsBox = Hive.box('tags'); */

      await Future.wait([
        Future.forEach(selectedPicsIds.toList(), (String picId) async {
          var picStore = picStoreMap[picId]?.value;
          picStore = explorPicStore(picId).value;
          if (null != picStore) {
            removePicFromUI(picId);
            /* filteredPics.remove(picStore);
          removePicFromTaggedPics(picStore: picStore, forceDelete: true);
          swipePics.remove(picStore);
          removePicFromUntaggedPics(picStore: picStore);
          allPics.value.remove(picStore);
          user.setDefaultWidgetImage(allPics.value[0].entity.value); */
            var pic = await database.getPhotoByPhotoId(picStore.photoId.value);

            if (pic != null && pic.tags.isNotEmpty) {
              // //print('pic is in db... removing it from db!');
              var picTags = List<String>.from(pic.tags.keys);
              await Future.wait([
                Future.forEach(picTags, (String tagKey) async {
                  var tag = await database.getLabelByLabelKey(tagKey);
                  if (tag != null) {
                    if (picStore != null) {
                      tag.photoId.remove(picStore.photoId);
                    }
                    // //print('removed ${picStore.photoId} from tag ${tag.title}');
                    await database.updateLabel(tag);
                    //tagsBox.put(tagKey, tag);

                    if (tagKey == kSecretTagKey) {
                      await picStore?.removePrivatePath();
                      await picStore?.deleteEncryptedPic();
                    }
                  }
                })
              ]);

              //picsBox.delete(picStore.photoId);
              await database.deletePhotoByPhotoId(picStore.photoId.value);
              // //print('removed ${picStore.photoId} from database');
            }
          }
        })
      ]).then((_) {
        TaggedController.to.refreshTaggedPhotos();
        TabsController.to.refreshUntaggedList();
        SwiperTabController.to.refresh();
      });

      await Analytics.sendEvent(Event.deleted_photo);
      // //print('Reaction!');
      selectedMultiBarPics.clear();
      //setTrashedPic(true);
    }
  }

  void removePicFromUI(String picId) {
    assetMap.remove(picId);
    allUnTaggedPicsMonth.remove(picId);
    allUnTaggedPicsDay.remove(picId);
    allUnTaggedPics.remove(picId);
    assetEntityList.removeWhere((element) => element.id == picId);
    var index = SwiperTabController.to.swipeIndex.value;
    SwiperTabController.to.swiperPicIdList.remove(picId);
    TaggedController.to.picWiseTags.remove(picId);
    if (SwiperTabController.to.swiperPicIdList.isNotEmpty) {
      SwiperTabController.to.swipeIndex.value = index + 1;
    }
  }

  Future<void> trashPic(String picId) async {
    var picStore = picStoreMap[picId]?.value;
    picStore ??= explorPicStore(picId).value;
    if (null != picStore) {
      // //print('Going to trash pic!');
      await picStore.deletePic();
      // //print('Deleted pic: $deleted');

      /* if (deleted) {
      filteredPics.remove(picStore);
      removePicFromTaggedPics(picStore: picStore, forceDelete: true);
      swipePics.remove(picStore);
      removePicFromUntaggedPics(picStore: picStore);
      allPics.value.remove(picStore);
      user.setDefaultWidgetImage(allPics.value[0].entity.value);
    } */

      await Analytics.sendEvent(Event.deleted_photo);
    }
    // //print('Reaction!');
    //setTrashedPic(true);
  }
}

Future<void> sharePics({required List<String> picKeys}) async {
  var imageList = <String>[], mimeList = <String>[];

  for (var picKey in picKeys) {
    if (TabsController.to.assetMap[picKey] == null) {
      continue;
    }
    final data = TabsController.to.assetMap[picKey]; //.entity.value;

    if (data == null) {
      /*  var bytes = await TabsController
          .to.picAssetOriginBytesMap[picKey] /* .assetOriginBytes */;
      String path = await _writeByteToImageFile(bytes);
      imageList.add(path);
      mimeList.add(lookupMimeType(path)); */
    } else {
      // var bytes = await data.thumbDataWithSize(
      //   600,
      //   800,
      //   format: ThumbFormat.jpeg,
      // );
      // String path = await _writeByteToImageFile(bytes);
      var path = (await data.file)?.path;
      if (path != null) {
        final mime = lookupMimeType(path);
        if (mime != null) {
          imageList.add(path);
          mimeList.add(mime);
        }
      }
    }

//      if (Platform.isAndroid) {
//        var bytes = await data.originBytes;
//        bytesPhotos['$x.jpg'] = bytes;
//      } else {
//        var bytes = await data.thumbDataWithSize(
//          data.size.width.toInt(),
//          data.size.height.toInt(),
//          format: ThumbFormat.jpeg,
//        );
//        bytesPhotos['$x.jpg'] = bytes;
//      }
//      x++;
  }

  // //print('Image List: $imageList');
  // //print('Mime List: $mimeList');

  await Analytics.sendEvent(Event.shared_photos);

  await Share.shareFiles(
    imageList,
    mimeTypes: mimeList,
  );

//    setSharedPic(true);

  return;
}

/* Future<void> checkIsLibraryUpdated() async {
  // //print('Scanning library again....');

  final List<AssetPathEntity> assets = await PhotoManager.getAssetPathList(
    hasAll: true,
    type: RequestType.image,
    onlyAll: true,
  );

  final AssetPathEntity assetPathEntity = assets[0];
  final List<AssetEntity> assetList = await assetPathEntity.getAssetListRange(
      start: 0, end: assetPathEntity.assetCount);
  final Set<String> entitiesIds = assetList.map((e) => e.id).toSet();
  final bool isEqual =
      SetEquality().equals(entitiesIds, allPics.value.keys.toSet());

  if (isEqual) {
    // //print('Library is updated!!!!!!');
    // //print('#@#@#@# Total photos: ${allPics.value.length}');
  } else {
    // //print('Library not updated!!!');

    final Set<String> createdPics =
        entitiesIds.difference(allPics.value.keys.toSet());
    final Set<String> deletedPics =
        allPics.value.keys.toSet().difference(entitiesIds);

    // //print('Created: $createdPics');
    // //print('Deleted: $deletedPics');

    for (String created in createdPics) {
      AssetEntity entity = await AssetEntity.fromId(created);
      addEntity(entity);
    }

    for (String deleted in deletedPics) {
      deleteEntity(deleted);
    }
  }

  await loadPrivateAssets();
} */

Future<String> _writeByteToImageFile(Uint8List byteData) async {
  var tempDir = await getTemporaryDirectory();
  var imageFile = File(
      '${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
  imageFile.createSync(recursive: true);
  imageFile.writeAsBytesSync(byteData);
  return imageFile.path;
}
