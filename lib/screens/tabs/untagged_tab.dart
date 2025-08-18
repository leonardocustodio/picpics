// import 'package:extended_image/extended_image.dart'; // Unused import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_blurhash/flutter_blurhash.dart'; // Unused import
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:picpics/asset_entity_image_provider.dart'; // Unused import
import 'package:picpics/constants.dart';
// import 'package:picpics/fade_image_builder.dart'; // Unused import
// import 'package:picpics/screens/photo_screen.dart'; // Unused import
import 'package:picpics/screens/settings_screen.dart';
import 'package:picpics/screens/tabs/untagged_tabs/untagged_day.dart';
import 'package:picpics/screens/tabs/untagged_tabs/untagged_month.dart';
import 'package:picpics/stores/language_controller.dart';
// import 'package:picpics/stores/pic_store.dart'; // Unused import
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/utils/app_logger.dart';
// import 'package:picpics/utils/refresh_everything.dart'; // Unused import
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/toggle_bar.dart';

// ignore: must_be_immutable
class UntaggedTab extends GetWidget<TabsController> {

  UntaggedTab({super.key});
  static const id = 'untagged_tab';

  //ScrollController scrollControllerFirstTab;
  TextEditingController tagsEditingController = TextEditingController();

  Widget _buildGridView(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        /// Hiding Months on days from here by listening to the scrollNotification
        if (scrollNotification is ScrollStartNotification) {
          AppLogger.d('Start scrolling');
          controller.setIsScrolling(true);
          return false;
        } else if (scrollNotification is ScrollEndNotification) {
          AppLogger.d('End scrolling');
          controller.setIsScrolling(false);
          return true;
        }
        return true;
      },
      child: Obx(
        () {
          final isMonth = controller.toggleIndexUntagged.value == 0;
          if (isMonth) {
            if (controller.allUnTaggedPicsMonth.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return const UntaggedTabMonth();
            /*   return Obx(
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
                              controller.allUnTaggedPicsMonth[i] is String) {
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
                                        is String) {
                                  controller.selectedMultiBarPics.remove(
                                      controller.allUnTaggedPicsMonth[i]);
                                  i++;
                                }
                              } else {
                                while (i <
                                        controller
                                            .allUnTaggedPicsMonth.length &&
                                    controller.allUnTaggedPicsMonth[i]
                                        is String) {
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
           */
          } else {
            return const UntaggedTabDay();
            /*  return Obx(
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
                              controller.allUnTaggedPicsDay[i] is String) {
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
                                          is String) {
                                    controller.selectedMultiBarPics.remove(
                                        controller.allUnTaggedPicsDay[i]);
                                    i++;
                                  }
                                } else {
                                  while (i <
                                          controller
                                              .allUnTaggedPicsDay.length &&
                                      controller.allUnTaggedPicsDay[i]
                                          is String) {
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
           */
          }
        },
      ),
    );
  }

  // Unused field commented out to fix warning
  // final _failedItem = const Center(
  //   child: Text(
  //     'Failed loading',
  //     textAlign: TextAlign.center,
  //     style: TextStyle(fontSize: 18),
  //   ),
  // );

  String dateFormat(DateTime dateTime) {
    DateFormat formatter;
    AppLogger.d('Date Time Formatting: $dateTime');

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
                      borderRadius: BorderRadius.circular(10),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),),
              child: isSelected
                  ? Image.asset('lib/images/checkwhiteico.png')
                  : null,
            ),
          Text(
            dateFormat(date),
            textScaler: const TextScaler.linear(1),
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      //constraints: BoxConstraints.expand(),
      color: kWhiteColor,
      child: SafeArea(
        child: Obx(() {
          final hasPics = controller.allUnTaggedPicsMonth.isNotEmpty ||
              controller.allUnTaggedPicsDay.isNotEmpty;
          if (controller.isUntaggedPicsLoaded.value == false) {
            return const Center(
              child: CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                  ),
            );
          } else if (!hasPics) {
            return Stack(
              children: <Widget>[
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          Get.to<void>(() => const SettingsScreen());
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                DeviceHasNoPics(
                  message: LangControl.to.S.value.device_has_no_pics,
                ),
              ],
            );
          } else if (controller.isUntaggedPicsLoaded.value && !hasPics) {
            return Stack(
              children: <Widget>[
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onPressed: () {
                          Get.to<void>(() => const SettingsScreen());
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                DeviceHasNoPics(
                  message: LangControl.to.S.value.no_photos_were_tagged,
                ),
              ],
            );
          } else if (controller.isUntaggedPicsLoaded.value && hasPics) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child:
                      /* GestureDetector( 
                              onScaleUpdate: (update) { 
                                AppLogger.d(update.scale); 
                                //DatabaseManager.instance.gridScale(update.scale);
                              },
                       child: */
                      _buildGridView(context),
                  /*  ), */
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onPressed: () {
                          Get.to<void>(() => const SettingsScreen());
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        controller.multiPicBar.value
                            ? LangControl.to.S.value.photo_gallery_count(
                                controller.selectedMultiBarPics.length,)
                            : LangControl.to.S.value.photo_gallery_description,
                        textScaler: const TextScaler.linear(1),
                        style: const TextStyle(
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
                  duration: const Duration(milliseconds: 300),
                  onEnd: () {
                    controller.setIsToggleBarVisible(
                        controller.isScrolling.value ? false : true,);
                  },
                  child: Visibility(
                    visible: controller.isScrolling.value
                        ? controller.isToggleBarVisible.value
                        : true,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ToggleBar(
                          titleLeft: LangControl.to.S.value.toggle_months,
                          titleRight: LangControl.to.S.value.toggle_days,
                          activeToggle: controller.toggleIndexUntagged.value,
                          onToggle: (int index) {
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
