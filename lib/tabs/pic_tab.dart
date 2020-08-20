import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/settings_screen.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:provider/provider.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/widgets/photo_card.dart';
import 'package:flare_flutter/flare_actor.dart';

class PicTab extends StatefulWidget {
  static const id = 'pic_tab';

  final Function showEditTagModal;
  final Function trashPic;

  PicTab({
    @required this.showEditTagModal,
    @required this.trashPic,
  });

  @override
  _PicTabState createState() => _PicTabState();
}

class _PicTabState extends State<PicTab> {
  GalleryStore galleryStore;

  CarouselController carouselController = CarouselController();
//  int picSwiper = 0;

//  TextEditingController tagsEditingController = TextEditingController();

  Widget _buildPhotoSlider(BuildContext context, int index) {
    print('photo slides index: $index');
    var data = galleryStore.pics[index].entity;

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

//    print('using picSwiper id: $picSwiper');
//

    DatabaseManager.instance.suggestionTags = [];

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: PhotoCard(
        picStore: galleryStore.pics[index],
        showEditTagModal: widget.showEditTagModal,
        onPressedTrash: () {
          widget.trashPic(data);
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    galleryStore = Provider.of<GalleryStore>(context);
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
//            if (Provider.of<DatabaseManager>(context).sliderIndex == null && galleryStore.deviceHasPics)
//              Expanded(
//                child: Center(
//                  child: CircularProgressIndicator(
//                    valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
//                  ),
//                ),
//              ),
//            if (Provider.of<DatabaseManager>(context).sliderIndex == null && !galleryStore.deviceHasPics)
//              Expanded(
//                child: DeviceHasNoPics(),
//              ),
//            if (Provider.of<DatabaseManager>(context).sliderIndex != null)
            Expanded(
              child: Stack(
                children: <Widget>[
                  CarouselSlider.builder(
                    itemCount: galleryStore.pics.length,
                    carouselController: carouselController,
                    itemBuilder: (BuildContext context, int index) {
                      print('calling index $index');
                      return _buildPhotoSlider(context, index);
                    },
                    options: CarouselOptions(
                      initialPage: DatabaseManager.instance.swiperIndex,
                      enableInfiniteScroll: true,
                      height: double.maxFinite,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) async {
                        if (!DatabaseManager.instance.userSettings.hasSwiped) {
                          DatabaseManager.instance.setUserHasSwiped();
                        }
                        Analytics.sendEvent(Event.swiped_photo);
                        print('### Swiper Index: $index');
                      },
                    ),
                  ),
                  if (!Provider.of<DatabaseManager>(context).userSettings.hasSwiped)
                    IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: FlareActor(
                          'lib/anims/swipe_left.flr',
                          alignment: Alignment.topCenter,
                          fit: BoxFit.contain,
                          animation: 'Animations',
//                            color: kWhiteColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
