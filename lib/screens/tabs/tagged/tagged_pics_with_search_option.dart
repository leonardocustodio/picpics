import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/tabs/tagged/tagged_photo_grouping.dart';
import 'package:picPics/screens/tabs/tagged/tagged_tab_date.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:intl/intl.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/widgets/top_bar.dart';

class TaggedPicsInDeviceWithSearchOption extends GetWidget<TagsController> {
  TaggedPicsInDeviceWithSearchOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  showSecretSwitch:
                      PrivatePhotosController.to.showPrivate.value,
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
                    if (controller.isSearching.value)
                      Obx(() {
                        if (controller.isSearching.value) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (controller
                                  .selectedFilteringTagsKeys.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, bottom: 8.0),
                                  child: TagsList(
                                    tagsKeyList: controller
                                        .selectedFilteringTagsKeys.keys
                                        .toList(),
                                    tagStyle: TagStyle.MultiColored,
                                    onTap: (String tagKey) {
                                      controller
                                          .removeTagKeyFromFiltering(tagKey);
                                    },
                                    onPanEnd: (String tagKey) {
                                      controller
                                          .removeTagKeyFromFiltering(tagKey);
                                    },
                                    onDoubleTap: (String tagKey) {
                                      //print('do nothing');
                                    },
                                    // showEditTagModal: showEditTagModal,
                                  ),
                                ),
                              //                            if (GalleryStore.to.showSearchTagsResults) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  controller.searchText.value != ''
                                      /* GalleryStore.to.showSearchTagsResults.value */
                                      ? S.current.search_results
                                      : S.current.recent_tags,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xff979a9b),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                              ),
                              controller.searchTagsResults.isNotEmpty
                                  //print('############ ${GalleryStore.to.tagsSuggestions}');
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16,
                                          top: 8.0,
                                          bottom: 16.0),
                                      child: TagsList(
                                        tagsKeyList: controller
                                            .searchTagsResults
                                            .map((e) => e.key)
                                            .toList(),
                                        tagStyle: TagStyle.GrayOutlined,
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
                                          //print('do nothing');
                                        },
                                        onPanEnd: (String tagKey) {
                                          //print('do nothing');
                                        },
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 26.0, bottom: 10.0),
                                      child: Text(
                                        S.current.no_tags_found,
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xff979a9b),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -0.4099999964237213,
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
              }),
            ),
            Expanded(
              child: GetX<TabsController>(builder: (tabsController) {
                if (TaggedController.to.toggleIndexTagged.value == 0) {
                  return TaggedTabDate();
                } else {
                  return TaggedPhotosGrouping();
                }
              }),
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
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      height: 40.0,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 10),
            decoration: isSelected
                ? BoxDecoration(
                    gradient: kSecondaryGradient,
                    borderRadius: BorderRadius.circular(10.0),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey, width: 1.0)),
            child:
                isSelected ? Image.asset('lib/images/checkwhiteico.png') : null,
          ),
          Text(
            '${dateFormat(date)}',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14.0,
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
