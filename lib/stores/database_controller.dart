import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:uuid/uuid.dart';

class DatabaseController extends GetxController {
  static DatabaseController get to => Get.find();
  AppDatabase _database = AppDatabase();

  Future<MoorUser> getUser({String deviceLocale}) async {
    MoorUser user = await _database.getSingleMoorUser(createIfNotExist: false);

    if (user == null) {
//      Locale locale = await DeviceLocale.getCurrentLocale();
      user = getDefaultMoorUser(deviceLocale: deviceLocale);
      await _database.createMoorUser(user);
      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.created_user);
    } else {
      Analytics.setUserId(user.id);
      Analytics.sendEvent(Event.user_returned);
    }
    return user;
  }

  Future<void> setDeletedFromCameraRoll(String picId, bool value) async {
    //var picsBox = Hive.box('pics');
    //Pic pic = picsBox.get(photoId);
    Photo pic = await _database.getPhotoByPhotoId(picId);
    //pic.deletedFromCameraRoll = value;
    //pic.save();
    await _database.updatePhoto(pic.copyWith(deletedFromCameraRoll: value));
  }

  void setKeepAskingToDelete(bool value) async {
    MoorUser currentUser = await _database.getSingleMoorUser();
    await _database
        .updateMoorUser(currentUser.copyWith(keepAskingToDelete: value));
  }
}

MoorUser getDefaultMoorUser({String deviceLocale}) {
  return MoorUser(
    customPrimaryKey: 0,
    id: Uuid().v4(),
    email: null,
    password: null,
    notification: false,
    dailyChallenges: false,
    goal: 20,
    hourOfDay: 20,
    minuteOfDay: 00,
    isPremium: false,
    recentTags: [],
    tutorialCompleted: false,
    picsTaggedToday: 0,
    lastTaggedPicDate: DateTime.now(),
    canTagToday: true,
    appLanguage: deviceLocale ?? '',
    hasGalleryPermission: null,
    loggedIn: false,
    secretPhotos: false,
    isPinRegistered: false,
    keepAskingToDelete: true,
    tourCompleted: false,
    isBiometricActivated: false,
    shouldDeleteOnPrivate: false,
    starredPhotos: [],
    defaultWidgetImage: null,
  );
}
