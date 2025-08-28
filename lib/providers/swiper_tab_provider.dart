import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
class SwiperTabState {
  final int currentIndex;
  final List<String> photoIds;
  final bool isZoomed;

  SwiperTabState({
    this.currentIndex = 0,
    this.photoIds = const [],
    this.isZoomed = false,
  });

  SwiperTabState copyWith({
    int? currentIndex,
    List<String>? photoIds,
    bool? isZoomed,
  }) {
    return SwiperTabState(
      currentIndex: currentIndex ?? this.currentIndex,
      photoIds: photoIds ?? this.photoIds,
      isZoomed: isZoomed ?? this.isZoomed,
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

  void setZoomed(bool zoomed) {
    state = state.copyWith(isZoomed: zoomed);
  }
}

final swiperTabProvider = StateNotifierProvider<SwiperTabNotifier, SwiperTabState>((ref) {
  return SwiperTabNotifier();
});