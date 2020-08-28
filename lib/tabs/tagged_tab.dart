import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/photo_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:provider/provider.dart';
import 'package:picPics/widgets/top_bar.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/model/tag.dart';

class TaggedTab extends StatefulWidget {
  static const id = 'tagged_tab';

  final Function showEditTagModal;

  TaggedTab({
    @required this.showEditTagModal,
  });

  @override
  _TaggedTabState createState() => _TaggedTabState();
}

class _TaggedTabState extends State<TaggedTab> {
  GalleryStore galleryStore;
  TabsStore tabsStore;

  ScrollController scrollControllerThirdTab;
  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  double offsetThirdTab = 0.0;
  double topOffsetThirdTab = 64.0;
  bool hideTitleThirdTab = false;
  bool hideSubtitleThirdTab = false;

  TextEditingController tagsEditingController = TextEditingController();

  void movedGridPositionThirdTab() {
    var offset = scrollControllerThirdTab.offset;

    if (offset >= 98) {
      setState(() {
        hideTitleThirdTab = true;
      });
    } else if (offset >= 52) {
      setState(() {
        hideTitleThirdTab = false;
        hideSubtitleThirdTab = true;
      });
    } else if (offset < 40) {
      setState(() {
        topOffsetThirdTab = 64;
        hideTitleThirdTab = false;
        hideSubtitleThirdTab = false;
      });
    }

    offsetThirdTab = scrollControllerThirdTab.offset;
    print(scrollControllerThirdTab.offset);
  }

  bool checkTagHasOneValidPic(Tag tag) {
//    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
//
//    for (String photoId in tag.photoId) {
//      var data = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);
//      if (data != null) {
//        return true;
//      }
//    }
//    return false;
    return true;
  }

