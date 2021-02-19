import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestPermission();
      // _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      var token = await _firebaseMessaging.getToken();

      print("FirebaseMessaging token: $token");

      _initialized = true;
/* 
      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      //print("Settings registered: $settings");

        var userBox = Hive.box('user');
        DatabaseManager.instance.userSettings.notifications = settings.alert;
        DatabaseManager.instance.userSettings.dailyChallenges = settings.alert;
        userBox.putAt(0, DatabaseManager.instance.userSettings);
      }); 
*/

      var initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false);

      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
      print('scheduling notification');
//      scheduleNotification();
    }
  }

  void register(
      {int hourOfDay,
      int minutesOfDay,
      String title,
      String description}) async {
    if (!_initialized) {
      init();
      print('subscribed');
      return;
    }

    _firebaseMessaging.requestPermission();
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

/*   void register() {
  _firebaseMessaging.subscribeToTopic('all_users');
//print('subscribed to topic: all_users');
  } */

  void deregister() async {
    try {
      _firebaseMessaging.deleteToken();
      print('unsubscribed');
      //var userBox = Hive.box('user');
      //DatabaseManager.instance.userSettings.dailyChallenges = false;
      //userBox.putAt(0, DatabaseManager.instance.userSettings);
      DatabaseManager.instance.database.updateMoorUser(
        DatabaseManager.instance.userSettings.copyWith(
          dailyChallenges: false,
        ),
      );

      print(
          'User settings: notification: ${DatabaseManager.instance.userSettings.notification} - dailyChallenges ${DatabaseManager.instance.userSettings.dailyChallenges}');

      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (error) {
      print(error);
    }
  }

  tz.TZDateTime _nextInstanceOfTime(Time time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void scheduleNotification(
      {int hourOfDay,
      int minutesOfDay,
      String title,
      String description}) async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    var time = Time(
      hourOfDay,
      minutesOfDay,
      0,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        description,
        _nextInstanceOfTime(time),
        const NotificationDetails(
          android: AndroidNotificationDetails('0', 'Daily Goal',
              'Notification for remembering your picPics daily goal'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        scheduledNotificationRepeatFrequency:
            ScheduledNotificationRepeatFrequency.daily);
  }
}
