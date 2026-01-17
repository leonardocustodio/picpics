import 'package:flutter_riverpod/legacy.dart';

class SwiperTabState {

  SwiperTabState({
    this.currentIndex = 0,
    this.photoIds = const [],
    this.isZoomed = false,
    this.isLoaded = false,
  });
  final int currentIndex;
  final List<String> photoIds;
  final bool isZoomed;
  final bool isLoaded;

  SwiperTabState copyWith({
    int? currentIndex,
    List<String>? photoIds,
    bool? isZoomed,
    bool? isLoaded,
  }) {
    return SwiperTabState(
      currentIndex: currentIndex ?? this.currentIndex,
      photoIds: photoIds ?? this.photoIds,
      isZoomed: isZoomed ?? this.isZoomed,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class SwiperTabNotifier extends StateNotifier<SwiperTabState> {
  SwiperTabNotifier() : super(SwiperTabState());

  void setPhotoIds(List<String> ids) {
    state = state.copyWith(photoIds: ids);
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void nextPhoto() {
    if (state.currentIndex < state.photoIds.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previousPhoto() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void setZoomed({required bool zoomed}) {
    state = state.copyWith(isZoomed: zoomed);
  }

  void removePhotoId(String id) {
    final ids = List<String>.from(state.photoIds)..remove(id);
    state = state.copyWith(photoIds: ids);
  }

  void setLoaded({required bool loaded}) {
    state = state.copyWith(isLoaded: loaded);
  }
}

final swiperTabProvider = StateNotifierProvider<SwiperTabNotifier, SwiperTabState>((ref) {
  return SwiperTabNotifier();
});
