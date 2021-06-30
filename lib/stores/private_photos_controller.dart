import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';

import 'user_controller.dart';

class PrivatePhotosController extends GetxController {
  static PrivatePhotosController get to => Get.find();

  final showPrivate = false.obs;

  /// privatePhotoId = '';
  final privateMap = <String, String>{}.obs;

  final _appDatabase = AppDatabase();

  Future<void> refreshPrivatePics() async {
    var _val = await _appDatabase.getPrivatePhotoList();
    await Future.forEach(_val, (photo) async {
      if (photo?.id != null) {
        privateMap[photo.id] = '';
      }
    });
  }

  Future<void> switchSecretPhotos() async {
    showPrivate.value = !showPrivate.value;

    if (showPrivate.value == false) {
      //print('Cleared encryption key in memory!!!');
      UserController.to.setEncryptionKey(null);
    }

    MoorUser currentUser = await _appDatabase.getSingleMoorUser();
    await _appDatabase
        .updateMoorUser(currentUser.copyWith(secretPhotos: showPrivate.value));

    //    Analytics.sendEvent(Event.notification_switch);
  }
}
