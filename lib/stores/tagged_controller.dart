import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/stores/tags_controller.dart';

class TaggedController extends GetxController {
  static TaggedController get to => Get.find();

  /// tagKey: {picId: ''}
  final taggedPicId = <String, RxMap<String, String>>{}.obs;
  final allTaggedPicIdList = <String, String>{}.obs;
  final picWiseTags = <String, RxMap<String, String>>{}.obs;

  final toggleIndexTagged = 1.obs;

  ScrollController scrollControllerThirdTab;

  double offsetThirdTab = 0.0;

  final isScrolling = false.obs;
  final database = AppDatabase();

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
    if (value == hideTitleThirdTab) {
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

  Future<void> refreshTaggedPhotos() async {
    var taggedPhotoIdList = await database.getAllPhoto();

    allTaggedPicIdList.clear();
    taggedPicId.clear();
    await TagsController.to.loadAllTags();
    await Future.forEach(taggedPhotoIdList, (Photo photo) async {
      if (photo?.tags?.isNotEmpty ?? false) {
        photo?.tags?.forEach((tagKey) {
          if (taggedPicId[tagKey] == null) {
            taggedPicId[tagKey] = <String, String>{}.obs;
          }
          taggedPicId[tagKey][photo.id] = '';

          if (picWiseTags[photo.id] == null) {
            picWiseTags[photo.id] = <String, String>{}.obs;
          }
          picWiseTags[photo.id][tagKey] = '';
        });
        allTaggedPicIdList[photo.id] = '';
      }
    });
    print('${allTaggedPicIdList.keys.toList()}');
  }

  void addPicIdToTaggedList(String tagKey, String taggedPicId) {
    if (TaggedController.to.taggedPicId[tagKey] == null) {
      TaggedController.to.taggedPicId[tagKey] = <String, String>{}.obs;
    }
    TaggedController.to.taggedPicId[tagKey][taggedPicId] = '';
  }
}
