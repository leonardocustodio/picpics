import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/screens/add_location.dart';
import 'package:picPics/screens/all_tags_screen.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/functions.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:picPics/components/circular_menu.dart';
import 'package:picPics/components/circular_menu_item.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'show_watch_ad_modal.dart';

//typedef EditTagModalTypeDef = dynamic Function(String tagKey);

class PhotoCard extends StatefulWidget {
  final PicStore picStore;

  //final EditTagModalTypeDef showEditTagModal;
  //final Function showDeleteSecretModal;
  final PicSource picsInThumbnails;
  final int picsInThumbnailIndex;

  PhotoCard({
    this.picStore,
    //this.showEditTagModal,
    //this.showDeleteSecretModal,
    this.picsInThumbnails,
    this.picsInThumbnailIndex,
  });

  @override
  _PhotoCardState createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  final GlobalKey _photoSpaceKey = GlobalKey();

  TabsController tabsStore;
  PicStore get picStore => widget.picStore;

  List<int> photoSize;

  BoxFit boxFit = BoxFit.cover;

  TextEditingController tagsEditingController = TextEditingController();
  FocusNode tagsFocusNode;

  String dateFormat(DateTime dateTime) {
    var formatter = DateFormat.yMMMEd();
    return formatter.format(dateTime);
  }

  Future<List<String>> reverseGeocoding(BuildContext context) async {
    if (picStore.specificLocation != null && picStore.generalLocation != null) {
      return [picStore.specificLocation.value, '  ${picStore.generalLocation}'];
    }

    if ((picStore.originalLatitude == null ||
            picStore.originalLongitude == null) ||
        (picStore.originalLatitude == 0 && picStore.originalLongitude == 0)) {
      return [S.of(context).photo_location, '  ${S.of(context).country}'];
    }

    List<Placemark> placemark = await placemarkFromCoordinates(
        picStore.originalLatitude, picStore.originalLongitude);

    //print('Placemark: ${placemark.length}');
    for (var place in placemark) {
      //print('${place.name} - ${place.locality} - ${place.country}');
    }

    if (placemark.isNotEmpty) {
      //print('Saving pic!!!');
      picStore.saveLocation(
        lat: picStore.originalLatitude,
        long: picStore.originalLongitude,
        specific: placemark[0].locality,
        general: placemark[0].country,
      );
      return [placemark[0].locality, '  ${placemark[0].country}'];
    }

    return [S.of(context).photo_location, '  ${S.of(context).country}'];
  }

  void focusTagsEditingController() {}

  void getSizeAndPosition() {
    RenderBox _cardBox = _photoSpaceKey.currentContext.findRenderObject();
    //print('Card Box Size: ${_cardBox.size.height}');
    UserController.to.setPhotoHeightInCardWidget(_cardBox.size.height);
  }

