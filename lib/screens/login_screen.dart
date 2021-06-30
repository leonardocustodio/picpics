import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/login_store.dart';
import 'package:picPics/widgets/color_animated_background.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    final loginStore = LoginStore();
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            ColorAnimatedBackground(
              moveByX: 30.0,
              moveByY: 20.0,
              blurFilter: false,
            ),
            SafeArea(
              child: Obx(() {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (loginStore.slideIndex.value != 0)
                          Image.asset('lib/images/picpics_small.png'),
                        Expanded(
                          child: Swiper(
                            loop: false,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 26.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Spacer(
                                        flex: 2,
                                      ),
                                      Image.asset(
                                          'lib/images/picpics_small.png'),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Text(
                                        S.of(context).welcome,
                                        textScaleFactor: 1.0,
                                        style: kLoginDescriptionTextStyle,
                                      ),
                                      Text(
                                        S.of(context).photos_always_organized,
                                        textScaleFactor: 1.0,
                                        style: kLoginDescriptionTextStyle,
                                      ),
                                      Spacer(
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight: height / 3 - 20),
                                    child: loginStore.getImage(index),
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      bottom: 48.0,
                                    ),
                                    child: Text(
                                      loginStore.getDescription(
                                              context, index) ??
                                          '',
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: kWhiteColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: loginStore.totalSlides,
                            controller: swiperController,
                            onIndexChanged: (index) {
                              loginStore.setSlideIndex(index);
                            },
                            pagination: SwiperCustomPagination(
                              builder: (BuildContext context,
                                  SwiperPluginConfig? config) {
                                var navIndicators = <Widget>[];

                                for (var x = 0;
                                    x < loginStore.totalSlides;
                                    x++) {
                                  navIndicators.add(
                                    Container(
                                      height: 8.0,
                                      width: 8.0,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 7.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: config?.activeIndex == x
                                            ? kWhiteColor
                                            : kGrayColor,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  );
                                }

                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: navIndicators,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 64.0),
                        CupertinoButton(
                          onPressed: () {
                            if (loginStore.slideIndex.value ==
                                loginStore.totalSlides - 1) {
                              Get.to(() => PremiumScreen());
                              return;
                            }
                            //print('next');
                            swiperController.next(animation: true);
                          },
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            height: 66.0,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              loginStore.slideIndex.value ==
                                      loginStore.totalSlides - 1
                                  ? S.of(context).start.toUpperCase()
                                  : S.of(context).next.toUpperCase(),
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: kWhiteColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// appStore.setLoggedIn(true);
// Navigator.pushReplacementNamed(context, TabsScreen());
// await appStore.requestNotificationPermission();
// await appStore.checkNotificationPermission(
//     firstPermissionCheck: true);
// await appStore.setTutorialCompleted(true);
// await galleryStore.loadAssetsPath();
