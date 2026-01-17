// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/* import 'package:picpics/stores/gallery_store.dart'; */
/* import 'package:picpics/stores/tagged_controller.dart'; */
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:picpics/asset_entity_image_provider.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/fade_image_builder.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/screens/all_tags_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/widgets/tags_list.dart';

class PhotoScreenState {
  PhotoScreenState({
    this.overlay = true,
    this.showSlideshow = false,
    this.selectedIndex = 0,
  });
  final bool overlay;
  final bool showSlideshow;
  final int selectedIndex;

  PhotoScreenState copyWith({
    bool? overlay,
    bool? showSlideshow,
    int? selectedIndex,
  }) {
    return PhotoScreenState(
      overlay: overlay ?? this.overlay,
      showSlideshow: showSlideshow ?? this.showSlideshow,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class PhotoScreenNotifier extends StateNotifier<PhotoScreenState> {
  PhotoScreenNotifier() : super(PhotoScreenState());

  void setOverlay({required bool value}) {
    state = state.copyWith(overlay: value);
  }

  void setShowSlideshow({required bool value}) {
    state = state.copyWith(showSlideshow: value);
  }

  void setSelectedIndex(int value) {
    state = state.copyWith(selectedIndex: value);
  }
}

final StateNotifierProvider<PhotoScreenNotifier, PhotoScreenState> photoScreenProvider =
    StateNotifierProvider.autoDispose<PhotoScreenNotifier, PhotoScreenState>((ref) {
  return PhotoScreenNotifier();
});

// ignore_for_file: unused_field
class PhotoScreen extends ConsumerStatefulWidget {
  const PhotoScreen({required this.picId, required this.picIdList, super.key});

  final String picId;
  final List<String> picIdList;

  @override
  ConsumerState<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends ConsumerState<PhotoScreen> {
  late PageController galleryPageController;
  final idList = <String>[];

  @override
  void initState() {
    super.initState();

    unawaited(Analytics.sendCurrentScreen(Screen.photo_screen));

    if (widget.picIdList.isNotEmpty) {
      idList.addAll(widget.picIdList);
    }
    final index = getPicIdList().indexOf(widget.picId);
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(photoScreenProvider.notifier).setSelectedIndex(index);
      });
    }
    galleryPageController = PageController(initialPage: index != -1 ? index : 0);
  }

  @override
  void dispose() {
    galleryPageController.dispose();
    super.dispose();
  }

  static const id = 'photo_screen';

  /*  @override
  void initState() {
    super.initState();
  } */

  String? getPicId(int index) {
    try {
      return getPicIdList()[index];
    } on Exception {
      return null;
    }
  }

  List<String> getPicIdList() {
    if (idList.isNotEmpty) {
      return idList;
    }
    return ref.read(tabsProvider).assetMap.keys.toList();
  }

  void changeOverlay() {
    final photoScreenNotifier = ref.read(photoScreenProvider.notifier);
    final photoScreenState = ref.read(photoScreenProvider);

    if (!photoScreenState.overlay) {
      photoScreenNotifier.setOverlay(value: true);
      // TODO(picpics): Removing this to compile
      // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      if (!photoScreenState.showSlideshow) {
        photoScreenNotifier.setShowSlideshow(value: true);
      } else {
        photoScreenNotifier
          ..setShowSlideshow(value: false)
          ..setOverlay(value: false);
        // TODO(picpics): Removing this to compile
        // SystemChrome.setEnabledSystemUIOverlays([]);
      }
    }
  }

