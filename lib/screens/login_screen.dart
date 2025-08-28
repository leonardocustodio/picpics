import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/login_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/tabs_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/color_animated_background.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const id = 'login_screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  SwiperController swiperController = SwiperController();

  @override
  void initState() {
    super.initState();
    // Initialize login screens on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginProvider.notifier).initializeScreens();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final s = ref.watch(sProvider);
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
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (loginState.slideIndex != 0)
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
                                      Text(
                                        s.welcome,
                                        textScaler: const TextScaler.linear(1),
                                        style: kLoginDescriptionTextStyle,
                                      ),
                                      Text(
                                        s.photos_always_organized,
                                        textScaler: const TextScaler.linear(1),
                                        style: kLoginDescriptionTextStyle,
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
                                    child: loginState.getImage(index - 1) ?? const SizedBox(),
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
                                      loginState.getDescription(index - 1) ??
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
                            itemCount: loginState.totalSlides,
                            controller: swiperController,
                            onIndexChanged: (index) {
                              ref.read(loginProvider.notifier).setSlideIndex(index);
                            },
                            pagination: SwiperCustomPagination(
                              builder: (BuildContext context,
                                  SwiperPluginConfig? config,) {
                                final navIndicators = <Widget>[];

                                for (var x = 0;
                                    x < loginState.totalSlides;
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
                            if (loginState.slideIndex ==
                                loginState.totalSlides - 1) {
                              await ref.read(loginProvider.notifier).completeIntroduction();
                              ref.read(userProvider.notifier).setTutorialCompleted(true);
                              if (mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  TabsScreen.id,
                                  (route) => false,
                                );
                              }
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
                            child: Text(
                              loginState.slideIndex ==
                                      loginState.totalSlides - 1
                                  ? s.start.toUpperCase()
                                  : s.next.toUpperCase(),
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
                      ],
                    ),
                  ),
                ),
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
