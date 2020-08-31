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
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/widgets/tags_list.dart';
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

  PhotoCard({
    this.picStore,
    this.showEditTagModal,
  });

  @override
  _PhotoCardState createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  AppStore appStore;
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

  Future<List<String>> reverseGeocoding(BuildContext context) async {
    if (picStore.specificLocation != null && picStore.generalLocation != null) {
      return [picStore.specificLocation, '  ${picStore.generalLocation}'];
    }

    if ((picStore.originalLatitude == null || picStore.originalLongitude == null) || (picStore.originalLatitude == 0 && picStore.originalLongitude == 0)) {
      return [S.of(context).photo_location, '  ${S.of(context).country}'];
    }

    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(picStore.entity.latitude, picStore.entity.longitude);

    print('Placemark: ${placemark.length}');
    for (var place in placemark) {
      print('${place.name} - ${place.locality} - ${place.country}');
    }

    if (placemark.isNotEmpty) {
      print('Saving pic!!!');
      picStore.saveLocation(
        lat: picStore.originalLatitude,
        long: picStore.originalLongitude,
        specific: placemark[0].locality,
        general: placemark[0].country,
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
  }

  @override
  void dispose() {
    tagsFocusNode = FocusNode();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);
  }

  @override
  Widget build(BuildContext context) {
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
                      galleryStore.setCurrentPic(picStore);
                      int initialIndex = DatabaseManager.instance.slideThumbPhotoIds.indexOf(picStore.entity.id);
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
                      picStore.sharePic();
                    }),
                CircularMenuItem(
                  image: Image.asset('lib/images/trashnobackground.png'),
                  color: kPinkColor,
                  onTap: () {
                    galleryStore.trashPic(picStore);
                  },
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
                        galleryStore.setCurrentPic(picStore);
                        Navigator.pushNamed(context, AddLocationScreen.id);
                      },
                      child: Observer(builder: (_) {
                        return RichText(
                          textScaleFactor: 1.0,
                          text: new TextSpan(
                            children: [
                              TextSpan(
                                text: picStore.specificLocation ?? S.of(context).photo_location,
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
                                text: '  ${picStore.generalLocation ?? S.of(context).country}',
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
                    onPanEnd: () {
                      if (!appStore.canTagToday) {
                        showWatchAdModal(context);
                        return;
                      }
                      picStore.removeTagFromPic(tagKey: DatabaseManager.instance.selectedTagKey);
                    },
                    onChanged: (text) {
                      picStore.setSearchText(text);
                    },
                    onSubmitted: (text) async {
                      print('return');

                      if (text != '') {
                        if (!appStore.canTagToday) {
                          tagsEditingController.clear();
                          picStore.setSearchText('');
                          showWatchAdModal(context);
                          return;
                        }

                        await picStore.addTag(
                          tagName: text,
                        );
                        Vibrate.feedback(FeedbackType.success);
                        tagsEditingController.clear();
                        picStore.setSearchText('');
                      }
                    },
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Observer(builder: (_) {
                    return TagsList(
                      title: S.of(context).suggestions,
                      tagsKeys: picStore.tagsSuggestions,
                      tagStyle: TagStyle.GrayOutlined,
                      showEditTagModal: widget.showEditTagModal,
                      onTap: (tagName) async {
                        if (!appStore.canTagToday) {
                          showWatchAdModal(context);
                          return;
                        }

                        await picStore.addTag(
                          tagName: tagName,
                        );
                        tagsEditingController.clear();
                        picStore.setSearchText('');
                      },
                      onDoubleTap: () {
                        print('do nothing');
                      },
                      onPanEnd: () {
                        print('do nothing');
                      },
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
