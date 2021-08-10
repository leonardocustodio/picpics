import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/tabs/untagged_tabs/untagged_image_widgets.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
/* import 'package:picPics/stores/gallery_store.dart'; */
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/utils/refresh_everything.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:picPics/widgets/toggle_bar.dart';

import '../../asset_entity_image_provider.dart';

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
          var isMonth = controller.toggleIndexUntagged.value == 0;
          if (isMonth) {
            if (controller.allUnTaggedPicsMonth.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Obx(
              () => StaggeredGridView.countBuilder(
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: true,
                  primary: true,
                  shrinkWrap: true,
                  key: Key('Month'),
                  padding: const EdgeInsets.only(top: 2),
                  crossAxisCount: 4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  itemCount: controller.allUnTaggedPicsMonth.length,
                  staggeredTileBuilder: (int index) {
                    if (controller.allUnTaggedPicsMonth[index] is DateTime) {
                      if (index + 1 < controller.allUnTaggedPicsMonth.length &&
                          controller.allUnTaggedPicsMonth[index + 1]
                              is DateTime) {
                        return const StaggeredTile.extent(4, 0);
                      }
                      return const StaggeredTile.extent(4, 40);
                    }
                    return const StaggeredTile.count(1, 1);
                  },
                  itemBuilder: (_, int index) {
                    return Obx(() {
                      if (index == 0 ||
                          controller.allUnTaggedPicsMonth[index] is DateTime) {
                        var isSelected = false;
                        if (controller.multiPicBar.value) {
                          var i = index + 1;

                          /// assuming that every picId is selected so the wh
                          var everySelected = false;
                          while (i < controller.allUnTaggedPicsMonth.length &&
                              controller.allUnTaggedPicsMonth[i] is! DateTime) {
                            if (controller.selectedMultiBarPics[
                                        controller.allUnTaggedPicsMonth[i]] ==
                                    null ||
                                controller.selectedMultiBarPics[
                                        controller.allUnTaggedPicsMonth[i]] ==
                                    false) {
                              everySelected = true;
                              break;
                            }
                            i++;
                          }
                          isSelected = !everySelected;
                        }
                        return GestureDetector(
                          onTap: () {
                            if (controller.multiPicBar.value) {
                              var i = index + 1;
                              if (isSelected) {
                                while (i <
                                        controller
                                            .allUnTaggedPicsMonth.length &&
                                    controller.allUnTaggedPicsMonth[i]
                                        is! DateTime) {
                                  controller.selectedMultiBarPics.remove(
                                      controller.allUnTaggedPicsMonth[i]);
                                  i++;
                                }
                              } else {
                                while (i <
                                        controller
                                            .allUnTaggedPicsMonth.length &&
                                    controller.allUnTaggedPicsMonth[i]
                                        is! DateTime) {
                                  controller.selectedMultiBarPics[controller
                                      .allUnTaggedPicsMonth[i]] = true;
                                  i++;
                                }
                              }
                            }
                          },
                          child: buildDateHeader(
                            controller.allUnTaggedPicsMonth[index],
                            isSelected,
                          ),
                        );
                      }

                      var blurHash = BlurHashController
                          .to.blurHash[controller.allUnTaggedPicsMonth[index]];

                      return Stack(
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
                                        padding: EdgeInsets.all(12),
                                        color: Colors.grey[300],
                                      ),
                              ),
                            ),
                          ),
                          if (controller
                                  .picStoreMap[
                                      controller.allUnTaggedPicsMonth[index]]
                                  ?.value !=
                              null)
                            Positioned.fill(
                                child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                    child: _buildImageWidget(
                                        picStore: controller
                                            .picStoreMap[controller
                                                .allUnTaggedPicsMonth[index]]!
                                            .value,
                                        picId: controller
                                            .allUnTaggedPicsMonth[index],
                                        hash: blurHash)),
                              ),
                            )),
                        ],
                      );
                    });
                  }),
            );
          } else {
            return Obx(
              () => StaggeredGridView.countBuilder(
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                primary: true,
                shrinkWrap: true,
                key: Key('Day'),
                padding: const EdgeInsets.only(top: 2),
                itemCount: controller.allUnTaggedPicsDay.length,
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                staggeredTileBuilder: (int index) {
                  if (controller.allUnTaggedPicsDay[index] is DateTime) {
                    if (index + 1 < controller.allUnTaggedPicsDay.length &&
                        controller.allUnTaggedPicsDay[index + 1] is DateTime) {
                      return const StaggeredTile.extent(3, 0);
                    }
                    return const StaggeredTile.extent(3, 40);
                  }
                  return const StaggeredTile.count(1, 1);
                },
                itemBuilder: (_, int index) {
                  return Obx(
                    () {
                      if (controller.allUnTaggedPicsDay[index] is DateTime) {
                        var isSelected = false;
                        if (controller.multiPicBar.value) {
                          var i = index + 1;

                          /// assuming that every picId is selected so the wh
                          var everySelected = false;
                          while (i < controller.allUnTaggedPicsDay.length &&
                              controller.allUnTaggedPicsDay[i] is! DateTime) {
                            if (controller.selectedMultiBarPics[
                                        controller.allUnTaggedPicsDay[i]] ==
                                    null ||
                                controller.selectedMultiBarPics[
                                        controller.allUnTaggedPicsDay[i]] ==
                                    false) {
                              everySelected = true;
                              break;
                            }
                            i++;
                          }
                          isSelected = !everySelected;
                        }
                        return GestureDetector(
                            onTap: () {
                              if (controller.multiPicBar.value) {
                                var i = index + 1;
                                if (isSelected) {
                                  while (i <
                                          controller
                                              .allUnTaggedPicsDay.length &&
                                      controller.allUnTaggedPicsDay[i]
                                          is! DateTime) {
                                    controller.selectedMultiBarPics.remove(
                                        controller.allUnTaggedPicsDay[i]);
                                    i++;
                                  }
                                } else {
                                  while (i <
                                          controller
                                              .allUnTaggedPicsDay.length &&
                                      controller.allUnTaggedPicsDay[i]
                                          is! DateTime) {
                                    controller.selectedMultiBarPics[controller
                                        .allUnTaggedPicsDay[i]] = true;
                                    i++;
                                  }
                                }
                              }
                            },
                            child: buildDateHeader(
                              controller.allUnTaggedPicsDay[index],
                              isSelected,
                            ));
                      }
                      var blurHash = BlurHashController
                          .to.blurHash[controller.allUnTaggedPicsDay[index]];

                      return Stack(
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
                                  .picStoreMap[
                                      controller.allUnTaggedPicsDay[index]]
                                  ?.value !=
                              null)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    child: _buildImageWidget(
                                        picStore: controller
                                            .picStoreMap[controller
                                                .allUnTaggedPicsDay[index]]!
                                            .value,
                                        picId: controller
                                            .allUnTaggedPicsDay[index],
                                        hash: blurHash),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  final _failedItem = const Center(
    child: Text(
      'Failed loading',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18.0),
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
      padding: const EdgeInsets.only(left: 8, right: 8),
      height: 40,
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
          Text(
            '${dateFormat(date)}',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontFamily: 'Lato',
              color: const Color(0xff606566),
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

  Widget _buildImageWidget(
      {required PicStore picStore, required String picId, String? hash}) {
    final imageProvider = AssetEntityImageProvider(picStore, isOriginal: false);

    return ExtendedImage(
      filterQuality: FilterQuality.none,
      image: imageProvider,
      fit: BoxFit.cover,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            if (hash == null) {
              return Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const ColoredBox(color: kGreyPlaceholder),
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
              milliseconds: 200,
              child: GestureDetector(
                onLongPress: () {
                  //print('LongPress');
                  if (controller.multiPicBar.value == false) {
                    controller.setMultiPicBar(true);
                    controller.selectedMultiBarPics[picId] = true;
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
                  child: Obx(() => Stack(
                        children: [
                          Positioned.fill(child: state.completedWidget),
                          if (controller.multiPicBar.value &&
                              controller.selectedMultiBarPics[picId] !=
                                  null) ...[
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
                        ],
                      )),
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
          if (controller.isUntaggedPicsLoaded.value == false) {
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
                          color: const Color(0xff979a9b),
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