  String dateFormat(DateTime dateTime) {
    final formatter = DateFormat.yMMMEd();
    return formatter.format(dateTime);
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final picIdValue = getPicIdList()[index];
    final picStore =
        ref.read(tabsProvider).picStoreMap[picIdValue] ?? ref.read(tabsProvider.notifier).explorPicStore(picIdValue);

    if (picStore == null) {
      return PhotoViewGalleryPageOptions.customChild(
        child: const Center(child: Text('Photo not available', style: TextStyle(color: Colors.white))),
      );
    }

    final imageProvider = AssetEntityImageProvider(picStore);

    return PhotoViewGalleryPageOptions.customChild(
      child: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ExtendedImage(
          image: imageProvider,
          fit: BoxFit.contain,
          loadStateChanged: (ExtendedImageState state) {
            Widget loader;
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                loader = const ColoredBox(color: kGreyPlaceholder);
              case LoadState.completed:
                loader = FadeImageBuilder(
                  child: () {
                    return RepaintBoundary(
                      child: state.completedWidget,
                    );
                  }(),
                );
              case LoadState.failed:
                loader = Container();
            }
            return loader;
          },
        ),

        // FullImageItem(
        //   picStore: picStore,
        //   size: MediaQuery.of(context).size.height.toInt(),
        //   fit: BoxFit.contain,
        //   backgroundColor: Colors.black,
        // ),
      ),
      childSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      onTapUp: (context, details, controller) {
        changeOverlay();
      },
//      initialScale: PhotoViewComputedScale.contained,
//      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
//      maxScale: PhotoViewComputedScale.covered * 1.1,
      minScale: 0.7,
      maxScale: 3.0,
      heroAttributes: PhotoViewHeroAttributes(tag: picIdValue),
    );
  }

  Widget _buildThumbnails(BuildContext context, int index) {
    final picIdValue = getPicIdList()[index];
    final picStore =
        ref.read(tabsProvider).picStoreMap[picIdValue] ?? ref.read(tabsProvider.notifier).explorPicStore(picIdValue);

    if (picStore == null) {
      return Container(
        height: 98,
        width: 98,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: Colors.grey[300],
      );
    }

    final imageProvider = AssetEntityImageProvider(picStore);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        ref.read(photoScreenProvider.notifier).setSelectedIndex(index);
        galleryPageController.jumpToPage(index);
      },
      child: Container(
        height: 98,
        width: 98,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ExtendedImage(
          image: imageProvider,
          fit: BoxFit.cover,
          loadStateChanged: (ExtendedImageState state) {
            Widget loader;
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                loader = const ColoredBox(color: kGreyPlaceholder);
              case LoadState.completed:
                loader = FadeImageBuilder(
                  child: () {
                    return RepaintBoundary(
                      child: state.completedWidget,
                    );
                  }(),
                );
              case LoadState.failed:
                loader = Container();
            }
            return loader;
          },
        ),

        // ImageItem(
        //   picStore: TabsController_.to.thumbnailsPics[index],
        //   size: 98,
        //   fit: BoxFit.cover,
        //   backgroundColor: Colors.black,
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoScreenState = ref.watch(photoScreenProvider);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints.expand(),
              color: const Color(0xff101010),
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: getPicIdList().length,
                loadingBuilder: (context, event) => Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      value: event == null || event.expectedTotalBytes == null
                          ? 0
                          : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                    ),
                  ),
                ),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                pageController: galleryPageController,
                onPageChanged: (index) {
                  ref.read(photoScreenProvider.notifier).setSelectedIndex(index);
                  //GalleryStore.to.setSelectedThumbnail(index);
                },
              ),
            ),
            if (photoScreenState.overlay)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2,
                        sigmaY: 2,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7 * 0.37 * 0.3),
                              Colors.black.withValues(alpha: 1.0 * 0.37 * 0.3),
                            ],
                            stops: const [0, 0.40625],
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Image.asset(
                                  'lib/images/backarrowwithdropshadow.png',
                                ),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                onPressed: () {
                                  final picIdValue = getPicIdList().toList()[photoScreenState.selectedIndex];
                                  final shareAblePicStore = ref.read(tabsProvider).picStoreMap[picIdValue] ??
                                      ref.read(tabsProvider.notifier).explorPicStore(picIdValue);
                                  unawaited(shareAblePicStore?.sharePic());
                                },
                                child: Image.asset(
                                  'lib/images/sharebuttonwithdropshadow.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!photoScreenState.showSlideshow)
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 2,
                          sigmaY: 2,
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 184,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.7).withValues(alpha: 0.37).withValues(alpha: 0.3),
                                Colors.black.withValues(alpha: 1).withValues(alpha: 0.37).withValues(alpha: 0.3),
                              ],
                              stops: const [0, 0.40625],
                            ),
                          ),
                          child: SafeArea(
                            top: false,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      // RichText(
                                      //   textScaler: TextScaler.linear(1.0),
                                      //   text: TextSpan(
                                      //     children: [
                                      //       TextSpan(
                                      //           text: TabsController
                                      //                   .to
                                      //                   .picStoreMap[
                                      //                       getPicIdList()
                                      //                               .toList()[
                                      //                           controller
                                      //                               .selectedIndex
                                      //                               .value]]
                                      //                   ?.value
                                      //                   .specificLocation
                                      //                   .value ??
                                      //               LangControl.to.S.value
                                      //                   .photo_location,
                                      //           style: const TextStyle(
                                      //             fontFamily: 'NotoSans',
                                      //             color: kWhiteColor,
                                      //             fontSize: 17,
                                      //             fontWeight: FontWeight.w400,
                                      //             fontStyle: FontStyle.normal,
                                      //             letterSpacing:
                                      //                 -0.4099999964237213,
                                      //           )),
                                      //       TextSpan(
                                      //         text:
                                      //             '  ${TabsController.to.picStoreMap[getPicIdList()[ref.read(photoScreenProvider).selectedIndex]]?.value.generalLocation.value ?? LangControl.to.S.value.country}',
                                      //         style: const TextStyle(
                                      //           fontFamily: 'NotoSans',
                                      //           color: kWhiteColor,
                                      //           fontSize: 12,
                                      //           fontWeight: FontWeight.w300,
                                      //           fontStyle: FontStyle.normal,
                                      //           letterSpacing:
                                      //               -0.4099999964237213,
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      Text(
                                        dateFormat(
                                          ref
                                                  .read(tabsProvider)
                                                  .picStoreMap[getPicIdList().toList()[photoScreenState.selectedIndex]]
                                                  ?.state
                                                  .createdAt ??
                                              DateTime.now(),
                                        ),
                                        textScaler: TextScaler.noScaling,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          color: kWhiteColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -0.4099999964237213,
                                        ),
                                      ),
                                    ],
                                  ),
                                  BottomTabsListWidget(
                                    picId: getPicIdList().toList()[photoScreenState.selectedIndex],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (photoScreenState.showSlideshow)
                    ClipRect(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7 * 0.37 * 0.3),
                              Colors.black.withValues(alpha: 1.0 * 0.37 * 0.3),
                            ],
                            stops: const [0, 0.40625],
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 98,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: _buildThumbnails,
                                    itemCount: getPicIdList().length,
                                    padding: const EdgeInsets.only(left: 8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class BottomTabsListWidget extends ConsumerWidget {
  const BottomTabsListWidget({required this.picId, super.key});
  final String picId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picWiseTags = ref.watch(taggedProvider).picWiseTags;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: (picWiseTags[picId]?.keys.toList().isEmpty ?? true)
          ? TagsList(
              tagsKeyList: const <String>[],
              tagStyle: TagStyle.multiColored,
              addTagButton: () async {
                final picStore = ref.read(tabsProvider).picStoreMap[picId];

                if (picStore != null) {
                  await Navigator.of(context).push<Object?>(
                    MaterialPageRoute<Object?>(builder: (context) => AllTagsScreen(picStore: picStore)),
                  );
                  await ref.read(taggedProvider.notifier).refreshTaggedPhotos();
                  await ref.read(tabsProvider.notifier).refreshUntaggedList();
                  return;
                }

                Navigator.of(context).pop();
              },
              onTap: (String tagKey) {
                AppLogger.d('ignore click');
              },
              onDoubleTap: (String tagKey) {
//                                        TabsController_.to.picStoreMap[picId]
//                                        TabsController_.to.currentPic.removeTagFromPic(tagKey: DatabaseManager.instance.selectedTagKey);
              },
              onPanEnd: (String tagKey) {
                AppLogger.d('teste');
              },
              /* showEditTagModal: () =>
                                                  showEditTagModal(context, false), */
            )
          : TagsList(
              tagsKeyList: picWiseTags[picId]?.keys.toList() ?? <String>[],
              tagStyle: TagStyle.multiColored,
              addTagButton: () async {
                /* GalleryStore.to.setCurrentPic(
                                                    TabsController_
                                                        .to.picStoreMap[picId].value); */

                /* if (!controller.modalCard.value) {
                                                  controller.setModalCard(true);
                                                } */

                final picStore = ref.read(tabsProvider).picStoreMap[picId];

                if (picStore != null) {
                  await Navigator.of(context).push<Object?>(
                    MaterialPageRoute<Object?>(builder: (context) => AllTagsScreen(picStore: picStore)),
                  );
                  await ref.read(taggedProvider.notifier).refreshTaggedPhotos();
                  await ref.read(tabsProvider.notifier).refreshUntaggedList();
                  return;
                }

                Navigator.of(context).pop();
              },
              onTap: (String tagKey) {
                AppLogger.d('ignore click');
              },
              onDoubleTap: (String tagKey) {
//                                        TabsController_.to.picStoreMap[picId]
//                                        TabsController_.to.currentPic.removeTagFromPic(tagKey: DatabaseManager.instance.selectedTagKey);
              },
              onPanEnd: (String tagKey) {
                AppLogger.d('teste');
              },
              /* showEditTagModal: () =>
                                                  showEditTagModal(context, false), */
            ),
    );
  }
}
