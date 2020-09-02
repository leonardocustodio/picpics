import 'package:mobx/mobx.dart';
import 'package:picPics/analytics_manager.dart';
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
  int currentTab = 1;

  @action
  void setCurrentTab(int value) {
    Analytics.sendCurrentTab(value);
    currentTab = value;
  }

  @observable
  bool multiPicBar = false;

  @action
  void setMultiPicBar(bool value) {
    if (value) {
      Analytics.sendEvent(Event.selected_photos);
    }
    multiPicBar = value;
  }

  @observable
  bool multiTagSheet = false;

  @action
  void setMultiTagSheet(bool value) {
    multiTagSheet = value;
  }

  @observable
  bool isLoading = false;

  @action
  void setIsLoading(bool value) {
    isLoading = value;
  }

  @observable
  bool modalCard = false;

  @action
  void setModalCard(bool value) {
    Analytics.sendEvent(Event.showed_card);
    modalCard = value;
  }

  @observable
  int tutorialIndex = 0;

  @action
  void setTutorialIndex(int value) => tutorialIndex = value;
}
