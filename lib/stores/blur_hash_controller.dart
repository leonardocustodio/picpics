import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:picpics/database/app_database.dart';
import 'package:picpics/third_party_lib/src/blurhash.dart';
import 'package:picpics/utils/app_logger.dart';

class BlurHashController extends GetxController {
  static BlurHashController get to => Get.find();
  static Timer? _timer;
  static Timer? _settingTimer;

  final blurHash = <String, String>{}.obs;
  final masterHash = <String, String>{};
  static final _appDatabase = AppDatabase();
  final _blurHashesQueue = <String, Uint8List>{}.obs;

  @override
  void onInit() {
    _loadBlurHash();
    super.onInit();
  }

  Future<void> _loadBlurHash() async {
    final blurHashList = await _appDatabase.getAllPicBlurHash();

    for (final pic in blurHashList) {
      masterHash[pic.photoId] = pic.blurHash;
    }
    blurHash.value = Map<String, String>.from(masterHash);
  }

  /// Below function will accept the calls for calculating the blur Hashes but will be executed after the calls
  /// to this function stops and then it will do the processing
  ///
  /// It's a way to Debounce the calls and overloads it with the updated data
  ///
  ///

  Future<void> createBlurHash(String photoId, Uint8List imageBytes) async {
    if (null != _blurHashesQueue[photoId] || null != masterHash[photoId]) {
      return;
    }
    _settingTimer?.cancel();

    _blurHashesQueue[photoId] = imageBytes;

    _settingTimer = Timer(const Duration(seconds: 5), () {
      _timer = Timer(const Duration(seconds: 1), spawnBlurHashInsertingIsolate);
    });
  }

  Future<void> spawnBlurHashInsertingIsolate() async {
    try {
      final val = await compute(_insertBlurHashToDatabase, _blurHashesQueue);

      if (val.isNotEmpty) {
        final picBlurHashList = <PicBlurHash>[];
        val.forEach((key, value) {
          masterHash[key] = value;
          picBlurHashList.add(PicBlurHash(photoId: key, blurHash: value));
        });
        await _appDatabase.insertAllPicBlurHash(picBlurHashList);
      }
    } catch (e) {
      AppLogger.d('Error: $e');
    }
  }

  static FutureOr<Map<String, String>> _insertBlurHashToDatabase(
      RxMap<String, Uint8List> val,) async {
    AppLogger.d('_blurHashesQueue : ${val.keys}');

    /// creating hashMap to return the value
    final localBlurHashMap = <String, String>{};

    if (val.isNotEmpty) {
      await Future.forEach(val.entries,
          (MapEntry<String, Uint8List> object) async {
        String? hash;

        ///
        /// get image bytes
        ///
        final image = img.decodeImage(object.value);
        if (null != image) {
          ///
          /// calculate blurHash
          ///
          hash = BlurHash.encode(image).hash;
          localBlurHashMap[object.key] = hash;
        }
      });
    }
    _timer = null;
    _settingTimer = null;
    return localBlurHashMap;
  }
}
