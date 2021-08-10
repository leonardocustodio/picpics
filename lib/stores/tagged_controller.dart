import 'dart:async';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/widgets/confirm_pic_delete.dart';

import 'tabs_controller.dart';

class TaggedController extends GetxController {
  static TaggedController get to => Get.find();

  /// tagKey: {picId: ''}
  final taggedPicId = <String, RxMap<String, String>>{}.obs;
  final allTaggedPicIdList = <String, String>{}.obs;
  final picWiseTags = <String, RxMap<String, String>>{}.obs;
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

  Future<void> starredAction() async {
    //await WidgetManager.saveData(picsStores: selectedUntaggedPics.toList());

    selectedMultiBarPics.forEach((picId, value) {
      var picStore = TabsController.to.picStoreMap[picId]?.value;
      picStore ??= TabsController.to.explorPicStore(picId).value;
      picStore?.switchIsStarred();
    });
    returnAction();
  }

  void tagAction() {
    setMultiTagSheet(true);
    Future.delayed(Duration(milliseconds: 200), () {
      expandableController.value.expanded = true;
    });
  }

  Future<void> shareAction() async {
    if (selectedMultiBarPics.isEmpty) {
      return;
    }
    //print('sharing selected pics....');
    //setIsLoading(true);
    await sharePics(picKeys: selectedMultiBarPics.keys.toList()
        /* picsStores: GalleryStore.to.selectedPics.toList() */);
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

  void clearSelectedUntaggedPics() {
    selectedMultiBarPics.clear();
  }

  void onPoppingOut() {
    selectedMultiBarPics.clear();
    TagsController.to.multiPicTags.clear();
  }

  Future<bool> shouldPopOut() async {
    /// if sheet is opened the don't allow popping and just
    if (multiTagSheet.value) {
      TagsController.to.multiPicTags.clear();
      multiTagSheet.value = false;
      return false;
    }
    if (multiPicBar.value) {
      multiPicBar.value = false;
      return false;
    }
    onPoppingOut();
    return true;
  }

  void setTabIndex(int index, String? tagKey) async {
    if (selectedMultiBarPics.isEmpty) {
      if (index == 0) {
        setMultiPicBar(false);
        clearSelectedUntaggedPics();
        TagsController.to.clearMultiPicTags();
        return;
      }
    }

    if (index == 0) {
      clearSelectedUntaggedPics();
      //GalleryStore.to.clearSelectedPics();
      setMultiPicBar(false);
    } else if (index == 1) {
      await TagsController.to.tagsSuggestionsCalculate();
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        setMultiTagSheet(true);
        expandableController.value.expanded = true;
        expandablePaddingController.value.expanded = true;
      });
    } else if (index == 2) {
      if (selectedMultiBarPics.isEmpty) {
        return;
      }
      await sharePics(picKeys: selectedMultiBarPics.keys.toList());
    } else if (index == 3) {
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
            await TabsController.to
                .trashMultiplePics(selectedMultiBarPics.keys.toList().toSet());
            await refreshTaggedPhotos();
            isTaggedPicsLoaded.value = true;
            if (taggedPicId[tagKey]?.keys.isEmpty ?? true) {
              /// If there are no pictures present related to this tagKey then
              /// let's go back to previous screen
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                print('going back');
                Get.back();
              });
            }
          });
        },
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
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

  final allTaggedPicDateWiseMap = <dynamic, dynamic>{}.obs;

  Future<void> refreshTaggedPhotos() async {
    isTaggedPicsLoaded.value = false;
    final taggedPhotoIdList = await database.getAllPhoto();

    allTaggedPicIdList.clear();
    taggedPicId.clear();
    picWiseTags.clear();
    await TagsController.to.loadAllTags();
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

    DateTime? previousDay;
    DateTime? previousMonth;

    var previousDatePicIdList = <String>[];

    await Future.forEach(taggedPhotoIdList, (Photo photo) async {
      if (photo.tags.isNotEmpty) {
        /// Iterating and checking whether the picId is not a tagged pic or it's not a private pic

        var dateTime = DateTime.utc(
            photo.createdAt.year, photo.createdAt.month, photo.createdAt.day);
        if (previousDay == null || previousMonth == null) {
          previousDay = dateTime;
          previousMonth = dateTime;

          allTaggedPicDateWiseMap[dateTime] = <String>[];
        }

        if (previousDay!.year != dateTime.year ||
            previousDay!.month != dateTime.month ||
            previousDay!.day != dateTime.day) {
          if (previousDay!.month != dateTime.month) {
            allTaggedPicDateWiseMap[previousMonth] =
                List<String>.from(previousDatePicIdList);
            previousDatePicIdList = <String>[];
            allTaggedPicDateWiseMap[dateTime] = <String>[];
            previousMonth = dateTime;
          }
        }
        allTaggedPicDateWiseMap[photo.id] = '';
        previousDatePicIdList.add(photo.id);
      }
    }).then((_) {
      if (previousMonth != null) {
        allTaggedPicDateWiseMap[previousMonth] =
            List<String>.from(previousDatePicIdList);
      }
      isTaggedPicsLoaded.value = true;
    });
  }

  void addPicIdToTaggedList(String tagKey, String taggedPicId) {
    if (TaggedController.to.taggedPicId[tagKey] == null) {
      TaggedController.to.taggedPicId[tagKey] = <String, String>{}.obs;
    }
    TaggedController.to.taggedPicId[tagKey]![taggedPicId] = '';
  }
}
