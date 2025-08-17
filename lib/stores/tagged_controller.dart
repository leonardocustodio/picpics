import 'dart:async';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/stores/percentage_dialog_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/widgets/confirm_pic_delete.dart';

import 'tabs_controller.dart';
import 'package:picPics/utils/app_logger.dart';

class TaggedController extends GetxController {
  static TaggedController get to => Get.find();
  final bottomOptionsBar = 0.obs;

  /// tagKey: {picId: ''}
  final taggedPicId = <String, RxMap<String, String>>{}.obs;

  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  final allTaggedPicIdList = <String, String>{}.obs;
  final picWiseTags = <String, RxMap<String, String>>{}.obs;
  final tagsController = Get.find<TagsController>();
  final isTaggedPicsLoaded = false.obs;

  final multiPicBar = false.obs;
  final multiTagSheet = false.obs;
  final expandableController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));
  final expandablePaddingController =
      Rx<ExpandableController>(ExpandableController(initialExpanded: false));
  final toggleIndexTagged = 1.obs;

  late ScrollController scrollControllerThirdTab;

  double offsetThirdTab = 0.0;

  final selectedMultiBarPics = <String, bool>{}.obs;
  final isScrolling = false.obs;
  final database = AppDatabase();

  void setMultiPicBar(bool value) {
    if (value) {
      Analytics.sendEvent(Event.selected_photos);
    }
    multiPicBar.value = value;
  }

  void returnAction() {
    selectedMultiBarPics.clear();
    setMultiPicBar(false);
  }

  void setMultiTagSheet(bool value) {
    multiTagSheet.value = value;
  }

  /* Future<void> starredAction() async {
    //await WidgetManager.saveData(picsStores: selectedUntaggedPics.toList());

    selectedMultiBarPics.forEach((picId, value) {
      var picStore = TabsController.to.picStoreMap[picId]?.value;
      picStore ??= TabsController.to.explorPicStore(picId).value;
      picStore?.switchIsStarred();
    });
    returnAction();
  } */

  void tagAction() {
    setMultiTagSheet(true);
    Future.delayed(const Duration(milliseconds: 200), () {
      expandableController.value.expanded = true;
    });
  }

  Future<void> shareAction() async {
    if (selectedMultiBarPics.isEmpty) {
      return;
    }
    AppLogger.d('sharing selected pics....');
    //setIsLoading(true);
    await sharePics(
        picKeys: selectedMultiBarPics.keys
            .toList() /* picsStores: GalleryStore.to.selectedPics.toList() */);
    //setIsLoading(false);
  }

  void trashAction() {
    if (selectedMultiBarPics.isEmpty) {
      return;
    }
    TabsController.to
        .trashMultiplePics(selectedMultiBarPics.keys.toList().toSet());
  }

  bool get deviceHasPics {
    return TabsController.to.assetMap.isNotEmpty;
  }

  void onPoppingOut() {
    selectedMultiBarPics.clear();
    tagsController.multiPicTags.clear();
  }

  Future<bool> shouldPopOut() async {
    /// if sheet is opened the don't allow popping and just
    AppLogger.d('WillPopScope taggedController');
    if (multiTagSheet.value) {
      AppLogger.d('WillPopScope multiPicTags');
      tagsController.multiPicTags.clear();
      multiTagSheet.value = false;
      return false;
    }
    if (multiPicBar.value) {
      AppLogger.d('WillPopScope multiPicBar');
      multiPicBar.value = false;
      return false;
    }

    AppLogger.d('WillPopScope onPoppingOut');
    onPoppingOut();
    return true;
  }

  Future<void> untagPicsFromTagFromDateOrGroupingCallable() async {
    if (TabsController.to.selectedMultiBarPics.isEmpty) {
      return;
    }

    if (toggleIndexTagged.value == 0) {
      final picIdMapToTagKey = <String, Map<String, String>>{};
      TabsController.to.selectedMultiBarPics.forEach((picId, value) {
        if (picWiseTags.value[picId] != null) {
          picIdMapToTagKey[picId] = picWiseTags.value[picId]!.value;
        }
      });
      await untagPicsFromTag(picIdMapToTagKey: picIdMapToTagKey);
    } else if (toggleIndexTagged.value == 1) {}
  }

  Future<void> untagPicsFromTag(
      {Map<String, Map<String, String>>? tagKeyMapToPicId,
      Map<String, Map<String, String>>? picIdMapToTagKey}) async {
    assert(picIdMapToTagKey != null || tagKeyMapToPicId != null);

    final percentageController = Get.find<PercentageDialogController>();
    final tabsController = Get.find<TabsController>();
    if (picIdMapToTagKey == null) {
      picIdMapToTagKey = <String, Map<String, String>>{};

      tagKeyMapToPicId!.forEach((tagKey, picMaps) {
        for (var picId in picMaps.keys) {
          if (picIdMapToTagKey![picId] == null) {
            picIdMapToTagKey[picId] = <String, String>{tagKey: ''};
          } else {
            picIdMapToTagKey[picId]![tagKey] = '';
          }
        }
      });
    } else {
      tagKeyMapToPicId = <String, Map<String, String>>{};

      picIdMapToTagKey.forEach((picId, tagMaps) {
        for (var tagKey in tagMaps.keys) {
          if (tagKeyMapToPicId![tagKey] == null) {
            tagKeyMapToPicId[tagKey] = <String, String>{picId: ''};
          } else {
            tagKeyMapToPicId[tagKey]![picId] = '';
          }
        }
      });
    }
    await showDialog<void>(
        context: Get.context!,
        barrierDismissible: true,
        builder: (_) {
          return ConfirmationDialog(
            headingText: 'Untag',
            titleText:
                'Are you sure you want to untag ${picIdMapToTagKey!.keys.length} photos ?',
            okText: 'Untag',
            cancelText: 'Cancel',
            onPressedOk: () async {
              Get.back();
              tabsController.setMultiPicBar(false);
              tabsController.setMultiTagSheet(false);
              tabsController.selectedMultiBarPics.clear();
              await Future.delayed(Duration.zero, () async {
                percentageController.start(
                    picIdMapToTagKey!.keys.length + .0, 'Un-tagging...');
                await tagsController.removeTagsFromPicsMainFunction(
                  picIdMapToTagKey: picIdMapToTagKey,
                  tagKeyMapToPicId: tagKeyMapToPicId!,
                );
                //await refreshTaggedPhotos();
              });
            },
          );
        });
  }

  void setTabIndexAllTaggedKeys(int idx) async {
    bottomOptionsBar.value = idx;
    final tabsController = Get.find<TabsController>();

    switch (bottomOptionsBar.value) {
      case 0:

        /// back button
        tabsController.setMultiPicBar(false);
        tabsController.clearSelectedPics();
        tagsController.clearMultiPicTags();
        return;
      case 1:
        final picIdList = tabsController.selectedMultiBarPics.keys.toList();
        final percentageController = Get.find<PercentageDialogController>();
        final map = <String, bool>{};
        percentageController.start(picIdList.length + .0, 'Processing...');
        await Future.forEach(picIdList, (String picId) async {
          final starred =
              await tabsController.picStoreMap[picId]?.value.switchIsStarred();
          if (starred != null) {
            map[picId] = starred;
          }
          await Future.delayed(Duration.zero, () {
            percentageController.value.value += 1.0;
          });
        }).then((_) async {
          for (var picId in map.keys) {
            tabsController.picStoreMap[picId]?.value.isStarred.value =
                map[picId]!;
          }
          percentageController.stop();
          tabsController.setMultiPicBar(false);
          tabsController.setMultiTagSheet(false);
          tabsController.clearSelectedPics();
          tagsController.clearMultiPicTags();
        });
        return;
      case 2:

        /// tag adding button
        await tagsController.tagsSuggestionsCalculate();
        tabsController.setMultiTagSheet(true);
        tabsController.expandableController.value.expanded = true;
        tabsController.expandablePaddingController.value.expanded = true;
        return;
      case 3:

        /// tag sharing button
        if (tabsController.selectedMultiBarPics.isEmpty) {
          return;
        }
        await sharePics(
            picKeys: tabsController.selectedMultiBarPics.keys.toList());
        return;
      case 4:

        /// tag deleting button
        if (tabsController.selectedMultiBarPics.isEmpty) {
          return;
        }
        await showDialog<void>(
          context: Get.context!,
          barrierDismissible: true,
          builder: (_) {
            return ConfirmPicDelete(onPressedDelete: () async {
              await Analytics.sendEvent(Event.deleted_photo);
              Get.back();
              isTaggedPicsLoaded.value = false;
              await TabsController.to.trashMultiplePics(
                  tabsController.selectedMultiBarPics.keys.toList().toSet());
              await refreshTaggedPhotos();
              isTaggedPicsLoaded.value = true;
              /* 
              if (picIds?.isEmpty ?? true) {
                /// If there are no pictures present related to this tagKey then
                /// let's go back to previous screen
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  AppLogger.d('going back');
                  Get.back();
                });
              } */
            });
          },
        );
        return;
      default:
        return;
    }
  }

  void setTabIndexParticularTagKey(int idx, String? tagKey) async {
    bottomOptionsBar.value = idx;

    switch (bottomOptionsBar.value) {
      case 0:

        /// back button
        setMultiPicBar(false);
        selectedMultiBarPics.clear();
        if (selectedMultiBarPics.isEmpty) {
          tagsController.clearMultiPicTags();
        }
        return;
      case 1:

        /// tag adding button
        setMultiTagSheet(true);
        await tagsController.tagsSuggestionsCalculate();
        expandableController.value.expanded = true;
        expandablePaddingController.value.expanded = true;
        return;
      case 2:

        /// tag sharing button
        if (selectedMultiBarPics.isEmpty) {
          return;
        }
        await sharePics(picKeys: selectedMultiBarPics.keys.toList());
        return;
      case 3:

        /// tag deleting button
        if (selectedMultiBarPics.isEmpty) {
          return;
        }
        await showDialog<void>(
          context: Get.context!,
          barrierDismissible: true,
          builder: (_) {
            return ConfirmPicDelete(onPressedDelete: () async {
              await Analytics.sendEvent(Event.deleted_photo);
              Get.back();
              isTaggedPicsLoaded.value = false;
              await TabsController.to.trashMultiplePics(
                  selectedMultiBarPics.keys.toList().toSet());
              await refreshTaggedPhotos();
              isTaggedPicsLoaded.value = true;
              if (taggedPicId[tagKey]?.keys.isEmpty ?? true) {
                /// If there are no pictures present related to this tagKey then
                /// let's go back to previous screen
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AppLogger.d('going back');
                  Get.back();
                });
              }
            });
          },
        );
        return;
      default:
        return;
    }
  }

  @override
  void onInit() {
    super.onInit();

    searchFocusNode.addListener(() {
      tagsController.isSearching.value = searchFocusNode.hasFocus ||
          tagsController.searchText.isNotEmpty ||
          tagsController.selectedFilteringTagsKeys.isNotEmpty;
      if (tagsController.isSearching.value) {
        tagsController.tagsSuggestionsCalculate();
      }
    });
    scrollControllerThirdTab =
        ScrollController(initialScrollOffset: offsetThirdTab);
    scrollControllerThirdTab.addListener(() {
      refreshGridPositionThirdTab();
    });
    refreshTaggedPhotos();
    refreshGridPositionThirdTab();
  }

  final hideTitleThirdTab = false.obs;
  void setHideTitleThirdTab(bool value) {
    if (value == hideTitleThirdTab.value) {
      return;
    }
    hideTitleThirdTab.value = value;
  }

  void refreshGridPositionThirdTab() {
    var offset = scrollControllerThirdTab.hasClients
        ? scrollControllerThirdTab.offset
        : scrollControllerThirdTab.initialScrollOffset;

    if (offset >= 40) {
      setHideTitleThirdTab(true);
    } else if (offset <= 0) {
      setHideTitleThirdTab(false);
    }

    if (scrollControllerThirdTab.hasClients) {
      offsetThirdTab = scrollControllerThirdTab.offset;
    }
  }

  void setIsScrolling(bool value) => isScrolling.value = value;

  final allTaggedPicDateWiseList = <dynamic>[].obs;

  Future<void> refreshTaggedPhotos() async {
    isTaggedPicsLoaded.value = false;
    final taggedPhotoIdList = await database.getAllPhoto();

    allTaggedPicIdList.clear();
    allTaggedPicDateWiseList.clear();
    taggedPicId.clear();
    picWiseTags.clear();
    await tagsController.loadAllTags();
    await Future.forEach(taggedPhotoIdList, (Photo photo) async {
      if (photo.tags.isNotEmpty) {
        photo.tags.forEach((tagKey, _) {
          if (taggedPicId[tagKey] == null) {
            taggedPicId[tagKey] = <String, String>{}.obs;
          }
          taggedPicId[tagKey]![photo.id] = '';

          if (picWiseTags[photo.id] == null) {
            picWiseTags[photo.id] = <String, String>{}.obs;
          }
          picWiseTags[photo.id]![tagKey] = '';
        });
        allTaggedPicIdList[photo.id] = '';
      }
    });

    /// Sorting the photo-ids on basis of their creation datetime

    taggedPhotoIdList.sort((a, b) {
      var year = b.createdAt.year.compareTo(a.createdAt.year);
      if (year == 0) {
        var month = b.createdAt.month.compareTo(a.createdAt.month);
        if (month == 0) {
          var day = b.createdAt.day.compareTo(a.createdAt.day);
          return day;
        }
        return month;
      }
      return year;
    });

    DateTime? previousMonth;

    var previousDatePicIdList = <String>[];

    await Future.forEach(taggedPhotoIdList, (Photo photo) async {
      if (photo.tags.isNotEmpty) {
        /// Iterating and checking whether the picId is not a tagged pic or it's not a private pic

        var dateTime = DateTime.utc(
            photo.createdAt.year, photo.createdAt.month, photo.createdAt.day);
        if (previousMonth == null) {
          previousMonth = dateTime;

          allTaggedPicDateWiseList.add(dateTime);
        }

        if (previousMonth!.year != dateTime.year ||
            previousMonth!.month != dateTime.month ||
            previousMonth!.day != dateTime.day) {
          if (previousMonth!.month != dateTime.month) {
            /* allTaggedPicDateWiseMap[previousMonth] =
                List<String>.from(previousDatePicIdList); */
            previousDatePicIdList = <String>[];
            allTaggedPicDateWiseList.add(dateTime);
            previousMonth = dateTime;
          }
        }
        allTaggedPicDateWiseList.add(photo.id);
        previousDatePicIdList.add(photo.id);
      }
    }).then((_) {
      /* if (previousMonth != null) {
        allTaggedPicDateWiseMap[previousMonth] =
            List<String>.from(previousDatePicIdList);
      } */
      isTaggedPicsLoaded.value = true;
    });
  }

  void addPicIdToTaggedList(String tagKey, String picId) {
    if (taggedPicId[tagKey] == null) {
      taggedPicId[tagKey] = <String, String>{}.obs;
    }
    taggedPicId[tagKey]![picId] = '';
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String titleText;
  final String cancelText;
  final String okText;
  final String headingText;
  final Function()? onPressedClose;
  final Function() onPressedOk;

  const ConfirmationDialog({
    super.key,
    required this.headingText,
    required this.titleText,
    required this.okText,
    required this.cancelText,
    this.onPressedClose,
    required this.onPressedOk,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: Get.width < 360
          ? const EdgeInsets.symmetric(horizontal: 20.0)
          : const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        headingText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff979a9b),
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.4099999964237213,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: CupertinoButton(
                      onPressed: () {
                        onPressedClose?.call();
                        Get.back();
                      },
                      child: Image.asset('lib/images/closegrayico.png'),
                    ),
                  ),
                ],
              ),
              /* Padding(
                padding: const EdgeInsets.symmetric(vertical: 44.0),
                child: Image.asset('lib/images/lockmodalico.png'),
              ), */
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  titleText,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff707070),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0, top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          /* if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          } */
                          onPressedClose?.call();
                          Get.back();
                        },
                        child: Container(
                          height: 44.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: kSecondaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              cancelText,
                              textScaler: TextScaler.linear(1.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Lato',
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 16.0),
                    ),
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          /* if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          } */
                          onPressedOk();
                        },
                        child: Container(
                          height: 44.0,
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              okText,
                              textScaler: TextScaler.linear(1.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: kLoginButtonTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
