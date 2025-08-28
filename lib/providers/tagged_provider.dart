import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class TaggedState {
  final List<String> taggedPhotoIds;
  final bool isLoading;
  final String searchQuery;
  final FocusNode searchFocusNode;

  TaggedState({
    this.taggedPhotoIds = const [],
    this.isLoading = false,
    this.searchQuery = '',
    FocusNode? searchFocusNode,
  }) : searchFocusNode = searchFocusNode ?? FocusNode();

  TaggedState copyWith({
    List<String>? taggedPhotoIds,
    bool? isLoading,
    String? searchQuery,
    FocusNode? searchFocusNode,
  }) {
    return TaggedState(
      taggedPhotoIds: taggedPhotoIds ?? this.taggedPhotoIds,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      searchFocusNode: searchFocusNode ?? this.searchFocusNode,
    );
  }
}

class TaggedNotifier extends StateNotifier<TaggedState> {
  TaggedNotifier() : super(TaggedState());

  void setTaggedPhotos(List<String> photoIds) {
    state = state.copyWith(taggedPhotoIds: photoIds);
  }

  void addTaggedPhoto(String photoId) {
    final photos = List<String>.from(state.taggedPhotoIds);
    if (!photos.contains(photoId)) {
      photos.add(photoId);
      state = state.copyWith(taggedPhotoIds: photos);
    }
  }

  void removeTaggedPhoto(String photoId) {
    final photos = List<String>.from(state.taggedPhotoIds);
    photos.remove(photoId);
    state = state.copyWith(taggedPhotoIds: photos);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    state.searchFocusNode.dispose();
    super.dispose();
  }
}

final taggedProvider = StateNotifierProvider<TaggedNotifier, TaggedState>((ref) {
  return TaggedNotifier();
});