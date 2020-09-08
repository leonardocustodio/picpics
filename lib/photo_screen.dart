import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/full_image_item.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/widgets/edit_tag_modal.dart';
import 'package:flutter/services.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PhotoScreen extends StatefulWidget {
  static const id = 'photo_screen';

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  PageController galleryPageController;
  GalleryStore galleryStore;

  bool overlay = true;
  bool showSlideshow = false;

  @override
  void initState() {
    super.initState();
    Analytics.sendCurrentScreen(Screen.photo_screen);
  }

  void changeOverlay() {
    if (!overlay) {
      setState(() {
        overlay = true;
      });
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      if (!showSlideshow) {
        setState(() {
          showSlideshow = true;
        });
      } else {
        showSlideshow = false;
        setState(() {
          overlay = false;
        });
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
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
              galleryStore.deleteTag(tagKey: DatabaseManager.instance.selectedTagKey);
              Navigator.of(context).pop();
            },
            onPressedOk: () {
              print('Editing tag - Old name: ${DatabaseManager.instance.selectedTagKey} - New name: ${alertInputController.text}');
              if (tagName != alertInputController.text) {
                galleryStore.editTag(
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
    AssetEntity entity = galleryStore.thumbnailsPics[index].entity;

    return PhotoViewGalleryPageOptions.customChild(
      child: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FullImageItem(
          entity: entity,
          size: MediaQuery.of(context).size.height.toInt(),
          fit: BoxFit.contain,
          backgroundColor: Colors.black,
        ),
      ),
      childSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      onTapUp: (context, details, controller) {
        changeOverlay();
      },
//      initialScale: PhotoViewComputedScale.contained,
//      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
//      maxScale: PhotoViewComputedScale.covered * 1.1,
      minScale: 0.7,
      maxScale: 3.0,
      heroAttributes: PhotoViewHeroAttributes(tag: entity.id),
    );
  }

  Widget _buildThumbnails(BuildContext context, int index) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        galleryStore.setSelectedThumbnail(index);
        galleryPageController.jumpToPage(index);
      },
      child: Container(
        height: 98,
        width: 98,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ImageItem(
          entity: galleryStore.thumbnailsPics[index].entity,
          size: 98,
          fit: BoxFit.cover,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    galleryStore = Provider.of<GalleryStore>(context);
    galleryPageController = PageController(initialPage: galleryStore.selectedThumbnail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              color: Color(0xff101010),
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: galleryStore.thumbnailsPics.length,
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
                  galleryStore.setSelectedThumbnail(index);
                },
                scrollDirection: Axis.horizontal,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset('lib/images/backarrowwithdropshadow.png'),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                onPressed: () {
                                  galleryStore.currentThumbnailPic.sharePic();
                                },
                                child: Image.asset('lib/images/sharebuttonwithdropshadow.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  if (!showSlideshow)
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 2.0,
                          sigmaY: 2.0,
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: 184.0,
                          ),
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
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Observer(builder: (_) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        RichText(
                                          textScaleFactor: 1.0,
                                          text: new TextSpan(
                                            children: [
                                              new TextSpan(
                                                  text: galleryStore.currentThumbnailPic.specificLocation ?? S.of(context).photo_location,
                                                  style: TextStyle(
                                                    fontFamily: 'NotoSans',
                                                    color: kWhiteColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    letterSpacing: -0.4099999964237213,
                                                  )),
                                              new TextSpan(
                                                text: '  ${galleryStore.currentThumbnailPic.generalLocation ?? S.of(context).country}',
                                                style: TextStyle(
                                                  fontFamily: 'NotoSans',
                                                  color: kWhiteColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle: FontStyle.normal,
                                                  letterSpacing: -0.4099999964237213,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          dateFormat(galleryStore.currentThumbnailPic.createdAt),
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            color: kWhiteColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: -0.4099999964237213,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  Observer(builder: (_) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: TagsList(
                                        tagsKeys: galleryStore.currentThumbnailPic.tagsKeys,
                                        tagStyle: TagStyle.MultiColored,
                                        addTagButton: () {
                                          Navigator.pop(context, 'show_keyboard');
                                        },
                                        onTap: (tagName) {
                                          print('ignore click');
                                        },
                                        onDoubleTap: () {
//                                        galleryStore.currentThumbnailPic
//                                        galleryStore.currentPic.removeTagFromPic(tagKey: DatabaseManager.instance.selectedTagKey);
                                        },
                                        onPanEnd: () {
                                          print('teste');
                                        },
                                        showEditTagModal: showEditTagModal,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (showSlideshow)
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
                                    itemCount: galleryStore.thumbnailsPics.length,
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
