import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/blur_hash_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/screens/photo_screen.dart';
import 'package:picpics/widgets/photo_widget.dart';

// ignore: must_be_immutable
class TaggedTabSelectiveTagKeyGrid extends ConsumerWidget {
  const TaggedTabSelectiveTagKeyGrid(this.tagKey, {super.key});
  final String tagKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taggedState = ref.watch(taggedProvider);
    final tabsState = ref.watch(tabsProvider);
    final blurHashState = ref.watch(blurHashProvider);

    final taggedPicIds = taggedState.taggedPicId[tagKey]?.keys.toList().reversed.toList() ?? <String>[];

    return StaggeredGridView.countBuilder(
      key: Key(tagKey),
      padding: const EdgeInsets.only(top: 2),
      crossAxisCount: 4,
      itemCount: taggedPicIds.length,
      staggeredTileBuilder: (_) {
        return const StaggeredTile.count(1, 1);
      },
      itemBuilder: (_, int index) {
        final picId = taggedPicIds[index];

        final blurHash = blurHashState.blurHash[picId];
        final picStore = tabsState.picStoreMap[picId];

        return Padding(
          padding: const EdgeInsets.all(4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                if (taggedState.multiPicBar) {
                  final taggedNotifier = ref.read(taggedProvider.notifier);
                  if (taggedState.selectedMultiBarPics[picId] == null) {
                    taggedNotifier.addSelectedMultiBarPic(picId);
                  } else {
                    taggedNotifier.removeSelectedMultiBarPic(picId);
                  }
                  return;
                }
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => PhotoScreen(picId: picId, picIdList: taggedPicIds),
                  ),
                );
              },
              child: GestureDetector(
                onLongPress: () {
                  final taggedNotifier = ref.read(taggedProvider.notifier);
                  if (taggedState.multiPicBar == false) {
                    taggedNotifier.setMultiPicBar(true);
                  }
                  taggedNotifier.addSelectedMultiBarPic(picId);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PhotoWidget(
                        picStore: picStore,
                        hash: blurHash,
                      ),
                    ),
                    if (taggedState.multiPicBar && taggedState.selectedMultiBarPics[picId] != null) ...[
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
  }
}
