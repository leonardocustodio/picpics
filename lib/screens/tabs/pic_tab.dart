import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/utils/show_edit_label_dialog.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:picPics/widgets/photo_card.dart';

/* class PicTab extends StatefulWidget {

  final Function showDeleteSecretModal;

  PicTab({
    @required this.showEditTagModal,
  });

  @override
  _PicTabState createState() => _PicTabState();
} */

class PicTab extends GetWidget<GalleryStore> {
  static const id = 'pic_tab';
  final Function showDeleteSecretModal;
  PicTab({@required this.showDeleteSecretModal, Key key}) : super(key: key);

  CarouselController carouselController = CarouselController();
  ScrollPhysics scrollPhysics = AlwaysScrollableScrollPhysics();

  Widget _buildPhotoSlider(int index) {
    //print('&&&&&&&& BUILD PHOTO SLIDER!!!!!');
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: PhotoCard(
        picStore: controller.swipePics.value[index],
        picsInThumbnails: PicSource.SWIPE,
        picsInThumbnailIndex: index,
        showEditTagModal: () => showEditTagModal(Get.context),
        showDeleteSecretModal: showDeleteSecretModal,
      ),
    );
  }

/*   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    controller = Provider.of<controller>(context);

  } */

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
                      Get.toNamed(SettingsScreen.id);
                    },
                    child: Image.asset('lib/images/settings.png'),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (!controller.isLoaded.value) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kSecondaryColor),
                    ),
                  ),
                );
              } else if (!controller.deviceHasPics.value) {
                return Expanded(
                  child: DeviceHasNoPics(
                    message: S.of(context).device_has_no_pics,
                  ),
                );
              } else if (controller.swipePics.isEmpty) {
                return Expanded(
                  child: DeviceHasNoPics(
                    message: S.of(context).all_photos_were_tagged,
                  ),
                );
              }
              return Expanded(
                child: Stack(
                  children: <Widget>[
                    Obx(() {
                      controller.clearPicThumbnails();
                      controller.addPicsToThumbnails(controller.swipePics);

                      return CarouselSlider.builder(
                        itemCount: controller.swipePics.length,
                        carouselController: carouselController,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < controller.swipeCutOff) {
                            return Container();
                          }
                          //print('calling index $index');
                          return _buildPhotoSlider(index);
                        },
                        options: CarouselOptions(
                          initialPage: controller.swipeIndex.value,
                          enableInfiniteScroll: false,
                          height: double.maxFinite,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollPhysics: scrollPhysics,
                          onPageChanged: (index, reason) {
                            controller.setSwipeIndex(index);
                          },
                          onScrolled: (double) {
//                              if (controller.swipeIndex <= controller.swipeCutOff && controller.swipeIndex != 0) {
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
