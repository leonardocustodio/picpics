import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/utils/refresh_everything.dart';
import 'package:picPics/widgets/date_header.dart';
import 'package:picPics/widgets/photo_widget.dart';

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
                return const StaggeredTile.extent(4, 0);
              }
              return const StaggeredTile.extent(4, 40);
            }
            return const StaggeredTile.count(1, 1);
          },
          itemBuilder: (_, int index) {
            return Obx(
              () {
                final object = controller.allUnTaggedPicsMonth[index];
                if (object is DateTime) {
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
                            while (i < controller.allUnTaggedPicsMonth.length &&
                                controller.allUnTaggedPicsMonth[i] is String) {
                              controller.selectedMultiBarPics
                                  .remove(controller.allUnTaggedPicsMonth[i]);
                              i++;
                            }
                          } else {
                            while (i < controller.allUnTaggedPicsMonth.length &&
                                controller.allUnTaggedPicsMonth[i] is String) {
                              controller.selectedMultiBarPics[
                                  controller.allUnTaggedPicsMonth[i]] = true;
                              i++;
                            }
                          }
                        }
                      },
                      child: DateHeaderWidget(
                          date: object,
                          isSelected: isSelected,
                          isMonth: controller.toggleIndexUntagged.value == 0));
                }
                var blurHash = BlurHashController.to.blurHash[object];
                final picStore = controller.picStoreMap[object]?.value;
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () async {
                        if (controller.multiPicBar.value) {
                          if (controller.selectedMultiBarPics[object] == null) {
                            controller.selectedMultiBarPics[object] = true;
                          } else {
                            controller.selectedMultiBarPics.remove(object);
                          }
                          return;
                        }
                        await Get.to(() => PhotoScreen(
                            picId: object,
                            picIdList:
                                controller.allUnTaggedPics.keys.toList()));

                        await refresh_everything();
                      },
                      child: GestureDetector(
                        onLongPress: () {
                          if (controller.multiPicBar.value == false) {
                            controller.setMultiPicBar(true);
                            controller.selectedMultiBarPics[object] = true;
                          }
                        },
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: PhotoWidget(
                                picStore: picStore,
                                hash: blurHash,
                              ),
                            ),
                            if (controller.multiPicBar.value &&
                                controller.selectedMultiBarPics[object] !=
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
                                  child: Image.asset(
                                      'lib/images/checkwhiteico.png'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
