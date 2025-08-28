import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class TabsState {
  final int currentIndex;
  final bool isTagging;
  final bool isMultiSelecting;
  final List<String> selectedPhotos;

  TabsState({
    this.currentIndex = 0,
    this.isTagging = false,
    this.isMultiSelecting = false,
    this.selectedPhotos = const [],
  });

  TabsState copyWith({
    int? currentIndex,
    bool? isTagging,
    bool? isMultiSelecting,
    List<String>? selectedPhotos,
  }) {
    return TabsState(
      currentIndex: currentIndex ?? this.currentIndex,
      isTagging: isTagging ?? this.isTagging,
      isMultiSelecting: isMultiSelecting ?? this.isMultiSelecting,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
    );
  }
}

class TabsNotifier extends StateNotifier<TabsState> {
  TabsNotifier() : super(TabsState());

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void setIsTagging(bool value) {
    state = state.copyWith(isTagging: value);
  }

  void setIsMultiSelecting(bool value) {
    state = state.copyWith(isMultiSelecting: value);
    if (!value) {
      clearSelectedPhotos();
    }
  }

  void togglePhotoSelection(String photoId) {
    final photos = List<String>.from(state.selectedPhotos);
    if (photos.contains(photoId)) {
      photos.remove(photoId);
    } else {
      photos.add(photoId);
    }
    state = state.copyWith(selectedPhotos: photos);
  }

  void clearSelectedPhotos() {
    state = state.copyWith(selectedPhotos: []);
  }

  void selectAllPhotos(List<String> photoIds) {
    state = state.copyWith(selectedPhotos: photoIds);
  }
}

final tabsProvider = StateNotifierProvider<TabsNotifier, TabsState>((ref) {
  return TabsNotifier();
});