// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/providers/private_photos_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/pin_screen.dart';
import 'package:picpics/providers/pic_store_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/delete_secret_modal.dart';
import 'package:picpics/widgets/unhide_secret_modal.dart';

Future<void> showDeleteSecretModalForMultiPic(BuildContext context, WidgetRef ref) async {
  final userState = ref.read(userProvider);

  if (userState.keepAskingToDelete == false) {
    ref.read(tabsProvider.notifier).setMultiTagSheet(false);
    ref.read(tabsProvider.notifier).setMultiPicBar(false);
    await ref.read(tagsProvider.notifier).addTagsToSelectedPics();
    return;
  }

  AppLogger.d('showModal');
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (BuildContext buildContext) {
      return DeleteSecretModal(
        onPressedClose: () async {
          Navigator.of(buildContext).pop();
        },
        onPressedDelete: () async {
          ref.read(userProvider.notifier).setShouldDeleteOnPrivate(false);
          ref.read(tabsProvider.notifier).setMultiTagSheet(false);
          ref.read(tabsProvider.notifier).setMultiPicBar(false);
          await ref.read(tagsProvider.notifier).addTagsToSelectedPics();
          if (buildContext.mounted) Navigator.of(buildContext).pop();
        },
        onPressedOk: () async {
          ref.read(userProvider.notifier).setShouldDeleteOnPrivate(true);
          ref.read(tabsProvider.notifier).setMultiTagSheet(false);
          ref.read(tabsProvider.notifier).setMultiPicBar(false);
          await ref.read(tagsProvider.notifier).addTagsToSelectedPics();
          if (buildContext.mounted) Navigator.of(buildContext).pop();
        },
      );
    },
  );
}

Future<void> showDeleteSecretModal(
  BuildContext context,
  WidgetRef ref,
  PicStoreNotifier picStore,
) async {
  final privatePhotosState = ref.read(privatePhotosProvider);

  if (privatePhotosState.showPrivate != true) {
    // TODO(Week 3D): Add popPinScreenToId property to UserState if needed
    // For now, just navigate to PIN screen
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<dynamic>(builder: (_) => const PinScreen()),
    );
    return;
  }

  final userState = ref.read(userProvider);
  if (userState.keepAskingToDelete == false && picStore.state.isPrivate == false) {
    //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
    return;
  }

  AppLogger.d('showModal');
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (BuildContext buildContext) {
      if (picStore.state.isPrivate == true) {
        return UnhideSecretModal(
          onPressedDelete: () {
            Navigator.of(buildContext).pop();
          },
          onPressedOk: () {
            //GalleryStore.to.setPrivatePic(picStore: picStore, private: false);
            Navigator.of(buildContext).pop();
          },
        );
      }
      return DeleteSecretModal(
        onPressedClose: () {
          Navigator.of(buildContext).pop();
        },
        onPressedDelete: () async {
          //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          ref.read(userProvider.notifier).setShouldDeleteOnPrivate(false);
          Navigator.of(buildContext).pop();
        },
        onPressedOk: () async {
          //GalleryStore.to.setPrivatePic(picStore: picStore, private: true);
          ref.read(userProvider.notifier).setShouldDeleteOnPrivate(true);
          Navigator.of(buildContext).pop();
        },
      );
    },
  );
}
