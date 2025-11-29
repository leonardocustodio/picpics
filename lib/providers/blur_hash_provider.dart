import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class BlurHashState {
  final Map<String, String> blurHashes;
  final bool isEnabled;

  // Alias for compatibility with GetX code
  Map<String, String> get blurHash => blurHashes;

  BlurHashState({
    this.blurHashes = const {},
    this.isEnabled = true,
  });

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

  void setEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
  }
}

final blurHashProvider = StateNotifierProvider<BlurHashNotifier, BlurHashState>((ref) {
  return BlurHashNotifier();
});