import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picPics/admob_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/pic_screen.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:picPics/widgets/edit_tag_modal.dart';
import 'package:flutter/services.dart';
import 'package:picPics/generated/l10n.dart';

class PhotoScreen extends StatefulWidget {
  static const id = 'photo_screen';

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  DateTime createdDate;
  String dateString;
  Pic picInfo;

  bool overlay = true;

  @override
  void initState() {
    super.initState();
    Ads.setScreen(PhotoScreen.id);

    createdDate = DatabaseManager.instance.selectedPhoto.createDateTime;
    dateString = DatabaseManager.instance.formatDate(createdDate);

    picInfo = DatabaseManager.instance.getPicInfo(DatabaseManager.instance.selectedPhoto.id);

    if (picInfo == null) {
      picInfo = Pic(
        DatabaseManager.instance.selectedPhoto.id,
        DatabaseManager.instance.selectedPhoto.createDateTime,
        DatabaseManager.instance.selectedPhoto.latitude,
        DatabaseManager.instance.selectedPhoto.longitude,
        DatabaseManager.instance.selectedPhoto.latitude,
        DatabaseManager.instance.selectedPhoto.longitude,
        null,
        null,
        [],
      );
    }
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
    if (DatabaseManager.instance.selectedEditTag != '') {
      TextEditingController alertInputController = TextEditingController();
      alertInputController.text = DatabaseManager.instance.selectedEditTag;

      print('showModal');
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return EditTagModal(
            alertInputController: alertInputController,
            onPressedDelete: () {
              DatabaseManager.instance.removeTag(DatabaseManager.instance.selectedEditTag);
              Navigator.of(context).pop();
            },
            onPressedOk: () {
              print('Editing tag - Old name: ${DatabaseManager.instance.selectedEditTag} - New name: ${alertInputController.text}');
              DatabaseManager.instance.editTag(DatabaseManager.instance.selectedEditTag, alertInputController.text);
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: PhotoView.customChild(
                  initialScale: 1.0,
                  minScale: 1.0,
                  child: ImageItem(
                    entity: DatabaseManager.instance.selectedPhoto,
                    size: MediaQuery.of(context).size.height.toInt(),
                    fit: BoxFit.contain,
                    backgroundColor: Colors.black,
                  ),
                ),
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
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2.0,
                        sigmaY: 2.0,
                      ),
                      child: Container(
                        height: 184.0,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                      text: new TextSpan(
                                        children: [
                                          new TextSpan(
                                              text: 'Local da foto',
                                              style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                color: kWhiteColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                letterSpacing: -0.4099999964237213,
                                              )),
                                          new TextSpan(
                                            text: '  estado',
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
                                      dateString,
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: TagsList(
                                    tags: picInfo.tags,
                                    tagStyle: TagStyle.MultiColored,
                                    addTagButton: () {
                                      Ads.setScreen(PicScreen.id, DatabaseManager.instance.currentTab);
                                      Navigator.pop(context, 'show_keyboard');
                                    },
                                    onTap: () {
                                      print('ignore click');
                                    },
                                    onDoubleTap: () {
                                      print('ignore click');
                                    },
                                    showEditTagModal: showEditTagModal,
                                  ),
                                ),
                              ],
                            ),
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
