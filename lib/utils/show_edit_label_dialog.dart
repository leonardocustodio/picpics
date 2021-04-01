import 'package:flutter/material.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/widgets/cupertino_input_dialog.dart';
import '../constants.dart';

Future<void> showEditTagModal(BuildContext context,
    [bool checkSecret = true]) async {
  if (DatabaseManager.instance.selectedTagKey != '' &&
      (!checkSecret ||
          DatabaseManager.instance.selectedTagKey != kSecretTagKey)) {
    TextEditingController alertInputController = TextEditingController();
//      Pic getPic = galleryStore.currentPic  DatabaseManager.instance.getPicInfo(DatabaseManager.instance.selectedPhoto.id);
    String tagName = await DatabaseManager.instance
        .getTagName(DatabaseManager.instance.selectedTagKey);
    alertInputController.text = tagName;

    //print('showModal');
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return CupertinoInputDialog(
          prefixImage: Image.asset('lib/images/smalladdtag.png'),
          alertInputController: alertInputController,
          title: S.of(context).edit_tag,
          destructiveButtonTitle: S.of(context).delete,
          onPressedDestructive: () {
            //print('Deleting tag: ${DatabaseManager.instance.selectedTagKey}');
            GalleryStore.to
                .deleteTag(tagKey: DatabaseManager.instance.selectedTagKey);
            Navigator.of(context).pop();
          },
          defaultButtonTitle: S.of(context).ok,
          onPressedDefault: () {
/* //print(Editing tag - Old name: ${DatabaseManager.instance.selectedTagKey} - New name: ${alertInputController.text}'); */
            if (tagName != alertInputController.text) {
              GalleryStore.to.editTag(
                oldTagKey: DatabaseManager.instance.selectedTagKey,
                newName: alertInputController.text,
              );
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
