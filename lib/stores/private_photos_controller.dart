import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';

import 'user_controller.dart';

class PrivatePhotosController extends GetxController {
  static PrivatePhotosController get to => Get.find();

  final showPrivate = false.obs;

  /// picId
  final privateMap = <String, String>{}.obs;

  final _appDatabase = AppDatabase();

  Future<void> refreshPrivatePics() async {
    var val = await _appDatabase.getPrivatePhotoList();
    await Future.forEach(val, (Photo photo) async {
      privateMap[photo.id] = '';
    });
  }

  Future<void> switchSecretPhotos() async {
    showPrivate.value = !showPrivate.value;

    if (showPrivate.value == false) {
      UserController.to.setEncryptionKey(null);
      return;
    }

    // ignore: unawaited_futures
    Analytics.sendEvent(Event.notification_switch);
  }
}
