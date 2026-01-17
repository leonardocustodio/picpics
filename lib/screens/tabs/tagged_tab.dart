import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart' as language;
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/screens/tabs/tagged/no_tagged_pics_in_device.dart';
import 'package:picpics/screens/tabs/tagged/tagged_pics_with_search_option.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/app_header.dart';
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/toggle_bar.dart';

/// Builds the leading widget for the header.
/// Shows search field when there are tagged photos, otherwise shows logo.
Widget? _buildHeaderLeading(
  BuildContext context,
  WidgetRef ref,
  TabsState tabsState,
  TaggedState taggedState,
  TaggedNotifier taggedNotifier,
  TagsState tagsState,
  language.S s,
) {
  // Only show search field when there are tagged photos
  if (tabsState.assetMap.isEmpty || taggedState.allTaggedPicIdList.isEmpty) {
    return null; // Use default logo
  }

  return TextField(
    controller: taggedNotifier.searchEditingController,
    focusNode: taggedNotifier.searchFocusNode,
    onChanged: (text) {
      AppLogger.d('searching: $text');
      final isSearching =
          taggedNotifier.searchFocusNode.hasFocus || text.isNotEmpty || tagsState.selectedFilteringTagsKeys.isNotEmpty;
      ref.read(tagsProvider.notifier).setIsSearching(isSearching);
      ref.read(tagsProvider.notifier).setSearchText(text);
    },
    onSubmitted: (text) {
      AppLogger.d('return');
      final isSearching =
          taggedNotifier.searchFocusNode.hasFocus || text.isNotEmpty || tagsState.selectedFilteringTagsKeys.isNotEmpty;
      ref.read(tagsProvider.notifier).setIsSearching(isSearching);
      ref.read(tagsProvider.notifier).setSearchText('');
      taggedNotifier.searchEditingController.clear();
    },
    onTap: () {
      if (!tagsState.isSearching) {
        ref.read(tagsProvider.notifier).setIsSearching(true);
        unawaited(ref.read(tagsProvider.notifier).tagsSuggestionsCalculate());
      }
    },
    keyboardType: TextInputType.text,
    style: const TextStyle(
      fontFamily: 'Lato',
      color: Color(0xff606566),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      letterSpacing: -0.4099999964237213,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.only(right: 2),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      prefixIcon: Image.asset('lib/images/searchico.png'),
      hintText: s.search,
      hintStyle: const TextStyle(
        fontFamily: 'Lato',
        color: kGrayColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: -0.4099999964237213,
      ),
    ),
  );
}

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
      child: ColoredBox(
        color: kWhiteColor,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              AppHeader(
                leading: _buildHeaderLeading(
                  context,
                  ref,
                  tabsState,
                  taggedState,
                  taggedNotifier,
                  tagsState,
                  s,
                ),
              ),
              Expanded(
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
                          if (tabsState.assetMap.isNotEmpty && taggedState.allTaggedPicIdList.isNotEmpty) {
                            return NotificationListener<ScrollNotification>(
                              onNotification: (scrollNotification) {
                                if (scrollNotification is ScrollStartNotification) {
                                  AppLogger.d('Start scrolling');
                                  taggedNotifier.setIsScrolling(true);
                                  return true;
                                } else if (scrollNotification is ScrollEndNotification) {
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
                          : (taggedNotifier.searchFocusNode.hasFocus || taggedState.allTaggedPicIdList.isEmpty)
                              ? 0.0
                              : 1.0,
                      duration: Duration(
                        milliseconds: taggedNotifier.searchFocusNode.hasFocus ? 0 : 300,
                      ),
                      onEnd: () {
                        tabsNotifier.setIsToggleBarVisible(
                          !taggedState.isScrolling,
                        );
                      },
                      child: Visibility(
                        visible: !taggedState.isScrolling || tabsState.isToggleBarVisible,
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
            ],
          ),
        ),
      ),
    );
  }
}
