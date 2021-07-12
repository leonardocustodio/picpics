import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/custom_scroll_physics.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
/* import 'package:picPics/stores/gallery_store.dart'; */
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/utils/refresh_everything.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:picPics/widgets/toggle_bar.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../asset_entity_image_provider.dart';

// ignore: must_be_immutable
class UntaggedTab extends GetWidget<TabsController> {
  static const id = 'untagged_tab';

  //ScrollController scrollControllerFirstTab;
  TextEditingController tagsEditingController = TextEditingController();
  final _scrollController = ScrollController();

  Widget _buildGridView(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        /// Hiding Months on days from here by listening to the scrollNotification
        if (scrollNotification is ScrollStartNotification) {
          //print('Start scrolling');
          controller.setIsScrolling(true);
          return false;
        } else if (scrollNotification is ScrollEndNotification) {
          //print('End scrolling');
          controller.setIsScrolling(false);
          return true;
        }
        return true;
      },
      child: Obx(
        () {
          if (controller.allUnTaggedPicsMonth.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          var isMonth = controller.toggleIndexUntagged.value == 0;
          if (isMonth) {
            var monthKeys = controller.allUnTaggedPicsMonth.entries.toList();
            return StaggeredGridView.countBuilder(
                key: Key('Month'),
                controller: _scrollController,
                padding: EdgeInsets.only(top: 2),
                primary: false,
                shrinkWrap: false,
                crossAxisCount: 5,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                itemCount: controller.allUnTaggedPicsMonth.length,
                staggeredTileBuilder: (int index) {
                  if (index == 0 || monthKeys[index].key is DateTime) {
                    return StaggeredTile.extent(5, 40);
                  }
                  return StaggeredTile.count(1, 1);
                },
                itemBuilder: (_, int index) {
                  if (index == 0 || monthKeys[index].key is DateTime) {
                    var isSelected = false;
                    if (controller.multiPicBar.value) {
                      isSelected = monthKeys[index].value.every((picId) =>
                          controller.selectedMultiBarPics[picId] == true);
                    }
                    return GestureDetector(
                        onTap: () {
                          if (controller.multiPicBar.value) {
                            monthKeys[index].value.forEach((picId) {
                              if (isSelected) {
                                controller.selectedMultiBarPics.remove(picId);
                              } else {
                                controller.selectedMultiBarPics[picId] = true;
                              }
                            });
                          }
                        },
                        child: buildDateHeader(
                          monthKeys[index].key,
                          isSelected,
                        ));
                  }
                  return Obx(() {
                    var blurHash =
                        BlurHashController.to.blurHash[monthKeys[index].key];

                    return VisibilityDetector(
                      key: Key('${monthKeys[index].key}'),
                      onVisibilityChanged: (visibilityInfo) {
                        var visiblePercentage =
                            visibilityInfo.visibleFraction * 100;
                        if (visiblePercentage > 10 &&
                            (_scrollController.position.activity?.velocity ??
                                    15) <
                                30) {
                          for (var i = index - 50; i < index + 50; i++) {
                            if (i > -1 &&
                                i < monthKeys.length &&
                                monthKeys[i].key is! DateTime) {
                              controller.putCache(monthKeys[i].key);
                            }
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: blurHash != null
                                    ? BlurHash(
                                        hash: blurHash,
                                        color: Colors.transparent,
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(12),
                                        color: Colors.grey[300],
                                      ),
                              ),
                            ),
                          ),
                          if (controller.picStoreMap[monthKeys[index].key]
                                      ?.value !=
                                  null &&
                              controller.getCache(monthKeys[index].key) != null)
                            Positioned.fill(
                                child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  child: _buildItemOneMoreTrial(
                                      controller
                                          .picStoreMap[monthKeys[index].key]!
                                          .value,
                                      monthKeys[index].key),
                                ),
                              ),
                            )),
                        ],
                      ),
                    );
                  });
                });
          } else {
            var dayKeys = controller.allUnTaggedPicsDay.entries.toList();
            return StaggeredGridView.countBuilder(
                key: Key('Day'),
                //controller: scrollControllerFirstTab,
                controller: _scrollController,
                padding: EdgeInsets.only(top: 2),
                itemCount: controller.allUnTaggedPicsDay.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                crossAxisCount: 5,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                staggeredTileBuilder: (int index) {
                  if (index == 0 || dayKeys[index].key is DateTime) {
                    return StaggeredTile.extent(5, 40);
                  }
                  return StaggeredTile.count(1, 1);
                },
                itemBuilder: (_, int index) {
                  if (index == 0 || dayKeys[index].key is DateTime) {
                    var isSelected = false;
                    if (controller.multiPicBar.value) {
                      isSelected = dayKeys[index].value.every((picId) =>
                          controller.selectedMultiBarPics[picId] == true);
                    }
                    return GestureDetector(
                        onTap: () {
                          if (controller.multiPicBar.value) {
                            dayKeys[index].value.forEach((picId) {
                              if (isSelected) {
                                controller.selectedMultiBarPics.remove(picId);
                              } else {
                                controller.selectedMultiBarPics[picId] = true;
                              }
                            });
                          }
                        },
                        child: buildDateHeader(
                          dayKeys[index].key,
                          isSelected,
                        ));
                  }
                  return Obx(() {
                    var blurHash =
                        BlurHashController.to.blurHash[dayKeys[index].key];

                    return VisibilityDetector(
                      key: Key('${dayKeys[index].key}'),
                      onVisibilityChanged: (visibilityInfo) {
                        var visiblePercentage =
                            visibilityInfo.visibleFraction * 100;
                        if (visiblePercentage > 10 &&
                            (_scrollController.position.activity?.velocity ??
                                    15) <
                                30) {
                          for (var i = index - 50; i < index + 50; i++) {
                            if (i > -1 &&
                                i < dayKeys.length &&
                                dayKeys[i].key is! DateTime) {
                              controller.putCache(dayKeys[i].key);
                            }
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: blurHash != null
                                    ? BlurHash(
                                        hash: blurHash,
                                        color: Colors.transparent,
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(12),
                                        color: Colors.grey[300],
                                      ),
                              ),
                            ),
                          ),
                          if (controller
                                      .picStoreMap[dayKeys[index].key]?.value !=
                                  null &&
                              controller.getCache(dayKeys[index].key) != null)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    child: _buildItemOneMoreTrial(
                                        controller
                                            .picStoreMap[dayKeys[index].key]!
                                            .value,
                                        dayKeys[index].key),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  });
                });
          }
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

    /// More Optimized code
    if (controller.toggleIndexUntagged.value == 0) {
      formatter = DateFormat.yMMMM();
    } else {
      formatter = dateTime.year == DateTime.now().year
          ? DateFormat.MMMEd()
          : DateFormat.yMMMEd();
    }
    return formatter.format(dateTime);
  }

  Widget buildDateHeader(DateTime date, bool isSelected) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      height: 40.0,
      child: Row(
        children: [
          if (TabsController.to.multiPicBar.value)
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
              child: isSelected
                  ? Image.asset('lib/images/checkwhiteico.png')
                  : null,
            ),
          /* Positioned(
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
            ), */
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

  Widget _buildItemOneMoreTrial(PicStore picStore, String picId) {
//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;
    var hash = BlurHashController.to.blurHash[picId];

    final imageProvider = AssetEntityImageProvider(picStore, isOriginal: false);

    return ExtendedImage(
      filterQuality: FilterQuality.low,
      gaplessPlayback: true,
      clearMemoryCacheWhenDispose: true,
      handleLoadingProgress: true,
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
                  onPressed: () async {
                    if (controller.multiPicBar.value) {
                      if (controller.selectedMultiBarPics[picId] == null) {
                        controller.selectedMultiBarPics[picId] = true;
                      } else {
                        controller.selectedMultiBarPics.remove(picId);
                      }
                      return;
                    }
                    var result = await Get.to(() => PhotoScreen(
                        picId: picId,
                        picIdList: controller.allUnTaggedPics.keys.toList()));
                    if (null == result) {
                      await refresh_everything();
                    }
                  },
                  child: Obx(() {
                    Widget image = Positioned.fill(
                      child: state.completedWidget,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child:
                                    Image.asset('lib/images/checkwhiteico.png'),
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
                                  color: Colors.transparent,
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
            return _failedItem;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //constraints: BoxConstraints.expand(),
      color: kWhiteColor,
      child: SafeArea(
        child: Obx(() {
          var hasPics = controller.allUnTaggedPicsMonth.isNotEmpty ||
              controller.allUnTaggedPicsDay.isNotEmpty;
          if (!controller.isUntaggedPicsLoaded.value) {
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
                          Get.to(() => SettingsScreen());
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
          } else if (controller.isUntaggedPicsLoaded.value && !hasPics) {
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
                          Get.to(() => SettingsScreen());
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
          } else if (controller.isUntaggedPicsLoaded.value && hasPics) {
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
                          Get.to(() => SettingsScreen());
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
                                controller.selectedMultiBarPics.length)
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
