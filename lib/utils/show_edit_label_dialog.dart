import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/managers/database_manager.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/cupertino_input_dialog.dart';

Future<void> showEditTagModal(String tagKey) async {
  if (tagKey.trim().isNotEmpty && tagKey != kSecretTagKey) {
    final alertInputController = TextEditingController();
    final tagName = await DatabaseManager.instance.getTagName(tagKey);
    alertInputController.text = tagName ?? '';

    AppLogger.d('showModal');
    await showDialog<void>(
      context: Get.context!,
      builder: (_) {
        return Obx(
          () => CupertinoInputDialog(
            prefixImage: Image.asset('lib/images/smalladdtag.png'),
            alertInputController: alertInputController,
            title: LangControl.to.S.value.edit_tag,
            destructiveButtonTitle: LangControl.to.S.value.delete,
            onPressedDestructive: () {
              TagsController.to.deleteTagFromPic(tagKey: tagKey);
              Get.back<void>();
            },
            defaultButtonTitle: LangControl.to.S.value.ok,
            onPressedDefault: () {
              AppLogger.d(
                  'Editing tag - Old name: $tagKey - New name: ${alertInputController.text}',);
              if (tagName != alertInputController.text) {
                TagsController.to.editTagName(
                    oldTagKey: tagKey, newName: alertInputController.text,);
              }
              Get.back<void>();
            },
          ),
        );
      },
    );
  }
}
