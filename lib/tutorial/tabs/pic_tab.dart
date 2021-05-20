/* import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/widgets/device_no_pics.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:picPics/widgets/photo_card.dart';

class TutsPicTab extends StatefulWidget {
  static const id = 'tuts_pic_tab';

  final Function showDeleteSecretModal;
  final Function showEditTagModal;

  TutsPicTab({
    @required this.showEditTagModal,
    @required this.showDeleteSecretModal,
  });

  @override
  _TutsPicTabState createState() => _TutsPicTabState();
}

class _TutsPicTabState extends State<TutsPicTab> {
  UserController appStore;
  GalleryStore galleryStore;
  CarouselController carouselController = CarouselController();
  ScrollPhysics scrollPhysics = AlwaysScrollableScrollPhysics();

  ReactionDisposer disposer;

  Widget _buildPhotoSlider(BuildContext context, int index) {
    //print('&&&&&&&& BUILD PHOTO SLIDER!!!!!');
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: PhotoCard(
        picStore: galleryStore.swipePics[index],
        picsInThumbnails: PicSource.SWIPE,
        picsInThumbnailIndex: index,
        showEditTagModal: widget.showEditTagModal,
        showDeleteSecretModal: widget.showDeleteSecretModal,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<UserController>(context);
    galleryStore = Provider.of<GalleryStore>(context);

    disposer = reaction((_) => galleryStore.trashedPic, (trashedPic) {
      if (trashedPic) {
        galleryStore.setSwipeIndex(galleryStore.swipeIndex);
        galleryStore.setTrashedPic(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0.0),
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
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
                      Get.to(() =>  SettingsScreen());
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kSecondaryColor),
                    ),
                  ),
                );
              } else if (!galleryStore.deviceHasPics) {
                return Expanded(
                  child: DeviceHasNoPics(
                    message: S.of(context).device_has_no_pics,
                  ),
                );
              } else if (galleryStore.swipePics.isEmpty) {
                return Expanded(
                  child: DeviceHasNoPics(
                    message: S.of(context).all_photos_were_tagged,
                  ),
                );
              }
              return Expanded(
                child: Stack(
                  children: <Widget>[
                    Observer(builder: (_) {
                      galleryStore.clearPicThumbnails();
                      galleryStore.addPicsToThumbnails(galleryStore.swipePics);

                      return CarouselSlider.builder(
                        itemCount: galleryStore.swipePics.length,
                        carouselController: carouselController,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < galleryStore.swipeCutOff) {
                            return Container();
                          }
                          //print('calling index $index');
                          return _buildPhotoSlider(context, index);
                        },
                        options: CarouselOptions(
                          initialPage: galleryStore.swipeIndex,
                          enableInfiniteScroll: false,
                          height: double.maxFinite,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollPhysics: scrollPhysics,
                          onPageChanged: (index, reason) {
                            galleryStore.setSwipeIndex(index);
                          },
                          onScrolled: (double) {
//                              if (galleryStore.swipeIndex <= galleryStore.swipeCutOff && galleryStore.swipeIndex != 0) {
                            //print('changing scroll physics');
//                                setState(() {
//                                  scrollPhysics = NeverScrollableScrollPhysics();
//                                });
//                              }
                            //print('scrolled $double');
                          },
                        ),
                      );
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
 */
