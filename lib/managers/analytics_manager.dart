import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

enum Screen {
  tabs_screen,
  settings_screen,
  add_location_screen,
  photo_screen,
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
  begin_checkout,
  present_offer,
  tutorial_complete,
  tutorial_begin,
  ad_impression,
  current_screen,
  current_tab,
}

class Analytics {
  static FacebookAppEvents facebookAppEvents = FacebookAppEvents();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static String enumToString(Object o) => o.toString().split('.').last;

  static Future<void> sendEvent(Event event,
      {Map<String, dynamic>? params}) async {
    if (/* kDebugMode */ true) {
      return;
    }

    await analytics.logEvent(
      name: enumToString(event),
      parameters: params,
    );

    await facebookAppEvents.logEvent(
      name: enumToString(event),
      parameters: params,
    );
  }

  static Future<void> sendAppOpen() async {
    if (/* kDebugMode */ true) {
      return;
    }

    await analytics.logAppOpen();
    // await facebookAppEvents.logActivatedApp();
  }

  static Future<void> sendTutorialBegin() async {
    if (/* kDebugMode */ true) {
      return;
    }

    await analytics.logTutorialBegin();
    await facebookAppEvents.logEvent(name: enumToString(Event.tutorial_begin));
  }

  static Future<void> sendTutorialComplete() async {
    if (/* kDebugMode */ true) {
      return;
    }

    await analytics.logTutorialComplete();
    await facebookAppEvents.logEvent(name: 'fb_mobile_tutorial_completion');
  }

  static Future<void> sendBeginCheckout(
      {required String currency, required double price}) async {
    if (/* kDebugMode */ true) {
      return;
    }

    await analytics.logBeginCheckout(
      value: price,
      currency: currency,
    );

    await facebookAppEvents.logEvent(
      name: 'fb_mobile_initiated_checkout',
      parameters: {
        FacebookAppEvents.paramNameContent: price,
        'fb_currency': currency,
      },
    );
  }

  static Future<void> setUserId(String userId) async {
    if (/* kDebugMode */ true) {
      return;
    }

    // await analytics.setUserId({id: userId});
    await facebookAppEvents.setUserID(userId);
    FlutterBranchSdk.setIdentity(userId);
  }

  static Future<void> sendCurrentScreen(Screen screen) async {
    if (/* kDebugMode */ true) {
      return;
    }

    await observer.analytics.setCurrentScreen(
      screenName: enumToString(screen),
    );
    await facebookAppEvents.logEvent(
      name: enumToString(Event.current_screen),
      parameters: {
        'screenName': enumToString(screen),
      },
    );
  }

  static Future<void> sendCurrentTab(int index) async {
    if (/* kDebugMode */ true) {
      return;
    }

    // String tabName;
    // if (index == 0) {
    //   tabName = enumToString(Tab.gallery);
    // } else if (index == 1) {
    //   tabName = enumToString(Tab.pics);
    // } else if (index == 2) {
    //   tabName = enumToString(Tab.tagged);
    // }
    //
    // await observer.analytics.setCurrentScreen(
    //   screenName: '${enumToString(Screen.tabs_screen)}/$tabName',
    // );
    // await facebookAppEvents.logEvent(
    //   name: enumToString(Event.current_tab),
    //   parameters: {
    //     'screenName': '${enumToString(Screen.tabs_screen)}/$tabName',
    //   },
    // );
  }
}
