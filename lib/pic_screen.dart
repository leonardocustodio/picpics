import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:picPics/asset_provider.dart';
import 'package:picPics/components/bubble_bottom_bar.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/premium_screen.dart';
import 'package:picPics/push_notifications_manager.dart';
import 'package:picPics/settings_screen.dart';
import 'package:picPics/widgets/photo_card.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:picPics/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:picPics/database_manager.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/throttle.dart';
import 'package:picPics/model/pic.dart';
import 'package:hive/hive.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picPics/image_item.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'dart:io';
import 'package:picPics/admob_manager.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:picPics/widgets/edit_tag_modal.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:picPics/widgets/watch_ad_modal.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class PicScreen extends StatefulWidget {
  static const id = 'pic_screen';

  @override
  _PicScreenState createState() => _PicScreenState();
}

class _PicScreenState extends State<PicScreen> with AfterLayoutMixin<PicScreen> {
  ExpandableController expandableController = ExpandableController(initialExpanded: false);
  ExpandableController expandablePaddingController = ExpandableController(initialExpanded: false);

  BuildContext multiPicContext;
  bool multiPicSelect = false;
  bool showingMultiTagSheet = false;
  List<int> picsSelected = [];
  List<String> multiPicTagKeys = [];

  ScrollController scrollControllerFirstTab;
  ScrollController scrollControllerThirdTab;

  CarouselController carouselController = CarouselController();
  SwiperController swiperController = SwiperController();

  SwiperController tutorialSwiperController = SwiperController();

  TextEditingController tagsEditingController = TextEditingController();

  TextEditingController bottomTagsEditingController = TextEditingController();
//  Map<String, List<String>> suggestions;

//  FocusNode tagsFocusNode = FocusNode();

  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

//  int currentIndex;
  int swiperIndex = 0;
  int picSwiper = 0;

  double offsetFirstTab = 0.0;
  double topOffsetFirstTab = 64.0;
//  double topOffsetFirstTab = 112.0;
  bool hideSubtitleFirstTab = false;

  double offsetThirdTab = 0.0;
  double topOffsetThirdTab = 64.0;
  bool hideTitleThirdTab = false;
  bool hideSubtitleThirdTab = false;

  bool modalPhotoCard = false;

  AssetEntity selectedPhotoData;
  Pic selectedPhotoPicInfo;
  int selectedPhotoIndex;
  Throttle _changeThrottle;

  bool isAdVisible = false;
  bool isLoading = false;

  void changeIndex() {
    print('teste');
  }

  void trashPics() async {
    print('trashing selected pics....');

    List<String> entitiesIds = [];
    List<AssetEntity> entities = [];
    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];

    for (var index in picsSelected) {
      AssetEntity entity = pathProvider.orderedList[index];
      entitiesIds.add(entity.id);
      entities.add(entity);
    }

    final List<String> result = await PhotoManager.editor.deleteWithIds(entitiesIds);
    if (result.isNotEmpty) {
      for (AssetEntity entity in entities) {
        DatabaseManager.instance.deletedPic(entity);
      }

      picsSelected = [];
      setState(() {
        multiPicSelect = false;
      });
    }
  }

  void trashPic(AssetEntity entity) async {
    print('trashing pic');
    final List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
    if (result.isNotEmpty) {
      DatabaseManager.instance.deletedPic(entity);
      if (modalPhotoCard) {
        setState(() {
          selectedPhotoPicInfo = null;
          selectedPhotoIndex = null;
          selectedPhotoData = null;
          modalPhotoCard = false;
        });
      }
    }
  }

  void _sendCurrentTabToAnalytics(index) {
    print('#### sending to analytics!');

    var tabName = '';
    if (index == 0) {
      tabName = 'gallery';
    } else if (index == 1) {
      tabName = 'pics';
    } else if (index == 2) {
      tabName = 'tagged';
    }

    DatabaseManager.instance.observer.analytics.setCurrentScreen(
      screenName: 'pic_screen/$tabName',
    );
  }

  void movedGridPositionFirstTab() {
    var offset = scrollControllerFirstTab.offset;

    if (offset >= 112) {
      setState(() {
        topOffsetFirstTab = 5;
        hideSubtitleFirstTab = true;
      });
    } else if (offset >= 52) {
      setState(() {
        topOffsetFirstTab = 64.0 - (offset - 52.0);
        hideSubtitleFirstTab = false;
      });
    } else if (offset <= 0) {
      setState(() {
        topOffsetFirstTab = 64;
        hideSubtitleFirstTab = false;
      });
    }

    offsetFirstTab = scrollControllerFirstTab.offset;
    print(scrollControllerFirstTab.offset);
  }

  void movedGridPositionThirdTab() {
    var offset = scrollControllerThirdTab.offset;

    if (offset >= 98) {
      setState(() {
        hideTitleThirdTab = true;
      });
    } else if (offset >= 52) {
      setState(() {
        hideTitleThirdTab = false;
        hideSubtitleThirdTab = true;
      });
    } else if (offset < 40) {
      setState(() {
        topOffsetThirdTab = 64;
        hideTitleThirdTab = false;
        hideSubtitleThirdTab = false;
      });
    }

    offsetThirdTab = scrollControllerThirdTab.offset;
    print(scrollControllerThirdTab.offset);
  }

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    isAdVisible = false;