  Widget _buildTaggedGridView(BuildContext context) {
    bool isFiltered = galleryStore.isSearching; // DatabaseManager.instance.searchActiveTags.isNotEmpty;
    var picsBox = Hive.box('pics');
    var tagsBox = Hive.box('tags');

    scrollControllerThirdTab = ScrollController(initialScrollOffset: offsetThirdTab);
    scrollControllerThirdTab.addListener(() {
      movedGridPositionThirdTab();
    });

    double newPadding = 0.0;
    if (galleryStore.isSearching) {
      newPadding = 140 - offsetThirdTab;
      if (newPadding > 140) {
        newPadding = 140.0;
      }
      if (newPadding < 0) {
        newPadding = 0;
      }
    }

    int totalTags = 0;
    int totalPics = 0;

    List<Widget> widgetsArray = [];
    List<bool> isTitleWidget = [];

//    if (!isFiltered) {
    List<String> slideThumbPhotoIds = [];

    List<String> tagsList = isFiltered ? galleryStore.searchingTagsKeys.toList() : tagsBox.keys.toList().cast<String>();
    print('Tags List: $tagsList');

//    if (isFiltered) {
//      String tagName = '';
//      if (tagsList.length == 1) {
//        Tag tag = tagsBox.get(tagsList[0]);
//        tagName = tag.name;
//      }
//
//      totalTags += 1;
//      isTitleWidget.add(true);
//      widgetsArray.add(Container(
//        padding: const EdgeInsets.only(left: 2.0, right: 8.0),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(
//              tagsList.length == 1 ? tagName : S.of(context).all_search_tags,
//              textScaleFactor: 1.0,
//              style: TextStyle(
//                fontFamily: 'Lato',
//                color: Color(0xff606566),
//                fontSize: 24,
//                fontWeight: FontWeight.w400,
//                fontStyle: FontStyle.normal,
//                letterSpacing: -0.4099999964237213,
//              ),
//            ),
//            CupertinoButton(
//              padding: const EdgeInsets.all(10),
//              onPressed: () async {
//                print('share pics');
//                tabsStore.setIsLoading(true);
//                await DatabaseManager.instance.sharePics(photoIds: DatabaseManager.instance.searchPhotosIds);
//                tabsStore.setIsLoading(false);
//              },
//              child: Image.asset('lib/images/sharepicsico.png'),
//            ),
//          ],
//        ),
//      ));
//
//      if (DatabaseManager.instance.searchPhotosIds.length == 0) {
//        totalPics += 1;
//        isTitleWidget.add(true);
//        widgetsArray.add(Container(
//          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
//          child: Text(
//            S.of(context).search_all_tags_not_found,
//            textScaleFactor: 1.0,
//            style: TextStyle(
//              fontFamily: 'Lato',
//              color: Color(0xff979a9b),
//              fontSize: 18,
//              fontWeight: FontWeight.w400,
//              fontStyle: FontStyle.normal,
//            ),
//          ),
//        ));
//      }
//
//      for (var photoId in DatabaseManager.instance.searchPhotosIds) {
//        var data = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);
//        if (data == null) {
//          print('Found a deleted picture');
//          continue;
//        }
//
//        totalPics += 1;
//        isTitleWidget.add(false);
//        slideThumbPhotoIds.add(data.id);
//        widgetsArray.add(RepaintBoundary(
//          child: Padding(
//            padding: const EdgeInsets.all(5.0),
//            child: ClipRRect(
//              borderRadius: BorderRadius.circular(5.0),
//              child: GestureDetector(
//                onLongPress: () {
//                  print('LongPress');
//                  if (tabsStore.multiPicBar == false) {
//                    Set<String> picsCopy = DatabaseManager.instance.picsSelected;
//                    picsCopy.add(data.id);
//                    DatabaseManager.instance.setPicsSelected(picsCopy);
//                    tabsStore.setMultiPicBar(true);
//                  }
//                },
//                child: CupertinoButton(
//                  padding: const EdgeInsets.all(0),
//                  onPressed: () {
//                    if (tabsStore.multiPicBar) {
//                      if (DatabaseManager.instance.picsSelected.contains(data.id)) {
//                        Set<String> picsCopy = DatabaseManager.instance.picsSelected;
//                        picsCopy.remove(data.id);
//                        DatabaseManager.instance.setPicsSelected(picsCopy);
//                      } else {
//                        Set<String> picsCopy = DatabaseManager.instance.picsSelected;
//                        picsCopy.add(data.id);
//                        DatabaseManager.instance.setPicsSelected(picsCopy);
//                      }
//                      print('Pics Selected Length: ${DatabaseManager.instance.picsSelected.length}');
//                      return;
//                    }
//
//                    // Call photocard
////                    Pic picInfo = DatabaseManager.instance.getPicInfo(data.id);
////                    tagsEditingController.text = '';
////
////                    DatabaseManager.instance.tagsSuggestions(
////                      tagsEditingController.text,
////                      data.id,
////                      excludeTags: picInfo.tags,
////                      notify: false,
////                    );
////
////                    print('PicTags: ${picInfo.tags}');
////
////                    DatabaseManager.instance.selectedPhotoData = data;
////                    DatabaseManager.instance.selectedPhotoPicInfo = picInfo;
////
////                    widget.showPhotoCardModal();
//
//                    // Call expanded screen directly
////                    DatabaseManager.instance.selectedPhoto = data;
//                    print('Selected photo: ${data.id}');
//                    int initialIndex = DatabaseManager.instance.slideThumbPhotoIds.indexOf(data.id);
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => PhotoScreen(
//                          initialIndex: initialIndex,
//                        ),
//                      ),
//                    );
//                    // Call expanded screen directly
//                  },
//                  child: ImageItem(
//                    entity: data,
//                    size: 150,
//                    backgroundColor: Colors.grey[400],
//                    showOverlay: tabsStore.multiPicBar ? true : false,
//                    isSelected: DatabaseManager.instance.picsSelected.contains(data.id),
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ));
//      }
//    }
//
//    if (!isFiltered || tagsList.length > 1) {
    for (String tagKey in galleryStore.taggedKeys) {
      Tag tag = tagsBox.get(tagKey);

//      if (tag.photoId.length == 0) {
//        print('skipping ${tag.name} because tag has no pictures...');
//        continue;
//      }
//
//      bool oneValidPic = checkTagHasOneValidPic(tag);
//      if (!oneValidPic) {
//        print('skipping ${tag.name} because tag has no valid pictures...');
//        continue;
//      }

      totalTags += 1;
      isTitleWidget.add(true);
      widgetsArray.add(Container(
        padding: const EdgeInsets.only(left: 2.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              tag.name,
              textScaleFactor: 1.0,
              style: TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff606566),
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.4099999964237213,
              ),
            ),
            CupertinoButton(
              onPressed: () async {
                print('share pics');
                tabsStore.setIsLoading(true);
                await galleryStore.sharePics(photoIds: tag.photoId); // DatabaseManager.instance.sharePics(photoIds: tag.photoId);
                tabsStore.setIsLoading(false);
              },
              child: Image.asset('lib/images/sharepicsico.png'),
            ),
          ],
        ),
      ));
      for (String photoId in tag.photoId) {
        var data = galleryStore.taggedPics.firstWhere((element) => element.photoId == photoId, orElse: () => null);

        if (data == null) {
          print('Found a deleted picture');
          continue;
        }

        totalPics += 1;
        isTitleWidget.add(false);

        slideThumbPhotoIds.add(data.entity.id);
        widgetsArray.add(RepaintBoundary(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: GestureDetector(
                onLongPress: () {
                  print('LongPress');
                  if (tabsStore.multiPicBar == false) {
                    galleryStore.setSelectedPics(
                      photoId: data.entity.id,
                      picIsTagged: true,
                    );
                    tabsStore.setMultiPicBar(true);
                  }
                },
                child: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    if (tabsStore.multiPicBar) {
                      galleryStore.setSelectedPics(
                        photoId: data.entity.id,
                        picIsTagged: true,
                      );
                      print('Pics Selected Length: ${galleryStore.selectedPics.length}');
                      return;
                    }

                    print('Selected photo: ${data.entity.id}');
                    int initialIndex = DatabaseManager.instance.slideThumbPhotoIds.indexOf(data.entity.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoScreen(
                          initialIndex: initialIndex,
                        ),
                      ),
                    );
                    // Call expanded screen directly
                  },
                  child: ImageItem(
                    entity: data.entity,
                    size: 150,
                    backgroundColor: Colors.grey[400],
                    showOverlay: tabsStore.multiPicBar ? true : false,
                    isSelected: galleryStore.selectedPics.contains(data.entity.id),
                  ),
                ),
              ),
            ),
          ),
        ));
      }
    }
