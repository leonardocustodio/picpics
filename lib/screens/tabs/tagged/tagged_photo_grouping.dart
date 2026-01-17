// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picpics/providers/blur_hash_provider.dart';
import 'package:picpics/providers/pic_store_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/screens/tabs/tagged/particular_tag_key_tagged/tagged_tab_selective_tag_key.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/photo_widget.dart';

class TaggedPhotosGrouping extends ConsumerWidget {
  const TaggedPhotosGrouping({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taggedState = ref.watch(taggedProvider);
    final tagsState = ref.watch(tagsProvider);
    final tabsState = ref.watch(tabsProvider);
    final blurHashState = ref.watch(blurHashProvider);

    final height = (MediaQuery.of(context).size.width / 3) - 20;

    /// Show the tags tab
    final tempTaggedStorage = taggedState.taggedPicId.keys.toList();
    var taggedKeys = <String>[];
    if (tagsState.selectedFilteringTagsKeys.isNotEmpty) {
      final tempStorage = <String, String>{};
      tagsState.selectedFilteringTagsKeys.forEach((key, _) {
        if (taggedState.taggedPicId[key] != null) {
          taggedKeys.add(key);
          tempStorage[key] = '';
        }
      });
      for (final tag in tempTaggedStorage) {
        if (tempStorage[tag] == null) {
          taggedKeys.add(tag);
        }
      }
    } else {
      taggedKeys = taggedState.taggedPicId.keys.toList();
    }

    return StaggeredGridView.countBuilder(
      key: const Key('tag'),
      padding: const EdgeInsets.only(left: 7, right: 7),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      itemCount: taggedKeys.length,
      staggeredTileBuilder: (_) {
        return StaggeredTile.extent(1, height + 45);
      },
      itemBuilder: (_, int index) {
        final tagKey = taggedKeys[index];
        final showingPicId = taggedState.taggedPicId[taggedKeys[index]]?.keys.last;

        final blurHash = blurHashState.blurHash[showingPicId];
        final ignore = tagsState.isSearching && tagsState.selectedFilteringTagsKeys[tagKey] == null;
        AppLogger.d('$ignore');

        return IgnorePointer(
          ignoring: ignore,
          child: Opacity(
            opacity: ignore ? 0.3 : 1.0,
            child: GestureDetector(
              onTap: () {
                unawaited(Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => TaggedTabSelectiveTagKey(tagKey),
                  ),
                ),);
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                child: Builder(
                  builder: (context) {
                    PicStoreNotifier? picStore;

                    if (showingPicId != null) {
                      picStore = tabsState.picStoreMap[showingPicId];
                    }

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: null != blurHash
                                  ? BlurHash(
                                      hash: blurHash,
                                      color: Colors.transparent,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(10),
                                      color: Colors.grey[300],
                                    ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: PhotoWidget(picStore: picStore),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: tagsState.allTags[tagKey]?.title ?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' (${taggedState.taggedPicId[tagKey]?.keys.length ?? 0})',
                                      ),
                                    ],
                                  ),
                                  maxFontSize: 20,
                                  minFontSize: 5,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (picStore?.state.isStarred ?? false)
                          Positioned(
                            left: 6,
                            top: 6,
                            child: Image.asset('lib/images/staryellowico.png'),
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
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
