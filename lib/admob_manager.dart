import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io';

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
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static void showBannerAd() {
    if (_bannerAd == null) _bannerAd = _createBannerAd();
    _bannerAd
      ..load()
      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
  }

  static void hideBannerAd() async {
    await _bannerAd.dispose();
    _bannerAd = null;
  }
}
