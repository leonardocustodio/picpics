import 'dart:io';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/functions.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/refresh_everything.dart';
import 'package:picPics/widgets/tags_list.dart';

class TaggedTabOptionBar extends GetWidget<TaggedController> {
  TaggedTabOptionBar({Key? key}) : super(key: key);

  final bottomTagsEditingController = TextEditingController();
  final tagsController = Get.find<TagsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.multiTagSheet.value) {
        return ExpandableNotifier(
          controller: controller.expandableController.value,
          child: Container(
            color: Color(0x0ff1f3f5),
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

                              if (tagsController.multiPicTags[kSecretTagKey] !=
                                  null) {
                                showDeleteSecretModalForMultiPic();
                                return;
                              }

                              controller.setMultiTagSheet(false);
                              controller.setMultiPicBar(false);
                              await tagsController.addTagsToSelectedPics();
                              await refresh_everything();
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
                              tagsKeyList:
                                  tagsController.multiPicTags.keys.toList(),
                              addTagField: true,
                              textEditingController:
                                  bottomTagsEditingController,
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
                                tagsController.multiPicTags.remove(tagKey);
                                tagsController.tagsSuggestionsCalculate();
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
                                tagsController.searchText.value = text;
                                tagsController.tagsSuggestionsCalculate();
                                //GalleryStore.to.setSearchText(text);
                              },
                              onSubmitted: (text) {
                                // if (!UserController.to.isPremium) {
                                //   Get.to(() =>   PremiumScreen);
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
                                      print('tag does not exist! creating it!');
                                      tagsController.createTag(text);
                                    }
                                    tagsController.multiPicTags[tagKey] = '';
                                    tagsController.searchText.value = '';
                                  }
                                }
                              }),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TagsList(
                              title: tagsController.searchText.value != ''
                                  ? S.of(context).search_results
                                  : S.of(context).recent_tags,
                              tagsKeyList: tagsController
                                  .searchTagsResults.value
                                  .where((tag) =>
                                      tagsController.multiPicTags[tag.key] ==
                                      null)
                                  .toList()
                                  .map((e) => e.key)
                                  .toList(),
                              tagStyle: TagStyle.GrayOutlined,
                              onTap: (String tagKey) {
                                /* if (!UserController
                                                      .to.isPremium.value) {
                                                    Get.to(() => PremiumScreen);
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
        );
      }
      if (!controller.multiPicBar.value) {
        return Container(
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
              duration: Duration(milliseconds: 500),
              opacity: controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
              child: Image.asset('lib/images/tagtabbutton.png')),
        ),
        BottomNavigationBarItem(
          label: 'Share',
          icon: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
              child: Image.asset('lib/images/sharetabbutton.png')),
        ),
        BottomNavigationBarItem(
            label: 'Trash',
            icon: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
              child: Image.asset('lib/images/trashtabbutton.png'),
            )),
      ];
      return Platform.isIOS
          ? CupertinoTabBar(
              onTap: (index) {
                controller.setTabIndexAllTaggedKeys(index);
              },
              iconSize: 24,
              border:
                  Border(top: BorderSide(color: Color(0xFFE2E4E5), width: 1.0)),
              items: listOfBottomNavigationItems)
          : SizedBox(
              height: 64,
              child: BottomNavigationBar(
                  onTap: (index) {
                    controller.setTabIndexAllTaggedKeys(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: listOfBottomNavigationItems),
            );
    });
  }
}
