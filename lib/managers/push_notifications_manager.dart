import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:picPics/managers/database_manager.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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

      var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings();
      var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
      print('scheduling notification');
//      scheduleNotification();
    }
  }

  void register({int hourOfDay, int minutesOfDay, String title, String description}) async {
    if (!_initialized) {
      init();
      print('subscribed');
      return;
    }

    _firebaseMessaging.requestNotificationPermissions();
    String token = await _firebaseMessaging.getToken();
    print("FirebaseMessaging token: $token");
    print('subscribed');

    scheduleNotification(
      hourOfDay: hourOfDay,
      minutesOfDay: minutesOfDay,
      title: title,
      description: description,
    );
  }

//  void register() {
//    _firebaseMessaging.subscribeToTopic('all_users');
//    print('subscribed to topic: all_users');
//  }

  void deregister() async {
    try {
      _firebaseMessaging.deleteInstanceID();
      print('unsubscribed');
      var userBox = Hive.box('user');
      DatabaseManager.instance.userSettings.dailyChallenges = false;
      userBox.putAt(0, DatabaseManager.instance.userSettings);

      print(
          'User settings: notification: ${DatabaseManager.instance.userSettings.notifications} - dailyChallenges ${DatabaseManager.instance.userSettings.dailyChallenges}');

      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (error) {
      print(error);
    }
  }

  void scheduleNotification({int hourOfDay, int minutesOfDay, String title, String description}) async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    var time = Time(
      hourOfDay,
      minutesOfDay,
      0,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      title,
      description,
      time,
      platformChannelSpecifics,
    );
  }
}
