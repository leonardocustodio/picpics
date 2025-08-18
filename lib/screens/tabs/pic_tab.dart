import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/settings_screen.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/swiper_tab_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
// import 'package:picpics/stores/user_controller.dart'; // Unused import
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/photo_card.dart';

// ignore: must_be_immutable
class PicTab extends GetWidget<SwiperTabController> {
  PicTab({super.key});
  static const id = 'pic_tab';

  // final _ = Get.put(UserController());
  // final __ = Get.put(SwiperTabController());

  CarouselSliderController carouselController = CarouselSliderController();
  ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics();

  Widget _buildPhotoSlider(int index) {
    final picId = controller.swiperPicIdList[index];
    final picStore = TabsController.to.picStoreMap[picId]?.value ??
        TabsController.to.explorPicStore(picId).value;

    if (picStore == null) {
      if ((controller.swipeIndex.value + 1) <
          controller.swiperPicIdList.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.swipeIndex.value += 1;
        });
      }
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: PhotoCard(
        picStore: picStore,
        picsInThumbnails: PicSource.swipe,
        picsInThumbnailIndex: index,
        // showEditTagModal: (tagkey) => showEditTagModal(tagkey),
        // showDeleteSecretModal: showDeleteSecretModal,
      ),
    );
  }

/*   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<UserController>(context);
    controller = Provider.of<controller>(context);

  } */

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(),
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.1), BlendMode.dstATop,),
          image: const AssetImage('lib/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset('lib/images/picpicssmallred.png'),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      Get.to<void>(() => const SettingsScreen());
                    },
                    child: Image.asset('lib/images/settings.png'),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (!controller.isLoaded.value) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kSecondaryColor),
                    ),
                  ),
                );
              } else if (!TabsController.to.deviceHasPics) {
                return Expanded(
                  child: DeviceHasNoPics(
                    message: LangControl.to.S.value.device_has_no_pics,
                  ),
                );
              } else if (controller.swiperPicIdList.isEmpty) {
                return Expanded(
                  child: DeviceHasNoPics(
                    message: LangControl.to.S.value.no_photos_were_tagged,
                  ),
                );
              }
              return Expanded(
                child: Stack(
                  children: <Widget>[
                    Obx(() {
                      //controller.clearPicThumbnails();
                      //controller.addPicsToThumbnails(controller.swipePics);

                      return CarouselSlider.builder(
                        itemCount: controller.swiperPicIdList.length,
                        carouselController: carouselController,
                        itemBuilder: (BuildContext context, int index, int _) {
                          /* if (index < controller.swipeCutOff) {
                            return Container();
                          } */
                          AppLogger.d('calling index $index');
                          return _buildPhotoSlider(index);
                        },
                        options: CarouselOptions(
                          initialPage: controller.swipeIndex.value,
                          enableInfiniteScroll: false,
                          height: double.maxFinite,
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                          scrollPhysics: scrollPhysics,
                          onPageChanged: (index, reason) {
                            controller.setSwipeIndex(index);
                          },
                          onScrolled: (double? val) {
//                              if (controller.swipeIndex <= controller.swipeCutOff && controller.swipeIndex != 0) {
                            AppLogger.d('changing scroll physics');
//                                setState(() {
//                                  scrollPhysics = NeverScrollableScrollPhysics();
//                                });
//                              }
                            AppLogger.d('scrolled $double');
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
