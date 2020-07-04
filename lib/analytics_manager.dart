import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

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
  played_ads,
}

class Analytics {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static String enumToString(Object o) => o.toString().split('.').last;

  static sendEvent() async {
    await analytics.logEvent(name: 'first_start');
    print('abc');
  }

  static sendCurrentScreen(Screen screen) {
    observer.analytics.setCurrentScreen(
      screenName: '${enumToString(screen)}',
    );
  }

  static sendCurrentTab(int index) {
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
