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
import 'package:picpics/services/navigation_service.dart';
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
                                    const Spacer(),
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
                                const Spacer(),
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight: height / 3 - 20,),
                                  child: Image.asset(
                                    loginState.screensList[index - 1]['image']!,
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        loginState.screensList[index - 1]['title']!,
                                        textScaler: const TextScaler.linear(1),
                                        style: kLoginDescriptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        loginState.screensList[index - 1]['description']!,
                                        textScaler: const TextScaler.linear(1),
                                        style: kLoginDescriptionTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                              ],
                            );
                          },
                          onIndexChanged: (index) {
                            ref.read(loginProvider.notifier).setSlideIndex(index);
                          },
                          itemCount: loginState.screensList.length + 1,
                          controller: swiperController,
                        ),
                      ),
                      _buildBottomButtons(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    final loginState = ref.watch(loginProvider);
    final s = ref.watch(sProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: loginState.slideIndex != loginState.screensList.length
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    ref.read(loginProvider.notifier).skipIntroduction();
                    _navigateToTabsScreen();
                  },
                  child: Text(
                    'Skip',
                    style: kLoginButtonTextStyle,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    swiperController.next();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      s.next,
                      style: kLoginButtonTextStyle,
                    ),
                  ),
                ),
              ],
            )
          : CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await ref.read(loginProvider.notifier).completeIntroduction();
                _navigateToTabsScreen();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s.start,
                  style: kLoginButtonTextStyle,
                ),
              ),
            ),
    );
  }

  void _navigateToTabsScreen() {
    NavigationService.offAll(const TabsScreen());
  }
}