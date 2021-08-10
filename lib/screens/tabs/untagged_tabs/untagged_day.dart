/* import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picPics/screens/tabs/untagged_tabs/untagged_image_widgets.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/widgets/date_header.dart';

class UntaggedTabDay extends GetWidget<TabsController> {
  const UntaggedTabDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StaggeredGridView.countBuilder(
        addAutomaticKeepAlives: true,
        key: Key('Day'),
        primary: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 2),
        itemCount: controller.allUnTaggedPicsDay.length,
        addRepaintBoundaries: true,
        crossAxisCount: 3,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        staggeredTileBuilder: (int index) {
          if (controller.allUnTaggedPicsDay[index] is DateTime) {
            if (index + 1 < controller.allUnTaggedPicsDay.length &&
                controller.allUnTaggedPicsDay[index + 1] is DateTime) {
              return StaggeredTile.extent(3, 0);
            }
            return StaggeredTile.extent(3, 40);
          }
          return StaggeredTile.count(1, 1);
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
                          while (i < controller.allUnTaggedPicsDay.length &&
                              controller.allUnTaggedPicsDay[i] is! DateTime) {
                            controller.selectedMultiBarPics
                                .remove(controller.allUnTaggedPicsDay[i]);
                            i++;
                          }
                        } else {
                          while (i < controller.allUnTaggedPicsDay.length &&
                              controller.allUnTaggedPicsDay[i] is! DateTime) {
                            controller.selectedMultiBarPics[
                                controller.allUnTaggedPicsDay[i]] = true;
                            i++;
                          }
                        }
                      }
                    },
                    child: DateHeaderWidget(
                        date: controller.allUnTaggedPicsDay[index],
                        isSelected: isSelected,
                        isMonth: controller.toggleIndexUntagged.value == 0));
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
                          .picStoreMap[controller.allUnTaggedPicsDay[index]]
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
                                  .picStoreMap[
                                      controller.allUnTaggedPicsDay[index]]!
                                  .value,
                              picId: controller.allUnTaggedPicsDay[index],
                              hash: blurHash,
                            ),
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
}
 */