import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_key_grid.dart';
import 'package:picpics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_option_bar.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/tagged_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/percentage_dialog.dart';
import 'package:picpics/widgets/select_all_widget.dart';

// ignore: must_be_immutable
class TaggedTabSelectiveTagKey extends GetWidget<TaggedController> {
  const TaggedTabSelectiveTagKey(this.tagKey, {super.key});
  final String tagKey;

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
                              .map((key, _) => MapEntry(key, '')),
                        },);
                  },
                  child: const Text('Untag'),
                ),
            ],
            leading: GestureDetector(
              onTap: () async {
                if (await controller.shouldPopOut()) {
                  Get.back<void>();
                }
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black.withValues(alpha: .5),
                size: 24,
              ),
            ),
            titleSpacing: -8,
            title: Text(
              '${TagsController.to.allTags[tagKey]?.value.title ?? ''} (${controller.taggedPicId[tagKey]?.keys.length ?? 0})',
              style: TextStyle(
                color: Colors.black.withValues(alpha: .5),
              ),
            ),
          ),
          body: ColoredBox(
            //constraints: BoxConstraints.expand(),
            color: kWhiteColor,
            child: SafeArea(
              child: Obx(() {
                if (controller.isTaggedPicsLoaded.value == false) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (TabsController.to.assetEntityList.isNotEmpty) {
                  ///
                  /// Device has pics
                  ///
                  final hasTaggedPics =
                      controller.taggedPicId[tagKey]?.isNotEmpty ?? false;
                  if (hasTaggedPics) {
                    ///
                    /// Tagged Pics are available
                    ///
                    var isSelected = true;
                    if (controller.multiPicBar.value) {
                      for (final picId in controller.taggedPicId[tagKey]!.keys) {
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
                                        for (final picId in controller
                                            .taggedPicId[tagKey]!.keys) {
                                          controller.selectedMultiBarPics
                                              .remove(picId);
                                        }
                                      } else {
                                        for (final picId in controller
                                            .taggedPicId[tagKey]!.keys) {
                                          controller
                                                  .selectedMultiBarPics[picId] =
                                              true;
                                        }
                                      }
                                    },
                                    child: SelectAllWidget(
                                        isSelected: isSelected,),),
                              Expanded(
                                  child: TaggedTabSelectiveTagKeyGrid(tagKey),),
                            ],
                          ),
                        ),
                        const Positioned.fill(child: PercentageDialog()),
                      ],
                    );
                  }

                  ///
                  /// No Pics Tagged
                  ///
                  return Obx(
                    () => DeviceHasNoPics(
                        message: LangControl.to.S.value.no_photos_were_tagged,),
                  );
                }

                /// Device has no Pics
                return Obx(
                  () => DeviceHasNoPics(
                      message: LangControl.to.S.value.device_has_no_pics,),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
