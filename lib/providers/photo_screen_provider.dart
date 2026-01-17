import 'package:flutter_riverpod/legacy.dart';

class PhotoScreenState {

  PhotoScreenState({
    this.currentPhotoId = '',
    this.photoIds = const [],
    this.currentIndex = 0,
    this.isEditing = false,
  });
  final String currentPhotoId;
  final List<String> photoIds;
  final int currentIndex;
  final bool isEditing;

  PhotoScreenState copyWith({
    String? currentPhotoId,
    List<String>? photoIds,
    int? currentIndex,
    bool? isEditing,
  }) {
    return PhotoScreenState(
      currentPhotoId: currentPhotoId ?? this.currentPhotoId,
      photoIds: photoIds ?? this.photoIds,
      currentIndex: currentIndex ?? this.currentIndex,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class PhotoScreenNotifier extends StateNotifier<PhotoScreenState> {
  PhotoScreenNotifier() : super(PhotoScreenState());

  void initialize(String photoId, List<String> photoIds) {
    final index = photoIds.indexOf(photoId);
    state = state.copyWith(
      currentPhotoId: photoId,
      photoIds: photoIds,
      currentIndex: index >= 0 ? index : 0,
    );
  }

  void setCurrentPhoto(String photoId) {
    final index = state.photoIds.indexOf(photoId);
    state = state.copyWith(
      currentPhotoId: photoId,
      currentIndex: index >= 0 ? index : state.currentIndex,
    );
  }

  void nextPhoto() {
    if (state.currentIndex < state.photoIds.length - 1) {
      final newIndex = state.currentIndex + 1;
      state = state.copyWith(
        currentIndex: newIndex,
        currentPhotoId: state.photoIds[newIndex],
      );
    }
  }

  void previousPhoto() {
    if (state.currentIndex > 0) {
      final newIndex = state.currentIndex - 1;
      state = state.copyWith(
        currentIndex: newIndex,
        currentPhotoId: state.photoIds[newIndex],
      );
    }
  }

  void setEditing({required bool editing}) {
    state = state.copyWith(isEditing: editing);
  }

  void setSelectedIndex(int index) {
    if (index >= 0 && index < state.photoIds.length) {
      state = state.copyWith(
        currentIndex: index,
        currentPhotoId: state.photoIds[index],
      );
    }
  }
}

final photoScreenProvider = StateNotifierProvider<PhotoScreenNotifier, PhotoScreenState>((ref) {
  return PhotoScreenNotifier();
});
