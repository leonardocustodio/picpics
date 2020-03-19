import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/components/bubble_bottom_bar.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:picPics/database_manager.dart';

class PicScreen extends StatefulWidget {
  static const id = 'pic_screen';

  @override
  _PicScreenState createState() => _PicScreenState();
}

class _PicScreenState extends State<PicScreen> {
  int currentIndex;
  bool showTutorial = true;

  int swiperIndex = 0;
  SwiperController swiperController = new SwiperController();

  void changeIndex() {
    print('teste');
  }

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
    return Stack(
      children: <Widget>[
        Scaffold(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage('lib/images/foto.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8.0,
                                    right: 16.0,
                                    child: Image.asset('lib/images/expandphotoico.png'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 29.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                    text: new TextSpan(
                                      children: [
                                        new TextSpan(
                                          text: "Local da foto",
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            color: Color(0xff606566),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: -0.4099999964237213,
                                          ),
                                        ),
                                        new TextSpan(
                                          text: "  estado",
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            color: Color(0xff606566),
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
                                    "Ontem",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff606566),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: -0.4099999964237213,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Add Tag",
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            color: Color(0xffff6666),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: -0.4099999964237213,
                                          ),
                                        ),
                                        Image.asset('lib/images/plusredico.png'),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.0),
                                      border: Border.all(color: kSecondaryColor, width: 1.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Tags recentes",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xff979a9b),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: -0.4099999964237213,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Ursos",
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Color(0xff979a9b),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: -0.4099999964237213,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.0),
                                      border: Border.all(
                                        color: Color(0xff979a9b),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
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
        ),
        if (showTutorial == true)
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
        if (showTutorial == true)
          Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                height: 609.0,
                width: 343.0,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Bem-vindo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff979a9b),
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.4099999964237213,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Expanded(
                        child: new Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            String text = '';
                            Image image;

                            if (index == 0) {
                              text = 'Trazemos diariamente um pacote para você organizar aos poucos sua biblioteca.';
                              image = Image.asset('lib/images/tutorialfirstimage.png');
                            } else if (index == 1) {
                              text = 'Organize suas fotos adicionando tags, como “família”, “pets” ou o quê você quiser.';
                              image = Image.asset('lib/images/tutorialsecondimage.png');
                            } else {
                              text = 'Depois de adicionar as tags na sua foto, basta fazer um swipe para ir para a próxima';
                              image = Image.asset('lib/images/tutorialthirdimage.png');
                            }

                            return Column(
                              children: <Widget>[
                                image,
                                SizedBox(
                                  height: 28.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff707070),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: 3,
                          controller: swiperController,
                          onIndexChanged: (index) {
                            setState(() {
                              swiperIndex = index;
                            });
                          },
                          pagination: new SwiperCustomPagination(
                            builder: (BuildContext context, SwiperPluginConfig config) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 8.0,
                                      width: 8.0,
                                      decoration: BoxDecoration(
                                        color: config.activeIndex == 0 ? kSecondaryColor : kGrayColor,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    Container(
                                      height: 8.0,
                                      width: 8.0,
                                      margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                                      decoration: BoxDecoration(
                                        color: config.activeIndex == 1 ? kSecondaryColor : kGrayColor,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    Container(
                                      height: 8.0,
                                      width: 8.0,
                                      decoration: BoxDecoration(
                                        color: config.activeIndex == 2 ? kSecondaryColor : kGrayColor,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 17.0,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          if (swiperIndex == 2) {
                            setState(() {
                              showTutorial = false;
                            });
                            return;
                          }
                          swiperController.next(animation: true);
                        },
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 44.0,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              swiperIndex == 2 ? 'Fechar' : 'Próximo',
                              textAlign: TextAlign.center,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
