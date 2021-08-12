import 'package:get/get.dart';

class PercentageDialogController extends GetxController {
  static PercentageDialogController get to => Get.find();
  final total = 0.0.obs;
  final value = 0.0.obs;
  final show = false.obs;
  final text = RxnString();

  void start(double totalLength, [String? showingText]) {
    if (show.value == false) {
      text.value = showingText;
      value.value = .0;
      total.value = totalLength;
      show.value = true;
    }
  }

  void increaseValue(double val) {
    if ((value.value + val) < total.value) {
      value.value += val;
    } else {
      stop();
    }
  }

  Future<void> stop() async {
    if (show.value) {
      show.value = false;
      value.value = .0;
    }
  }
}
