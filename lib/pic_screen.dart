import 'package:flutter/material.dart';
import 'package:picPics/components/bubble_bottom_bar.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';

class PicScreen extends StatefulWidget {
  static const id = 'pic_screen';

  @override
  _PicScreenState createState() => _PicScreenState();
}

class _PicScreenState extends State<PicScreen> {
  int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: new BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
              image: AssetImage('lib/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset('lib/images/picpicssmallred.png'),
                      Image.asset('lib/images/settings.png'),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: kWhiteColor,
        hasNotch: true,
        opacity: 1.0,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: kPinkColor,
            icon: Image.asset('lib/images/tabgridred.png'),
            activeIcon: Image.asset('lib/images/tabgridwhite.png'),
          ),
          BubbleBottomBarItem(
            backgroundColor: kSecondaryColor,
            icon: Image.asset('lib/images/tabpicpicsred.png'),
            activeIcon: Image.asset('lib/images/tabpicpicswhite.png'),
          ),
          BubbleBottomBarItem(
            backgroundColor: kPrimaryColor,
            icon: Image.asset('lib/images/tabtaggedblue.png'),
            activeIcon: Image.asset('lib/images/tabtaggedwhite.png'),
          ),
        ],
      ),
    );
  }
}
