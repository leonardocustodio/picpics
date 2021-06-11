import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/third_party_lib/src/blurhash.dart';

class BlurHashController extends GetxController {
  static BlurHashController get to => Get.find();

  final blurHash = <String, String>{}.obs;
  final _appDatabase = AppDatabase();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadBlurHash() async {
    var blurHashList = await _appDatabase.getAllPicBlurHash();

    blurHash.clear();

    blurHashList.forEach((pic) {
      blurHash[pic.photoId] = pic.blurHash;
    });
  }

  Future<String> createBlurHash(String photoId, Uint8List imageBytes) async {
    if (null != blurHash[photoId]) {
      return blurHash[photoId];
    }
    blurHash[photoId] = _processBlurHash(photoId, imageBytes);
    await _appDatabase.createBlurHash(
        PicBlurHash(photoId: photoId, blurHash: blurHash[photoId]));
    return blurHash[photoId];
  }

  String _processBlurHash(String photoId, Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes.toList());
    return BlurHash.encode(image).hash;
  }
}
