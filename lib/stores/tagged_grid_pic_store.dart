import 'package:mobx/mobx.dart';
import 'package:picPics/stores/pic_store.dart';

part 'tagged_grid_pic_store.g.dart';

class TaggedGridPicStore = _TaggedGridPicStore with _$TaggedGridPicStore;

abstract class _TaggedGridPicStore with Store {
  final DateTime date;
  final PicStore picStore;

  _TaggedGridPicStore({this.date, this.picStore});
}
