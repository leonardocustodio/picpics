import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:intl/intl.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/utils/refresh_everything.dart';

class TaggedTabDate extends GetWidget<TaggedController> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var monthKeys = controller.allTaggedPicDateWiseMap.entries.toList();

      return StaggeredGridView.countBuilder(
          addAutomaticKeepAlives: true,
          key: Key('Date Tagging'),
          controller: _scrollController,
          padding: EdgeInsets.only(top: 2),
          primary: false,
          shrinkWrap: false,
          crossAxisCount: 5,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          itemCount: controller.allTaggedPicDateWiseMap.length,
          staggeredTileBuilder: (int index) {
            if (index == 0 || monthKeys[index].key is DateTime) {
              return StaggeredTile.extent(5, 40);
            }
            return StaggeredTile.count(1, 1);
          },
          itemBuilder: (_, int index) {
            if (index == 0 || monthKeys[index].key is DateTime) {
              var isSelected = false;
              if (controller.multiPicBar.value) {
                isSelected = monthKeys[index].value.every(
                    (picId) => controller.selectedMultiBarPics[picId] == true);
              }
              return GestureDetector(
                onTap: () {
                  if (controller.multiPicBar.value) {
                    monthKeys[index].value.forEach((picId) {
                      if (isSelected) {
                        controller.selectedMultiBarPics.remove(picId);
                      } else {
                        controller.selectedMultiBarPics[picId] = true;
                      }
                    });
                  }
                },
                child: buildDateHeader(
                  monthKeys[index].key,
                  isSelected,
                ),
              );
            }
            return Obx(() {
              var blurHash =
                  BlurHashController.to.blurHash[monthKeys[index].key];

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
                  if (TabsController
                          .to.picStoreMap[monthKeys[index].key]?.value !=
                      null)
                    Positioned.fill(
                        child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          child: _buildTaggedDateImageWidget(
                            TabsController
                                .to.picStoreMap[monthKeys[index].key]!.value,
                          ),
                        ),
                      ),
                    )),
                ],
              );
            });
          });
    });
  }

  Widget _buildTaggedDateImageWidget(PicStore picStore) {
//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;
    final picId = picStore.photoId.value;
    var hash = BlurHashController.to.blurHash[picId];

    final imageProvider = AssetEntityImageProvider(picStore, isOriginal: false);

    return ExtendedImage(
      filterQuality: FilterQuality.low,
      gaplessPlayback: true,
      clearMemoryCacheWhenDispose: true,
      handleLoadingProgress: true,
      image: imageProvider,
      fit: BoxFit.cover,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            if (null == hash) {
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
                    hash: hash,
                    color: Colors.transparent,
                  ),
                ),
              );
            }
          case LoadState.completed:
            return FadeImageBuilder(
              child: GestureDetector(
                onLongPress: () {
                  //print('LongPress');
                  if (controller.multiPicBar.value == false) {
                    controller.selectedMultiBarPics[picId] = true;
                    controller.setMultiPicBar(true);
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

                    var result = await Get.to(() => PhotoScreen(
                        picId: picId,
                        picIdList:
                            controller.allTaggedPicIdList.keys.toList()));
                    if (null == result) {
                      await refresh_everything();
                    }
                  },
                  child: Obx(() {
                    if (controller.multiPicBar.value) {
                      if (controller.selectedMultiBarPics[picId] != null) {
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: state.completedWidget,
                            ),
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
                        );
                      }
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: state.completedWidget,
                          ),
                          Positioned(
                            left: 8.0,
                            top: 6.0,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: state.completedWidget,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            );
          case LoadState.failed:
            return Center(
              child: Text(
                'Failed loading',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0),
              ),
            );
        }
      },
    );
  }

  String dateFormat(DateTime dateTime) {
    return DateFormat.yMMMM().format(dateTime);
  }

  Widget buildDateHeader(DateTime date, bool isSelected) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      height: 40.0,
      child: Row(
        children: [
          if (TabsController.to.multiPicBar.value)
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: kSecondaryGradient,
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey, width: 1.0)),
              child: isSelected
                  ? Image.asset('lib/images/checkwhiteico.png')
                  : null,
            ),
          /* Positioned(
              left: 8.0,
              top: 6.0,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  gradient: kSecondaryGradient,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset('lib/images/checkwhiteico.png'),
              ),
            ), */
          Text(
            '${dateFormat(date)}',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ],
      ),
    );
  }
}
