import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/stores/language_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/widgets/cupertino_input_dialog.dart';
import '../constants.dart';

Future<void> showEditTagModal(String tagKey, [bool checkSecret = true]) async {
  if (tagKey != '' && (!checkSecret || tagKey != kSecretTagKey)) {
    final alertInputController = TextEditingController();
    final tagName = await DatabaseManager.instance.getTagName(tagKey);
    alertInputController.text = tagName ?? '';

    //print('showModal');
    await showDialog<void>(
      context: Get.context!,
      barrierDismissible: true,
      builder: (_) {
        return Obx(
          () => CupertinoInputDialog(
            prefixImage: Image.asset('lib/images/smalladdtag.png'),
            alertInputController: alertInputController,
            title: LangControl.to.S.value.edit_tag,
            destructiveButtonTitle: LangControl.to.S.value.delete,
            onPressedDestructive: () {
              TagsController.to.deleteTagFromPic(tagKey: tagKey);
              Get.back();
            },
            defaultButtonTitle: LangControl.to.S.value.ok,
            onPressedDefault: () {
//print(Editing tag - Old name: ${DatabaseManager.instance.selectedTagKey} - New name: ${alertInputController.text}');
              if (tagName != alertInputController.text) {
                TagsController.to.editTagName(
                    oldTagKey: tagKey, newName: alertInputController.text);
              }
              Get.back();
            },
          ),
        );
      },
    );
  }
}
