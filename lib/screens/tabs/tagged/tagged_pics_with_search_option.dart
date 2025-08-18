import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/tabs/tagged/tagged_photo_grouping.dart';
import 'package:picpics/screens/tabs/tagged/tagged_tab_date.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/tagged_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/widgets/tags_list.dart';
import 'package:picpics/widgets/top_bar.dart';

class TaggedPicsInDeviceWithSearchOption extends GetWidget<TagsController> {
  const TaggedPicsInDeviceWithSearchOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            Container(
              child: GetX<TabsController>(builder: (tabsController) {
                return TopBar(
                  showUntag: tabsController.currentTab.value == 2 &&
                      tabsController.multiPicBar.value &&
                      tabsController.selectedMultiBarPics.isNotEmpty,
                  onUntag: () {
                    TaggedController.to
                        .untagPicsFromTagFromDateOrGroupingCallable();
                  },
                  searchEditingController:
                      TaggedController.to.searchEditingController,
                  onChanged: (String value) {
                    controller.isSearching.value =
                        TaggedController.to.searchFocusNode.hasFocus ||
                            value.isNotEmpty ||
                            controller.selectedFilteringTagsKeys.isNotEmpty;
                    controller.searchText.value = value;
                  },
                  onSubmitted: (String value) {
                    controller.isSearching.value =
                        TaggedController.to.searchFocusNode.hasFocus ||
                            value.isNotEmpty ||
                            controller.selectedFilteringTagsKeys.isNotEmpty;
                    controller.searchTagsResults.clear();
                  },
                  searchFocusNode: TaggedController.to.searchFocusNode,
                  children: <Widget>[
                    Obx(() {
                      if (controller.isSearching.value) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (controller.selectedFilteringTagsKeys.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 8,),
                                child: TagsList(
                                  tagsKeyList: controller
                                      .selectedFilteringTagsKeys.keys
                                      .toList(),
                                  tagStyle: TagStyle.multiColored,
                                  onTap: (String tagKey) {
                                    controller
                                        .removeTagKeyFromFiltering(tagKey);
                                  },
                                  onPanEnd: (String tagKey) {
                                    controller
                                        .removeTagKeyFromFiltering(tagKey);
                                  },
                                  onDoubleTap: (String tagKey) {
                                    AppLogger.d('do nothing');
                                  },
                                  // showEditTagModal: showEditTagModal,
                                ),
                              ),
                            //                            if (GalleryStore.to.showSearchTagsResults) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Obx(
                                () => Text(
                                  controller.searchText.value != ''
                                      /* GalleryStore.to.showSearchTagsResults.value */
                                      ? LangControl.to.S.value.search_results
                                      : LangControl.to.S.value.recent_tags,
                                  textScaler: const TextScaler.linear(1),
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xff979a9b),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                              ),
                            ),

                            if (controller.searchTagsResults.isNotEmpty) Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 8,
                                        bottom: 16,),
                                    child: TagsList(
                                      tagsKeyList: controller.searchTagsResults
                                          .map((e) => e.key)
                                          .toList(),
                                      tagStyle: TagStyle.grayOutlined,
                                      /* showEditTagModal: showEditTagModal, */
                                      onTap: (tagKey) {
                                        /* if (controller.toggleIndexTagged.value == 0) {
                                                          TabsController.to
                                                              .setToggleIndexTagged(1);
                                                        } */

                                        controller
                                            .addTagKeyForFiltering(tagKey);
                                        /* searchEditingController.clear(); */
                                        /* GalleryStore.to.searchResultsTags(
                                                            searchEditingController.text); */
                                      },
                                      onDoubleTap: (String tagKey) {
                                        AppLogger.d('do nothing');
                                      },
                                      onPanEnd: (String tagKey) {
                                        AppLogger.d('do nothing');
                                      },
                                    ),
                                  ) else Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 26, bottom: 10,),
                                    child: Obx(
                                      () => Text(
                                        LangControl.to.S.value.no_tags_found,
                                        textScaler: const TextScaler.linear(1),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xff979a9b),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -0.4099999964237213,
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              height: 1,
                              color: kLightGrayColor,
                            ),
                          ],
                        );
                      }
                      return Container();
                    }),
                  ],
                );
              },),
            ),
            Expanded(
              child: GetX<TaggedController>(
                builder: (taggedController) {
                  if (taggedController.toggleIndexTagged.value == 0) {
                    return TaggedTabDate();
                  }
                  return const TaggedPhotosGrouping();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String dateFormat(DateTime dateTime) {
    return DateFormat.yMMMM().format(dateTime);
  }

  Widget buildDateHeader(DateTime date, bool isSelected) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      height: 40,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 10),
            decoration: isSelected
                ? BoxDecoration(
                    gradient: kSecondaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),),
            child:
                isSelected ? Image.asset('lib/images/checkwhiteico.png') : null,
          ),
          Text(
            dateFormat(date),
            textScaler: const TextScaler.linear(1),
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ],
      ),
    );
  }
}
