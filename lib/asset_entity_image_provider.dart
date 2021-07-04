import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/stores/pic_store.dart';

@immutable
class AssetEntityImageProvider extends ImageProvider<AssetEntityImageProvider> {
  final PicStore picStore;

  /// Scale for image provider.
  /// 缩放
  final double scale;

  /// Size for thumb data.
  /// 缩略图的大小
  final List<int> thumbSize;

  /// Choose if original data or thumb data should be loaded.
  /// 选择载入原数据还是缩略图数据
  final bool isOriginal;
  AssetEntityImageProvider(
    this.picStore, {
    this.scale = 1.0,
    this.thumbSize = kDefaultPreviewThumbSize,
    this.isOriginal = true,
  }) : assert(isOriginal || thumbSize.length == 2,
            'thumbSize must contain and only contain two integers when it\'s not original');
  /* {
    if (!isOriginal && thumbSize.length != 2) {
      throw ArgumentError(
        'thumbSize must contain and only contain two integers when it\'s not original',
      );
    } */

  /// File type for the image asset, use it for some special type detection.
  /// 图片资源的类型，用于某些特殊类型的判断
  ImageFileType get imageFileType => _getType();

  @override
  ImageStreamCompleter load(
      AssetEntityImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<AssetEntityImageProvider>('Image key', key),
        ];
      },
    );
  }

  @override
  Future<AssetEntityImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssetEntityImageProvider>(this);
  }

  Future<ui.Codec> _loadAsync(
    AssetEntityImageProvider key,
    DecoderCallback decode,
  ) async {
    assert(key == this);
    Uint8List? data;

    if (isOriginal) {
      //print('Loading original...');
      data = picStore.isPrivate.value
          ? await key.picStore.assetOriginBytes
          : await key.picStore.entity.value?.originBytes;
    } else {
      //print('Loading thumbnail...');
      if (picStore.entity.value == null) {
        //print('Entity is null & isPrivate: ${picStore.isPrivate}');
      }
      data = picStore.isPrivate.value
          ? await key.picStore.assetThumbBytes
          : await key.picStore.entity.value
              ?.thumbDataWithSize(thumbSize[0], thumbSize[1]);
    }

    // if (picStore.isPrivate == true) {
    //print('entity is null!!!');
    //   data = await key.picStore.assetOriginBytes;
    //   return decode(data);
    // }
    //
    // if (isOriginal ?? false) {
    //   if (imageFileType == ImageFileType.heic) {
    //     data = await (await key.picStore.entity.file).readAsBytes();
    //   } else {
    //     data = await key.picStore.entity.originBytes;
    //   }
    // } else {
    //   data = await key.picStore.entity.thumbDataWithSize(thumbSize[0], thumbSize[1]);
    // }
    return decode(data!);
  }

  /// Get image type by reading the file extension.
  /// 从图片后缀判断图片类型
  ///
  /// ⚠ Not all the system version support read file name from the entity,
  /// so this method might not work sometime.
  /// 并非所有的系统版本都支持读取文件名，所以该方法有时无法返回正确的type。
  ImageFileType _getType() {
    late ImageFileType type;

    final extension = picStore.entity.value == null
        ? picStore.photoPath.split('.').last
        : picStore.entity.value?.title?.split('.').last;
    //print('Extension: $extension');
    if (extension != null) {
      switch (extension.toLowerCase()) {
        case 'jpg':
        case 'jpeg':
          type = ImageFileType.jpg;
          break;
        case 'png':
          type = ImageFileType.png;
          break;
        case 'gif':
          type = ImageFileType.gif;
          break;
        case 'tiff':
          type = ImageFileType.tiff;
          break;
        case 'heic':
          type = ImageFileType.heic;
          break;
        default:
          type = ImageFileType.other;
          break;
      }
    }
    return type;
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final typedOther =
        // ignore: test_types_in_equals
        other as AssetEntityImageProvider;

    if (picStore.entity.value == null) {
      return picStore.photoPath == typedOther.picStore.photoPath;
    }

    return picStore.entity == typedOther.picStore.entity &&
        scale == typedOther.scale &&
        thumbSize == typedOther.thumbSize &&
        isOriginal == typedOther.isOriginal;
  }

  @override
  int get hashCode => hashValues(picStore.entity, scale, isOriginal);
}

enum ImageFileType { jpg, png, gif, tiff, heic, other }

enum SpecialImageType { gif, heic }
