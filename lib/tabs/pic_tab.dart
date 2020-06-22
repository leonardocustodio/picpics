import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/widgets/photo_card.dart';
import 'package:picPics/widgets/edit_tag_modal.dart';
import 'package:photo_manager/photo_manager.dart';

class PicTab extends StatefulWidget {
  static const id = 'pic_tab';

  final bool deviceHasNoPics;

  PicTab({
    this.deviceHasNoPics = false,
  });

  @override
  _PicTabState createState() => _PicTabState();
}

class _PicTabState extends State<PicTab> {
  bool modalPhotoCard = false; // Mudar essa variavel pq não serve para nada!!!
  AssetEntity selectedPhotoData;
  Pic selectedPhotoPicInfo;
  int selectedPhotoIndex;
  // msm coisa variaveis acima

  CarouselController carouselController = CarouselController();
  int picSwiper = 0;

  TextEditingController tagsEditingController = TextEditingController();

  Widget _buildPhotoSlider(BuildContext context, int index) {
    print('photo slides index: $index');
    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];

    int orderedIndex = DatabaseManager.instance.sliderIndex[index];
    print('Slider index in index $index: $orderedIndex');
    var data = pathProvider.orderedList[orderedIndex];

    Pic picInfo = DatabaseManager.instance.getPicInfo(data.id);

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

    print('photo id: ${data.id}');
    double latitude = data.latitude;
    double longitude = data.longitude;

    print('lat: $latitude - long: $longitude');

//    if (latitude == 0.0 && longitude == 0.0) {
//      DatabaseManager.instance.currentPhotoCity = 'Local da foto';
//      DatabaseManager.instance.currentPhotoState = ' estado';
//    } else if (DatabaseManager.instance.lastLocationRequest[0] == latitude &&
//        DatabaseManager.instance.lastLocationRequest[1] == longitude) {
//      print('skipping location request');
//    } else {
//      DatabaseManager.instance.findLocation(latitude, longitude);
//    }

//    if (suggestions == null) {
//      suggestions = DatabaseManager.instance.tagsSuggestions(
//        '',
//        picInfo.photoId,
//        excludeTags: picInfo.tags,
//      );
//    }

    print('using picSwiper id: $picSwiper');

    DatabaseManager.instance.tagsSuggestions(
      tagsEditingController.text,
      picInfo.photoId,
      excludeTags: picInfo.tags,
      notify: false,
    );

    return PhotoCard(
      data: data,
      photoId: picInfo.photoId,
      picSwiper: picSwiper,
      index: index,
      tagsEditingController: tagsEditingController,
      specificLocation: picInfo.specificLocation,
      generalLocation: picInfo.generalLocation,
      showEditTagModal: showEditTagModal,
      onPressedTrash: () {
        trashPic(data);
      },
    );
  }

  void trashPic(AssetEntity entity) async {
    print('trashing pic');
    final List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
    if (result.isNotEmpty) {
      DatabaseManager.instance.deletedPic(entity);
      if (modalPhotoCard) {
        setState(() {
          selectedPhotoPicInfo = null;
          selectedPhotoIndex = null;
          selectedPhotoData = null;
          modalPhotoCard = false;
        });
      }
    }
  }

  showEditTagModal() {
    if (DatabaseManager.instance.selectedTagKey != '') {
      TextEditingController alertInputController = TextEditingController();
      Pic getPic = DatabaseManager.instance.getPicInfo(DatabaseManager.instance.selectedPhoto.id);
      String tagName = DatabaseManager.instance.getTagName(DatabaseManager.instance.selectedTagKey);
      alertInputController.text = tagName;

      print('showModal');
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return EditTagModal(
            alertInputController: alertInputController,
            onPressedDelete: () {
              DatabaseManager.instance.deleteTag(tagKey: DatabaseManager.instance.selectedTagKey);
              DatabaseManager.instance.tagsSuggestions(
                tagsEditingController.text,
                DatabaseManager.instance.selectedPhoto.id,
                excludeTags: getPic.tags,
                notify: false,
              );
              Navigator.of(context).pop();
            },
            onPressedOk: () {
              print('Editing tag - Old name: ${DatabaseManager.instance.selectedTagKey} - New name: ${alertInputController.text}');
              if (tagName != alertInputController.text) {
                DatabaseManager.instance.editTag(
                  oldTagKey: DatabaseManager.instance.selectedTagKey,
                  newName: alertInputController.text,
                );
              }
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0.0),
      constraints: BoxConstraints.expand(),
      decoration: new BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('lib/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset('lib/images/picpicssmallred.png'),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    onPressed: () {
                      Navigator.pushNamed(context, SettingsScreen.id);
                    },
                    child: Image.asset('lib/images/settings.png'),
                  ),
                ],
              ),
            ),
            if (Provider.of<DatabaseManager>(context).sliderIndex == null && !widget.deviceHasNoPics)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                  ),
                ),
              ),
            if (Provider.of<DatabaseManager>(context).sliderIndex == null && widget.deviceHasNoPics)
              Expanded(
                child: DeviceHasNoPics(),
              ),
            if (Provider.of<DatabaseManager>(context).sliderIndex != null)
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: Provider.of<DatabaseManager>(context).sliderIndex.length,
                  carouselController: carouselController,
                  itemBuilder: (BuildContext context, int index) {
                    print('calling index $index');
                    return _buildPhotoSlider(context, index);
                  },
                  options: CarouselOptions(
                    initialPage: DatabaseManager.instance.swiperIndex,
                    enableInfiniteScroll: true,
                    height: double.maxFinite,
                    viewportFraction: 0.95,
                    enlargeCenterPage: false,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) async {
                      DatabaseManager.instance.swiperIndex = index;
                      picSwiper = index;
                      print('picSwiper = $index');
                    },
                  ),
                ),
//                            Swiper(
//                              controller: swiperController,
//                              loop: true,
//                              index: DatabaseManager.instance.swiperIndex(),
//                              itemCount: pathProvider.orderedList.length, // count == 0 ? 1 : count,
//                              onIndexChanged: (index) async {
//                                DatabaseManager.instance.setSwiperIndex(index);
//                                picSwiper = index;
//                                print('picSwiper = $index');
//                                bool shouldShowAds = await DatabaseManager.instance.increaseTodayTaggedPics();
//                                if (shouldShowAds) {
//                                  showWatchAdModal(context);
//                                }
//                              },
//                              itemBuilder: (BuildContext context, int index) {
//                                print('calling index $index');
//                                return _buildPhotoSlider(context, index);
//                              },
//                              layout: SwiperLayout.DEFAULT,
//                              itemWidth: screenWidth,
//                              customLayoutOption:
//                                  CustomLayoutOption(startIndex: -1, stateCount: 3).addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate(
//                                [
//                                  Offset(-screenWidth - screenWidth / 2, -40.0),
//                                  Offset(0.0, 0.0),
//                                  Offset(screenWidth + screenWidth / 2, -40.0),
//                                ],
//                              ),
//                            ),
              ),
          ],
        ),
      ),
    );
  }
}
