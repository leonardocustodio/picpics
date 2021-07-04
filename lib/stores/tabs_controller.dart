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
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/swiper_tab_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/model/tag_model.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/refresh_everything.dart';
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
  final toggleIndexUntagged = 0.obs;
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

  //var privatePhotoIdMap = <String, String>{};
  /* final secretPicIds = <String, bool>{}.obs;
  final secretPicData = <String, Private>{}.obs; */
  final selectedMultiBarPics = <String, bool>{}.obs;
  //final photoPathMap = <String, String>{}.obs;

  final picStoreMap = <String, Rx<PicStore>>{}.obs;

  AppDatabase database = AppDatabase();
  final allUnTaggedPicsMonth = <dynamic, dynamic>{}.obs;
  final allUnTaggedPicsDay = <dynamic, dynamic>{}.obs;
  final allUnTaggedPics = <String, String>{}.obs;

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
    /// I know below line is redundant but it is used to kickstart initialization of the tags list.
    var _ = TagsController.to.allTags;
    var __ = TaggedController.to.taggedPicId;
    initialization();
    super.onReady();
  }

  Future<void> initialization() async {
    await initPlatformState();
    await BlurHashController.to.loadBlurHash();
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

  Future<void> getDataForPic(String picId) async {}

  //@action
  Future<void> loadEntities(List<AssetPathEntity> assetsPath) async {
    if (assetsPath.isEmpty) {
      status.value = Status.DeviceHasNoPics;
      return;
    }

    var assetPathEntity = assetsPath[0];

    await assetPathEntity
        .getAssetListRange(start: 0, end: assetPathEntity.assetCount)
        .then((list) async {
      assetEntityList = List<AssetEntity>.from(list);
      await refreshUntaggedList();
    });
  }

  Future<void> refreshUntaggedList() async {
    isUntaggedPicsLoaded.value = false;
    allUnTaggedPics.clear();
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

    /* var val = await database.getPrivatePhotoList();
    await Future.forEach(
        val, (photo) async => privatePhotoIdMap[photo.id] = ''); */

    /// refreshing the taggedPhotos so that we can filter out the untagged photos from the below section.
    await TaggedController.to.refreshTaggedPhotos();

    DateTime? previousDay;
    DateTime? previousMonth;

    var previousMonthPicIdList = <String>[];
    var previousDayPicIdList = <String>[];

    /// clear the map as this function will be used to refresh from the tagging done via expandable or the swiper tags

    assetEntityList.forEach((entity) {
      assetMap[entity.id] = entity;
      if (TaggedController.to.allTaggedPicIdList[entity.id] != null) {
        print('${entity.id}');
      }

      /// Iterating and checking whether the picId is not a tagged pic or it's not a private pic
      if (TaggedController.to.allTaggedPicIdList[entity.id] == null &&
          PrivatePhotosController.to.privateMap[entity.id] == null) {
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

        if (previousDay!.year != dateTime.year ||
            previousDay!.month != dateTime.month ||
            previousDay!.day != dateTime.day) {
          if (previousDay!.day != dateTime.day) {
            //allUnTaggedPicsDay[dateTime] = '';
            allUnTaggedPicsDay[previousDay] =
                List<String>.from(previousDayPicIdList);
            previousDayPicIdList = <String>[];
            allUnTaggedPicsDay[dateTime] = <String>[];
          }
          if (previousDay!.month != dateTime.month) {
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
        allUnTaggedPics[entity.id] = '';
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

  void deletePic(String picId, bool removeFromGallery) {
    allUnTaggedPicsDay.remove(picId);
    allUnTaggedPicsMonth.remove(picId);
    /* secretPicIds.remove(picId);
    secretPicData.remove(picId); */
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

  /// Here only those picId will come who are untagged.
  Rx<PicStore?> explorPicStore(String picId) {
    var picStoreValue = picStoreMap[picId];

    if (null == picStoreMap[picId]) {
      final entity = assetMap[picId];
      if (null == entity) {
        /// TODO: In worst case scenario this is telling that the asset map is not update and does not contain the image
        refresh_everything();
      }

      picStoreValue = Rx<PicStore>(PicStore(
        entityValue: entity!,
        createdAt: entity.createDateTime,
        originalLatitude: entity.latitude,
        originalLongitude: entity.longitude,
        photoId: null,
        photoPath: '',
        thumbPath: '',
      ));
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        var map = RxMap<String, Rx<TagModel>>();
        TaggedController
            .to.picWiseTags[picStoreValue!.value.photoId.value]?.keys
            .toList()
            .forEach((tagKey) {
          map[tagKey] = TagsController.to.allTags[tagKey]!;
        });
        picStoreValue.value.tags = map;
        picStoreMap[picId] = picStoreValue;

        if (BlurHashController.to.blurHash[picId] == null) {
          await picStoreValue.value.assetThumbBytes.then((imageBytes) {
            if (null != imageBytes) {
              BlurHashController.to.createBlurHash(picId, imageBytes);
            }
          });
        }
      });
    }
    return picStoreValue!;
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

  //@action
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
    if (value == topOffsetFirstTab.value) {
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
    await sharePics(picKeys: selectedMultiBarPics.keys.toList()
        /* picsStores: GalleryStore.to.selectedPics.toList() */);
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
        //GalleryStore.to.clearSelectedPics();
        setMultiPicBar(false);
      } else if (index == 1) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          setMultiTagSheet(true);
          expandableController.value.expanded = true;
          expandablePaddingController.value.expanded = true;
        });
      } else if (index == 2) {
        if (/* GalleryStore.to.selectedPics */ selectedMultiBarPics.isEmpty) {
          return;
        }
        //print('sharing selected pics....');
        setIsLoading(true);
        await sharePics(picKeys: selectedMultiBarPics.keys.toList()
            /* picsStores: GalleryStore.to.selectedPics.toList() */);
        setIsLoading(false);
      } else if (index == 3) {
        if (selectedMultiBarPics.isEmpty) {
          return;
        }

        await trashMultiplePics(selectedMultiBarPics.keys.toList().toSet());
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
              var picTags = List<String>.from(pic.tags);
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
      ]);

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
    TaggedController.to.refreshTaggedPhotos();
    TabsController.to.refreshUntaggedList();
    SwiperTabController.to.refresh();
    if (SwiperTabController.to.swiperPicIdList.isNotEmpty) {
      SwiperTabController.to.swipeIndex.value = index + 1;
    }
  }

  //@action
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
