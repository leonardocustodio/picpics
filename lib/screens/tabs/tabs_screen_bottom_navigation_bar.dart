import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/functions.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/widgets/tags_list.dart';

class TabsScreenBottomNavigatioBar extends GetWidget<TabsController> {
  TabsScreenBottomNavigatioBar({Key? key}) : super(key: key);
  TextEditingController tagsEditingController = TextEditingController();

  TextEditingController bottomTagsEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.multiTagSheet.value
          ? ExpandableNotifier(
              controller: controller.expandableController.value,
              child: Container(
                color: Color(0x00f1f3f5),
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
                        child: Container(
                          color: Color(0xFFF1F3F5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                onPressed: () async {
                                  // if (!UserController.to.isPremium) {
                                  //   Get.to(() =>   PremiumScreen());
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
                                      ?.addPostFrameCallback((timeStamp) async {
                                    await TagsController.to
                                        .addTagsToSelectedPics();
                                  });
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
                                    TagsController.to
                                        .tagsSuggestionsCalculate();
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
                                    TagsController.to.searchText.value = text;
                                    TagsController.to
                                        .tagsSuggestionsCalculate();
                                    //GalleryStore.to.setSearchText(text);
                                  },
                                  onSubmitted: (text) {
                                    // if (!UserController.to.isPremium) {
                                    //   Get.to(() =>   PremiumScreen);
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
                                          print(
                                              'tag does not exist! creating it!');
                                          TagsController.to.createTag(text);
                                        }
                                        TagsController.to.multiPicTags[tagKey] =
                                            '';
                                        TagsController.to.searchText.value = '';
                                      }
                                    }
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TagsList(
                                  title:
                                      TagsController.to.searchText.value != ''
                                          ? S.of(context).search_results
                                          : S.of(context).recent_tags,
                                  tagsKeyList: TagsController
                                      .to.searchTagsResults.value
                                      .where((tag) =>
                                          TagsController
                                              .to.multiPicTags[tag.key] ==
                                          null)
                                      .toList()
                                      .map((e) => e.key)
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
                              icon:
                                  Image.asset('lib/images/pictabinactive.png'),
                              activeIcon:
                                  Image.asset('lib/images/pictabactive.png'),
                            ),
                            BottomNavigationBarItem(
                              label: 'Tagged photos',
                              icon: Image.asset(
                                  'lib/images/taggedtabinactive.png'),
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
                      iconSize: 24.0,
                      border: Border(
                          top:
                              BorderSide(color: Color(0xFFE2E4E5), width: 1.0)),
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: Image.asset('lib/images/returntabbutton.png'),
                        ),
                        /* if (controller.currentTab.value == 2)
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: Image.asset('lib/images/starico.png'),
                        ), */
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: Image.asset('lib/images/tagtabbutton.png'),
                        ),
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: controller.selectedMultiBarPics
                                  .isEmpty /* GalleryStore.to.selectedPics.isEmpty */
                              ? Opacity(
                                  opacity: 0.2,
                                  child: Image.asset(
                                      'lib/images/sharetabbutton.png'),
                                )
                              : Image.asset('lib/images/sharetabbutton.png'),
                        ),
                        BottomNavigationBarItem(
                          //title: Container(),
                          icon: controller.selectedMultiBarPics
                                  .isEmpty // GalleryStore.to.selectedPics.isEmpty
                              ? Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                      'lib/images/trashtabbutton.png'),
                                )
                              : Image.asset('lib/images/trashtabbutton.png'),
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
                            icon: Image.asset('lib/images/returntabbutton.png'),
                          ),
                          /* if (controller.currentTab.value == 2)
                          BottomNavigationBarItem(
                            label: 'Feature',
                            icon: Image.asset('lib/images/starico.png'),
                          ), */
                          BottomNavigationBarItem(
                            label: 'Tag',
                            icon: TabsController.to.selectedMultiBarPics.isEmpty
                                ? Opacity(
                                    opacity: 0.3,
                                    child: Image.asset(
                                        'lib/images/tagtabbutton.png'),
                                  )
                                : Image.asset('lib/images/tagtabbutton.png'),
                          ),
                          BottomNavigationBarItem(
                            label: 'Share',
                            icon: TabsController.to.selectedMultiBarPics.isEmpty
                                ? Opacity(
                                    opacity: 0.3,
                                    child: Image.asset(
                                        'lib/images/sharetabbutton.png'),
                                  )
                                : Image.asset('lib/images/sharetabbutton.png'),
                          ),
                          BottomNavigationBarItem(
                            label: 'Trash',
                            icon: TabsController.to.selectedMultiBarPics.isEmpty
                                ? Opacity(
                                    opacity: 0.3,
                                    child: Image.asset(
                                        'lib/images/trashtabbutton.png'),
                                  )
                                : Image.asset('lib/images/trashtabbutton.png'),
                          ),
                        ],
                      ),
                    );
            }),
    );
  }
}
