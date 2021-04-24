import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/widgets/delete_secret_modal.dart';
import 'package:picPics/widgets/unhide_secret_modal.dart';

void showDeleteSecretModalForMultiPic(TabsStore controller) {
  if (UserController.to.keepAskingToDelete.value == false) {
    controller.setMultiTagSheet(false);
    controller.setMultiPicBar(false);
    GalleryStore.to.addTagsToSelectedPics();
    return;
  }

  //print('showModal');
  showDialog<void>(
    context: Get.context,
    barrierDismissible: true,
    builder: (BuildContext buildContext) {
      return DeleteSecretModal(
        onPressedClose: () {
          Get.back();
        },
        onPressedDelete: () {
          UserController.to.setShouldDeleteOnPrivate(false);
          controller.setMultiTagSheet(false);
          controller.setMultiPicBar(false);
          GalleryStore.to.addTagsToSelectedPics();
          Get.back();
        },
        onPressedOk: () {
          UserController.to.setShouldDeleteOnPrivate(true);
          controller.setMultiTagSheet(false);
          controller.setMultiPicBar(false);
          GalleryStore.to.addTagsToSelectedPics();
          Get.back();
        },
      );
    },
  );
}

Future<void> showDeleteSecretModal(
    BuildContext context, PicStore picStore) async {
  if (UserController.to.secretPhotos != true) {
    UserController.to.popPinScreen = PopPinScreenTo.TabsScreen;
    Get.toNamed(PinScreen.id);
    return;
  }

  if (UserController.to.isPremium == false) {
    int freePrivatePics = await UserController.to.freePrivatePics;
    if (UserController.to.totalPrivatePics >= freePrivatePics &&
        picStore.isPrivate == false) {
      Get.toNamed(PremiumScreen.id);
      return;
    }
  }

  if (UserController.to.keepAskingToDelete == false &&
      picStore.isPrivate == false) {
    GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
    return;
  }

  //print('showModal');
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext buildContext) {
      if (picStore.isPrivate == true) {
        return UnhideSecretModal(
          onPressedDelete: () {
            Get.back();
          },
          onPressedOk: () {
            GalleryStore.to.setPrivatePic(picStore: picStore, private: false);
            Get.back();
          },
        );
      }
      return DeleteSecretModal(
        onPressedClose: () {
          Get.back();
        },
        onPressedDelete: () {
          GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          UserController.to.setShouldDeleteOnPrivate(false);
          Get.back();
        },
        onPressedOk: () {
          GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          UserController.to.setShouldDeleteOnPrivate(true);
          Get.back();
        },
      );
    },
  );
}
