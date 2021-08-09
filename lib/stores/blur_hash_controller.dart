import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/third_party_lib/src/blurhash.dart';

class BlurHashController extends GetxController {
  static BlurHashController get to => Get.find();
  static Timer? _timer;

  final blurHash = <String, String>{}.obs;
  final masterHash = <String, String>{}.obs;
  static final _appDatabase = AppDatabase();
  final _blurHashesQueue = <String, Uint8List>{};

  @override
  void onInit() {
    _loadBlurHash();
    super.onInit();
  }

  Future<void> _loadBlurHash() async {
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
  ///

  Future<void> createBlurHash(String photoId, Uint8List imageBytes) async {
    return;
    if (null != _blurHashesQueue[photoId] || null != masterHash[photoId]) {}
    _timer?.cancel();

    _blurHashesQueue[photoId] = imageBytes;

    _timer = Timer(Duration(seconds: 5), spawnBlurHashInsertingIsolate);
  }

  static Future<String?> _calculateBlurHash(Uint8List imageBytes) async {
    final image = img.decodeImage(imageBytes.toList());
    if (null != image) {
      return BlurHash.encode(image).hash;
    }
    return null;
  }

  void spawnBlurHashInsertingIsolate() async {
    Map<String, String>? val;
    try {
      print('Before: ' + masterHash.value.toString());
      val = await compute<Map<String, Uint8List>, Map<String, String>>(
          _insertBlurHashToDatabase, _blurHashesQueue);
      if (val.isNotEmpty) {
        var picBlurHashList = <PicBlurHash>[];
        val.forEach((key, value) {
          masterHash[key] = value;
          picBlurHashList.add(PicBlurHash(photoId: key, blurHash: value));
        });
        await Future.forEach(picBlurHashList, _appDatabase.createPicBlurHash);
      }
      print('After: $val');
    } catch (e) {
      print('After2: $val : ');
      print('Error: $e');
    }
  }

  static FutureOr<Map<String, String>> _insertBlurHashToDatabase(
      Map<String, Uint8List> val) async {
    print('_blurHashesQueue : ${val.keys}');
    var localBlurHashMap = <String, String>{};

    if (val.isNotEmpty) {
      var picMaps = Map<String, Uint8List>.from(val);
      val.clear();
      var picBlurHashList = <PicBlurHash>[];

      await Future.forEach(picMaps.entries,
          (MapEntry<String, Uint8List> object) async {
        var hash = await _calculateBlurHash(object.value);
        if (null != hash) {
          localBlurHashMap[object.key] = hash;
          picBlurHashList.add(PicBlurHash(photoId: object.key, blurHash: hash));
        }
      });
    }
    _timer = null;
    return localBlurHashMap;
  }
}
