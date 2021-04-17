import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/generated/l10n.dart';

import 'user_controller.dart';

class LoginStore extends GetxController {
  static LoginStore get to => Get.find();

  final slideIndex = 0.obs;

  int totalSlides = Board.values.length;

  @override
  void onInit() {
    super.onInit();
    UserController.to.createDefaultTags(Get.context);
  }

  //@action
  void setSlideIndex(int value) => slideIndex.value = value;

  String getDescription(BuildContext context, int value) {
    return Board.values[value].displayDescription(context);
  }

  Image getImage(int value) {
    return Board.values[value].image;
  }
}

enum Board {
  introduction,
  createTags,
  swipeRight,
  keepSecret,
  multiSelect,
}

extension SelectedBoard on Board {
  String displayDescription(BuildContext context) {
    switch (this) {
      case Board.introduction:
        return S.current.welcome;
      case Board.createTags:
        return S.current.tutorial_however_you_want;
      case Board.swipeRight:
        return S.current.tutorial_just_swipe;
      case Board.keepSecret:
        return S.current.tutorial_secret;
      case Board.multiSelect:
        return S.current.tutorial_multiselect;
      default:
        return null;
    }
  }

  Image get image {
    switch (this) {
      case Board.introduction:
        return null;
      case Board.createTags:
        return Image.asset('lib/images/onboardtagging.png');
      case Board.swipeRight:
        return Image.asset('lib/images/onboardswipe.png');
      case Board.keepSecret:
        return Image.asset('lib/images/onboardsecret.png');
      case Board.multiSelect:
        return Image.asset('lib/images/onboardmultiselect.png');
      default:
        return null;
    }
  }
}
