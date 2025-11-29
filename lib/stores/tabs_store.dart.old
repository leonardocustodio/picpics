/* import 'package:background_fetch/background_fetch.dart';
import 'package:convert/convert.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:moor/moor.dart';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/managers/crypto_manager.dart';
import 'package:picpics/managers/push_notifications_manager.dart';
import 'package:picpics/managers/widget_manager.dart';
import 'package:picpics/screens/premium/premium_screen.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/stores/gallery_store.dart';
import 'package:picpics/utils/enum.dart';

import '../constants.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:picpics/utils/app_logger.dart';

class Debouncer {
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
}

class TabsController extends GetxController {
  static TabsController get to => Get.find();
  final currentTab = 0.obs;
  final toggleIndexUntagged = 0.obs;
  final toggleIndexTagged = 1.obs;
  final topOffsetFirstTab = 64.0.obs;
  final tutorialIndex = 0.obs;
  final multiPicBar = false.obs;
  final multiTagSheet = false.obs;
  final hideTitleThirdTab = false.obs;
  final showDeleteSecretModal = false.obs;
  final isScrolling = false.obs;
  final isToggleBarVisible = true.obs;
  final isLoading = false.obs;
  final isUntaggedPicsLoaded = false.obs;
  final modalCard = false.obs;
  final status = Status.Loading.obs;

  var privatePhotoIdMap = <String, String>{};
  final secretPicIds = <String, bool>{}.obs;
  final secretPicData = <String, Private>{}.obs;
  final selectedUntaggedPics = <String, bool>{}.obs;
  final photoPathMap = <String, String>{}.obs;

  AppDatabase database = AppDatabase();
  final allUnTaggedPicsMonth = <dynamic, String>{}.obs;
  final allUnTaggedPicsDay = <dynamic, String>{}.obs;

  // picId: assetPathEntity
  final assetMap = <String, AssetEntity>{}.obs;
  final picAssetOriginBytesMap = <String, Future<Uint8List>>{}.obs;

  final starredPicMap = <String, bool>{}.obs;

  ScrollController scrollControllerThirdTab;

  final expandableController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));
  final expandablePaddingController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));

  @override
  void onReady() {
    super.onReady();
    initPlatformState();
    loadAssetPath();

    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (multiTagSheet.value) {
        expandablePaddingController.value.expanded = visible;
      }
    });

    scrollControllerThirdTab =
        ScrollController(initialScrollOffset: offsetThirdTab);
    scrollControllerThirdTab.addListener(() {
      refreshGridPositionThirdTab();
    });

    ever(GalleryStore.to.trashedPic, (_) {
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
    });

    /*    disposer3 = reaction((_) => controller.showDeleteSecretModal, (showModal) {
      if (showModal) {
        AppLogger.d('show delete secret modal!!!');
//        setState(() {
//          showEditTagModal();
//        });
//        showDeleteSecretModal(context);
      }
    }); */

    if (UserController.to.tutorialCompleted == true &&
        UserController.to.notifications == true) {
      PushNotificationsManager push = PushNotificationsManager();
      push.init();
    }

    // Added for the case of buying premium from appstore
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (UserController.to.tryBuyId != null) {
        Get.to<void>(() => PremiumScreen());
      }
    });
    refreshGridPositionThirdTab();
  }

  Future<void> getDataForPic(String picId) async {}

  //@action
  Future<void> loadEntities(List<AssetPathEntity> assetsPath) async {
    if (assetsPath.isEmpty) {
      status.value = Status.DeviceHasNoPics;
      return;
    }

    AssetPathEntity assetPathEntity = assetsPath[0];

    final list = await assetPathEntity.getAssetListRange(
        start: 0, end: assetPathEntity.assetCount);

    list.sort((a, b) {
      var year = b.createDateTime.year.compareTo(a.createDateTime.year);
      if (year == 0) {
        var month = b.createDateTime.month.compareTo(a.createDateTime.month);
        if (month == 0) {
          var day = b.createDateTime.day.compareTo(a.createDateTime.day);
          return day;
        }
        return month;
      }
      return year;
    });

    var val = await database.getPrivatePhotoIdList();
    await Future.forEach(
        val, (photo) async => privatePhotoIdMap[photo.id] = '');
    DateTime previousDay;
    await Future.forEach(list, (entity) async {
      if (privatePhotoIdMap[entity.id] == null) {
        var dateTime = DateTime.utc(entity.createDateTime.year,
            entity.createDateTime.month, entity.createDateTime.day);
        if (previousDay == null) {
          previousDay = dateTime;
          allUnTaggedPicsDay[dateTime] = '';
          allUnTaggedPicsMonth[dateTime] = '';
        }
        if (previousDay.year != dateTime.year ||
            previousDay.month != dateTime.month ||
            previousDay.day != dateTime.day) {
          if (previousDay.day != dateTime.day) {
            allUnTaggedPicsDay[dateTime] = '';
          } else {
            allUnTaggedPicsMonth[dateTime] = '';
          }
          previousDay = dateTime;
        }
        assetMap[entity.id] = entity;
        allUnTaggedPicsMonth[entity.id] = '';
        allUnTaggedPicsDay[entity.id] = '';
      }
      status.value = await Status.Loaded;
      isUntaggedPicsLoaded.value = true;
    });
  }

  final picAssetThumbBytesMap = <String, Future<Uint8List>>{}.obs;

  void addThumbBytesMap(String picId, Future<Uint8List> uint8List) {
    if (picAssetThumbBytesMap[picId] == null) {
      picAssetThumbBytesMap[picId] = uint8List;
      /* if (picAssetThumbBytesMap.length > 500) {
        AppLogger.d('removing pics');
        picAssetThumbBytesMap.remove(picAssetThumbBytesMap.keys.first);
      } */
    }
  }

  void deletePic(String picId, bool removeFromGallery) {
    allUnTaggedPicsDay.remove(picId);
    allUnTaggedPicsMonth.remove(picId);
    secretPicIds.remove(picId);
    secretPicData.remove(picId);
    picAssetThumbBytesMap.remove(picId);
    if (removeFromGallery) {}
  }

  Future<void> exploreThumbPic(String picId) async {
    /// if it is not secret pic
    if (secretPicIds[picId] != null) {
      if (!secretPicIds[picId]) {
        // not a secret pic
        addThumbBytesMap(picId, assetThumbBytes(false, assetMap[picId]));
        return;
      } else if (secretPicData[picId] != null) {
        // it is a secret pic as we had successfully found the data related to it
        addThumbBytesMap(
            picId,
            assetThumbBytes(true, assetMap[picId], secretPicData[picId].nonce,
                secretPicData[picId].thumbPath));
        return;
      }
    }

    Photo pic = await database.getPhotoByPhotoId(assetMap[picId].id);
    if (pic != null) {
      AppLogger.d('pic $photoId exists, loading data....');
      //Pic pic = picsBox.get(photoId);

      /* latitude.value = pic.latitude;
      longitude.value = pic.longitude;
      specificLocation.value = pic.specificLocation;
      generalLocation.value = pic.generalLocation;
      isPrivate.value = pic.isPrivate ?? false;
      deletedFromCameraRoll = pic.deletedFromCameraRoll ?? false;
      isStarred.value = pic.isStarred ?? false; */

      AppLogger.d('Is private: $isPrivate');
      /* for (String tagKey in pic.tags) {
        TagsStore tagsStore = UserController.to.tags[tagKey];
        if (tagsStore == null) {
          AppLogger.d('&&&&##### DID NOT FIND TAG: ${tagKey}');
          continue;
        }

        /// TODO: tags[tagKey] = tagsStore;
      } */
      if (pic.isPrivate == true) {
        Private secretPic =
            await database.getPrivateByPhotoId(assetMap[picId].id);

        if (secretPic != null) {
          var thumbPath = secretPic.thumbPath;
          var nonce = secretPic.nonce;
          secretPicIds[assetMap[picId].id] = true;
          secretPicData[assetMap[picId].id] = secretPic;
          AppLogger.d('Setting private path to: $photoPath - Thumb: $thumbPath - Nonce: $nonce');
          /* picAssetOriginBytesMap[assetMap[picId].id] =
              assetOriginBytes(true, assetMap[picId], nonce, photoPath); */
          //await Crypto.decryptImage(photoPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
          addThumbBytesMap(
              picId, assetThumbBytes(true, assetMap[picId], nonce, thumbPath));
          //await Crypto.decryptImage(thumbPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
        }
      }
    }
    /* picAssetOriginBytesMap[assetMap[picId].id] =
        assetOriginBytes(false, assetMap[picId]); */
    //await entity.originBytes;
    addThumbBytesMap(picId, assetThumbBytes(false, assetMap[picId]));
    //await entity.thumbDataWithSize(kDefaultPreviewThumbSize[0], kDefaultPreviewThumbSize[1]);
  }

  Future<Uint8List> assetOriginBytes(bool isPrivate, AssetEntity entity,
      [String nonce, String photoPath]) async {
    if (isPrivate == false && entity != null) {
      return await entity.originBytes;
    }
    AppLogger.d('Returning decrypt image in privatePath: $photoPath');
    return await Crypto.decryptImage(
        photoPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
  }

  Future<Uint8List> assetThumbBytes(bool isPrivate, AssetEntity entity,
      [String nonce, String thumbPath]) async {
    if (isPrivate == false && entity != null) {
      return await entity.thumbDataWithSize(
          kDefaultPreviewThumbSize[0], kDefaultPreviewThumbSize[1]);
    }
    AppLogger.d('Returning decrypt image in privatePath: $thumbPath');
    return await Crypto.decryptImage(
        thumbPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
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
    FilterOptionGroup filterOptionGroup = FilterOptionGroup()
      ..addOrderOption(
        OrderOption(
          type: OrderOptionType.createDate,
          asc: false,
        ),
      );

    final List<AssetPathEntity> assets = await PhotoManager.getAssetPathList(
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
    BackgroundFetch.configure(
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
      AppLogger.d("[BackgroundFetch] Event received $taskId");

      await WidgetManager.sendAndUpdate();

      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      AppLogger.d('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      AppLogger.d('[BackgroundFetch] configure ERROR: $e');
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

  void refreshGridPositionThirdTab() {
    var offset = scrollControllerThirdTab.hasClients
        ? scrollControllerThirdTab.offset
        : scrollControllerThirdTab.initialScrollOffset;

    if (offset >= 40) {
      setHideTitleThirdTab(true);
    } else if (offset <= 0) {
      setHideTitleThirdTab(false);
    }

    if (scrollControllerThirdTab.hasClients) {
      offsetThirdTab = scrollControllerThirdTab.offset;
    }
  }

  //@action
  void setCurrentTab(int value) {
    if (currentTab.value != value) {
      if (currentTab.value == 1) {
        GalleryStore.to.setSwipeIndex(GalleryStore.to.swipeIndex.value);
      } else if (currentTab.value == 2) {
        GalleryStore.to.clearSearchTags();
      }

      Analytics.sendCurrentTab(value);
      currentTab.value = value;
    }
  }

  //@action
  void setMultiPicBar(bool value) {
    if (value) {
      Analytics.sendEvent(Event.selected_photos);
    }
    multiPicBar.value = value;
  }

  //@action
  void setMultiTagSheet(bool value) {
    multiTagSheet.value = value;
  }

  //@action
  void setIsLoading(bool value) {
    isLoading.value = value;
  }

  //@action
  void setModalCard(bool value) {
    Analytics.sendEvent(Event.showed_card);
    modalCard.value = value;
  }

  //@action
  void setTutorialIndex(int value) => tutorialIndex.value = value;

  double offsetFirstTab = 0.0;

  //@action
  void setTopOffsetFirstTab(double value) {
    if (value == topOffsetFirstTab) {
      return;
    }
    topOffsetFirstTab.value = value;
  }

  double offsetThirdTab = 0.0;

  //@action
  void setHideTitleThirdTab(bool value) {
    if (value == hideTitleThirdTab) {
      return;
    }
    hideTitleThirdTab.value = value;
  }

  //@action
  void setShowDeleteSecretModal(bool value) =>
      showDeleteSecretModal.value = value;

  //@action
  void setIsScrolling(bool value) => isScrolling.value = value;

  //@action
  void setIsToggleBarVisible(bool value) => isToggleBarVisible.value = value;

  //@action
  void setToggleIndexUntagged(int value) => toggleIndexUntagged.value = value;

  //@action
  void setToggleIndexTagged(int value) => toggleIndexTagged.value = value;

  void returnAction() {
    GalleryStore.to.clearSelectedPics();
    setMultiPicBar(false);
  }

  Future<void> starredAction() async {
    await WidgetManager.saveData(
        picsStores: GalleryStore.to.selectedPics.toList());
    GalleryStore.to.clearSelectedPics();
    setMultiPicBar(false);
  }

  void tagAction() {
    setMultiTagSheet(true);
    Future.delayed(Duration(milliseconds: 200), () {
      expandableController.value.expanded = true;
    });
  }

  Future<void> shareAction() async {
    if (GalleryStore.to.selectedPics.isEmpty) {
      return;
    }
    AppLogger.d('sharing selected pics....');
    setIsLoading(true);
    await GalleryStore.to
        .sharePics(picsStores: GalleryStore.to.selectedPics.toList());
    setIsLoading(false);
  }

  void trashAction() {
    if (GalleryStore.to.selectedPics.isEmpty) {
      return;
    }
    GalleryStore.to
        .trashMultiplePics(GalleryStore.to.selectedPics.value.toSet());
  }

  setTabIndex(int index) async {
    if (!GalleryStore.to.deviceHasPics.value) {
      setCurrentTab(index);
      return;
    }

    if (multiPicBar.value) {
      if (index == 0) {
        GalleryStore.to.clearSelectedPics();
        setMultiPicBar(false);
      } else if (index == 1) {
        setMultiTagSheet(true);
        Future.delayed(Duration(milliseconds: 200), () {
          expandableController.value.expanded = true;
        });
      } else if (index == 2) {
        if (GalleryStore.to.selectedPics.isEmpty) {
          return;
        }
        AppLogger.d('sharing selected pics....');
        setIsLoading(true);
        await GalleryStore.to
            .sharePics(picsStores: GalleryStore.to.selectedPics.toList());
        setIsLoading(false);
      } else if (index == 3) {
        if (GalleryStore.to.selectedPics.isEmpty) {
          return;
        }
        GalleryStore.to
            .trashMultiplePics(GalleryStore.to.selectedPics.value.toSet());
      }
      return;
    }

    setCurrentTab(index);
  }
/* 
  setTabIndex(int index) {
    if (!GalleryStore.to.deviceHasPics.value) {
      setCurrentTab(index);
      return;
    }

    if (multiPicBar.value) {
      if (index == 0) {
        returnAction();
      } else if (index == 1) {
        if (currentTab.value == 0) {
          tagAction();
        } else {
          starredAction();
        }
      } else if (index == 2) {
        if (currentTab.value == 0) {
          shareAction();
        } else {
          tagAction();
        }
      } else if (index == 3) {
        if (currentTab.value == 0) {
          trashAction();
        } else {
          shareAction();
        }
      } else if (index == 4) {
        trashAction();
      }
      return;
    }

    setCurrentTab(index);
  } */
}
 */
