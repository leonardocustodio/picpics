import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:picPics/screens/tabs/tagged/no_tagged_pics_in_device.dart';
import 'package:picPics/screens/tabs/tagged/tagged_pics_with_search_option.dart';
import 'package:picPics/stores/language_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:picPics/widgets/toggle_bar.dart';
import 'package:picPics/utils/app_logger.dart';

// ignore_for_file: must_be_immutable, unused_field
class TaggedTab extends GetView<TaggedController> {
  static const id = 'tagged_tab';
  TaggedTab({super.key});

  final _ = Get.find<UserController>();
  final tagsController = Get.find<TagsController>();
  final tabsController = Get.find<TabsController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppLogger.d('WillPopScope  taggedTab');
        if (tabsController.multiTagSheet.value) {
          AppLogger.d('WillPopScope  multiTagSheet');
          tabsController.multiTagSheet.value = false;
          return false;
        }
        if (tabsController.multiPicBar.value) {
          AppLogger.d('WillPopScope  multiPicBar');
          tabsController.multiPicBar.value = false;
          return false;
        }
        if (tagsController.isSearching.value) {
          AppLogger.d('WillPopScope  isSearching');
          tagsController.isSearching.value = false;
          return false;
        }
        /* if (tabsController.currentTab.value != 0) {
          AppLogger.d('WillPopScope  currentTab');
          return false;
        } */
        AppLogger.d('WillPopScope  currentTab = 0');
        tabsController.currentTab.value = 0;
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Obx(() {
                    if (tabsController.deviceHasPics) {
                      ///
                      /// Device has pics
                      ///
                      if (controller.allTaggedPicIdList.isEmpty) {
                        ///
                        /// Device has pics but no tagged pics
                        ///
                        return const NoTaggedPicsInDevice();
                      } else {
                        ///
                        /// Device has pics with tagged Pics
                        ///
                        return const TaggedPicsInDeviceWithSearchOption();
                      }
                    } else {
                      ///
                      /// Device has no pics
                      ///
                      return DeviceHasNoPics(
                          message: LangControl.to.S.value.device_has_no_pics);
                    }
                  }),
                ),
                Positioned.fill(
                  child: Obx(() {
                    if (tabsController.deviceHasPics &&
                        controller.allTaggedPicIdList.isNotEmpty) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollStartNotification) {
                            AppLogger.d('Start scrolling');
                            TaggedController.to.setIsScrolling(true);
                            return true;
                          } else if (scrollNotification
                              is ScrollEndNotification) {
                            AppLogger.d('End scrolling');
                            TaggedController.to.setIsScrolling(false);
                          }
                          return false;
                        },
                        child: Container(),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
                Obx(() {
                  return AnimatedOpacity(
                    opacity: controller.isScrolling.value
                        ? 0.0
                        : (controller.searchFocusNode.hasFocus ||
                                TaggedController.to.allTaggedPicIdList.isEmpty)
                            ? 0.0
                            : 1.0,
                    curve: Curves.linear,
                    duration: Duration(
                        milliseconds:
                            controller.searchFocusNode.hasFocus ? 0 : 300),
                    onEnd: () {
                      tabsController.setIsToggleBarVisible(
                          controller.isScrolling.value ? false : true);
                    },
                    child: Visibility(
                      visible: controller.isScrolling.value
                          ? tabsController.isToggleBarVisible.value
                          : true,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ToggleBar(
                            titleLeft: LangControl.to.S.value.toggle_date,
                            titleRight: LangControl.to.S.value.toggle_tags,
                            activeToggle: controller.toggleIndexTagged.value,
                            onToggle: (index) {
                              controller.toggleIndexTagged.value = index;
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
        ),
      ),
    );
  }
}
