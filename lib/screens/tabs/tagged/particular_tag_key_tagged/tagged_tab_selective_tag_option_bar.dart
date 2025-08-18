import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tagged_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/utils/functions.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/utils/refresh_everything.dart';
import 'package:picpics/widgets/tags_list.dart';

class TaggedTabSelectiveTagOptionBar extends GetWidget<TaggedController> {
  TaggedTabSelectiveTagOptionBar({required this.tagKey, super.key});
  final String tagKey;

  final bottomTagsEditingController = TextEditingController();
  final tagsController = Get.find<TagsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.multiTagSheet.value) {
        return ExpandableNotifier(
          controller: controller.expandableController.value,
          child: ColoredBox(
            color: const Color(0x0ff1f3f5),
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
                              child: Obx(
                                () => Text(
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
                          ),
                          const Spacer(),
                          CupertinoButton(
                            onPressed: () async {
                              // if (!UserController.to.isPremium) {
                              //   Get.to<void>(() =>   PremiumScreen());
                              //   return;
                              // }

                              if (tagsController.multiPicTags[kSecretTagKey] !=
                                  null) {
                                showDeleteSecretModalForMultiPic();
                                return;
                              }

                              controller.setMultiTagSheet(false);
                              controller.setMultiPicBar(false);
                              await tagsController.addTagsToSelectedPics(
                                  selectedPicIds: controller
                                      .selectedMultiBarPics.keys
                                      .toList(),);
                              await refreshEverything();
                            },
                            child: SizedBox(
                              width: 80,
                              child: Obx(
                                () => Text(
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
                              tagsKeyList:
                                  tagsController.multiPicTags.keys.toList(),
                              addTagField: true,
                              textEditingController:
                                  bottomTagsEditingController,
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
                                tagsController.multiPicTags.remove(tagKey);
                                tagsController.tagsSuggestionsCalculate();
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
                                tagsController.searchText.value = text;
                                tagsController.tagsSuggestionsCalculate();
                                //GalleryStore.to.setSearchText(text);
                              },
                              onSubmitted: (text) {
                                // if (!UserController.to.isPremium) {
                                //   Get.to<void>(() =>   PremiumScreen);
                                //   return;
                                // }
                                if (text != '') {
                                  bottomTagsEditingController.clear();
                                  tagsController.searchText.value = text;
                                  tagsController.tagsSuggestionsCalculate();
                                  final tagKey = Helpers.encryptTag(text);

                                  if (tagsController.multiPicTags[tagKey] ==
                                      null) {
                                    if (tagsController.allTags[tagKey] ==
                                        null) {
                                      AppLogger.d(
                                          'tag does not exist! creating it!',);
                                      tagsController.createTag(text);
                                    }
                                    tagsController.multiPicTags[tagKey] = '';
                                    tagsController.searchText.value = '';
                                  }
                                }
                              },),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Obx(
                              () => TagsList(
                                title: tagsController.searchText.value != ''
                                    ? LangControl.to.S.value.search_results
                                    : LangControl.to.S.value.recent_tags,
                                tagsKeyList: tagsController
                                    .searchTagsResults
                                    .where((tag) =>
                                        tag.key != tagKey &&
                                        tagsController.multiPicTags[tag.key] ==
                                            null,)
                                    .toList()
                                    .map((e) => e.key)
                                    .toList(),
                                tagStyle: TagStyle.grayOutlined,
                                onTap: (String tagKey) {
                                  /* if (!UserController
                                                      .to.isPremium.value) {
                                                    Get.to<void>(() => PremiumScreen);
                                                    return;
                                                  } */

                                  bottomTagsEditingController.clear();
                                  tagsController.searchText.value = '';
                                  //GalleryStore.to.setSearchText('');
                                  tagsController.multiPicTags[tagKey] = '';
                                  tagsController.tagsSuggestionsCalculate();
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
        );
      }
      if (!controller.multiPicBar.value) {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
      final listOfBottomNavigationItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: 'Return',
          icon: Image.asset('lib/images/returntabbutton.png'),
        ),
        BottomNavigationBarItem(
          label: 'Tag',
          icon: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
              child: Image.asset('lib/images/tagtabbutton.png'),),
        ),
        BottomNavigationBarItem(
          label: 'Share',
          icon: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
              child: Image.asset('lib/images/sharetabbutton.png'),),
        ),
        BottomNavigationBarItem(
            label: 'Trash',
            icon: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
              child: Image.asset('lib/images/trashtabbutton.png'),
            ),),
      ];
      return Platform.isIOS
          ? CupertinoTabBar(
              onTap: (index) {
                controller.setTabIndexParticularTagKey(index, tagKey);
              },
              iconSize: 24,
              border: const Border(
                  top: BorderSide(color: Color(0xFFE2E4E5)),),
              items: listOfBottomNavigationItems,)
          : SizedBox(
              height: 64,
              child: BottomNavigationBar(
                  onTap: (index) {
                    controller.setTabIndexParticularTagKey(index, tagKey);
                  },
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: listOfBottomNavigationItems,),
            );
    });
  }
}
