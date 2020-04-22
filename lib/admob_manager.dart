import 'package:firebase_admob/firebase_admob.dart';
import 'package:picPics/pic_screen.dart';
import 'package:picPics/premium_screen.dart';
import 'dart:io';

import 'package:picPics/settings_screen.dart';

const String androidAppId = 'ca-app-pub-5152146538991892~2540164868';
const String iosAppId = 'ca-app-pub-5152146538991892~4542623621';
const String testDevice = 'YOUR_DEVICE_ID';

class Ads {
  static BannerAd _bannerAd;

  static void initialize() {
    if (Platform.isAndroid) {
      FirebaseAdMob.instance.initialize(appId: androidAppId);
    } else {
      FirebaseAdMob.instance.initialize(appId: iosAppId);
    }
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: false,
    nonPersonalizedAds: false,
  );

  static BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
//      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static void showBannerAd(AnchorType position) {
    if (_bannerAd == null) _bannerAd = _createBannerAd();

    _bannerAd
      ..load()
      ..show(anchorOffset: position == AnchorType.top ? 48.0 : 0.0, anchorType: position);
  }

  static void hideBannerAd() async {
    if (_bannerAd == null) {
      return;
    }
    await _bannerAd.dispose();
    _bannerAd = null;
  }

  static void setScreen(String screen, [int tab]) {
    switch (screen) {
      case SettingsScreen.id:
        {
          showBannerAd(AnchorType.bottom);
        }
        break;
      case PremiumScreen.id:
        {
          hideBannerAd();
        }
        break;
      case PicScreen.id:
        {
          if (tab == 0) {
            showBannerAd(AnchorType.top);
          } else if (tab == 1) {
            hideBannerAd();
          } else {
            hideBannerAd();
          }
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
