import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';

import 'package:picPics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_key_grid.dart';
import 'package:picPics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_option_bar.dart';
import 'package:picPics/widgets/percentage_dialog.dart';
import 'package:picPics/widgets/select_all_widget.dart';
import 'package:picPics/stores/language_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/widgets/device_no_pics.dart';

// ignore: must_be_immutable
class TaggedTabSelectiveTagKey extends GetWidget<TaggedController> {
  final String tagKey;
  const TaggedTabSelectiveTagKey(this.tagKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.shouldPopOut(),
      child: Obx(
        () => Scaffold(
          bottomNavigationBar: TaggedTabSelectiveTagOptionBar(tagKey: tagKey),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.black,
            actions: [
              if (controller.multiPicBar.value &&
                  controller.selectedMultiBarPics.isNotEmpty)
                CupertinoButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: () async {
                    await controller.untagPicsFromTag(
                        tagKeyMapToPicId: <String, Map<String, String>>{
                          tagKey: controller.selectedMultiBarPics
                              .map((key, _) => MapEntry(key, ''))
                        });
                  },
                  child: Text('Untag'),
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
              '${TagsController.to.allTags[tagKey]?.value.title ?? ''} (${controller.taggedPicId[tagKey]?.keys.length ?? 0})',
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
                    var isSelected = true;
                    if (controller.multiPicBar.value) {
                      for (var picId in controller.taggedPicId[tagKey]!.keys) {
                        if (controller.selectedMultiBarPics[picId] == null) {
                          isSelected = false;
                          break;
                        }
                      }
                    }

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Column(
                            children: [
                              if (controller.multiPicBar.value)
                                GestureDetector(
                                    onTap: () {
                                      if (isSelected) {
                                        for (var picId in controller
                                            .taggedPicId[tagKey]!.keys) {
                                          controller.selectedMultiBarPics
                                              .remove(picId);
                                        }
                                      } else {
                                        for (var picId in controller
                                            .taggedPicId[tagKey]!.keys) {
                                          controller
                                                  .selectedMultiBarPics[picId] =
                                              true;
                                        }
                                      }
                                    },
                                    child: SelectAllWidget(
                                        isSelected: isSelected)),
                              Expanded(
                                  child: TaggedTabSelectiveTagKeyGrid(tagKey)),
                            ],
                          ),
                        ),
                        Positioned.fill(child: PercentageDialog()),
                      ],
                    );
                  }

                  ///
                  /// No Pics Tagged
                  ///
                  return Obx(
                    () => DeviceHasNoPics(
                        message: LangControl.to.S.value.no_photos_were_tagged),
                  );
                }

                /// Device has no Pics
                return Obx(
                  () => DeviceHasNoPics(
                      message: LangControl.to.S.value.device_has_no_pics),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
