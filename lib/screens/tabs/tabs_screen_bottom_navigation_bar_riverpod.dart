import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  ConsumerState<TabsScreenBottomNavigatioBar> createState() => 
      _TabsScreenBottomNavigatioBarState();
}

class _TabsScreenBottomNavigatioBarState 
    extends ConsumerState<TabsScreenBottomNavigatioBar> {
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

                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) async {
                            await ref.read(tagsProvider.notifier)
                                .addTagsToSelectedPics();
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
    return SafeArea(
      child: Container(
        color: const Color(0xfff1f2f3),
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
    );
  }

  Widget _buildNormalBottomBar(BuildContext context, TabsState tabsState, language.S s) {
    return SafeArea(
      child: Container(
        color: const Color(0xfff1f2f3),
        height: kBottomBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTabButton(
              index: 0,
              isSelected: tabsState.currentIndex == 0,
              icon: 'lib/images/untagged_tab',
              label: 'Recent', // TODO: Use localization when available
            ),
            _buildTabButton(
              index: 1,
              isSelected: tabsState.currentIndex == 1,
              icon: 'lib/images/pics_tab',
              label: 'Photos', // TODO: Use localization when available
            ),
            _buildTabButton(
              index: 2,
              isSelected: tabsState.currentIndex == 2,
              icon: 'lib/images/tagged_tab',
              label: 'Tags', // TODO: Use localization when available
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required bool isSelected,
    required String icon,
    required String label,
  }) {
    final color = isSelected ? kPrimaryColor : const Color(0xffc1c2c3);
    final iconPath = isSelected ? '${icon}_selected.png' : '$icon.png';

    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        ref.read(tabsProvider.notifier).setCurrentTab(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textScaler: const TextScaler.linear(1),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}