import 'package:get/get.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:uuid/uuid.dart';

class DatabaseController extends GetxController {
  static DatabaseController get to => Get.find();
  final _database = AppDatabase();

  Future<MoorUser> getUser({String? deviceLocale}) async {
    final user = await _database.getSingleMoorUser(createIfNotExist: false);

    if (user == null) {
//      Locale locale = await DeviceLocale.getCurrentLocale();
      final user2 = getDefaultMoorUser(deviceLocale: deviceLocale);
      await _database.createMoorUser(user2);
      await Analytics.setUserId(user2.id);
      await Analytics.sendEvent(Event.created_user);
      return user2;
    } else {
      await Analytics.setUserId(user.id);
      await Analytics.sendEvent(Event.user_returned);
    }
    return user;
  }

  Future<void> setDeletedFromCameraRoll(String picId, bool value) async {
    final pic = await _database.getPhotoByPhotoId(picId);
    if (pic != null) {
      await _database.updatePhoto(pic.copyWith(deletedFromCameraRoll: value));
    }
  }

  Future<void> setKeepAskingToDelete(bool value) async {
    final currentUser = await _database.getSingleMoorUser();
    if (currentUser != null) {
      await _database
          .updateMoorUser(currentUser.copyWith(keepAskingToDelete: value));
    }
  }
}

MoorUser getDefaultMoorUser({String? deviceLocale}) {
  return MoorUser(
    customPrimaryKey: 0,
    id: const Uuid().v4(),
    notification: false,
    dailyChallenges: false,
    goal: 20,
    hourOfDay: 20,
    minuteOfDay: 00,
    recentTags: [],
    tutorialCompleted: false,
    picsTaggedToday: 0,
    lastTaggedPicDate: DateTime.now(),
    appLanguage: deviceLocale ?? '',
    hasGalleryPermission: false,
    loggedIn: false,
    secretPhotos: false,
    isPinRegistered: false,
    keepAskingToDelete: true,
    tourCompleted: false,
    isBiometricActivated: false,
    shouldDeleteOnPrivate: false,
  );
}
