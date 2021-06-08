/* import 'package:get/get.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/swiper_tab_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshPicPicsController extends GetxController {
  static RefreshPicPicsController get to => Get.find();

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await PrivatePhotosController.to.refreshPrivatePics();
    await TabsController.to.refreshUntaggedList();
    await SwiperTabController.to.refreshSwiperList();
    await TaggedController.to.refreshTaggedPhotos();
    await refreshController.refreshCompleted();
  }
}
 */