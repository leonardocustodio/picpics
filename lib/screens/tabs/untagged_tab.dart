import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picPics/asset_entity_image_provider_new.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/custom_scroll_physics.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:picPics/widgets/toggle_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ignore: must_be_immutable
class UntaggedTab extends GetWidget<TabsController> {
  static const id = 'untagged_tab';

  //ScrollController scrollControllerFirstTab;
  TextEditingController tagsEditingController = TextEditingController();

  Widget _buildGridView(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        /// Hiding Months on days from here by listening to the scrollNotification
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
          if (controller.allUnTaggedPicsMonth.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          var isMonth = controller.toggleIndexUntagged.value == 0;
          var monthKeys = controller.allUnTaggedPicsMonth.entries.toList();
          var dayKeys = controller.allUnTaggedPicsDay.entries.toList();
          if (isMonth) {
            return StaggeredGridView.builder(
                key: Key('Month'),
                //controller: scrollControllerFirstTab,
                physics: const CustomScrollPhysics(),
                padding: EdgeInsets.only(top: 2),
                addAutomaticKeepAlives: true,
                itemCount: controller.allUnTaggedPicsMonth.length,
                gridDelegate:
                    SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  staggeredTileBuilder: (int index) {
                    if (index == 0 || monthKeys[index].key is DateTime) {
                      return StaggeredTile.extent(5, 40);
                    }
                    return StaggeredTile.count(1, 1);
                  },
                ),
                itemBuilder: (_, int index) {
                  if (index == 0 || monthKeys[index].key is DateTime) {
                    return buildDateHeader(monthKeys[index].key);
                  }
                  return Obx(() {
                    if (controller
                            .picAssetThumbBytesMap[monthKeys[index].key] ==
                        null) {
                      controller.exploreThumbPic(monthKeys[index].key);
                      return greyWidget;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          child: _buildItem2(monthKeys[index].key),
                        ),
                      ),
                    );
                  });
                });
          } else {
            return StaggeredGridView.builder(
                key: Key('Day'),
                //controller: scrollControllerFirstTab,
                physics: const CustomScrollPhysics(),
                padding: EdgeInsets.only(top: 2),
                itemCount: controller.allUnTaggedPicsDay.length,
                addAutomaticKeepAlives: true,
                gridDelegate:
                    SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  staggeredTileBuilder: (int index) {
                    if (index == 0 || dayKeys[index].key is DateTime) {
                      return StaggeredTile.extent(5, 40);
                    }
                    return StaggeredTile.count(1, 1);
                  },
                ),
                itemBuilder: (_, int index) {
                  if (index == 0 || dayKeys[index].key is DateTime) {
                    return buildDateHeader(dayKeys[index].key);
                  }
                  return Obx(() {
                    if (controller.picAssetThumbBytesMap[dayKeys[index].key] ==
                        null) {
                      return greyWidget;
                    }
                    return VisibilityDetector(
                      key: Key('${dayKeys[index].key}'),
                      onVisibilityChanged: (visibilityInfo) {
                        var visiblePercentage =
                            visibilityInfo.visibleFraction * 100;
                        if (visiblePercentage >= 99) {
                          controller.exploreThumbPic(dayKeys[index].key);
                        }
                        debugPrint(
                            'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            child: _buildItem2(dayKeys[index].key),
                          ),
                        ),
                      ),
                    );
                  });
                });
          }

          /* 
          var width = (Get.width / 5) - 2;
          return ListView.builder(
            itemCount: keys.length,
            physics: const CustomScrollPhysics(),
            itemBuilder: (context, index) {
              DateTime headerDateTime = keys[index];
              if (true) {
                if (controller.allUnTaggedPicsMonth[headerDateTime]['extras'] ==
                    null) {
                  return Container();
                }
                return Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDateHeader(headerDateTime),
                    Wrap(
                      spacing: 0,
                      runSpacing: 0,
                      children: [
                        for (var dateTime in controller
                            .allUnTaggedPicsMonth[headerDateTime]['extras']) ...[
                          if (!isMonth && headerDateTime != dateTime)
                            AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: !isMonth ? 45 : 0,
                                child: buildDateHeader(dateTime)),
                          ...[
                            for (var i = 0;
                                i <
                                    getLength(controller
                                        .allUnTaggedPicsMonth[dateTime]['pics']
                                        .length);
                                i++)
                              Obx(() {
                                if (i >=
                                    controller.allUnTaggedPicsMonth[dateTime]['pics']
                                        .length) {
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 190),
                                    width: isMonth ? 0 : width,
                                    height: isMonth ? 0 : width,
                                  );
                                }
                                var picId = controller.allUnTaggedPicsMonth[dateTime]
                                    ['pics'][i];
                                if (controller.picAssetThumbBytesMap[picId] ==
                                    null) {
                                  controller.explorePic(picId);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        width: width,
                                        height: width,
                                        padding: const EdgeInsets.all(10),
                                        color: kGreyPlaceholder,
                                        /* child: Center(
                                    child: CircularProgressIndicator(),
                                  ), */
                                      ),
                                    ),
                                  );
                                }
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        width: width,
                                        height: width,
                                        child: _buildItem2(picId),
                                      ),
                                    ));
                              }),
                          ],
                        ]
                      ],
                    ),
                    const SizedBox(height: 20)
                  ],
                ));
              }

              return Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDateHeader(headerDateTime),
                  Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    children: [
                      for (var picId
                          in controller.allUnTaggedPicsMonth[headerDateTime]['pics'])
                        Obx(() {
                          if (controller.picAssetThumbBytesMap[picId] == null) {
                            controller.explorePic(picId);
                            return Container(
                              width: width,
                              height: width,
                              padding: const EdgeInsets.all(10),
                              color: kGreyPlaceholder,
                              /* child: Center(
                                  child: CircularProgressIndicator(),
                                ), */
                            );
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              width: width,
                              height: width,
                              child: _buildItem2(picId),
                            ),
                          );
                        }),
                    ],
                  ),
                  const SizedBox(height: 20)
                ],
              ));
            },
          ); */
        },
      ),
    );
  }

  Widget get _failedItem => Center(
        child: Text(
          'Failed loading',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18.0),
        ),
      );

  String dateFormat(DateTime dateTime) {
    DateFormat formatter;
    //print('Date Time Formatting: $dateTime');

    if (dateTime.year == DateTime.now().year) {
      formatter = controller.toggleIndexUntagged == 0
          ? DateFormat.yMMMM()
          : DateFormat.MMMEd();
    } else {
      formatter = controller.toggleIndexUntagged == 0
          ? DateFormat.yMMMM()
          : DateFormat.yMMMEd();
    }
    return formatter.format(dateTime);
  }

  Widget buildDateHeader(DateTime date) {
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
  }
