import 'package:flutter/material.dart';
import 'package:picPics/components/bubble_bottom_bar.dart';
import 'package:picPics/constants.dart';

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
      appBar: AppBar(
        title: Text('Teste'),
      ),
      bottomNavigationBar: BubbleBottomBar(
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
