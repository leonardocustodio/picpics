import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io';

const String androidAppId = 'ca-app-pub-5152146538991892~2540164868';
const String iosAppId = 'ca-app-pub-5152146538991892~4542623621';
const String iosBannerId = 'ca-app-pub-5152146538991892/7863578075';
const String androidBannerId = 'ca-app-pub-5152146538991892/1911525195';
const String iosRewardedId = 'ca-app-pub-5152146538991892/3698742406';
const String androidRewardedId = 'ca-app-pub-5152146538991892/6096647360';
const String HideAdScreen = 'HideAd';

//static final String testAdUnitId = Platform.isAndroid
//    ? 'ca-app-pub-3940256099942544/5224354917'
//    : 'ca-app-pub-3940256099942544/1712485313';

class Ads {
//  static BannerAd _bannerAd;

  static void initialize() {
    if (Platform.isAndroid) {
      FirebaseAdMob.instance.initialize(appId: androidAppId);
    } else {
      FirebaseAdMob.instance.initialize(appId: iosAppId);
    }
    print('Did initialize admob!!!');
  }

  static void loadRewarded() {
    if (Platform.isAndroid) {
//      RewardedVideoAd.testAdUnitId
      RewardedVideoAd.instance.load(adUnitId: androidRewardedId, targetingInfo: targetingInfo);
    } else {
      RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo).catchError((e) {
        print(e.toString());
      });
    }
    print('Did load rewarded!!!');
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['pic', 'image', 'pictures', 'photos', 'photography', 'album', 'manager', 'filter'],
    contentUrl: 'https://www.inovatso.com.br',
    childDirected: false,
    nonPersonalizedAds: false,
    testDevices: <String>['00008020-0009251E1A84002E', 'BBBB5C82882E2809449515237DD8EC25'],
  );

//  static BannerAd _createBannerAd() {
//    return BannerAd(
//      adUnitId: BannerAd.testAdUnitId,
//      size: AdSize.fullBanner,
//      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event) {
//        print("BannerAd event $event");
////        print(_bannerAd.size);
//      },
//    );
//  }
//
//  static void showBannerAd(double offset) async {
//    if (_bannerAd == null) {
//      DatabaseManager.instance.adOffset = offset;
//
//      _bannerAd = _createBannerAd();
//
//      _bannerAd
//        ..load()
//        ..show(anchorOffset: offset, anchorType: AnchorType.bottom);
//
//      return;
//    }
//
//    if (DatabaseManager.instance.adOffset != offset) {
//      DatabaseManager.instance.adOffset = offset;
//
//      await _bannerAd.dispose();
//      _bannerAd = null;
//
//      _bannerAd = _createBannerAd();
//      _bannerAd
//        ..load()
//        ..show(anchorOffset: offset, anchorType: AnchorType.bottom);
//      return;
//    }
//
//    if (_bannerAd != null) {
//      _bannerAd.show(anchorOffset: offset, anchorType: AnchorType.bottom);
//      return;
//    }
//  }
//
//  static void hideBannerAd() async {
//    if (_bannerAd == null) {
//      return;
//    }
//    await _bannerAd.dispose();
//    _bannerAd = null;
//  }
//
//  static void setScreen(String screen, [int tab]) {
//    if (DatabaseManager.instance.userSettings.isPremium) {
//      hideBannerAd();
//      return;
//    }
//
//    switch (screen) {
//      case SettingsScreen.id:
//        {
//          hideBannerAd();
//          //showBannerAd(0.0);
//        }
//        break;
//      case PremiumScreen.id:
//        {
//          hideBannerAd();
//        }
//        break;
//      case PicScreen.id:
//        {
//          hideBannerAd();
////          if (tab == 0) {
////            showBannerAd(48.0);
////          } else if (tab == 1) {
////            showBannerAd(48.0);
////          } else {
////            showBannerAd(48.0);
////          }
//        }
//        break;
//      case HideAdScreen:
//        {
//          hideBannerAd();
//        }
//        break;
//      default:
//        {
//          hideBannerAd();
//        }
//        break;
//    }
//  }
}