//    if (DatabaseManager.instance.userSettings.tutorialCompleted == true) {
//      isAdVisible = true;
//      Ads.setScreen(PicScreen.id, DatabaseManager.instance.currentTab);
//    }

    KeyboardVisibility.onChange.listen((bool visible) {
      print('keyboard: $visible');

      if (visible && showingMultiTagSheet) {
        setState(() {
          expandablePaddingController.expanded = true;
        });
      } else if (!visible && showingMultiTagSheet) {
        setState(() {
          expandablePaddingController.expanded = false;
        });
      }

//      setState(() {
//        isAdVisible = !visible;
//        isKeyboardVisible = visible;
//      });
    });

//    _changeThrottle = Throttle(onCall: _onAssetChange);
//    PhotoManager.addChangeCallback(_changeThrottle.call);
    PhotoManager.addChangeCallback(_onAssetChange);
    PhotoManager.startChangeNotify();

    if (DatabaseManager.instance.userSettings.tutorialCompleted == true && DatabaseManager.instance.userSettings.notifications == true) {
      PushNotificationsManager push = PushNotificationsManager();
      push.init();
    }

    if (DatabaseManager.instance.userSettings.isPremium) {
      DatabaseManager.instance.checkPremiumStatus();
    }

    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        print('@@@ loaded');
      }

      if (event == RewardedVideoAdEvent.rewarded) {
        print('@@@ rewarded');
        DatabaseManager.instance.setCanTagToday(true);
        Ads.loadRewarded();
      }

      if (event == RewardedVideoAdEvent.closed || event == RewardedVideoAdEvent.failedToLoad) {
        Ads.loadRewarded();
      }
    };
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    print('#!#!#!#!#!# AFTER LAYOUT');
//    if (DatabaseManager.instance.editingTags == true) {
//      tagsFocusNode.requestFocus();
//    }
  }

  @override
  void dispose() {
    PhotoManager.removeChangeCallback(_changeThrottle.call);
    PhotoManager.stopChangeNotify();
    _changeThrottle.dispose();
    super.dispose();
  }

  void _onAssetChange(MethodCall call) {
    print('#!#!#!#!#!#! asset changed: ${call.arguments}');

    List<dynamic> deletedPics = call.arguments['delete'];
    print(deletedPics);

    if (deletedPics.length > 0) {
      print('### deleted pics from library!');
      for (var pic in deletedPics) {
        print('Pic deleted Id: ${pic['id']}');
        AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
        AssetEntity entity = pathProvider.orderedList.firstWhere((element) => element.id == pic['id'], orElse: () => null);

        if (entity != null) {
          DatabaseManager.instance.deletedPic(
            entity,
            removeFromDb: false,
          );
        }
      }
    }

//    _onPhotoRefresh();
  }

  void changePage(int index) {
    if (index == 0) {
      AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
      List<String> photosIds = [];
      for (int x = 0; x < pathProvider.orderedList.length; x++) {
        bool hasTag = DatabaseManager.instance.picHasTag[x];
        AssetEntity entity = pathProvider.orderedList[x];
        if (!hasTag) {
          photosIds.add(entity.id);
        }
      }
      DatabaseManager.instance.slideThumbPhotoIds = photosIds;
    } else if (index == 1) {
      AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
      List<String> photosIds = [];
      for (int x = 0; x < DatabaseManager.instance.sliderIndex.length; x++) {
        int orderedIndex = DatabaseManager.instance.sliderIndex[x];
        AssetEntity entity = pathProvider.orderedList[orderedIndex];
        photosIds.add(entity.id);
      }
      DatabaseManager.instance.slideThumbPhotoIds = photosIds;
    }

    if (multiPicSelect) {
      if (index == 0) {
        picsSelected = [];
        setState(() {
          multiPicSelect = false;
        });
      } else if (index == 1) {
//        showMultiTagSheet();

        // Verificar se multipic não existe antes
        DatabaseManager.instance.tagsSuggestions(
          bottomTagsEditingController.text,
          'MULTIPIC',
          // excludeTags: picInfo.tags,
        );

        setState(() {
          showingMultiTagSheet = true;
        });

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            expandableController.expanded = true;
          });
        });
      } else {
        trashPics();
      }

      return;
    }

    _sendCurrentTabToAnalytics(index);
    print('Trying to set swiper to index: ${DatabaseManager.instance.swiperIndex}');
//    swiperController.move(DatabaseManager.instance.swiperIndex(), animation: false);
    DatabaseManager.instance.setCurrentTab(index);
//    swiperController.index = DatabaseManager.instance.swiperIndex();

