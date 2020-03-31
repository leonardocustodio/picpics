import 'package:flutter/material.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/pic_screen.dart';

class PhotoScreen extends StatefulWidget {
  static const id = 'photo_screen';

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ImageItem(
            entity: DatabaseManager.instance.selectedPhoto,
            size: MediaQuery.of(context).size.height.toInt(),
          ),
          Container(
            constraints: BoxConstraints.expand(),
            child: Column(
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
                                      text: "Ilha Bela",
                                      style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        color: kWhiteColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: -0.4099999964237213,
                                      )),
                                  new TextSpan(
                                    text: "  Brasil - SP",
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
                              "18 de novembro de 1990",
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
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 61.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                gradient: kYellowGradient,
                                borderRadius: BorderRadius.circular(19.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Ursos',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: kWhiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
