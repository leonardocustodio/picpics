import 'package:get/get.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/stores/tabs_controller.dart';

class SwiperTabController extends GetxController {
  static SwiperTabController get to => Get.find();
  final swipeIndex = 0.obs;
  final isLoaded = false.obs;

  final swiperPicIdList = <String>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() {
    TabsController.to.refreshUntaggedList().then((_) {
      swiperPicIdList.value =
          List<String>.from(TabsController.to.allUnTaggedPics.keys.toList());
      isLoaded.value = true;
    });
  }

  void setSwipeIndex(int index) {
    swipeIndex.value = index;

    Analytics.sendEvent(Event.swiped_photo);
  }
}
