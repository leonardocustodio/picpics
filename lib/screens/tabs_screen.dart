import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/managers/push_notifications_manager.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/screens/tabs/pic_tab.dart';
import 'package:picPics/screens/tabs/tagged_tab.dart';
import 'package:picPics/screens/tabs/untagged_tab.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/functions.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/show_edit_label_dialog.dart';
import 'package:picPics/widgets/delete_secret_modal.dart';
import 'package:picPics/widgets/photo_card.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/widgets/unhide_secret_modal.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/managers/widget_manager.dart';
import 'package:picPics/throttle.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:picPics/generated/l10n.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:background_fetch/background_fetch.dart';

class TabsScreen extends GetView<TabsStore> {
  static const id = 'tabs_screen';

  // Swiper do Tutorial
  SwiperController tutorialSwiperController = SwiperController();
  TextEditingController tagsEditingController = TextEditingController();
  TextEditingController bottomTagsEditingController = TextEditingController();

  Throttle _changeThrottle;
  AppLifecycleState _appCycleState;

  /*  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      //print('keyboard: $visible');

      if (visible && controller.multiTagSheet) {
        setState(() {
         controller. expandablePaddingController.value.expanded = true;
        });
      } else if (!visible && controller.multiTagSheet) {
        setState(() {
         controller. expandablePaddingController.value.expanded = false;
        });
      }
    }); */

//    _changeThrottle = Throttle(onCall: _onAssetChange);
//    PhotoManager.addChangeCallback(_changeThrottle.call);

  // RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
  //   if (event == RewardedVideoAdEvent.loaded) {
  //print('@@@ loaded');
  //   }
  //
  //   if (event == RewardedVideoAdEvent.rewarded) {
  //print('@@@ rewarded');
  //     AppStore.to.setCanTagToday(true);
  //   }
  //
  //   if (event == RewardedVideoAdEvent.closed) {
  //print('@@@@ closed');
  //     DatabaseManager.instance.adsIsLoaded = false;
  //     Ads.loadRewarded();
  //   }
  //
  //   if (event == RewardedVideoAdEvent.failedToLoad) {
  //print('@@@ failed');
  //     DatabaseManager.instance.adsIsLoaded = false;
  //   }
  // };

  //initPlatformState();
  //}

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

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey[400],
        ),
      ),
    );
  }
