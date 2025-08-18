import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/photo_screen.dart';
import 'package:picpics/stores/blur_hash_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/tagged_controller.dart';
import 'package:picpics/utils/refresh_everything.dart';
import 'package:picpics/widgets/date_header.dart';
import 'package:picpics/widgets/photo_widget.dart';

class TaggedTabDate extends GetWidget<TaggedController> {
  TaggedTabDate({
    super.key,
  });

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetX<TabsController>(builder: (tabsController) {
      return StaggeredGridView.countBuilder(
          padding: const EdgeInsets.only(top: 2),
          crossAxisCount: 4,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          primary: false,
          controller: scrollController,
          itemCount: controller.allTaggedPicDateWiseList.length,
          staggeredTileBuilder: (int index) {
            if (controller.allTaggedPicDateWiseList[index] is DateTime) {
              return const StaggeredTile.extent(4, 40);
            }
            return const StaggeredTile.count(1, 1);
          },
          itemBuilder: (_, int index) {
            return Obx(() {
              if (controller.allTaggedPicDateWiseList[index] is DateTime) {
                var isSelected = false;
                if (tabsController.multiPicBar.value) {
                  var i = index + 1;
                  isSelected = true;

                  while (i < controller.allTaggedPicDateWiseList.length &&
                      controller.allTaggedPicDateWiseList[i] is String) {
                    if (tabsController.selectedMultiBarPics[
                            controller.allTaggedPicDateWiseList[i]] ==
                        null) {
                      isSelected = false;
                      break;
                    }
                    i++;
                  }
                }

                return GestureDetector(
                  onTap: () {
                    if (tabsController.multiPicBar.value) {
                      var i = index + 1;
                      if (isSelected) {
                        while (i < controller.allTaggedPicDateWiseList.length &&
                            controller.allTaggedPicDateWiseList[i] is String) {
                          tabsController.selectedMultiBarPics
                              .remove(controller.allTaggedPicDateWiseList[i]);
                          i++;
                        }
                      } else {
                        while (i < controller.allTaggedPicDateWiseList.length &&
                            controller.allTaggedPicDateWiseList[i] is String) {
                          tabsController.selectedMultiBarPics[
                              controller.allTaggedPicDateWiseList[i] as String] = true;
                          i++;
                        }
                      }
                    }
                  },
                  child: DateHeaderWidget(
                      date: controller.allTaggedPicDateWiseList[index] as DateTime,
                      isSelected: isSelected,
                      isMonth: true,),
                );
              }

              final picId = controller.allTaggedPicDateWiseList[index];
              final blurHash = BlurHashController
                  .to.blurHash[controller.allTaggedPicDateWiseList[index]];
              final picStore = TabsController
                  .to
                  .picStoreMap[controller.allTaggedPicDateWiseList[index]]
                  ?.value;
              return Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      if (tabsController.multiPicBar.value) {
                        if (tabsController.selectedMultiBarPics[picId] ==
                            null) {
                          tabsController.selectedMultiBarPics[picId as String] = true;
                        } else {
                          tabsController.selectedMultiBarPics.remove(picId);
                        }
                        return;
                      }

                      final result = await Get.to<dynamic>(() => PhotoScreen(
                          picId: picId as String,
                          picIdList:
                              controller.allTaggedPicIdList.keys.toList(),),);
                      if (null == result) {
                        await refreshEverything();
                      }
                    },
                    child: GestureDetector(
                      onLongPress: () {
                        if (tabsController.multiPicBar.value == false) {
                          tabsController.setMultiPicBar(true);
                        }
                        tabsController.selectedMultiBarPics[picId as String] = true;
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: PhotoWidget(
                              picStore: picStore,
                              hash: blurHash,
                            ),
                          ),
                          if (picStore != null && picStore.isStarred.value)
                            Positioned(
                              left: 6,
                              top: 6,
                              child:
                                  Image.asset('lib/images/staryellowico.png'),
                            ),
                          if (tabsController.multiPicBar.value &&
                              tabsController.selectedMultiBarPics[picId] !=
                                  null &&
                              tabsController.selectedMultiBarPics[picId] ==
                                  true) ...[
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
                            if (picStore?.isPrivate.value ?? false)
                              Positioned(
                                right: 8,
                                top: 6,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  padding: const EdgeInsets.only(bottom: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffffcc00),
                                        Color(0xffffe98f),
                                      ],
                                      stops: [0.2291666716337204, 1],
                                      end: Alignment(1, -0),
                                      // angle: 0,
                                      // scale: undefined,
                                    ),
                                  ),
                                  child: Image.asset(
                                      'lib/images/smallwhitelock.png',),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          },);
    },);
  }
}
