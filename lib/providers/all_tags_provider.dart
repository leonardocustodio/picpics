import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/utils/helpers.dart';

class AllTagsState {
  AllTagsState({
    this.selectedTags = const {},
    this.searchedTags = const {},
    this.searchedText = '',
  });
  final Map<String, TagModel> selectedTags;
  final Map<String, TagModel> searchedTags;
  final String searchedText;

  AllTagsState copyWith({
    Map<String, TagModel>? selectedTags,
    Map<String, TagModel>? searchedTags,
    String? searchedText,
  }) {
    return AllTagsState(
      selectedTags: selectedTags ?? this.selectedTags,
      searchedTags: searchedTags ?? this.searchedTags,
      searchedText: searchedText ?? this.searchedText,
    );
  }
}

class AllTagsNotifier extends StateNotifier<AllTagsState> {
  AllTagsNotifier(this.ref) : super(AllTagsState());
  final Ref ref;

  void setSearchedText(String text) {
    state = state.copyWith(searchedText: text.trim());
  }

  void doSearching(Map<String, TagModel> allTags) {
    if (state.searchedText.isEmpty) return;

    final searched = <String, TagModel>{};
    final listOfLetters = state.searchedText.toLowerCase().split('');

    allTags.forEach((key, tagModel) {
      doCustomisedSearching(
        tagModel,
        listOfLetters,
        ({required bool matched}) {
          if (matched) {
            searched[key] = tagModel;
          }
        },
      );
    });

    state = state.copyWith(searchedTags: searched);
  }

  void clearSearch() {
    state = state.copyWith(
      searchedText: '',
      searchedTags: {},
    );
  }

  void toggleTagSelection(String tagId, TagModel tagModel) {
    final selected = Map<String, TagModel>.from(state.selectedTags);

    if (selected.containsKey(tagId)) {
      selected.remove(tagId);
    } else {
      selected[tagId] = tagModel;
    }

    state = state.copyWith(selectedTags: selected);
  }

  void initializeSelectedTags(Map<String, TagModel> tags) {
    state = state.copyWith(selectedTags: tags);
  }
}

final allTagsProvider = StateNotifierProvider<AllTagsNotifier, AllTagsState>((ref) {
  return AllTagsNotifier(ref);
});
