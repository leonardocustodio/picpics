import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/custom_scroll_physics.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/stores/tagged_pics_store.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/widgets/toggle_bar.dart';
import 'package:picPics/widgets/top_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TaggedTab extends GetWidget<TabsController> {
  static const id = 'tagged_tab';

  final Function showEditTagModal;

  TaggedTab({
    @required this.showEditTagModal,
  });

  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  TextEditingController tagsEditingController = TextEditingController();

  Widget _buildTaggedGridView(BuildContext context) {
    //print('Rebuilding tagged gridview');
    //print('&&&&&&&&&&&&&&&&& Build grid items!!!');

    double newPadding = 0.0;
    if (GalleryStore.to.isSearching.value) {
      newPadding = 86 - controller.offsetThirdTab;
      if (newPadding > 86) {
        newPadding = 86.0;
      } else if (newPadding < 0) {
        newPadding = 0.0;
      }
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          //print('Start scrolling');
          controller.setIsScrolling(true);
        } else if (scrollNotification is ScrollEndNotification) {
          //print('End scrolling');
          controller.setIsScrolling(false);
        }
        return;
      },
      child: Obx(
        () {
          if (controller.toggleIndexTagged == 0) {
            return StaggeredGridView.countBuilder(
              key: Key('date'),
              controller: controller.scrollControllerThirdTab,
              physics: const CustomScrollPhysics(),
              padding: EdgeInsets.only(top: 86 - newPadding),
              crossAxisCount: 3,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              itemCount: GalleryStore.to.taggedGridPics.length,
              itemBuilder: (BuildContext context, int index) {
                var picStore = GalleryStore.to.taggedGridPics[index].picStore;
                if (picStore == null) {
                  return _buildDateItem(
                      GalleryStore.to.taggedGridPics[index].date);
                }
                return _buildPicItem(picStore);
              },
              staggeredTileBuilder: (int index) {
                return GalleryStore.to.taggedGridPics[index].picStore == null
                    ? StaggeredTile.fit(3)
                    : StaggeredTile.count(1, 1);
              },
            );
          }

          return StaggeredGridView.countBuilder(
            key: Key('tag'),
            controller: controller.scrollControllerThirdTab,
            // padding: EdgeInsets.only(top: 86.0),
            padding: EdgeInsets.only(top: 86 - newPadding),
            physics: const CustomScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            itemCount: GalleryStore.to.isTitleWidget.value.length,
            itemBuilder: (BuildContext context, int index) {
              var item = GalleryStore.to.taggedItems.value[index];

              if (item is TaggedPicsStore) {
                return _buildTagItem(item);
              } else if (item is PicStore) {
                return _buildPicItem(item);
              } else {
                if (index == 0) {
                  return _buildTagItem(null);
                } else {
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      index == 1
                          ? S.current.search_all_tags_not_found
                          : 'No photos found with this tag',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff979a9b),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  );
                }
              }
            },
            staggeredTileBuilder: (int index) {
              if (GalleryStore.to.isTitleWidget.value[index]) {
                return StaggeredTile.fit(3);
              }
              return StaggeredTile.count(1, 1);
            },
          );
        },
      ),
    );
  }

  String dateFormat(DateTime dateTime) {
    DateFormat formatter;
    //print('Date Time Formatting: $dateTime');

    if (dateTime.year == DateTime.now().year) {
      formatter = DateFormat.MMMEd();
    } else {
      formatter = DateFormat.yMMMEd();
    }
    return formatter.format(dateTime);
  }

  Widget _buildDateItem(DateTime date) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      height: 40.0,
      child: Row(
        children: [
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

    //   Container(
    //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: <Widget>[
    //       Text(
    //         '${dateFormat(date)}',
    //         textScaleFactor: 1.0,
    //         style: TextStyle(
    //           fontFamily: 'Lato',
    //           color: Color(0xff606566),
    //           fontSize: 24,
    //           fontWeight: FontWeight.w400,
    //           fontStyle: FontStyle.normal,
    //           letterSpacing: -0.4099999964237213,
    //         ),
    //       ),
    //       // CupertinoButton(
    //       //   onPressed: () async {
    //       //     controller.setIsLoading(true);
    //       //
    //       //     // if (taggedPicsStore != null) {
    //       //     //   await GalleryStore.to.sharePics(picsStores: taggedPicsStore.pics);
    //       //     // } else {
    //       //     //   await GalleryStore.to.sharePics(
    //       //     //       picsStores: GalleryStore.to.filteredPics);
    //       //     // }
    //       //
    //       //     controller.setIsLoading(false);
    //       //   },
    //       //   child: Image.asset('lib/images/sharepicsico.png'),
    //       // ),
    //     ],
    //   ),
    // );
  }

  Widget _buildTagItem(TaggedPicsStore taggedPicsStore) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            taggedPicsStore != null
                ? taggedPicsStore.tag.value.name
                : S.current.all_search_tags,
            textScaleFactor: 1.0,
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
          CupertinoButton(
            onPressed: () {
              controller.setIsLoading(true);

              if (taggedPicsStore != null) {
                GalleryStore.to.sharePics(picsStores: taggedPicsStore.pics);
              } else {
                GalleryStore.to
                    .sharePics(picsStores: GalleryStore.to.filteredPics);
              }

              controller.setIsLoading(false);
            },
            child: Image.asset('lib/images/sharepicsico.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildPicItem(PicStore picStore) {
    final AssetEntityImageProvider imageProvider =
        AssetEntityImageProvider(picStore, isOriginal: false);

    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          Widget loader;
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              loader = const ColoredBox(color: kGreyPlaceholder);
              break;
            case LoadState.completed:
              loader = FadeImageBuilder(
                child: () {
                  return GestureDetector(
                    onLongPress: () {
                      //print('LongPress');
                      if (controller.multiPicBar == false) {
                        GalleryStore.to.setSelectedPics(
                          picStore: picStore,
                          picIsTagged: true,
                        );
                        controller.setMultiPicBar(true);
                      }
                    },
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        if (controller.multiPicBar.value) {
                          GalleryStore.to.setSelectedPics(
                            picStore: picStore,
                            picIsTagged: true,
                          );
                          //print('Pics Selected Length: ${GalleryStore.to.selectedPics.length}');
                          return;
                        }

                        //print('Selected photo: ${picStore.photoId}');
                        GalleryStore.to.setCurrentPic(picStore);
                        GalleryStore.to.setInitialSelectedThumbnail(picStore);
                        Get.toNamed(PhotoScreen.id);
                      },
                      child: Obx(() {
                        Widget image = Positioned.fill(
                          child: RepaintBoundary(
                            child: state.completedWidget,
                          ),
                        );

                        List<Widget> items = [image];

                        if (controller.multiPicBar.value) {
                          if (GalleryStore.to.selectedPics.contains(picStore)) {
                            items.add(
                              Container(
                                constraints: BoxConstraints.expand(),
                                decoration: BoxDecoration(
                                  color: kSecondaryColor.withOpacity(0.3),
                                  border: Border.all(
                                    color: kSecondaryColor,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            );
                            items.add(
                              Positioned(
                                left: 8.0,
                                top: 6.0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    gradient: kSecondaryGradient,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Image.asset(
                                      'lib/images/checkwhiteico.png'),
                                ),
                              ),
                            );
                          } else {
                            items.add(
                              Positioned(
                                left: 8.0,
                                top: 6.0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: kGrayColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        if (picStore.isPrivate == true) {
                          items.add(
                            Positioned(
                              right: 8.0,
                              top: 6.0,
                              child: Container(
                                height: 20,
                                width: 20,
                                padding: const EdgeInsets.only(bottom: 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xffffcc00),
                                      Color(0xffffe98f)
                                    ],
                                    stops: [0.2291666716337204, 1],
                                    begin: Alignment(-1.00, 0.00),
                                    end: Alignment(1.00, -0.00),
                                    // angle: 0,
                                    // scale: undefined,
                                  ),
                                ),
                                child: Image.asset(
                                    'lib/images/smallwhitelock.png'),
                              ),
                            ),
                          );
                        }

                        if (picStore.isStarred == true &&
                            !controller.multiPicBar.value) {
                          //print('Adding starred yellow ico');
                          items.add(
                            Positioned(
                              left: 6.0,
                              top: 6.0,
                              child:
                                  Image.asset('lib/images/staryellowico.png'),
                            ),
                          );
                        }

                        return Stack(children: items);
                      }),
                    ),
                  );
                }(),
              );
              break;
            case LoadState.failed:
              loader = Container();
              break;
          }
          return loader;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.only(bottom: 0.0),
//                    constraints: BoxConstraints.expand(),
//                    color: kWhiteColor,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Obx(() {
              if (!GalleryStore.to.deviceHasPics.value) {
                return DeviceHasNoPics(
                  message: S.current.device_has_no_pics,
                );
              } else if (GalleryStore.to.taggedPics.length == 0 &&
                  GalleryStore.to.deviceHasPics.value) {
                return TopBar(
                  appStore: UserController.to,
                  galleryStore: GalleryStore.to,
                  showSecretSwitch: UserController.to.secretPhotos.value,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: height / 2,
                              child:
                                  Image.asset('lib/images/notaggedphotos.png'),
                            ),
                            SizedBox(
                              height: 21.0,
                            ),
                            Text(
                              S.current.no_tagged_photos,
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
                              onPressed: () => controller.setCurrentTab(1),
                              child: Container(
                                width: 201.0,
                                height: 44.0,
                                decoration: BoxDecoration(
                                  gradient: kPrimaryGradient,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    S.current.start_tagging,
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
                    ),
                  ],
                );
              } else if (GalleryStore.to.taggedPics.length > 0 &&
                  GalleryStore.to.deviceHasPics.value) {
                return TopBar(
                  appStore: UserController.to,
                  galleryStore: GalleryStore.to,
                  showSecretSwitch: UserController.to.secretPhotos.value,
                  searchEditingController: searchEditingController,
                  searchFocusNode: searchFocusNode,
                  children: <Widget>[
                    Obx(() {
                      if (GalleryStore.to.isSearching.value) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (GalleryStore.to.searchingTagsKeys.length > 0)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, bottom: 8.0),
                                child: TagsList(
                                  tagsKeyList: GalleryStore.to.searchingTags.value.toList(),
                                  tagStyle: TagStyle.MultiColored,
                                  onTap: (String tagKey) {
                                    //print('do nothing');
                                    GalleryStore.to.removeTagFromSearchFilter();
                                    if (GalleryStore
                                            .to.searchingTagsKeys.isEmpty &&
                                        searchFocusNode.hasFocus == false) {
                                      GalleryStore.to.setIsSearching(false);
                                    }
                                  },
                                  onPanEnd: (String tagKey) {
                                    GalleryStore.to.removeTagFromSearchFilter();
                                    if (GalleryStore
                                            .to.searchingTagsKeys.isEmpty &&
                                        searchFocusNode.hasFocus == false) {
                                      GalleryStore.to.setIsSearching(false);
                                    }
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
                                GalleryStore.to.showSearchTagsResults.value
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
                                if (!GalleryStore
                                    .to.showSearchTagsResults.value) {
                                  //print('############ ${GalleryStore.to.tagsSuggestions}');
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16,
                                        top: 8.0,
                                        bottom: 16.0),
                                    child: TagsList(
                                      tagsKeyList: GalleryStore.to.tagsSuggestions.value.toList(),
                                      tagStyle: TagStyle.GrayOutlined,
                                      showEditTagModal: showEditTagModal,
                                      onTap: (tagId, tagName) {
                                        if (controller.toggleIndexTagged == 0) {
                                          controller.setToggleIndexTagged(1);
                                        }

                                        GalleryStore.to.addTagToSearchFilter();
                                        searchEditingController.clear();
                                        GalleryStore.to.searchResultsTags(
                                            searchEditingController.text);
                                      },
                                      onDoubleTap: () {
                                        //print('do nothing');
                                      },
                                      onPanEnd: () {
                                        //print('do nothing');
                                      },
                                    ),
                                  );
                                }

                                if (GalleryStore.to.searchTagsResults.isEmpty) {
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
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 8.0,
                                      bottom: 16.0),
                                  child: TagsList(
                                    tags: GalleryStore.to.searchTagsResults
                                        .toList(),
                                    tagStyle: TagStyle.GrayOutlined,
                                    showEditTagModal: showEditTagModal,
                                    onTap: (tagId, tagName) {
                                      if (controller.toggleIndexTagged == 0) {
                                        controller.setToggleIndexTagged(1);
                                      }

                                      GalleryStore.to.addTagToSearchFilter();
                                      searchEditingController.clear();
                                      GalleryStore.to.searchResultsTags(
                                          searchEditingController.text);
                                    },
                                    onDoubleTap: () {
                                      //print('do nothing');
                                    },
                                    onPanEnd: () {
                                      //print('do nothing');
                                    },
                                  ),
                                );
                              },
                            ),

//                            ],
                            Container(
                              height: 1,
                              color: kLightGrayColor,
                            ),
                          ],
                        );
                      }
                      return Container();
                    }),
                    Expanded(
                      child: _buildTaggedGridView(context),
                    ),
                  ],
                );
              }
              return Container();
            }),
            Obx(() {
              if (GalleryStore.to.taggedPics.length > 0 &&
                  !controller.hideTitleThirdTab.value &&
                  !GalleryStore.to.isSearching.value &&
                  GalleryStore.to.deviceHasPics.value) {
                return Positioned(
                  left: 19.0,
                  top: 64.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        controller.multiPicBar.value
                            ? S.current.photo_gallery_count(
                                GalleryStore.to.selectedPics.length)
                            : S.current.organized_photos_title,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff979a9b),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }),
            Obx(() {
              return AnimatedOpacity(
                opacity: controller.isScrolling.value
                    ? 0.0
                    : (searchFocusNode.hasFocus ||
                            GalleryStore.to.taggedPics.length == 0)
                        ? 0.0
                        : 1.0,
                curve: Curves.linear,
                duration:
                    Duration(milliseconds: searchFocusNode.hasFocus ? 0 : 300),
                onEnd: () {
                  controller.setIsToggleBarVisible(
                      controller.isScrolling.value ? false : true);
                },
                child: Visibility(
                  visible: controller.isScrolling.value
                      ? controller.isToggleBarVisible
                      : true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ToggleBar(
                        titleLeft: S.current.toggle_date,
                        titleRight: S.current.toggle_tags,
                        activeToggle: controller.toggleIndexTagged.value,
                        onToggle: (index) {
                          if (GalleryStore.to.isSearching.value && index == 0) {
                            GalleryStore.to.clearSearchTags();
                            GalleryStore.to.setShouldRefreshTaggedGallery(true);
                            GalleryStore.to.refreshItems();
                            //print('##### Rebuild everything!');

                          }
                          controller.setToggleIndexTagged(index);
                        },
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
