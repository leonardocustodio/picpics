import 'dart:typed_data';
import 'package:flutter_riverpod/legacy.dart';

class BlurHashState {
  BlurHashState({
    this.blurHashes = const {},
    this.isEnabled = true,
  });
  final Map<String, String> blurHashes;
  final bool isEnabled;

  // Alias for compatibility with GetX code
  Map<String, String> get blurHash => blurHashes;

  BlurHashState copyWith({
    Map<String, String>? blurHashes,
    bool? isEnabled,
  }) {
    return BlurHashState(
      blurHashes: blurHashes ?? this.blurHashes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class BlurHashNotifier extends StateNotifier<BlurHashState> {
  BlurHashNotifier() : super(BlurHashState());

  void addBlurHash(String imageId, String blurHash) {
    final hashes = Map<String, String>.from(state.blurHashes);
    hashes[imageId] = blurHash;
    state = state.copyWith(blurHashes: hashes);
  }

  String? getBlurHash(String imageId) {
    return state.blurHashes[imageId];
  }

  void clearBlurHashes() {
    state = state.copyWith(blurHashes: {});
  }

  void setEnabled({required bool enabled}) {
    state = state.copyWith(isEnabled: enabled);
  }

  Future<void> createBlurHash(String imageId, Uint8List imageData) async {
    // TODO(picpics): Implement actual blur hash generation
    // For now, just add a placeholder
    addBlurHash(imageId, 'placeholder_blur_hash');
  }
}

final blurHashProvider = StateNotifierProvider<BlurHashNotifier, BlurHashState>((ref) {
  return BlurHashNotifier();
});
