import 'package:mobx/mobx.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';

part 'tabs_store.g.dart';

class TabsStore = _TabsStore with _$TabsStore;

abstract class _TabsStore with Store {
  final AppStore appStore;

  _TabsStore({this.appStore}) {
    autorun((_) {
      print('autorun!');
    });
  }

  @observable
  int currentTab = 0;

  @action
  void setCurrentTab(int value) {
    currentTab = value;
  }
}
