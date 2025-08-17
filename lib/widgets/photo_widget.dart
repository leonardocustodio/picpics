import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/stores/pic_store.dart';

class PhotoWidget extends StatelessWidget {
  final PicStore? picStore;
  final String? hash;
  const PhotoWidget({required this.picStore, this.hash, super.key});

  @override
  Widget build(BuildContext context) {
    if (picStore == null) {
      if (hash != null) {
        return BlurHash(hash: hash!, color: Colors.transparent);
      } else {
        return const ColoredBox(color: kGreyPlaceholder);
      }
    }
    final imageProvider =
        AssetEntityImageProvider(picStore!, isOriginal: false);
    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              if (hash != null) {
                return BlurHash(hash: hash!, color: Colors.transparent);
              } else {
                return const ColoredBox(color: kGreyPlaceholder);
              }

            case LoadState.completed:
              return FadeImageBuilder(
                child: state.completedWidget,
              );
            case LoadState.failed:
              return failedItem;
          }
        },
      ),
    );
  }
}
