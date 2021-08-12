import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/stores/tags_controller.dart';

Future<void> refresh_everything() async {
  await TabsController.to.refreshUntaggedList();
  await TagsController.to.tagsSuggestionsCalculate();
  TagsController.to.multiPicTags.clear();
}