//    if (index == 1) {
//      print('#### moving to picture.... $picSwiper');
//      swiperController.move(picSwiper, animation: false);
//    }
  }

  showEditTagModal() {
    if (DatabaseManager.instance.selectedTagKey != '') {
      TextEditingController alertInputController = TextEditingController();
      Pic getPic = DatabaseManager.instance.getPicInfo(DatabaseManager.instance.selectedPhoto.id);
      String tagName = DatabaseManager.instance.getTagName(DatabaseManager.instance.selectedTagKey);
      alertInputController.text = tagName;

      print('showModal');
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return EditTagModal(
            alertInputController: alertInputController,
            onPressedDelete: () {
              DatabaseManager.instance.deleteTag(tagKey: DatabaseManager.instance.selectedTagKey);
              DatabaseManager.instance.tagsSuggestions(
                tagsEditingController.text,
                DatabaseManager.instance.selectedPhoto.id,
                excludeTags: getPic.tags,
                notify: false,
              );
              Navigator.of(context).pop();
            },
            onPressedOk: () {
              print('Editing tag - Old name: ${DatabaseManager.instance.selectedTagKey} - New name: ${alertInputController.text}');
              if (tagName != alertInputController.text) {
                DatabaseManager.instance.editTag(
                  oldTagKey: DatabaseManager.instance.selectedTagKey,
                  newName: alertInputController.text,
                );
              }
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  bool checkTagHasOneValidPic(Tag tag) {
    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];

    for (String photoId in tag.photoId) {
      var data = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);
      if (data != null) {
        return true;
      }
    }
    return false;
  }

  Widget _buildTaggedGridView() {
    bool isFiltered = DatabaseManager.instance.searchActiveTags.isNotEmpty;
    var picsBox = Hive.box('pics');
    var tagsBox = Hive.box('tags');

    scrollControllerThirdTab = ScrollController(initialScrollOffset: offsetThirdTab);
    scrollControllerThirdTab.addListener(() {
      movedGridPositionThirdTab();
    });

    double newPadding = 0.0;
    if (DatabaseManager.instance.searchingTags == true) {
      newPadding = 140 - offsetThirdTab;
      if (newPadding > 140) {
        newPadding = 140.0;
      }
      if (newPadding < 0) {
        newPadding = 0;
      }
    }

    int totalTags = 0;
    int totalPics = 0;

    List<Widget> widgetsArray = [];
    List<bool> isTitleWidget = [];

    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];

    if (!isFiltered) {
      List<String> slideThumbPhotoIds = [];

      for (Tag tag in tagsBox.values) {
        if (tag.photoId.length == 0) {
          print('skipping because tag has no pictures...');
          continue;
        }

        bool oneValidPic = checkTagHasOneValidPic(tag);
        if (!oneValidPic) {
          print('skipping because tag has no valid pictures...');
          continue;
        }

        totalTags += 1;
        isTitleWidget.add(true);
        widgetsArray.add(Container(
          padding: const EdgeInsets.only(left: 2.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                tag.name,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff606566),
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.4099999964237213,
                ),
              ),
              CupertinoButton(
                onPressed: () async {
                  print('share pics');
                  setState(() {
                    isLoading = true;
                  });
                  await DatabaseManager.instance.sharePics(photoIds: tag.photoId);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Image.asset('lib/images/sharepicsico.png'),
              ),
            ],
          ),
        ));
        for (String photoId in tag.photoId) {
          var data = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);

          if (data == null) {
            print('Found a deleted picture');
            continue;
          }

          totalPics += 1;
          isTitleWidget.add(false);

          slideThumbPhotoIds.add(data.id);
          widgetsArray.add(RepaintBoundary(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Pic picInfo = DatabaseManager.instance.getPicInfo(data.id);
                    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
                    int indexOfPic = pathProvider.orderedList.indexWhere((element) => element.id == data.id);
                    tagsEditingController.text = '';

                    DatabaseManager.instance.tagsSuggestions(
                      tagsEditingController.text,
                      data.id,
                      excludeTags: picInfo.tags,
                      notify: false,
                    );

                    print('PicTags: ${picInfo.tags}');

                    selectedPhotoData = data;
                    selectedPhotoPicInfo = picInfo;
                    selectedPhotoIndex = indexOfPic;

                    setState(() {
                      modalPhotoCard = true;
                    });
                  },
                  child: ImageItem(
                    entity: data,
                    size: 150,
                    backgroundColor: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ));
        }
      }
      DatabaseManager.instance.slideThumbPhotoIds = slideThumbPhotoIds;
    } else {
      for (var photoId in DatabaseManager.instance.searchPhotosIds) {
        var data = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);
        if (data == null) {
          print('Found a deleted picture');
          continue;
        }

        totalPics += 1;
        widgetsArray.add(RepaintBoundary(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Pic picInfo = DatabaseManager.instance.getPicInfo(data.id);
//                    int indexOfPic = DatabaseManager.instance.allPics.indexOf(data.id);
                  tagsEditingController.text = '';

                  DatabaseManager.instance.tagsSuggestions(
                    tagsEditingController.text,
                    data.id,
                    excludeTags: picInfo.tags,
                    notify: false,
                  );

                  print('PicTags: ${picInfo.tags}');

                  selectedPhotoData = data;
                  selectedPhotoPicInfo = picInfo;

                  setState(() {
                    modalPhotoCard = true;
                  });
                },
                child: ImageItem(
                  entity: data,
                  size: 150,
                  backgroundColor: Colors.grey[400],
                ),
              ),
            ),
          ),
        ));
      }
    }

//    print('Number of pics: ${DatabaseManager.instance.allPics.length}');
//    print('Number of tags: ${DatabaseManager.instance.allTags.length}');

    print('New Padding: $newPadding');
