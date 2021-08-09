import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/refresh_everything.dart';

class UntaggedImageWidgets extends GetWidget<TabsController> {
  final PicStore picStore;
  final String picId;
  final String? hash;
  const UntaggedImageWidgets(
      {required this.picStore, required this.picId, this.hash, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageProvider = AssetEntityImageProvider(picStore, isOriginal: false);

    return ExtendedImage(
      filterQuality: FilterQuality.medium,
      image: imageProvider,
      fit: BoxFit.cover,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            if (hash == null) {
              return Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: ColoredBox(color: kGreyPlaceholder),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: BlurHash(
                    hash: hash!,
                    color: Colors.transparent,
                  ),
                ),
              );
            }
          case LoadState.completed:
            return FadeImageBuilder(
              milliseconds: 200,
              child: GestureDetector(
                onLongPress: () {
                  //print('LongPress');
                  if (controller.multiPicBar.value == false) {
                    controller.setMultiPicBar(true);
                    controller.selectedMultiBarPics[picId] = true;
                  }
                },
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
                    await Get.to(() => PhotoScreen(
                        picId: picId,
                        picIdList: controller.allUnTaggedPics.keys.toList()));

                    await refresh_everything();
                  },
                  child: Obx(() => Stack(
                        children: [
                          Positioned.fill(child: state.completedWidget),
                          if (controller.multiPicBar.value &&
                              controller.selectedMultiBarPics[picId] !=
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
                                child:
                                    Image.asset('lib/images/checkwhiteico.png'),
                              ),
                            ),
                          ],
                        ],
                      )),
                ),
              ),
            );
          case LoadState.failed:
            return Helpers.failedItem;
        }
      },
    );
  }
}
