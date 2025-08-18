import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/stores/tags_controller.dart';

Future<void> refreshEverything() async {
  await TabsController.to.refreshUntaggedList();
  await TagsController.to.tagsSuggestionsCalculate();
  TagsController.to.multiPicTags.clear();
}