/* 
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppStore to.= Provider.of<AppStore>(context);
    controller = Provider.of<TabsStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);

    disposer = reaction((_) => galleryStore.trashedPic, (trashedPic) {
      if (trashedPic) {
        if (controller.modalCard) {
          controller.setModalCard(false);
        }
        if (controller.currentTab != 1) {
          galleryStore.setTrashedPic(false);
        }
      }
    });

    disposer2 = reaction((_) => galleryStore.sharedPic, (sharedPic) {
      if (sharedPic) {
        if (controller.multiPicBar) {
          galleryStore.clearSelectedPics();
          controller.setMultiPicBar(false);
        }
      }
    });

    disposer3 = reaction((_) => controller.showDeleteSecretModal, (showModal) {
      if (showModal) {
        //print('show delete secret modal!!!');
//        setState(() {
//          showEditTagModal();
//        });
//        showDeleteSecretModal(context);
      }
    });

    disposer4 = reaction((_) => appStore.secretPhotos, (secretPhotos) {
      if (secretPhotos) {
        if (appStore.hasObserver == false) {
          //print('adding observer to change screen!');
          WidgetsBinding.instance.addObserver(this);
          appStore.hasObserver = true;
        }
      } else {
        if (appStore.hasObserver == true) {
          //print('removing observer of changing screen');
          WidgetsBinding.instance.removeObserver(this);
          appStore.hasObserver = false;
        }
      }
    });

    if (appStore.tutorialCompleted == true && appStore.notifications == true) {
      PushNotificationsManager push = PushNotificationsManager();
      push.init();
    }

    // Added for the case of buying premium from appstore
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (appStore.tryBuyId != null) {
        Get.toNamed( PremiumScreen.id);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /* switch (state) {
      case AppLifecycleState.paused:
        //print("&&&& Paused");
         setState(() {
          _appCycleState = state;
        }); 
        break;
      case AppLifecycleState.inactive:
        setState(() {
          _appCycleState = state;
        });
        //print("&&& inactive");
        break;
      case AppLifecycleState.detached:
        setState(() {
          _appCycleState = state;
        });
        //print("&&&& detached");
        break;
      case AppLifecycleState.resumed:
        setState(() {
          _appCycleState = state;
        });
        //print("&&&& resumed");
        break;
    } */

    setState(() {
      _appCycleState = state;
    });
  } */

  @override
  Widget build(BuildContext context) {
    // if (_appCycleState == AppLifecycleState.inactive) {
    //   return Scaffold();
    // }

    Locale myLocale = Localizations.localeOf(context);
    //print('Language Code: ${myLocale.languageCode}');

    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var height = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Scaffold(
          bottomNavigationBar: Obx(() {
            return controller.multiTagSheet.value
                ? ExpandableNotifier(
                    child: Container(
                      color: Color(0xF1F3F5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              controller.expandableController.value.expanded =
                                  !controller
                                      .expandableController.value.expanded;
                            },
                            child: SafeArea(
                              bottom: !controller
                                  .expandableController.value.expanded,
                              child: Container(
                                color: Color(0xFFF1F3F5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CupertinoButton(
                                      onPressed: () {
                                        controller.setMultiTagSheet(false);
                                      },
                                      child: Container(
                                        width: 80.0,
                                        child: Text(
                                          S.of(context).cancel,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: 16,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    CupertinoButton(
                                      onPressed: () {
                                        // if (!AppStore.to.isPremium) {
                                        //   Get.toNamed(  PremiumScreen.id);
                                        //   return;
                                        // }

                                        if (GalleryStore.to.multiPicTags
                                                .value[kSecretTagKey] !=
                                            null) {
                                          showDeleteSecretModalForMultiPic(
                                              context, controller);
                                          return;
                                        }

                                        controller.setMultiTagSheet(false);
                                        controller.setMultiPicBar(false);
                                        GalleryStore.to.addTagsToSelectedPics();
                                      },
                                      child: Container(
                                        width: 80.0,
                                        child: Text(
                                          S.of(context).ok,
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: 16,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expandable(
                            controller: controller.expandableController.value,
                            expanded: Container(
                              padding: const EdgeInsets.all(24.0),
                              color: Color(0xFFEFEFF4).withOpacity(0.94),
                              child: SafeArea(
                                bottom: true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TagsList(
                                        tags: GalleryStore
                                            .to.multiPicTags.values
                                            .toList(),
                                        addTagField: true,
                                        textEditingController:
                                            bottomTagsEditingController,
                                        showEditTagModal: () =>
                                            showEditTagModal(context),
                                        onTap: (tagId, tagName) {
                                          // if (!AppStore.to.isPremium) {
                                          //   Get.toNamed(  PremiumScreen.id);
                                          //   return;
                                          // }
                                          //print('do nothing');
                                        },
                                        onPanEnd: () {
                                          // if (!AppStore.to.isPremium) {
                                          //   Get.toNamed(  PremiumScreen.id);
                                          //   return;
                                          // }
                                          GalleryStore.to
                                              .removeFromMultiPicTags(
                                                  DatabaseManager
                                                      .instance.selectedTagKey);
                                        },
                                        onDoubleTap: () {
                                          // if (!AppStore.to.isPremium) {
                                          //   Get.toNamed(  PremiumScreen.id);
                                          //   return;
                                          // }
                                          //print('do nothing');
                                        },
                                        onChanged: (text) {
                                          GalleryStore.to.setSearchText(text);
                                        },
                                        onSubmitted: (text) {
                                          // if (!AppStore.to.isPremium) {
                                          //   Get.toNamed(  PremiumScreen.id);
                                          //   return;
                                          // }
                                          if (text != '') {
                                            bottomTagsEditingController.clear();
                                            GalleryStore.to.setSearchText('');
                                            String tagKey =
                                                Helpers.encryptTag(text);

                                            if (GalleryStore
                                                    .to.multiPicTags[tagKey] ==
                                                null) {
                                              if (AppStore
                                                      .to.tags.value[tagKey] ==
                                                  null) {
                                                //print('tag does not exist! creating it!');
                                                GalleryStore.to.createTag(text);
                                              }
                                              GalleryStore.to
                                                  .addToMultiPicTags(tagKey);
                                            }
                                          }
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: TagsList(
                                        title: GalleryStore.to.searchText != ''
                                            ? S.of(context).search_results
                                            : S.of(context).recent_tags,
                                        tags: GalleryStore.to.tagsSuggestions,
                                        tagStyle: TagStyle.GrayOutlined,
                                        showEditTagModal: () =>
                                            showEditTagModal(context),
                                        onTap: (tagId, tagName) {
                                          // if (!AppStore.to.isPremium) {
                                          //   Get.toNamed(  PremiumScreen.id);
                                          //   return;
                                          // }

                                          bottomTagsEditingController.clear();
                                          GalleryStore.to.setSearchText('');
                                          GalleryStore.to
                                              .addToMultiPicTags(tagId);
                                        },
                                        onDoubleTap: () {
                                          // if (!AppStore.to.isPremium) {
                                          //   Get.toNamed(  PremiumScreen.id);
                                          //   return;
                                          // }
                                          //print('do nothing');
                                        },
                                        onPanEnd: () {
                                          // if (!AppStore.to.isPremium) {
                                          //   Get.toNamed(  PremiumScreen.id);
                                          //   return;
                                          // }
                                          //print('do nothing');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expandable(
                            controller:
                                controller.expandablePaddingController.value,
                            expanded: Container(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Obx(() {
                    if (!controller.multiPicBar.value) {
                      return Platform.isIOS
                          ? CupertinoTabBar(
                              currentIndex: controller.currentTab.value,
                              onTap: (index) {
                                controller.setTabIndex(index);
                              },
                              iconSize: 32.0,
                              border: Border(
                                  top: BorderSide(
                                      color: Color(0xFFE2E4E5), width: 1.0)),
                              items: <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  //title: Container(),
                                  icon: Image.asset(
                                      'lib/images/untaggedtabinactive.png'),
                                  activeIcon: Image.asset(
                                      'lib/images/untaggedtabactive.png'),
                                ),
                                BottomNavigationBarItem(
                                  //title: Container(),
                                  icon: Image.asset(
                                      'lib/images/pictabinactive.png'),
                                  activeIcon: Image.asset(
                                      'lib/images/pictabactive.png'),
                                ),
                                BottomNavigationBarItem(
                                  //title: Container(),
                                  icon: Image.asset(
                                      'lib/images/taggedtabinactive.png'),
                                  activeIcon: Image.asset(
                                      'lib/images/taggedtabactive.png'),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 64.0,
                              child: BottomNavigationBar(
                                currentIndex: controller.currentTab.value,
                                onTap: (index) {
                                  controller.setTabIndex(index);
                                },
                                type: BottomNavigationBarType.fixed,
                                showSelectedLabels: false,
                                showUnselectedLabels: false,
                                iconSize: 32.0,
                                items: <BottomNavigationBarItem>[
                                  BottomNavigationBarItem(
                                    label: 'Untagged photos',
                                    icon: Image.asset(
                                        'lib/images/untaggedtabinactive.png'),
                                    activeIcon: Image.asset(
                                        'lib/images/untaggedtabactive.png'),
                                  ),
                                  BottomNavigationBarItem(
                                    label: 'Swipe photos',
                                    icon: Image.asset(
                                        'lib/images/pictabinactive.png'),
                                    activeIcon: Image.asset(
                                        'lib/images/pictabactive.png'),
                                  ),
                                  BottomNavigationBarItem(
                                    label: 'Tagged photos',
                                    icon: Image.asset(
                                        'lib/images/taggedtabinactive.png'),
                                    activeIcon: Image.asset(
                                        'lib/images/taggedtabactive.png'),
                                  ),
                                ],
                              ),
                            );
                    }
                    return Platform.isIOS
                        ? CupertinoTabBar(
                            onTap: (index) {
                              controller.setTabIndex(index);
                            },
                            iconSize: 24.0,
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xFFE2E4E5), width: 1.0)),
                            items: <BottomNavigationBarItem>[
                              BottomNavigationBarItem(
                                //title: Container(),
                                icon: Image.asset(
                                    'lib/images/returntabbutton.png'),
                              ),
                              if (controller.currentTab == 2)
                                BottomNavigationBarItem(
                                  //title: Container(),
                                  icon: Image.asset('lib/images/starico.png'),
                                ),
                              BottomNavigationBarItem(
                                //title: Container(),
                                icon:
                                    Image.asset('lib/images/tagtabbutton.png'),
                              ),
                              BottomNavigationBarItem(
                                //title: Container(),
                                icon: GalleryStore.to.selectedPics.isEmpty
                                    ? Opacity(
                                        opacity: 0.2,
                                        child: Image.asset(
                                            'lib/images/sharetabbutton.png'),
                                      )
                                    : Image.asset(
                                        'lib/images/sharetabbutton.png'),
                              ),
                              BottomNavigationBarItem(
                                //title: Container(),
                                icon: GalleryStore.to.selectedPics.isEmpty
                                    ? Opacity(
                                        opacity: 0.3,
                                        child: Image.asset(
                                            'lib/images/trashtabbutton.png'),
                                      )
                                    : Image.asset(
                                        'lib/images/trashtabbutton.png'),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 64.0,
                            child: BottomNavigationBar(
                              onTap: (index) {
                                controller.setTabIndex(index);
                              },
                              type: BottomNavigationBarType.fixed,
                              showSelectedLabels: false,
                              showUnselectedLabels: false,
                              items: <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  label: 'Return',
                                  icon: Image.asset(
                                      'lib/images/returntabbutton.png'),
                                ),
                                if (controller.currentTab == 2)
                                  BottomNavigationBarItem(
                                    label: 'Feature',
                                    icon: Image.asset('lib/images/starico.png'),
                                  ),
                                BottomNavigationBarItem(
                                  label: 'Tag',
                                  icon: Image.asset(
                                      'lib/images/tagtabbutton.png'),
                                ),
                                BottomNavigationBarItem(
                                  label: 'Share',
                                  icon: GalleryStore.to.selectedPics.isEmpty
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              'lib/images/sharetabbutton.png'),
                                        )
                                      : Image.asset(
                                          'lib/images/sharetabbutton.png'),
                                ),
                                BottomNavigationBarItem(
                                  label: 'Trash',
                                  icon: GalleryStore.to.selectedPics.isEmpty
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              'lib/images/trashtabbutton.png'),
                                        )
                                      : Image.asset(
                                          'lib/images/trashtabbutton.png'),
                                ),
                              ],
                            ),
                          );
                  });
          }),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Stack(
              children: <Widget>[
                Obx(() {
                  Widget wgt;
                  if (AppStore.to.hasGalleryPermission == null ||
                      AppStore.to.hasGalleryPermission == false) {
                    wgt = Container(
                      constraints: BoxConstraints.expand(),
                      color: kWhiteColor,
                      child: SafeArea(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    onPressed: () {
                                      Get.toNamed(SettingsScreen.id);
                                    },
                                    child:
                                        Image.asset('lib/images/settings.png'),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30.0),
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxHeight: height / 2),
                                      child: Image.asset(
                                          'lib/images/nogalleryauth.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 21.0,
                                  ),
                                  Text(
                                    S
                                        .of(context)
                                        .gallery_access_permission_description,
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff979a9b),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 17.0,
                                  ),
                                  CupertinoButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      AppStore.to
                                          .requestGalleryPermission()
                                          .then((hasPermission) async {
                                        if (hasPermission) {
                                          await AppStore.to
                                              .requestNotificationPermission();
                                          await AppStore.to
                                              .checkNotificationPermission(
                                                  firstPermissionCheck: true);
                                          await AppStore.to
                                              .setTutorialCompleted(true);
                                          await GalleryStore.to
                                              .loadAssetsPath();
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 201.0,
                                      height: 44.0,
                                      decoration: BoxDecoration(
                                        gradient: kPrimaryGradient,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          S
                                              .of(context)
                                              .gallery_access_permission,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            color: kWhiteColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: -0.4099999964237213,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (controller.currentTab == 0 &&
                      AppStore.to.hasGalleryPermission.value)
                    wgt = UntaggedTab();
                  else if (controller.currentTab == 1 &&
                      AppStore.to.hasGalleryPermission.value)
                    wgt = PicTab(
                      showDeleteSecretModal: showDeleteSecretModal,
                    );
                  else if (controller.currentTab == 2 &&
                      AppStore.to.hasGalleryPermission.value)
                    wgt = TaggedTab(
                        showEditTagModal: () => showEditTagModal(context));
                  return wgt ?? Container();
                }),
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.modalCard.value) {
            return Material(
              color: Colors.transparent,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    controller.setModalCard(false);
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: SafeArea(
                      child: CarouselSlider.builder(
                        itemCount: controller.currentTab == 0
                            ? GalleryStore.to.swipePics.length
                            : GalleryStore.to.thumbnailsPics.length,
                        // carouselController: carouselController,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              //print('ignore');
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom:
                                    bottomInsets > 0 ? bottomInsets + 5 : 32.0,
                                top: bottomInsets > 0 ? 5 : 26.0,
                                left: 2.0,
                                right: 2.0,
                              ),
                              child: PhotoCard(
                                picStore: controller.currentTab == 0
                                    ? GalleryStore.to.swipePics[index]
                                    : GalleryStore.to.thumbnailsPics[index],
                                picsInThumbnails: PicSource.UNTAGGED,
                                showEditTagModal: () =>
                                    showEditTagModal(context),
                                showDeleteSecretModal: showDeleteSecretModal,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          initialPage: controller.currentTab.value == 0
                              ? GalleryStore.to.selectedSwipe.value
                              : GalleryStore.to.selectedThumbnail.value,
                          enableInfiniteScroll: false,
                          height: double.maxFinite,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          // scrollPhysics: scrollPhysics,
                          // onPageChanged: (index, reason) {
                          //   GalleryStore.to.setSwipeIndex(index);
                          // },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        }),
        Obx(() {
          if (controller.isLoading.value) {
            return Material(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: SpinKitChasingDots(
                  color: kPrimaryColor,
                  size: 80.0,
                ),
              ),
            );
          }
          return Container();
        }),
      ],
    );
  }
}
