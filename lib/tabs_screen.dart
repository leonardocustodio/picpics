import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/components/custom_bubble_bottom_bar.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';
import 'package:picPics/premium_screen.dart';
import 'package:picPics/push_notifications_manager.dart';
import 'package:picPics/settings_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/tabs/pic_tab.dart';
import 'package:picPics/tabs/tagged_tab.dart';
import 'package:picPics/tabs/untagged_tab.dart';
import 'package:picPics/widgets/photo_card.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:picPics/database_manager.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/throttle.dart';
import 'package:picPics/model/pic.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:picPics/admob_manager.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picPics/widgets/edit_tag_modal.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class TabsScreen extends StatefulWidget {
  static const id = 'tabs_screen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  AppStore appStore;
  TabsStore tabsStore;
  GalleryStore galleryStore;

  ExpandableController expandableController = ExpandableController(initialExpanded: false);
  ExpandableController expandablePaddingController = ExpandableController(initialExpanded: false);

  // Swiper do Tutorial
  SwiperController tutorialSwiperController = SwiperController();

  TextEditingController tagsEditingController = TextEditingController();

  TextEditingController bottomTagsEditingController = TextEditingController();

  Throttle _changeThrottle;

  void trashPics() async {
    print('trashing selected pics....');

    List<String> entitiesIds = [];
    List<AssetEntity> entities = [];
    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];

    for (var photoId in DatabaseManager.instance.picsSelected) {
      AssetEntity entity = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);
      entitiesIds.add(photoId);
      entities.add(entity);
    }

    final List<String> result = await PhotoManager.editor.deleteWithIds(entitiesIds);
    if (result.isNotEmpty) {
      for (AssetEntity entity in entities) {
        DatabaseManager.instance.deletedPic(entity);
      }

      DatabaseManager.instance.setPicsSelected(Set());
      tabsStore.setMultiPicBar(false);
    }
  }

  trashPic(AssetEntity entity) async {
    print('trashing pic');
    final List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
    if (result.isNotEmpty) {
      DatabaseManager.instance.deletedPic(entity);

      if (tabsStore.modalCard) {
        DatabaseManager.instance.selectedPhotoPicInfo = null;
        DatabaseManager.instance.selectedPhotoIndex = null;
        DatabaseManager.instance.selectedPhotoData = null;
        tabsStore.setModalCard(false);
      }
    }
  }

  showEditTagModal() {
    if (DatabaseManager.instance.selectedTagKey != '') {
      TextEditingController alertInputController = TextEditingController();
      Pic getPic = DatabaseManager.instance.getPicInfo(DatabaseManager.instance.selectedPhoto.id);
      String tagName = DatabaseManager.instance.getTagName(DatabaseManager.instance.selectedTagKey);
      alertInputController.text = tagName;

      print('showModal');
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return EditTagModal(
            alertInputController: alertInputController,
            onPressedDelete: () {
              DatabaseManager.instance.deleteTag(tagKey: DatabaseManager.instance.selectedTagKey);
              DatabaseManager.instance.tagsSuggestions(
                tagsEditingController.text,
                DatabaseManager.instance.selectedPhoto.id,
                excludeTags: getPic.tags,
                notify: false,
              );
              Navigator.of(context).pop();
            },
            onPressedOk: () {
              print('Editing tag - Old name: ${DatabaseManager.instance.selectedTagKey} - New name: ${alertInputController.text}');
              if (tagName != alertInputController.text) {
                DatabaseManager.instance.editTag(
                  oldTagKey: DatabaseManager.instance.selectedTagKey,
                  newName: alertInputController.text,
                );
              }
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  showPhotoCardModal() {
    Analytics.sendEvent(Event.showed_card);
    tabsStore.setModalCard(true);
  }

  setIsLoading(bool loading) {
    tabsStore.setIsLoading(loading);
  }

  void dismissPhotoCard() {
    print('dismissed photo card!!!');

    DatabaseManager.instance.selectedPhotoData = null;
    DatabaseManager.instance.selectedPhotoPicInfo = null;
    DatabaseManager.instance.selectedPhotoIndex = null;
    tabsStore.setModalCard(false);
  }

  @override
  void initState() {
    super.initState();
//    _loadPhotos();

    KeyboardVisibility.onChange.listen((bool visible) {
      print('keyboard: $visible');

      if (visible && tabsStore.multiTagSheet) {
        setState(() {
          expandablePaddingController.expanded = true;
        });
      } else if (!visible && tabsStore.multiTagSheet) {
        setState(() {
          expandablePaddingController.expanded = false;
        });
      }
    });

//    _changeThrottle = Throttle(onCall: _onAssetChange);
//    PhotoManager.addChangeCallback(_changeThrottle.call);
    PhotoManager.addChangeCallback(_onAssetChange);
    PhotoManager.startChangeNotify();

    if (DatabaseManager.instance.userSettings.tutorialCompleted == true && DatabaseManager.instance.userSettings.notifications == true) {
      PushNotificationsManager push = PushNotificationsManager();
      push.init();
    }

    if (DatabaseManager.instance.userSettings.isPremium) {
      DatabaseManager.instance.checkPremiumStatus();
    }

    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        print('@@@ loaded');
      }

      if (event == RewardedVideoAdEvent.rewarded) {
        print('@@@ rewarded');
        DatabaseManager.instance.setCanTagToday(true);
      }

      if (event == RewardedVideoAdEvent.closed) {
        print('@@@@ closed');
        DatabaseManager.instance.adsIsLoaded = false;
        Ads.loadRewarded();
      }

      if (event == RewardedVideoAdEvent.failedToLoad) {
        print('@@@ failed');
        DatabaseManager.instance.adsIsLoaded = false;
      }
    };

    // Added for the case of buying premium from appstore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (DatabaseManager.instance.appStartInPremium) {
        Navigator.pushNamed(context, PremiumScreen.id);
      }
    });
  }

  @override
  void dispose() {
    PhotoManager.removeChangeCallback(_changeThrottle.call);
    PhotoManager.stopChangeNotify();
    _changeThrottle.dispose();
    super.dispose();
  }

  void _onAssetChange(MethodCall call) async {
    print('#!#!#!#!#!#! asset changed: ${call.arguments}');

    List<dynamic> createdPics = call.arguments['create'];
    List<dynamic> deletedPics = call.arguments['delete'];
//    print(deletedPics);

    if (deletedPics.length > 0) {
      print('### deleted pics from library!');
      for (var pic in deletedPics) {
        print('Pic deleted Id: ${pic['id']}');
        AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
        AssetEntity entity = pathProvider.orderedList.firstWhere((element) => element.id == pic['id'], orElse: () => null);

        if (entity != null) {
          DatabaseManager.instance.deletedPic(
            entity,
            removeFromDb: false,
          );
        }
      }
    }

    if (createdPics.length > 0) {
      print('#### created pics!!!');
      for (var pic in createdPics) {
        print('Pic created Id: ${pic['id']}');
        AssetEntity picEntity = await AssetEntity.fromId(pic['id']);
        AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
        pathProvider.addAsset(picEntity);
      }

      DatabaseManager.instance.sliderHasPics();
      setState(() {
//        Conferir isso aqui que eu tive que comentar!!!!

        // picSwiper = 0;
        // carouselController.jumpToPage(0);
        if (!galleryStore.deviceHasPics) {
          // ver isso aqui - mudei hoje 17/08
//          deviceHasNoPics = false;
        }
      });
    }
  }

  setTabIndex(int index) async {
    if (!galleryStore.deviceHasPics) {
      Analytics.sendCurrentTab(index);
      print('Trying to set swiper to index: ${DatabaseManager.instance.swiperIndex}');
      tabsStore.setCurrentTab(index);
      return;
    }

    if (tabsStore.multiPicBar) {
      if (index == 0) {
        DatabaseManager.instance.setPicsSelected(Set());
        tabsStore.setMultiPicBar(false);
      } else if (index == 1) {
        trashPics();
      } else if (index == 2) {
        print('sharing selected pics....');
        tabsStore.setIsLoading(true);

        await DatabaseManager.instance.sharePics(photoIds: DatabaseManager.instance.picsSelected.toList());

        tabsStore.setIsLoading(false);
      } else {
        //        showMultiTagSheet();

        // Verificar se multipic não existe antes
        DatabaseManager.instance.tagsSuggestions(
          bottomTagsEditingController.text,
          'MULTIPIC',
          // excludeTags: picInfo.tags,
        );

        tabsStore.setMultiTagSheet(true);

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            expandableController.expanded = true;
          });
        });
      }
      return;
    }

    if (index == 0) {
//      AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
//      List<String> photosIds = [];
//      for (int x = 0; x < pathProvider.orderedList.length; x++) {
//        bool hasTag = DatabaseManager.instance.picHasTag[x];
//        AssetEntity entity = pathProvider.orderedList[x];
//        if (!hasTag) {
//          photosIds.add(entity.id);
//        }
//      }
//      DatabaseManager.instance.slideThumbPhotoIds = photosIds;
    } else if (index == 1) {
//      AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
//      List<String> photosIds = [];
//      for (int x = 0; x < DatabaseManager.instance.sliderIndex.length; x++) {
//        int orderedIndex = DatabaseManager.instance.sliderIndex[x];
//        AssetEntity entity = pathProvider.orderedList[orderedIndex];
//        photosIds.add(entity.id);
//      }
//      DatabaseManager.instance.slideThumbPhotoIds = photosIds;
    }

    print('Trying to set swiper to index: ${DatabaseManager.instance.swiperIndex}');
    Analytics.sendCurrentTab(index);
    tabsStore.setCurrentTab(index);
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

