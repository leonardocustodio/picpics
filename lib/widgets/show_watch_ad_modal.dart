import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/managers/admob_manager.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/widgets/watch_ad_modal.dart';

void showWatchAdModal() {
  Analytics.sendEvent(Event.watch_ads_modal);
  showDialog<void>(
    context: Get.context,
    barrierDismissible: true,
    builder: (_) {
      return WatchAdModal(
        onPressedWatchAdd: () {
          Get.back();
          Ads.showRewarded();
          Analytics.sendAdImpression();
        },
        onPressedGetPremium: () {
          Get.offNamed(PremiumScreen.id);
        },
      );
    },
  );
}
