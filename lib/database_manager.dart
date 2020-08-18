import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/asset_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:picPics/push_notifications_manager.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/utils/languages.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:encrypt/encrypt.dart' as E;
import 'package:diacritic/diacritic.dart';
import 'package:date_utils/date_utils.dart';
import 'package:share_extend/share_extend.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class DatabaseManager extends ChangeNotifier {
  DatabaseManager._();

  static DatabaseManager _instance;

  static DatabaseManager get instance {
    return _instance ??= DatabaseManager._();
  }

  static const maxNumOfSuggestions = 6;
  static const maxNumOfRecentTags = 5;

  int swiperIndex = 0;
  int dailyPicsForAds = 50;

  List<bool> picHasTag;
  List<int> sliderIndex;

  bool noTaggedPhoto = false;
//  bool editingTags = false;
  bool searchingTags = false;

  List<String> searchActiveTags = [];
  List<String> searchResults;
  List<String> searchPhotosIds = [];

  List<String> slideThumbPhotoIds = [];

//  AssetProvider assetProvider = AssetProvider();
  AssetEntity selectedPhoto;
  List<double> lastLocationRequest = [0.0, 0.0];

  String currentPhotoCity;
  String currentPhotoState;

  List<String> suggestionTags = [];

  double scale = 1.0;

  String addingTagId = '';
  int addingTagIndex = 0;
  String selectedTagKey;

  User userSettings;

  int currentTab = 1;

  double adOffset = 48.0;

  AssetEntity selectedPhotoData;
  Pic selectedPhotoPicInfo;
  int selectedPhotoIndex;

  // For multipic work
  bool multiPicBar = false;
  Set<String> picsSelected = Set();
  List<String> multiPicTagKeys = [];

  bool adsIsLoaded = false;
  bool showShowAdAfterReload = false;

  bool appStartInPremium = false;
  String trybuyId;

  void setPicsSelected(Set<String> pics) {
    picsSelected = pics;
    notifyListeners();
  }

  void setMultiPicTagKeys(List<String> pics) {
    multiPicTagKeys = pics;
    notifyListeners();
  }

  void setMultiPicBar(bool enabled) {
    if (enabled) {
      Analytics.sendEvent(Event.selected_photos);
    }
    multiPicBar = enabled;
    notifyListeners();
  }

