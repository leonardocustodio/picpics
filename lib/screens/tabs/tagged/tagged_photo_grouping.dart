import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_key.dart';
import 'package:picPics/stores/blur_hash_controller.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';

class TaggedPhotosGrouping extends GetWidget<TaggedController> {
  TaggedPhotosGrouping({Key? key}) : super(key: key);
  final height = (Get.width / 3) - 20;

  @override
  Widget build(BuildContext context) {
    return GetX<TagsController>(builder: (tagsController) {
      /// Show the tags tab

      final tempTaggedStorage = controller.taggedPicId.keys.toList();
      var taggedKeys = <String>[];
      if (tagsController.selectedFilteringTagsKeys.isNotEmpty) {
        final tempStorage = <String, String>{};
        tagsController.selectedFilteringTagsKeys.forEach((key, _) {
          taggedKeys.add(key);
          tempStorage[key] = '';
        });
        tempTaggedStorage.forEach((tag) {
          if (tempStorage[tag] == null) {
            taggedKeys.add(tag);
          }
        });
      } else {
        taggedKeys = controller.taggedPicId.keys.toList();
      }

      return StaggeredGridView.countBuilder(
        key: Key('tag'),
        padding: EdgeInsets.only(left: 7, right: 7),
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
        itemCount: taggedKeys.length,
        itemBuilder: (BuildContext _, int index) {
          return Obx(() {
            final tagKey = taggedKeys[index];
            final showingPicId =
                controller.taggedPicId[taggedKeys[index]]?.keys.last;
            Widget? originalImage;

            final blurHash = BlurHashController.to.blurHash[showingPicId];
            final ignore = tagsController.isSearching.value &&
                tagsController.selectedFilteringTagsKeys[tagKey] == null;
            print('$ignore');
            return IgnorePointer(
              ignoring: ignore,
              child: Opacity(
                opacity: ignore ? 0.3 : 1.0,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: GetX<TabsController>(builder: (tabsController) {
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
                                  : Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        color: Colors.grey[300],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        if (originalImage == null &&
                            showingPicId != null &&
                            tabsController.picStoreMap[showingPicId]?.value !=
                                null)
                          Positioned.fill(
                            child: _buildPicItem(
                              tabsController.picStoreMap[showingPicId]!.value,
                              showingPicId,
                              tagKey,
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            );
          });
        },
        staggeredTileBuilder: (_) {
          return StaggeredTile.extent(1, height + 45);
        },
      );
    });
  }

  Widget _buildPicItem(PicStore? picStore, String picId, String tagKey) {
    if (null == picStore) {
      return Container();
    }
    final imageProvider = AssetEntityImageProvider(picStore, isOriginal: false);

    var hash = BlurHashController.to.blurHash[picId];

    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        shape: BoxShape.rectangle,
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
                child: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Get.to(() => TaggedTabSelectiveTagKey(tagKey));
                  },
                  child: Obx(() {
                    Widget image = Positioned.fill(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: state.completedWidget),
                    );

                    final items = <Widget>[image];

                    if (picStore.isPrivate.value == true) {
                      items.add(
                        Positioned(
                          right: 8.0,
                          top: 6.0,
                          child: Container(
                            height: 20,
                            width: 20,
                            padding: const EdgeInsets.only(bottom: 2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                colors: [Color(0xffffcc00), Color(0xffffe98f)],
                                stops: [0.2291666716337204, 1],
                                begin: Alignment(-1.00, 0.00),
                                end: Alignment(1.00, -0.00),
                                // angle: 0,
                                // scale: undefined,
                              ),
                            ),
                            child: Image.asset('lib/images/smallwhitelock.png'),
                          ),
                        ),
                      );
                    }

                    if (picStore.isStarred.value == true) {
                      //print('Adding starred yellow ico');
                      items.add(
                        Positioned(
                          left: 6.0,
                          top: 6.0,
                          child: Image.asset('lib/images/staryellowico.png'),
                        ),
                      );
                    }

                    return Container(
                        child: Column(
                      children: [
                        Expanded(
                          child: Stack(children: items),
                        ),
                        Container(
                          // color: Colors.brown.withOpacity(.9),
                          margin: const EdgeInsets.only(top: 5),
                          child: AutoSizeText.rich(
                            TextSpan(
                                text:
                                    '${TagsController.to.allTags[tagKey]?.value.title ?? ''}',
                                style: TextStyle(
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
                    ));
                  }),
                ),
              );
            case LoadState.failed:
              return Container();
          }
        },
      ),
    );
  }
}
