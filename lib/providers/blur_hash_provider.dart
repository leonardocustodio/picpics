import 'dart:typed_data';

import 'package:flutter_riverpod/legacy.dart';
import 'package:image/image.dart' as img;
import 'package:picpics/database/app_database.dart';
import 'package:picpics/third_party_lib/src/blurhash.dart';
import 'package:picpics/utils/app_logger.dart';

class BlurHashState {
  BlurHashState({
    this.blurHashes = const {},
    this.isEnabled = true,
    this.isGenerating = false,
  });
  final Map<String, String> blurHashes;
  final bool isEnabled;
  final bool isGenerating;

  // Alias for compatibility with GetX code
  Map<String, String> get blurHash => blurHashes;

  BlurHashState copyWith({
    Map<String, String>? blurHashes,
    bool? isEnabled,
    bool? isGenerating,
  }) {
    return BlurHashState(
      blurHashes: blurHashes ?? this.blurHashes,
      isEnabled: isEnabled ?? this.isEnabled,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}

class BlurHashNotifier extends StateNotifier<BlurHashState> {
  BlurHashNotifier() : super(BlurHashState()) {
    _database = AppDatabase();
  }

  late final AppDatabase _database;

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

  /// Load cached blur hashes from database
  Future<void> loadCachedBlurHashes() async {
    try {
      final cachedHashes = await _database.getAllPicBlurHash();
      final hashMap = <String, String>{};

      for (final hash in cachedHashes) {
        hashMap[hash.photoId] = hash.blurHash;
      }

      state = state.copyWith(blurHashes: hashMap);
      AppLogger.d('Loaded ${hashMap.length} cached blur hashes');
    } on Exception catch (e) {
      AppLogger.e('Error loading cached blur hashes: $e');
    }
  }

  /// Generate and store a blur hash for an image
  Future<String?> createBlurHash(String imageId, Uint8List imageData) async {
    // Check if already cached in memory
    if (state.blurHashes.containsKey(imageId)) {
      return state.blurHashes[imageId];
    }

    // Check if already cached in database
    try {
      final cachedHash = await _database.getSinglePicBlurHash(imageId);
      if (cachedHash != null) {
        addBlurHash(imageId, cachedHash.blurHash);
        return cachedHash.blurHash;
      }
    } on Exception catch (e) {
      AppLogger.w('Error checking cached blur hash: $e');
    }

    // Generate new blur hash
    state = state.copyWith(isGenerating: true);

    try {
      // Decode image data
      final image = img.decodeImage(imageData);
      if (image == null) {
        AppLogger.w('Failed to decode image for blur hash generation');
        state = state.copyWith(isGenerating: false);
        return null;
      }

      // Resize image to smaller dimensions for faster encoding
      // BlurHash works best with small images
      final resizedImage = img.copyResize(
        image,
        width: 32,
        height: (32 * image.height / image.width).round(),
      );

      // Generate blur hash using the third_party_lib BlurHash encoder
      final blurHash = BlurHash.encode(resizedImage);

      final hashString = blurHash.hash;

      // Store in memory
      addBlurHash(imageId, hashString);

      // Store in database for persistence
      await _cacheBlurHash(imageId, hashString);

      AppLogger.d('Generated blur hash for $imageId: $hashString');
      state = state.copyWith(isGenerating: false);
      return hashString;
    } on Exception catch (e) {
      AppLogger.e('Error generating blur hash: $e');
      state = state.copyWith(isGenerating: false);
      return null;
    }
  }

  /// Cache blur hash in database
  Future<void> _cacheBlurHash(String imageId, String blurHash) async {
    try {
      final picBlurHash = PicBlurHash(
        photoId: imageId,
        blurHash: blurHash,
      );
      await _database.createPicBlurHash(picBlurHash);
    } on Exception catch (e) {
      AppLogger.w('Error caching blur hash: $e');
    }
  }

  /// Batch generate blur hashes for multiple images
  Future<void> batchCreateBlurHashes(
    Map<String, Uint8List> images,
  ) async {
    final newHashes = <PicBlurHash>[];

    for (final entry in images.entries) {
      final imageId = entry.key;
      final imageData = entry.value;

      // Skip if already cached
      if (state.blurHashes.containsKey(imageId)) {
        continue;
      }

      try {
        final image = img.decodeImage(imageData);
        if (image == null) continue;

        final resizedImage = img.copyResize(
          image,
          width: 32,
          height: (32 * image.height / image.width).round(),
        );

        final blurHash = BlurHash.encode(resizedImage);

        addBlurHash(imageId, blurHash.hash);
        newHashes.add(
          PicBlurHash(
            photoId: imageId,
            blurHash: blurHash.hash,
          ),
        );
      } on Exception catch (e) {
        AppLogger.w('Error generating blur hash for $imageId: $e');
      }
    }

    // Batch insert into database
    if (newHashes.isNotEmpty) {
      await _database.insertAllPicBlurHash(newHashes);
      AppLogger.d('Batch cached ${newHashes.length} blur hashes');
    }
  }
}

final blurHashProvider = StateNotifierProvider<BlurHashNotifier, BlurHashState>((ref) {
  return BlurHashNotifier();
});
