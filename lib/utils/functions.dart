import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/widgets/delete_secret_modal.dart';
import 'package:picPics/widgets/unhide_secret_modal.dart';

void showDeleteSecretModalForMultiPic() async {
  if (UserController.to.keepAskingToDelete.value == false) {
    TabsController.to.setMultiTagSheet(false);
    TabsController.to.setMultiPicBar(false);
    await TagsController.to.addTagsToSelectedPics();
    return;
  }

  print('showModal');
  await showDialog<void>(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext buildContext) {
      return DeleteSecretModal(
        onPressedClose: () async {
          Get.back();
        },
        onPressedDelete: () async {
          await UserController.to.setShouldDeleteOnPrivate(false);
          TabsController.to.setMultiTagSheet(false);
          TabsController.to.setMultiPicBar(false);
          await TagsController.to.addTagsToSelectedPics();
          Get.back();
        },
        onPressedOk: () async {
          await UserController.to.setShouldDeleteOnPrivate(true);
          TabsController.to.setMultiTagSheet(false);
          TabsController.to.setMultiPicBar(false);
          await TagsController.to.addTagsToSelectedPics();
          Get.back();
        },
      );
    },
  );
}

Future<void> showDeleteSecretModal(
    /* BuildContext context, */ PicStore picStore) async {
  if (true != PrivatePhotosController.to.showPrivate.value) {
    UserController.to.popPinScreenToId = TabsScreen.id;
    await Get.to(() => PinScreen());
    return;
  }

  /* if (UserController.to.isPremium.value == false) {
    final freePrivatePics = UserController.to.freePrivatePics;
    if (UserController.to.totalPrivatePics >= freePrivatePics &&
        picStore.isPrivate.value == false) {
      await Get.to(() => PremiumScreen());
      return;
    }
  } */

  if (UserController.to.keepAskingToDelete.value == false &&
      picStore.isPrivate.value == false) {
    //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
    return;
  }

  print('showModal');
  await showDialog<void>(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext buildContext) {
      if (picStore.isPrivate.value == true) {
        return UnhideSecretModal(
          onPressedDelete: () {
            Get.back();
          },
          onPressedOk: () {
            //GalleryStore.to.setPrivatePic(picStore: picStore, private: false);
            Get.back();
          },
        );
      }
      return DeleteSecretModal(
        onPressedClose: () {
          Get.back();
        },
        onPressedDelete: () async {
          //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          await UserController.to.setShouldDeleteOnPrivate(false);
          Get.back();
        },
        onPressedOk: () async {
          //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          await UserController.to.setShouldDeleteOnPrivate(true);
          Get.back();
        },
      );
    },
  );
}
