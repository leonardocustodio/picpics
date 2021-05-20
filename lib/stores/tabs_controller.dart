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
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/utils/enum.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

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
  final showPrivatePics = false.obs;
  final multiPicBar = false.obs;
  final multiTagSheet = false.obs;
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
  final allUnTaggedPicsMonth = <dynamic, dynamic>{}.obs;
  final allUnTaggedPicsDay = <dynamic, dynamic>{}.obs;

  // picId: assetPathEntity
  final assetMap = <String, AssetEntity>{}.obs;
  List<AssetEntity> assetEntityList = <AssetEntity>[];
  //final picAssetOriginBytesMap = <String, Future<Uint8List>>{}.obs;

  //@action
  final starredPicMap = <String, bool>{}.obs;

  final expandableController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));
  final expandablePaddingController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));

  @override
  void onReady() {
    initialization();
    super.onReady();
  }

  Future<void> initialization() async {
    await initPlatformState();
    await loadAssetPath();

    ever(showPrivatePics, (_) {
      refreshUntaggedList();
    });

    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (multiTagSheet.value) {
        expandablePaddingController.value.expanded = visible;
      }
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
        //print('show delete secret modal!!!');
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserController.to.tryBuyId != null) {
        Get.to(() => PremiumScreen());
      }
    });
  }

  Future<void> getDataForPic(String picId) async {}

  //@action
  Future<void> loadEntities(List<AssetPathEntity> assetsPath) async {
    if (assetsPath.isEmpty) {
      status.value = Status.DeviceHasNoPics;
      return;
    }

    AssetPathEntity assetPathEntity = assetsPath[0];

    assetPathEntity
        .getAssetListRange(start: 0, end: assetPathEntity.assetCount)
        .then((list) async {
      assetEntityList = await List<AssetEntity>.from(list);
      await refreshUntaggedList();
    });
  }

  Future<void> refreshUntaggedList() async {
    isUntaggedPicsLoaded.value = false;
    allUnTaggedPicsMonth.clear();
    allUnTaggedPicsDay.clear();
    assetEntityList.sort((a, b) {
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

    /// refreshing the taggedPhotos so that we can filter out the untagged photos from the below section.
    await TaggedController.to.refreshTaggedPhotos();

    DateTime previousDay, previousMonth;
    List<String> previousMonthPicIdList = <String>[];
    List<String> previousDayPicIdList = <String>[];

    /// clear the map as this function will be used to refresh from the tagging done via expandable or the swiper tags

    assetEntityList.forEach((entity) {
      assetMap[entity.id] = entity;
      if (TaggedController.to.allTaggedPicIdList[entity.id] != null) {
        print('${entity.id}');
      }
      if (TaggedController.to.allTaggedPicIdList[entity.id] == null &&
          (privatePhotoIdMap[entity.id] == null || showPrivatePics.value)) {
        var dateTime = DateTime.utc(entity.createDateTime.year,
            entity.createDateTime.month, entity.createDateTime.day);
        if (previousDay == null || previousMonth == null) {
          previousDay = dateTime;
          previousMonth = dateTime;
          /* allUnTaggedPicsDay[dateTime] = '';
          allUnTaggedPicsMonth[dateTime] = ''; */
          allUnTaggedPicsMonth[dateTime] = <String>[];
          allUnTaggedPicsDay[dateTime] = <String>[];
        }

        if (previousDay.year != dateTime.year ||
            previousDay.month != dateTime.month ||
            previousDay.day != dateTime.day) {
          if (previousDay.day != dateTime.day) {
            //allUnTaggedPicsDay[dateTime] = '';
            allUnTaggedPicsDay[previousDay] =
                List<String>.from(previousDayPicIdList);
            previousDayPicIdList = <String>[];
            allUnTaggedPicsDay[dateTime] = <String>[];
          }
          if (previousDay.month != dateTime.month) {
            //allUnTaggedPicsMonth[dateTime] = '';
            allUnTaggedPicsMonth[previousMonth] =
                List<String>.from(previousMonthPicIdList);
            previousMonthPicIdList = <String>[];
            allUnTaggedPicsMonth[dateTime] = <String>[];
            previousMonth = dateTime;
          }
          previousDay = dateTime;
        }
        allUnTaggedPicsMonth[entity.id] = '';
        allUnTaggedPicsDay[entity.id] = '';
        previousMonthPicIdList.add(entity.id);
        previousDayPicIdList.add(entity.id);
      }
      //status.value = Status.Loaded;
      isUntaggedPicsLoaded.value = true;
    });

    allUnTaggedPicsMonth[previousMonth] =
        List<String>.from(previousMonthPicIdList);
    allUnTaggedPicsDay[previousDay] = List<String>.from(previousDayPicIdList);
  }

  //final picAssetThumbBytesMap = <String, Future<Uint8List>>{}.obs;
/* 
  void addOriginBytesMap(String picId, Future<Uint8List> uint8List) {
    if (picAssetOriginBytesMap[picId] == null) {
      picAssetOriginBytesMap[picId] = uint8List;
      /* if (picAssetThumbBytesMap.length > 500) {
        print('removing pics');
        picAssetThumbBytesMap.remove(picAssetThumbBytesMap.keys.first);
      } */
    }
  }

  void addThumbBytesMap(String picId, Future<Uint8List> uint8List) {
    if (picAssetThumbBytesMap[picId] == null) {
      picAssetThumbBytesMap[picId] = uint8List;
      /* if (picAssetThumbBytesMap.length > 500) {
        print('removing pics');
        picAssetThumbBytesMap.remove(picAssetThumbBytesMap.keys.first);
      } */
    }
  } */

  void deletePic(String picId, bool removeFromGallery) {
    allUnTaggedPicsDay.remove(picId);
    allUnTaggedPicsMonth.remove(picId);
    secretPicIds.remove(picId);
    secretPicData.remove(picId);
    //picAssetThumbBytesMap.remove(picId);
    if (removeFromGallery) {}
  }

  /* Future<void> exploreOriginPic(String picId) async {
    /// if it is not secret pic
    if (secretPicIds[picId] != null) {
      if (!secretPicIds[picId]) {
        // not a secret pic
        addOriginBytesMap(picId, assetOriginBytes(false, assetMap[picId]));
        return;
      } else if (secretPicData[picId] != null) {
        // it is a secret pic as we had successfully found the data related to it
        addOriginBytesMap(
            picId,
            assetOriginBytes(true, assetMap[picId], secretPicData[picId].nonce,
                secretPicData[picId].thumbPath));
        return;
      }
    }

    Photo pic = await database.getPhotoByPhotoId(assetMap[picId].id);
    if (pic != null) {
      //print('pic $photoId exists, loading data....');
      //Pic pic = picsBox.get(photoId);

      /* latitude.value = pic.latitude;
      longitude.value = pic.longitude;
      specificLocation.value = pic.specificLocation;
      generalLocation.value = pic.generalLocation;
      isPrivate.value = pic.isPrivate ?? false;
      deletedFromCameraRoll = pic.deletedFromCameraRoll ?? false;
      isStarred.value = pic.isStarred ?? false; */

      //print('Is private: $isPrivate');
      /* for (String tagKey in pic.tags) {
        TagsStore tagsStore = UserController.to.tags[tagKey];
        if (tagsStore == null) {
          //print('&&&&##### DID NOT FIND TAG: ${tagKey}');
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
          //print('Setting private path to: $photoPath - Thumb: $thumbPath - Nonce: $nonce');
          /* picAssetOriginBytesMap[assetMap[picId].id] =
              assetOriginBytes(true, assetMap[picId], nonce, photoPath); */
          //await Crypto.decryptImage(photoPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
          addOriginBytesMap(
              picId, assetOriginBytes(true, assetMap[picId], nonce, thumbPath));
          //await Crypto.decryptImage(thumbPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
        }
      }
    }
    /* picAssetOriginBytesMap[assetMap[picId].id] =
        assetOriginBytes(false, assetMap[picId]); */
    //await entity.originBytes;
    addOriginBytesMap(picId, assetOriginBytes(false, assetMap[picId]));
    //await entity.thumbDataWithSize(kDefaultPreviewThumbSize[0], kDefaultPreviewThumbSize[1]);
  } */

  final picStoreMap = <String, Rx<PicStore>>{}.obs;

  /// Here only those picId will come who are untagged.
  Rx<PicStore> explorPicStore(String picId) {
    if (picStoreMap[picId] == null) {
      AssetEntity entity = assetMap[picId];

      PicStore pic = PicStore(
        isStarredValue: null,
        entityValue: entity,
        photoIdValue: entity.id,
        createdAt: entity.createDateTime,
        originalLatitude: entity.latitude,
        originalLongitude: entity.longitude,
      );
      picStoreMap[picId] = Rx<PicStore>(pic);
    }
    return picStoreMap[picId];
  }

  /* Future<void> exploreThumbPic_(String picId) async {
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
      //print('pic $photoId exists, loading data....');
      //Pic pic = picsBox.get(photoId);

      /* latitude.value = pic.latitude;
      longitude.value = pic.longitude;
      specificLocation.value = pic.specificLocation;
      generalLocation.value = pic.generalLocation;
      isPrivate.value = pic.isPrivate ?? false;
      deletedFromCameraRoll = pic.deletedFromCameraRoll ?? false;
      isStarred.value = pic.isStarred ?? false; */

      //print('Is private: $isPrivate');
      /* for (String tagKey in pic.tags) {
        TagsStore tagsStore = UserController.to.tags[tagKey];
        if (tagsStore == null) {
          //print('&&&&##### DID NOT FIND TAG: ${tagKey}');
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
          //print('Setting private path to: $photoPath - Thumb: $thumbPath - Nonce: $nonce');
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
  } */

  /* Future<Uint8List> assetOriginBytes(bool isPrivate, AssetEntity entity,
      [String nonce, String photoPath]) async {
    if (isPrivate == false && entity != null) {
      return await entity.originBytes;
    }
    //print('Returning decrypt image in privatePath: $photoPath');
    return await Crypto.decryptImage(
        photoPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
  }

  Future<Uint8List> assetThumbBytes(bool isPrivate, AssetEntity entity,
      [String nonce, String thumbPath]) async {
    if (isPrivate == false && entity != null) {
      return await entity.thumbDataWithSize(
          kDefaultPreviewThumbSize[0], kDefaultPreviewThumbSize[1]);
    }
    //print('Returning decrypt image in privatePath: $thumbPath');
    return await Crypto.decryptImage(
        thumbPath, UserController.to.encryptionKey, Nonce(hex.decode(nonce)));
  } */

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
    //print('sharing selected pics....');
    setIsLoading(true);
    await sharePics(picKeys: selectedUntaggedPics.keys.toList()
        /* picsStores: GalleryStore.to.selectedPics.toList() */);
    setIsLoading(false);
  }

  void trashAction() {
    if (GalleryStore.to.selectedPics.isEmpty) {
      return;
    }
    GalleryStore.to
        .trashMultiplePics(GalleryStore.to.selectedPics.value.toSet());
  }

  bool get deviceHasPics {
    return assetMap.isNotEmpty;
  }

  void clearSelectedUntaggedPics() {
    selectedUntaggedPics.clear();
  }

  setTabIndex(int index) async {
    if (!deviceHasPics || selectedUntaggedPics.isEmpty) {
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
        //GalleryStore.to.clearSelectedPics();
        setMultiPicBar(false);
      } else if (index == 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setMultiTagSheet(true);
          expandableController.value.expanded = true;
          expandablePaddingController.value.expanded = true;
        });
      } else if (index == 2) {
        if (/* GalleryStore.to.selectedPics */ selectedUntaggedPics.isEmpty) {
          return;
        }
        //print('sharing selected pics....');
        setIsLoading(true);
        await sharePics(picKeys: selectedUntaggedPics.keys.toList()
            /* picsStores: GalleryStore.to.selectedPics.toList() */);
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

Future<void> sharePics({@required List<String> picKeys}) async {
  var imageList = <String>[], mimeList = <String>[];

  for (String picKey in picKeys) {
    if (TabsController.to.assetMap[picKey] == null) {
      continue;
    }
    AssetEntity data = TabsController.to.assetMap[picKey]; //.entity.value;

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

      String path = (await data.file).path;
      String mime = lookupMimeType(path);
      imageList.add(path);
      mimeList.add(mime);
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

  Analytics.sendEvent(Event.shared_photos);

  Share.shareFiles(
    imageList,
    mimeTypes: mimeList,
  );

//    setSharedPic(true);

  return;
}

Future<String> _writeByteToImageFile(Uint8List byteData) async {
  Directory tempDir = await getTemporaryDirectory();
  File imageFile = File(
      '${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
  imageFile.createSync(recursive: true);
  imageFile.writeAsBytesSync(byteData);
  return imageFile.path;
}
