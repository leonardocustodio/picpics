import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tagged_controller.dart';
import 'package:picPics/stores/tags_controller.dart';

Future<void> refresh_everything() async {
  await PrivatePhotosController.to.refreshPrivatePics();
  await TabsController.to.refreshUntaggedList();
  await TaggedController.to.refreshTaggedPhotos();
  await TagsController.to
    ..loadAllTags()
    ..loadLastMonthUsedTags()
    ..loadLastWeekUsedTags()
    ..loadMostUsedTags()
    ..loadRecentTags();
  TagsController.to.multiPicTags.clear();
}
