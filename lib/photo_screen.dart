import 'package:flutter/material.dart';
import 'package:picPics/admob_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/image_item.dart';
import 'package:picPics/widgets/tags_list.dart';

class PhotoScreen extends StatefulWidget {
  static const id = 'photo_screen';

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  DateTime createdDate;
  String dateString;
  Pic picInfo;

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
        '',
        [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            color: Color(0xff101010),
            child: ImageItem(
              entity: DatabaseManager.instance.selectedPhoto,
              size: MediaQuery.of(context).size.height.toInt(),
              fit: BoxFit.contain,
              backgroundColor: Colors.black,
            ),
          ),
          Column(
            children: <Widget>[
              Spacer(),
              Container(
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
                          onTap: () {
                            print('ignore click');
                          },
                          showEditTagModal: () {
                            print('ignore');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
