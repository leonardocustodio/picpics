import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class TabsState {
  final int currentIndex;
  final bool isTagging;
  final bool isMultiSelecting;
  final List<String> selectedPhotos;
  final bool multiTagSheet;
  final bool multiPicBar;

  TabsState({
    this.currentIndex = 0,
    this.isTagging = false,
    this.isMultiSelecting = false,
    this.selectedPhotos = const [],
    this.multiTagSheet = false,
    this.multiPicBar = false,
  });

  TabsState copyWith({
    int? currentIndex,
    bool? isTagging,
    bool? isMultiSelecting,
    List<String>? selectedPhotos,
    bool? multiTagSheet,
    bool? multiPicBar,
  }) {
    return TabsState(
      currentIndex: currentIndex ?? this.currentIndex,
      isTagging: isTagging ?? this.isTagging,
      isMultiSelecting: isMultiSelecting ?? this.isMultiSelecting,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      multiTagSheet: multiTagSheet ?? this.multiTagSheet,
      multiPicBar: multiPicBar ?? this.multiPicBar,
    );
  }
}

class TabsNotifier extends StateNotifier<TabsState> {
  TabsNotifier() : super(TabsState());

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void setCurrentTab(int index) {
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

  void setMultiTagSheet(bool value) {
    state = state.copyWith(multiTagSheet: value);
  }

  void setMultiPicBar(bool value) {
    state = state.copyWith(multiPicBar: value);
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

  Future<void> loadAssetPath() async {
    // TODO: Implement asset loading from photo manager
    // This should load photos from the device gallery
    // For now, this is a placeholder to prevent compilation errors
  }
}

final tabsProvider = StateNotifierProvider<TabsNotifier, TabsState>((ref) {
  return TabsNotifier();
});