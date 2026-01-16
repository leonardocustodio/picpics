import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/swiper_tab_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/screens/settings_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/photo_card.dart';

// ignore: must_be_immutable
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
    final picStore = ref.read(tabsProvider).picStoreMap[picId] ??
        ref.read(tabsProvider.notifier).explorPicStore(picId);

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

    return Container(
      padding: const EdgeInsets.only(),
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.1), BlendMode.dstATop,),
          image: const AssetImage('lib/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset('lib/images/picpicssmallred.png'),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Image.asset('lib/images/settings.png'),
                  ),
                ],
              ),
            ),
            if (!swiperState.isLoaded)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kSecondaryColor),
                  ),
                ),
              )
            else if (tabsState.assetMap.isEmpty)
              Expanded(
                child: DeviceHasNoPics(
                  message: s.device_has_no_pics,
                ),
              )
            else if (swiperState.photoIds.isEmpty)
              Expanded(
                child: DeviceHasNoPics(
                  message: s.no_photos_were_tagged,
                ),
              )
            else
              Expanded(
                child: Stack(
                  children: <Widget>[
                    CarouselSlider.builder(
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
//                              if (controller.swipeIndex <= controller.swipeCutOff && controller.swipeIndex != 0) {
                          AppLogger.d('changing scroll physics');
//                                setState(() {
//                                  scrollPhysics = NeverScrollableScrollPhysics();
//                                });
//                              }
                          AppLogger.d('scrolled $double');
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
