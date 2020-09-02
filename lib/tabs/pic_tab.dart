import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/settings_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:picPics/widgets/photo_card.dart';
import 'package:flare_flutter/flare_actor.dart';

class PicTab extends StatefulWidget {
  static const id = 'pic_tab';

  final Function showEditTagModal;

  PicTab({
    @required this.showEditTagModal,
  });

  @override
  _PicTabState createState() => _PicTabState();
}

class _PicTabState extends State<PicTab> {
  AppStore appStore;
  GalleryStore galleryStore;
  CarouselController carouselController = CarouselController();

  Widget _buildPhotoSlider(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: PhotoCard(
        picStore: galleryStore.swipePics[index],
        picsInThumbnails: PicsInThumbnails.SWIPE,
        picsInThumbnailIndex: index,
        showEditTagModal: widget.showEditTagModal,
      ),
    );
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
            Observer(builder: (_) {
              if (!galleryStore.isLoaded) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                    ),
                  ),
                );
              } else if (!galleryStore.deviceHasPics) {
                return Expanded(
                  child: DeviceHasNoPics(),
                );
              }
              return Expanded(
                child: Stack(
                  children: <Widget>[
                    Observer(builder: (_) {
                      return CarouselSlider.builder(
                        itemCount: galleryStore.swipePics.length,
                        carouselController: carouselController,
                        itemBuilder: (BuildContext context, int index) {
                          print('calling index $index');
                          return _buildPhotoSlider(context, index);
                        },
                        options: CarouselOptions(
                          initialPage: galleryStore.swipeIndex,
                          enableInfiniteScroll: true,
                          height: double.maxFinite,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) async {
                            if (!appStore.hasSwiped) {
                              appStore.setHasSwiped(true);
                            }
                            galleryStore.setSwipeIndex(index);
                            Analytics.sendEvent(Event.swiped_photo);
                            print('### Swiper Index: $index');
                          },
                        ),
                      );
                    }),
                    Observer(builder: (_) {
                      if (!appStore.hasSwiped) {
                        return IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.only(top: 150.0),
                            child: FlareActor(
                              'lib/anims/swipe_left.flr',
                              alignment: Alignment.topCenter,
                              fit: BoxFit.contain,
                              animation: 'Animations',
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