  @override
  void initState() {
    super.initState();
    tagsFocusNode = FocusNode();

    if (KeyboardVisibility.isVisible) {
      //print('#### keyboard is visible!!!!');
      tagsFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    tagsFocusNode = FocusNode();
    super.dispose();
  }

/*   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    UserController.to = Provider.of<UserController>(context);
    tabsStore = Provider.of<TabsStore>(context);
    GalleryStore.to = Provider.of<GalleryStore>(context);
    // GalleryStore.to.setCurrentPic(widget.picStore);

    int height = MediaQuery.of(context).size.height * 2 ~/ 3;
    photoSize = <int>[height, height];

    //print('Did Change Dep!!!');
  } */

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //print('Pic Store Photo Id: ${picStore.photoId}');
    //print('Other info: ${picStore.photoPath}');
    // var secretBox = Hive.box('secrets');
    // Secret secret = secretBox.get(picStore.photoId);
    /* //print('In secret db: ${secret.photoId} - ${secret.photoPath}'); */

    AssetEntityImageProvider imageProvider = AssetEntityImageProvider(picStore,
        thumbSize: kDefaultPhotoSize, isOriginal: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: RepaintBoundary(
                    child: ExtendedImage(
                      key: _photoSpaceKey,
                      afterPaintImage: (canvas, rect, image, paint) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => getSizeAndPosition());
                      },
                      image: imageProvider,
                      fit: boxFit,
                      loadStateChanged: (ExtendedImageState state) {
                        Widget loader;
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            loader = const ColoredBox(color: kGreyPlaceholder);
                            break;
                          case LoadState.completed:
                            loader = FadeImageBuilder(
                              child: () {
                                return GestureDetector(
                                  onDoubleTap: () {
                                    if (boxFit == BoxFit.cover) {
                                      setState(() {
                                        boxFit = BoxFit.contain;
                                      });
                                    } else {
                                      setState(() {
                                        boxFit = BoxFit.cover;
                                      });
                                    }
                                  },
                                  child: RepaintBoundary(
                                    child: Container(
                                      color: Colors.black,
                                      constraints: BoxConstraints.expand(),
                                      child: state.completedWidget,
                                    ),
                                  ),
                                );
                              }(),
                            );
                            break;
                          case LoadState.failed:
                            loader = Container();
                            break;
                        }
                        return loader;
                      },
                    ),
                  ),
                ),
                Obx(
                  () {
                    //print('Photo Height: ${UserController.to.photoHeightInCardWidget}');
                    return CircularMenu(
                      // UserController.to: UserController.to,
                      isExpanded: UserController.to.isMenuExpanded.value,
                      useInHorizontal:
                          UserController.to.photoHeightInCardWidget < 280
                              ? true
                              : false,
                      alignment: Alignment.bottomRight,
                      radius: 52,
                      toggleButtonOnPressed: () {
                        UserController.to.switchIsMenuExpanded();
                      },
                      toggleButtonColor: Color(0xFF979A9B).withOpacity(0.5),
                      toggleButtonBoxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            spreadRadius: 3),
                      ],
                      toggleButtonIconColor: Colors.white,
                      toggleButtonMargin: 12.0,
                      toggleButtonPadding: 8.0,
                      toggleButtonSize: 19.2,
                      items: [
                        CircularMenuItem(
                          image: Image.asset('lib/images/trashmenu.png'),
                          color: kWarningColor,
                          iconSize: 19.2,
                          onTap: () {
                            GalleryStore.to.trashPic(picStore);
                          },
                        ),
                        CircularMenuItem(
                          image: picStore.isPrivate == true
                              ? Image.asset('lib/images/openlockmenu.png')
                              : Image.asset('lib/images/lockmenu.png'),
                          color: picStore.isPrivate == true
                              ? Color(0xFFF5FAFA)
                              : kYellowColor,
                          iconSize: 19.2,
                          onTap: () {
                            showDeleteSecretModal(picStore);
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
                          onTap: () {
                            GalleryStore.to
                                .setInitialSelectedThumbnail(picStore);
                            Get.toNamed(PhotoScreen.id);
                          },
                        ),
                      ],
                      backgroundWidget: Container(),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        Get.toNamed(AddLocationScreen.id);
                      },
                      child: Obx(() {
                        return RichText(
                          textScaleFactor: 1.0,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: picStore.specificLocation ??
                                    S.of(context).photo_location,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff606566),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: -0.4099999964237213,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '  ${picStore.generalLocation ?? S.of(context).country}',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff606566),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: -0.4099999964237213,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    Text(
                      dateFormat(picStore.createdAt),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff606566),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.4099999964237213,
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return TagsList(
                    tagsKeyList:
                        GalleryStore.to.tagsFromPic(picStore: picStore),
                    addTagField: true,
                    textEditingController: tagsEditingController,
                    textFocusNode: tagsFocusNode,
                    //showEditTagModal: widget.showEditTagModal,
                    shouldChangeToSwipeMode: true,
                    aiButtonTitle: 'All Tags',
                    onAiButtonTap: () {
                      Get.to(AllTagsScreen(picStore: picStore));
                      //print('ai button tapped');
                      // picStore.switchAiTags(context);
                    },
                    onTap: (String key) {
                      //print('do nothing');
                    },
                    onDoubleTap: (String value) {
                      //print('do nothing');
                    },
                    onPanEnd: (String selectedTagKey) async {
                      if (!UserController.to.canTagToday.value) {
                        showWatchAdModal(context);
                        return;
                      }

                      await GalleryStore.to.removeTagFromPic(
                          picStore: picStore, tagKey: selectedTagKey);

                      await picStore.tagsSuggestionsCalculate();
                    },
                    onChanged: (text) {
                      picStore.setSearchText(text);
                    },
                    onSubmitted: (text) async {
                      //print('return');

                      if (text != '') {
                        if (!UserController.to.canTagToday.value) {
                          tagsEditingController.clear();
                          picStore.setSearchText('');
                          showWatchAdModal(context);
                          return;
                        }

                        await GalleryStore.to.addTagToPic(
                          picStore: picStore,
                          tagName: text,
                        );

                        await picStore.tagsSuggestionsCalculate();
                        Vibrate.feedback(FeedbackType.success);
                        tagsEditingController.clear();
                        picStore.setSearchText('');
                      }
                    },
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Obx(() {
                    String suggestionsTitle;

                    if (picStore.aiTags.value) {
                      if (picStore.aiTagsLoaded == false) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).suggestions,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff979a9b),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 32.0, bottom: 32.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kSecondaryColor),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      suggestionsTitle = S.of(context).suggestions;
                    } else if (picStore.searchText != '') {
                      suggestionsTitle = S.of(context).search_results;
                    } else {
                      suggestionsTitle = S.of(context).recent_tags;
                    }

                    //print('${suggestionsTitle} : ${picStore.aiTags} : suggestionsTitle');

                    return Obx(
                      () => TagsList(
                        title: suggestionsTitle,
                        tagsKeyList:
                            /* picStore.aiTags.value
                            ? picStore.aiSuggestions.value
                            : */
                            picStore.tagsSuggestions.value.toList(),
                        tagStyle: TagStyle.GrayOutlined,
                        //showEditTagModal: widget.showEditTagModal,
                        onTap: (tagId) async {
                          if (!UserController.to.canTagToday.value) {
                            showWatchAdModal(context);
                            return;
                          }

                          await GalleryStore.to.addTagToPic(
                              picStore: picStore, tagName: tagName);
                          tagsEditingController.clear();
                          picStore.setSearchText('');
                        },
                        onDoubleTap: (tagKey) {
                          //print('do nothing');
                        },
                        onPanEnd: (tagKey) {
                          //print('do nothing');
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
