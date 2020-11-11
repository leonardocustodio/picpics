import 'package:mobx/mobx.dart';
import 'package:picPics/stores/pic_store.dart';

part 'untagged_grid_pic_store.g.dart';

class UntaggedGridPicStore = _UntaggedGridPicStore with _$UntaggedGridPicStore;

abstract class _UntaggedGridPicStore with Store {
  final DateTime date;
  final PicStore picStore;

  _UntaggedGridPicStore({this.date, this.picStore});

}
