import 'package:firebase_analytics/firebase_analytics.dart';
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
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static String enumToString(Object o) => o.toString().split('.').last;

  static sendEvent(Event event) async {
    if (kDebugMode) {
      return;
    }

    await analytics.logEvent(name: '${enumToString(event)}');
  }

  static setUserId(String userId) async {
    if (kDebugMode) {
      return;
    }

    await analytics.setUserId(userId);
  }

  static sendCurrentScreen(Screen screen) {
    if (kDebugMode) {
      return;
    }

    observer.analytics.setCurrentScreen(
      screenName: '${enumToString(screen)}',
    );
  }

  static sendCurrentTab(int index) {
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

    observer.analytics.setCurrentScreen(
      screenName: '${enumToString(Screen.tabs_screen)}/$tabName',
    );
  }
}
