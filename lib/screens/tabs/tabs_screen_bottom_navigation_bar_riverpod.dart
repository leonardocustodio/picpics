import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart' as language;
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/utils/functions.dart';

class TabsScreenBottomNavigatioBar extends ConsumerStatefulWidget {
  const TabsScreenBottomNavigatioBar({super.key});

  @override
  ConsumerState<TabsScreenBottomNavigatioBar> createState() => _TabsScreenBottomNavigatioBarState();
}

class _TabsScreenBottomNavigatioBarState extends ConsumerState<TabsScreenBottomNavigatioBar> {
  final TextEditingController tagsEditingController = TextEditingController();
  final TextEditingController bottomTagsEditingController = TextEditingController();
  late ExpandableController expandableController;

  @override
  void initState() {
    super.initState();
    expandableController = ExpandableController(initialExpanded: false);
  }

  @override
  void dispose() {
    tagsEditingController.dispose();
    bottomTagsEditingController.dispose();
    expandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(tabsProvider);
    final tagsState = ref.watch(tagsProvider);
    final s = ref.watch(sProvider);

    if (tabsState.multiTagSheet) {
      return _buildMultiTagSheet(context, tabsState, tagsState, s);
    } else if (tabsState.multiPicBar) {
      return _buildMultiPicBar(context, tabsState, s);
    } else {
      return _buildNormalBottomBar(context, tabsState, s);
    }
  }

  Widget _buildMultiTagSheet(
    BuildContext context,
    TabsState tabsState,
    TagsState tagsState,
    language.S s,
  ) {
    return ExpandableNotifier(
      controller: expandableController,
      child: ColoredBox(
        color: const Color(0x00f1f3f5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                expandableController.expanded = !expandableController.expanded;
              },
              child: SafeArea(
                bottom: !expandableController.expanded,
                child: ColoredBox(
                  color: const Color(0xFFF1F3F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          ref.read(tabsProvider.notifier).setMultiTagSheet(false);
                        },
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            s.cancel,
                            textScaler: const TextScaler.linear(1),
                            style: const TextStyle(
                              color: Color(0xff707070),
                              fontSize: 16,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      CupertinoButton(
                        onPressed: () async {
                          if (tagsState.multiPicTags.containsKey(kSecretTagKey)) {
                            showDeleteSecretModalForMultiPic(context, ref);
                            return;
                          }

                          ref.read(tabsProvider.notifier).setMultiTagSheet(false);
                          ref.read(tabsProvider.notifier).setMultiPicBar(false);

                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                            await ref.read(tagsProvider.notifier).addTagsToSelectedPics();
                          });
                        },
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            s.ok,
                            textScaler: const TextScaler.linear(1),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: Color(0xff707070),
                              fontSize: 16,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add expandable content here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildMultiPicBar(BuildContext context, TabsState tabsState, language.S s) {
    return Container(
      color: const Color(0xfff1f2f3),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kMultiPicBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                onPressed: () {
                  ref.read(tabsProvider.notifier).setMultiPicBar(false);
                },
                child: Text(
                  s.cancel,
                  textScaler: const TextScaler.linear(1),
                  style: const TextStyle(
                    color: Color(0xff707070),
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Add multi-pic action buttons here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalBottomBar(BuildContext context, TabsState tabsState, language.S s) {
    return Container(
      color: const Color(0xfff1f2f3),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildTabButton(
                index: 0,
                isSelected: tabsState.currentIndex == 0,
                activeIcon: 'lib/images/untaggedtabactive.png',
                inactiveIcon: 'lib/images/untaggedtabinactive.png',
              ),
              _buildTabButton(
                index: 1,
                isSelected: tabsState.currentIndex == 1,
                activeIcon: 'lib/images/pictabactive.png',
                inactiveIcon: 'lib/images/pictabinactive.png',
              ),
              _buildTabButton(
                index: 2,
                isSelected: tabsState.currentIndex == 2,
                activeIcon: 'lib/images/taggedtabactive.png',
                inactiveIcon: 'lib/images/taggedtabinactive.png',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required bool isSelected,
    required String activeIcon,
    required String inactiveIcon,
  }) {
    final iconPath = isSelected ? activeIcon : inactiveIcon;

    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        ref.read(tabsProvider.notifier).setCurrentTab(index);
      },
      child: Image.asset(
        iconPath,
        width: 24,
        height: 24,
      ),
    );
  }
}
