import 'package:background_fetch/background_fetch.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/managers/push_notifications_manager.dart';
import 'package:picPics/managers/widget_manager.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';

class TabsStore extends GetxController {
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
  final modalCard = false.obs;

  ScrollController scrollControllerThirdTab;

  final expandableController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));
  final expandablePaddingController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));

  @override
  void onInit() {
    initPlatformState();

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
        //print('show delete secret modal!!!');
//        setState(() {
//          showEditTagModal();
//        });
//        showDeleteSecretModal(context);
      }
    }); */

    if (AppStore.to.tutorialCompleted == true &&
        AppStore.to.notifications == true) {
      PushNotificationsManager push = PushNotificationsManager();
      push.init();
    }

    // Added for the case of buying premium from appstore
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (AppStore.to.tryBuyId != null) {
        Get.toNamed(PremiumScreen.id);
      }
    });
    refreshGridPositionThirdTab();

    super.onInit();
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
    //print('sharing selected pics....');
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
        //print('sharing selected pics....');
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
