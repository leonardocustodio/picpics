import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
/* import 'package:picPics/stores/gallery_store.dart'; */
import 'package:picPics/stores/tabs_controller.dart';
/* import 'package:picPics/stores/tabs_controller.dart'; */
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/services.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:extended_image/extended_image.dart';

import 'all_tags_screen.dart';

class PhotoScreenController extends GetxController {
  final overlay = true.obs;
  final showSlideshow = false.obs;
  final selectedIndex = 0.obs;
  static PhotoScreenController get to => Get.find();
  @override
  void onReady() {
    super.onReady();

    Analytics.sendCurrentScreen(Screen.photo_screen);
  }
}

// ignore_for_file: must_be_immutable,prefer_final_fields, unused_field
class PhotoScreen extends GetWidget<PhotoScreenController> {
  static const id = 'photo_screen';

  final String picId;
  late PageController galleryPageController;
  //List<String> photoScreenSwiper = TabsController_.to.picStoreMap.keys.toList();

  final idList = <String>[];

  final List<String> picIdList;

  PhotoScreen({required this.picId, required this.picIdList}) {
    if (picIdList.isNotEmpty) {
      idList.addAll(picIdList);
    }
    var index = getPicIdList().indexOf(picId);
    if (index != -1) {
      PhotoScreenController.to.selectedIndex.value = index;
    }
    galleryPageController = PageController(
        initialPage: PhotoScreenController.to.selectedIndex
            .value /* GalleryStore.to.selectedThumbnail.value */);
  }

  final _ = Get.put(PhotoScreenController());

  /*  @override
  void initState() {
    super.initState();
  } */

  String? getPicId(int index) {
    try {
      return getPicIdList()[index];
    } catch (_) {
      return null;
    }
  }

  List<String> getPicIdList() {
    if (idList.isNotEmpty) {
      return idList;
    }
    return TabsController.to.assetMap.keys.toList();
  }

