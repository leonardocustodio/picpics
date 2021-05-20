import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/screens/tabs/pic_tab.dart';
import 'package:picPics/screens/tabs/tagged_tab.dart';
import 'package:picPics/screens/tabs/untagged_tab.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/functions.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/widgets/photo_card.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:picPics/generated/l10n.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TabsScreen extends GetWidget<TabsController> {
  static const id = 'tabs_screen';

  SwiperController tutorialSwiperController = SwiperController();

  TextEditingController tagsEditingController = TextEditingController();

  TextEditingController bottomTagsEditingController = TextEditingController();

  //Throttle _changeThrottle;

  //AppLifecycleState _appCycleState;

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    //print('Language Code: ${myLocale.languageCode}');

    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var height = MediaQuery.of(context).size.height;

    return Obx(
      () => Stack(
        children: <Widget>[
          Scaffold(
            bottomNavigationBar: controller.multiTagSheet.value
                ? ExpandableNotifier(
                    controller: controller.expandableController.value,
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
                                        // if (!UserController.to.isPremium) {
                                        //   Get.to(() =>   PremiumScreen());
                                        //   return;
                                        // }

                                        if (TagsController.to.multiPicTags
                                                .value[kSecretTagKey] !=
                                            null) {
                                          showDeleteSecretModalForMultiPic(
                                              controller);
                                          return;
                                        }

                                        controller.setMultiTagSheet(false);
                                        controller.setMultiPicBar(false);
                                        TagsController.to
                                            .addTagsToSelectedPics();
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

                              /// TODO: Tags List Not Showing
                              color: Color(0xFFEFEFF4).withOpacity(0.94),
                              child: SafeArea(
                                bottom: true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TagsList(
                                        tagsKeyList: TagsController
                                            .to.multiPicTags.keys
                                            .toList(),
                                        addTagField: true,
                                        textEditingController:
                                            bottomTagsEditingController,
                                        /*  showEditTagModal: (String tagKey) {
                                                showEditTagModal();
                                              }, */
                                        onTap: (String tagKey) {
                                          ///  if (!UserController.to.isPremium) {
                                          ///    Get.to(() =>   PremiumScreen);
                                          ///    return;
                                          ///  }
                                          print('do nothing');
                                        },
                                        onPanEnd: (String tagKey) {
                                          // if (!UserController.to.isPremium) {
                                          //   Get.to(() =>   PremiumScreen);
                                          //   return;
                                          // }
                                          TagsController.to.multiPicTags
                                              .remove(tagKey);
                                          TagsController.to.loadRecentTags();
                                          //GalleryStore.to.removeFromMultiPicTags(tagKey);
                                        },
                                        onDoubleTap: (String tagKey) {
                                          // if (!UserController.to.isPremium) {
                                          //   Get.to(() =>   PremiumScreen);
                                          //   return;
                                          // }
                                          print('do nothing');
                                        },
                                        onChanged: (text) {
                                          TagsController.to.searchText.value =
                                              text ?? '';
                                          TagsController.to.loadRecentTags();
                                          //GalleryStore.to.setSearchText(text);
                                        },
                                        onSubmitted: (text) {
                                          // if (!UserController.to.isPremium) {
                                          //   Get.to(() =>   PremiumScreen);
                                          //   return;
                                          // }
                                          if (text != '') {
                                            bottomTagsEditingController.clear();
                                            TagsController.to.searchText.value =
                                                text ?? '';
                                            TagsController.to.loadRecentTags();
                                            String tagKey =
                                                Helpers.encryptTag(text);

                                            if (TagsController
                                                    .to.multiPicTags[tagKey] ==
                                                null) {
                                              if (TagsController
                                                      .to.allTags[tagKey] ==
                                                  null) {
                                                print(
                                                    'tag does not exist! creating it!');
                                                TagsController.to
                                                    .createTag(text);
                                              }
                                              TagsController
                                                  .to.multiPicTags[tagKey] = '';
                                              TagsController
                                                  .to.searchText.value = '';
                                            }
                                          }
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: TagsList(
                                        title: TagsController
                                                    .to.searchText.value !=
                                                ''
                                            ? S.of(context).search_results
                                            : S.of(context).recent_tags,
                                        tagsKeyList: TagsController
                                            .to.recentTagKeyList.value.keys
                                            .where((tag) =>
                                                TagsController
                                                    .to.multiPicTags[tag] ==
                                                null)
                                            .toList(),
                                        tagStyle: TagStyle.GrayOutlined,
                                        /* showEditTagModal: () =>
                                                  showEditTagModal(context), */
                                        onTap: (String tagKey) {
                                          /* if (!UserController
                                                    .to.isPremium.value) {
                                                  Get.to(() => PremiumScreen);
                                                  return;
                                                } */

                                          bottomTagsEditingController.clear();
                                          TagsController.to.searchText.value =
                                              '';
                                          //GalleryStore.to.setSearchText('');
                                          TagsController
                                              .to.multiPicTags[tagKey] = '';
                                          TagsController.to.loadRecentTags();
                                          //GalleryStore.to.addToMultiPicTags(tagKey);
                                        },
                                        onDoubleTap: (String tagKey) {
                                          /* if (!UserController
                                                    .to.isPremium.value) {
                                                  Get.to(() => PremiumScreen);
                                                  return;
                                                } */
                                          print('do nothing');
                                        },
                                        onPanEnd: (String tagKey) {
                                          /* if (!UserController
                                                    .to.isPremium.value) {
                                                  Get.to(() => PremiumScreen);
                                                  return;
                                                } */
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
                              if (controller.currentTab.value == 2)
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
                                if (controller.currentTab.value == 2)
                                  BottomNavigationBarItem(
                                    label: 'Feature',
                                    icon: Image.asset('lib/images/starico.png'),
                                  ),
                                BottomNavigationBarItem(
                                  label: 'Tag',
                                  icon: TabsController
                                          .to.selectedUntaggedPics.isEmpty
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              'lib/images/tagtabbutton.png'),
                                        )
                                      : Image.asset(
                                          'lib/images/tagtabbutton.png'),
                                ),
                                BottomNavigationBarItem(
                                  label: 'Share',
                                  icon: TabsController
                                          .to.selectedUntaggedPics.isEmpty
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
                                  icon: TabsController
                                          .to.selectedUntaggedPics.isEmpty
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
                  }),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Stack(
                children: <Widget>[
                  GetX<UserController>(builder: (userController) {
                    if (userController.hasGalleryPermission.value == null ||
                        userController.hasGalleryPermission.value == false) {
                      return Container(
                        constraints: BoxConstraints.expand(),
                        color: kWhiteColor,
                        child: SafeArea(
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    CupertinoButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      onPressed: () {
                                        Get.to(() => SettingsScreen);
                                      },
                                      child: Image.asset(
                                          'lib/images/settings.png'),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 30.0),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxHeight: height / 2),
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
                                        userController
                                            .requestGalleryPermission()
                                            .then((hasPermission) async {
                                          if (hasPermission) {
                                            await userController
                                                .requestNotificationPermission();
                                            await userController
                                                .checkNotificationPermission(
                                                    firstPermissionCheck: true);
                                            await userController
                                                .setTutorialCompleted(true);
                                            await TabsController.to
                                                .loadAssetPath();
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 201.0,
                                        height: 44.0,
                                        decoration: BoxDecoration(
                                          gradient: kPrimaryGradient,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                              letterSpacing:
                                                  -0.4099999964237213,
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
                    } else if (controller.currentTab.value == 0 &&
                        userController.hasGalleryPermission.value)
                      return UntaggedTab();
                    else if (controller.currentTab.value == 1 &&
                        userController.hasGalleryPermission.value) {
                      return PicTab(
                        showDeleteSecretModal: showDeleteSecretModal,
                      );
                    } else if (controller.currentTab.value == 2 &&
                        userController.hasGalleryPermission.value) {
                      return TaggedTab();
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          ),
          Obx(() => controller.modalCard.value
              ? Material(
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
                            itemCount: controller.currentTab.value == 0
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
                                    bottom: bottomInsets > 0
                                        ? bottomInsets + 5
                                        : 32.0,
                                    top: bottomInsets > 0 ? 5 : 26.0,
                                    left: 2.0,
                                    right: 2.0,
                                  ),
                                  child: PhotoCard(
                                    picStore: controller.currentTab.value == 0
                                        ? GalleryStore.to.swipePics[index]
                                        : GalleryStore.to.thumbnailsPics[index],
                                    picsInThumbnails: PicSource.UNTAGGED,
                                    /*  showEditTagModal: () =>
                                          showEditTagModal(context),
                                      showDeleteSecretModal: showDeleteSecretModal, */
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
                )
              : Container()),
          Obx(() => controller.isLoading.value
              ? Material(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: SpinKitChasingDots(
                      color: kPrimaryColor,
                      size: 80.0,
                    ),
                  ),
                )
              : Container()),
        ],
      ),
    );
  }
}
