import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';

class DatabaseController extends GetxController {
  static DatabaseController get to => Get.find();
  AppDatabase _database = AppDatabase();

  Future<void> operatePicStar(String picId, bool isStarred) async {}

  Future<void> setDeletedFromCameraRoll(String picId, bool value) async {
    //var picsBox = Hive.box('pics');
    //Pic pic = picsBox.get(photoId);
    Photo pic = await _database.getPhotoByPhotoId(picId);
    //pic.deletedFromCameraRoll = value;
    //pic.save();
    await _database.updatePhoto(pic.copyWith(deletedFromCameraRoll: value));
  }
}
