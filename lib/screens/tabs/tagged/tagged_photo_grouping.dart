import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picPics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_key.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/widgets/photo_widget.dart';

final height = (Get.width / 3) - 20;

class TaggedPhotosGrouping extends GetWidget<TaggedController> {
  const TaggedPhotosGrouping({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<TagsController>(builder: (tagsController) {
      /// Show the tags tab

      final tempTaggedStorage = controller.taggedPicId.keys.toList();
      var taggedKeys = <String>[];
      if (tagsController.selectedFilteringTagsKeys.isNotEmpty) {
        final tempStorage = <String, String>{};
        tagsController.selectedFilteringTagsKeys.forEach((key, _) {
          if (controller.taggedPicId[key] != null) {
            taggedKeys.add(key);
            tempStorage[key] = '';
          }
        });
        for (var tag in tempTaggedStorage) {
          if (tempStorage[tag] == null) {
            taggedKeys.add(tag);
          }
        }
      } else {
        taggedKeys = controller.taggedPicId.keys.toList();
      }

      return StaggeredGridView.countBuilder(
        key: const Key('tag'),
        padding: const EdgeInsets.only(left: 7, right: 7),
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
        itemCount: taggedKeys.length,
        staggeredTileBuilder: (_) {
          return StaggeredTile.extent(1, height + 45);
        },
        itemBuilder: (_, int index) {
          return Obx(() {
            final tagKey = taggedKeys[index];
            final showingPicId =
                controller.taggedPicId[taggedKeys[index]]?.keys.last;

            final blurHash = BlurHashController.to.blurHash[showingPicId];
            final ignore = tagsController.isSearching.value &&
                tagsController.selectedFilteringTagsKeys[tagKey] == null;
            print('$ignore');
            return IgnorePointer(
              ignoring: ignore,
              child: Opacity(
                opacity: ignore ? 0.3 : 1.0,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => TaggedTabSelectiveTagKey(tagKey));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: GetX<TabsController>(builder: (tabsController) {
                      PicStore? picStore;

                      if (showingPicId != null) {
                        picStore =
                            tabsController.picStoreMap[showingPicId]?.value;
                      }

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: null != blurHash
                                    ? BlurHash(
                                        hash: blurHash,
                                        color: Colors.transparent,
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(10),
                                        color: Colors.grey[300],
                                      ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: PhotoWidget(picStore: picStore),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: AutoSizeText.rich(
                                      TextSpan(
                                          text: TagsController
                                                  .to
                                                  .allTags[tagKey]
                                                  ?.value
                                                  .title ??
                                              '',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  ' (${controller.taggedPicId[tagKey]?.keys.length ?? 0})',
                                            )
                                          ]),
                                      maxFontSize: 20,
                                      minFontSize: 5,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (picStore?.isStarred.value ?? false)
                            Positioned(
                              left: 6.0,
                              top: 6.0,
                              child:
                                  Image.asset('lib/images/staryellowico.png'),
                            ),
                          if (picStore?.isPrivate.value ?? false)
                            Positioned(
                              right: 8.0,
                              top: 6.0,
                              child: Container(
                                height: 20,
                                width: 20,
                                padding: const EdgeInsets.only(bottom: 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffffcc00),
                                      Color(0xffffe98f)
                                    ],
                                    stops: [0.2291666716337204, 1],
                                    begin: Alignment(-1.0, 0.0),
                                    end: Alignment(1.0, -0.0),
                                    // angle: 0,
                                    // scale: undefined,
                                  ),
                                ),
                                child: Image.asset(
                                    'lib/images/smallwhitelock.png'),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            );
          });
        },
      );
    });
  }
}
