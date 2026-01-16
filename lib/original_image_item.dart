import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class OriginalImageItem extends StatelessWidget {

  const OriginalImageItem({
    required this.backgroundColor, super.key,
    this.entity,
    this.size = 64,
    this.fit = BoxFit.cover,
  });
  final AssetEntity? entity;
  final Color backgroundColor;
  final int size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: entity!.thumbnailDataWithSize(ThumbnailSize(
          entity!.size.width.toInt(), entity!.size.height.toInt(),),),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        final futureData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done &&
            futureData != null) {
          return _buildImageItem(context, futureData);
        }

        return Container(
          color: backgroundColor,
        );
      },
    );
  }

  Widget _buildImageItem(BuildContext context, Uint8List data) {
    final image = Image.memory(
      data,
      width: double.infinity,
      height: double.infinity,
    );

    return image;
  }
}
