/* import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/custom_scroll_physics.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/widgets/device_no_pics.dart';
import 'package:picPics/widgets/toggle_bar.dart';

class TutsUntaggedTab extends StatefulWidget {
  static const id = 'tuts_untagged_tab';

  @override
  _TutsUntaggedTabState createState() => _TutsUntaggedTabState();
}

class _TutsUntaggedTabState extends State<TutsUntaggedTab> {
  TabsStore tabsStore;
  GalleryStore galleryStore;

  //ScrollController scrollControllerFirstTab;
  TextEditingController tagsEditingController = TextEditingController();

  // List<Widget> _buildSlivers(BuildContext context) {
  //   List<Widget> slivers = [];
  //
  //   for (var untaggedPic in galleryStore.untaggedPics) {
  //     slivers.add();
  //   }
  //
  //   return slivers;
  // }

/*   void refreshGridPositionFirstTab() {
    var offset = scrollControllerFirstTab.hasClients
        ? scrollControllerFirstTab.offset
        : scrollControllerFirstTab.initialScrollOffset;

    if (offset >= 86) {
      tabsStore.setTopOffsetFirstTab(10.0);
    } else if (offset >= 32) {
      tabsStore.setTopOffsetFirstTab(64.0 - (offset - 32.0));
    } else if (offset <= 0) {
      tabsStore.setTopOffsetFirstTab(64.0);
    }

    if (scrollControllerFirstTab.hasClients) {
      tabsStore.offsetFirstTab = scrollControllerFirstTab.offset;
    }
  } */

  Widget _buildSliverGridItem(BuildContext context, PicStore picStore) {
    if (picStore == null) {
      return Container();
    }

    final AssetEntityImageProvider imageProvider =
        AssetEntityImageProvider(picStore, isOriginal: false);
    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          Widget loader;
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              loader = const ColoredBox(color: kGreyPlaceholder);
              break;
            case LoadState.completed:
              loader = FadeImageBuilder(
                child: () {
                  return GestureDetector(
                    onLongPress: () {
                      print('LongPress');
                      if (tabsStore.multiPicBar == false) {
                        galleryStore.setSelectedPics(
                          picStore: picStore,
                          picIsTagged: false,
                        );
                        tabsStore.setMultiPicBar(true);
                      }
                    },
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        if (tabsStore.multiPicBar) {
                          galleryStore.setSelectedPics(
                            picStore: picStore,
                            picIsTagged: false,
                          );
                          print('Pics Selected Length: ${galleryStore.selectedPics.length}');
                          return;
                        }

                        tagsEditingController.text = '';
                        galleryStore.setCurrentPic(picStore);
                        tabsStore.setModalCard(true);
                      },
                      child: Observer(builder: (_) {
                        Widget image = Positioned.fill(
                          child: RepaintBoundary(
                            child: state.completedWidget,
                          ),
                        );
                        if (tabsStore.multiPicBar) {
                          if (galleryStore.selectedPics.contains(picStore)) {
                            return Stack(
                              children: [
                                image,
                                Container(
                                  constraints: BoxConstraints.expand(),
                                  decoration: BoxDecoration(
                                    color: kSecondaryColor.withOpacity(0.3),
                                    border: Border.all(
                                      color: kSecondaryColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 8.0,
                                  top: 6.0,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      gradient: kSecondaryGradient,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Image.asset(
                                        'lib/images/checkwhiteico.png'),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Stack(
                            children: [
                              image,
                              Positioned(
                                left: 8.0,
                                top: 6.0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: kGrayColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Stack(
                          children: [
                            image,
                          ],
                        );
                      }),
                    ),
                  );
                }(),
              );
              break;
            case LoadState.failed:
              loader = _failedItem;
              break;
          }
          return loader;
        },
      ),
    );
  }

//   Widget _buildNewItem(BuildContext context, int index, double size) {
/* print('Curret Index: $index'); */
//
//     List<Widget> childs = [];
//     int endIndex = (index + 1) * 3;
//
//     for (int currentIndex = index * 3; currentIndex < endIndex; currentIndex++) {
//       PicStore picStore = galleryStore.untaggedPics[currentIndex].picStore;
//       if (picStore == null) {
//         childs.add(
//           Container(
//             color: kGrayColor,
//             padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//             width: double.infinity,
//             child: Text(
//               '${dateFormat(galleryStore.untaggedPics[currentIndex].date)}',
//               textScaler: TextScaler.linear(1.0),
//               style: TextStyle(
//                 fontFamily: 'Lato',
//                 color: Color(0xff606566),
//                 fontSize: 24,
//                 fontWeight: FontWeight.w400,
//                 fontStyle: FontStyle.normal,
//                 letterSpacing: -0.4099999964237213,
//               ),
//             ),
//           ),
//         );
//         continue;
//
//         // if (tabsStore.toggleIndexSelected == null || tabsStore.toggleIndexSelected == 0) {
//         //   if (!galleryStore.untaggedPics[index].didChangeMonth) {
//         //     return Container();
//         //   }
//         // }
//         // return Container(
//         //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//         //   child: Text(
//         //     '${dateFormat(galleryStore.untaggedPics[index].date)}',
//         //     textScaler: TextScaler.linear(1.0),
//         //     style: TextStyle(
//         //       fontFamily: 'Lato',
//         //       color: Color(0xff606566),
//         //       fontSize: 24,
//         //       fontWeight: FontWeight.w400,
//         //       fontStyle: FontStyle.normal,
//         //       letterSpacing: -0.4099999964237213,
//         //     ),
//         //   ),
//         // );
//       }
//
// //    var thumbWidth = MediaQuery.of(context).size.width / 3.0;
//
//       final AssetEntityImageProvider imageProvider = AssetEntityImageProvider(picStore, isOriginal: false);
//
//       childs.add(Container(
//         height: size,
//         width: size - 1,
//         child: RepaintBoundary(
//           child: ExtendedImage(
//             image: imageProvider,
//             fit: BoxFit.cover,
//             loadStateChanged: (ExtendedImageState state) {
//               Widget loader;
//               switch (state.extendedImageLoadState) {
//                 case LoadState.loading:
//                   loader = const ColoredBox(color: kGreyPlaceholder);
//                   break;
//                 case LoadState.completed:
//                   loader = FadeImageBuilder(
//                     child: () {
//                       return GestureDetector(
//                         onLongPress: () {
/* print('LongPress'); */
//                           if (tabsStore.multiPicBar == false) {
//                             galleryStore.setSelectedPics(
//                               picStore: picStore,
//                               picIsTagged: false,
//                             );
//                             tabsStore.setMultiPicBar(true);
//                           }
//                         },
//                         child: CupertinoButton(
//                           padding: const EdgeInsets.all(0),
//                           onPressed: () {
//                             if (tabsStore.multiPicBar) {
//                               galleryStore.setSelectedPics(
//                                 picStore: picStore,
//                                 picIsTagged: false,
//                               );
/* print('Pics Selected Length: ${galleryStore.selectedPics.length}'); */
//                               return;
//                             }
//
//                             tagsEditingController.text = '';
//                             galleryStore.setCurrentPic(picStore);
//                             tabsStore.setModalCard(true);
//                           },
//                           child: Observer(builder: (_) {
//                             Widget image = Positioned.fill(
//                               child: RepaintBoundary(
//                                 child: state.completedWidget,
//                               ),
//                             );
//                             if (tabsStore.multiPicBar) {
//                               if (galleryStore.selectedPics.contains(picStore)) {
//                                 return Stack(
//                                   children: [
//                                     image,
//                                     Container(
//                                       constraints: BoxConstraints.expand(),
//                                       decoration: BoxDecoration(
//                                         color: kSecondaryColor.withOpacity(0.3),
//                                         border: Border.all(
//                                           color: kSecondaryColor,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       left: 8.0,
//                                       top: 6.0,
//                                       child: Container(
//                                         height: 20,
//                                         width: 20,
//                                         decoration: BoxDecoration(
//                                           gradient: kSecondaryGradient,
//                                           borderRadius: BorderRadius.circular(10.0),
//                                         ),
//                                         child: Image.asset('lib/images/checkwhiteico.png'),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }
//                               return Stack(
//                                 children: [
//                                   image,
//                                   Positioned(
//                                     left: 8.0,
//                                     top: 6.0,
//                                     child: Container(
//                                       height: 20,
//                                       width: 20,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10.0),
//                                         border: Border.all(
//                                           color: kGrayColor,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }
//                             return Stack(
//                               children: [
//                                 image,
//                               ],
//                             );
//                           }),
//                         ),
//                       );
//                     }(),
//                   );
//                   break;
//                 case LoadState.failed:
//                   loader = _failedItem;
//                   break;
//               }
//               return loader;
//             },
//           ),
//         ),
//       ));
//     }
//
//     return Wrap(
//       alignment: WrapAlignment.spaceBetween,
//       children: childs,
//     );
//   }

  Widget _buildGridView(BuildContext context) {
    print('&&&&& Building grid view');
    // List<Widget> sliverGrids = [];
    //
    // for (UntaggedPicsStore untaggedPicsStore in galleryStore.untaggedPics) {
    //   sliverGrids.add(SliverPersistentHeader(
    //     delegate: MyDynamicHeader(
    //       headerTitle: dateFormat(untaggedPicsStore.date),
    //     ),
    //   ));
    //   sliverGrids.add(SliverGrid(
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 3,
    //       mainAxisSpacing: 2.0,
    //       crossAxisSpacing: 2.0,
    //       childAspectRatio: 1.0,
    //     ),
    //     delegate: SliverChildBuilderDelegate(
    //       (BuildContext context, int index) {
    //         return _buildSliverGridItem(context, untaggedPicsStore.picStores[index]);
    //       },
    //       childCount: untaggedPicsStore.picStoresIds.length,
    //     ),
    //   ));
    // }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          print('Start scrolling');
          tabsStore.setIsScrolling(true);
        } else if (scrollNotification is ScrollEndNotification) {
          print('End scrolling');
          tabsStore.setIsScrolling(false);
        }
        return;
      },
      child:

          // CustomScrollView(
          //   slivers: <Widget>[
          //     SliverAppBar(
          //       pinned: true,
          //       expandedHeight: 140.0,
          //       backgroundColor: kWhiteColor,
          //       flexibleSpace: FlexibleSpaceBar(
          //         centerTitle: false,
          //         titlePadding: const EdgeInsets.only(bottom: 16.0, left: 19.0),
          //         title: Text(
          //           tabsStore.multiPicBar ? LangControl.to.S.value.photo_gallery_count(galleryStore.selectedPics.length) : LangControl.to.S.value.photo_gallery_description,
          //           textScaler: TextScaler.linear(1.0),
          //           style: TextStyle(
          //             fontFamily: 'Lato',
          //             color: Color(0xff979a9b),
          //             fontSize: 20.0,
          //             fontWeight: FontWeight.w700,
          //             fontStyle: FontStyle.normal,
          //           ),
          //         ),
          //       ),
          //     ),
          //     SliverToBoxAdapter(
          //       child: SizedBox(
          //         height: 30.0,
          //       ),
          //     ),
          //     ...sliverGrids,
          //
          //     // SliverAnimatedList(
          //     //   initialItemCount: (galleryStore.untaggedPics.length / 3).floor() + 1,
          //     //   itemBuilder: (context, index, animation) {
          //     //     double size = MediaQuery.of(context).size.width / 3;
          //     //     return _buildNewItem(context, index, size);
          //     //   },
          //     // )
          //     // SliverPinnedHeader(
          //     //   child: Container(
          //     //     child: Text('Teste'),
          //     //   ),
          //     // ),
          //     // SliverGrid(
          //     //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //     //     maxCrossAxisExtent: 200.0,
          //     //     mainAxisSpacing: 10.0,
          //     //     crossAxisSpacing: 10.0,
          //     //     childAspectRatio: 4.0,
          //     //   ),
          //     //   delegate: SliverChildBuilderDelegate(
          //     //     (BuildContext context, int index) {
          //     //       return Container(
          //     //         alignment: Alignment.center,
          //     //         color: Colors.teal[100 * (index % 9)],
          //     //         child: Text('Grid Item $index'),
          //     //       );
          //     //     },
          //     //     childCount: 5,
          //     //   ),
          //     // ),
          //     // SliverPinnedHeader(
          //     //   child: Container(
          //     //     child: Text('Teste'),
          //     //   ),
          //     // ),
          //     // SliverGrid(
          //     //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //     //     maxCrossAxisExtent: 200.0,
          //     //     mainAxisSpacing: 10.0,
          //     //     crossAxisSpacing: 10.0,
          //     //     childAspectRatio: 4.0,
          //     //   ),
          //     //   delegate: SliverChildBuilderDelegate(
          //     //     (BuildContext context, int index) {
          //     //       if (index == 2) {
          //     //         return Container();
          //     //       }
          //     //       return Container(
          //     //         alignment: Alignment.center,
          //     //         color: Colors.teal[100 * (index % 9)],
          //     //         child: Text('Grid Item $index'),
          //     //       );
          //     //     },
          //     //     childCount: 100,
          //     //   ),
          //     // ),
          //   ],
          // ),
          //

          Observer(builder: (_) {
        if (tabsStore.toggleIndexUntagged == 0) {
          List<DateTime> keys = galleryStore.isLoaded
              ? galleryStore.untaggedGridPicsByMonth.keys.toList()
              : <DateTime>[];
          keys.sort((a, b) {
            var year = b.year.compareTo(a.year);
            if (year == 0) return b.month.compareTo(a.month);
            return year;
          });
          ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                DateTime dateTime = keys[index];
                var innerMap = galleryStore.untaggedGridPicsByMonth[dateTime];
                var innerKeys = innerMap.keys.toList();
                return Column(
                  children: [
                    buildDateHeader(dateTime),
                    StaggeredGridView.countBuilder(addAutomaticKeepAlives: true,
                      key: Key(dateTime.toString()),
                      //controller: scrollControllerFirstTab,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 82.0),
                      crossAxisCount: 5,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                      itemCount: innerKeys?.length ?? 0,
                      itemBuilder: (BuildContext context, int innerIndex) {
                        PicStore picStore = innerMap[innerKeys[index]];
                        if (picStore == null)
                          return ColoredBox(color: kGreyPlaceholder);
                        return _buildItem(picStore, index);
                      },
                      staggeredTileBuilder: (int _) {
                        return StaggeredTile.fit(5);
                        /* PicStore picStore =
                      galleryStore.untaggedGridPicsByMonth[index].picStore;
              if (picStore == null) {
                    
              }
              return StaggeredTile.count(1, 1); */
                      },
                    ),
                  ],
                );
              });
          /* StaggeredGridView.countBuilder(addAutomaticKeepAlives: true,
            key: Key('month'),
            controller: scrollControllerFirstTab,
            physics: const CustomScrollPhysics(),
            padding: EdgeInsets.only(top: 82.0),
            crossAxisCount: 5,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            itemCount: galleryStore.isLoaded
                ? galleryStore.untaggedGridPicsByMonth.length
                : 0,
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(context, index);
            },
            staggeredTileBuilder: (int index) {
              PicStore picStore =
                  galleryStore.untaggedGridPicsByMonth[index].picStore;
              if (picStore == null) {
                return StaggeredTile.fit(5);
              }
              return StaggeredTile.count(1, 1);
            },
          ); */
        }

        return StaggeredGridView.countBuilder(addAutomaticKeepAlives: true,
          key: Key('day'),
          //controller: scrollControllerFirstTab,
          physics: const CustomScrollPhysics(),
          padding: EdgeInsets.only(top: 82.0),
          crossAxisCount: 3,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          itemCount:
              galleryStore.isLoaded ? galleryStore.untaggedGridPics.length : 0,
          itemBuilder: (BuildContext context, int index) {
            var untaggedPicsStore = galleryStore.untaggedGridPics;
            PicStore picStore = untaggedPicsStore[index].picStore;
            if (picStore == null)
              return buildDateHeader(untaggedPicsStore[index].date);
            return _buildItem(picStore, index);
          },
          staggeredTileBuilder: (int index) {
            PicStore picStore = galleryStore.untaggedGridPics[index].picStore;
            if (picStore == null) {
              return StaggeredTile.fit(3);
            }
            return StaggeredTile.count(1, 1);
          },
        );
      }),
    );
  }

  Widget get _failedItem => Center(
        child: Text(
          'Failed loading',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18.0),
        ),
      );

  String dateFormat(DateTime dateTime) {
    DateFormat formatter;
    print('Date Time Formatting: $dateTime');

    if (dateTime.year == DateTime.now().year) {
      formatter = tabsStore.toggleIndexUntagged == 0
          ? DateFormat.MMMM()
          : DateFormat.MMMEd();
    } else {
      formatter = tabsStore.toggleIndexUntagged == 0
          ? DateFormat.yMMMM()
          : DateFormat.yMMMEd();
    }
    return formatter.format(dateTime);
  }

  Widget buildDateHeader(DateTime date) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      height: 40.0,
      child: Row(
        children: [
          Text(
            '${date}',
            textScaler: TextScaler.linear(1.0),
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(PicStore picStore, int index) {
//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;

    final AssetEntityImageProvider imageProvider =
        AssetEntityImageProvider(picStore, isOriginal: false);

    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          Widget loader;
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              loader = const ColoredBox(color: kGreyPlaceholder);
              break;
            case LoadState.completed:
              loader = FadeImageBuilder(
                child: () {
                  return GestureDetector(
                    onLongPress: () {
                      print('LongPress');
                      if (tabsStore.multiPicBar == false) {
                        galleryStore.setSelectedPics(
                          picStore: picStore,
                          picIsTagged: false,
                        );
                        tabsStore.setMultiPicBar(true);
                      }
                    },
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        if (tabsStore.multiPicBar) {
                          galleryStore.setSelectedPics(
                            picStore: picStore,
                            picIsTagged: false,
                          );
                          print('Pics Selected Length: ${galleryStore.selectedPics.length}');
                          return;
                        }

                        tagsEditingController.text = '';
                        galleryStore.setCurrentPic(picStore);
                        tabsStore.setModalCard(true);
                      },
                      child: Observer(builder: (_) {
                        Widget image = Positioned.fill(
                          child: RepaintBoundary(
                            child: state.completedWidget,
                          ),
                        );
                        if (tabsStore.multiPicBar) {
                          if (galleryStore.selectedPics.contains(picStore)) {
                            return Stack(
                              children: [
                                image,
                                Container(
                                  constraints: BoxConstraints.expand(),
                                  decoration: BoxDecoration(
                                    color: kSecondaryColor.withOpacity(0.3),
                                    border: Border.all(
                                      color: kSecondaryColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 8.0,
                                  top: 6.0,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      gradient: kSecondaryGradient,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Image.asset(
                                        'lib/images/checkwhiteico.png'),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Stack(
                            children: [
                              image,
                              Positioned(
                                left: 8.0,
                                top: 6.0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: kGrayColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Stack(
                          children: [
                            image,
                          ],
                        );
                      }),
                    ),
                  );
                }(),
              );
              break;
            case LoadState.failed:
              loader = _failedItem;
              break;
          }
          return loader;
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabsStore = Provider.of<TabsStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);

    /* scrollControllerFirstTab =
        ScrollController(initialScrollOffset: tabsStore.offsetFirstTab);
    scrollControllerFirstTab.addListener(() {
      refreshGridPositionFirstTab();
    });
    refreshGridPositionFirstTab(); */

    print('change dependencies!');
    galleryStore.refreshPicThumbnails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: kWhiteColor,
      child: SafeArea(
        child: Observer(builder: (_) {
          if (!galleryStore.deviceHasPics) {
            return Stack(
              children: <Widget>[
                Container(
                  height: 56.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          Get.to(() =>  SettingsScreen());
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                DeviceHasNoPics(
                  message: LangControl.to.S.value.device_has_no_pics,
                ),
              ],
            );
          } else if (galleryStore.isLoaded &&
              galleryStore.untaggedPics.isEmpty) {
            return Stack(
              children: <Widget>[
                Container(
                  height: 56.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        onPressed: () {
                          Get.to(() =>  SettingsScreen());
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                DeviceHasNoPics(
                  message: LangControl.to.S.value.no_photos_were_tagged,
                ),
              ],
            );
          } else if (galleryStore.isLoaded && galleryStore.deviceHasPics) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: GestureDetector(
//                              onScaleUpdate: (update) {
/* print(update.scale); */
//                                DatabaseManager.instance.gridScale(update.scale);
//                              },
                    child: _buildGridView(context),
                  ),
                ),
                Container(
                  height: 56.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        onPressed: () {
                          Get.to(() =>  SettingsScreen());
                        },
                        child: Image.asset('lib/images/settings.png'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16.0,
                  top: tabsStore.topOffsetFirstTab,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tabsStore.multiPicBar
                            ? LangControl.to.S.value.photo_gallery_count(
                                galleryStore.selectedPics.length)
                            : LangControl.to.S.value.photo_gallery_description,
                        textScaler: TextScaler.linear(1.0),
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff979a9b),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: tabsStore.isScrolling ? 0.0 : 1.0,
                  curve: Curves.linear,
                  duration: Duration(milliseconds: 300),
                  onEnd: () {
                    tabsStore.setIsToggleBarVisible(
                        tabsStore.isScrolling ? false : true);
                  },
                  child: Visibility(
                    visible: tabsStore.isScrolling
                        ? tabsStore.isToggleBarVisible
                        : true,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ToggleBar(
                          titleLeft: LangControl.to.S.value.toggle_months,
                          titleRight: LangControl.to.S.value.toggle_days,
                          activeToggle: tabsStore.toggleIndexUntagged,
                          onToggle: (index) {
                            tabsStore.setToggleIndexUntagged(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }
}
 */