//    }
    DatabaseManager.instance.slideThumbPhotoIds = slideThumbPhotoIds;

    return StaggeredGridView.countBuilder(
      controller: scrollControllerThirdTab,
      padding: EdgeInsets.only(
        top: 140 - newPadding,
        right: 6.0,
        left: 6.0,
      ),
      crossAxisCount: 3,
      itemCount: totalTags + totalPics,
      itemBuilder: (BuildContext context, int index) {
        return widgetsArray[index];
      },
      staggeredTileBuilder: (int index) {
        if (isTitleWidget[index]) {
          return StaggeredTile.fit(3);
        }
        return StaggeredTile.count(1, 1);
      },
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabsStore = Provider.of<TabsStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0.0),
//                    constraints: BoxConstraints.expand(),
//                    color: kWhiteColor,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            if (!galleryStore.deviceHasPics) DeviceHasNoPics(),
            if (Provider.of<DatabaseManager>(context).noTaggedPhoto && galleryStore.deviceHasPics)
              TopBar(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('lib/images/notaggedphotos.png'),
                          SizedBox(
                            height: 21.0,
                          ),
                          Text(
                            S.of(context).no_tagged_photos,
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff979a9b),
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(
                            height: 17.0,
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => tabsStore.setCurrentTab(1),
                            child: Container(
                              width: 201.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  S.of(context).start_tagging,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: kWhiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (!Provider.of<DatabaseManager>(context).noTaggedPhoto && galleryStore.deviceHasPics)
              TopBar(
                galleryStore: galleryStore,
                searchEditingController: searchEditingController,
                searchFocusNode: searchFocusNode,
                children: <Widget>[
                  Observer(builder: (_) {
                    if (galleryStore.isSearching) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (galleryStore.searchingTagsKeys.length > 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                              child: TagsList(
                                tagsKeys: galleryStore.searchingTagsKeys.toList(),
                                tagStyle: TagStyle.MultiColored,
                                onTap: (tagName) {
                                  print('do nothing');
                                  galleryStore.removeTagFromSearchFilter();
                                  if (galleryStore.searchingTagsKeys.isEmpty && searchFocusNode.hasFocus == false) {
                                    galleryStore.setIsSearching(false);
                                  }
                                },
                                onPanEnd: () {
                                  galleryStore.removeTagFromSearchFilter();
                                  if (galleryStore.searchingTagsKeys.isEmpty && searchFocusNode.hasFocus == false) {
                                    galleryStore.setIsSearching(false);
                                  }
                                },
                                onDoubleTap: () {
                                  print('do nothing');
                                },
                                showEditTagModal: widget.showEditTagModal,
                              ),
                            ),
                          if (galleryStore.showSearchTagsResults) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                S.of(context).search_results,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff979a9b),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: -0.4099999964237213,
                                ),
                              ),
                            ),
                            if (galleryStore.searchTagsResults.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8.0, bottom: 16.0),
                                child: TagsList(
                                  tagsKeys: galleryStore.searchTagsResults.toList(),
                                  tagStyle: TagStyle.GrayOutlined,
                                  showEditTagModal: widget.showEditTagModal,
                                  onTap: (tagName) {
                                    galleryStore.addTagToSearchFilter();
                                    searchEditingController.clear();
                                    galleryStore.searchResultsTags(searchEditingController.text);
                                  },
                                  onDoubleTap: () {
                                    print('do nothing');
                                  },
                                ),
                              ),
                            if (galleryStore.searchTagsResults.isEmpty)
                              Container(
                                padding: const EdgeInsets.only(top: 10.0, left: 26.0, bottom: 10.0),
                                child: Text(
                                  S.of(context).no_tags_found,
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xff979a9b),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                              )
                          ],
                          Container(
                            height: 1,
                            color: kLightGrayColor,
                          ),
                        ],
                      );
                    }
                    return Expanded(
                      child: _buildTaggedGridView(context),
                    );
                  }),
                ],
              ),
            if (!Provider.of<DatabaseManager>(context).noTaggedPhoto && !hideTitleThirdTab && !galleryStore.isSearching && galleryStore.deviceHasPics)
              Positioned(
                left: 19.0,
                top: topOffsetThirdTab,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).organized_photos_title,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff979a9b),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    if (!hideSubtitleThirdTab)
                      SizedBox(
                        height: 8.0,
                      ),
                    if (!hideSubtitleThirdTab)
                      Text(
                        tabsStore.multiPicBar
                            ? S.of(context).photo_gallery_count(galleryStore.selectedPics.length)
                            : S.of(context).organized_photos_description,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff606566),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
