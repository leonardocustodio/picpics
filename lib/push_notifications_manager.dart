import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:picPics/database_manager.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();

      print("FirebaseMessaging token: $token");

      _initialized = true;

//      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
//        print("Settings registered: $settings");
//
//        var userBox = Hive.box('user');
//        DatabaseManager.instance.userSettings.notifications = settings.alert;
//        DatabaseManager.instance.userSettings.dailyChallenges = settings.alert;
//        userBox.putAt(0, DatabaseManager.instance.userSettings);
//      });
    }
  }

  void register() async {
    if (!_initialized) {
      init();

      print('subscribed');
      var userBox = Hive.box('user');
      DatabaseManager.instance.userSettings.dailyChallenges = true;
      userBox.putAt(0, DatabaseManager.instance.userSettings);

      return;
    }

    _firebaseMessaging.requestNotificationPermissions();
    String token = await _firebaseMessaging.getToken();
    print("FirebaseMessaging token: $token");

    print('subscribed');
    var userBox = Hive.box('user');
    DatabaseManager.instance.userSettings.dailyChallenges = true;
    userBox.putAt(0, DatabaseManager.instance.userSettings);
  }

//  void register() {
//    _firebaseMessaging.subscribeToTopic('all_users');
//    print('subscribed to topic: all_users');
//  }

  void deregister() {
    try {
      _firebaseMessaging.deleteInstanceID();
      print('unsubscribed');
      var userBox = Hive.box('user');
      DatabaseManager.instance.userSettings.dailyChallenges = false;
      userBox.putAt(0, DatabaseManager.instance.userSettings);

      print(
          'User settings: notification: ${DatabaseManager.instance.userSettings.notifications} - dailyChallenges ${DatabaseManager.instance.userSettings.dailyChallenges}');
    } catch (error) {
      print(error);
    }
  }
}
