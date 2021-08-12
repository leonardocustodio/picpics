/* import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/tabs/tagged/select_all_widget.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/functions.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/refresh_everything.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:picPics/widgets/tags_list.dart';
import '../../asset_entity_image_provider.dart';

// ignore: must_be_immutable
class TaggedTabGridView extends GetWidget<TaggedController> {
  final String tagKey;
  TaggedTabGridView(this.tagKey, {Key? key}) : super(key: key);

  //ScrollController scrollControllerFirstTab;
  TextEditingController tagsEditingController = TextEditingController();
  TextEditingController bottomTagsEditingController = TextEditingController();

  Widget _buildGridView(BuildContext context) {
    return Obx(
      () {
        var taggedPicIds = controller.taggedPicId[tagKey]?.keys.toList();
        if (taggedPicIds == null || taggedPicIds.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return StaggeredGridView.countBuilder(
            key: Key('$tagKey'),
            //controller: scrollControllerFirstTab,
            padding: EdgeInsets.only(top: 2),
            crossAxisCount: 5,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            itemCount: taggedPicIds.length,
            staggeredTileBuilder: (_) {
              return StaggeredTile.count(1, 1);
            },
            itemBuilder: (_, int index) {
              return Obx(() {
                final picId = taggedPicIds[index];

                var blurHash = BlurHashController.to.blurHash[picId];

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: null != blurHash
                              ? BlurHash(
                                  hash: blurHash,
                                  color: Colors.transparent,
                                )
                              : greyWidget,
                        ),
                      ),
                    ),
                    if (TabsController.to.picStoreMap[picId]?.value != null)
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: _buildImageWidget(
                                  TabsController.to.picStoreMap[picId]!.value,
                                  picId)),
                        ),
                      ),
                  ],
                );
              });
            });
      },
    );
  }

  Widget _buildImageWidget(PicStore picStore, String picId) {
//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;

    var hash = BlurHashController.to.blurHash[picId];
    final imageProvider = AssetEntityImageProvider(picStore, isOriginal: false);

    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              if (null == hash) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: ColoredBox(color: kGreyPlaceholder),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: BlurHash(
                      hash: hash,
                      color: Colors.transparent,
                    ),
                  ),
                );
              }

            case LoadState.completed:
              return FadeImageBuilder(
                child: GestureDetector(
                  onLongPress: () {
                    //print('LongPress');
                    if (controller.multiPicBar.value == false) {
                      controller.selectedMultiBarPics[picId] = true;
                      controller.setMultiPicBar(true);
                    }
                  },
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      if (controller.multiPicBar.value) {
                        if (controller.selectedMultiBarPics[picId] == null) {
                          controller.selectedMultiBarPics[picId] = true;
                        } else {
                          controller.selectedMultiBarPics.remove(picId);
                        }
                        /* GalleryStore.to.setSelectedPics(
                  picStore: picStore,
                  picIsTagged: false,
                ); */
                        //print('Pics Selected Length: ');
                        //print('${GalleryStore.to.selectedPics.length}');
                        return;
                      }
                      var list = controller.taggedPicId[tagKey]?.keys.toList();
                      if (list != null && list.isNotEmpty) {
                        Get.to(
                            () => PhotoScreen(picId: picId, picIdList: list));
                      }
                    },
                    child: Obx(() {
                      Widget image = Positioned.fill(
                        child: RepaintBoundary(
                          child: state.completedWidget,
                        ),
                      );
                      if (controller.multiPicBar.value) {
                        if (controller.selectedMultiBarPics[picId] != null) {
                          return Stack(
                            children: [
                              image,
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
                              Positioned(
                                left: 8.0,
                                top: 6.0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    gradient: kSecondaryGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                      'lib/images/checkwhiteico.png'),
                                ),
                              ),
                            ],
                          );
                        }
                        return Stack(
                          children: [
                            image,
                            Positioned(
                              left: 8.0,
                              top: 6.0,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kGrayColor,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Stack(
                        children: [
                          image,
                        ],
                      );
                    }),
                  ),
                ),
              );
            case LoadState.failed:
              return failedItem;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.shouldPopOut(),
      child: Obx(
        () => Scaffold(
          bottomNavigationBar: controller.multiTagSheet.value
              ? ExpandableNotifier(
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
                            bottom:
                                !controller.expandableController.value.expanded,
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
                                      await TagsController.to
                                          .addTagsToSelectedPics();
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
                                        TagsController.to.searchText.value =
                                            text;
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
                                          TagsController.to.searchText.value =
                                              text;
                                          TagsController.to
                                              .tagsSuggestionsCalculate();
                                          final tagKey =
                                              Helpers.encryptTag(text);

                                          if (TagsController
                                                  .to.multiPicTags[tagKey] ==
                                              null) {
                                            if (TagsController
                                                    .to.allTags[tagKey] ==
                                                null) {
                                              print(
                                                  'tag does not exist! creating it!');
                                              TagsController.to.createTag(text);
                                            }
                                            TagsController
                                                .to.multiPicTags[tagKey] = '';
                                            TagsController.to.searchText.value =
                                                '';
                                          }
                                        }
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TagsList(
                                      title:
                                          TagsController.to.searchText.value !=
                                                  ''
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
                                        TagsController.to.multiPicTags[tagKey] =
                                            '';
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
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                  var listOfBottomNavigationItems = <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      label: 'Return',
                      icon: Image.asset('lib/images/returntabbutton.png'),
                    ),
                    BottomNavigationBarItem(
                      label: 'Tag',
                      icon: AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity:
                              controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
                          child: Image.asset('lib/images/tagtabbutton.png')),
                    ),
                    BottomNavigationBarItem(
                      label: 'Share',
                      icon: AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity:
                              controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
                          child: Image.asset('lib/images/sharetabbutton.png')),
                    ),
                    BottomNavigationBarItem(
                        label: 'Trash',
                        icon: AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity:
                              controller.selectedMultiBarPics.isEmpty ? 0.2 : 1,
                          child: Image.asset('lib/images/trashtabbutton.png'),
                        )),
                  ];
                  return Platform.isIOS
                      ? CupertinoTabBar(
                          onTap: (index) {
                            controller.setTabIndex(index, tagKey);
                          },
                          iconSize: 24.0,
                          border: Border(
                              top: BorderSide(
                                  color: Color(0xFFE2E4E5), width: 1.0)),
                          items: listOfBottomNavigationItems)
                      : SizedBox(
                          height: 64.0,
                          child: BottomNavigationBar(
                              onTap: (index) {
                                controller.setTabIndex(index, tagKey);
                              },
                              type: BottomNavigationBarType.fixed,
                              showSelectedLabels: false,
                              showUnselectedLabels: false,
                              items: listOfBottomNavigationItems),
                        );
                }),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.black,
            actions: [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                onPressed: () {
                  Get.to(() => SettingsScreen());
                },
                child: Image.asset('lib/images/settings.png'),
              ),
            ],
            leading: GestureDetector(
              onTap: () async {
                if (await controller.shouldPopOut()) {
                  Get.back();
                }
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black.withOpacity(.5),
                size: 24,
              ),
            ),
            titleSpacing: -8,
            title: Text(
              ('${TagsController.to.allTags[tagKey]?.value.title ?? ''} (${controller.taggedPicId[tagKey]?.keys.length ?? 0})'),
              style: TextStyle(
                color: Colors.black.withOpacity(.5),
              ),
            ),
          ),
          body: Container(
            //constraints: BoxConstraints.expand(),
            color: kWhiteColor,
            child: SafeArea(
              child: Obx(() {
                if (controller.isTaggedPicsLoaded.value == false) {
                  return Center(child: CircularProgressIndicator());
                }

                if (TabsController.to.assetEntityList.isNotEmpty) {
                  ///
                  /// Device has pics
                  ///
                  var hasTaggedPics =
                      controller.taggedPicId[tagKey]?.isNotEmpty ?? false;
                  if (hasTaggedPics) {
                    ///
                    /// Tagged Pics are available
                    ///
                    
                    return Column(
                      children: [
                        if (controller.multiPicBar.value)
                          SelectAllWidget(isSelected: false),
                        Expanded(child: _buildGridView(context)),
                      ],
                    );
                  }

                  ///
                  /// No Pics Tagged
                  ///
                  return DeviceHasNoPics(
                      message: S.of(context).no_photos_were_tagged);
                }

                /// Device has no Pics
                return DeviceHasNoPics(
                    message: S.of(context).device_has_no_pics);
              }),
            ),
          ),
        ),
      ),
    );
  }
}
 */