//  void _setDeviceHasNoPics() {
//    print('This device has no pics!!!!');
//    setState(() {
//      deviceHasNoPics = true;
//    });
//    return;
//  }

  void _loadPhotos({shouldReload = false}) async {
    print('Loading photos.....');
    if (PhotoProvider.instance.list.isEmpty) {
//      await PhotoProvider.instance.refreshGalleryList();
//      print('LISTA: ${PhotoProvider.instance.list}');

//      if (PhotoProvider.instance.list.length == 0) {
//        _setDeviceHasNoPics();
//        return;
//      }

//      PhotoProvider.instance.getOrCreatePathProvider(PhotoProvider.instance.list[0]);
//      await PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]].loadAllPics();
//      _checkTaggedPics()

      DatabaseManager.instance.sliderHasPics();
//      setState(() {
//        deviceHasNoPics = false;
//      });
    }

    DatabaseManager.instance.checkHasTaggedPhotos();
    tabsStore.setCurrentTab(1);
    setTabIndex(1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    tabsStore = Provider.of<TabsStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    print('Language Code: ${myLocale.languageCode}');

    AssetPathProvider pathProvider;
    if (PhotoProvider.instance.list.isNotEmpty) {
      print('refreshing');
      pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    }

    var screenWidth = MediaQuery.of(context).size.width;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    print('Bottom inset: $bottomInsets');

    return Stack(
      children: <Widget>[
        Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Stack(
              children: <Widget>[
                Observer(builder: (_) {
                  Widget wgt;
                  if (!appStore.hasGalleryPermission) {
                    wgt = Container(
                      constraints: BoxConstraints.expand(),
                      color: kWhiteColor,
                      child: SafeArea(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  CupertinoButton(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    onPressed: () {
                                      Navigator.pushNamed(context, SettingsScreen.id);
                                    },
                                    child: Image.asset('lib/images/settings.png'),
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
                                    child: Image.asset('lib/images/nogalleryauth.png'),
                                  ),
                                  SizedBox(
                                    height: 21.0,
                                  ),
                                  Text(
                                    S.of(context).gallery_access_permission_description,
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
                                      PhotoManager.openSetting();
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
                                          S.of(context).gallery_access_permission,
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
                  } else if (tabsStore.currentTab == 0 && appStore.hasGalleryPermission)
                    wgt = UntaggedTab(
                      showPhotoCardModal: showPhotoCardModal,
                    );
                  else if (tabsStore.currentTab == 1 && appStore.hasGalleryPermission)
                    wgt = PicTab(
                      showEditTagModal: showEditTagModal,
                      trashPic: trashPic,
                    );
                  else if (tabsStore.currentTab == 2 && appStore.hasGalleryPermission)
                    wgt = TaggedTab(
                      setTabIndex: setTabIndex,
                      setIsLoading: setIsLoading,
                      deviceHasNoPics: !galleryStore.deviceHasPics,
                      showEditTagModal: showEditTagModal,
                      showPhotoCardModal: showPhotoCardModal,
                    );
                  return wgt;
                }),
              ],
            ),
          ),
          bottomNavigationBar: tabsStore.multiTagSheet
              ? ExpandableNotifier(
                  child: Container(
                    color: Color(0xF1F3F5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              expandableController.expanded = !expandableController.expanded;
                            });
                          },
                          child: SafeArea(
                            bottom: !expandableController.expanded,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CupertinoButton(
                                  onPressed: () {
                                    tabsStore.setMultiTagSheet(false);
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
                                    if (!DatabaseManager.instance.userSettings.isPremium) {
                                      Navigator.pushNamed(context, PremiumScreen.id);
                                      return;
                                    }

                                    List<String> photosIds = [];
                                    List<AssetEntity> entities = [];
                                    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
                                    for (var photoId in DatabaseManager.instance.picsSelected) {
                                      AssetEntity entity = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);
                                      photosIds.add(photoId);
                                      entities.add(entity);
                                    }
                                    DatabaseManager.instance.addTagsToPics(
                                      tagsKeys: DatabaseManager.instance.multiPicTagKeys,
                                      photosIds: photosIds,
                                      entities: entities,
                                    );

                                    tabsStore.setMultiTagSheet(false);
                                    tabsStore.setMultiPicBar(false);
                                    DatabaseManager.instance.setPicsSelected(Set());
                                    DatabaseManager.instance.setMultiPicTagKeys([]);
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
                        Expandable(
                          controller: expandableController,
                          expanded: Container(
                            padding: const EdgeInsets.all(24.0),
                            color: Color(0xFFEFEFF4).withOpacity(0.94),
                            child: SafeArea(
                              bottom: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TagsList(
                                      tagsKeys: Provider.of<DatabaseManager>(context).multiPicTagKeys, //picI
                                      addTagField: true,
                                      textEditingController: bottomTagsEditingController,
                                      showEditTagModal: showEditTagModal,
                                      onTap: (tagName) {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }
                                        print('do nothing');
                                      },
                                      onPanUpdate: () {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        if (DatabaseManager.instance.multiPicTagKeys.contains(DatabaseManager.instance.selectedTagKey)) {
                                          List<String> multiPic = DatabaseManager.instance.multiPicTagKeys;
                                          multiPic.remove(DatabaseManager.instance.selectedTagKey);
                                          DatabaseManager.instance.setMultiPicTagKeys(multiPic);

                                          DatabaseManager.instance.tagsSuggestions(
                                            bottomTagsEditingController.text,
                                            'MULTIPIC',
                                            excludeTags: DatabaseManager.instance.multiPicTagKeys,
                                          );
                                        }
                                      },
                                      onDoubleTap: () {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }
                                        print('do nothing');
                                      },
                                      onChanged: (text) {
                                        print('calling tag suggestions');
                                        DatabaseManager.instance.tagsSuggestions(
                                          text,
                                          'MULTIPIC',
                                          excludeTags: DatabaseManager.instance.multiPicTagKeys,
                                        );
                                      },
                                      onSubmitted: (text) {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        print('return');
                                        if (text != '') {
                                          bottomTagsEditingController.clear();
                                          String tagKey = DatabaseManager.instance.encryptTag(text);
                                          if (!DatabaseManager.instance.multiPicTagKeys.contains(tagKey)) {
                                            if (DatabaseManager.instance.getTagName(tagKey) == null) {
                                              print('tag does not exist! creating it!');
                                              DatabaseManager.instance.createTag(text);
                                            }
                                            List<String> multiPic = DatabaseManager.instance.multiPicTagKeys;
                                            multiPic.add(tagKey);
                                            DatabaseManager.instance.setMultiPicTagKeys(multiPic);

                                            DatabaseManager.instance.tagsSuggestions(
                                              '',
                                              'MULTIPIC',
                                              excludeTags: DatabaseManager.instance.multiPicTagKeys,
                                            );
                                          }
                                        }
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TagsList(
                                      title: S.of(context).suggestions,
                                      tagsKeys: DatabaseManager.instance.suggestionTags,
                                      tagStyle: TagStyle.GrayOutlined,
                                      showEditTagModal: showEditTagModal,
                                      onTap: (tagName) {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        bottomTagsEditingController.clear();
                                        String tagKey = DatabaseManager.instance.encryptTag(tagName);
                                        if (!DatabaseManager.instance.multiPicTagKeys.contains(tagKey)) {
                                          List<String> multiPic = DatabaseManager.instance.multiPicTagKeys;
                                          multiPic.add(tagKey);
                                          DatabaseManager.instance.setMultiPicTagKeys(multiPic);

                                          DatabaseManager.instance.tagsSuggestions(
                                            '',
                                            'MULTIPIC',
                                            excludeTags: DatabaseManager.instance.multiPicTagKeys,
                                          );
                                        }
                                      },
                                      onDoubleTap: () {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        print('do nothing');
                                      },
                                      onPanUpdate: () {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        print('do nothing');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expandable(
                          controller: expandablePaddingController,
                          expanded: Container(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  constraints: BoxConstraints(
                    maxHeight: 100.0,
                  ),
                  child: !tabsStore.multiPicBar
                      ? Observer(builder: (_) {
                          return CustomBubbleBottomBar(
                            backgroundColor: kWhiteColor,
                            hasNotch: true,
                            opacity: 1.0,
                            currentIndex: tabsStore.currentTab,
                            onTap: setTabIndex,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            elevation: 8,
                            items: <CustomBubbleBottomBarItem>[
                              CustomBubbleBottomBarItem(
                                backgroundColor: kPinkColor,
                                icon: Image.asset('lib/images/tabgridred.png'),
                                activeIcon: Image.asset('lib/images/tabgridwhite.png'),
                              ),
                              CustomBubbleBottomBarItem(
                                backgroundColor: kSecondaryColor,
                                icon: Image.asset('lib/images/tabpicpicsred.png'),
                                activeIcon: Image.asset('lib/images/tabpicpicswhite.png'),
                              ),
                              CustomBubbleBottomBarItem(
                                backgroundColor: kPrimaryColor,
                                icon: Image.asset('lib/images/tabtaggedblue.png'),
                                activeIcon: Image.asset('lib/images/tabtaggedwhite.png'),
                              ),
                            ],
                          );
                        })
                      : BubbleBottomBar(
                          backgroundColor: kWhiteColor,
                          hasNotch: true,
                          opacity: 1.0,
                          currentIndex: 2,
                          onTap: setTabIndex,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          elevation: 8,
                          fabLocation: BubbleBottomBarFabLocation.end,
                          items: <BubbleBottomBarItem>[
                            BubbleBottomBarItem(
                              backgroundColor: kWhiteColor,
                              icon: Image.asset('lib/images/cancelbarbutton.png'),
                              title: Text(''),
                            ),
                            BubbleBottomBarItem(
                              backgroundColor: kWhiteColor,
                              icon: Opacity(
                                opacity: Provider.of<DatabaseManager>(context).picsSelected.length > 0 ? 1.0 : 0.35,
                                child: Image.asset('lib/images/trashbarbutton.png'),
                              ),
                              title: Text(''),
                            ),
                            BubbleBottomBarItem(
                              backgroundColor: kWhiteColor,
                              icon: Opacity(
                                opacity: Provider.of<DatabaseManager>(context).picsSelected.length > 0 ? 1.0 : 0.35,
                                child: Image.asset('lib/images/sharebutton.png'),
                              ),
                              title: Text(''),
                            ),
                          ],
                        ),
                ),
          floatingActionButton: !tabsStore.multiPicBar || tabsStore.multiTagSheet
              ? Container(
                  width: 0,
                  height: 0,
                )
              : FloatingActionButton(
                  onPressed: () {
                    setTabIndex(3);
                  },
                  child: Image.asset('lib/images/picbarbuttonwhite.png'),
                  backgroundColor: kSecondaryColor,
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ),
        Observer(builder: (_) {
          if (tabsStore.modalCard) {
            return Material(
              color: Colors.transparent,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    dismissPhotoCard();
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          print('ignore');
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: bottomInsets > 0 ? bottomInsets + 5 : 52,
                            top: bottomInsets > 0 ? 5 : 46.0,
                          ),
                          child: PhotoCard(
                            picStore: galleryStore.currentPic,
//                          data: DatabaseManager.instance.selectedPhotoData,
//                          photoId: DatabaseManager.instance.selectedPhotoPicInfo.photoId,
//                          picSwiper: -1,
//                          index: DatabaseManager.instance.selectedPhotoIndex,
//                          tagsEditingController: tagsEditingController,
//                          specificLocation: DatabaseManager.instance.selectedPhotoPicInfo.specificLocation,
//                          generalLocation: DatabaseManager.instance.selectedPhotoPicInfo.generalLocation,
                            showEditTagModal: showEditTagModal,
                            onPressedTrash: () {
                              trashPic(DatabaseManager.instance.selectedPhotoData);
                            },
                          ),
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
        Observer(builder: (_) {
          if (tabsStore.isLoading) {
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
        Observer(builder: (_) {
          if (appStore.tutorialCompleted == false) {
            return Container(
              color: Colors.black.withOpacity(0.6),
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    height: 609.0,
                    width: 343.0,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            S.of(context).welcome,
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff979a9b),
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Expanded(
                            child: new Swiper(
                              loop: false,
                              itemBuilder: (BuildContext context, int index) {
                                String text = '';
                                Image image;

                                if (index == 0) {
                                  text = S.of(context).tutorial_just_swipe;
                                  image = Image.asset('lib/images/tutorialthirdimage.png');
                                } else if (index == 1) {
                                  text = S.of(context).tutorial_however_you_want;
                                  image = Image.asset('lib/images/tutorialsecondimage.png');
                                } else {
                                  text = S.of(context).tutorial_daily_package;
                                  image = Image.asset('lib/images/tutorialfirstimage.png');
                                }

                                return Column(
                                  children: <Widget>[
                                    image,
                                    SizedBox(
                                      height: 28.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Text(
                                        text,
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xff707070),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: 3,
                              controller: tutorialSwiperController,
                              onIndexChanged: (index) {
                                tabsStore.setTutorialIndex(index);
                              },
                              pagination: new SwiperCustomPagination(
                                builder: (BuildContext context, SwiperPluginConfig config) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 0 ? kSecondaryColor : kGrayColor,
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 1 ? kSecondaryColor : kGrayColor,
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 2 ? kSecondaryColor : kGrayColor,
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 17.0,
                          ),
                          CupertinoButton(
                            onPressed: () {
                              if (tabsStore.tutorialIndex == 2) {
                                print('Requesting notification....');

                                if (Platform.isAndroid) {
                                  var userBox = Hive.box('user');
                                  DatabaseManager.instance.userSettings.notifications = true;
                                  DatabaseManager.instance.userSettings.dailyChallenges = true;
                                  userBox.putAt(0, DatabaseManager.instance.userSettings);
                                } else {
                                  PushNotificationsManager push = PushNotificationsManager();
                                  push.init();
                                }
                                DatabaseManager.instance.checkNotificationPermission(firstPermissionCheck: true);
                                appStore.setTutorialCompleted(true);
                                return;
                              }
                              tutorialSwiperController.next(animation: true);
                            },
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              height: 44.0,
                              margin: const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  tabsStore.tutorialIndex == 2 ? S.of(context).start : S.of(context).next,
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
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
                  ),
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
