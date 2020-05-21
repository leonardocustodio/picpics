import 'dart:ui';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/admob_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/pic_screen.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/widgets/edit_tag_modal.dart';
import 'package:flutter/services.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/asset_provider.dart';

class GalleryScreen extends StatefulWidget {
  static const id = 'gallery_screen';

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  PageController galleryPageController = PageController(initialPage: 0);
  DateTime createdDate;
  Pic picInfo;

  bool overlay = true;

  @override
  void initState() {
    super.initState();
    Ads.setScreen(GalleryScreen.id);
  }

  void changeOverlay() {
    setState(() {
      overlay = !overlay;
    });
    if (!overlay) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }

  showEditTagModal() {
    if (DatabaseManager.instance.selectedTagKey != '') {
      TextEditingController alertInputController = TextEditingController();
      String tagName = DatabaseManager.instance.getTagName(DatabaseManager.instance.selectedTagKey);
      alertInputController.text = tagName;

      print('showModal');
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return EditTagModal(
            alertInputController: alertInputController,
            onPressedDelete: () {
              DatabaseManager.instance.deleteTag(tagKey: DatabaseManager.instance.selectedTagKey);
              Navigator.of(context).pop();
            },
            onPressedOk: () {
              print('Editing tag - Old name: ${DatabaseManager.instance.selectedTagKey} - New name: ${alertInputController.text}');
              if (tagName != alertInputController.text) {
                DatabaseManager.instance.editTag(
                  oldTagKey: DatabaseManager.instance.selectedTagKey,
                  newName: alertInputController.text,
                );
              }
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  String dateFormat(DateTime dateTime) {
    var formatter = DateFormat.yMMMEd();
    return formatter.format(dateTime);
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    String photoId = DatabaseManager.instance.searchPhotosIds[index];

    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    AssetEntity entity = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);

    return PhotoViewGalleryPageOptions.customChild(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ImageItem(
          entity: entity,
          size: MediaQuery.of(context).size.height.toInt(),
          fit: BoxFit.contain,
          backgroundColor: Colors.black,
        ),
      ),
      childSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: entity.id),
    );
  }

  Widget _buildThumbnails(BuildContext context, int index) {
    return Container(
      height: 98,
      width: 98,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ImageItem(
        entity: getEntity(DatabaseManager.instance.searchPhotosIds[index]),
        size: 98,
        fit: BoxFit.cover,
        backgroundColor: Colors.black,
      ),
    );
  }

  AssetEntity getEntity(String photoId) {
    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    AssetEntity entity = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);
    return entity;
  }

  @override
  Widget build(BuildContext context) {
//    createdDate = Provider.of<DatabaseManager>(context).selectedPhoto.createDateTime;
//    picInfo = Provider.of<DatabaseManager>(context).getPicInfo(DatabaseManager.instance.selectedPhoto.id);
//
//    if (picInfo == null) {
//      picInfo = Pic(
//        DatabaseManager.instance.selectedPhoto.id,
//        DatabaseManager.instance.selectedPhoto.createDateTime,
//        DatabaseManager.instance.selectedPhoto.latitude,
//        DatabaseManager.instance.selectedPhoto.longitude,
//        DatabaseManager.instance.selectedPhoto.latitude,
//        DatabaseManager.instance.selectedPhoto.longitude,
//        null,
//        null,
//        [],
//      );
//    }

    //                FutureBuilder<File>(
//                  future: DatabaseManager.instance.selectedPhoto.file,
//                  builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//                    var futureData = snapshot.data;
//                    if (snapshot.connectionState == ConnectionState.done && futureData != null) {
//                      return PhotoView(
//                        imageProvider: FileImage(futureData),
//                      );
//                    }
//                    return Container();
//                  },
//                ),
//              ),

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                changeOverlay();
              },
              child: Container(
                constraints: BoxConstraints.expand(),
                color: Color(0xff101010),
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: DatabaseManager.instance.searchPhotosIds.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                      ),
                    ),
                  ),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  pageController: galleryPageController,
                  onPageChanged: (index) {
                    print('page changed');
                  },
                  scrollDirection: Axis.horizontal,
                ),
//                PhotoView.customChild(
//                  initialScale: 1.0,
//                  minScale: 1.0,
//                  child: ImageItem(
//                    entity: DatabaseManager.instance.selectedPhoto,
//                    size: MediaQuery.of(context).size.height.toInt(),
//                    fit: BoxFit.contain,
//                    backgroundColor: Colors.black,
//                  ),
//                ),
              ),
            ),
            if (overlay)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2.0,
                        sigmaY: 2.0,
                      ),
                      child: Container(
                        decoration: new BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7).withOpacity(0.37).withOpacity(0.3),
                              Colors.black.withOpacity(1.0).withOpacity(0.37).withOpacity(0.3)
                            ],
                            stops: [0, 0.40625],
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Row(
                            children: <Widget>[
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                onPressed: () {
                                  Ads.setScreen(PicScreen.id, DatabaseManager.instance.currentTab);
                                  Navigator.pop(context);
                                },
                                child: Image.asset('lib/images/backarrowwithdropshadow.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  ClipRect(
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7).withOpacity(0.37).withOpacity(0.3),
                            Colors.black.withOpacity(1.0).withOpacity(0.37).withOpacity(0.3)
                          ],
                          stops: [0, 0.40625],
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                height: 98,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: _buildThumbnails,
                                  itemCount: DatabaseManager.instance.searchPhotosIds.length,
                                  padding: const EdgeInsets.only(left: 8.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
