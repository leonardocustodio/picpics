import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/settings_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/model/pic.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:provider/provider.dart';

class UntaggedTab extends StatefulWidget {
  static const id = 'untagged_tab';

  final AssetPathProvider pathProvider;
  final bool deviceHasNoPics;

  final Function showPhotoCardModal;

  UntaggedTab({
    @required this.pathProvider,
    @required this.showPhotoCardModal,
    this.deviceHasNoPics = false,
  });

  @override
  _UntaggedTabState createState() => _UntaggedTabState();
}

class _UntaggedTabState extends State<UntaggedTab> {
  ScrollController scrollControllerFirstTab;

  double offsetFirstTab = 0.0;
  double topOffsetFirstTab = 64.0;
  bool hideSubtitleFirstTab = false;

  BuildContext multiPicContext;
  bool showingMultiTagSheet = false;

  List<int> picsSelected = [];
  List<String> multiPicTagKeys = [];

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

    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    int itemCount = pathProvider.isLoaded ? pathProvider.orderedList.length : 0;
    print('#!#@#!# Number of photos: $itemCount');

    return StaggeredGridView.countBuilder(
      controller: scrollControllerFirstTab,
      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 140.0),
      crossAxisCount: 3,
      itemCount: itemCount,
      itemBuilder: _buildItem,
      staggeredTileBuilder: (int index) {
        if (DatabaseManager.instance.picHasTag[index] == true) return StaggeredTile.count(0, 0);
        return StaggeredTile.count(1, 1);
      },
//      mainAxisSpacing: 5.0,
//      crossAxisSpacing: 5.0,
    );
//  }
  }

  Widget _buildItem(BuildContext context, int index) {
    if (DatabaseManager.instance.picHasTag[index] == true) {
      print('This pic has tag returning empty container');
      return Container();
    }

    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    print('pathProvider itemcount: ${pathProvider.list.length}');

    var data = pathProvider.orderedList[index];

//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;
    print('Build Item: $index');

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onLongPress: () {
            print('LongPress');
            if (DatabaseManager.instance.multiPicBar == false) {
              picsSelected.add(index);
              multiPicContext = context;
              DatabaseManager.instance.setMultiPicBar(true);
            }
          },
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (DatabaseManager.instance.multiPicBar) {
                if (picsSelected.contains(index)) {
                  setState(() {
                    picsSelected.remove(index);
                  });
                } else {
                  setState(() {
                    picsSelected.add(index);
                  });
                }
                print('Pics Selected Length: ${picsSelected.length}');
                return;
              }

              Pic picInfo = DatabaseManager.instance.getPicInfo(data.id);
              tagsEditingController.text = '';

              if (picInfo == null) {
                picInfo = Pic(
                  data.id,
                  data.createDateTime,
                  data.latitude,
                  data.longitude,
                  null,
                  null,
                  null,
                  null,
                  [],
                );
              }

              DatabaseManager.instance.tagsSuggestions(
                tagsEditingController.text,
                data.id,
                excludeTags: picInfo.tags,
                notify: false,
              );

              print('PicTags: ${picInfo.tags}');

              DatabaseManager.instance.selectedPhotoData = data;
              DatabaseManager.instance.selectedPhotoPicInfo = picInfo;
              DatabaseManager.instance.selectedPhotoIndex = index;

              widget.showPhotoCardModal();
            },
            child: ImageItem(
              entity: data,
              size: 150,
              backgroundColor: Colors.grey[400],
              showOverlay: DatabaseManager.instance.multiPicBar ? true : false,
              isSelected: picsSelected.contains(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: kWhiteColor,
      child: SafeArea(
        child: Stack(
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
            if (widget.deviceHasNoPics) DeviceHasNoPics(),
            if (widget.pathProvider != null && widget.pathProvider.isLoaded != null && !widget.deviceHasNoPics)
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
                        Provider.of<DatabaseManager>(context).multiPicBar
                            ? S.of(context).photo_gallery_count(picsSelected.length)
                            : S.of(context).photo_gallery_description,
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
            if (widget.pathProvider != null && widget.pathProvider.isLoaded != null && !widget.deviceHasNoPics)
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
        ),
      ),
    );
  }
}