/* 
  Widget _buildItem(String picId) {
    var image = FutureBuilder<Uint8List>(
      future: controller.assetMap[picId].thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return CircularProgressIndicator();
        // If there's data, display it as an image
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );

    return FadeImageBuilder(
      child: () {
        return GestureDetector(
          onLongPress: () {
            //print('LongPress');
            if (controller.multiPicBar.value == false) {
              controller.selectedPics[picId] = true;
              controller.setMultiPicBar(true);
            }
          },
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (controller.multiPicBar.value) {
                if (!(controller.selectedPics[picId] ?? false)) {
                  controller.selectedPics[picId] = true;
                } else {
                  controller.selectedPics.remove(picId);
                }
                /* GalleryStore.to.setSelectedPics(
                  picStore: picStore,
                  picIsTagged: false,
                ); */
                //print('Pics Selected Length: ');
                //print('${GalleryStore.to.selectedPics.length}');
                return;
              }
/* 
              tagsEditingController.text = '';
              GalleryStore.to.setCurrentPic(picStore);
              int indexOfSwipePic = GalleryStore.to.swipePics.indexOf(picStore);
              GalleryStore.to.setSelectedSwipe(indexOfSwipePic);
              controller.setModalCard(true); */
            },
            child: Obx(() {
              if (controller.multiPicBar.value) {
                if (controller.selectedPics[picId] ??
                    false /* GalleryStore.to.selectedPics.contains(picStore) */) {
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
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Image.asset('lib/images/checkwhiteico.png'),
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
                          borderRadius: BorderRadius.circular(10.0),
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
        );
      }(),
    );
  } */

  Widget _buildItem2(String picId) {
    final AssetEntityImageProviderKawal imageProvider =
        AssetEntityImageProviderKawal(controller.assetMap[picId],
            originBytes: controller.picAssetOriginBytesMap[picId],
            thumbBytes: controller.picAssetThumbBytesMap[picId],
            photoPath: controller.photoPathMap[picId],
            isOriginal: false);

    return RepaintBoundary(
      child: ExtendedImage(
        clearMemoryCacheWhenDispose: true,
        //handleLoadingProgress: true,
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          return () {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.grey[100],
                  period: const Duration(milliseconds: 600),
                  loop: 50,
                  enabled: true,
                  child: greyWidget,
                );
              case LoadState.completed:
                return FadeImageBuilder(
                  child: GestureDetector(
                    onLongPress: () {
                      //print('LongPress');
                      if (controller.multiPicBar.value == false) {
                        controller.selectedUntaggedPics[picId] = true;
                        controller.setMultiPicBar(true);
                      }
                    },
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        if (controller.multiPicBar.value) {
                          if (!(controller.selectedUntaggedPics[picId] ??
                              false)) {
                            controller.selectedUntaggedPics[picId] = true;
                          } else {
                            controller.selectedUntaggedPics.remove(picId);
                          }
                          /* GalleryStore.to.setSelectedPics(
                  picStore: picStore,
                  picIsTagged: false,
                ); */
                          //print('Pics Selected Length: ');
                          //print('${GalleryStore.to.selectedPics.length}');
                          return;
                        }
/* 
              tagsEditingController.text = '';
              GalleryStore.to.setCurrentPic(picStore);
              int indexOfSwipePic = GalleryStore.to.swipePics.indexOf(picStore);
              GalleryStore.to.setSelectedSwipe(indexOfSwipePic);
              controller.setModalCard(true); */
                      },
                      child: Obx(() {
                        Widget image = Positioned.fill(
                          child: RepaintBoundary(
                            child: state.completedWidget,
                          ),
                        );
                        if (controller.multiPicBar.value) {
                          if (controller.selectedUntaggedPics[picId] ??
                              false /* GalleryStore.to.selectedPics.contains(picStore) */) {
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
                                      borderRadius: BorderRadius.circular(10.0),
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
                                    borderRadius: BorderRadius.circular(10.0),
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
                break;
              case LoadState.failed:
                return _failedItem;
              default:
                return _failedItem;
            }
          }();
        },
      ),
    );
  }
/* 
  Widget _buildItem(PicStore picStore) {
//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;

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
                          picIsTagged: false,
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
                            picIsTagged: false,
                          );
                          //print('Pics Selected Length: ');
                          //print('${GalleryStore.to.selectedPics.length}');
                          return;
                        }

                        tagsEditingController.text = '';
                        GalleryStore.to.setCurrentPic(picStore);
                        int indexOfSwipePic =
                            GalleryStore.to.swipePics.indexOf(picStore);
                        GalleryStore.to.setSelectedSwipe(indexOfSwipePic);
                        controller.setModalCard(true);
                      },
                      child: Obx(() {
                        Widget image = Positioned.fill(
                          child: RepaintBoundary(
                            child: state.completedWidget,
                          ),
                        );
                        if (controller.multiPicBar.value) {
                          if (GalleryStore.to.selectedPics.contains(picStore)) {
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
                                      borderRadius: BorderRadius.circular(10.0),
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
                                    borderRadius: BorderRadius.circular(10.0),
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
                  );
                }(),
              );
              break;
            case LoadState.failed:
              loader = _failedItem;
              break;
          }
          return loader;
        },
      ),
    );
  } */

  @override
  Widget build(BuildContext context) {
    var hasPics = GalleryStore.to.untaggedGridPics.isEmpty ||
        GalleryStore.to.untaggedGridPicsByMonth.isEmpty;

    return Container(
      constraints: BoxConstraints.expand(),
      color: kWhiteColor,
      child: SafeArea(
        child: Obx(() {
          if (!GalleryStore.to.isLoaded.value) {
            return Center(
              child: CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                  ),
            );
          } else if (!hasPics) {
            return Stack(
              children: <Widget>[
                Container(
                  height: 56.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          Get.toNamed(SettingsScreen.id);
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                DeviceHasNoPics(
                  message: S.of(context).device_has_no_pics,
                ),
              ],
            );
          } else if (GalleryStore.to.isLoaded.value && !hasPics) {
            return Stack(
              children: <Widget>[
                Container(
                  height: 56.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        onPressed: () {
                          Get.toNamed(SettingsScreen.id);
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                DeviceHasNoPics(
                  message: S.of(context).all_photos_were_tagged,
                ),
              ],
            );
          } else if (GalleryStore.to.isLoaded.value && hasPics) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: GestureDetector(
//                              onScaleUpdate: (update) {
/* //print(update.scale); */
//                                DatabaseManager.instance.gridScale(update.scale);
//                              },
                    child: _buildGridView(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        onPressed: () {
                          Get.toNamed(SettingsScreen.id);
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16.0,
                  top: 10.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        controller.multiPicBar.value
                            ? S.of(context).photo_gallery_count(
                                GalleryStore.to.selectedPics.length)
                            : S.of(context).photo_gallery_description,
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
                ),
                AnimatedOpacity(
                  opacity: controller.isScrolling.value ? 0.0 : 1.0,
                  curve: Curves.linear,
                  duration: Duration(milliseconds: 300),
                  onEnd: () {
                    controller.setIsToggleBarVisible(
                        controller.isScrolling.value ? false : true);
                  },
                  child: Visibility(
                    visible: controller.isScrolling.value
                        ? controller.isToggleBarVisible.value
                        : true,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ToggleBar(
                          titleLeft: S.of(context).toggle_months,
                          titleRight: S.of(context).toggle_days,
                          activeToggle: controller.toggleIndexUntagged.value,
                          onToggle: (index) {
                            controller.setToggleIndexUntagged(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }
}

int getLength(int len) {
  if ((len % 5) == 0) {
    return len;
  } else {
    return (5 * (1 + (len ~/ 5)));
  }
}
