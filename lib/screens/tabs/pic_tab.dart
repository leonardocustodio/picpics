import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart' as language;
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/swiper_tab_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/widgets/app_header.dart';
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/photo_card.dart';

class PicTab extends ConsumerStatefulWidget {
  const PicTab({super.key});
  static const id = 'pic_tab';

  @override
  ConsumerState<PicTab> createState() => _PicTabState();
}

class _PicTabState extends ConsumerState<PicTab> {
  CarouselSliderController carouselController = CarouselSliderController();
  ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics();

  Widget _buildPhotoSlider(int index) {
    final swiperState = ref.read(swiperTabProvider);
    final picId = swiperState.photoIds[index];
    final picStore = ref.read(tabsProvider).picStoreMap[picId] ?? ref.read(tabsProvider.notifier).explorPicStore(picId);

    if (picStore == null) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          color: Colors.grey[300],
          child: const Center(child: Text('Photo not available')),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: PhotoCard(
        picStore: picStore,
        picsInThumbnails: PicSource.swipe,
        picsInThumbnailIndex: index,
        // showEditTagModal: (tagkey) => showEditTagModal(tagkey),
        // showDeleteSecretModal: showDeleteSecretModal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final swiperState = ref.watch(swiperTabProvider);
    final tabsState = ref.watch(tabsProvider);
    final s = ref.watch(sProvider);

    return ColoredBox(
      color: kWhiteColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const AppHeader(),
            Expanded(
              child: _buildContent(swiperState, tabsState, s),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    SwiperTabState swiperState,
    TabsState tabsState,
    language.S s,
  ) {
    if (!swiperState.isLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
        ),
      );
    }

    if (tabsState.assetMap.isEmpty) {
      return DeviceHasNoPics(
        message: s.device_has_no_pics,
      );
    }

    if (swiperState.photoIds.isEmpty) {
      return DeviceHasNoPics(
        message: s.no_photos_were_tagged,
      );
    }

    return CarouselSlider.builder(
      itemCount: swiperState.photoIds.length,
      carouselController: carouselController,
      itemBuilder: (BuildContext context, int index, int _) {
        return _buildPhotoSlider(index);
      },
      options: CarouselOptions(
        initialPage: swiperState.currentIndex,
        enableInfiniteScroll: false,
        height: double.maxFinite,
        viewportFraction: 1,
        enlargeCenterPage: true,
        scrollPhysics: scrollPhysics,
        onPageChanged: (index, reason) {
          ref.read(swiperTabProvider.notifier).setCurrentIndex(index);
        },
        onScrolled: (double? val) {
          AppLogger.d('changing scroll physics');
          AppLogger.d('scrolled $double');
        },
      ),
    );
  }
}
