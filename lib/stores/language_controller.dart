import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/generated/l10n.dart' as language;

class LangControl extends GetxController {
  static LangControl get to => Get.find();

  late Rx<language.S> S;

  Future<void> changeLanguageTo(String languageCode) async {
    S.value = await language.S.load(Locale(languageCode));
  }
}
