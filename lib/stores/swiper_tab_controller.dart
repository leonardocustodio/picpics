import 'package:get/get.dart';

class SwiperTabController extends GetxController {
  static SwiperTabController get to => Get.find();

  final swiperPicIdList = <String, String>{}.obs;
}
