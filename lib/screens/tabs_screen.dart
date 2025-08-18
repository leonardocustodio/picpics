import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/settings_screen.dart';
import 'package:picpics/screens/tabs/pic_tab.dart';
import 'package:picpics/screens/tabs/tabs_screen_bottom_navigation_bar.dart';
import 'package:picpics/screens/tabs/tagged_tab.dart';
import 'package:picpics/screens/tabs/untagged_tab.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/percentage_dialog.dart';

// ignore_for_file: unused_local_variable, must_be_immutable
class TabsScreen extends GetWidget<TabsController> {

  const TabsScreen({super.key});
  static const id = 'tabs_screen';

  //SwiperController tutorialSwiperController = SwiperController();

  //Throttle _changeThrottle;

  //AppLifecycleState _appCycleState;

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    AppLogger.d('Language Code: ${myLocale.languageCode}');

    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () => controller.shouldPopOut(),
      child: Stack(
        children: <Widget>[
          Scaffold(
            bottomNavigationBar: TabsScreenBottomNavigatioBar(),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Stack(
                children: <Widget>[
                  GetX<UserController>(builder: (userController) {
                    AppLogger.i('[TabsScreen] Building with UserController:');
                    AppLogger.d(
                        '  - hasGalleryPermission: ${userController.hasGalleryPermission.value}',);
                    AppLogger.d(
                        '  - tutorialCompleted: ${userController.tutorialCompleted.value}',);

                    /* if (true || controller.isLoading.value) {
                        return Material(
                          color: Colors.black.withValues(alpha: 0.7),
                          child: Container(
                            width: Get.width,
                            height: Get.height,
                            child: Center(
                              child: SpinKitChasingDots(
                                color: kPrimaryColor,
                                size: 80.0,
                              ),
                            ),
                          ),
                        );
                      } else  */
                    if (userController.hasGalleryPermission.value == false) {
                      AppLogger.i(
                          '[TabsScreen] Showing permission request screen',);
                      return Container(
                        constraints: const BoxConstraints.expand(),
                        color: kWhiteColor,
                        child: SafeArea(
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    CupertinoButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8,),
                                      onPressed: () {
                                        Get.to<void>(() => SettingsScreen);
                                      },
                                      child: Image.asset(
                                          'lib/images/settings.png',),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 30),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxHeight: height / 2,),
                                        child: Image.asset(
                                            'lib/images/nogalleryauth.png',),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 21,
                                    ),
                                    Obx(
                                      () => Text(
                                        LangControl.to.S.value
                                            .gallery_access_permission_description,
                                        textScaler: const TextScaler.linear(1),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xff979a9b),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        AppLogger.i(
                                            '[TabsScreen] User tapped permission button',);
                                        userController
                                            .requestGalleryPermission()
                                            .then((hasPermission) async {
                                          AppLogger.i(
                                              '[TabsScreen] Permission request result: $hasPermission',);
                                          if (hasPermission) {
                                            await userController
                                                .requestNotificationPermission();
                                            await userController
                                                .checkNotificationPermission(
                                                    firstPermissionCheck: true,);
                                            await userController
                                                .setTutorialCompleted(true);
                                            await TabsController.to
                                                .loadAssetPath();
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 201,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: kPrimaryGradient,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Obx(
                                            () => Text(
                                              LangControl.to.S.value
                                                  .gallery_access_permission,
                                              textScaler:
                                                  const TextScaler.linear(1),
                                              style: const TextStyle(
                                                fontFamily: 'Lato',
                                                color: kWhiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                letterSpacing:
                                                    -0.4099999964237213,
                                              ),
                                            ),
                                          ),
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
                    } else if (controller.currentTab.value == 0 &&
                        userController.hasGalleryPermission.value) {
                      return UntaggedTab();
                    } else if (controller.currentTab.value == 1 &&
                        userController.hasGalleryPermission.value) {
                      return PicTab();
                    } else if (controller.currentTab.value == 2 &&
                        userController.hasGalleryPermission.value) {
                      return TaggedTab();
                    } else {
                      return Container();
                    }
                  },),
                ],
              ),
            ),
          ),
          /* Obx(() => controller.modalCard.value
              ? Material(
                  color: Colors.transparent,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        controller.setModalCard(false);
                      },
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.4),
                        child: SafeArea(
                          child: CarouselSlider.builder(
                            itemCount: controller.currentTab.value == 0
                                ? GalleryStore.to.swipePics.length
                                : GalleryStore.to.thumbnailsPics.length,
                            // carouselController: carouselController,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  AppLogger.d('ignore');
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: bottomInsets > 0
                                        ? bottomInsets + 5
                                        : 32.0,
                                    top: bottomInsets > 0 ? 5 : 26.0,
                                    left: 2.0,
                                    right: 2.0,
                                  ),
                                  child: PhotoCard(
                                    picStore: controller.currentTab.value == 0
                                        ? GalleryStore.to.swipePics[index]
                                        : GalleryStore.to.thumbnailsPics[index],
                                    picsInThumbnails: PicSource.UNTAGGED,
                                    /*  showEditTagModal: () =>
                                          showEditTagModal(context),
                                      showDeleteSecretModal: showDeleteSecretModal, */
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              initialPage: controller.currentTab.value == 0
                                  ? GalleryStore.to.selectedSwipe.value
                                  : GalleryStore.to.selectedThumbnail.value,
                              enableInfiniteScroll: false,
                              height: double.maxFinite,
                              viewportFraction: 1.0,
                              enlargeCenterPage: true,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              // scrollPhysics: scrollPhysics,
                              // onPageChanged: (index, reason) {
                              //   GalleryStore.to.setSwipeIndex(index);
                              // },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()), */
          /* Obx(() => controller.isLoading.value
                ? Material(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      child: Center(
                        child: SpinKitChasingDots(
                          color: kPrimaryColor,
                          size: 80.0,
                        ),
                      ),
                    ),
                  )
                : Container()), */
          const Positioned.fill(child: PercentageDialog()),
        ],
      ),
    );
  }
}
