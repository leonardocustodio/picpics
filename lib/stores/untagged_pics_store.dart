import 'package:mobx/mobx.dart';
import 'package:picPics/stores/pic_store.dart';

part 'untagged_pics_store.g.dart';

class UntaggedPicsStore = _UntaggedPicsStore with _$UntaggedPicsStore;

abstract class _UntaggedPicsStore with Store {
  PicStore picStore;
  DateTime date;
  bool didChangeMonth;

  _UntaggedPicsStore({
    this.picStore,
    this.date,
    this.didChangeMonth,
  });
}
