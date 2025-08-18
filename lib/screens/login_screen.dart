import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/tabs_screen.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/login_store.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/color_animated_background.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    final loginStore = LoginStore();
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            const ColorAnimatedBackground(
              blurFilter: false,
            ),
            SafeArea(
              child: Obx(() {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 24),
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
                                    horizontal: 26,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Spacer(
                                        flex: 2,
                                      ),
                                      Image.asset(
                                          'lib/images/picpics_small.png',),
                                      const Spacer(
                                        
                                      ),
                                      Obx(
                                        () => Text(
                                          LangControl.to.S.value.welcome,
                                          textScaler: const TextScaler.linear(1),
                                          style: kLoginDescriptionTextStyle,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          LangControl.to.S.value
                                              .photos_always_organized,
                                          textScaler: const TextScaler.linear(1),
                                          style: kLoginDescriptionTextStyle,
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                children: <Widget>[
                                  const Spacer(
                                    
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight: height / 3 - 20,),
                                    child: loginStore.getImage(index),
                                  ),
                                  const Spacer(
                                    flex: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 48,
                                    ),
                                    child: Text(
                                      loginStore.getDescription(
                                              context, index,) ??
                                          '',
                                      textScaler: const TextScaler.linear(1),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
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
                            onIndexChanged: loginStore.setSlideIndex,
                            pagination: SwiperCustomPagination(
                              builder: (BuildContext context,
                                  SwiperPluginConfig? config,) {
                                final navIndicators = <Widget>[];

                                for (var x = 0;
                                    x < loginStore.totalSlides;
                                    x++) {
                                  navIndicators.add(
                                    Container(
                                      height: 8,
                                      width: 8,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: config?.activeIndex == x
                                            ? kWhiteColor
                                            : kGrayColor,
                                        borderRadius:
                                            BorderRadius.circular(4),
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
                        const SizedBox(height: 64),
                        CupertinoButton(
                          onPressed: () async {
                            if (loginStore.slideIndex.value ==
                                loginStore.totalSlides - 1) {
                              await UserController.to
                                  .setTutorialCompleted(true);
                              await Get.offNamedUntil<void>(
                                  TabsScreen.id, (route) => false,);
                              return;
                            }
                            AppLogger.d('next');
                            await swiperController.next();
                          },
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            height: 66,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Obx(
                              () => Text(
                                loginStore.slideIndex.value ==
                                        loginStore.totalSlides - 1
                                    ? LangControl.to.S.value.start.toUpperCase()
                                    : LangControl.to.S.value.next.toUpperCase(),
                                textScaler: const TextScaler.linear(1),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
