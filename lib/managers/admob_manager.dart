// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:picPics/managers/database_manager.dart';

class Ads {
  static final String appId = Platform.isAndroid
      ? 'ca-app-pub-4850390878205651~5454538550'
      : 'ca-app-pub-4850390878205651~6175952653';
  static final String rewardedId = Platform.isAndroid
      ? 'ca-app-pub-4850390878205651/2428279339'
      : 'ca-app-pub-4850390878205651/6587016195';

  static void initialize() {
    // FirebaseAdMob.instance.initialize(appId: kDebugMode ? FirebaseAdMob.testAppId : appId);
    print('Did initialize admob!!!');
  }

  static void loadRewarded() {
    // RewardedVideoAd.instance.load(adUnitId: kDebugMode ? RewardedVideoAd.testAdUnitId : rewardedId, targetingInfo: targetingInfo).catchError((e) {
    //print(e.toString());
    // }).then((value) {
    //   DatabaseManager.instance.adsIsLoaded = true;
    //   if (DatabaseManager.instance.showShowAdAfterReload) {
    //     DatabaseManager.instance.showShowAdAfterReload = false;
    //     Ads.showRewarded();
    //   }
    // });
  }

  static void showRewarded() {
    // if (DatabaseManager.instance.adsIsLoaded) {
    //   RewardedVideoAd.instance.show();
    // } else {
    //   DatabaseManager.instance.showShowAdAfterReload = true;
    //   loadRewarded();
    // }
  }

  // static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //   keywords: <String>['pic', 'image', 'pictures', 'photos', 'photography', 'album', 'manager', 'filter'],
  //   contentUrl: 'https://picpics.app',
  //   childDirected: false,
  //   nonPersonalizedAds: false,
  //   testDevices: <String>['00008020-0009251E1A84002E', 'BBBB5C82882E2809449515237DD8EC25'],
  // );
}
