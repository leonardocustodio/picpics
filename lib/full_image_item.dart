// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:picpics/lru_cache.dart';
// import 'dart:typed_data';
//
// import 'package:picpics/stores/pic_store.dart';
//
// class FullImageItem extends StatelessWidget {
//   final PicStore picStore;
//   final Color backgroundColor;
//   final int size;
//   final BoxFit fit;
//
//   const FullImageItem({
//     Key key,
//     this.picStore,
//     this.backgroundColor,
//     this.size = 64,
//     this.fit = BoxFit.cover,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var thumb = ImageLruCache.getData(entity, size);
//     if (thumb != null) {
//       return _buildImageItem(context, thumb);
//     }
//
//     return FutureBuilder<Uint8List>(
//       future: entity.thumbDataWithSize(size, size),
//       builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
//         var futureData = snapshot.data;
//         if (snapshot.connectionState == ConnectionState.done && futureData != null) {
//           ImageLruCache.setData(entity, size, futureData);
//           return _buildImageItem(context, futureData);
//         }
//         return Container(
//           color: backgroundColor,
//         );
//       },
//     );
//   }
//
//   Widget _buildImageItem(BuildContext context, Uint8List data) {
//     var image = Image.memory(
//       data,
//       width: double.infinity,
//       height: double.infinity,
//       fit: fit,
//     );
//
//     return image;
//   }
// }
