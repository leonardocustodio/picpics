import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/custom_scroll_physics.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:extended_image/extended_image.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/widgets/top_bar.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaggedTabGridView extends GetWidget<TaggedController> {
  final String tagKey;
  const TaggedTabGridView(this.tagKey, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
            size: 22,
          ),
        ),
        titleSpacing: -10,
        title: Text(
          ('${TagsController.to.allTags[tagKey]?.value?.title ?? ''} (${controller.taggedPicId[tagKey]?.keys?.length ?? ''})'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Obx(() {
          var taggedPicIds = controller.taggedPicId[tagKey]?.keys?.toList();
          if (taggedPicIds?.isEmpty ?? true) {
            return controller.taggedPicId[tagKey]?.keys?.toList()?.isEmpty ??
                    true
                ? TopBar(
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
                                height: Get.height / 2,
                                child: Image.asset(
                                    'lib/images/notaggedphotos.png'),
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
                                onPressed: () =>
                                    TabsController.to.setCurrentTab(1),
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
                  )
                : Container();
          }
          var height = Get.width / 3 - 12;

          return StaggeredGridView.countBuilder(
            key: Key('tag'),
            controller: controller.scrollControllerThirdTab,
            // padding: EdgeInsets.only(top: 86.0),
            padding: EdgeInsets.only(left: 7, right: 7),
            physics: const CustomScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            itemCount: taggedPicIds.length,
            itemBuilder: (BuildContext context, int index) {
              var picId = taggedPicIds[index];

              return Container(
                height: height,
                child: GetX<TabsController>(builder: (tabsController) {
                  var widget = VisibilityDetector(
                    key: Key('${picId}'),
                    onVisibilityChanged: (visibilityInfo) {
                      var visiblePercentage =
                          visibilityInfo.visibleFraction * 100;
                      print(visiblePercentage.toString() + 'visibility');
                      if (visiblePercentage > 10 &&
                          tabsController.picStoreMap[picId]?.value == null) {
                        TabsController.to.picStoreMap[picId] =
                            tabsController.explorPicStore(picId);
                      }
                    },
                    child: tabsController.picStoreMap[picId]?.value == null
                        ? greyWidget
                        : _buildPicItem(
                            tabsController.picStoreMap[picId]?.value,
                            picId,
                            tagKey,
                          ),
                  );
                  if (index == taggedPicIds.length - 1) {
                    return widget;
                  }
                  return widget;
                }),
              );
              /* if (item is TaggedPicsStore) {
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
              } */
            },
            staggeredTileBuilder: (_) {
              return StaggeredTile.fit(1);
            },
          );
        }),
      ),
    );
  }

  Widget _buildPicItem(PicStore picStore, String picId, String tagKey) {
    final AssetEntityImageProvider imageProvider =
        AssetEntityImageProvider(picStore, isOriginal: false);

    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        shape: BoxShape.rectangle,
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
                  return CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      /* if (controller.multiPicBar.value) {
                        GalleryStore.to.setSelectedPics(
                          picStore: picStore,
                          picIsTagged: true,
                        );
                        //print('Pics Selected Length: ${GalleryStore.to.selectedPics.length}');
                        return;
                      } */

                      //print('Selected photo: ${picStore.photoId}');
                      /* GalleryStore.to.setCurrentPic(picStore);
                      GalleryStore.to.setInitialSelectedThumbnail(picStore); */
                      Get.to(() => PhotoScreen(picId: picId));
                    },
                    child: Obx(() {
                      Widget image = Positioned.fill(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: state.completedWidget),
                      );

                      List<Widget> items = [image];

                      /* if (controller.multiPicBar.value) {
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
                      */
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
                              child:
                                  Image.asset('lib/images/smallwhitelock.png'),
                            ),
                          ),
                        );
                      }
                      if (picStore.isStarred == true) {
                        //print('Adding starred yellow ico');
                        items.add(
                          Positioned(
                            left: 6.0,
                            top: 6.0,
                            child: Image.asset('lib/images/staryellowico.png'),
                          ),
                        );
                      }
                      return Container(child: Stack(children: items));
                    }),
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
}