//    print('Deleted pic index: $isDeletedPic');

    return StaggeredGridView.countBuilder(
      controller: scrollControllerThirdTab,
      padding: EdgeInsets.only(
        top: 140 - newPadding,
        right: 6.0,
        left: 6.0,
      ),
      crossAxisCount: 3,
      itemCount: isFiltered ? totalPics : totalTags + totalPics, // picsBox.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return widgetsArray[index];
      },
      staggeredTileBuilder: (int index) {
        if (isFiltered) return StaggeredTile.count(1, 1);

        if (isTitleWidget[index]) {
          return StaggeredTile.fit(3);
        }
        return StaggeredTile.count(1, 1);
      },
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget _buildGridView() {
    print('### Number of photos: ${PhotoProvider.instance.list[0].assetCount}');

    scrollControllerFirstTab = ScrollController(initialScrollOffset: offsetFirstTab);
    scrollControllerFirstTab.addListener(() {
      movedGridPositionFirstTab();
    });

    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    int itemCount = pathProvider.isLoaded ? pathProvider.orderedList.length : 0;

    return StaggeredGridView.countBuilder(
      controller: scrollControllerFirstTab,
      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 140.0),
      crossAxisCount: 3,
      itemCount: itemCount,
      itemBuilder: _buildItem,
      staggeredTileBuilder: (int index) {
        if (DatabaseManager.instance.picHasTag[index] == true) return StaggeredTile.count(0, 0);
        return StaggeredTile.count(1, 1);
      },
//      mainAxisSpacing: 5.0,
//      crossAxisSpacing: 5.0,
    );
//  }
  }

  Widget _buildItem(BuildContext context, int index) {
    if (DatabaseManager.instance.picHasTag[index] == true) {
      print('This pic has tag returning empty container');
      return Container();
    }

    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    print('pathProvider itemcount: ${pathProvider.list.length}');

    var data = pathProvider.orderedList[index];

//    var thumbWidth = MediaQuery.of(context).size.width / 3.0;
    print('Build Item: $index');

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onLongPress: () {
            print('LongPress');
            if (multiPicSelect == false) {
              picsSelected.add(index);
              multiPicContext = context;
              setState(() {
                multiPicSelect = true;
              });
            }
          },
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (multiPicSelect) {
                if (picsSelected.contains(index)) {
                  setState(() {
                    picsSelected.remove(index);
                  });
                } else {
                  setState(() {
                    picsSelected.add(index);
                  });
                }
                print('Pics Selected Length: ${picsSelected.length}');
                return;
              }

              Pic picInfo = DatabaseManager.instance.getPicInfo(data.id);
              tagsEditingController.text = '';

              if (picInfo == null) {
                picInfo = Pic(
                  data.id,
                  data.createDateTime,
                  data.latitude,
                  data.longitude,
                  null,
                  null,
                  null,
                  null,
                  [],
                );
              }

              DatabaseManager.instance.tagsSuggestions(
                tagsEditingController.text,
                data.id,
                excludeTags: picInfo.tags,
                notify: false,
              );

              print('PicTags: ${picInfo.tags}');

              selectedPhotoData = data;
              selectedPhotoPicInfo = picInfo;
              selectedPhotoIndex = index;

              setState(() {
                modalPhotoCard = true;
              });
            },
            child: ImageItem(
              entity: data,
              size: 150,
              backgroundColor: Colors.grey[400],
              showOverlay: multiPicSelect ? true : false,
              isSelected: picsSelected.contains(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSlider(BuildContext context, int index) {
    print('photo slides index: $index');
    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];

    int orderedIndex = DatabaseManager.instance.sliderIndex[index];
    print('Slider index in index $index: $orderedIndex');
    var data = pathProvider.orderedList[orderedIndex];

    Pic picInfo = DatabaseManager.instance.getPicInfo(data.id);

    if (picInfo == null) {
      picInfo = Pic(
        data.id,
        data.createDateTime,
        data.latitude,
        data.longitude,
        null,
        null,
        null,
        null,
        [],
      );
    }

    print('photo id: ${data.id}');
    double latitude = data.latitude;
    double longitude = data.longitude;

    print('lat: $latitude - long: $longitude');

//    if (latitude == 0.0 && longitude == 0.0) {
//      DatabaseManager.instance.currentPhotoCity = 'Local da foto';
//      DatabaseManager.instance.currentPhotoState = ' estado';
//    } else if (DatabaseManager.instance.lastLocationRequest[0] == latitude &&
//        DatabaseManager.instance.lastLocationRequest[1] == longitude) {
//      print('skipping location request');
//    } else {
//      DatabaseManager.instance.findLocation(latitude, longitude);
//    }

//    if (suggestions == null) {
//      suggestions = DatabaseManager.instance.tagsSuggestions(
//        '',
//        picInfo.photoId,
//        excludeTags: picInfo.tags,
//      );
//    }

    print('using picSwiper id: $picSwiper');

    DatabaseManager.instance.tagsSuggestions(
      tagsEditingController.text,
      picInfo.photoId,
      excludeTags: picInfo.tags,
      notify: false,
    );

    return PhotoCard(
      data: data,
      photoId: picInfo.photoId,
      picSwiper: picSwiper,
      index: index,
      tagsEditingController: tagsEditingController,
      specificLocation: picInfo.specificLocation,
      generalLocation: picInfo.generalLocation,
      showEditTagModal: showEditTagModal,
      onPressedTrash: () {
        trashPic(data);
      },
    );
  }

  void dismissPhotoCard() {
    selectedPhotoData = null;
    selectedPhotoPicInfo = null;
    selectedPhotoIndex = null;

    setState(() {
      modalPhotoCard = false;
    });
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey[400],
        ),
      ),
    );
  }

  void _loadPhotos() async {
    if (PhotoProvider.instance.list.isEmpty) {
      await PhotoProvider.instance.refreshGalleryList();
      print('LISTA: ${PhotoProvider.instance.list}');

      PhotoProvider.instance.getOrCreatePathProvider(PhotoProvider.instance.list[0]);
      await PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]].loadAllPics();
