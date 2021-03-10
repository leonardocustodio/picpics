import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';
import 'package:picPics/managers/analytics_manager.dart';
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
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/show_edit_label_dialog.dart';
import 'package:picPics/widgets/delete_secret_modal.dart';
import 'package:picPics/widgets/photo_card.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/widgets/unhide_secret_modal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/throttle.dart';
import 'package:picPics/managers/admob_manager.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:picPics/generated/l10n.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picPics/widgets/cupertino_input_dialog.dart';

class TutsTabsScreen extends StatefulWidget {
  static const id = 'tuts_tabs_screen';

  @override
  _TutsTabsScreenState createState() => _TutsTabsScreenState();
}

class _TutsTabsScreenState extends State<TutsTabsScreen>
    with WidgetsBindingObserver {
  AppStore appStore;
  TabsStore tabsStore;
  GalleryStore galleryStore;

  ReactionDisposer disposer;
  ReactionDisposer disposer2;
  ReactionDisposer disposer3;
  ReactionDisposer disposer4;

  ExpandableController expandableController =
      ExpandableController(initialExpanded: false);
  ExpandableController expandablePaddingController =
      ExpandableController(initialExpanded: false);

  // Swiper do Tutorial
  SwiperController tutorialSwiperController = SwiperController();
  TextEditingController tagsEditingController = TextEditingController();
  TextEditingController bottomTagsEditingController = TextEditingController();

  Throttle _changeThrottle;
  AppLifecycleState _appCycleState;

  void showDeleteSecretModalForMultiPic() {
    if (appStore.keepAskingToDelete == false) {
      tabsStore.setMultiTagSheet(false);
      tabsStore.setMultiPicBar(false);
      galleryStore.addTagsToSelectedPics();
      return;
    }

    //print('showModal');
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return DeleteSecretModal(
          onPressedClose: () {
            Navigator.of(context).pop();
          },
          onPressedDelete: () {
            appStore.setShouldDeleteOnPrivate(false);
            tabsStore.setMultiTagSheet(false);
            tabsStore.setMultiPicBar(false);
            galleryStore.addTagsToSelectedPics();
            Navigator.of(context).pop();
          },
          onPressedOk: () {
            appStore.setShouldDeleteOnPrivate(true);
            tabsStore.setMultiTagSheet(false);
            tabsStore.setMultiPicBar(false);
            galleryStore.addTagsToSelectedPics();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> showDeleteSecretModal(PicStore picStore) async {
    if (appStore.secretPhotos != true) {
      appStore.popPinScreen = PopPinScreenTo.TabsScreen;
      Navigator.pushNamed(context, PinScreen.id);
      return;
    }

    if (appStore.isPremium == false) {
      int freePrivatePics = await appStore.freePrivatePics;
      if (appStore.totalPrivatePics >= freePrivatePics &&
          picStore.isPrivate == false) {
        Navigator.pushNamed(context, PremiumScreen.id);
        return;
      }
    }

    if (appStore.keepAskingToDelete == false && picStore.isPrivate == false) {
      galleryStore.setPrivatePic(picStore: picStore, private: true);
      return;
    }

    //print('showModal');
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        if (picStore.isPrivate == true) {
          return UnhideSecretModal(
            onPressedDelete: () {
              Navigator.of(context).pop();
            },
            onPressedOk: () {
              galleryStore.setPrivatePic(picStore: picStore, private: false);
              Navigator.of(context).pop();
            },
          );
        }
        return DeleteSecretModal(
          onPressedClose: () {
            Navigator.of(context).pop();
          },
          onPressedDelete: () {
            galleryStore.setPrivatePic(picStore: picStore, private: true);
            appStore.setShouldDeleteOnPrivate(false);
            Navigator.of(context).pop();
          },
          onPressedOk: () {
            galleryStore.setPrivatePic(picStore: picStore, private: true);
            appStore.setShouldDeleteOnPrivate(true);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    KeyboardVisibility.onChange.listen((bool visible) {
      //print('keyboard: $visible');

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

    // RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
    //   if (event == RewardedVideoAdEvent.loaded) {
    //print('@@@ loaded');
    //   }
    //
    //   if (event == RewardedVideoAdEvent.rewarded) {
    //print('@@@ rewarded');
    //     appStore.setCanTagToday(true);
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
  }

  @override
  void dispose() {
//    PhotoManager.removeChangeCallback(_changeThrottle.call);
//    PhotoManager.stopChangeNotify();
//    _changeThrottle.dispose();
    disposer();
    disposer2();
    disposer3();
    disposer4();

    if (appStore.hasObserver) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  setTabIndex(int index) async {
    if (!galleryStore.deviceHasPics) {
      tabsStore.setCurrentTab(index);
      return;
    }

    if (tabsStore.multiPicBar) {
      if (index == 0) {
        galleryStore.clearSelectedPics();
        tabsStore.setMultiPicBar(false);
      } else if (index == 1) {
        tabsStore.setMultiTagSheet(true);
        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            expandableController.expanded = true;
          });
        });
      } else if (index == 2) {
        if (galleryStore.selectedPics.isEmpty) {
          return;
        }
        //print('sharing selected pics....');
        tabsStore.setIsLoading(true);
        await galleryStore.sharePics(
            picsStores: galleryStore.selectedPics.toList());
        tabsStore.setIsLoading(false);
      } else if (index == 3) {
        if (galleryStore.selectedPics.isEmpty) {
          return;
        }
        galleryStore.trashMultiplePics(galleryStore.selectedPics);
      }
      return;
    }

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    tabsStore = Provider.of<TabsStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);

    disposer = reaction((_) => galleryStore.trashedPic, (trashedPic) {
      if (trashedPic) {
        if (tabsStore.modalCard) {
          tabsStore.setModalCard(false);
        }
        if (tabsStore.currentTab != 1) {
          galleryStore.setTrashedPic(false);
        }
      }
    });

    disposer2 = reaction((_) => galleryStore.sharedPic, (sharedPic) {
      if (sharedPic) {
        if (tabsStore.multiPicBar) {
          galleryStore.clearSelectedPics();
          tabsStore.setMultiPicBar(false);
        }
      }
    });

    disposer3 = reaction((_) => tabsStore.showDeleteSecretModal, (showModal) {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appStore.tryBuyId != null) {
        Navigator.pushNamed(context, PremiumScreen.id);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
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
    }
  }

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
          bottomNavigationBar: Observer(builder: (_) {
            return tabsStore.multiTagSheet
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
                                expandableController.expanded =
                                    !expandableController.expanded;
                              });
                            },
                            child: SafeArea(
                              bottom: !expandableController.expanded,
                              child: Container(
                                color: Color(0xFFF1F3F5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        // if (!appStore.isPremium) {
                                        //   Navigator.pushNamed(
                                        //       context, PremiumScreen.id);
                                        //   return;
                                        // }

                                        if (galleryStore
                                                .multiPicTags[kSecretTagKey] !=
                                            null) {
                                          showDeleteSecretModalForMultiPic();
                                          return;
                                        }

                                        tabsStore.setMultiTagSheet(false);
                                        tabsStore.setMultiPicBar(false);
                                        galleryStore.addTagsToSelectedPics();
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
                                        tags: galleryStore.multiPicTags.values
                                            .toList(),
                                        addTagField: true,
                                        textEditingController:
                                            bottomTagsEditingController,
                                        showEditTagModal: () =>
                                            showEditTagModal(
                                                context, galleryStore, true),
                                        onTap: (tagId, tagName) {
                                          // if (!appStore.isPremium) {
                                          //   Navigator.pushNamed(
                                          //       context, PremiumScreen.id);
                                          //   return;
                                          // }
                                          //print('do nothing');
                                        },
                                        onPanEnd: () {
                                          // if (!appStore.isPremium) {
                                          //   Navigator.pushNamed(
                                          //       context, PremiumScreen.id);
                                          //   return;
                                          // }
                                          galleryStore.removeFromMultiPicTags(
                                              DatabaseManager
                                                  .instance.selectedTagKey);
                                        },
                                        onDoubleTap: () {
                                          // if (!appStore.isPremium) {
                                          //   Navigator.pushNamed(
                                          //       context, PremiumScreen.id);
                                          //   return;
                                          // }
                                          //print('do nothing');
                                        },
                                        onChanged: (text) {
                                          galleryStore.setSearchText(text);
                                        },
                                        onSubmitted: (text) {
                                          // if (!appStore.isPremium) {
                                          //   Navigator.pushNamed(
                                          //       context, PremiumScreen.id);
                                          //   return;
                                          // }
                                          if (text != '') {
                                            bottomTagsEditingController.clear();
                                            galleryStore.setSearchText('');
                                            String tagKey =
                                                Helpers.encryptTag(text);

                                            if (galleryStore
                                                    .multiPicTags[tagKey] ==
                                                null) {
                                              if (appStore.tags[tagKey] ==
                                                  null) {
                                                //print(                                                    'tag does not exist! creating it!');
                                                galleryStore.createTag(text);
                                              }
                                              galleryStore
                                                  .addToMultiPicTags(tagKey);
                                            }
                                          }
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: TagsList(
                                        title: galleryStore.searchText != ''
                                            ? S.of(context).search_results
                                            : S.of(context).recent_tags,
                                        tags: galleryStore.tagsSuggestions,
                                        tagStyle: TagStyle.GrayOutlined,
                                        showEditTagModal: () =>
                                            showEditTagModal(
                                                context, galleryStore, true),
                                        onTap: (tagId, tagName) {
                                          // if (!appStore.isPremium) {
                                          //   Navigator.pushNamed(
                                          //       context, PremiumScreen.id);
                                          //   return;
                                          // }

                                          bottomTagsEditingController.clear();
                                          galleryStore.setSearchText('');
                                          galleryStore.addToMultiPicTags(tagId);
                                        },
                                        onDoubleTap: () {
                                          // if (!appStore.isPremium) {
                                          //   Navigator.pushNamed(
                                          //       context, PremiumScreen.id);
                                          //   return;
                                          // }
                                          //print('do nothing');
                                        },
                                        onPanEnd: () {
                                          // if (!appStore.isPremium) {
                                          //   Navigator.pushNamed(
                                          //       context, PremiumScreen.id);
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
                            controller: expandablePaddingController,
                            expanded: Container(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Observer(builder: (_) {
                    if (!tabsStore.multiPicBar) {
                      return Platform.isIOS
                          ? CupertinoTabBar(
                              currentIndex: tabsStore.currentTab,
                              onTap: (index) {
                                setTabIndex(index);
                              },
                              iconSize: 32.0,
                              border: Border(
                                  top: BorderSide(
                                      color: Color(0xFFE2E4E5), width: 1.0)),
                              items: <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  title: Container(),
                                  icon: Image.asset(
                                      'lib/images/untaggedtabinactive.png'),
                                  activeIcon: Image.asset(
                                      'lib/images/untaggedtabactive.png'),
                                ),
                                BottomNavigationBarItem(
                                  title: Container(),
                                  icon: Image.asset(
                                      'lib/images/pictabinactive.png'),
                                  activeIcon: Image.asset(
                                      'lib/images/pictabactive.png'),
                                ),
                                BottomNavigationBarItem(
                                  title: Container(),
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
                                currentIndex: tabsStore.currentTab,
                                onTap: (index) {
                                  setTabIndex(index);
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
                              setTabIndex(index);
                            },
                            iconSize: 24.0,
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xFFE2E4E5), width: 1.0)),
                            items: <BottomNavigationBarItem>[
                              BottomNavigationBarItem(
                                title: Container(),
                                icon: Image.asset(
                                    'lib/images/returntabbutton.png'),
                              ),
                              // BottomNavigationBarItem(
                              //   title: Container(),
                              //   icon: Image.asset('lib/images/locktabbutton.png'),
                              // ),
                              BottomNavigationBarItem(
                                title: Container(),
                                icon:
                                    Image.asset('lib/images/tagtabbutton.png'),
                              ),
                              BottomNavigationBarItem(
                                title: Container(),
                                icon: galleryStore.selectedPics.isEmpty
                                    ? Opacity(
                                        opacity: 0.2,
                                        child: Image.asset(
                                            'lib/images/sharetabbutton.png'),
                                      )
                                    : Image.asset(
                                        'lib/images/sharetabbutton.png'),
                              ),
                              BottomNavigationBarItem(
                                title: Container(),
                                icon: galleryStore.selectedPics.isEmpty
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
                                setTabIndex(index);
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
                                // BottomNavigationBarItem(
                                //   label: 'Lock',
                                //   icon: Image.asset('lib/images/locktabbutton.png'),
                                // ),
                                BottomNavigationBarItem(
                                  label: 'Tag',
                                  icon: Image.asset(
                                      'lib/images/tagtabbutton.png'),
                                ),
                                BottomNavigationBarItem(
                                  label: 'Share',
                                  icon: galleryStore.selectedPics.isEmpty
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
                                  icon: galleryStore.selectedPics.isEmpty
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
                Observer(builder: (_) {
                  Widget wgt;
                  if (appStore.hasGalleryPermission == null ||
                      appStore.hasGalleryPermission == false) {
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
                                      Navigator.pushNamed(
                                          context, SettingsScreen.id);
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
                                    onPressed: () async {
                                      bool photoPermission = await PhotoManager
                                          .requestPermission();

                                      if (photoPermission == false) {
                                        PhotoManager.openSetting();
                                      }
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
                  } else if (tabsStore.currentTab == 0 &&
                      appStore.hasGalleryPermission)
                    wgt = UntaggedTab();
                  else if (tabsStore.currentTab == 1 &&
                      appStore.hasGalleryPermission)
                    wgt = PicTab(
                      showEditTagModal: () =>
                          showEditTagModal(context, galleryStore, true),
                      showDeleteSecretModal: showDeleteSecretModal,
                    );
                  else if (tabsStore.currentTab == 2 &&
                      appStore.hasGalleryPermission)
                    wgt = TaggedTab(showEditTagModal: showEditTagModal);
                  return wgt ?? Container();
                }),
              ],
            ),
          ),
        ),
        Observer(builder: (_) {
          if (tabsStore.modalCard) {
            return Material(
              color: Colors.transparent,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    tabsStore.setModalCard(false);
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          //print('ignore');
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: bottomInsets > 0 ? bottomInsets + 5 : 32.0,
                            top: bottomInsets > 0 ? 5 : 26.0,
                            left: 2.0,
                            right: 2.0,
                          ),
                          child: PhotoCard(
                            picStore: galleryStore.currentPic,
                            picsInThumbnails: PicSource.UNTAGGED,
                            showEditTagModal: () =>
                                showEditTagModal(context, galleryStore, true),
                            showDeleteSecretModal: showDeleteSecretModal,
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
            Analytics.sendTutorialBegin();

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
                            child: Swiper(
                              loop: false,
                              itemBuilder: (BuildContext context, int index) {
                                String text;
                                Image image;

                                if (index == 0) {
                                  text = S.of(context).tutorial_just_swipe;
                                  image = Image.asset(
                                      'lib/images/tutorialthirdimage.png');
                                } else if (index == 1) {
                                  text =
                                      S.of(context).tutorial_however_you_want;
                                  image = Image.asset(
                                      'lib/images/tutorialsecondimage.png');
                                } else {
                                  text = S.of(context).tutorial_daily_package;
                                  image = Image.asset(
                                      'lib/images/tutorialfirstimage.png');
                                }

                                return Column(
                                  children: <Widget>[
                                    Container(
                                      constraints: BoxConstraints(
                                          maxHeight: height / 2 - 20),
                                      child: image,
                                    ),
                                    SizedBox(
                                      height: 28.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
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
                              pagination: SwiperCustomPagination(
                                builder: (BuildContext context,
                                    SwiperPluginConfig config) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 0
                                                ? kSecondaryColor
                                                : kGrayColor,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          margin: const EdgeInsets.only(
                                              left: 24.0, right: 24.0),
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 1
                                                ? kSecondaryColor
                                                : kGrayColor,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 2
                                                ? kSecondaryColor
                                                : kGrayColor,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
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
                            onPressed: () async {
                              if (tabsStore.tutorialIndex == 2) {
                                print('Requesting notification....');

                                await appStore.requestNotificationPermission();
                                await appStore.checkNotificationPermission(
                                    firstPermissionCheck: true);
                                await appStore.setTutorialCompleted(true);
                                await galleryStore.loadAssetsPath();
                                return;
                              }
                              tutorialSwiperController.next(animation: true);
                            },
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              height: 44.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  tabsStore.tutorialIndex == 2
                                      ? S.of(context).start
                                      : S.of(context).next,
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
