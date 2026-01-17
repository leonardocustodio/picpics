import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/blur_hash_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/screens/photo_screen.dart';
import 'package:picpics/widgets/date_header.dart';
import 'package:picpics/widgets/photo_widget.dart';

class UntaggedTabDay extends ConsumerWidget {
  const UntaggedTabDay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsState = ref.watch(tabsProvider);
    final tabsNotifier = ref.read(tabsProvider.notifier);
    final taggedState = ref.watch(taggedProvider);
    final taggedNotifier = ref.read(taggedProvider.notifier);
    final blurHashState = ref.watch(blurHashProvider);

    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      controller: tabsNotifier.untaggedScrollControllerDay,
      key: const Key('Day'),
      padding: const EdgeInsets.only(top: 2),
      itemCount: tabsState.allUnTaggedPicsDay.length,
      crossAxisCount: 3,
      staggeredTileBuilder: (int index) {
        if (tabsState.allUnTaggedPicsDay[index] is DateTime) {
          if (index + 1 < tabsState.allUnTaggedPicsDay.length && tabsState.allUnTaggedPicsDay[index + 1] is DateTime) {
            return const StaggeredTile.extent(3, 0);
          }
          return const StaggeredTile.extent(3, 40);
        }
        return const StaggeredTile.count(1, 1);
      },
      itemBuilder: (_, int index) {
        return Builder(
          builder: (context) {
            final object = tabsState.allUnTaggedPicsDay[index];
            if (object is DateTime) {
              var isSelected = false;
              if (tabsState.multiPicBar) {
                var i = index + 1;
                isSelected = true;

                while (i < tabsState.allUnTaggedPicsDay.length && tabsState.allUnTaggedPicsDay[i] is String) {
                  if (taggedState.selectedMultiBarPics[tabsState.allUnTaggedPicsDay[i]] == null) {
                    isSelected = false;
                    break;
                  }
                  i++;
                }
              }
              return GestureDetector(
                onTap: () {
                  if (tabsState.multiPicBar) {
                    var i = index + 1;
                    if (isSelected) {
                      while (i < tabsState.allUnTaggedPicsDay.length && tabsState.allUnTaggedPicsDay[i] is String) {
                        taggedNotifier.removeSelectedMultiBarPic(
                          tabsState.allUnTaggedPicsDay[i] as String,
                        );
                        i++;
                      }
                    } else {
                      while (i < tabsState.allUnTaggedPicsDay.length && tabsState.allUnTaggedPicsDay[i] is String) {
                        taggedNotifier.addSelectedMultiBarPic(
                          tabsState.allUnTaggedPicsDay[i] as String,
                        );
                        i++;
                      }
                    }
                  }
                },
                child: DateHeaderWidget(
                  date: object,
                  isSelected: isSelected,
                  isMonth: tabsState.toggleIndexUntagged == 0,
                ),
              );
            }
            final blurHash = blurHashState.blurHash[object];
            final picStore = tabsState.picStoreMap[object];
            return Padding(
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () async {
                    if (tabsState.multiPicBar) {
                      if (taggedState.selectedMultiBarPics[object] == null) {
                        taggedNotifier.addSelectedMultiBarPic(object as String);
                      } else {
                        taggedNotifier.removeSelectedMultiBarPic(object as String);
                      }
                      return;
                    }
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => PhotoScreen(
                          picId: object as String,
                          picIdList: tabsState.allUnTaggedPics.keys.toList(),
                        ),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onLongPress: () {
                      if (tabsState.multiPicBar == false) {
                        tabsNotifier.setMultiPicBar(true);
                      }
                      taggedNotifier.addSelectedMultiBarPic(object as String);
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: PhotoWidget(
                            picStore: picStore,
                            hash: blurHash,
                          ),
                        ),
                        if (tabsState.multiPicBar && taggedState.selectedMultiBarPics[object] != null) ...[
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
