import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tags_provider.dart';

Future<void> refreshEverything(WidgetRef ref) async {
  await ref.read(tabsProvider.notifier).refreshUntaggedList();
  await ref.read(tagsProvider.notifier).tagsSuggestionsCalculate();
  ref.read(tagsProvider.notifier).clear();
}
