import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tags_controller.dart';

Future<void> refresh_everything() async {
  await PrivatePhotosController.to.refreshPrivatePics();
  await TabsController.to.refreshUntaggedList();
  await TagsController.to.loadAllTags();
  TagsController.to.loadLastMonthUsedTags();
  TagsController.to.loadLastWeekUsedTags();
  TagsController.to.loadMostUsedTags();
  await TagsController.to.tagsSuggestionsCalculate();
  TagsController.to.multiPicTags.clear();
}
