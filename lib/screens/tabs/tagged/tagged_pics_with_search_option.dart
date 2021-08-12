import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/tabs/tagged/tagged_photo_section.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/widgets/top_bar.dart';

class TaggedPicsInDeviceWithSearchOption extends GetWidget<TagsController> {
  TaggedPicsInDeviceWithSearchOption({Key? key}) : super(key: key);
  final taggedController = Get.find<TaggedController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          showSecretSwitch: PrivatePhotosController.to.showPrivate.value,
          searchEditingController: taggedController.searchEditingController,
          onChanged: (String value) {
            controller.isSearching.value =
                taggedController.searchFocusNode.hasFocus ||
                    value.isNotEmpty ||
                    controller.selectedFilteringTagsKeys.isNotEmpty;
            controller.searchText.value = value;
          },
          onSubmitted: (String value) {
            controller.isSearching.value =
                taggedController.searchFocusNode.hasFocus ||
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
                            left: 16.0, right: 16.0, bottom: 8.0),
                        child: TagsList(
                          tagsKeyList: controller.selectedFilteringTagsKeys.keys
                              .toList(),
                          tagStyle: TagStyle.MultiColored,
                          onTap: (String tagKey) {
                            controller.removeTagKeyFromFiltering(tagKey);
                          },
                          onPanEnd: (String tagKey) {
                            controller.removeTagKeyFromFiltering(tagKey);
                          },
                          onDoubleTap: (String tagKey) {
                            //print('do nothing');
                          },
                          // showEditTagModal: showEditTagModal,
                        ),
                      ),
                    //                            if (GalleryStore.to.showSearchTagsResults) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    Obx(
                      () {
                        if (controller.searchTagsResults.isNotEmpty) {
                          //print('############ ${GalleryStore.to.tagsSuggestions}');
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 8.0, bottom: 16.0),
                            child: TagsList(
                              tagsKeyList: controller.searchTagsResults
                                  .map((e) => e.key)
                                  .toList(),
                              tagStyle: TagStyle.GrayOutlined,
                              /* showEditTagModal: showEditTagModal, */
                              onTap: (tagKey) {
                                /* if (controller.toggleIndexTagged.value == 0) {
                                                TabsController.to
                                                    .setToggleIndexTagged(1);
                                              } */

                                controller.addTagKeyForFiltering(tagKey);
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
                          );
                        } else {
                          return Container(
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
                          );
                        }
                      },
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
        ),
        NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollStartNotification) {
              //print('Start scrolling');
              TaggedController.to.setIsScrolling(true);
              return true;
            } else if (scrollNotification is ScrollEndNotification) {
              //print('End scrolling');
              TaggedController.to.setIsScrolling(false);
            }
            return false;
          },
          child: Expanded(
            child: TaggedPhotosSection(),
          ),
        ),
      ],
    );
  }
}
