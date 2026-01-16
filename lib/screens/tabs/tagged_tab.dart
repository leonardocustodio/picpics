import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/screens/tabs/tagged/no_tagged_pics_in_device.dart';
import 'package:picpics/screens/tabs/tagged/tagged_pics_with_search_option.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/toggle_bar.dart';

class TaggedTab extends ConsumerWidget {
  const TaggedTab({super.key});
  static const id = 'tagged_tab';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taggedState = ref.watch(taggedProvider);
    final taggedNotifier = ref.read(taggedProvider.notifier);
    final tagsState = ref.watch(tagsProvider);
    final tagsNotifier = ref.read(tagsProvider.notifier);
    final tabsState = ref.watch(tabsProvider);
    final tabsNotifier = ref.read(tabsProvider.notifier);
    final s = ref.watch(sProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          AppLogger.d('PopScope taggedTab');
          if (taggedState.multiTagSheet) {
            AppLogger.d('PopScope multiTagSheet');
            taggedNotifier.setMultiTagSheet(false);
            return;
          }
          if (taggedState.multiPicBar) {
            AppLogger.d('PopScope multiPicBar');
            taggedNotifier.setMultiPicBar(false);
            return;
          }
          if (tagsState.isSearching) {
            AppLogger.d('PopScope isSearching');
            tagsNotifier.setIsSearching(false);
            return;
          }
          AppLogger.d('PopScope currentTab = 0');
          tabsNotifier.setCurrentTab(0);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Builder(
                    builder: (context) {
                      if (tabsState.assetMap.isNotEmpty) {
                        ///
                        /// Device has pics
                        ///
                        if (taggedState.allTaggedPicIdList.isEmpty) {
                          ///
                          /// Device has pics but no tagged pics
                          ///
                          return const NoTaggedPicsInDevice();
                        } else {
                          ///
                          /// Device has pics with tagged Pics
                          ///
                          return const TaggedPicsInDeviceWithSearchOption();
                        }
                      } else {
                        ///
                        /// Device has no pics
                        ///
                        return DeviceHasNoPics(message: s.device_has_no_pics);
                      }
                    },
                  ),
                ),
                Positioned.fill(
                  child: Builder(
                    builder: (context) {
                      if (tabsState.assetMap.isNotEmpty &&
                          taggedState.allTaggedPicIdList.isNotEmpty) {
                        return NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (scrollNotification is ScrollStartNotification) {
                              AppLogger.d('Start scrolling');
                              taggedNotifier.setIsScrolling(true);
                              return true;
                            } else if (scrollNotification
                                is ScrollEndNotification) {
                              AppLogger.d('End scrolling');
                              taggedNotifier.setIsScrolling(false);
                            }
                            return false;
                          },
                          child: Container(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                AnimatedOpacity(
                  opacity: taggedState.isScrolling
                      ? 0.0
                      : (taggedNotifier.searchFocusNode.hasFocus ||
                              taggedState.allTaggedPicIdList.isEmpty)
                          ? 0.0
                          : 1.0,
                  duration: Duration(
                    milliseconds:
                        taggedNotifier.searchFocusNode.hasFocus ? 0 : 300,
                  ),
                  onEnd: () {
                    tabsNotifier.setIsToggleBarVisible(
                      taggedState.isScrolling ? false : true,
                    );
                  },
                  child: Visibility(
                    visible: taggedState.isScrolling
                        ? tabsState.isToggleBarVisible
                        : true,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ToggleBar(
                          titleLeft: s.toggle_date,
                          titleRight: s.toggle_tags,
                          activeToggle: taggedState.toggleIndexTagged,
                          onToggle: (int index) {
                            taggedNotifier.setToggleIndexTagged(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
