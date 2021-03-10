import 'package:flutter/material.dart';
import 'package:picPics/managers/admob_manager.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/widgets/watch_ad_modal.dart';

showWatchAdModal(BuildContext context) {
  Analytics.sendEvent(Event.watch_ads_modal);
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext buildContext) {
      return WatchAdModal(
        onPressedWatchAdd: () {
          Navigator.pop(context);
          Ads.showRewarded();
          Analytics.sendAdImpression();
        },
        onPressedGetPremium: () {
          Navigator.popAndPushNamed(context, PremiumScreen.id);
        },
      );
    },
  );
}
