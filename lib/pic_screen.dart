import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/add_location.dart';
import 'package:picPics/components/bubble_bottom_bar.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';
import 'package:picPics/photo_screen.dart';
import 'package:picPics/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:picPics/database_manager.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/lru_cache.dart';
import 'package:picPics/throttle.dart';

part 'image_item.dart';

class PicScreen extends StatefulWidget {
  static const id = 'pic_screen';

  @override
  _PicScreenState createState() => _PicScreenState();
}

class _PicScreenState extends State<PicScreen> {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  int currentIndex;
  bool showTutorial = false;
  bool edittingTags = false;

  int swiperIndex = 0;
  SwiperController swiperController = new SwiperController();

  double topOffset = 64.0;
  bool hideSubtitle = false;
  bool noTaggedPhoto = true;

  Throttle _changeThrottle;

  void changeIndex() {
    print('teste');
  }

  void movedGridPosition() {
    var offset = scrollController.offset;

    if (offset >= 117) {
      setState(() {
        topOffset = 0;
        hideSubtitle = true;
      });
    } else if (offset >= 52) {
      setState(() {
        topOffset = 64.0 - (offset - 52.0);
        hideSubtitle = false;
      });
    } else if (offset <= 0) {
      setState(() {
        topOffset = 64;
        hideSubtitle = false;
      });
    }

    print(scrollController.offset);
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 1;

    scrollController.addListener(() {
      movedGridPosition();
    });

    _changeThrottle = Throttle(onCall: _onAssetChange);
    PhotoManager.addChangeCallback(_changeThrottle.call);
    PhotoManager.startChangeNotify();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    PhotoManager.removeChangeCallback(_changeThrottle.call);
    PhotoManager.stopChangeNotify();
    _changeThrottle.dispose();
    super.dispose();
  }

