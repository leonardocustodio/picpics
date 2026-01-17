import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart' as language;
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/settings_screen.dart';
import 'package:picpics/screens/tabs/pic_tab.dart';
import 'package:picpics/screens/tabs/tabs_screen_bottom_navigation_bar_riverpod.dart';
import 'package:picpics/screens/tabs/tagged_tab.dart';
import 'package:picpics/screens/tabs/untagged_tab.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/percentage_dialog.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  static const id = 'tabs_screen';

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  @override
  void initState() {
    super.initState();
    // Load assets when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTabsScreen();
    });
  }

  Future<void> _initializeTabsScreen() async {
    // Initialize tabs and load assets
    await ref.read(tabsProvider.notifier).loadAssetPath();
  }

  Future<bool> _shouldPopOut() async {
    final tabsState = ref.read(tabsProvider);
    if (tabsState.currentIndex != 1) {
      ref.read(tabsProvider.notifier).setCurrentTab(1);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(tabsProvider);
    final userState = ref.watch(userProvider);
    final s = ref.watch(sProvider);

    final height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final shouldPop = await _shouldPopOut();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            bottomNavigationBar: const TabsScreenBottomNavigatioBar(),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Stack(
                children: <Widget>[
                  _buildMainContent(
                    context,
                    userState,
                    tabsState,
                    s,
                    height,
                  ),
                ],
              ),
            ),
          ),
          const Positioned.fill(child: PercentageDialog()),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    UserState userState,
    TabsState tabsState,
    language.S s,
    double height,
  ) {
    // Removed verbose build logs to prevent log spam

    if (!userState.hasGalleryPermission) {
      AppLogger.i('[TabsScreen] Showing permission request screen');
      return _buildPermissionRequestScreen(context, s, height);
    }

    // Show the appropriate tab based on current index
    switch (tabsState.currentIndex) {
      case 0:
        return UntaggedTab();
      case 1:
        return PicTab();
      case 2:
        return TaggedTab();
      default:
        return Container();
    }
  }

  Widget _buildPermissionRequestScreen(
    BuildContext context,
    language.S s,
    double height,
  ) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: kWhiteColor,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Image.asset('lib/images/settings.png'),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: height / 2),
                      child: Image.asset('lib/images/nogalleryauth.png'),
                    ),
                  ),
                  const SizedBox(height: 21),
                  Text(
                    s.gallery_access_permission_description,
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
                  const SizedBox(height: 17),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      AppLogger.i('[TabsScreen] User tapped permission button');
                      await ref.read(userProvider.notifier).requestGalleryPermission();

                      AppLogger.i('[TabsScreen] Permission request completed');

                      // Check if permission was granted by reading the updated state
                      final hasPermission = ref.read(userProvider).hasGalleryPermission;

                      if (hasPermission) {
                        // Request notification permission
                        await ref.read(userProvider.notifier).requestNotificationPermission();

                        // Check notification permission
                        await ref.read(userProvider.notifier).checkNotificationPermission(firstPermissionCheck: true);

                        // Mark tutorial as completed
                        await ref.read(userProvider.notifier).setTutorialCompleted(true);

                        // Load assets after permission is granted
                        await ref.read(tabsProvider.notifier).loadAssetPath();
                      }
                    },
                    child: Container(
                      width: 201,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          s.gallery_access_permission,
                          textScaler: const TextScaler.linear(1),
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: kWhiteColor,
                            fontSize: 16,
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
          ],
        ),
      ),
    );
  }
}
