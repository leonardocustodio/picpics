// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:picPics/lru_cache.dart';
// import 'package:picPics/constants.dart';
// import 'dart:typed_data';
//
// class ImageItem extends StatelessWidget {
//   final AssetEntity entity;
//   final Color backgroundColor;
//   final int size;
//   final BoxFit fit;
//   final bool showOverlay;
//   final bool isSelected;
//   final Function onTap;
//
//   const ImageItem({
//     Key key,
//     this.entity,
//     this.backgroundColor,
//     this.size = 64,
//     this.fit = BoxFit.cover,
//     this.showOverlay = false,
//     this.isSelected = false,
//     this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var thumb = ImageLruCache.getData(entity, size);
//     if (thumb != null) {
//       return onTap != null
//           ? GestureDetector(
//               onTap: onTap,
//               child: _buildImageItem(context, thumb),
//             )
//           : _buildImageItem(context, thumb);
//     }
//
//     return FutureBuilder<Uint8List>(
//       future: entity.thumbDataWithSize(size, size),
//       builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
//         var futureData = snapshot.data;
//         if (snapshot.connectionState == ConnectionState.done && futureData != null) {
//           ImageLruCache.setData(entity, size, futureData);
//           return onTap != null
//               ? GestureDetector(
//                   onTap: onTap,
//                   child: _buildImageItem(context, futureData),
//                 )
//               : _buildImageItem(context, futureData);
//         }
//         return onTap != null
//             ? GestureDetector(
//                 onTap: onTap,
//                 child: Container(
//                   color: backgroundColor,
//                 ),
//               )
//             : Container(
//                 color: backgroundColor,
//               );
//       },
//     );
//   }
//
//   Widget _buildImageItem(BuildContext context, Uint8List data) {
//     var image = ClipRRect(
//       borderRadius: BorderRadius.circular(5.0),
//       child: Image.memory(
//         data,
//         width: double.infinity,
//         height: double.infinity,
//         fit: fit,
//       ),
//     );
//
//     if (showOverlay) {
//       if (isSelected) {
//         return Stack(
//           children: <Widget>[
//             image,
//             Container(
//               decoration: BoxDecoration(
//                 color: kSecondaryColor.withOpacity(0.3),
//                 border: Border.all(
//                   color: kSecondaryColor,
//                   width: 2.0,
//                 ),
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//             ),
//             Positioned(
//               left: 8.0,
//               top: 6.0,
//               child: Container(
//                 height: 20,
//                 width: 20,
//                 decoration: BoxDecoration(
//                   gradient: kSecondaryGradient,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Image.asset('lib/images/checkwhiteico.png'),
//               ),
//             )
//           ],
//         );
//       }
//
//       return Stack(
//         children: <Widget>[
//           image,
//           Positioned(
//             left: 8.0,
//             top: 6.0,
//             child: Container(
//               height: 20,
//               width: 20,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.0),
//                 border: Border.all(
//                   color: kGrayColor,
//                   width: 2.0,
//                 ),
//               ),
//             ),
//           )
//         ],
//       );
//     }
//
//     return image;
//   }
// }