  void _onAssetChange() {
    print('asset changed');
//    _onPhotoRefresh();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget _buildGridView() {
    final noMore = DatabaseManager.instance.assetProvider.noMore;
    final count = DatabaseManager.instance.assetProvider.count + (noMore ? 0 : 1);

    print('noMore: $noMore - count: $count');

    return GridView.builder(
      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 140.0),
      controller: scrollController,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: count,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildPhotoSlider(BuildContext context, int index) {
    final noMore = DatabaseManager.instance.assetProvider.noMore;
    print('No More: $noMore - index $index - Count ${DatabaseManager.instance.assetProvider.count}');

    if (!noMore && index == DatabaseManager.instance.assetProvider.count) {
      print('loading more');
      _loadMore();
      print('returning container');
      return Container();
      return _buildLoading();
    }

    print('photo slides index: $index');
    var data = DatabaseManager.instance.assetProvider.data[index];

    print('photo id: ${data.id}');

    DateTime createdDate = data.createDateTime;
    String dateString = DatabaseManager.instance.formatDate(createdDate);

    double latitude = data.latitude;
    double longitude = data.longitude;

    print('lat: $latitude - long: $longitude');

//    if (latitude == 0.0 && longitude == 0.0) {
//      DatabaseManager.instance.currentPhotoCity = 'Local da foto';
//      DatabaseManager.instance.currentPhotoState = ' estado';
//    } else if (DatabaseManager.instance.lastLocationRequest[0] == latitude &&
//        DatabaseManager.instance.lastLocationRequest[1] == longitude) {
//      print('skipping location request');
//    } else {
//      DatabaseManager.instance.findLocation(latitude, longitude);
//    }

    return Container(
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
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: ImageItem(
                    entity: data,
                    size: 600,
                    backgroundColor: Colors.grey[400],
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 6.0,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                    onPressed: () {
                      DatabaseManager.instance.selectedPhoto = DatabaseManager.instance.assetProvider.data[index];
                      Navigator.pushNamed(context, PhotoScreen.id);
                    },
                    child: Image.asset('lib/images/expandphotoico.png'),
                  ),
                ),
              ],
            ),
          ),
          if (edittingTags == false)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          DatabaseManager.instance.selectedPhoto = data;
                          Navigator.pushNamed(context, AddLocationScreen.id);
                        },
                        child: RichText(
                          text: new TextSpan(
                            children: [
                              new TextSpan(
                                text: 'Local da foto',
//                        text: Provider.of<DatabaseManager>(context).currentPhotoCity,
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
                                text: ' estado',
//                        text: ' ${Provider.of<DatabaseManager>(context).currentPhotoState}',
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
                      ),
                      Text(
                        dateString,
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
                  Row(
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          print('add tag');
                          setState(() {
                            edittingTags = true;
                          });
                        },
                        child: Container(
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
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
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
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
                ],
              ),
            ),
          if (edittingTags == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(241, 243, 245, 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: TextField(
                              onEditingComplete: () {
                                print('return');
                                setState(() {
                                  edittingTags = false;
                                });
                              },
                              keyboardType: TextInputType.multiline,
                              textAlignVertical: TextAlignVertical.center,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff606566),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(right: 2.0),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                prefixIcon: Image.asset('lib/images/typetagnameico.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Tags ativas",
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xff979a9b),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.4099999964237213,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    height: 30.0,
                    width: 71.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    child: Center(
                      child: Text(
                        "Comida",
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
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Sugestões de tags",
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xff979a9b),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.4099999964237213,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
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
            ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final noMore = DatabaseManager.instance.assetProvider.noMore;
    if (!noMore && index == DatabaseManager.instance.assetProvider.count) {
      print('loading more');
      _loadMore();
      return _buildLoading();
    }

//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;
    var data = DatabaseManager.instance.assetProvider.data[index];

    print('loading photo index: $index');

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: ImageItem(
            entity: data,
            size: 150,
            backgroundColor: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey[400],
        ),
      ),
    );
  }

  _loadMore() async {
    print('calling db loadmore');
    await DatabaseManager.instance.loadMore();
    print('calling set state');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final noMore = DatabaseManager.instance.assetProvider.noMore;
    final count = DatabaseManager.instance.assetProvider.count;
    print('first build!!!');
    print('!!!! noMore: $noMore - count: $count');

    var screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Stack(
              children: <Widget>[
                if (!Provider.of<DatabaseManager>(context).hasGalleryPermission)
                  Container(
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
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.pushNamed(context, SettingsScreen.id);
                                  },
                                  child: Image.asset('lib/images/settings.png'),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Image.asset('lib/images/nogalleryauth.png'),
                                ),
                                SizedBox(
                                  height: 21.0,
                                ),
                                Text(
                                  "Para começarmos a organizar suas fotos, precismos de autorização para acessá-las",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xff979a9b),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                SizedBox(
                                  height: 17.0,
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    PhotoManager.openSetting();
                                  },
                                  child: Container(
                                    width: 201.0,
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      gradient: kPrimaryGradient,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Permissões de acesso",
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
                        ],
                      ),
                    ),
                  ),
                if (currentIndex == 0 && Provider.of<DatabaseManager>(context).hasGalleryPermission)
                  Container(
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
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.pushNamed(context, SettingsScreen.id);
                                  },
                                  child: Image.asset('lib/images/settings.png'),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 16.0,
                            top: topOffset,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Galeria de fotos",
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xff979a9b),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                if (!hideSubtitle)
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                if (!hideSubtitle)
                                  Text(
                                    "Fotos ainda não organizadas",
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
                          Padding(
                            padding: const EdgeInsets.only(top: 48.0),
                            child: _buildGridView(),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (currentIndex == 1 && Provider.of<DatabaseManager>(context).hasGalleryPermission)
                  Container(
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
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.pushNamed(context, SettingsScreen.id);
                                  },
                                  child: Image.asset('lib/images/settings.png'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Swiper(
                              loop: true,
                              itemCount: count == 0 ? 1 : count,
                              itemBuilder: (BuildContext context, int index) {
                                print('calling index $index');
                                return _buildPhotoSlider(context, index);
                              },
                              layout: SwiperLayout.CUSTOM,
                              itemWidth: screenWidth,
                              customLayoutOption:
                                  CustomLayoutOption(startIndex: -1, stateCount: 3).addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate(
                                [
                                  Offset(-screenWidth - screenWidth / 2, -40.0),
                                  Offset(0.0, 0.0),
                                  Offset(screenWidth + screenWidth / 2, -40.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (currentIndex == 2 && Provider.of<DatabaseManager>(context).hasGalleryPermission)
                  Container(
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
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.pushNamed(context, SettingsScreen.id);
                                  },
                                  child: Image.asset('lib/images/settings.png'),
                                ),
                              ],
                            ),
                          ),
                          if (noTaggedPhoto)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  Image.asset('lib/images/notaggedphotos.png'),
                                  SizedBox(
                                    height: 21.0,
                                  ),
                                  Text(
                                    "Você ainda não tem nenhuma foto\ntaggeada.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff979a9b),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 17.0,
                                  ),
                                  CupertinoButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      changePage(1);
                                    },
                                    child: Container(
                                      width: 201.0,
                                      height: 44.0,
                                      decoration: BoxDecoration(
                                        gradient: kPrimaryGradient,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Começar a taggear",
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
                          if (!noTaggedPhoto)
                            Positioned(
                              left: 16.0,
                              top: topOffset,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Galeria de fotos",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff979a9b),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  if (!hideSubtitle)
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                  if (!hideSubtitle)
                                    Text(
                                      "Fotos ainda não organizadas",
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
                          if (!noTaggedPhoto)
                            Padding(
                              padding: const EdgeInsets.only(top: 48.0),
                              child: GridView.builder(
                                padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 140.0),
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                itemCount: 20,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
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