  void changeOverlay() {
    if (!controller.overlay.value) {
      controller.overlay.value = true;
      /* setState(() {
      }); */
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      if (!controller.showSlideshow.value) {
        controller.showSlideshow.value = true;
      } else {
        controller.showSlideshow.value = false;
        controller.overlay.value = false;
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
    }
  }

  String dateFormat(DateTime dateTime) {
    var formatter = DateFormat.yMMMEd();
    return formatter.format(dateTime);
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final picIdValue = getPicIdList()[index];
    var picStore = TabsController.to.picStoreMap[picIdValue]?.value;
    picStore ??= TabsController.to.explorPicStore(picIdValue).value;

    final imageProvider = AssetEntityImageProvider(picStore, isOriginal: true);

    return PhotoViewGalleryPageOptions.customChild(
      child: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ExtendedImage(
          image: imageProvider,
          fit: BoxFit.contain,
          loadStateChanged: (ExtendedImageState state) {
            Widget loader;
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                loader = const ColoredBox(color: kGreyPlaceholder);
                break;
              case LoadState.completed:
                loader = FadeImageBuilder(
                  child: () {
                    return RepaintBoundary(
                      child: state.completedWidget,
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

        // FullImageItem(
        //   picStore: picStore,
        //   size: MediaQuery.of(context).size.height.toInt(),
        //   fit: BoxFit.contain,
        //   backgroundColor: Colors.black,
        // ),
      ),
      childSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      onTapUp: (context, details, controller) {
        changeOverlay();
      },
//      initialScale: PhotoViewComputedScale.contained,
//      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
//      maxScale: PhotoViewComputedScale.covered * 1.1,
      minScale: 0.7,
      maxScale: 3.0,
      heroAttributes: PhotoViewHeroAttributes(tag: picIdValue),
    );
  }

  Widget _buildThumbnails(BuildContext context, int index) {
    final picIdValue = getPicIdList()[index];
    var picStore = TabsController.to.picStoreMap[picIdValue]?.value;
    picStore ??= TabsController.to.explorPicStore(picIdValue).value;
    final imageProvider = AssetEntityImageProvider(picStore, isOriginal: true);

    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        controller.selectedIndex.value = index;
        galleryPageController.jumpToPage(index);
      },
      child: Container(
        height: 98,
        width: 98,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
                    return RepaintBoundary(
                      child: state.completedWidget,
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

        // ImageItem(
        //   picStore: TabsController_.to.thumbnailsPics[index],
        //   size: 98,
        //   fit: BoxFit.cover,
        //   backgroundColor: Colors.black,
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                color: Color(0xff101010),
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: getPicIdList().length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null || event.expectedTotalBytes == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  pageController: galleryPageController,
                  onPageChanged: (index) {
                    controller.selectedIndex.value = index;
                    //GalleryStore.to.setSelectedThumbnail(index);
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              if (controller.overlay.value)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 2.0,
                          sigmaY: 2.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black
                                    .withOpacity(0.7)
                                    .withOpacity(0.37)
                                    .withOpacity(0.3),
                                Colors.black
                                    .withOpacity(1.0)
                                    .withOpacity(0.37)
                                    .withOpacity(0.3)
                              ],
                              stops: [0, 0.40625],
                            ),
                          ),
                          child: SafeArea(
                            bottom: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 10.0),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Image.asset(
                                      'lib/images/backarrowwithdropshadow.png'),
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 10.0),
                                  onPressed: () {
                                    var picIdValue = getPicIdList().toList()[
                                        controller.selectedIndex.value];
                                    var shareAblePicStore = TabsController
                                        .to.picStoreMap[picIdValue]?.value;
                                    shareAblePicStore ??= TabsController.to
                                        .explorPicStore(picIdValue)
                                        .value;
                                    shareAblePicStore.sharePic();
                                  },
                                  child: Image.asset(
                                      'lib/images/sharebuttonwithdropshadow.png'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    if (!controller.showSlideshow.value)
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 2.0,
                            sigmaY: 2.0,
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: 184.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black
                                      .withOpacity(0.7)
                                      .withOpacity(0.37)
                                      .withOpacity(0.3),
                                  Colors.black
                                      .withOpacity(1.0)
                                      .withOpacity(0.37)
                                      .withOpacity(0.3)
                                ],
                                stops: [0, 0.40625],
                              ),
                            ),
                            child: SafeArea(
                              top: false,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        RichText(
                                          textScaleFactor: 1.0,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: TabsController
                                                          .to
                                                          .picStoreMap[
                                                              getPicIdList()
                                                                      .toList()[
                                                                  controller
                                                                      .selectedIndex
                                                                      .value]]
                                                          ?.value
                                                          .specificLocation
                                                          .value ??
                                                      S
                                                          .of(context)
                                                          .photo_location,
                                                  style: TextStyle(
                                                    fontFamily: 'NotoSans',
                                                    color: kWhiteColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    letterSpacing:
                                                        -0.4099999964237213,
                                                  )),
                                              TextSpan(
                                                text:
                                                    '  ${TabsController.to.picStoreMap[getPicIdList()[controller.selectedIndex.value]]?.value.generalLocation.value ?? S.of(context).country}',
                                                style: TextStyle(
                                                  fontFamily: 'NotoSans',
                                                  color: kWhiteColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle: FontStyle.normal,
                                                  letterSpacing:
                                                      -0.4099999964237213,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          dateFormat(TabsController
                                                  .to
                                                  .picStoreMap[
                                                      getPicIdList().toList()[
                                                          controller
                                                              .selectedIndex
                                                              .value]]
                                                  ?.value
                                                  .createdAt ??
                                              DateTime.now()),
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            color: kWhiteColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: -0.4099999964237213,
                                          ),
                                        ),
                                      ],
                                    ),
                                    BottomTabsListWidget(
                                        picId: getPicIdList().toList()[
                                            controller.selectedIndex.value]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (controller.showSlideshow.value)
                      ClipRect(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black
                                    .withOpacity(0.7)
                                    .withOpacity(0.37)
                                    .withOpacity(0.3),
                                Colors.black
                                    .withOpacity(1.0)
                                    .withOpacity(0.37)
                                    .withOpacity(0.3)
                              ],
                              stops: [0, 0.40625],
                            ),
                          ),
                          child: SafeArea(
                            top: false,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    height: 98,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: _buildThumbnails,
                                      itemCount: getPicIdList().length,
                                      padding: const EdgeInsets.only(left: 8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomTabsListWidget extends GetWidget<TaggedController> {
  final String picId;
  const BottomTabsListWidget({required this.picId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Obx(
        () => (controller.picWiseTags[picId]?.keys.toList().isEmpty ?? true)
            ? TagsList(
                tagsKeyList: <String>[],
                tagStyle: TagStyle.MultiColored,
                addTagButton: () async {
                  var picStore = TabsController.to.picStoreMap[picId]?.value;

                  if (picStore != null) {
                    var result =
                        Get.to(() => AllTagsScreen(picStore: picStore));
                    if (result == null) {
                      await TaggedController.to.refreshTaggedPhotos();
                      await TabsController.to.refreshUntaggedList();
                    }
                    return;
                  }

                  Get.back();
                },
                onTap: (String tagKey) {
                  //print('ignore click');
                },
                onDoubleTap: (String tagKey) {
//                                        TabsController_.to.picStoreMap[picId]
//                                        TabsController_.to.currentPic.removeTagFromPic(tagKey: DatabaseManager.instance.selectedTagKey);
                },
                onPanEnd: (String tagKey) {
                  //print('teste');
                },
                /* showEditTagModal: () =>
                                                    showEditTagModal(context, false), */
              )
            : TagsList(
                tagsKeyList:
                    controller.picWiseTags[picId]?.keys.toList() ?? <String>[],
                tagStyle: TagStyle.MultiColored,
                addTagButton: () async {
                  /* GalleryStore.to.setCurrentPic(
                                                      TabsController_
                                                          .to.picStoreMap[picId].value); */

                  /* if (!controller.modalCard.value) {
                                                    controller.setModalCard(true);
                                                  } */

                  var picStore = TabsController.to.picStoreMap[picId]?.value;

                  if (picStore != null) {
                    var result =
                        Get.to(() => AllTagsScreen(picStore: picStore));
                    if (result == null) {
                      await TaggedController.to.refreshTaggedPhotos();
                      await TabsController.to.refreshUntaggedList();
                    }
                    return;
                  }

                  Get.back();
                },
                onTap: (String tagKey) {
                  //print('ignore click');
                },
                onDoubleTap: (String tagKey) {
//                                        TabsController_.to.picStoreMap[picId]
//                                        TabsController_.to.currentPic.removeTagFromPic(tagKey: DatabaseManager.instance.selectedTagKey);
                },
                onPanEnd: (String tagKey) {
                  //print('teste');
                },
                /* showEditTagModal: () =>
                                                    showEditTagModal(context, false), */
              ),
      ),
    );
  }
}
