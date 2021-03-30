//import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';
//import 'package:photo_manager/photo_manager.dart';
//import 'package:picPics/stores/gallery_store.dart';
//
//
//class AssetChangeNotifier {
//  static void registerObserve() {
//    try {
/* //print('%%%%%% Registered change notifier'); */
//      PhotoManager.addChangeCallback(_onAssetChange);
//      PhotoManager.startChangeNotify();
//    } catch (e) {
/* //print('Error when registering assets callback: $e'); */
//    }
//  }
//
//  /// Unregister the observation callback with assets changes.
//  static void unregisterObserve() {
//    try {
//      PhotoManager.removeChangeCallback(_onAssetChange);
//      PhotoManager.stopChangeNotify();
//    } catch (e) {
/* //print('Error when unregistering assets callback: $e'); */
//    }
//  }
//
//  static void _onAssetChange(MethodCall call) async {
/* //print('#!#!#!#!#!#! asset changed: ${call.arguments}'); */
//
//    List<dynamic> createdPics = call.arguments['create'];
//    List<dynamic> deletedPics = call.arguments['delete'];
////print(deletedPics);
//
//    if (deletedPics.length > 0) {
/* //print('### deleted pics from library!'); */
//      for (var pic in deletedPics) {
/* //print('Pic deleted Id: ${pic['id']}'); */
////        AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
////        AssetEntity entity = pathProvider.orderedList.firstWhere((element) => element.id == pic['id'], orElse: () => null);
////
////        if (entity != null) {
////          galleryStore.trashPic(picStore)
////          DatabaseManager.instance.deletedPic(
////            entity,
////            removeFromDb: false,
////          );
////        }
//      }
//    }
//
//    if (createdPics.length > 0) {
//      for (var pic in createdPics) {
/* //print('Pic created Id: ${pic['id']}'); */
//        AssetEntity picEntity = await AssetEntity.fromId(pic['id']);
//        galleryStore.addEntity(picEntity);
//      }
//    }
//  }
//}