//  Pic selectedPic;
  void requestNotification() {
    var userBox = Hive.box('user');
    print('requesting notification...');
    print('dailyChallenges: ${userSettings.dailyChallenges}');

    if (Platform.isIOS) {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
//      _firebaseMessaging.getToken().then((String token) {
//        assert(token != null);
//        print('got token this mean it did accept notification');
//        userSettings.notifications = true;
//        userSettings.dailyChallenges = true;
//        userBox.putAt(0, userSettings);
//      });
//
//      _firebaseMessaging.onIosSettingsRegistered.
    } else {
      print('its android!!!');
      userSettings.notifications = true;
      userSettings.dailyChallenges = true;
      userBox.putAt(0, userSettings);
    }
  }

  bool canTagToday() {
    var userBox = Hive.box('user');
    User getUser = userBox.getAt(0);
    print('User can tag today: ${getUser.canTagToday}');
    if (getUser.isPremium) {
      return true;
    }
    return getUser.canTagToday ?? true;
  }

  void setCanTagToday(bool canTag) {
    var userBox = Hive.box('user');
    User getUser = userBox.getAt(0);
    getUser.canTagToday = canTag;
    userBox.putAt(0, getUser);
    print('Setting user can tag today to: $canTag');
  }

  String getTagName(String tagKey) {
    var tagsBox = Hive.box('tags');
    Tag getTag = tagsBox.get(tagKey);

    // Verificar isso aqui pois tem a ver com as sugestões!!!!
    print('TagKey: $tagKey');

    if (getTag != null) {
      print('Returning name');
      return getTag.name;
    } else {
      print('### ERROR ### Returning key');
      return null;
    }
  }

  void checkHasTaggedPhotos() {
    var picsBox = Hive.box('pics');

    noTaggedPhoto = true;
    for (Pic pic in picsBox.values) {
      if (pic.tags.length > 0) {
        noTaggedPhoto = false;
        break;
      }
    }
  }

  void saveLocationToPic({double lat, double long, String specifLocation, String generalLocation, String photoId, bool notify = true}) {
    var picsBox = Hive.box('pics');

    Pic getPic = picsBox.get(photoId);

    if (getPic != null) {
      print('found pic');

      getPic.latitude = lat;
      getPic.longitude = long;
      getPic.specificLocation = specifLocation;
      getPic.generalLocation = generalLocation;

      picsBox.put(photoId, getPic);
      print('updated pic with new values');
    }

    if (notify) {
      notifyListeners();
    }
  }

  void deletedPic(AssetEntity entity, {bool removeFromDb = true}) {
    var picsBox = Hive.box('pics');
    var tagsBox = Hive.box('tags');

    Pic getPic = picsBox.get(entity.id);
    if (getPic != null && removeFromDb == true) {
      print('found pic');

      for (var tag in getPic.tags) {
        String tagKey = stripTag(tag);

        Tag getTag = tagsBox.get(tagKey);
        getTag.photoId.remove(entity.id);
        print('removed ${entity.id} from $tag');
        tagsBox.put(tagKey, getTag);
      }
      print('removed ${entity.id} from database');
      picsBox.delete(entity.id);
    }

    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    int indexInOrderedList = pathProvider.orderedList.indexOf(entity);

    if (indexInOrderedList != null) {
      pathProvider.orderedList.remove(entity);

      // Supondo que pic está nas não taggeadas
      reorderSliderIndex(indexInOrderedList);
      picHasTag.removeAt(indexInOrderedList);
      print('Removed pic in ordered list number $indexInOrderedList');
    }

    Analytics.sendEvent(Event.deleted_photo);
    notifyListeners();
  }

  void reorderSliderIndex(int removeIndex) {
    int indexOfValue = sliderIndex.indexOf(removeIndex);

    List<int> newSliderIndex = [];
    for (int x = 0; x < sliderIndex.length; x++) {
      if (x < indexOfValue) {
        newSliderIndex.add(sliderIndex[x]);
      } else if (x == indexOfValue) {
        print('Skipping value ${sliderIndex[x]}');
      } else {
        newSliderIndex.add(sliderIndex[x - 1]);
      }
    }

    sliderIndex = newSliderIndex;
  }

  void checkPicHasTags(String photoId) {
    print('Checking photoId $photoId has tags...');
    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
//    int itemCount = pathProvider.isLoaded ? pathProvider.orderedList.length : 0;

    Pic getPic = getPicInfo(photoId);
    int indexOfOrderedList = pathProvider.orderedList.indexWhere((element) => element.id == photoId);

    if (indexOfOrderedList == null) {
      print('### ERROR DID NOT FIND INDEX IN ORDERED LIST');
      return;
    }

    if (getPic.tags.length > 0) {
      print('pic has tags!!!');
      picHasTag[indexOfOrderedList] = true;
    } else {
      print('pic has no tags!!!');
      picHasTag[indexOfOrderedList] = false;
    }
  }

  void resetSlider() {
    swiperIndex = 0;
    sliderIndex = null;
    picHasTag = null;
    notifyListeners();
  }

  void sliderHasPics() {
//    GalleryStore galleryStore = Provider.of<GalleryStore>(context, listen: false);

    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
    int itemCount = pathProvider.isLoaded ? pathProvider.orderedList.length : 0;

    if (itemCount > 0) {
      sliderIndex = [];
      picHasTag = [];
      for (int x = 0; x < pathProvider.orderedList.length; x++) {
        var item = pathProvider.orderedList[x];
        Pic pic = DatabaseManager.instance.getPicInfo(item.id);
        if (pic != null) {
          if (pic.tags.length > 0) {
            picHasTag.add(true);
            continue;
          }
        }
        picHasTag.add(false);
        sliderIndex.add(x);
      }
    }

    print('## Total Item Count: $itemCount');
    print('## Slider Count: ${sliderIndex.length}');
    notifyListeners();
  }

  void setCurrentTab(int tab, {bool notify = true}) {
    currentTab = tab;
    if (notify) {
      notifyListeners();
    }
  }

  void finishedTutorial() {
    var userBox = Hive.box('user');
    userSettings.tutorialCompleted = true;
    userBox.putAt(0, userSettings);
    notifyListeners();
  }

  void checkPremiumStatus() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      if (purchaserInfo.entitlements.all["Premium"].isActive) {
        // Grant user "pro" access
        print('you are still premium');
      } else {
        print('not premium anymore');
        setUserAsNotPremium();
      }

      // access latest purchaserInfo
    } on PlatformException catch (e) {
      // Error fetching purchaser info
    }
  }

  void increaseTodayTaggedPics() async {
    var userBox = Hive.box('user');

    User userInfo = userBox.getAt(0);

    DateTime lastTaggedPicDate = userInfo.lastTaggedPicDate;
    DateTime dateNow = DateTime.now();

    if (lastTaggedPicDate == null) {
      print('date is null....');
      userInfo.picsTaggedToday = 1;
      userInfo.lastTaggedPicDate = dateNow;
    } else if (Utils.isSameDay(lastTaggedPicDate, dateNow)) {
      userInfo.picsTaggedToday += 1;
      userInfo.lastTaggedPicDate = dateNow;
      print('same day... increasing number of tagged photos today, now it is: ${userInfo.picsTaggedToday}');

      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      dailyPicsForAds = remoteConfig.getInt('daily_pics_for_ads');
      int mod = userInfo.picsTaggedToday % dailyPicsForAds;

      if (mod == 0) {
        print('### CALL ADS!!!');
        setCanTagToday(false);
        return;
      }
    } else {
      print('not same day... resetting counter....');
      userInfo.picsTaggedToday = 1;
      userInfo.lastTaggedPicDate = dateNow;
    }
    userBox.putAt(0, userInfo);
    setCanTagToday(true);
  }

  void setUserAsPremium() {
    var userBox = Hive.box('user');
    userSettings.isPremium = true;
    userBox.putAt(0, userSettings);
    notifyListeners();
  }

  void setUserAsNotPremium() {
    var userBox = Hive.box('user');
    userSettings.isPremium = false;
    userBox.putAt(0, userSettings);
    notifyListeners();
  }

  void loadRemoteConfig() async {
    print('loading remote config....');
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    remoteConfig.setDefaults(<String, dynamic>{
      'daily_pics_for_ads': 50,
    });

    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    print('daily_pics_for_ads: ${remoteConfig.getInt('daily_pics_for_ads')}');
  }

  void loadUserSettings() async {
    var userBox = Hive.box('user');
    User getUser = await userBox.getAt(0);
    userSettings = getUser;
  }

  void changeUserLanguage(String appLanguage, {bool notify = true}) {
    var userBox = Hive.box('user');
    userSettings.appLanguage = appLanguage;
    userBox.putAt(0, userSettings);

    if (notify = true) {
      Analytics.sendEvent(Event.changed_language);
      notifyListeners();
    }
  }

  String getUserLanguage() {
    String appLanguage = userSettings.appLanguage.split('_')[0];
    var language = LanguageLocal();
    return '${language.getDisplayLanguage(appLanguage)['nativeName']}';
  }

  void changeUserGoal(int goal) {
    var userBox = Hive.box('user');
    userSettings.goal = goal;
    userBox.putAt(0, userSettings);
    notifyListeners();
  }

  void tagsSuggestions(String text, String photoId, {List<String> excludeTags, bool notify = true}) {
    var userBox = Hive.box('user');
    var tagsBox = Hive.box('tags');
    User getUser = userBox.getAt(0);

    suggestionTags.clear();

    if (excludeTags == null) {
      excludeTags = [];
    }

    if (text == '') {
      for (var recent in getUser.recentTags) {
        if (excludeTags.contains(recent)) {
          continue;
        }
        suggestionTags.add(recent);
      }

      print('Sugestion Length: ${suggestionTags.length} - Num of Suggestions: $maxNumOfSuggestions');

//      while (suggestions.length < maxNumOfSuggestions) {
//          if (excludeTags.contains('Hey}')) {
//            continue;
//          }
      if (suggestionTags.length < maxNumOfSuggestions) {
        for (var tagKey in tagsBox.keys) {
          if (suggestionTags.length == maxNumOfSuggestions) {
            break;
          }
          if (excludeTags.contains(tagKey) || suggestionTags.contains(tagKey)) {
            continue;
          }
          suggestionTags.add(tagKey);
        }
      }
//      }
    } else {
      for (var tagKey in tagsBox.keys) {
        String tagName = decryptTag(tagKey);
        if (tagName.startsWith(stripTag(text))) {
          suggestionTags.add(tagKey);
        }
      }
    }
    print('find suggestions: $text - exclude: $excludeTags');
    print(suggestionTags);

    if (notify) {
      notifyListeners();
    }
  }

  void addTagToSearchFilter() {
    if (searchActiveTags.contains(selectedTagKey)) {
      return;
    }
    searchActiveTags.add(selectedTagKey);
    print('search tags: $searchActiveTags');
    searchPicsWithTags();
  }

  void removeTagFromSearchFilter() {
    if (searchActiveTags.contains(selectedTagKey)) {
      searchActiveTags.remove(selectedTagKey);
      print('search tags: $searchActiveTags');
      searchPicsWithTags();
    }
  }

  void searchPicsWithTags() {
    var tagsBox = Hive.box('tags');

    searchPhotosIds.clear();
    List<String> tempPhotosIds = [];
    bool firstInteraction = true;

    for (var tagKey in searchActiveTags) {
      print('filtering tag: $tagKey');
      Tag getTag = tagsBox.get(tagKey);
      List<String> photosIds = getTag.photoId;
      print('photos Ids in this tag: $photosIds');

      if (firstInteraction) {
        print('adding all photos because it is firt interaction');
        tempPhotosIds.addAll(photosIds);
        firstInteraction = false;
      } else {
        print('tempPhotoId: $tempPhotosIds');
        List<String> auxArray = [];
        auxArray.addAll(tempPhotosIds);

        for (var photoId in tempPhotosIds) {
          print('checking if photoId is there: $photoId');
          if (!photosIds.contains(photoId)) {
            auxArray.remove(photoId);
            print('removing $photoId because doesnt have $tagKey');
          }
        }
        tempPhotosIds = auxArray;
      }
    }
    searchPhotosIds = tempPhotosIds;
    slideThumbPhotoIds = tempPhotosIds;
    print('Search Photos Ids: $searchPhotosIds');

    Analytics.sendEvent(Event.searched_photos);
    notifyListeners();
  }

  void searchResultsTags(String text) {
    var tagsBox = Hive.box('tags');

    if (text == '') {
      searchResults = null;
      notifyListeners();
      return;
    }

    searchResults = [];

    for (var tagKey in tagsBox.keys) {
      String tagName = decryptTag(tagKey);
      if (tagName.startsWith(stripTag(text))) {
        searchResults.add(tagKey);
      }
    }

    notifyListeners();
  }

  void switchSearchingTags(bool searching) {
    searchingTags = searching;
    notifyListeners();
  }

  void gridScale(double multiplier) {
    scale = scale;
    print('new scale value: $scale');
//    notifyListeners();
  }

  Pic getPicInfo(String photoId) {
//    print('loading pic info from: $photoId');
    var picsBox = Hive.box('pics');

    if (picsBox.containsKey(photoId)) {
//      print('found pic!!!');
      Pic getPic = picsBox.get(photoId);
//      print('@@@ Lat: ${getPic.latitude} - Long ${getPic.longitude} - PhotoId: $photoId');
      return getPic;
    }
//    print('did not found pic!!!');

    return null;
  }

  void removeTagFromPic({String tagKey, String photoId}) {
    print('removing tag: $tagKey from pic $photoId');
    var tagsBox = Hive.box('tags');
    var picsBox = Hive.box('pics');

    Tag getTag = tagsBox.get(tagKey);

    int indexOfPicInTag = getTag.photoId.indexOf(photoId);
    if (indexOfPicInTag != null) {
      getTag.photoId.removeAt(indexOfPicInTag);
      tagsBox.put(tagKey, getTag);
      print('removed pic from tag');
    }

    Pic getPic = picsBox.get(photoId);

    int indexOfTagInPic = getPic.tags.indexOf(tagKey);
    if (indexOfTagInPic != null) {
      getPic.tags.removeAt(indexOfTagInPic);
      picsBox.put(photoId, getPic);
      print('removed tag from pic');
      checkPicHasTags(photoId);

      if (getPic.tags.length == 0) {
        print('pic has no tags anymore!!!!');
      }
    }
    checkHasTaggedPhotos();
    Analytics.sendEvent(Event.removed_tag);
    notifyListeners();
  }

  void deleteTag({String tagKey}) {
    var tagsBox = Hive.box('tags');
    var picsBox = Hive.box('pics');
    var userBox = Hive.box('user');

    if (tagsBox.containsKey(tagKey)) {
      print('found tag going to delete it');

      Tag getTag = tagsBox.get(tagKey);

      for (String photoId in getTag.photoId) {
        Pic pic = picsBox.get(photoId);
        int indexOfTagInPic = pic.tags.indexOf(tagKey);
        print('getting pic: $photoId');

        if (indexOfTagInPic != null) {
          pic.tags.removeAt(indexOfTagInPic);
          picsBox.put(photoId, pic);
          print('removed tag from pic');
          checkPicHasTags(photoId);
        }
      }

      User getUser = userBox.getAt(0);
      if (getUser.recentTags.contains(tagKey)) {
        print('recent tags: ${getUser.recentTags}');
        print('removing from recent tags');
        getUser.recentTags.remove(tagKey);
        userBox.putAt(0, getUser);
        print('recent tags after removed: ${getUser.recentTags}');
      }

      tagsBox.delete(tagKey);
      checkHasTaggedPhotos();
      print('deleted from tags db');
      Analytics.sendEvent(Event.deleted_tag);
      notifyListeners();
    }
  }

  void editTag({String oldTagKey, String newName}) {
    var tagsBox = Hive.box('tags');
    var picsBox = Hive.box('pics');
    var userBox = Hive.box('user');

    String newTagKey = encryptTag(newName);

    if (tagsBox.containsKey(oldTagKey)) {
      print('found tag with this name');

      Tag getTag = tagsBox.get(oldTagKey);

      Tag newTag = Tag(newName, getTag.photoId);
      tagsBox.put(newTagKey, newTag);
      tagsBox.delete(oldTagKey);

      print('updated tag');

      for (String photoId in newTag.photoId) {
        Pic pic = picsBox.get(photoId);

        int indexOfOldTag = pic.tags.indexOf(oldTagKey);
        print('Tags in this picture: ${pic.tags}');
        pic.tags[indexOfOldTag] = newTagKey;
        picsBox.put(photoId, pic);
        print('updated tag in pic ${pic.photoId}');
      }

      User getUser = userBox.getAt(0);
      if (getUser.recentTags.contains(oldTagKey)) {
        print('updating tag name in recent tags');
        int indexOfRecentTag = getUser.recentTags.indexOf(oldTagKey);
        getUser.recentTags[indexOfRecentTag] = newTagKey;
        userBox.putAt(0, getUser);
      }

      print('updating in all suggestions');
      if (suggestionTags.contains(oldTagKey)) {
        int indexOfSuggestionTag = suggestionTags.indexOf(oldTagKey);
        suggestionTags[indexOfSuggestionTag] = newTagKey;
      }

      if (searchResults.isNotEmpty) {
        print('fixing in search result');
        if (searchResults.contains(oldTagKey)) {
          int indexOfSearchResultTag = searchResults.indexOf(oldTagKey);
          searchResults[indexOfSearchResultTag] = newTagKey;
        }
      }

      if (searchActiveTags.isNotEmpty) {
        print('fixing in search active tags');
        if (searchActiveTags.contains(oldTagKey)) {
          int indexOfSearchActiveTags = searchActiveTags.indexOf(oldTagKey);
          searchActiveTags[indexOfSearchActiveTags] = newTagKey;
        }
      }

      print('finished updating all tags');
      Analytics.sendEvent(Event.edited_tag);
      notifyListeners();
    }
  }

  void setUserHasSwiped() {
    var userBox = Hive.box('user');
    userSettings.hasSwiped = true;
    userBox.putAt(0, userSettings);
    notifyListeners();
  }

  void addTagToRecent({String tagKey}) {
    print('adding tag to recent: $tagKey');

    var userBox = Hive.box('user');
    User getUser = userBox.getAt(0);

    if (getUser.recentTags.contains(tagKey)) {
      getUser.recentTags.remove(tagKey);
      getUser.recentTags.insert(0, tagKey);
      userBox.putAt(0, getUser);
      return;
    }

    if (getUser.recentTags.length >= maxNumOfRecentTags) {
      print('removing last');
      getUser.recentTags.removeLast();
    }

    getUser.recentTags.insert(0, tagKey);
    userBox.putAt(0, getUser);
    print('final tags in recent: ${getUser.recentTags}');
  }

  Future<void> addTagToPic({String tagKey, String photoId, List<AssetEntity> entities}) async {
    var picsBox = Hive.box('pics');

    if (picsBox.containsKey(photoId)) {
      print('this picture is in db going to update');

      Pic getPic = picsBox.get(photoId);

      if (getPic.tags.contains(tagKey)) {
        print('this tag is already in this picture');
        return;
      }

      if (noTaggedPhoto == true) {
        noTaggedPhoto = false;
      }

      getPic.tags.add(tagKey);
      print('photoId: ${getPic.photoId} - tags: ${getPic.tags}');
      picsBox.put(photoId, getPic);
      print('updated picture');

      checkPicHasTags(photoId);
      Analytics.sendEvent(Event.added_tag);
      return;
    }

    print('this picture is not in db, adding it...');
    print('Photo Id: $photoId');

    Pic pic;

    if (selectedPhoto != null) {
      print('Pic Info Localization: ${selectedPhoto.latitude} - ${selectedPhoto.longitude} - ${selectedPhoto.createDateTime}');

      pic = Pic(
        photoId,
        selectedPhoto.createDateTime,
        selectedPhoto.latitude,
        selectedPhoto.longitude,
        null,
        null,
        null,
        null,
        [tagKey],
      );
    } else {
      AssetEntity entity = entities.firstWhere((element) => element.id == photoId, orElse: () => null);
      if (entity == null) {
        pic = Pic(
          photoId,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          [tagKey],
        );
      } else {
        pic = Pic(
          photoId,
          entity.createDateTime,
          entity.latitude,
          entity.longitude,
          null,
          null,
          null,
          null,
          [tagKey],
        );
      }
    }
    await picsBox.put(photoId, pic);
    print('@@@@@@@@ tagsKey: ${tagKey}');
    checkPicHasTags(photoId);
    if (noTaggedPhoto == true) {
      noTaggedPhoto = false;
    }

    // Increase today tagged pics everytime it adds a new pic to database.
    DatabaseManager.instance.increaseTodayTaggedPics();
    Analytics.sendEvent(Event.added_tag);
  }

  Future<String> _writeByteToImageFile(Uint8List byteData) async {
    Directory tempDir = await getTemporaryDirectory();
    File imageFile = new File('${tempDir.path}/picpics/${DateTime.now().millisecondsSinceEpoch}.jpg');
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData);
    return imageFile.path;
  }

  Future<void> sharePic(AssetEntity data) async {
    if (data == null) {
      return;
    }

    String path = '';
    if (Platform.isAndroid) {
      path = await _writeByteToImageFile(await data.originBytes);
    } else {
      var bytes = await data.thumbDataWithSize(
        data.size.width.toInt(),
        data.size.height.toInt(),
        format: ThumbFormat.jpeg,
      );
      path = await _writeByteToImageFile(bytes);
    }

    if (path == '' || path == null) {
      return;
    }

    Analytics.sendEvent(Event.shared_photo);
    ShareExtend.share(path, "image");
  }

  Future<void> sharePics({List<String> photoIds}) async {
    AssetPathProvider pathProvider = PhotoProvider.instance.pathProviderMap[PhotoProvider.instance.list[0]];
//    Map<String, dynamic> bytesPhotos = {};
//    int x = 0;

    var imageList = List<String>();

    for (var photoId in photoIds) {
      AssetEntity data = pathProvider.orderedList.firstWhere((element) => element.id == photoId, orElse: () => null);

      if (data == null) {
        continue;
      }

      if (Platform.isAndroid) {
        String path = await _writeByteToImageFile(await data.originBytes);
        imageList.add(path);
      } else {
        var bytes = await data.thumbDataWithSize(
          data.size.width.toInt(),
          data.size.height.toInt(),
          format: ThumbFormat.jpeg,
        );
        String path = await _writeByteToImageFile(bytes);
        imageList.add(path);
      }

//      if (Platform.isAndroid) {
//        var bytes = await data.originBytes;
//        bytesPhotos['$x.jpg'] = bytes;
//      } else {
//        var bytes = await data.thumbDataWithSize(
//          data.size.width.toInt(),
//          data.size.height.toInt(),
//          format: ThumbFormat.jpeg,
//        );
//        bytesPhotos['$x.jpg'] = bytes;
//      }
//      x++;
    }

    Analytics.sendEvent(Event.shared_photos);
    ShareExtend.shareMultiple(
      imageList,
      "image",
    );

    if (DatabaseManager.instance.multiPicBar) {
      DatabaseManager.instance.setPicsSelected(Set());
      DatabaseManager.instance.setMultiPicBar(false);
    }

    //    await Share.files(
//      'images',
//      {
//        ...bytesPhotos,
//      },
//      'image/jpeg',
//    );

    return;
  }

  String stripTag(String tag) {
    return removeDiacritics(tag.toLowerCase());
  }

  String encryptTag(String tag) {
    final plainText = stripTag(tag);

    final key = E.Key.fromUtf8('picpics key for encrypting tags!');
    final iv = E.IV.fromLength(16);
    final encrypter = E.Encrypter(E.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    print('Stripped tag: $tag');
//    print(encrypted.bytes);
    print('Encrypted tag: ${encrypted.base16}');
//    print(encrypted.base64);

    return encrypted.base16;
  }

  String decryptTag(String encrypted) {
    final key = E.Key.fromUtf8('picpics key for encrypting tags!');
    final iv = E.IV.fromLength(16);
    final encrypter = E.Encrypter(E.AES(key));
    var encrypt = E.Encrypted.fromBase16(encrypted);
    final decrypted = encrypter.decrypt(encrypt, iv: iv);

    print('Decrypted tag: $decrypted');
    return decrypted;
  }

  // Create tag for using in multipic
  void createTag(String tagName) {
    var tagsBox = Hive.box('tags');
    print(tagsBox.keys);

    String tagKey = encryptTag(tagName);
    print('Adding tag: $tagName');

    if (tagsBox.containsKey(tagKey)) {
      print('user already has this tag');
      return;
    }

    print('adding tag to database...');
    tagsBox.put(tagKey, Tag(tagName, []));
    addTagToRecent(tagKey: tagKey);

    Analytics.sendEvent(Event.created_tag);
    notifyListeners();
  }

  void addTagsToPics({List<String> tagsKeys, List<String> photosIds, List<AssetEntity> entities}) {
    var tagsBox = Hive.box('tags');

    for (String photoId in photosIds) {
      for (String tagKey in tagsKeys) {
        Tag getTag = tagsBox.get(tagKey);

        if (getTag.photoId.contains(photoId)) {
          print('this tag is already in this picture');
          continue;
        }

        getTag.photoId.add(photoId);
        tagsBox.put(tagKey, getTag);
        addTagToPic(
          tagKey: tagKey,
          photoId: photoId,
          entities: entities,
        );
        print('update pictures in tag');
        Analytics.sendEvent(Event.added_tag);
      }
    }

    notifyListeners();
  }

  Future<void> addTag({String tagName, String photoId}) async {
    var tagsBox = Hive.box('tags');
    print(tagsBox.keys);

    String tagKey = encryptTag(tagName);
    print('Adding tag: $tagName');

    if (tagsBox.containsKey(tagKey)) {
      print('user already has this tag');

      Tag getTag = tagsBox.get(tagKey);

      if (getTag.photoId.contains(photoId)) {
        print('this tag is already in this picture');
        return;
      }

      getTag.photoId.add(photoId);
      tagsBox.put(tagKey, getTag);
      await addTagToPic(
        tagKey: tagKey,
        photoId: photoId,
      );
      addTagToRecent(tagKey: tagKey);
      print('updated pictures in tag');
      notifyListeners();
      return;
    }

    Analytics.sendEvent(Event.created_tag);
    print('adding tag to database...');
    tagsBox.put(tagKey, Tag(tagName, [photoId]));
    await addTagToPic(
      tagKey: tagKey,
      photoId: photoId,
    );
    addTagToRecent(tagKey: tagKey);
    notifyListeners();
  }

  void setupPathList() async {
//    List<AssetPathEntity> pathList;
//
//    pathList = await PhotoManager.getAssetPathList(
//      hasAll: true,
//      onlyAll: true,
//      type: RequestType.image,
//    );
//
//    print('pathList: $pathList');
//
//    DatabaseManager.instance.assetProvider.current = pathList[0];
//    DatabaseManager.instance.loadFirstPhotos();
  }

  loadFirstPhotos() async {
//    await assetProvider.loadMore();
//    print('loaded first photos');
  }

  loadMore() async {
//    print('calling asset provider loadmore');
//    await assetProvider.loadMore();
//    print('calling notify listeners');
//    notifyListeners();
  }

//  String formatDate(DateTime date) {
//    int daysDif = calculateDifference(date);
//
//    if (daysDif == 0) {
//      return 'Hoje';
//    } else if (daysDif == -1) {
//      return 'Ontem';
//    }
//
//    switch (date.weekday) {
//      case 1:
//        {
//          return 'Segunda, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
//        }
//        break;
//
//      case 2:
//        {
//          return 'Terça, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
//        }
//        break;
//
//      case 3:
//        {
//          return 'Quarta, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
//        }
//        break;
//
//      case 4:
//        {
//          return 'Quinta, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
//        }
//        break;
//
//      case 5:
//        {
//          return 'Sexta, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
//        }
//        break;
//
//      case 6:
//        {
//          return 'Sábado, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
//        }
//        break;
//
//      case 7:
//        {
//          return 'Domingo, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
//        }
//        break;
//
//      default:
//        {
//          return '${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
//        }
//        break;
//    }
//  }
//
//  String monthString(int month) {
//    switch (month) {
//      case 1:
//        {
//          return 'janeiro';
//        }
//        break;
//      case 2:
//        {
//          return 'fevereiro';
//        }
//        break;
//      case 3:
//        {
//          return 'março';
//        }
//        break;
//      case 4:
//        {
//          return 'abril';
//        }
//        break;
//      case 5:
//        {
//          return 'maio';
//        }
//        break;
//      case 6:
//        {
//          return 'junho';
//        }
//        break;
//      case 7:
//        {
//          return 'julho';
//        }
//        break;
//      case 8:
//        {
//          return 'agosto';
//        }
//        break;
//      case 9:
//        {
//          return 'setembro';
//        }
//        break;
//      case 10:
//        {
//          return 'outubro';
//        }
//        break;
//      case 11:
//        {
//          return 'novembro';
//        }
//        break;
//      case 12:
//        {
//          return 'dezembro';
//        }
//        break;
//    }
//  }
//
//  int calculateDifference(DateTime date) {
//    DateTime now = DateTime.now();
//    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
//  }

  Future findLocation(double latitude, double longitude) async {
    print('Finding location...');
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'pt_BR');
    print('Placemark: ${placemark.first.locality}');
    currentPhotoCity = placemark.first.locality;
    currentPhotoState = placemark.first.administrativeArea;
    lastLocationRequest = [latitude, longitude];
//    notifyListeners();
  }

  void checkNotificationPermission({bool firstPermissionCheck = false, bool shouldNotify = false}) async {
    return NotificationPermissions.getNotificationPermissionStatus().then((status) {
      var userBox = Hive.box('user');
      if (status == PermissionStatus.denied) {
        print('user has no notification permission');
        DatabaseManager.instance.userSettings.notifications = false;
//        if (firstPermissionCheck) {
        DatabaseManager.instance.userSettings.dailyChallenges = false;
//        }
        userBox.putAt(0, DatabaseManager.instance.userSettings);
      } else {
        print('user has notification permission');
        DatabaseManager.instance.userSettings.notifications = true;
        if (firstPermissionCheck) {
          DatabaseManager.instance.userSettings.dailyChallenges = true;
        }
        userBox.putAt(0, DatabaseManager.instance.userSettings);
      }
      if (shouldNotify) {
        notifyListeners();
      }
    });
  }
}
