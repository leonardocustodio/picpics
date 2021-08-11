/* import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picPics/screens/tabs/untagged_tabs/untagged_image_widgets.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/widgets/date_header.dart';

class UntaggedTabMonth extends GetWidget<TabsController> {
  const UntaggedTabMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StaggeredGridView.countBuilder(
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          key: Key('Month'),
          padding: EdgeInsets.only(top: 2),
          primary: true,
          shrinkWrap: true,
          crossAxisCount: 4,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          itemCount: controller.allUnTaggedPicsMonth.length,
          staggeredTileBuilder: (int index) {
            if (controller.allUnTaggedPicsMonth[index] is DateTime) {
              if (index + 1 < controller.allUnTaggedPicsMonth.length &&
                  controller.allUnTaggedPicsMonth[index + 1] is DateTime) {
                return StaggeredTile.extent(4, 0);
              }
              return StaggeredTile.extent(4, 40);
            }
            return StaggeredTile.count(1, 1);
          },
          itemBuilder: (_, int index) {
            return Obx(() {
              if (controller.allUnTaggedPicsMonth[index] is DateTime) {
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
                        while (i < controller.allUnTaggedPicsMonth.length &&
                            controller.allUnTaggedPicsMonth[i] is! DateTime) {
                          controller.selectedMultiBarPics
                              .remove(controller.allUnTaggedPicsMonth[i]);
                          i++;
                        }
                      } else {
                        while (i < controller.allUnTaggedPicsMonth.length &&
                            controller.allUnTaggedPicsMonth[i] is! DateTime) {
                          controller.selectedMultiBarPics[
                              controller.allUnTaggedPicsMonth[i]] = true;
                          i++;
                        }
                      }
                    }
                  },
                  child: DateHeaderWidget(
                    date: controller.allUnTaggedPicsMonth[index],
                    isSelected: isSelected,
                    isMonth: controller.toggleIndexUntagged.value == 0,
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
                                padding: const EdgeInsets.all(12),
                                color: Colors.grey[300],
                              ),
                      ),
                    ),
                  ),
                  if (controller
                          .picStoreMap[controller.allUnTaggedPicsMonth[index]]
                          ?.value !=
                      null)
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                              child: UntaggedImageWidgets(
                                  picStore: controller
                                      .picStoreMap[controller
                                          .allUnTaggedPicsMonth[index]]!
                                      .value,
                                  hash: blurHash,
                                  picId:
                                      controller.allUnTaggedPicsMonth[index])),
                        ),
                      ),
                    ),
                ],
              );
            });
          }),
    );
  }
}
 */
