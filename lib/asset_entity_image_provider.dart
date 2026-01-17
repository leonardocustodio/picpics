// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/pic_store_provider.dart';
import 'package:picpics/utils/app_logger.dart';

@immutable
class AssetEntityImageProvider extends ImageProvider<AssetEntityImageProvider> {
  const AssetEntityImageProvider(
    this.picStore, {
    this.scale = 1.0,
    this.thumbSize = kDefaultPreviewThumbSize,
    this.isOriginal = true,
  }) : assert(
          isOriginal || thumbSize.length == 2,
          'thumbSize must contain and only contain two integers when it\'s not original',
        );
  final PicStoreNotifier picStore;

  /// Scale for image provider.
  /// 缩放
  final double scale;

  /// Size for thumb data.
  /// 缩略图的大小
  final List<int> thumbSize;

  /// Choose if original data or thumb data should be loaded.
  /// 选择载入原数据还是缩略图数据
  final bool isOriginal;
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
  ImageStreamCompleter loadImage(
    AssetEntityImageProvider key,
    ImageDecoderCallback decode,
  ) {
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
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    Uint8List? data;

    if (isOriginal) {
      AppLogger.d('Loading original...');
      data =
          picStore.state.isPrivate ? await key.picStore.assetOriginBytes : await key.picStore.state.entity?.originBytes;
    } else {
      AppLogger.d('Loading thumbnail...');
      if (picStore.state.entity == null) {
        AppLogger.d('Entity is null & isPrivate: ${picStore.state.isPrivate}');
      }
      data = picStore.state.isPrivate
          ? await key.picStore.assetThumbBytes
          : await key.picStore.state.entity?.thumbnailDataWithSize(
              ThumbnailSize(thumbSize[0], thumbSize[1]),
            );

      // TODO: Blur hash generation needs to be moved to a provider-aware context
      // Cannot access Riverpod provider from ImageProvider
      // if (data != null) {
      //   await createBlurHash(picStore.photoId.value, data);
      // }
    }

    // if (picStore.state.isPrivate == true) {
    AppLogger.d('entity is null!!!');
    //   data = await key.picStore.assetOriginBytes;
    //   return decode(data);
    // }
    //
    // if (isOriginal ?? false) {
    //   if (imageFileType == ImageFileType.heic) {
    //     data = await (await key.picStore.state.entity.file).readAsBytes();
    //   } else {
    //     data = await key.picStore.state.entity.originBytes;
    //   }
    // } else {
    //   data = await key.picStore.state.entity.thumbDataWithSize(thumbSize[0], thumbSize[1]);
    // }
    final buffer = await ui.ImmutableBuffer.fromUint8List(data!);
    return decode(buffer);
  }

  /// Get image type by reading the file extension.
  /// 从图片后缀判断图片类型
  ///
  /// ⚠ Not all the system version support read file name from the entity,
  /// so this method might not work sometime.
  /// 并非所有的系统版本都支持读取文件名，所以该方法有时无法返回正确的type。
  ImageFileType _getType() {
    late ImageFileType type;

    final extension = picStore.state.entity == null
        ? picStore.state.photoPath.split('.').last
        : picStore.state.entity?.title?.split('.').last;
    AppLogger.d('Extension: $extension');
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final typedOther = other as AssetEntityImageProvider;

    if (picStore.state.entity == null) {
      return picStore.state.photoPath == typedOther.picStore.state.photoPath;
    }

    return picStore.state.entity == typedOther.picStore.state.entity &&
        scale == typedOther.scale &&
        thumbSize == typedOther.thumbSize &&
        isOriginal == typedOther.isOriginal;
  }

  @override
  int get hashCode => Object.hash(picStore.state.entity, scale, isOriginal);
}

enum ImageFileType { jpg, png, gif, tiff, heic, other }

enum SpecialImageType { gif, heic }
