import 'package:mobx/mobx.dart';
import 'package:picPics/stores/app_store.dart';

part 'gallery_store.g.dart';

class GalleryStore = _GalleryStore with _$GalleryStore;

abstract class _GalleryStore with Store {
  final AppStore appStore;

  _GalleryStore({this.appStore}) {
    autorun((_) {
      print('autorun');
    });
  }
}