//      _checkTaggedPics();
      DatabaseManager.instance.sliderHasPics();
      setState(() {});
    } else {
      print('Already loaded');
    }

    DatabaseManager.instance.checkHasTaggedPhotos();
    DatabaseManager.instance.setCurrentTab(1, notify: false);
    _sendCurrentTabToAnalytics(DatabaseManager.instance.currentTab);
    changePage(1);
  }

  void afterBuild() {
    print('#### AFTER BUILD!');
    print('Trying to moe to page: ${DatabaseManager.instance.swiperIndex}');
//    swiperController.index = DatabaseManager.instance.swiperIndex();
//    swiperController.move(DatabaseManager.instance.swiperIndex(), animation: false);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild());
    AssetPathProvider pathProvider;
    if (PhotoProvider.instance.list.isNotEmpty) {
      print('refreshing');
      pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    }

    var screenWidth = MediaQuery.of(context).size.width;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    print('Bottom inset: $bottomInsets');

    return Stack(
      children: <Widget>[
        Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Stack(
              children: <Widget>[
                if (!Provider.of<DatabaseManager>(context).hasGalleryPermission)
                  Container(
                    constraints: BoxConstraints.expand(),
                    color: kWhiteColor,
                    child: SafeArea(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  onPressed: () {
                                    Navigator.pushNamed(context, SettingsScreen.id);
                                  },
                                  child: Image.asset('lib/images/settings.png'),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Image.asset('lib/images/nogalleryauth.png'),
                                ),
                                SizedBox(
                                  height: 21.0,
                                ),
                                Text(
                                  S.of(context).gallery_access_permission_description,
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xff979a9b),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                SizedBox(
                                  height: 17.0,
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    PhotoManager.openSetting();
                                  },
                                  child: Container(
                                    width: 201.0,
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      gradient: kPrimaryGradient,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        S.of(context).gallery_access_permission,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: kWhiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -0.4099999964237213,
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
                if (Provider.of<DatabaseManager>(context).currentTab == 0 && Provider.of<DatabaseManager>(context).hasGalleryPermission)
                  Container(
                    constraints: BoxConstraints.expand(),
                    color: kWhiteColor,
                    child: SafeArea(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  onPressed: () {
                                    Navigator.pushNamed(context, SettingsScreen.id);
                                  },
                                  child: Image.asset('lib/images/settings.png'),
                                ),
                              ],
                            ),
                          ),
                          if (pathProvider != null && pathProvider.isLoaded != null)
                            Positioned(
                              left: 16.0,
                              top: topOffsetFirstTab,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    S.of(context).photo_gallery_title,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff979a9b),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  if (!hideSubtitleFirstTab)
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                  if (!hideSubtitleFirstTab)
                                    Text(
                                      multiPicSelect
                                          ? S.of(context).photo_gallery_count(picsSelected.length)
                                          : S.of(context).photo_gallery_description,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Color(0xff606566),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          if (pathProvider != null && pathProvider.isLoaded != null)
                            Padding(
                              padding: isAdVisible && !DatabaseManager.instance.userSettings.isPremium
                                  ? const EdgeInsets.only(top: 48.0, bottom: 60.0)
                                  : const EdgeInsets.only(top: 48.0, bottom: 0.0),
                              child: GestureDetector(
//                              onScaleUpdate: (update) {
//                                print(update.scale);
//                                DatabaseManager.instance.gridScale(update.scale);
//                              },
                                child: _buildGridView(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (Provider.of<DatabaseManager>(context).currentTab == 1 && Provider.of<DatabaseManager>(context).hasGalleryPermission)
                  Container(
                    padding: isAdVisible && !DatabaseManager.instance.userSettings.isPremium
                        ? const EdgeInsets.only(bottom: 60.0)
                        : const EdgeInsets.only(bottom: 0.0),
                    constraints: BoxConstraints.expand(),
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                        image: AssetImage('lib/images/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('lib/images/picpicssmallred.png'),
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  onPressed: () {
                                    Navigator.pushNamed(context, SettingsScreen.id);
                                  },
                                  child: Image.asset('lib/images/settings.png'),
                                ),
                              ],
                            ),
                          ),
                          if (Provider.of<DatabaseManager>(context).sliderIndex == null)
                            Expanded(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                                ),
                              ),
                            ),
                          if (Provider.of<DatabaseManager>(context).sliderIndex != null)
                            Expanded(
                              child: CarouselSlider.builder(
                                itemCount: Provider.of<DatabaseManager>(context).sliderIndex.length,
                                carouselController: carouselController,
                                itemBuilder: (BuildContext context, int index) {
                                  print('calling index $index');
                                  return _buildPhotoSlider(context, index);
                                },
                                options: CarouselOptions(
                                  initialPage: DatabaseManager.instance.swiperIndex,
                                  enableInfiniteScroll: true,
                                  height: double.maxFinite,
                                  viewportFraction: 0.95,
                                  enlargeCenterPage: false,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  onPageChanged: (index, reason) async {
                                    DatabaseManager.instance.swiperIndex = index;
                                    picSwiper = index;
                                    print('picSwiper = $index');
                                  },
                                ),
                              ),
//                            Swiper(
//                              controller: swiperController,
//                              loop: true,
//                              index: DatabaseManager.instance.swiperIndex(),
//                              itemCount: pathProvider.orderedList.length, // count == 0 ? 1 : count,
//                              onIndexChanged: (index) async {
//                                DatabaseManager.instance.setSwiperIndex(index);
//                                picSwiper = index;
//                                print('picSwiper = $index');
//                                bool shouldShowAds = await DatabaseManager.instance.increaseTodayTaggedPics();
//                                if (shouldShowAds) {
//                                  showWatchAdModal(context);
//                                }
//                              },
//                              itemBuilder: (BuildContext context, int index) {
//                                print('calling index $index');
//                                return _buildPhotoSlider(context, index);
//                              },
//                              layout: SwiperLayout.DEFAULT,
//                              itemWidth: screenWidth,
//                              customLayoutOption:
//                                  CustomLayoutOption(startIndex: -1, stateCount: 3).addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate(
//                                [
//                                  Offset(-screenWidth - screenWidth / 2, -40.0),
//                                  Offset(0.0, 0.0),
//                                  Offset(screenWidth + screenWidth / 2, -40.0),
//                                ],
//                              ),
//                            ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (Provider.of<DatabaseManager>(context).currentTab == 2 && Provider.of<DatabaseManager>(context).hasGalleryPermission)
                  Container(
                    padding: isAdVisible && !DatabaseManager.instance.userSettings.isPremium
                        ? const EdgeInsets.only(bottom: 60.0)
                        : const EdgeInsets.only(bottom: 0.0),
//                    constraints: BoxConstraints.expand(),
//                    color: kWhiteColor,
                    child: SafeArea(
                      child: Stack(
                        children: <Widget>[
                          if (Provider.of<DatabaseManager>(context).noTaggedPhoto)
                            TopBar(
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset('lib/images/notaggedphotos.png'),
                                        SizedBox(
                                          height: 21.0,
                                        ),
                                        Text(
                                          S.of(context).no_tagged_photos,
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            color: Color(0xff979a9b),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 17.0,
                                        ),
                                        CupertinoButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => changePage(1),
                                          child: Container(
                                            width: 201.0,
                                            height: 44.0,
                                            decoration: BoxDecoration(
                                              gradient: kPrimaryGradient,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                S.of(context).start_tagging,
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  color: kWhiteColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                  letterSpacing: -0.4099999964237213,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (!Provider.of<DatabaseManager>(context).noTaggedPhoto)
                            TopBar(
                              searchEditingController: searchEditingController,
                              searchFocusNode: searchFocusNode,
                              children: <Widget>[
                                if (Provider.of<DatabaseManager>(context).searchingTags)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if (Provider.of<DatabaseManager>(context).searchActiveTags.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TagsList(
                                                tagsKeys: Provider.of<DatabaseManager>(context).searchActiveTags,
                                                tagStyle: TagStyle.MultiColored,
                                                onTap: (tagName) {
                                                  print('do nothing');
                                                },
                                                onDoubleTap: () {
                                                  DatabaseManager.instance.removeTagFromSearchFilter();
                                                  if (DatabaseManager.instance.searchActiveTags.isEmpty &&
                                                      searchFocusNode.hasFocus == false) {
                                                    DatabaseManager.instance.switchSearchingTags(false);
                                                  }
                                                },
                                                showEditTagModal: showEditTagModal,
                                              ),
                                              CupertinoButton(
                                                padding: const EdgeInsets.all(10),
                                                onPressed: () async {
                                                  print('share pics');
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await DatabaseManager.instance
                                                      .sharePics(photoIds: DatabaseManager.instance.searchPhotosIds);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                child: Image.asset('lib/images/sharepicsico.png'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (Provider.of<DatabaseManager>(context).searchResults != null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Text(
                                            S.of(context).search_results,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              color: Color(0xff979a9b),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: -0.4099999964237213,
                                            ),
                                          ),
                                        ),
                                      if (Provider.of<DatabaseManager>(context).searchResults != null)
                                        if (Provider.of<DatabaseManager>(context).searchResults.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8.0, bottom: 16.0),
                                            child: TagsList(
                                              tagsKeys: Provider.of<DatabaseManager>(context).searchResults,
                                              tagStyle: TagStyle.GrayOutlined,
                                              showEditTagModal: showEditTagModal,
                                              onTap: (tagName) {
                                                DatabaseManager.instance.addTagToSearchFilter();
                                              },
                                              onDoubleTap: () {
                                                print('do nothing');
                                              },
                                            ),
                                          ),
                                      if (Provider.of<DatabaseManager>(context).searchResults != null)
                                        if (Provider.of<DatabaseManager>(context).searchResults.isEmpty)
                                          Container(
                                            padding: const EdgeInsets.only(top: 10.0, left: 26.0, bottom: 10.0),
                                            child: Text(
                                              S.of(context).no_tags_found,
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                color: Color(0xff979a9b),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                letterSpacing: -0.4099999964237213,
                                              ),
                                            ),
                                          ),
                                      Container(
                                        height: 1,
                                        color: kLightGrayColor,
                                      ),
                                    ],
                                  ),
                                if (!Provider.of<DatabaseManager>(context).noTaggedPhoto)
                                  Expanded(
                                    child: _buildTaggedGridView(),
                                  ),
                              ],
                            ),
                          if (!Provider.of<DatabaseManager>(context).noTaggedPhoto &&
                              !hideTitleThirdTab &&
                              !Provider.of<DatabaseManager>(context).searchingTags)
                            Positioned(
                              left: 19.0,
                              top: topOffsetThirdTab,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    S.of(context).organized_photos_title,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff979a9b),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  if (!hideSubtitleThirdTab)
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                  if (!hideSubtitleThirdTab)
                                    Text(
                                      S.of(context).organized_photos_description,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Color(0xff606566),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: showingMultiTagSheet
              ? ExpandableNotifier(
                  child: Container(
                    color: Color(0xF1F3F5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              expandableController.expanded = !expandableController.expanded;
                            });
                          },
                          child: SafeArea(
                            bottom: !expandableController.expanded,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CupertinoButton(
                                  onPressed: () {
                                    setState(() {
                                      showingMultiTagSheet = false;
                                    });
                                  },
                                  child: Container(
                                    width: 80.0,
                                    child: Text(
                                      S.of(multiPicContext).cancel,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        color: Color(0xff707070),
                                        fontSize: 16,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                CupertinoButton(
                                  onPressed: () {
                                    if (!DatabaseManager.instance.userSettings.isPremium) {
                                      Navigator.pushNamed(context, PremiumScreen.id);
                                      return;
                                    }

                                    List<String> photosIds = [];
                                    List<AssetEntity> entities = [];
                                    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
                                    for (var index in picsSelected) {
                                      AssetEntity entity = pathProvider.orderedList[index];
                                      photosIds.add(entity.id);
                                      entities.add(entity);
                                    }
                                    DatabaseManager.instance.addTagsToPics(
                                      tagsKeys: multiPicTagKeys,
                                      photosIds: photosIds,
                                      entities: entities,
                                    );

                                    setState(() {
                                      showingMultiTagSheet = false;
                                      multiPicSelect = false;
                                    });

                                    picsSelected = [];
                                    multiPicTagKeys = [];
                                  },
                                  child: Container(
                                    width: 80.0,
                                    child: Text(
                                      S.of(multiPicContext).ok,
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: Color(0xff707070),
                                        fontSize: 16,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expandable(
                          controller: expandableController,
                          expanded: Container(
                            padding: const EdgeInsets.all(24.0),
                            color: Color(0xFFEFEFF4).withOpacity(0.94),
                            child: SafeArea(
                              bottom: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TagsList(
                                      tagsKeys: multiPicTagKeys, //picInfo.tags,
                                      addTagField: true,
                                      textEditingController: bottomTagsEditingController,
                                      showEditTagModal: showEditTagModal,
                                      onTap: (tagName) {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }
                                        print('do nothing');
                                      },
                                      onDoubleTap: () {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        if (multiPicTagKeys.contains(DatabaseManager.instance.selectedTagKey)) {
                                          setState(() {
                                            multiPicTagKeys.remove(DatabaseManager.instance.selectedTagKey);
                                          });
                                          DatabaseManager.instance.tagsSuggestions(
                                            bottomTagsEditingController.text,
                                            'MULTIPIC',
                                            excludeTags: multiPicTagKeys,
                                          );
                                        }
                                      },
                                      onChanged: (text) {
                                        print('calling tag suggestions');
                                        DatabaseManager.instance.tagsSuggestions(
                                          text,
                                          'MULTIPIC',
                                          excludeTags: multiPicTagKeys,
                                        );
                                      },
                                      onSubmitted: (text) {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        print('return');
                                        if (text != '') {
                                          bottomTagsEditingController.clear();
                                          String tagKey = DatabaseManager.instance.encryptTag(text);
                                          if (!multiPicTagKeys.contains(tagKey)) {
                                            if (DatabaseManager.instance.getTagName(tagKey) == null) {
                                              print('tag does not exist! creating it!');
                                              DatabaseManager.instance.createTag(text);
                                            }
                                            multiPicTagKeys.add(tagKey);
                                            DatabaseManager.instance.tagsSuggestions(
                                              '',
                                              'MULTIPIC',
                                              excludeTags: multiPicTagKeys,
                                            );
                                          }
                                        }
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TagsList(
                                      title: S.of(context).suggestions,
                                      tagsKeys: DatabaseManager.instance.suggestionTags['MULTIPIC'],
                                      tagStyle: TagStyle.GrayOutlined,
                                      showEditTagModal: showEditTagModal,
                                      onTap: (tagName) {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        bottomTagsEditingController.clear();
                                        String tagKey = DatabaseManager.instance.encryptTag(tagName);
                                        if (!multiPicTagKeys.contains(tagKey)) {
                                          multiPicTagKeys.add(tagKey);
                                          DatabaseManager.instance.tagsSuggestions(
                                            '',
                                            'MULTIPIC',
                                            excludeTags: multiPicTagKeys,
                                          );
                                        }
                                      },
                                      onDoubleTap: () {
                                        if (!DatabaseManager.instance.userSettings.isPremium) {
                                          Navigator.pushNamed(context, PremiumScreen.id);
                                          return;
                                        }

                                        print('do nothing');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expandable(
                          controller: expandablePaddingController,
                          expanded: Container(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  constraints: BoxConstraints(
                    maxHeight: 100.0,
                  ),
                  child: BubbleBottomBar(
                    backgroundColor: kWhiteColor,
                    hasNotch: true,
                    opacity: 1.0,
                    currentIndex: Provider.of<DatabaseManager>(context).currentTab,
                    onTap: changePage,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    elevation: 8,
                    items: multiPicSelect
                        ? <BubbleBottomBarItem>[
                            BubbleBottomBarItem(
                              backgroundColor: kWhiteColor,
                              icon: Image.asset('lib/images/cancelbarbutton.png'),
                            ),
                            BubbleBottomBarItem(
                              backgroundColor: kWhiteColor,
                              icon: Image.asset('lib/images/picbarbutton.png'),
                            ),
                            BubbleBottomBarItem(
                              backgroundColor: kWhiteColor,
                              icon: Image.asset('lib/images/trashbarbutton.png'),
                            )
                          ]
                        : <BubbleBottomBarItem>[
                            BubbleBottomBarItem(
                              backgroundColor: kPinkColor,
                              icon: Image.asset('lib/images/tabgridred.png'),
                              activeIcon: Image.asset('lib/images/tabgridwhite.png'),
                            ),
                            BubbleBottomBarItem(
                              backgroundColor: kSecondaryColor,
                              icon: Image.asset('lib/images/tabpicpicsred.png'),
                              activeIcon: Image.asset('lib/images/tabpicpicswhite.png'),
                            ),
                            BubbleBottomBarItem(
                              backgroundColor: kPrimaryColor,
                              icon: Image.asset('lib/images/tabtaggedblue.png'),
                              activeIcon: Image.asset('lib/images/tabtaggedwhite.png'),
                            )
                          ],
                  ),
                ),
        ),
        if (modalPhotoCard)
          Material(
            color: Colors.transparent,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  dismissPhotoCard();
                },
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: () {
                        print('ignore');
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: bottomInsets > 0 ? bottomInsets + 5 : 52,
                          top: bottomInsets > 0 ? 5 : 46.0,
                        ),
                        child: PhotoCard(
                          data: selectedPhotoData,
                          photoId: selectedPhotoPicInfo.photoId,
                          picSwiper: -1,
                          index: selectedPhotoIndex,
                          tagsEditingController: tagsEditingController,
                          specificLocation: selectedPhotoPicInfo.specificLocation,
                          generalLocation: selectedPhotoPicInfo.generalLocation,
                          showEditTagModal: showEditTagModal,
                          onPressedTrash: () {
                            trashPic(selectedPhotoData);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (isLoading)
          Material(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Loading(indicator: BallPulseIndicator(), size: 100.0),
            ),
          ),
        if (Provider.of<DatabaseManager>(context).userSettings.tutorialCompleted == false)
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
        if (Provider.of<DatabaseManager>(context).userSettings.tutorialCompleted == false)
          Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                height: 609.0,
                width: 343.0,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        S.of(context).welcome,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff979a9b),
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.4099999964237213,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Expanded(
                        child: new Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            String text = '';
                            Image image;

                            if (index == 0) {
                              text = S.of(context).tutorial_daily_package;
                              image = Image.asset('lib/images/tutorialfirstimage.png');
                            } else if (index == 1) {
                              text = S.of(context).tutorial_however_you_want;
                              image = Image.asset('lib/images/tutorialsecondimage.png');
                            } else {
                              text = S.of(context).tutorial_just_swipe;
                              image = Image.asset('lib/images/tutorialthirdimage.png');
                            }

                            return Column(
                              children: <Widget>[
                                image,
                                SizedBox(
                                  height: 28.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    text,
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xff707070),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: 3,
                          controller: tutorialSwiperController,
                          onIndexChanged: (index) {
                            if (index == 1) {
                              print('Requesting notification....');

                              if (Platform.isAndroid) {
                                var userBox = Hive.box('user');
                                DatabaseManager.instance.userSettings.notifications = true;
                                DatabaseManager.instance.userSettings.dailyChallenges = true;
                                userBox.putAt(0, DatabaseManager.instance.userSettings);
                              } else {
                                PushNotificationsManager push = PushNotificationsManager();
                                push.init();
                              }
                            } else if (index == 2) {
                              DatabaseManager.instance.checkNotificationPermission(firstPermissionCheck: true);
                            }

                            setState(() {
                              swiperIndex = index;
                            });
                          },
                          pagination: new SwiperCustomPagination(
                            builder: (BuildContext context, SwiperPluginConfig config) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 8.0,
                                      width: 8.0,
                                      decoration: BoxDecoration(
                                        color: config.activeIndex == 0 ? kSecondaryColor : kGrayColor,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    Container(
                                      height: 8.0,
                                      width: 8.0,
                                      margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                                      decoration: BoxDecoration(
                                        color: config.activeIndex == 1 ? kSecondaryColor : kGrayColor,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    Container(
                                      height: 8.0,
                                      width: 8.0,
                                      decoration: BoxDecoration(
                                        color: config.activeIndex == 2 ? kSecondaryColor : kGrayColor,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 17.0,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          if (swiperIndex == 2) {
                            DatabaseManager.instance.finishedTutorial();
                            return;
                          }
                          tutorialSwiperController.next(animation: true);
                        },
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 44.0,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              swiperIndex == 2 ? S.of(context).close : S.of(context).next,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: kWhiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
