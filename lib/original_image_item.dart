import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/lru_cache.dart';
import 'dart:typed_data';

class OriginalImageItem extends StatelessWidget {
  final AssetEntity entity;
  final Color backgroundColor;
  final int size;
  final BoxFit fit;

  const OriginalImageItem({
    Key key,
    this.entity,
    this.backgroundColor,
    this.size = 64,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: entity.thumbDataWithSize(entity.size.width.toInt(), entity.size.height.toInt()),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        var futureData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done && futureData != null) {
//          ImageLruCache.setData(entity, size, futureData);
          return _buildImageItem(context, futureData);
        }

        return Container(
          color: backgroundColor,
        );
      },
    );
  }

  Widget _buildImageItem(BuildContext context, Uint8List data) {
    var image = Image.memory(
      data,
      width: double.infinity,
      height: double.infinity,
//      fit: fit,
    );

    return image;
  }
}
