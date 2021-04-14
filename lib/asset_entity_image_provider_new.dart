import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/stores/pic_store.dart';

@immutable
class AssetEntityImageProviderKawal extends ImageProvider<AssetEntityImageProviderKawal> {
  final AssetEntity entity;

  /// Scale for image provider.
  /// 缩放
  final double scale;

  /// Size for thumb data.
  /// 缩略图的大小
  final List<int> thumbSize;
  final String photoPath;

  final Future<Uint8List> originBytes;
  final Future<Uint8List> thumbBytes;

  /// Choose if original data or thumb data should be loaded.
  /// 选择载入原数据还是缩略图数据
  final bool isOriginal;
  AssetEntityImageProviderKawal(
    this.entity, {
    @required this.originBytes,
    @required this.thumbBytes,
    this.photoPath,
    this.scale = 1.0,
    this.thumbSize = kDefaultPreviewThumbSize,
    this.isOriginal = true,
  }) : assert(
          isOriginal || thumbSize?.length == 2,
          'thumbSize must contain and only contain two integers when it\'s not original',
        ) {
    if (!isOriginal && thumbSize?.length != 2) {
      throw ArgumentError(
        'thumbSize must contain and only contain two integers when it\'s not original',
      );
    }
  }

  /// File type for the image asset, use it for some special type detection.
  /// 图片资源的类型，用于某些特殊类型的判断
  //ImageFileType get imageFileType => _getType();

  @override
  ImageStreamCompleter load(
      AssetEntityImageProviderKawal key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<AssetEntityImageProviderKawal>('Image key', key),
        ];
      },
    );
  }

  @override
  Future<AssetEntityImageProviderKawal> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssetEntityImageProviderKawal>(this);
  }

  Future<ui.Codec> _loadAsync(
    AssetEntityImageProviderKawal key,
    DecoderCallback decode,
  ) async {
    assert(key == this);
    Uint8List data;

    if (isOriginal ?? false) {
      //print('Loading original...');
      data = await originBytes;

      /* isPrivate.value
          ? await key.assetOriginBytes
          : await key.entity.value.originBytes; */
    } else {
      //print('Loading thumbnail...');
      /* if (entity == null) {
        //print('Entity is null & isPrivate: ${isPrivate}');
      } */
      data = await thumbBytes;
      /* isPrivate.value
          ? await key.assetThumbBytes
          : await key.entity.value
              .thumbDataWithSize(thumbSize[0], thumbSize[1]); */
    }

    // if (isPrivate == true) {
    //print('entity is null!!!');
    //   data = await key.assetOriginBytes;
    //   return decode(data);
    // }
    //
    // if (isOriginal ?? false) {
    //   if (imageFileType == ImageFileType.heic) {
    //     data = await (await key.entity.file).readAsBytes();
    //   } else {
    //     data = await key.entity.originBytes;
    //   }
    // } else {
    //   data = await key.entity.thumbDataWithSize(thumbSize[0], thumbSize[1]);
    // }
    return decode(data);
  }

  /// Get image type by reading the file extension.
  /// 从图片后缀判断图片类型
  ///
  /// ⚠ Not all the system version support read file name from the entity,
  /// so this method might not work sometime.
  /// 并非所有的系统版本都支持读取文件名，所以该方法有时无法返回正确的type。
  /* ImageFileType _getType() {
    ImageFileType type;
    final String extension = entity == null
        ? photoPath?.split('.')?.last
        : entity.value.title?.split('.')?.last;
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
  } */

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final AssetEntityImageProviderKawal typedOther =
        // ignore: test_types_in_equals
        other as AssetEntityImageProviderKawal;

    if (entity == null) {
      return photoPath == typedOther.photoPath;
    }

    return entity == typedOther.entity &&
        scale == typedOther.scale &&
        thumbSize == typedOther.thumbSize &&
        isOriginal == typedOther.isOriginal;
  }

  @override
  int get hashCode => hashValues(entity, scale, isOriginal);
}

enum ImageFileType { jpg, png, gif, tiff, heic, other }

enum SpecialImageType { gif, heic }
