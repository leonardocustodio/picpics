import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart' as language;
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/screens/tabs/untagged_tabs/untagged_day.dart';
import 'package:picpics/screens/tabs/untagged_tabs/untagged_month.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/app_header.dart';
import 'package:picpics/widgets/device_no_pics.dart';
import 'package:picpics/widgets/toggle_bar.dart';

class UntaggedTab extends ConsumerStatefulWidget {
  const UntaggedTab({super.key});
  static const id = 'untagged_tab';

  @override
  ConsumerState<UntaggedTab> createState() => _UntaggedTabState();
}

class _UntaggedTabState extends ConsumerState<UntaggedTab> {
  final tagsEditingController = TextEditingController();

  @override
  void dispose() {
    tagsEditingController.dispose();
    super.dispose();
  }

  Widget _buildGridView(BuildContext context) {
    final tabsState = ref.watch(tabsProvider);
    final tabsNotifier = ref.read(tabsProvider.notifier);

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        /// Hiding Months on days from here by listening to the scrollNotification
        if (scrollNotification is ScrollStartNotification) {
          AppLogger.d('Start scrolling');
          tabsNotifier.setIsScrolling(true);
          return false;
        } else if (scrollNotification is ScrollEndNotification) {
          AppLogger.d('End scrolling');
          tabsNotifier.setIsScrolling(false);
          return true;
        }
        return true;
      },
      child: Builder(
        builder: (context) {
          final isMonth = tabsState.toggleIndexUntagged == 0;
          if (isMonth) {
            if (tabsState.allUnTaggedPicsMonth.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return const UntaggedTabMonth();
            /*   return Obx(
              () => StaggeredGridView.countBuilder(
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: true,
                  primary: true,
                  shrinkWrap: true,
                  key: Key('Month'),
                  padding: const EdgeInsets.only(top: 2),
                  crossAxisCount: 4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  itemCount: controller.allUnTaggedPicsMonth.length,
                  staggeredTileBuilder: (int index) {
                    if (controller.allUnTaggedPicsMonth[index] is DateTime) {
                      if (index + 1 < controller.allUnTaggedPicsMonth.length &&
                          controller.allUnTaggedPicsMonth[index + 1]
                              is DateTime) {
                        return const StaggeredTile.extent(4, 0);
                      }
                      return const StaggeredTile.extent(4, 40);
                    }
                    return const StaggeredTile.count(1, 1);
                  },
                  itemBuilder: (_, int index) {
                    return Obx(() {
                      if (index == 0 ||
                          controller.allUnTaggedPicsMonth[index] is DateTime) {
                        var isSelected = false;
                        if (controller.multiPicBar.value) {
                          var i = index + 1;

                          /// assuming that every picId is selected so the wh
                          var everySelected = false;
                          while (i < controller.allUnTaggedPicsMonth.length &&
                              controller.allUnTaggedPicsMonth[i] is String) {
                            if (controller.selectedMultiBarPics[
                                        controller.allUnTaggedPicsMonth[i]] ==
                                    null ||
                                controller.selectedMultiBarPics[
                                        controller.allUnTaggedPicsMonth[i]] ==
                                    false) {
                              everySelected = true;
                              break;
                            }
                            i++;
                          }
                          isSelected = !everySelected;
                        }
                        return GestureDetector(
                          onTap: () {
                            if (controller.multiPicBar.value) {
                              var i = index + 1;
                              if (isSelected) {
                                while (i <
                                        controller
                                            .allUnTaggedPicsMonth.length &&
                                    controller.allUnTaggedPicsMonth[i]
                                        is String) {
                                  controller.selectedMultiBarPics.remove(
                                      controller.allUnTaggedPicsMonth[i]);
                                  i++;
                                }
                              } else {
                                while (i <
                                        controller
                                            .allUnTaggedPicsMonth.length &&
                                    controller.allUnTaggedPicsMonth[i]
                                        is String) {
                                  controller.selectedMultiBarPics[controller
                                      .allUnTaggedPicsMonth[i]] = true;
                                  i++;
                                }
                              }
                            }
                          },
                          child: buildDateHeader(
                            controller.allUnTaggedPicsMonth[index],
                            isSelected,
                          ),
                        );
                      }

                      var blurHash = BlurHashController
                          .to.blurHash[controller.allUnTaggedPicsMonth[index]];

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: blurHash != null
                                    ? BlurHash(
                                        hash: blurHash,
                                        color: Colors.transparent,
                                      )
                                    : Container(
                                        padding: EdgeInsets.all(12),
                                        color: Colors.grey[300],
                                      ),
                              ),
                            ),
                          ),
                          if (controller
                                  .picStoreMap[
                                      controller.allUnTaggedPicsMonth[index]]
                                  ?.value !=
                              null)
                            Positioned.fill(
                                child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                    child: _buildImageWidget(
                                        picStore: controller
                                            .picStoreMap[controller
                                                .allUnTaggedPicsMonth[index]]!
                                            .value,
                                        picId: controller
                                            .allUnTaggedPicsMonth[index],
                                        hash: blurHash)),
                              ),
                            )),
                        ],
                      );
                    });
                  }),
            );
           */
          } else {
            return const UntaggedTabDay();
            /*  return Obx(
              () => StaggeredGridView.countBuilder(
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                primary: true,
                shrinkWrap: true,
                key: Key('Day'),
                padding: const EdgeInsets.only(top: 2),
                itemCount: controller.allUnTaggedPicsDay.length,
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                staggeredTileBuilder: (int index) {
                  if (controller.allUnTaggedPicsDay[index] is DateTime) {
                    if (index + 1 < controller.allUnTaggedPicsDay.length &&
                        controller.allUnTaggedPicsDay[index + 1] is DateTime) {
                      return const StaggeredTile.extent(3, 0);
                    }
                    return const StaggeredTile.extent(3, 40);
                  }
                  return const StaggeredTile.count(1, 1);
                },
                itemBuilder: (_, int index) {
                  return Obx(
                    () {
                      if (controller.allUnTaggedPicsDay[index] is DateTime) {
                        var isSelected = false;
                        if (controller.multiPicBar.value) {
                          var i = index + 1;

                          /// assuming that every picId is selected so the wh
                          var everySelected = false;
                          while (i < controller.allUnTaggedPicsDay.length &&
                              controller.allUnTaggedPicsDay[i] is String) {
                            if (controller.selectedMultiBarPics[
                                        controller.allUnTaggedPicsDay[i]] ==
                                    null ||
                                controller.selectedMultiBarPics[
                                        controller.allUnTaggedPicsDay[i]] ==
                                    false) {
                              everySelected = true;
                              break;
                            }
                            i++;
                          }
                          isSelected = !everySelected;
                        }
                        return GestureDetector(
                            onTap: () {
                              if (controller.multiPicBar.value) {
                                var i = index + 1;
                                if (isSelected) {
                                  while (i <
                                          controller
                                              .allUnTaggedPicsDay.length &&
                                      controller.allUnTaggedPicsDay[i]
                                          is String) {
                                    controller.selectedMultiBarPics.remove(
                                        controller.allUnTaggedPicsDay[i]);
                                    i++;
                                  }
                                } else {
                                  while (i <
                                          controller
                                              .allUnTaggedPicsDay.length &&
                                      controller.allUnTaggedPicsDay[i]
                                          is String) {
                                    controller.selectedMultiBarPics[controller
                                        .allUnTaggedPicsDay[i]] = true;
                                    i++;
                                  }
                                }
                              }
                            },
                            child: buildDateHeader(
                              controller.allUnTaggedPicsDay[index],
                              isSelected,
                            ));
                      }
                      var blurHash = BlurHashController
                          .to.blurHash[controller.allUnTaggedPicsDay[index]];

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: blurHash != null
                                    ? BlurHash(
                                        hash: blurHash,
                                        color: Colors.transparent,
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(12),
                                        color: Colors.grey[300],
                                      ),
                              ),
                            ),
                          ),
                          if (controller
                                  .picStoreMap[
                                      controller.allUnTaggedPicsDay[index]]
                                  ?.value !=
                              null)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    child: _buildImageWidget(
                                        picStore: controller
                                            .picStoreMap[controller
                                                .allUnTaggedPicsDay[index]]!
                                            .value,
                                        picId: controller
                                            .allUnTaggedPicsDay[index],
                                        hash: blurHash),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
           */
          }
        },
      ),
    );
  }

  // Unused field commented out to fix warning
  // final _failedItem = const Center(
  //   child: Text(
  //     'Failed loading',
  //     textAlign: TextAlign.center,
  //     style: TextStyle(fontSize: 18),
  //   ),
  // );

  String dateFormat(DateTime dateTime) {
    DateFormat formatter;
    AppLogger.d('Date Time Formatting: $dateTime');

    /// More Optimized code
    if (ref.read(tabsProvider).toggleIndexUntagged == 0) {
      formatter = DateFormat.yMMMM();
    } else {
      formatter = dateTime.year == DateTime.now().year ? DateFormat.MMMEd() : DateFormat.yMMMEd();
    }
    return formatter.format(dateTime);
  }

  Widget buildDateHeader(DateTime date, bool isSelected) {
    final tabsState = ref.watch(tabsProvider);

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      height: 40,
      child: Row(
        children: [
          if (tabsState.multiPicBar)
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: kSecondaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
              child: isSelected ? Image.asset('lib/images/checkwhiteico.png') : null,
            ),
          Text(
            dateFormat(date),
            textScaler: TextScaler.noScaling,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(tabsProvider);
    final tabsNotifier = ref.read(tabsProvider.notifier);
    final taggedState = ref.watch(taggedProvider);
    final s = ref.watch(sProvider);

    return ColoredBox(
      color: kWhiteColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const AppHeader(),
            Expanded(
              child: _buildContent(
                context,
                tabsState,
                tabsNotifier,
                taggedState,
                s,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TabsState tabsState,
    TabsNotifier tabsNotifier,
    TaggedState taggedState,
    language.S s,
  ) {
    final hasPics = tabsState.allUnTaggedPicsMonth.isNotEmpty || tabsState.allUnTaggedPicsDay.isNotEmpty;

    if (!tabsState.isUntaggedPicsLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!hasPics) {
      return DeviceHasNoPics(
        message: s.device_has_no_pics,
      );
    }

    return Stack(
      children: <Widget>[
        _buildGridView(context),
        AnimatedOpacity(
          opacity: tabsState.isScrolling ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          onEnd: () {
            tabsNotifier.setIsToggleBarVisible(
              !tabsState.isScrolling,
            );
          },
          child: Visibility(
            visible: !tabsState.isScrolling || tabsState.isToggleBarVisible,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ToggleBar(
                  titleLeft: s.toggle_months,
                  titleRight: s.toggle_days,
                  activeToggle: tabsState.toggleIndexUntagged,
                  onToggle: (int index) {
                    tabsNotifier.setToggleIndexUntagged(index);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
