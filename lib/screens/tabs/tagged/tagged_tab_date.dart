// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/blur_hash_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/screens/photo_screen.dart';
import 'package:picpics/widgets/date_header.dart';
import 'package:picpics/widgets/photo_widget.dart';

class TaggedTabDate extends ConsumerStatefulWidget {
  const TaggedTabDate({
    super.key,
  });

  @override
  ConsumerState<TaggedTabDate> createState() => _TaggedTabDateState();
}

class _TaggedTabDateState extends ConsumerState<TaggedTabDate> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taggedState = ref.watch(taggedProvider);
    final taggedNotifier = ref.read(taggedProvider.notifier);
    final tabsState = ref.watch(tabsProvider);
    final blurHashState = ref.watch(blurHashProvider);

    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.only(top: 2),
      crossAxisCount: 4,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      primary: false,
      controller: scrollController,
      itemCount: taggedState.allTaggedPicDateWiseList.length,
      staggeredTileBuilder: (int index) {
        if (taggedState.allTaggedPicDateWiseList[index] is DateTime) {
          return const StaggeredTile.extent(4, 40);
        }
        return const StaggeredTile.count(1, 1);
      },
      itemBuilder: (_, int index) {
        return Builder(
          builder: (context) {
            if (taggedState.allTaggedPicDateWiseList[index] is DateTime) {
              var isSelected = false;
              if (taggedState.multiPicBar) {
                var i = index + 1;
                isSelected = true;

                while (i < taggedState.allTaggedPicDateWiseList.length &&
                    taggedState.allTaggedPicDateWiseList[i] is String) {
                  if (taggedState.selectedMultiBarPics[taggedState.allTaggedPicDateWiseList[i]] == null) {
                    isSelected = false;
                    break;
                  }
                  i++;
                }
              }

              return GestureDetector(
                onTap: () {
                  if (taggedState.multiPicBar) {
                    var i = index + 1;
                    if (isSelected) {
                      while (i < taggedState.allTaggedPicDateWiseList.length &&
                          taggedState.allTaggedPicDateWiseList[i] is String) {
                        taggedNotifier.removeSelectedMultiBarPic(
                          taggedState.allTaggedPicDateWiseList[i] as String,
                        );
                        i++;
                      }
                    } else {
                      while (i < taggedState.allTaggedPicDateWiseList.length &&
                          taggedState.allTaggedPicDateWiseList[i] is String) {
                        taggedNotifier.addSelectedMultiBarPic(
                          taggedState.allTaggedPicDateWiseList[i] as String,
                        );
                        i++;
                      }
                    }
                  }
                },
                child: DateHeaderWidget(
                  date: taggedState.allTaggedPicDateWiseList[index] as DateTime,
                  isSelected: isSelected,
                  isMonth: true,
                ),
              );
            }

            final picId = taggedState.allTaggedPicDateWiseList[index];
            final blurHash = blurHashState.blurHash[taggedState.allTaggedPicDateWiseList[index]];
            final picStore = tabsState.picStoreMap[taggedState.allTaggedPicDateWiseList[index]];
            return Padding(
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (taggedState.multiPicBar) {
                      if (taggedState.selectedMultiBarPics[picId] == null) {
                        taggedNotifier.addSelectedMultiBarPic(picId as String);
                      } else {
                        taggedNotifier.removeSelectedMultiBarPic(picId as String);
                      }
                      return;
                    }

                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => PhotoScreen(
                          picId: picId as String,
                          picIdList: taggedState.allTaggedPicIdList.keys.toList(),
                        ),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onLongPress: () {
                      if (!taggedState.multiPicBar) {
                        taggedNotifier.setMultiPicBar(value: true);
                      }
                      taggedNotifier.addSelectedMultiBarPic(picId as String);
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: PhotoWidget(
                            picStore: picStore,
                            hash: blurHash,
                          ),
                        ),
                        if (picStore != null && picStore.state.isStarred)
                          Positioned(
                            left: 6,
                            top: 6,
                            child: Image.asset('lib/images/staryellowico.png'),
                          ),
                        if (taggedState.multiPicBar &&
                            taggedState.selectedMultiBarPics[picId] != null &&
                            (taggedState.selectedMultiBarPics[picId] ?? false)) ...[
                          Container(
                            constraints: const BoxConstraints.expand(),
                            decoration: BoxDecoration(
                              color: kSecondaryColor.withValues(alpha: 0.3),
                              border: Border.all(
                                color: kSecondaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 6,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                gradient: kSecondaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset('lib/images/checkwhiteico.png'),
                            ),
                          ),
                          if (picStore?.state.isPrivate ?? false)
                            Positioned(
                              right: 8,
                              top: 6,
                              child: Container(
                                height: 20,
                                width: 20,
                                padding: const EdgeInsets.only(bottom: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffffcc00),
                                      Color(0xffffe98f),
                                    ],
                                    stops: [0.2291666716337204, 1],
                                    end: Alignment(1, -0),
                                    // angle: 0,
                                    // scale: undefined,
                                  ),
                                ),
                                child: Image.asset(
                                  'lib/images/smallwhitelock.png',
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
