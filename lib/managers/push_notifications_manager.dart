import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:picpics/managers/database_manager.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:timezone/timezone.dart' as tz;

class PushNotificationsManager {

  factory PushNotificationsManager() => _instance;
  PushNotificationsManager._();

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      await _firebaseMessaging.requestPermission();
      // _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      final token = await _firebaseMessaging.getToken();

      AppLogger.d('FirebaseMessaging token: $token');

      _initialized = true;
/* 
      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      AppLogger.d("Settings registered: $settings");

        var userBox = Hive.box('user');
        DatabaseManager.instance.userSettings.notifications = settings.alert;
        DatabaseManager.instance.userSettings.dailyChallenges = settings.alert;
        userBox.putAt(0, DatabaseManager.instance.userSettings);
      }); 
*/

      const initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      const initializationSettingsIOS = DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,);

      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
      AppLogger.d('scheduling notification');
//      scheduleNotification();
    }
  }

  Future<void> register(
      {int hourOfDay = 0,
      int minutesOfDay = 0,
      String? title,
      String? description,}) async {
    if (!_initialized) {
      await init();
      AppLogger.d('subscribed');
      return;
    }

    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    AppLogger.d('FirebaseMessaging token: $token');
    AppLogger.d('subscribed');

    scheduleNotification(
      hourOfDay: hourOfDay,
      minutesOfDay: minutesOfDay,
      title: title,
      description: description,
    );
  }

/*   void register() {
  _firebaseMessaging.subscribeToTopic('all_users');
AppLogger.d('subscribed to topic: all_users');
  } */

  Future<void> deregister() async {
    try {
      await _firebaseMessaging.deleteToken();
      AppLogger.d('unsubscribed');
      //var userBox = Hive.box('user');
      //DatabaseManager.instance.userSettings.dailyChallenges = false;
      //userBox.putAt(0, DatabaseManager.instance.userSettings);
      await DatabaseManager.instance.database.updateMoorUser(
        DatabaseManager.instance.userSettings.copyWith(
          dailyChallenges: false,
        ),
      );

      AppLogger.d(
          'User settings: notification: ${DatabaseManager.instance.userSettings.notification} - dailyChallenges ${DatabaseManager.instance.userSettings.dailyChallenges}',);

      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (error) {
      AppLogger.d(error);
    }
  }

  tz.TZDateTime _nextInstanceOfTime(tz.TZDateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute,);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleNotification(
      {int hourOfDay = 0,
      int minutesOfDay = 0,
      String? title,
      String? description,}) async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    // TODO: Check this
    // var time = Time(
    //   hourOfDay,
    //   minutesOfDay,
    //   0,
    // );
    // This is not right just to pass
    final time = tz.TZDateTime.utc(2023);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      description,
      _nextInstanceOfTime(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '0',
          'Daily Goal',
          channelDescription:
              'Notification for remembering your picPics daily goal',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
