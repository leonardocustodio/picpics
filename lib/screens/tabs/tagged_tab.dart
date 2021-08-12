import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/tabs/tagged/no_tagged_pics_in_device.dart';
import 'package:picPics/screens/tabs/tagged/tagged_pics_with_search_option.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:picPics/widgets/toggle_bar.dart';

// ignore_for_file: must_be_immutable, unused_field
class TaggedTab extends GetView<TaggedController> {
  static const id = 'tagged_tab';
  TaggedTab({Key? key}) : super(key: key);

  final _ = Get.find<UserController>();
  final tagsController = Get.find<TagsController>();
  final tabsController = Get.find<TabsController>();

  /* TextEditingController tagsEditingController = TextEditingController(); */
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (tagsController.isSearching.value) {
          tagsController.isSearching.value = false;
          return false;
        }
        return true;
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 0.0),
        //                    constraints: BoxConstraints.expand(),
        //                    color: kWhiteColor,
        child: SafeArea(
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
                      return NoTaggedPicsInDevice();
                    } else {
                      ///
                      /// Device has pics with tagged Pics
                      ///
                      return TaggedPicsInDeviceWithSearchOption();
                    }
                  } else {
                    ///
                    /// Device has no pics
                    ///
                    return DeviceHasNoPics(
                        message: S.current.device_has_no_pics);
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
                          titleLeft: S.current.toggle_date,
                          titleRight: S.current.toggle_tags,
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
    );
  }
}
