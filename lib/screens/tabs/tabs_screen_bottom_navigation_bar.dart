import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/utils/functions.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/widgets/tags_list.dart';

class TabsScreenBottomNavigatioBar extends GetWidget<TabsController> {
  TabsScreenBottomNavigatioBar({super.key});
  final TextEditingController tagsEditingController = TextEditingController();

  final TextEditingController bottomTagsEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.multiTagSheet.value
          ? ExpandableNotifier(
              controller: controller.expandableController.value,
              child: ColoredBox(
                color: const Color(0x00f1f3f5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        controller.expandableController.value.expanded =
                            !controller.expandableController.value.expanded;
                      },
                      child: SafeArea(
                        bottom: !controller.expandableController.value.expanded,
                        child: ColoredBox(
                          color: const Color(0xFFF1F3F5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CupertinoButton(
                                onPressed: () {
                                  controller.setMultiTagSheet(false);
                                },
                                child: SizedBox(
                                  width: 80,
                                  child: Text(
                                    LangControl.to.S.value.cancel,
                                    textScaler: const TextScaler.linear(1),
                                    style: const TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: 16,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              CupertinoButton(
                                onPressed: () async {
                                  // if (!UserController.to.isPremium) {
                                  //   Get.to<void>(() =>   PremiumScreen());
                                  //   return;
                                  // }

                                  if (TagsController
                                          .to.multiPicTags[kSecretTagKey] !=
                                      null) {
                                    showDeleteSecretModalForMultiPic();
                                    return;
                                  }

                                  controller.setMultiTagSheet(false);
                                  controller.setMultiPicBar(false);

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) async {
                                    await TagsController.to
                                        .addTagsToSelectedPics();
                                  });
                                },
                                child: SizedBox(
                                  width: 80,
                                  child: Text(
                                    LangControl.to.S.value.ok,
                                    textScaler: const TextScaler.linear(1),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
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
                        padding: const EdgeInsets.all(24),

                        /// TODO: Tags List Not Showing
                        color: const Color(0xFFEFEFF4).withValues(alpha: 0.94),
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TagsList(
                                  tagStyle: TagStyle.multiColored,
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
                                    ///    Get.to<void>(() =>   PremiumScreen);
                                    ///    return;
                                    ///  }
                                    AppLogger.d('do nothing');
                                  },
                                  onPanEnd: (String tagKey) {
                                    // if (!UserController.to.isPremium) {
                                    //   Get.to<void>(() =>   PremiumScreen);
                                    //   return;
                                    // }
                                    TagsController.to.multiPicTags
                                        .remove(tagKey);
                                    TagsController.to
                                        .tagsSuggestionsCalculate();
                                    //GalleryStore.to.removeFromMultiPicTags(tagKey);
                                  },
                                  onDoubleTap: (String tagKey) {
                                    // if (!UserController.to.isPremium) {
                                    //   Get.to<void>(() =>   PremiumScreen);
                                    //   return;
                                    // }
                                    AppLogger.d('do nothing');
                                  },
                                  onChanged: (text) {
                                    TagsController.to.searchText.value = text;
                                    TagsController.to
                                        .tagsSuggestionsCalculate();
                                    //GalleryStore.to.setSearchText(text);
                                  },
                                  onSubmitted: (text) {
                                    // if (!UserController.to.isPremium) {
                                    //   Get.to<void>(() =>   PremiumScreen);
                                    //   return;
                                    // }
                                    if (text != '') {
                                      bottomTagsEditingController.clear();
                                      TagsController.to.searchText.value = text;
                                      TagsController.to
                                          .tagsSuggestionsCalculate();
                                      final tagKey = Helpers.encryptTag(text);

                                      if (TagsController
                                              .to.multiPicTags[tagKey] ==
                                          null) {
                                        if (TagsController.to.allTags[tagKey] ==
                                            null) {
                                          AppLogger.d(
                                              'tag does not exist! creating it!',);
                                          TagsController.to.createTag(text);
                                        }
                                        TagsController.to.multiPicTags[tagKey] =
                                            '';
                                        TagsController.to.searchText.value = '';
                                      }
                                    }
                                  },),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: TagsList(
                                  title: TagsController.to.searchText.value !=
                                          ''
                                      ? LangControl.to.S.value.search_results
                                      : LangControl.to.S.value.recent_tags,
                                  tagsKeyList: TagsController
                                      .to.searchTagsResults.value
                                      .where((tag) =>
                                          TagsController
                                              .to.multiPicTags[tag.key] ==
                                          null,)
                                      .toList()
                                      .map((e) => e.key)
                                      .toList(),
                                  tagStyle: TagStyle.grayOutlined,
                                  /* showEditTagModal: () =>
                                                  showEditTagModal(context), */
                                  onTap: (String tagKey) {
                                    /* if (!UserController
                                                    .to.isPremium.value) {
                                                  Get.to<void>(() => PremiumScreen);
                                                  return;
                                                } */

                                    bottomTagsEditingController.clear();
                                    TagsController.to.searchText.value = '';
                                    //GalleryStore.to.setSearchText('');
                                    TagsController.to.multiPicTags[tagKey] = '';
                                    TagsController.to
                                        .tagsSuggestionsCalculate();
                                    //GalleryStore.to.addToMultiPicTags(tagKey);
                                  },
                                  onDoubleTap: (String tagKey) {
                                    /* if (!UserController
                                                    .to.isPremium.value) {
                                                  Get.to<void>(() => PremiumScreen);
                                                  return;
                                                } */
                                    AppLogger.d('do nothing');
                                  },
                                  onPanEnd: (String tagKey) {
                                    /* if (!UserController
                                                    .to.isPremium.value) {
                                                  Get.to<void>(() => PremiumScreen);
                                                  return;
                                                } */
                                    AppLogger.d('do nothing');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      collapsed: Container(),
                    ),
                    Expandable(
                      collapsed: Container(),
                      controller: controller.expandablePaddingController.value,
                      expanded: Container(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Obx(() {
              final ignore = TabsController.to.selectedMultiBarPics.isEmpty;
              if (!controller.multiPicBar.value) {
                return Platform.isIOS
                    ? CupertinoTabBar(
                        currentIndex: controller.currentTab.value,
                        onTap: (index) {
                          controller.setTabIndex(index);
                        },
                        iconSize: 32,
                        border: const Border(
                            top: BorderSide(
                                color: Color(0xFFE2E4E5),),),
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            //title: Container(),
                            icon: Image.asset(
                                'lib/images/untaggedtabinactive.png',),
                            activeIcon:
                                Image.asset('lib/images/untaggedtabactive.png'),
                          ),
                          BottomNavigationBarItem(
                            //title: Container(),
                            icon: Image.asset('lib/images/pictabinactive.png'),
                            activeIcon:
                                Image.asset('lib/images/pictabactive.png'),
                          ),
                          BottomNavigationBarItem(
                            //title: Container(),
                            icon:
                                Image.asset('lib/images/taggedtabinactive.png'),
                            activeIcon:
                                Image.asset('lib/images/taggedtabactive.png'),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 92,
                        child: BottomNavigationBar(
                          currentIndex: controller.currentTab.value,
                          onTap: (index) {
                            controller.setTabIndex(index);
                          },
                          type: BottomNavigationBarType.fixed,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          iconSize: 32,
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              label: 'Untagged photos',
                              icon: Image.asset(
                                  'lib/images/untaggedtabinactive.png',),
                              activeIcon: Image.asset(
                                  'lib/images/untaggedtabactive.png',),
                            ),
                            BottomNavigationBarItem(
                              label: 'Swipe photos',
                              icon:
                                  Image.asset('lib/images/pictabinactive.png'),
                              activeIcon:
                                  Image.asset('lib/images/pictabactive.png'),
                            ),
                            BottomNavigationBarItem(
                              label: 'Tagged photos',
                              icon: Image.asset(
                                  'lib/images/taggedtabinactive.png',),
                              activeIcon:
                                  Image.asset('lib/images/taggedtabactive.png'),
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
                      iconSize: 24,
                      border: const Border(
                          top:
                              BorderSide(color: Color(0xFFE2E4E5)),),
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: Image.asset('lib/images/returntabbutton.png'),
                        ),
                        if (controller.currentTab.value == 2)
                          BottomNavigationBarItem(
                            //title: Container(),
                            icon: AnimatedOpacity(
                              opacity: ignore ? 0.3 : 1,
                              duration: const Duration(seconds: 1),
                              child: Image.asset('lib/images/starico.png'),
                            ),
                          ),
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: AnimatedOpacity(
                            opacity: ignore ? 0.3 : 1,
                            duration: const Duration(seconds: 1),
                            child: Image.asset('lib/images/tagtabbutton.png'),
                          ),
                        ),
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: AnimatedOpacity(
                            opacity: ignore ? 0.3 : 1,
                            duration: const Duration(seconds: 1),
                            child: Image.asset('lib/images/sharetabbutton.png'),
                          ),
                        ),
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: AnimatedOpacity(
                            opacity: ignore ? 0.3 : 1,
                            duration: const Duration(seconds: 1),
                            child: Image.asset('lib/images/trashtabbutton.png'),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 92,
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
                            icon: Image.asset('lib/images/returntabbutton.png'),
                          ),
                          if (controller.currentTab.value == 2)
                            BottomNavigationBarItem(
                              label: 'Feature',
                              icon: AnimatedOpacity(
                                opacity: ignore ? 0.3 : 1,
                                duration: const Duration(seconds: 1),
                                child: Image.asset('lib/images/starico.png'),
                              ),
                            ),
                          BottomNavigationBarItem(
                            label: 'Tag',
                            icon: AnimatedOpacity(
                              opacity: ignore ? 0.3 : 1,
                              duration: const Duration(seconds: 1),
                              child: Image.asset('lib/images/tagtabbutton.png'),
                            ),
                          ),
                          BottomNavigationBarItem(
                            label: 'Share',
                            icon: AnimatedOpacity(
                              opacity: ignore ? 0.3 : 1,
                              duration: const Duration(seconds: 1),
                              child:
                                  Image.asset('lib/images/sharetabbutton.png'),
                            ),
                          ),
                          BottomNavigationBarItem(
                            label: 'Trash',
                            icon: AnimatedOpacity(
                              opacity: ignore ? 0.3 : 1,
                              duration: const Duration(seconds: 1),
                              child:
                                  Image.asset('lib/images/trashtabbutton.png'),
                            ),
                          ),
                        ],
                      ),
                    );
            }),
    );
  }
}
