import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/custom_scroll_physics.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/photo_screen.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
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
  bool hideTitleThirdTab = false;

  TextEditingController tagsEditingController = TextEditingController();

  void movedGridPositionThirdTab() {
    var offset = scrollControllerThirdTab.offset;

    if (offset >= 40) {
      setState(() {
        hideTitleThirdTab = true;
      });
    } else if (offset < 40) {
      setState(() {
        hideTitleThirdTab = false;
      });
    }
    offsetThirdTab = scrollControllerThirdTab.offset;
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

  Widget _buildTaggedGridView({bool isFiltered}) {
    print('IsFiltered: $isFiltered');

    var tagsBox = Hive.box('tags');

    scrollControllerThirdTab = ScrollController(initialScrollOffset: offsetThirdTab);
    scrollControllerThirdTab.addListener(() {
      movedGridPositionThirdTab();
    });

    double newPadding = 0.0;
    if (galleryStore.isSearching) {
      newPadding = 86 - offsetThirdTab;
      if (newPadding > 86) {
        newPadding = 86.0;
      }
      if (newPadding < 0) {
        newPadding = 0;
      }
    }

    int totalTags = 0;
    int totalPics = 0;

    List<Widget> widgetsArray = [];
    List<bool> isTitleWidget = [];

    galleryStore.clearPicThumbnails();

    List<String> tagsList = isFiltered ? galleryStore.searchingTagsKeys.toList() : tagsBox.keys.toList().cast<String>();
    print('Tags List: $tagsList');

    if (isFiltered) {
      print('#####!!!##### IS FILTERED !!!!@@@!!!');

      Tag tag;
      if (tagsList.length == 1) {
        tag = tagsBox.get(tagsList[0]);
      }

      totalTags += 1;
      isTitleWidget.add(true);
      widgetsArray.add(_buildTagItem(tag));

      if (galleryStore.filteredPics.length == 0) {
        totalPics += 1;
        isTitleWidget.add(true);
        widgetsArray.add(Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          child: Text(
            S.of(context).search_all_tags_not_found,
            textScaleFactor: 1.0,
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff979a9b),
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
        ));
      }

      for (PicStore pic in galleryStore.filteredPics) {
        totalPics += 1;
        isTitleWidget.add(false);

        if (tagsList.length == 1) {
          galleryStore.addPicToThumbnails(pic);
        }
        widgetsArray.add(_buildPicItem(pic));
      }
    }

    if (tagsList.length > 1) {
      for (String tagKey in tagsList) {
        Tag tag = tagsBox.get(tagKey);

        if (tag.photoId.length == 0) {
          print('skipping ${tag.name} because tag has no pictures...');
          continue;
        }

//      bool oneValidPic = checkTagHasOneValidPic(tag);
//      if (!oneValidPic) {
//        print('skipping ${tag.name} because tag has no valid pictures...');
//        continue;
//      }

        totalTags += 1;
        isTitleWidget.add(true);
        widgetsArray.add(_buildTagItem(tag));
        for (String photoId in tag.photoId) {
          PicStore picStore = galleryStore.taggedPics.firstWhere((element) => element.photoId == photoId, orElse: () => null);

          if (picStore == null) {
            print('Found a deleted picture');
            continue;
          }

          totalPics += 1;
          isTitleWidget.add(false);
          galleryStore.addPicToThumbnails(picStore);
          widgetsArray.add(_buildPicItem(picStore));
        }
      }
    }

    return StaggeredGridView.countBuilder(
      controller: scrollControllerThirdTab,
      padding: EdgeInsets.only(top: 86 - newPadding),
      physics: const CustomScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
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
    );
  }

  Widget _buildTagItem(Tag tag) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            tag != null ? tag.name : S.of(context).all_search_tags,
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

              if (tag != null) {
                await galleryStore.sharePics(photoIds: tag.photoId);
              } else {
                await galleryStore.sharePics(photoIds: galleryStore.filteredPicsKeys);
              }

              tabsStore.setIsLoading(false);
            },
            child: Image.asset('lib/images/sharepicsico.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildPicItem(PicStore picStore) {
    final AssetEntityImageProvider imageProvider = AssetEntityImageProvider(picStore.entity, isOriginal: false);

    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          Widget loader;
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              loader = const ColoredBox(color: kGreyPlaceholder);
              break;
            case LoadState.completed:
              loader = FadeImageBuilder(
                child: () {
                  return GestureDetector(
                    onLongPress: () {
                      print('LongPress');
                      if (tabsStore.multiPicBar == false) {
                        galleryStore.setSelectedPics(
                          photoId: picStore.photoId,
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
                            photoId: picStore.photoId,
                            picIsTagged: true,
                          );
                          print('Pics Selected Length: ${galleryStore.selectedPics.length}');
                          return;
                        }

                        print('Selected photo: ${picStore.photoId}');
                        galleryStore.setCurrentPic(picStore);
                        galleryStore.setInitialSelectedThumbnail(picStore);
                        Navigator.pushNamed(context, PhotoScreen.id);
                      },
                      child: Observer(builder: (_) {
                        Widget image = Positioned.fill(
                          child: RepaintBoundary(
                            child: state.completedWidget,
                          ),
                        );
                        if (tabsStore.multiPicBar) {
                          if (galleryStore.selectedPics.contains(picStore.photoId)) {
                            return Stack(
                              children: [
                                image,
                                Container(
                                  constraints: BoxConstraints.expand(),
                                  decoration: BoxDecoration(
                                    color: kSecondaryColor.withOpacity(0.3),
                                    border: Border.all(
                                      color: kSecondaryColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 8.0,
                                  top: 6.0,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      gradient: kSecondaryGradient,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Image.asset('lib/images/checkwhiteico.png'),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Stack(
                            children: [
                              image,
                              Positioned(
                                left: 8.0,
                                top: 6.0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: kGrayColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Stack(
                          children: [
                            image,
                          ],
                        );
                      }),
                    ),
                  );
                }(),
              );
              break;
            case LoadState.failed:
              loader = Container();
              break;
          }
          return loader;
        },
      ),
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
            Observer(builder: (_) {
              if (!galleryStore.deviceHasPics) {
                return DeviceHasNoPics();
              } else if (galleryStore.taggedPics.length == 0 && galleryStore.deviceHasPics) {
                return TopBar(
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
                );
              } else if (galleryStore.taggedPics.length > 0 && galleryStore.deviceHasPics) {
                return TopBar(
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
                                  tags: galleryStore.searchingTags.toList(),
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
                                    tags: galleryStore.searchTagsResults.toList(),
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
                                    onPanEnd: () {
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
                      return Container();
                    }),
                    Expanded(
                      child: _buildTaggedGridView(isFiltered: galleryStore.searchingTagsKeys.length > 0),
                    ),
                  ],
                );
              }
              return Container();
            }),
            Observer(builder: (_) {
              if (galleryStore.taggedPics.length > 0 && !hideTitleThirdTab && !galleryStore.isSearching && galleryStore.deviceHasPics) {
                return Positioned(
                  left: 19.0,
                  top: 64.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tabsStore.multiPicBar ? S.of(context).photo_gallery_count(galleryStore.selectedPics.length) : S.of(context).organized_photos_title,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff979a9b),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }),
          ],
        ),
      ),
    );
  }
}
