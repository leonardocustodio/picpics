import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/database/app_database.dart';

class PrivatePhotosState {
  PrivatePhotosState({
    this.showPrivate = false,
    this.privatePhotoIds = const [],
    this.privateMap = const {},
  });
  final bool showPrivate;
  final List<String> privatePhotoIds;
  final Map<String, String> privateMap;

  PrivatePhotosState copyWith({
    bool? showPrivate,
    List<String>? privatePhotoIds,
    Map<String, String>? privateMap,
  }) {
    return PrivatePhotosState(
      showPrivate: showPrivate ?? this.showPrivate,
      privatePhotoIds: privatePhotoIds ?? this.privatePhotoIds,
      privateMap: privateMap ?? this.privateMap,
    );
  }
}

class PrivatePhotosNotifier extends StateNotifier<PrivatePhotosState> {
  PrivatePhotosNotifier() : super(PrivatePhotosState());

  void toggleShowPrivate() {
    state = state.copyWith(showPrivate: !state.showPrivate);
  }

  void setShowPrivate({required bool value}) {
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
    final photos = List<String>.from(state.privatePhotoIds)..remove(photoId);
    final map = Map<String, String>.from(state.privateMap)..remove(photoId);
    state = state.copyWith(privatePhotoIds: photos, privateMap: map);
  }

  Future<void> refreshPrivatePics() async {
    final appDatabase = AppDatabase();
    final val = await appDatabase.getPrivatePhotoList();
    final newMap = <String, String>{};
    for (final photo in val) {
      newMap[photo.id] = '';
    }
    state = state.copyWith(privateMap: newMap);
  }
}

final privatePhotosProvider = StateNotifierProvider<PrivatePhotosNotifier, PrivatePhotosState>((ref) {
  return PrivatePhotosNotifier();
});
