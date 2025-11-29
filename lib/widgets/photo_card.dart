import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:picpics/asset_entity_image_provider.dart';
import 'package:picpics/components/circular_menu.dart';
import 'package:picpics/components/circular_menu_item.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/fade_image_builder.dart';
import 'package:picpics/providers/blur_hash_provider.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/all_tags_screen.dart';
import 'package:picpics/screens/photo_screen.dart';
import 'package:picpics/providers/pic_store_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/utils/functions.dart';
import 'package:picpics/utils/refresh_everything.dart';
import 'package:picpics/widgets/tags_list.dart';

class PhotoCard extends ConsumerStatefulWidget {
  const PhotoCard({
    required this.picStore,
    required this.picsInThumbnails,
    required this.picsInThumbnailIndex,
    super.key,
  });

  final PicStoreNotifier picStore;
  final PicSource picsInThumbnails;
  final int picsInThumbnailIndex;

  @override
  ConsumerState<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends ConsumerState<PhotoCard> {
  final GlobalKey _photoSpaceKey = GlobalKey();

  PicStoreNotifier get picStore => widget.picStore;

  BoxFit boxFit = BoxFit.cover;

  TextEditingController tagsEditingController = TextEditingController();
  late FocusNode tagsFocusNode;

  String dateFormat(DateTime dateTime) {
    final formatter = DateFormat.yMMMEd();
    return formatter.format(dateTime);
  }

  Future<List<String>> reverseGeocoding(BuildContext context) async {
    final s = ref.read(sProvider);

    if (picStore.state.specificLocation != null &&
        picStore.state.generalLocation != null) {
      return [
        picStore.state.specificLocation!,
        '  ${picStore.state.generalLocation}',
      ];
    }

    if ((picStore.state.originalLatitude == null ||
            picStore.state.originalLongitude == null) ||
        (picStore.state.originalLatitude == 0 && picStore.state.originalLongitude == 0)) {
      return [
        s.photo_location,
        '  ${s.country}',
      ];
    }

    final placemark = await placemarkFromCoordinates(
        picStore.state.originalLatitude!, picStore.state.originalLongitude!,);

    AppLogger.d('Placemark: ${placemark.length}');
    for (final place in placemark) {
      AppLogger.d('${place.name} - ${place.locality} - ${place.country}');
    }

    if (placemark.isNotEmpty) {
      AppLogger.d('Saving pic!!!');
      await picStore.saveLocation(
        lat: picStore.state.originalLatitude!,
        long: picStore.state.originalLongitude!,
        specific: placemark[0].locality,
        general: placemark[0].country,
      );
      return [placemark[0].locality!, '  ${placemark[0].country}'];
    }

    return [
      s.photo_location,
      '  ${s.country}',
    ];
  }

  void focusTagsEditingController() {}

  void getSizeAndPosition() {
    final cardBox =
        _photoSpaceKey.currentContext!.findRenderObject()! as RenderBox;
    AppLogger.d('Card Box Size: ${cardBox.size.height}');
    ref.read(userProvider.notifier).setPhotoHeightInCardWidget(cardBox.size.height);
  }

  String? hash;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final blurHashState = ref.read(blurHashProvider);
      hash = blurHashState.blurHash[picStore.state.photoId];
      if (mounted) {
        setState(() {});
      }
    });

    tagsFocusNode = FocusNode();
  }

  @override
  void dispose() {
    tagsEditingController.dispose();
    tagsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final taggedState = ref.watch(taggedProvider);
    final tagsState = ref.watch(tagsProvider);
    final s = ref.watch(sProvider);
    final blurHashState = ref.watch(blurHashProvider);

    hash ??= blurHashState.blurHash[picStore.state.photoId];

    final imageProvider = AssetEntityImageProvider(picStore,
        thumbSize: kDefaultPhotoSize, isOriginal: false,);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                if (null != hash)
                  BlurHash(
                    hash: hash!,
                    color: Colors.transparent,
                  ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: RepaintBoundary(
                    child: ExtendedImage(
                      gaplessPlayback: true,
                      clearMemoryCacheWhenDispose: true,
                      handleLoadingProgress: true,
                      key: _photoSpaceKey,
                      afterPaintImage: (canvas, rect, image, paint) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => getSizeAndPosition());
                      },
                      image: imageProvider,
                      fit: boxFit,
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            if (null == hash) {
                              return const ColoredBox(color: kGreyPlaceholder);
                            } else {
                              return BlurHash(
                                hash: hash!,
                                color: Colors.transparent,
                              );
                            }
                          case LoadState.completed:
                            return FadeImageBuilder(
                              child: GestureDetector(
                                onDoubleTap: () {
                                  setState(() {
                                    boxFit = (boxFit == BoxFit.cover)
                                        ? BoxFit.contain
                                        : BoxFit.cover;
                                  });
                                },
                                child: RepaintBoundary(
                                  child: Container(
                                    color: Colors.black,
                                    constraints: const BoxConstraints.expand(),
                                    child: state.completedWidget,
                                  ),
                                ),
                              ),
                            );
                          case LoadState.failed:
                            return Container();
                        }
                      },
                    ),
                  ),
                ),
                CircularMenu(
                  isExpanded: userState.isMenuExpanded,
                  useInHorizontal:
                      userState.photoHeightInCardWidget < 280
                          ? true
                          : false,
                  alignment: Alignment.bottomRight,
                  radius: 52,
                  toggleButtonOnPressed: () {
                    ref.read(userProvider.notifier).switchIsMenuExpanded();
                  },
                  toggleButtonColor:
                      const Color(0xFF979A9B).withValues(alpha: 0.5),
                  toggleButtonBoxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 3, spreadRadius: 3,),
                  ],
                  toggleButtonIconColor: Colors.white,
                  toggleButtonMargin: 12,
                  toggleButtonPadding: 8,
                  toggleButtonSize: 19.2,
                  items: [
                    CircularMenuItem(
                      image: Image.asset('lib/images/trashmenu.png'),
                      color: kWarningColor,
                      iconSize: 19.2,
                      onTap: () {
                        ref.read(tabsProvider.notifier)
                            .removePicFromUI(picStore.state.photoId);
                        ref.read(tabsProvider.notifier).trashPic(picStore.state.photoId);
                      },
                    ),
                    CircularMenuItem(
                      image: picStore.state.isPrivate == true
                          ? Image.asset('lib/images/openlockmenu.png')
                          : Image.asset('lib/images/lockmenu.png'),
                      color: picStore.state.isPrivate == true
                          ? const Color(0xFFF5FAFA)
                          : kYellowColor,
                      iconSize: 19.2,
                      onTap: () {
                        showDeleteSecretModal(context, ref, picStore);
                      },
                    ),
                    CircularMenuItem(
                      image: Image.asset('lib/images/sharemenu.png'),
                      color: kPrimaryColor,
                      iconSize: 19.2,
                      onTap: () {
                        picStore.sharePic();
                      },
                    ),
                    CircularMenuItem(
                      image: Image.asset('lib/images/expandmenu.png'),
                      color: kSecondaryColor,
                      iconSize: 19.2,
                      onTap: () async {
                        await Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => PhotoScreen(
                              picIdList: const [],
                              picId: picStore.state.photoId,
                            ),
                          ),
                        );
                        refreshEverything(ref);
                      },
                    ),
                  ],
                  backgroundWidget: Container(),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: null,
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        dateFormat(picStore.state.createdAt),
                        textScaler: const TextScaler.linear(1),
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff606566),
                          fontSize: 14.5,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.4099999964237213,
                        ),
                      ),
                    ),
                  ],
                ),
                TagsList(
                  tagStyle: TagStyle.multiColored,
                  tagsKeyList: taggedState.picWiseTags[picStore.state.photoId]
                          ?.keys
                          .toList() ??
                      <String>[],
                  addTagField: true,
                  textEditingController: tagsEditingController,
                  textFocusNode: tagsFocusNode,
                  shouldChangeToSwipeMode: true,
                  aiButtonTitle: s.allTags,
                  onAiButtonTap: () async {
                    await Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => AllTagsScreen(picStore: picStore),
                      ),
                    );
                    AppLogger.d('ai button tapped');
                  },
                  onTap: (String key) {
                    AppLogger.d('do nothing');
                  },
                  onDoubleTap: (String value) {
                    AppLogger.d('do nothing');
                  },
                  onPanEnd: (String selectedTagKey) async {
                    await ref.read(tagsProvider.notifier).removeTagFromPic(
                        picId: picStore.state.photoId,
                        tagKey: selectedTagKey,);

                    await picStore.tagsSuggestionsCalculate();
                    await ref.read(taggedProvider.notifier).refreshTaggedPhotos();
                    await ref.read(tabsProvider.notifier).loadAssetPath();
                  },
                  onChanged: (text) async {
                    ref.read(tagsProvider.notifier).setSearchText(text);
                    await ref.read(tagsProvider.notifier).tagsSuggestionsCalculate();
                  },
                  onSubmitted: (text) async {
                    AppLogger.d('return');

                    if (text != '') {
                      final tagKey = await ref.read(tagsProvider.notifier).createTag(text);
                      await picStore.addMultipleTagsToPic(
                          acceptedTagKeys: {tagKey: ''},);

                      HapticFeedback.lightImpact();
                      tagsEditingController.clear();
                      ref.read(tagsProvider.notifier).setSearchText('');
                      await ref.read(tagsProvider.notifier).tagsSuggestionsCalculate();
                      await ref.read(taggedProvider.notifier).refreshTaggedPhotos();
                      await ref.read(tabsProvider.notifier).loadAssetPath();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Builder(
                    builder: (context) {
                      String suggestionsTitle;

                      if (picStore.state.aiTags) {
                        if (picStore.state.aiTagsLoaded == false) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.suggestions,
                                textScaler: const TextScaler.linear(1),
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff979a9b),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: -0.4099999964237213,
                                ),
                              ),
                              const Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 32, bottom: 32),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kSecondaryColor,),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        suggestionsTitle = s.suggestions;
                      } else if (picStore.state.searchText != '') {
                        suggestionsTitle = s.search_results;
                      } else {
                        suggestionsTitle = s.recent_tags;
                      }

                      AppLogger.d(
                          '$suggestionsTitle : ${picStore.state.aiTags} : suggestionsTitle',);

                      return TagsList(
                        title: suggestionsTitle,
                        tagsKeyList: tagsState.searchTagsResults
                            .map((e) => e.key)
                            .toList()
                            .where((tagKey) {
                          if (taggedState.picWiseTags[
                                      picStore.state.photoId] !=
                                  null &&
                              taggedState.picWiseTags[
                                          picStore.state.photoId]
                                      ?[tagKey] !=
                                  null) {
                            return false;
                          }

                          return true;
                        }).toList(),
                        tagStyle: TagStyle.grayOutlined,
                        onTap: (tagKey) async {
                          await picStore.addMultipleTagsToPic(
                              acceptedTagKeys: {tagKey: ''},);
                          await ref.read(tagsProvider.notifier)
                              .tagsSuggestionsCalculate();
                          await ref.read(taggedProvider.notifier).refreshTaggedPhotos();
                          await ref.read(tabsProvider.notifier).loadAssetPath();
                        },
                        onDoubleTap: (tagKey) {
                          AppLogger.d('do nothing');
                        },
                        onPanEnd: (tagKey) {
                          AppLogger.d('do nothing');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
