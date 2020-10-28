import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

enum Screen {
  tabs_screen,
  settings_screen,
  add_location_screen,
  photo_screen,
  premium_screen,
  login_screen,
}

enum Tab {
  gallery,
  pics,
  tagged,
}

enum Event {
  created_user,
  user_returned,
  created_tag,
  added_tag,
  removed_tag,
  deleted_tag,
  edited_tag,
  swiped_photo,
  searched_photos,
  showed_card,
  watch_ads_modal,
  played_ads,
  selected_photos,
  shared_photo,
  shared_photos,
  deleted_photo,
  changed_language,
  shared_app,
  rated_app,
  notification_switch,
  notification_time,
}

class Analytics {
  static FacebookAppEvents facebookAppEvents = FacebookAppEvents();
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static String enumToString(Object o) => o.toString().split('.').last;

  static sendEvent(Event event, {Map<String, dynamic> params = null}) async {
    if (kDebugMode) {
      return;
    }

    await analytics.logEvent(
        name: '${enumToString(event)}', parameters: params);
    await facebookAppEvents.logEvent(
      name: '${enumToString(event)}',
      parameters: params,
    );
  }

  static sendPurchase(
      {String currency, double price, String transactionId}) async {
    if (kDebugMode) {
      return;
    }

    await analytics.logEcommercePurchase(
      currency: 'USD',
      value: price,
    );

    await facebookAppEvents.logPurchase(
      amount: price,
      currency: 'USD',
    );
  }

  static setUserId(String userId) async {
    if (kDebugMode) {
      return;
    }

    await analytics.setUserId(userId);
    FlutterBranchSdk.setIdentity(userId);
  }

  static sendCurrentScreen(Screen screen) async {
    if (kDebugMode) {
      return;
    }

    await observer.analytics.setCurrentScreen(
      screenName: '${enumToString(screen)}',
    );
  }

  static sendCurrentTab(int index) async {
    if (kDebugMode) {
      return;
    }

    var tabName;
    if (index == 0) {
      tabName = '${enumToString(Tab.gallery)}';
    } else if (index == 1) {
      tabName = '${enumToString(Tab.pics)}';
    } else if (index == 2) {
      tabName = '${enumToString(Tab.tagged)}';
    }

    await observer.analytics.setCurrentScreen(
      screenName: '${enumToString(Screen.tabs_screen)}/$tabName',
    );
  }
}
