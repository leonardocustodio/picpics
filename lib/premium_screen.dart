import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/components/arrow_painter.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';

class PremiumScreen extends StatefulWidget {
  static const id = 'premium_screen';

  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Color(0xffff6666),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFF5FAFA).withOpacity(0.76),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Spacer(
                          flex: 1,
                        ),
                        Image.asset('lib/images/bigpremiumlogo.png'),
                        Text(
                          "Get Premium",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: kPrimaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                        ),
                        Text(
                          "ONE-YEAR PREMIUM ACCOUNT",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: kPrimaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        Spacer(
                          flex: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
                          child: Row(
                            children: <Widget>[
                              Image.asset('lib/images/starrateapp.png'),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "No Ads!",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff707070),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
                          child: Row(
                            children: <Widget>[
                              Image.asset('lib/images/starrateapp.png'),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "Export all galery",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff707070),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
                          child: Row(
                            children: <Widget>[
                              Image.asset('lib/images/starrateapp.png'),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "Infinite Tags",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff707070),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Row(
                            children: <Widget>[
                              Image.asset('lib/images/starrateapp.png'),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "Multiple select to tag",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff707070),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(
                          flex: 5,
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            print('test');
                          },
                          child: Container(
                            height: 63.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 19,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(color: kPinkColor, width: 1.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign R\$ 99,90/year",
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: kPinkColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -0.4099999964237213,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 6,
                                  child: CustomPaint(
                                    painter: ArrowPainter(
                                      strokeColor: kYellowColor,
                                      strokeWidth: 10,
                                      paintingStyle: PaintingStyle.fill,
                                    ),
                                    child: Container(
                                      width: 69.0,
                                      height: 24.0,
                                      child: Center(
                                        child: Text(
                                          "   save 16%",
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            color: Color(0xff606566),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            print('test');
                          },
                          child: Container(
                            height: 44.0,
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                "Sign R\$ 9,90/month",
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
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          "Restaurar compra",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: kPrimaryColor,
                            decoration: TextDecoration.underline,
                            fontFamily: "Lato",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('lib/images/closegrayico.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
