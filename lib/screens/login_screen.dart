import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/login_store.dart';
import 'package:picPics/widgets/color_animated_background.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppStore appStore;
  SwiperController tutorialSwiperController = SwiperController();

  @override
  void initState() {
    super.initState();
    Analytics.sendCurrentScreen(Screen.login_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    appStore.createDefaultTags(context);
  }

  @override
  Widget build(BuildContext context) {
    final LoginStore loginStore = LoginStore();
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
              child: Observer(builder: (_) {
                if (appStore.tutorialCompleted != true) {
                  // Analytics.sendTutorialBegin();

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset('lib/images/picpics_small.png'),
                          Expanded(
                            child: new Swiper(
                              loop: false,
                              itemBuilder: (BuildContext context, int index) {
                                String text = '';
                                Image image;

                                if (index == 0) {
                                  text =
                                      S.of(context).tutorial_however_you_want;
                                  image = Image.asset(
                                      'lib/images/onboardtagging.png');
                                } else if (index == 1) {
                                  text = S.of(context).tutorial_just_swipe;
                                  image = Image.asset(
                                      'lib/images/onboardswipe.png');
                                } else if (index == 2) {
                                  text = S.of(context).tutorial_secret;
                                  image = Image.asset(
                                      'lib/images/onboardsecret.png');
                                } else {
                                  text = S.of(context).tutorial_multiselect;
                                  image = Image.asset(
                                      'lib/images/onboardmultiselect.png');
                                }

                                return Column(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxHeight: height / 2 - 20),
                                      child: image,
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
                                        text,
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
                              itemCount: 4,
                              controller: tutorialSwiperController,
                              onIndexChanged: (index) {
                                // tabsStore.setTutorialIndex(index);
                              },
                              pagination: new SwiperCustomPagination(
                                builder: (BuildContext context,
                                    SwiperPluginConfig config) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 0
                                                ? kWhiteColor
                                                : kGrayColor,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          margin: const EdgeInsets.only(
                                              left: 24.0, right: 12.0),
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 1
                                                ? kWhiteColor
                                                : kGrayColor,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          margin: const EdgeInsets.only(
                                              left: 12.0, right: 24.0),
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 2
                                                ? kWhiteColor
                                                : kGrayColor,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Container(
                                          height: 8.0,
                                          width: 8.0,
                                          decoration: BoxDecoration(
                                            color: config.activeIndex == 3
                                                ? kWhiteColor
                                                : kGrayColor,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 64.0,
                          ),
                          CupertinoButton(
                            onPressed: () async {
                              if (loginStore.slideIndex == 3) {
                                print('Requesting notification....');

                                await appStore.requestNotificationPermission();
                                await appStore.checkNotificationPermission(
                                    firstPermissionCheck: true);
                                await appStore.setTutorialCompleted(true);
                                // await galleryStore.loadAssetsPath();
                                return;
                              }
                              tutorialSwiperController.next(animation: true);
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
                              child: Center(
                                child: Text(
                                  loginStore.slideIndex == 3
                                      ? S.of(context).start.toUpperCase()
                                      : S.of(context).next.toUpperCase(),
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: kWhiteColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Spacer(
// flex: 2,
// ),
// Image.asset('lib/images/picpics_small.png'),
// Spacer(
// flex: 1,
// ),
// Text(
// S.of(context).welcome,
// textScaleFactor: 1.0,
// style: kLoginDescriptionTextStyle,
// ),
// Text(
// S.of(context).photos_always_organized,
// textScaleFactor: 1.0,
// style: kLoginDescriptionTextStyle,
// ),
// Spacer(
// flex: 2,
// ),
// CupertinoButton(
// padding: const EdgeInsets.all(0),
// onPressed: () async {
// appStore.setLoggedIn(true);
// Navigator.pushReplacementNamed(context, TabsScreen.id);
// },
// child: Container(
// height: 44.0,
// decoration: BoxDecoration(
// gradient: kPrimaryGradient,
// borderRadius: BorderRadius.circular(8.0),
// ),
// child: Center(
// child: Text(
// S.of(context).continue_string,
// textScaleFactor: 1.0,
// style: kLoginButtonTextStyle,
// ),
// ),
// ),
// ),
// SizedBox(
// height: 40.0,
// ),
// ],
// )
