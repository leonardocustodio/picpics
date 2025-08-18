import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/screens/pin_screen.dart';
import 'package:picpics/screens/tabs_screen.dart';
import 'package:picpics/stores/pic_store.dart';
import 'package:picpics/stores/private_photos_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/delete_secret_modal.dart';
import 'package:picpics/widgets/unhide_secret_modal.dart';

Future<void> showDeleteSecretModalForMultiPic() async {
  if (UserController.to.keepAskingToDelete.value == false) {
    TabsController.to.setMultiTagSheet(false);
    TabsController.to.setMultiPicBar(false);
    await TagsController.to.addTagsToSelectedPics();
    return;
  }

  AppLogger.d('showModal');
  await showDialog<void>(
    context: Get.context!,
    builder: (BuildContext buildContext) {
      return DeleteSecretModal(
        onPressedClose: () async {
          Get.back<void>();
        },
        onPressedDelete: () async {
          await UserController.to.setShouldDeleteOnPrivate(false);
          TabsController.to.setMultiTagSheet(false);
          TabsController.to.setMultiPicBar(false);
          await TagsController.to.addTagsToSelectedPics();
          Get.back<void>();
        },
        onPressedOk: () async {
          await UserController.to.setShouldDeleteOnPrivate(true);
          TabsController.to.setMultiTagSheet(false);
          TabsController.to.setMultiPicBar(false);
          await TagsController.to.addTagsToSelectedPics();
          Get.back<void>();
        },
      );
    },
  );
}

Future<void> showDeleteSecretModal(
    /* BuildContext context, */ PicStore picStore,) async {
  if (true != PrivatePhotosController.to.showPrivate.value) {
    UserController.to.popPinScreenToId = TabsScreen.id;
    await Get.to<dynamic>(PinScreen.new);
    return;
  }

  if (UserController.to.keepAskingToDelete.value == false &&
      picStore.isPrivate.value == false) {
    //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
    return;
  }

  AppLogger.d('showModal');
  await showDialog<void>(
    context: Get.context!,
    builder: (BuildContext buildContext) {
      if (picStore.isPrivate.value == true) {
        return UnhideSecretModal(
          onPressedDelete: () {
            Get.back<void>();
          },
          onPressedOk: () {
            //GalleryStore.to.setPrivatePic(picStore: picStore, private: false);
            Get.back<void>();
          },
        );
      }
      return DeleteSecretModal(
        onPressedClose: () {
          Get.back<void>();
        },
        onPressedDelete: () async {
          //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          await UserController.to.setShouldDeleteOnPrivate(false);
          Get.back<void>();
        },
        onPressedOk: () async {
          //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          await UserController.to.setShouldDeleteOnPrivate(true);
          Get.back<void>();
        },
      );
    },
  );
}
