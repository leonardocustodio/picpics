import 'dart:async';
import 'package:flutter/material.dart';
import 'package:picPics/add_location.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/photo_screen.dart';
import 'package:picPics/pic_screen.dart';
import 'package:picPics/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:picPics/login_screen.dart';
import 'package:picPics/database_manager.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PicAdapter());
  Hive.registerAdapter(TagAdapter());

  var userBox = await Hive.openBox('user');
  var picsBox = await Hive.openBox('pics');
  var tagsBox = await Hive.openBox('tags');

  if (userBox.length == 0) {
    print('creating user entry...');
    User user = User('userId', 'leonardo@custodio.me', 'pass', true, 20, 21, 30, true, []);
    userBox.add(user);
  }

  DatabaseManager.instance.loadRecentTags();
//  DatabaseManager.instance.tagsSuggestions('');
  DatabaseManager.instance.loadTags();
  DatabaseManager.instance.loadPics();

  // Open boxes
//  var pics = await Hive.openBox('Pictures');
//  var tags = await Hive.openBox('Tags');

  void setupPathList() async {
    List<AssetPathEntity> pathList;

    pathList = await PhotoManager.getAssetPathList(
      hasAll: true,
      onlyAll: true,
      type: RequestType.image,
    );

    print('pathList: $pathList');

    DatabaseManager.instance.assetProvider.current = pathList[0];
    DatabaseManager.instance.loadFirstPhotos();
  }

  setupPathList();

//  Crashlytics.instance.enableInDevMode = true;
//  FlutterError.onError = Crashlytics.instance.recordFlutterError;
//
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  String uid = prefs.getString('uid');
//
//  if (uid != null) {
//    await DatabaseManager.instance.getUser(uid: uid);
//  }
//
//  DatabaseManager.instance.getCards();
//  DatabaseManager.instance.getAreas();

//  runZoned(() {
  runApp(
    PicPicsApp(
      initialRoute: LoginScreen.id,
    ),
  );
//  }, onError: Crashlytics.instance.recordError);
}

class PicPicsApp extends StatefulWidget {
  final String initialRoute;

  PicPicsApp({@required this.initialRoute});

  @override
  _PicPicsAppState createState() => _PicPicsAppState();
}

class _PicPicsAppState extends State<PicPicsApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ChangeNotifierProvider<DatabaseManager>(
      create: (context) => DatabaseManager.instance,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: widget.initialRoute,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          PicScreen.id: (context) => PicScreen(),
          PhotoScreen.id: (context) => PhotoScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          AddLocationScreen.id: (context) => AddLocationScreen(),
        },
      ),
    );
  }
}
