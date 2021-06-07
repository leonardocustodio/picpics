import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';

class PrivatePhotosController extends GetxController {
  static PrivatePhotosController get to => Get.find();

  final showPrivate = false.obs;

  /// privatePhotoId = '';
  final privateMap = <String, String>{}.obs;

  final _appDatabase = AppDatabase();

  Future<void> refreshPrivatePics() async {
    var _val = await _appDatabase.getPrivatePhotoList();
    await Future.forEach(
        _val, (photo) async => privateMap[photo.id] = '');
    
  }
}
