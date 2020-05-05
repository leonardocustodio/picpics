import 'package:firebase_admob/firebase_admob.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/pic_screen.dart';
import 'package:picPics/premium_screen.dart';
import 'dart:io';
import 'package:picPics/settings_screen.dart';

const String androidAppId = 'ca-app-pub-5152146538991892~2540164868';
const String iosAppId = 'ca-app-pub-5152146538991892~4542623621';
const String iosBannerId = 'ca-app-pub-5152146538991892/7863578075';
const String androidBannerId = 'ca-app-pub-5152146538991892/1911525195';
const String iosRewardedId = 'ca-app-pub-5152146538991892/3698742406';
const String androidRewardedId = 'ca-app-pub-5152146538991892/6096647360';
const String HideAdScreen = 'HideAd';

class Ads {
  static BannerAd _bannerAd;

  static void initialize() {
    if (Platform.isAndroid) {
      RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
      FirebaseAdMob.instance.initialize(appId: androidAppId);
    } else {
      RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
      FirebaseAdMob.instance.initialize(appId: iosAppId);
    }
    print('Ads did initialize!!!');
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: false,
    nonPersonalizedAds: false,
    testDevices: <String>[],
  );

  static BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
//        print(_bannerAd.size);
      },
    );
  }

  static void showBannerAd(double offset) async {
    if (_bannerAd == null) {
      DatabaseManager.instance.adOffset = offset;

      _bannerAd = _createBannerAd();

      _bannerAd
        ..load()
        ..show(anchorOffset: offset, anchorType: AnchorType.bottom);

      return;
    }

    if (DatabaseManager.instance.adOffset != offset) {
      DatabaseManager.instance.adOffset = offset;

      await _bannerAd.dispose();
      _bannerAd = null;

      _bannerAd = _createBannerAd();
      _bannerAd
        ..load()
        ..show(anchorOffset: offset, anchorType: AnchorType.bottom);
      return;
    }

    if (_bannerAd != null) {
      _bannerAd.show(anchorOffset: offset, anchorType: AnchorType.bottom);
      return;
    }
  }

  static void hideBannerAd() async {
    if (_bannerAd == null) {
      return;
    }
    await _bannerAd.dispose();
    _bannerAd = null;
  }

  static void setScreen(String screen, [int tab]) {
    if (DatabaseManager.instance.userSettings.isPremium) {
      hideBannerAd();
      return;
    }

    switch (screen) {
      case SettingsScreen.id:
        {
          hideBannerAd();
          //showBannerAd(0.0);
        }
        break;
      case PremiumScreen.id:
        {
          hideBannerAd();
        }
        break;
      case PicScreen.id:
        {
          hideBannerAd();
//          if (tab == 0) {
//            showBannerAd(48.0);
//          } else if (tab == 1) {
//            showBannerAd(48.0);
//          } else {
//            showBannerAd(48.0);
//          }
        }
        break;
      case HideAdScreen:
        {
          hideBannerAd();
        }
        break;
      default:
        {
          hideBannerAd();
        }
        break;
    }
  }
}
