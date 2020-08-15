import 'package:mobx/mobx.dart';
import 'package:picPics/stores/app_store.dart';

part 'pic_store.g.dart';

class PicStore = _PicStore with _$PicStore;

abstract class _PicStore with Store {
  final AppStore appStore;

  _PicStore({this.appStore}) {
    autorun((_) {
      print('autorun');
    });
  }
}
