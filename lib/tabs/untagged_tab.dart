import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/settings_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:provider/provider.dart';

class UntaggedTab extends StatefulWidget {
  static const id = 'untagged_tab';

  @override
  _UntaggedTabState createState() => _UntaggedTabState();
}

class _UntaggedTabState extends State<UntaggedTab> {
  TabsStore tabsStore;
  GalleryStore galleryStore;

  ScrollController scrollControllerFirstTab;

  double offsetFirstTab = 0.0;
  double topOffsetFirstTab = 64.0;
  bool hideSubtitleFirstTab = false;

  TextEditingController tagsEditingController = TextEditingController();

  void movedGridPositionFirstTab() {
    var offset = scrollControllerFirstTab.offset;

    if (offset >= 112) {
      setState(() {
        topOffsetFirstTab = 5;
        hideSubtitleFirstTab = true;
      });
    } else if (offset >= 52) {
      setState(() {
        topOffsetFirstTab = 64.0 - (offset - 52.0);
        hideSubtitleFirstTab = false;
      });
    } else if (offset <= 0) {
      setState(() {
        topOffsetFirstTab = 64;
        hideSubtitleFirstTab = false;
      });
    }

    offsetFirstTab = scrollControllerFirstTab.offset;
    print(scrollControllerFirstTab.offset);
  }

  Widget _buildGridView() {
    scrollControllerFirstTab = ScrollController(initialScrollOffset: offsetFirstTab);
    scrollControllerFirstTab.addListener(() {
      movedGridPositionFirstTab();
    });

    return StaggeredGridView.countBuilder(
      controller: scrollControllerFirstTab,
      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 140.0),
      crossAxisCount: 3,
      itemCount: galleryStore.isLoaded ? galleryStore.untaggedPics.length : 0,
      itemBuilder: _buildItem,
      staggeredTileBuilder: (int index) {
//        if (DatabaseManager.instance.picHasTag[index] == true) return StaggeredTile.count(0, 0);
        return StaggeredTile.count(1, 1);
      },
//      mainAxisSpacing: 5.0,
//      crossAxisSpacing: 5.0,
    );
//  }
  }

  Widget _buildItem(BuildContext context, int index) {
//    if (DatabaseManager.instance.picHasTag[index] == true) {
//      print('This pic has tag returning empty container');
//      return Container();
//    }

    print('Item Count: ${galleryStore.untaggedPics.length}');
    var data = galleryStore.untaggedPics[index].entity;
//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;
    print('Build Item: $index');

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onLongPress: () {
            print('LongPress');
            if (tabsStore.multiPicBar == false) {
              galleryStore.setSelectedPics(
                photoId: data.id,
                picIsTagged: false,
              );
              tabsStore.setMultiPicBar(true);
            }
          },
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (tabsStore.multiPicBar) {
                galleryStore.setSelectedPics(
                  photoId: data.id,
                  picIsTagged: false,
                );
                print('Pics Selected Length: ${galleryStore.selectedPics.length}');
                return;
              }

              tagsEditingController.text = '';
              galleryStore.setCurrentPic(source: PicSource.UNTAGGED, picIndex: index);
              tabsStore.setModalCard(true);
              galleryStore.setSelectedThumbnail(index);
            },
            child: ImageItem(
              entity: data,
              size: 150,
              backgroundColor: Colors.grey[400],
              showOverlay: tabsStore.multiPicBar ? true : false,
              isSelected: galleryStore.selectedPics.contains(data.id),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    galleryStore = Provider.of<GalleryStore>(context);
    tabsStore = Provider.of<TabsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: kWhiteColor,
      child: SafeArea(
        child: Observer(builder: (_) {
          if (!galleryStore.deviceHasPics) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        onPressed: () {
                          Navigator.pushNamed(context, SettingsScreen.id);
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                DeviceHasNoPics(),
              ],
            );
          } else if (galleryStore.isLoaded && galleryStore.deviceHasPics) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        onPressed: () {
                          Navigator.pushNamed(context, SettingsScreen.id);
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16.0,
                  top: topOffsetFirstTab,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        S.of(context).photo_gallery_title,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff979a9b),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      if (!hideSubtitleFirstTab)
                        SizedBox(
                          height: 8.0,
                        ),
                      if (!hideSubtitleFirstTab)
                        Text(
                          tabsStore.multiPicBar ? S.of(context).photo_gallery_count(galleryStore.selectedPics.length) : S.of(context).photo_gallery_description,
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
                Padding(
                  padding: const EdgeInsets.only(top: 48.0, bottom: 0.0),
                  child: GestureDetector(
//                              onScaleUpdate: (update) {
//                                print(update.scale);
//                                DatabaseManager.instance.gridScale(update.scale);
//                              },
                    child: _buildGridView(),
                  ),
                ),
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }
}
