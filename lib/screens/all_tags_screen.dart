import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/providers/all_tags_provider.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/providers/pic_store_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/customised_tags_list.dart';

class AllTagsScreen extends ConsumerStatefulWidget {
  const AllTagsScreen({
    this.picStore,
    super.key,
  });

  static const id = 'all_tags_screen';
  final PicStoreNotifier? picStore;

  @override
  ConsumerState<AllTagsScreen> createState() => _AllTagsScreenState();
}

class _AllTagsScreenState extends ConsumerState<AllTagsScreen> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController searchEditingController = TextEditingController();
  bool loadTagsFromPicStoreNotifier = true;

  @override
  void dispose() {
    focusNode.dispose();
    searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTagsState = ref.watch(allTagsProvider);
    final tagsState = ref.watch(tagsProvider);
    final s = ref.watch(sProvider);

    // Initialize selected tags from picStore on first build
    if (loadTagsFromPicStoreNotifier && widget.picStore != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // TODO: Access picStore.tags properly without .value
        // For now, initialize with empty map
        ref.read(allTagsProvider.notifier).initializeSelectedTags({});
        loadTagsFromPicStoreNotifier = false;
      });
    }

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: Image.asset('lib/images/backarrowgray.png'),
                          ),
                        ),
                        Image.asset('lib/images/searchico.png'),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 50,
                            width: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      controller: searchEditingController,
                                      focusNode: focusNode,
                                      onChanged: (text) {
                                        ref.read(allTagsProvider.notifier).setSearchedText(text);
                                        ref.read(allTagsProvider.notifier).doSearching(tagsState.allTags);
                                      },
                                      onFieldSubmitted: (text) {
                                        // Handle submission if needed
                                      },
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        color: Color(0xff606566),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: -0.4099999964237213,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(0),
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                        hintText: 'Search...',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Lato',
                                          color: kGrayColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (allTagsState.searchedText.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      ref.read(allTagsProvider.notifier).clearSearch();
                                      focusNode.unfocus();
                                      searchEditingController.clear();
                                    },
                                    child: const SizedBox(
                                      width: 60,
                                      child: Icon(Icons.clear),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (allTagsState.searchedText.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Searched',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xff979a9b),
                            fontSize: 33,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                        ),
                      ),
                      CustomisedTagsList(
                        tagsKeyList: allTagsState.searchedTags.keys.toList(),
                        selectedTags: allTagsState.selectedTags,
                        onTap: (String tagId, String tagName, int count, DateTime? time) async =>
                            doTagging(tagId, tagName, count, time),
                        onDoubleTap: () {
                          AppLogger.d('do nothing');
                        },
                      ),
                    ],
                  ),
                if (allTagsState.searchedText.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Most used',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xff979a9b),
                            fontSize: 33,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                        ),
                      ),
                      CustomisedTagsList(
                        tagsKeyList: tagsState.mostUsedTags.keys.toList(),
                        selectedTags: allTagsState.selectedTags,
                        onTap: (String tagId, String tagName, int count, DateTime? time) async =>
                            doTagging(tagId, tagName, count, time),
                        onDoubleTap: () {
                          AppLogger.d('do nothing');
                        },
                      ),
                    ],
                  ),
                if (tagsState.lastWeekUsedTags.isNotEmpty && allTagsState.searchedText.isEmpty)
                  const SizedBox(height: 20),
                if (tagsState.lastWeekUsedTags.isNotEmpty && allTagsState.searchedText.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Last Week Used',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xff979a9b),
                            fontSize: 33,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                        ),
                      ),
                      CustomisedTagsList(
                        tagsKeyList: tagsState.lastWeekUsedTags.keys.toList(),
                        selectedTags: allTagsState.selectedTags,
                        onTap: (String tagId, String tagName, int count, DateTime? time) async =>
                            doTagging(tagId, tagName, count, time),
                        onDoubleTap: () {
                          AppLogger.d('do nothing');
                        },
                      ),
                    ],
                  ),
                if (tagsState.lastMonthUsedTags.isNotEmpty && allTagsState.searchedText.isEmpty)
                  const SizedBox(height: 20),
                if (tagsState.lastMonthUsedTags.isNotEmpty && allTagsState.searchedText.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Last Month Used',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xff979a9b),
                            fontSize: 33,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                        ),
                      ),
                      CustomisedTagsList(
                        tagsKeyList: tagsState.lastMonthUsedTags.keys.toList(),
                        selectedTags: allTagsState.selectedTags,
                        onTap: (String tagId, String tagName, int count, DateTime? time) async =>
                            doTagging(tagId, tagName, count, time),
                        onDoubleTap: () {
                          AppLogger.d('do nothing');
                        },
                      ),
                    ],
                  ),
                if (allTagsState.searchedText.isEmpty) const SizedBox(height: 20),
                if (allTagsState.searchedText.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          s.allTags,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xff979a9b),
                            fontSize: 33,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                        ),
                      ),
                      CustomisedTagsList(
                        tagsKeyList: tagsState.allTags.keys.toList(),
                        selectedTags: allTagsState.selectedTags,
                        onTap: (String tagId, String tagName, int count, DateTime? time) async =>
                            doTagging(tagId, tagName, count, time),
                        onDoubleTap: () {
                          AppLogger.d('do nothing');
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doTagging(String tagId, String tagName, int count, DateTime? time) async {
    AppLogger.d('Tagging: $tagName');

    final currentSelected = ref.read(allTagsProvider).selectedTags;

    if (currentSelected.containsKey(tagId)) {
      // Remove tag
      ref.read(allTagsProvider.notifier).toggleTagSelection(
        tagId,
        TagModel(key: tagId, title: tagName, count: count, time: time),
      );
      await ref.read(tagsProvider.notifier).removeTagFromPic(
        picId: widget.picStore!.state.photoId,
        tagKey: tagId,
      );
    } else {
      // Add tag
      ref.read(allTagsProvider.notifier).toggleTagSelection(
        tagId,
        TagModel(key: tagId, title: tagName, count: count, time: time),
      );
      await widget.picStore?.addMultipleTagsToPic(acceptedTagKeys: {tagId: ''});
    }

    await ref.read(tagsProvider.notifier).loadAllTags();
    await ref.read(taggedProvider.notifier).refreshTaggedPhotos();
  }
}
