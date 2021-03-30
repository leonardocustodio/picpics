import 'package:flutter/cupertino.dart';

import 'package:picPics/generated/l10n.dart';

class LoginStore {
  LoginStore() {
    // autorun((_) {
    // //print('autorun');
    // });
  }

  @observable
  int slideIndex = 0;

  int totalSlides = Board.values.length;

  @action
  void setSlideIndex(int value) => slideIndex = value;

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
        return S.of(context).welcome;
      case Board.createTags:
        return S.of(context).tutorial_however_you_want;
      case Board.swipeRight:
        return S.of(context).tutorial_just_swipe;
      case Board.keepSecret:
        return S.of(context).tutorial_secret;
      case Board.multiSelect:
        return S.of(context).tutorial_multiselect;
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
