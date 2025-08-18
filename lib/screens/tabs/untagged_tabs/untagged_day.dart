import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/photo_screen.dart';
import 'package:picpics/stores/blur_hash_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/utils/refresh_everything.dart';
import 'package:picpics/widgets/date_header.dart';
import 'package:picpics/widgets/photo_widget.dart';

class UntaggedTabDay extends GetWidget<TabsController> {
  const UntaggedTabDay({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StaggeredGridView.countBuilder(
        shrinkWrap: true,
        controller: controller.untaggedScrollControllerDay,
        key: const Key('Day'),
        padding: const EdgeInsets.only(top: 2),
        itemCount: controller.allUnTaggedPicsDay.length,
        crossAxisCount: 3,
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
              final object = controller.allUnTaggedPicsDay[index];
              if (object is DateTime) {
                var isSelected = false;
                if (controller.multiPicBar.value) {
                  var i = index + 1;
                  isSelected = true;

                  while (i < controller.allUnTaggedPicsDay.length &&
                      controller.allUnTaggedPicsDay[i] is String) {
                    if (controller.selectedMultiBarPics[
                            controller.allUnTaggedPicsDay[i]] ==
                        null) {
                      isSelected = false;
                      break;
                    }
                    i++;
                  }
                }
                return GestureDetector(
                    onTap: () {
                      if (controller.multiPicBar.value) {
                        var i = index + 1;
                        if (isSelected) {
                          while (i < controller.allUnTaggedPicsDay.length &&
                              controller.allUnTaggedPicsDay[i] is String) {
                            controller.selectedMultiBarPics
                                .remove(controller.allUnTaggedPicsDay[i]);
                            i++;
                          }
                        } else {
                          while (i < controller.allUnTaggedPicsDay.length &&
                              controller.allUnTaggedPicsDay[i] is String) {
                            controller.selectedMultiBarPics[
                                controller.allUnTaggedPicsDay[i] as String] = true;
                            i++;
                          }
                        }
                      }
                    },
                    child: DateHeaderWidget(
                        date: object,
                        isSelected: isSelected,
                        isMonth: controller.toggleIndexUntagged.value == 0,),);
              }
              final blurHash = BlurHashController.to.blurHash[object];
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
                          controller.selectedMultiBarPics[object as String] = true;
                        } else {
                          controller.selectedMultiBarPics.remove(object);
                        }
                        return;
                      }
                      await Get.to<dynamic>(() => PhotoScreen(
                          picId: object as String,
                          picIdList: controller.allUnTaggedPics.keys.toList(),),);

                      await refreshEverything();
                    },
                    child: GestureDetector(
                      onLongPress: () {
                        if (controller.multiPicBar.value == false) {
                          controller.setMultiPicBar(true);
                        }
                        controller.selectedMultiBarPics[object as String] = true;
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
                              constraints: const BoxConstraints.expand(),
                              decoration: BoxDecoration(
                                color: kSecondaryColor.withValues(alpha: 0.3),
                                border: Border.all(
                                  color: kSecondaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              top: 6,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  gradient: kSecondaryGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                    Image.asset('lib/images/checkwhiteico.png'),
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
        },
      ),
    );
  }
}
