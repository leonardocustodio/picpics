import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';

class TaggedController extends GetxController {
  static TaggedController get to => Get.find();

  /// tagKey: {picId: ''}
  final taggedPicId = <String, RxMap<String, String>>{};
  final allTaggedPicIdList = <String, String>{}.obs;

  final database = AppDatabase();

  @override
  void onReady() {
    super.onReady();
    refreshTaggedPhotos();
  }

  Future<void> refreshTaggedPhotos() async {
    var taggedPhotoIdList = await database.getAllPhoto();

    allTaggedPicIdList.clear();
    taggedPicId.clear();
    await Future.forEach(taggedPhotoIdList, (Photo photo) async {
      if (photo?.tags?.isNotEmpty ?? false) {
        photo?.tags?.forEach((tagKey) {
          if (taggedPicId[tagKey] == null) {
            taggedPicId[tagKey] = <String, String>{}.obs;
          }
          taggedPicId[tagKey][photo.id] = '';
        });
        allTaggedPicIdList[photo.id] = '';
      }
    });
    print('${allTaggedPicIdList.keys.toList()}');
  }
}
