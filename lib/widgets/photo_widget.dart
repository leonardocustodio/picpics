// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picpics/asset_entity_image_provider.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/fade_image_builder.dart';
import 'package:picpics/providers/blur_hash_provider.dart';
import 'package:picpics/providers/pic_store_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/error_state_widget.dart';

class PhotoWidget extends ConsumerStatefulWidget {
  const PhotoWidget({required this.picStore, this.hash, super.key});
  final PicStoreNotifier? picStore;
  final String? hash;

  @override
  ConsumerState<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends ConsumerState<PhotoWidget> {
  String? _localHash;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _localHash = widget.hash;

    // Schedule blur hash generation if needed
    if (_localHash == null && widget.picStore != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_checkAndGenerateBlurHash());
      });
    }
  }

  @override
  void didUpdateWidget(PhotoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local hash if widget hash changed
    if (widget.hash != oldWidget.hash) {
      _localHash = widget.hash;
    }
  }

  Future<void> _checkAndGenerateBlurHash() async {
    if (!mounted || _isGenerating) return;
    if (widget.picStore == null) return;

    final blurHashState = ref.read(blurHashProvider);
    final photoId = widget.picStore!.state.photoId;

    // Check if already cached
    final cachedHash = blurHashState.blurHash[photoId];
    if (cachedHash != null) {
      if (mounted) {
        setState(() => _localHash = cachedHash);
      }
      return;
    }

    // Generate if not cached and enabled
    if (!blurHashState.isEnabled) return;

    _isGenerating = true;

    try {
      final entity = widget.picStore!.state.entity;
      if (entity == null) return;

      final thumbData = await entity.thumbnailDataWithSize(
        const ThumbnailSize(100, 100),
      );
      if (thumbData == null || !mounted) return;

      final generatedHash = await ref.read(blurHashProvider.notifier).createBlurHash(
            photoId,
            thumbData,
          );

      if (generatedHash != null && mounted) {
        setState(() => _localHash = generatedHash);
      }
    } on Exception catch (e) {
      AppLogger.w('Error generating blur hash in PhotoWidget: $e');
    } finally {
      _isGenerating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHash = _localHash ?? widget.hash;

    if (widget.picStore == null) {
      if (effectiveHash != null) {
        return BlurHash(hash: effectiveHash, color: Colors.transparent);
      } else {
        return const ColoredBox(color: kGreyPlaceholder);
      }
    }

    final imageProvider = AssetEntityImageProvider(widget.picStore!, isOriginal: false);

    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              if (effectiveHash != null) {
                return BlurHash(hash: effectiveHash, color: Colors.transparent);
              } else {
                return const ColoredBox(color: kGreyPlaceholder);
              }

            case LoadState.completed:
              return FadeImageBuilder(
                child: state.completedWidget,
              );
            case LoadState.failed:
              return PhotoErrorWidget(
                onRetry: () => state.reLoadImage(),
              );
          }
        },
      ),
    );
  }
}
