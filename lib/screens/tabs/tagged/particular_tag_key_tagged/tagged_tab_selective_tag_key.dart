import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_key_grid.dart';
import 'package:picpics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_option_bar.dart';
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/percentage_dialog.dart';
import 'package:picpics/widgets/select_all_widget.dart';

class TaggedTabSelectiveTagKey extends ConsumerWidget {
  const TaggedTabSelectiveTagKey(this.tagKey, {super.key});
  final String tagKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taggedState = ref.watch(taggedProvider);
    final tagsState = ref.watch(tagsProvider);
    final tabsState = ref.watch(tabsProvider);
    final s = ref.watch(sProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final shouldPop = await ref.read(taggedProvider.notifier).shouldPopOut();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: TaggedTabSelectiveTagOptionBar(tagKey: tagKey),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black,
          actions: [
            if (taggedState.multiPicBar && taggedState.selectedMultiBarPics.isNotEmpty)
              CupertinoButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: () async {
                  await ref.read(taggedProvider.notifier).untagPicsFromTag(
                    tagKeyMapToPicId: <String, Map<String, String>>{
                      tagKey: taggedState.selectedMultiBarPics.map((key, _) => MapEntry(key, '')),
                    },
                  );
                },
                child: const Text('Untag'),
              ),
          ],
          leading: GestureDetector(
            onTap: () async {
              if (await ref.read(taggedProvider.notifier).shouldPopOut()) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black.withValues(alpha: .5),
              size: 24,
            ),
          ),
          titleSpacing: -8,
          title: Text(
            '${tagsState.allTags[tagKey]?.title ?? ''} (${taggedState.taggedPicId[tagKey]?.keys.length ?? 0})',
            style: TextStyle(
              color: Colors.black.withValues(alpha: .5),
            ),
          ),
        ),
        body: ColoredBox(
          //constraints: BoxConstraints.expand(),
          color: kWhiteColor,
          child: SafeArea(
            child: Builder(
              builder: (context) {
                if (!taggedState.isTaggedPicsLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (tabsState.assetEntityList.isNotEmpty) {
                  ///
                  /// Device has pics
                  ///
                  final hasTaggedPics = taggedState.taggedPicId[tagKey]?.isNotEmpty ?? false;
                  if (hasTaggedPics) {
                    ///
                    /// Tagged Pics are available
                    ///
                    var isSelected = true;
                    if (taggedState.multiPicBar) {
                      for (final picId in taggedState.taggedPicId[tagKey]!.keys) {
                        if (taggedState.selectedMultiBarPics[picId] == null) {
                          isSelected = false;
                          break;
                        }
                      }
                    }

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Column(
                            children: [
                              if (taggedState.multiPicBar)
                                GestureDetector(
                                  onTap: () {
                                    final taggedNotifier = ref.read(taggedProvider.notifier);
                                    if (isSelected) {
                                      for (final picId in taggedState.taggedPicId[tagKey]!.keys) {
                                        taggedNotifier.removeSelectedMultiBarPic(picId);
                                      }
                                    } else {
                                      for (final picId in taggedState.taggedPicId[tagKey]!.keys) {
                                        taggedNotifier.addSelectedMultiBarPic(picId);
                                      }
                                    }
                                  },
                                  child: SelectAllWidget(
                                    isSelected: isSelected,
                                  ),
                                ),
                              Expanded(
                                child: TaggedTabSelectiveTagKeyGrid(tagKey),
                              ),
                            ],
                          ),
                        ),
                        const Positioned.fill(child: PercentageDialog()),
                      ],
                    );
                  }

                  ///
                  /// No Pics Tagged
                  ///
                  return DeviceHasNoPics(
                    message: s.no_photos_were_tagged,
                  );
                }

                /// Device has no Pics
                return DeviceHasNoPics(
                  message: s.device_has_no_pics,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
