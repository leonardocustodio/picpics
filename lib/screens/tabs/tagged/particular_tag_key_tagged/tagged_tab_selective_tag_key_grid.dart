import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/widgets/photo_widget.dart';

// ignore: must_be_immutable
class TaggedTabSelectiveTagKeyGrid extends GetWidget<TaggedController> {
  final String tagKey;
  const TaggedTabSelectiveTagKeyGrid(this.tagKey, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final taggedPicIds =
          controller.taggedPicId[tagKey]?.keys.toList().reversed.toList() ??
              <String>[];

      return StaggeredGridView.countBuilder(
          key: Key(tagKey),
          padding: const EdgeInsets.only(top: 2),
          crossAxisCount: 4,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          itemCount: taggedPicIds.length,
          staggeredTileBuilder: (_) {
            return const StaggeredTile.count(1, 1);
          },
          itemBuilder: (_, int index) {
            return Obx(() {
              final picId = taggedPicIds[index];

              var blurHash = BlurHashController.to.blurHash[picId];
              final picStore = TabsController.to.picStoreMap[picId]!.value;
              return Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      if (controller.multiPicBar.value) {
                        if (controller.selectedMultiBarPics[picId] == null) {
                          controller.selectedMultiBarPics[picId] = true;
                        } else {
                          controller.selectedMultiBarPics.remove(picId);
                        }
                        return;
                      }
                      await Get.to(() =>
                          PhotoScreen(picId: picId, picIdList: taggedPicIds));
                    },
                    child: GestureDetector(
                      onLongPress: () {
                        if (controller.multiPicBar.value == false) {
                          controller.setMultiPicBar(true);
                        }
                        controller.selectedMultiBarPics[picId] = true;
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
                              controller.selectedMultiBarPics[picId] !=
                                  null) ...[
                            Container(
                              constraints: const BoxConstraints.expand(),
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
            });
          });
    });
  }
}
