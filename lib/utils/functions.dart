import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/screens/pin_screen.dart';
import 'package:picPics/screens/premium/premium_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/widgets/delete_secret_modal.dart';
import 'package:picPics/widgets/unhide_secret_modal.dart';

void showDeleteSecretModalForMultiPic(
    BuildContext context, TabsStore controller) {
  if (AppStore.to.keepAskingToDelete == false) {
    controller.setMultiTagSheet(false);
    controller.setMultiPicBar(false);
    GalleryStore.to.addTagsToSelectedPics();
    return;
  }

  //print('showModal');
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext buildContext) {
      return DeleteSecretModal(
        onPressedClose: () {
          Navigator.of(context).pop();
        },
        onPressedDelete: () {
          AppStore.to.setShouldDeleteOnPrivate(false);
          controller.setMultiTagSheet(false);
          controller.setMultiPicBar(false);
          GalleryStore.to.addTagsToSelectedPics();
          Get.back();
        },
        onPressedOk: () {
          AppStore.to.setShouldDeleteOnPrivate(true);
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
  if (AppStore.to.secretPhotos != true) {
    AppStore.to.popPinScreen = PopPinScreenTo.TabsScreen;
    Get.toNamed(PinScreen.id);
    return;
  }

  if (AppStore.to.isPremium == false) {
    int freePrivatePics = await AppStore.to.freePrivatePics;
    if (AppStore.to.totalPrivatePics >= freePrivatePics &&
        picStore.isPrivate == false) {
      Get.toNamed(PremiumScreen.id);
      return;
    }
  }

  if (AppStore.to.keepAskingToDelete == false && picStore.isPrivate == false) {
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
            Navigator.of(context).pop();
          },
          onPressedOk: () {
            GalleryStore.to.setPrivatePic(picStore: picStore, private: false);
            Navigator.of(context).pop();
          },
        );
      }
      return DeleteSecretModal(
        onPressedClose: () {
          Navigator.of(context).pop();
        },
        onPressedDelete: () {
          GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          AppStore.to.setShouldDeleteOnPrivate(false);
          Navigator.of(context).pop();
        },
        onPressedOk: () {
          GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          AppStore.to.setShouldDeleteOnPrivate(true);
          Navigator.of(context).pop();
        },
      );
    },
  );
}
