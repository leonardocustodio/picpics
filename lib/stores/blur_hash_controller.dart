import 'dart:async';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/third_party_lib/src/blurhash.dart';

class BlurHashController extends GetxController {
  static BlurHashController get to => Get.find();
  Timer? _timer;

  final blurHash = <String, String>{}.obs;
  final masterHash = <String, String>{};
  final _appDatabase = AppDatabase();
  final _blurHashesQueue = <String, Uint8List>{};

  @override
  void onInit() {
    super.onInit();
    loadBlurHash();
  }

  Future<void> loadBlurHash() async {
    var blurHashList = await _appDatabase.getAllPicBlurHash();

    blurHashList.forEach((pic) {
      masterHash[pic.photoId] = pic.blurHash;
    });
    blurHash.value = Map<String, String>.from(masterHash);
  }

  /// Below function will accept the calls for calculating the blur Hashes but will be executed after the calls
  /// to this function stops and then it will do the processing
  ///
  /// It's a way to Debounce the calls and overloads it with the updated data
  ///

  Future<void> createBlurHash(String photoId, Uint8List imageBytes) async {
    if (null != _blurHashesQueue[photoId] || null != masterHash[photoId]) {
      return;
    }
    _timer?.cancel();

    print('blur hash: creating');
    _blurHashesQueue[photoId] = imageBytes;

    _timer = Timer(Duration(seconds: 3), _insertBlurHashToDatabase);
  }

  Future<String?> _calculateBlurHash(
      String photoId, Uint8List imageBytes) async {
    if (null == masterHash[photoId]) {
      final image = img.decodeImage(imageBytes.toList());
      if (null != image) {
        return BlurHash.encode(image).hash;
      }
    }
    return null;
  }

  Future<void> _insertBlurHashToDatabase() async {
    if (_blurHashesQueue.isNotEmpty) {
      print('blur hash: inserting');
      var picMaps = Map<String, Uint8List>.from(_blurHashesQueue);
      _blurHashesQueue.clear();
      var picBlurHashList = <PicBlurHash>[];

      await Future.forEach(picMaps.entries,
          (MapEntry<String, Uint8List> object) async {
        if (null == masterHash[object.key]) {
          var hash = await _calculateBlurHash(object.key, object.value);
          if (null != hash) {
            masterHash[object.key] = hash;
            picBlurHashList
                .add(PicBlurHash(photoId: object.key, blurHash: hash));
          }
        }
      }).then((_) async {
        await _appDatabase.insertAllPicBlurHash(picBlurHashList);

        ///
        /// I thinks it's making the application laggy
        ///
        //blurHash.value = Map<String, String>.from(masterHash);
      });
    }
    _timer = null;
  }
}
