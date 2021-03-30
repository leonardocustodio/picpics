import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';

class TabsStore {
  final AppStore appStore;
  final GalleryStore galleryStore;

  TabsStore({this.appStore, this.galleryStore}) {}

  @observable
  int currentTab = 0;

  @action
  void setCurrentTab(int value) {
    if (currentTab == value) {
      return;
    }

    if (currentTab == 1) {
      galleryStore.setSwipeIndex(galleryStore.swipeIndex);
    } else if (currentTab == 2) {
      galleryStore.clearSearchTags();
    }

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

  double offsetFirstTab = 0.0;

  @observable
  double topOffsetFirstTab = 64.0;

  @action
  void setTopOffsetFirstTab(double value) {
    if (value == topOffsetFirstTab) {
      return;
    }
    topOffsetFirstTab = value;
  }

  double offsetThirdTab = 0.0;

  @observable
  bool hideTitleThirdTab = false;

  @action
  void setHideTitleThirdTab(bool value) {
    if (value == hideTitleThirdTab) {
      return;
    }
    hideTitleThirdTab = value;
  }

  @observable
  bool showDeleteSecretModal = false;

  @action
  void setShowDeleteSecretModal(bool value) => showDeleteSecretModal = value;

  @observable
  bool isScrolling = false;

  @action
  void setIsScrolling(bool value) => isScrolling = value;

  @observable
  bool isToggleBarVisible = true;

  @action
  void setIsToggleBarVisible(bool value) => isToggleBarVisible = value;

  @observable
  int toggleIndexUntagged = 0;

  @action
  void setToggleIndexUntagged(int value) => toggleIndexUntagged = value;

  @observable
  int toggleIndexTagged = 1;

  @action
  void setToggleIndexTagged(int value) => toggleIndexTagged = value;
}
