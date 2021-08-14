import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/screens/tabs/tagged/tagged_photo_grouping.dart';
import 'package:picPics/screens/tabs/tagged/tagged_tab_date.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:intl/intl.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/refresh_everything.dart';
import 'package:picPics/widgets/date_header.dart';
import 'package:picPics/widgets/photo_widget.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/widgets/top_bar.dart';

class TaggedPicsInDeviceWithSearchOption extends GetWidget<TagsController> {
  TaggedPicsInDeviceWithSearchOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            GetX<TabsController>(builder: (tabsController) {
              return TopBar(
                showUntag: tabsController.currentTab.value == 2 &&
                    tabsController.multiPicBar.value &&
                    tabsController.selectedMultiBarPics.isNotEmpty,
                onUntag: () {
                  TaggedController.to
                      .untagPicsFromTagFromDateOrGroupingCallable();
                },
                showSecretSwitch: PrivatePhotosController.to.showPrivate.value,
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
                                  left: 16.0, right: 16.0, bottom: 8.0),
                              child: TagsList(
                                tagsKeyList: controller
                                    .selectedFilteringTagsKeys.keys
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
            })
          ],
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
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
            child: GetX<TabsController>(builder: (tabsController) {
              if (TaggedController.to.toggleIndexTagged.value == 0) {
                return GetX<TaggedController>(builder: (taggedController) {
                  return StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.only(top: 2),
                      crossAxisCount: 4,
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                      shrinkWrap: true,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      itemCount:
                          taggedController.allTaggedPicDateWiseList.length,
                      staggeredTileBuilder: (int index) {
                        if (taggedController.allTaggedPicDateWiseList[index]
                            is DateTime) {
                          return const StaggeredTile.extent(4, 40);
                        }
                        return const StaggeredTile.count(1, 1);
                      },
                      itemBuilder: (BuildContext _, int index) {
                        return Obx(() {
                          if (taggedController.allTaggedPicDateWiseList[index]
                              is DateTime) {
                            var isSelected = false;
                            if (tabsController.multiPicBar.value) {
                              var i = index + 1;
                              isSelected = true;

                              while (i <
                                      taggedController
                                          .allTaggedPicDateWiseList.length &&
                                  taggedController.allTaggedPicDateWiseList[i]
                                      is String) {
                                if (tabsController.selectedMultiBarPics[
                                        taggedController
                                            .allTaggedPicDateWiseList[i]] ==
                                    null) {
                                  isSelected = false;
                                  break;
                                }
                                i++;
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                if (tabsController.multiPicBar.value) {
                                  var i = index + 1;
                                  if (isSelected) {
                                    while (i <
                                            taggedController
                                                .allTaggedPicDateWiseList
                                                .length &&
                                        taggedController
                                                .allTaggedPicDateWiseList[i]
                                            is String) {
                                      tabsController.selectedMultiBarPics
                                          .remove(taggedController
                                              .allTaggedPicDateWiseList[i]);
                                      i++;
                                    }
                                  } else {
                                    while (i <
                                            taggedController
                                                .allTaggedPicDateWiseList
                                                .length &&
                                        taggedController
                                                .allTaggedPicDateWiseList[i]
                                            is String) {
                                      tabsController.selectedMultiBarPics[
                                          taggedController
                                                  .allTaggedPicDateWiseList[
                                              i]] = true;
                                      i++;
                                    }
                                  }
                                }
                              },
                              child: DateHeaderWidget(
                                  date: taggedController
                                      .allTaggedPicDateWiseList[index],
                                  isSelected: isSelected,
                                  isMonth: true),
                            );
                          }

                          final picId =
                              taggedController.allTaggedPicDateWiseList[index];
                          final blurHash = BlurHashController.to.blurHash[
                              taggedController.allTaggedPicDateWiseList[index]];
                          final picStore = TabsController
                              .to
                              .picStoreMap[taggedController
                                  .allTaggedPicDateWiseList[index]]
                              ?.value;
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  if (tabsController.multiPicBar.value) {
                                    if (tabsController
                                            .selectedMultiBarPics[picId] ==
                                        null) {
                                      tabsController
                                          .selectedMultiBarPics[picId] = true;
                                    } else {
                                      tabsController.selectedMultiBarPics
                                          .remove(picId);
                                    }
                                    return;
                                  }

                                  var result = await Get.to(() => PhotoScreen(
                                      picId: picId,
                                      picIdList: taggedController
                                          .allTaggedPicIdList.keys
                                          .toList()));
                                  if (null == result) {
                                    await refresh_everything();
                                  }
                                },
                                child: GestureDetector(
                                  onLongPress: () {
                                    if (tabsController.multiPicBar.value ==
                                        false) {
                                      tabsController.setMultiPicBar(true);
                                      tabsController
                                          .selectedMultiBarPics[picId] = true;
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: PhotoWidget(
                                          picStore: picStore,
                                          hash: blurHash,
                                        ),
                                      ),
                                      if (picStore != null &&
                                          picStore.isStarred.value)
                                        Positioned(
                                          left: 6,
                                          top: 6,
                                          child: Image.asset(
                                              'lib/images/staryellowico.png'),
                                        ),
                                      if (tabsController.multiPicBar.value &&
                                          tabsController.selectedMultiBarPics[
                                                  picId] !=
                                              null &&
                                          tabsController.selectedMultiBarPics[
                                                  picId] ==
                                              true) ...[
                                        Container(
                                          constraints: BoxConstraints.expand(),
                                          decoration: BoxDecoration(
                                            color: kSecondaryColor
                                                .withOpacity(0.3),
                                            border: Border.all(
                                              color: kSecondaryColor,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 8.0,
                                          top: 6.0,
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              gradient: kSecondaryGradient,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Image.asset(
                                                'lib/images/checkwhiteico.png'),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      });
                });
              } else {
                return TaggedPhotosGrouping();
              }
            }),
          ),
        ),
      ],
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
