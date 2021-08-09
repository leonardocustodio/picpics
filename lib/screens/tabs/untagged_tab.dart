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
import 'package:picPics/screens/tabs/untagged_tabs/untagged_day.dart';
import 'package:picPics/screens/tabs/untagged_tabs/untagged_month.dart';
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
            return UntaggedTabMonth();
          } else {
            return UntaggedTabDay();
          }
        },
      ),
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
