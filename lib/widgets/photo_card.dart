import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:picPics/admob_manager.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/add_location.dart';
import 'package:picPics/photo_screen.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/premium_screen.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:picPics/widgets/watch_ad_modal.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:picPics/components/circular_menu.dart';
import 'package:picPics/components/circular_menu_item.dart';
import 'dart:math';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

class PhotoCard extends StatefulWidget {
  final PicStore picStore;
  final Function showEditTagModal;
  final Function onPressedTrash;

  PhotoCard({
    this.picStore,
    this.showEditTagModal,
    this.onPressedTrash,
  });

  @override
  _PhotoCardState createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  GalleryStore galleryStore;
  PicStore get picStore => widget.picStore;

  TextEditingController tagsEditingController = TextEditingController();
  FocusNode tagsFocusNode;

  showWatchAdModal(BuildContext context) {
    Analytics.sendEvent(Event.watch_ads_modal);
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return WatchAdModal(
          onPressedWatchAdd: () {
            Navigator.pop(context);
            Ads.showRewarded();
          },
          onPressedGetPremium: () {
            Navigator.popAndPushNamed(context, PremiumScreen.id);
          },
        );
      },
    );
  }

  String dateFormat(DateTime dateTime) {
    var formatter = DateFormat.yMMMEd();
    return formatter.format(dateTime);
  }

  Future<List<String>> reverseGeocoding(BuildContext context, Pic picInfo) async {
    if (picStore.specificLocation != null && picStore.generalLocation != null) {
      return [picStore.specificLocation, '  ${picStore.generalLocation}'];
    }

    if ((picInfo.originalLatitude == null || picInfo.originalLongitude == null) || (picInfo.originalLatitude == 0 && picInfo.originalLongitude == 0)) {
      return [S.of(context).photo_location, '  ${S.of(context).country}'];
    }

    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(picStore.entity.latitude, picStore.entity.longitude);

    print('Placemark: ${placemark.length}');
    for (var place in placemark) {
      print('${place.name} - ${place.locality} - ${place.country}');
    }

    if (placemark.isNotEmpty) {
      print('Saving pic!!!');
      DatabaseManager.instance.saveLocationToPic(
        lat: picInfo.originalLatitude,
        long: picInfo.originalLongitude,
        specifLocation: placemark[0].locality,
        generalLocation: placemark[0].country,
        photoId: picInfo.photoId,
        notify: false,
      );
      return [placemark[0].locality, '  ${placemark[0].country}'];
    }
  }

  void focusTagsEditingController() {}

  @override
  void initState() {
    super.initState();
    tagsFocusNode = FocusNode();

    if (KeyboardVisibility.isVisible) {
      print('#### keyboard is visible!!!!');
      tagsFocusNode.requestFocus();
    }

//    KeyboardVisibility.onChange.listen((bool visible) {
//      print('Keyboard visibility update. Is visible: ${visible}');
//
//    });
  }

  @override
  void dispose() {
    tagsFocusNode = FocusNode();
    super.dispose();
  }

  void refreshTagSuggestions(Pic picInfo, {bool notify = true}) {
    print('@@@ Pic Info Tags: ${picInfo.tags}');

    DatabaseManager.instance.tagsSuggestions(
      tagsEditingController.text,
      picInfo.photoId,
      excludeTags: picInfo.tags,
      notify: notify,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    galleryStore = Provider.of<GalleryStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    Pic picInfo = DatabaseManager.instance.getPicInfo(picStore.photoId);
    print('Suggestions: ${DatabaseManager.instance.suggestionTags}');

    if (picInfo == null) {
      picInfo = Pic(
        picStore.entity.id,
        picStore.entity.createDateTime,
        picStore.entity.latitude,
        picStore.entity.longitude,
        null,
        null,
        null,
        null,
        [],
      );
    }

    if (DatabaseManager.instance.suggestionTags.length == 0) {
      print('###### calling init tag suggestions!!!!');
      refreshTagSuggestions(
        picInfo,
        notify: false,
      );
    }

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
            child: CircularMenu(
              alignment: Alignment.bottomRight,
              radius: 80,
              startingAngleInRadian: pi,
              endingAngleInRadian: pi + pi / 2,
              toggleButtonColor: Color(0xFF979A9B).withOpacity(0.5),
              toggleButtonBoxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 3),
              ],
              toggleButtonIconColor: Colors.white,
              toggleButtonMargin: 12.0,
              toggleButtonPadding: 8.0,
              toggleButtonSize: 18.0,
              items: [
                CircularMenuItem(
                    image: Image.asset('lib/images/expandnobackground.png'),
                    color: kSecondaryColor,
                    onTap: () {
                      DatabaseManager.instance.selectedPhoto = picStore.entity;
                      print('Selected photo: ${picStore.entity.id}');

                      int initialIndex = DatabaseManager.instance.slideThumbPhotoIds.indexOf(picStore.entity.id);

//                      Navigator.pushNamed(context, PhotoScreen.id);

                      galleryStore.currentPic = picStore;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoScreen(
                            initialIndex: initialIndex,
                          ),
                        ),
                      );
                    }),
                CircularMenuItem(
                    image: Image.asset('lib/images/sharenobackground.png'),
                    color: kPrimaryColor,
                    onTap: () {
                      DatabaseManager.instance.sharePic(picStore.entity);
                    }),
                CircularMenuItem(
                  image: Image.asset('lib/images/trashnobackground.png'),
                  color: kPinkColor,
                  onTap: widget.onPressedTrash,
                ),
              ],
              backgroundWidget: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: ImageItem(
                  entity: picStore.entity,
                  size: 600,
                  backgroundColor: Colors.grey[400],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () async {
                        DatabaseManager.instance.selectedPhoto = picStore.entity;
                        Navigator.pushNamed(context, AddLocationScreen.id);
                      },
                      child: FutureBuilder(
                          future: reverseGeocoding(context, picInfo),
                          initialData: [S.of(context).photo_location, '  ${S.of(context).country}'],
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return RichText(
                                textScaleFactor: 1.0,
                                text: new TextSpan(
                                  children: [
                                    TextSpan(
                                      text: snapshot.data[0],
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
                                      text: '  ${snapshot.data[1]}',
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
                            } else if (snapshot.hasError) {
                              return RichText(
                                textScaleFactor: 1.0,
                                text: new TextSpan(
                                  children: [
                                    TextSpan(
                                      text: S.of(context).photo_location,
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
                                      text: '  ${S.of(context).country}',
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
                            } else {
                              return Row(
                                children: <Widget>[
                                  RichText(
                                    textScaleFactor: 1.0,
                                    text: new TextSpan(
                                      children: [
                                        TextSpan(
                                          text: snapshot.data[0],
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
                                          text: '  ${snapshot.data[1]}',
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
                                  ),
                                ],
                              );
                            }
                          }),
                    ),
                    Text(
                      dateFormat(picStore.entity.createDateTime),
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
                Observer(builder: (_) {
                  return TagsList(
                    tagsKeys: picStore.tagsKeys,
                    addTagField: true,
                    textEditingController: tagsEditingController,
                    textFocusNode: tagsFocusNode,
                    showEditTagModal: widget.showEditTagModal,
                    shouldChangeToSwipeMode: true,
                    onTap: (tagName) {
                      print('do nothing');
                    },
                    onDoubleTap: () {
                      print('do nothing');
                    },
                    onPanUpdate: () {
                      if (!DatabaseManager.instance.canTagToday()) {
                        showWatchAdModal(context);
                        return;
                      }

                      DatabaseManager.instance.removeTagFromPic(
                        tagKey: DatabaseManager.instance.selectedTagKey,
                        photoId: picInfo.photoId,
                      );

                      refreshTagSuggestions(picInfo);
                    },
                    onChanged: (text) {
                      refreshTagSuggestions(picInfo);
                    },
                    onSubmitted: (text) async {
                      print('return');

                      if (text != '') {
                        if (!DatabaseManager.instance.canTagToday()) {
                          tagsEditingController.clear();
                          refreshTagSuggestions(picInfo);
                          showWatchAdModal(context);
                          return;
                        }

                        DatabaseManager.instance.selectedPhoto = picStore.entity;
                        await picStore.addTag(
                          tagName: text,
                          photoId: picStore.entity.id,
                        );
                        Vibrate.feedback(FeedbackType.success);
                        tagsEditingController.clear();

                        Pic updatedPicInfo = DatabaseManager.instance.getPicInfo(picStore.photoId);
                        print('Updated picinfo - tags length: ${updatedPicInfo.tags.length}');
                        refreshTagSuggestions(updatedPicInfo);
                      }
                    },
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TagsList(
                    title: S.of(context).suggestions,
                    tagsKeys: DatabaseManager.instance.suggestionTags,
                    tagStyle: TagStyle.GrayOutlined,
                    showEditTagModal: widget.showEditTagModal,
                    onTap: (tagName) async {
                      if (!DatabaseManager.instance.canTagToday()) {
                        showWatchAdModal(context);
                        return;
                      }

                      DatabaseManager.instance.selectedPhoto = picStore.entity;
                      await picStore.addTag(
                        tagName: tagName,
                        photoId: picInfo.photoId,
                      );
                      tagsEditingController.clear();

                      Pic updatedPicInfo = DatabaseManager.instance.getPicInfo(picStore.photoId);
                      print('Updated picinfo - tags length: ${updatedPicInfo.tags.length}');
                      refreshTagSuggestions(updatedPicInfo);
                    },
                    onDoubleTap: () {
                      print('do nothing');
                    },
                    onPanUpdate: () {
                      print('do nothing');
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
