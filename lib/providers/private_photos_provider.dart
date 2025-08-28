import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivatePhotosState {
  final bool showPrivate;
  final List<String> privatePhotoIds;

  PrivatePhotosState({
    this.showPrivate = false,
    this.privatePhotoIds = const [],
  });

  PrivatePhotosState copyWith({
    bool? showPrivate,
    List<String>? privatePhotoIds,
  }) {
    return PrivatePhotosState(
      showPrivate: showPrivate ?? this.showPrivate,
      privatePhotoIds: privatePhotoIds ?? this.privatePhotoIds,
    );
  }
}

class PrivatePhotosNotifier extends StateNotifier<PrivatePhotosState> {
  PrivatePhotosNotifier() : super(PrivatePhotosState());

  void toggleShowPrivate() {
    state = state.copyWith(showPrivate: !state.showPrivate);
  }

  void setShowPrivate(bool value) {
    state = state.copyWith(showPrivate: value);
  }

  void addPrivatePhoto(String photoId) {
    final photos = List<String>.from(state.privatePhotoIds);
    if (!photos.contains(photoId)) {
      photos.add(photoId);
      state = state.copyWith(privatePhotoIds: photos);
    }
  }

  void removePrivatePhoto(String photoId) {
    final photos = List<String>.from(state.privatePhotoIds);
    photos.remove(photoId);
    state = state.copyWith(privatePhotoIds: photos);
  }
}

final privatePhotosProvider = StateNotifierProvider<PrivatePhotosNotifier, PrivatePhotosState>((ref) {
  return PrivatePhotosNotifier();
});