import 'dart:async';
import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/utils/functions.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/widgets/tags_list.dart';

class TaggedTabSelectiveTagOptionBar extends ConsumerStatefulWidget {
  const TaggedTabSelectiveTagOptionBar({required this.tagKey, super.key});
  final String tagKey;

  @override
  ConsumerState<TaggedTabSelectiveTagOptionBar> createState() => _TaggedTabSelectiveTagOptionBarState();
}

class _TaggedTabSelectiveTagOptionBarState extends ConsumerState<TaggedTabSelectiveTagOptionBar> {
  final bottomTagsEditingController = TextEditingController();

  @override
  void dispose() {
    bottomTagsEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taggedState = ref.watch(taggedProvider);
    final taggedNotifier = ref.read(taggedProvider.notifier);
    final tagsState = ref.watch(tagsProvider);
    final tagsNotifier = ref.read(tagsProvider.notifier);
    final s = ref.watch(sProvider);

    return Builder(builder: (context) {
      if (taggedState.multiTagSheet) {
        return ExpandableNotifier(
          controller: taggedState.expandableController,
          child: ColoredBox(
            color: const Color(0x0ff1f3f5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    taggedState.expandableController.expanded = !taggedState.expandableController.expanded;
                  },
                  child: SafeArea(
                    bottom: !taggedState.expandableController.expanded,
                    child: ColoredBox(
                      color: const Color(0xFFF1F3F5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CupertinoButton(
                            onPressed: () {
                              taggedNotifier.setMultiTagSheet(value: false);
                            },
                            child: SizedBox(
                              width: 80,
                              child: Text(
                                s.cancel,
                                textScaler: TextScaler.noScaling,
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
                              // if (!UserController.to.isPremium) {
                              //   Get.to<void>(() =>   PremiumScreen());
                              //   return;
                              // }

                              if (tagsState.multiPicTags[kSecretTagKey] != null) {
                                showDeleteSecretModalForMultiPic(context, ref);
                                return;
                              }

                              taggedNotifier
                                ..setMultiTagSheet(value: false)
                                ..setMultiPicBar(value: false);
                              await tagsNotifier.addTagsToSelectedPics();
                              await ref.read(tabsProvider.notifier).refreshUntaggedList();
                              await tagsNotifier.tagsSuggestionsCalculate();
                              tagsNotifier.clear();
                            },
                            child: SizedBox(
                              width: 80,
                              child: Text(
                                s.ok,
                                textScaler: TextScaler.noScaling,
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
                Expandable(
                  controller: taggedState.expandableController,
                  expanded: Container(
                    padding: const EdgeInsets.all(24),

                    /// TODO(picpics): Tags List Not Showing
                    color: const Color(0xFFEFEFF4).withValues(alpha: 0.94),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TagsList(
                            tagStyle: TagStyle.multiColored,
                            tagsKeyList: tagsState.multiPicTags.keys.toList(),
                            addTagField: true,
                            textEditingController: bottomTagsEditingController,
                            onTap: (String tagKey) {
                              ///  if (!UserController.to.isPremium) {
                              ///    Get.to<void>(() =>   PremiumScreen);
                              ///    return;
                              ///  }
                              AppLogger.d('do nothing');
                            },
                            onPanEnd: (String tagKey) {
                              // if (!UserController.to.isPremium) {
                              //   Get.to<void>(() =>   PremiumScreen);
                              //   return;
                              // }
                              tagsNotifier.removeMultiPicTag(tagKey);
                              unawaited(tagsNotifier.tagsSuggestionsCalculate());
                              //GalleryStore.to.removeFromMultiPicTags(tagKey);
                            },
                            onDoubleTap: (String tagKey) {
                              // if (!UserController.to.isPremium) {
                              //   Get.to<void>(() =>   PremiumScreen);
                              //   return;
                              // }
                              AppLogger.d('do nothing');
                            },
                            onChanged: (text) {
                              tagsNotifier.setSearchText(text);
                              unawaited(tagsNotifier.tagsSuggestionsCalculate());
                              //GalleryStore.to.setSearchText(text);
                            },
                            onSubmitted: (text) {
                              // if (!UserController.to.isPremium) {
                              //   Get.to<void>(() =>   PremiumScreen);
                              //   return;
                              // }
                              if (text != '') {
                                bottomTagsEditingController.clear();
                                tagsNotifier.setSearchText(text);
                                unawaited(tagsNotifier.tagsSuggestionsCalculate());
                                final tagKey = Helpers.encryptTag(text);

                                if (tagsState.multiPicTags[tagKey] == null) {
                                  if (tagsState.allTags[tagKey] == null) {
                                    AppLogger.d(
                                      'tag does not exist! creating it!',
                                    );
                                    unawaited(tagsNotifier.createTag(text));
                                  }
                                  tagsNotifier
                                    ..addMultiPicTag(tagKey)
                                    ..setSearchText('');
                                }
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TagsList(
                              title: tagsState.searchText != '' ? s.search_results : s.recent_tags,
                              tagsKeyList: tagsState.searchTagsResults
                                  .where(
                                    (tag) => tag.key != widget.tagKey && tagsState.multiPicTags[tag.key] == null,
                                  )
                                  .toList()
                                  .map((e) => e.key)
                                  .toList(),
                              tagStyle: TagStyle.grayOutlined,
                              onTap: (String tagKey) {
                                /* if (!UserController
                                                      .to.isPremium.value) {
                                                    Get.to<void>(() => PremiumScreen);
                                                    return;
                                                  } */

                                bottomTagsEditingController.clear();
                                tagsNotifier
                                  ..setSearchText('')
                                  //GalleryStore.to.setSearchText('');
                                  ..addMultiPicTag(tagKey);
                                unawaited(tagsNotifier.tagsSuggestionsCalculate());
                                //GalleryStore.to.addToMultiPicTags(tagKey);
                              },
                              onDoubleTap: (String tagKey) {
                                /* if (!UserController
                                                      .to.isPremium.value) {
                                                    Get.to<void>(() => PremiumScreen);
                                                    return;
                                                  } */
                                AppLogger.d('do nothing');
                              },
                              onPanEnd: (String tagKey) {
                                /* if (!UserController
                                                      .to.isPremium.value) {
                                                    Get.to<void>(() => PremiumScreen);
                                                    return;
                                                  } */
                                AppLogger.d('do nothing');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  collapsed: Container(),
                ),
                Expandable(
                  collapsed: Container(),
                  controller: taggedState.expandablePaddingController,
                  expanded: Container(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (!taggedState.multiPicBar) {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
      final listOfBottomNavigationItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: 'Return',
          icon: Image.asset('lib/images/returntabbutton.png'),
        ),
        BottomNavigationBarItem(
          label: 'Tag',
          icon: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: taggedState.selectedMultiBarPics.isEmpty ? 0.2 : 1,
            child: Image.asset('lib/images/tagtabbutton.png'),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Share',
          icon: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: taggedState.selectedMultiBarPics.isEmpty ? 0.2 : 1,
            child: Image.asset('lib/images/sharetabbutton.png'),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Trash',
          icon: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: taggedState.selectedMultiBarPics.isEmpty ? 0.2 : 1,
            child: Image.asset('lib/images/trashtabbutton.png'),
          ),
        ),
      ];
      return Platform.isIOS
          ? CupertinoTabBar(
              onTap: taggedNotifier.setBottomOptionsBar,
              iconSize: 24,
              border: const Border(
                top: BorderSide(color: Color(0xFFE2E4E5)),
              ),
              items: listOfBottomNavigationItems,
            )
          : SizedBox(
              height: 64,
              child: BottomNavigationBar(
                onTap: taggedNotifier.setBottomOptionsBar,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: listOfBottomNavigationItems,
              ),
            );
    },);
  }
}
