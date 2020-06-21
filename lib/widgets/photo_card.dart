import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/add_location.dart';
import 'package:picPics/photo_screen.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/premium_screen.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/widgets/watch_ad_modal.dart';

class PhotoCard extends StatelessWidget {
  final AssetEntity data;
  final int index;
  final String photoId;
  final int picSwiper;
  final String specificLocation;
  final String generalLocation;
  final TextEditingController tagsEditingController;
  final Function showEditTagModal;
  final Function onPressedTrash;

  PhotoCard({
    this.data,
    this.index,
    this.photoId,
    this.picSwiper,
    this.specificLocation,
    this.generalLocation,
    this.tagsEditingController,
    this.showEditTagModal,
    this.onPressedTrash,
  });

  showWatchAdModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return WatchAdModal(
          onPressedWatchAdd: () {
            Navigator.pop(context);
            RewardedVideoAd.instance.show();
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
    if (specificLocation != null && generalLocation != null) {
      return [specificLocation, '  $generalLocation'];
    }

    if ((picInfo.originalLatitude == null || picInfo.originalLongitude == null) ||
        (picInfo.originalLatitude == 0 && picInfo.originalLongitude == 0)) {
      return [S.of(context).photo_location, '  ${S.of(context).country}'];
    }

    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(data.latitude, data.longitude);

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

  @override
  Widget build(BuildContext context) {
    Pic picInfo = DatabaseManager.instance.getPicInfo(photoId);

    if (picInfo == null) {
      picInfo = Pic(
        data.id,
        data.createDateTime,
        data.latitude,
        data.longitude,
        null,
        null,
        null,
        null,
        [],
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
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: ImageItem(
                    entity: data,
                    size: 600,
                    backgroundColor: Colors.grey[400],
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 6.0,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                    onPressed: onPressedTrash,
                    child: Image.asset('lib/images/pictrashicon.png'),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 6.0,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                    onPressed: () {
                      DatabaseManager.instance.selectedPhoto = data;
                      print('Selected photo: ${data.id}');

                      int initialIndex = DatabaseManager.instance.slideThumbPhotoIds.indexOf(data.id);

//                      Navigator.pushNamed(context, PhotoScreen.id);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoScreen(
                            initialIndex: initialIndex,
                          ),
                        ),
                      );
                    },
                    child: Image.asset('lib/images/expandphotoico.png'),
                  ),
                ),
              ],
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
                      onPressed: () {
                        DatabaseManager.instance.selectedPhoto = data;
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
//                                  CircularProgressIndicator(),
                                ],
                              );
                            }
                          }),
                    ),
                    Text(
                      dateFormat(data.createDateTime),
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
                TagsList(
                  tagsKeys: picInfo.tags,
                  addTagField: true,
                  textEditingController: tagsEditingController,
                  showEditTagModal: showEditTagModal,
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
                  },
                  onChanged: (text) {
                    print('photo Index: $index - photo Swipe : $picSwiper');
                    if (index == picSwiper || picSwiper == -1) {
                      print('calling tag suggestions');
                      DatabaseManager.instance.tagsSuggestions(
                        text,
                        picInfo.photoId,
                        excludeTags: picInfo.tags,
                      );
                    } else {
                      print('skipping');
                    }
                  },
                  onSubmitted: (text) {
                    print('return');
                    if (text != '') {
                      if (!DatabaseManager.instance.canTagToday()) {
                        tagsEditingController.clear();
                        DatabaseManager.instance.tagsSuggestions(
                          '',
                          data.id,
                          excludeTags: picInfo.tags,
                        );
                        showWatchAdModal(context);
                        return;
                      }

                      print('text: $text - data.id: ${data.id} - index: $index - picSwiper: $picSwiper');
                      AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
                      DatabaseManager.instance.selectedPhoto = pathProvider.orderedList[index];
                      DatabaseManager.instance.addTag(
                        tagName: text,
                        photoId: data.id,
                      );
                      tagsEditingController.clear();

                      if (picSwiper != -1) {
                        // Refatorar essa gambi dps
                        var indexPicBefore = picSwiper - 1;
                        var indexPicAfter = picSwiper + 1;

                        AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
                        if (indexPicBefore < 0) {
                          indexPicBefore = pathProvider.orderedList.length - 1;
                        }
                        if (indexPicAfter == pathProvider.orderedList.length) {
                          indexPicAfter = 0;
                        }

                        Pic picBefore = DatabaseManager.instance.getPicInfo(pathProvider.orderedList[indexPicBefore].id);
                        Pic picAfter = DatabaseManager.instance.getPicInfo(pathProvider.orderedList[indexPicAfter].id);

                        DatabaseManager.instance.tagsSuggestions(
                          '',
                          picBefore.photoId,
                          excludeTags: picBefore.tags,
                        );
                        DatabaseManager.instance.tagsSuggestions(
                          '',
                          picAfter.photoId,
                          excludeTags: picAfter.tags,
                        );
                        ////////////////////////
                      } else {
                        DatabaseManager.instance.tagsSuggestions(
                          '',
                          data.id,
                          excludeTags: picInfo.tags,
                        );
                      }
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TagsList(
                    title: S.of(context).suggestions,
                    tagsKeys: DatabaseManager.instance.suggestionTags[picInfo.photoId],
                    tagStyle: TagStyle.GrayOutlined,
                    showEditTagModal: showEditTagModal,
                    onTap: (tagName) {
                      if (!DatabaseManager.instance.canTagToday()) {
                        showWatchAdModal(context);
                        return;
                      }

                      AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
                      DatabaseManager.instance.selectedPhoto = pathProvider.orderedList[index];
                      DatabaseManager.instance.addTag(
                        tagName: tagName,
                        photoId: picInfo.photoId,
                      );
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
