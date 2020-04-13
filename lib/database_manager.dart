import 'package:flutter/cupertino.dart';
import 'package:picPics/asset_provider.dart';
import 'package:photo_manager/photo_manager.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';

class DatabaseManager extends ChangeNotifier {
  DatabaseManager._();

  static DatabaseManager _instance;

  static DatabaseManager get instance {
    return _instance ??= DatabaseManager._();
  }

  static const maxNumOfRecentTags = 5;

  bool hasGalleryPermission = true;
  bool noTaggedPhoto = true;
  bool editingTags = false;
  bool searchingTags = false;

  List<String> searchActiveTags = ['Abc', 'cde', 'fgh'];
  List<String> searchResults;

  AssetProvider assetProvider = AssetProvider();
  AssetEntity selectedPhoto;
  List<double> lastLocationRequest = [0.0, 0.0];

  String currentPhotoCity;
  String currentPhotoState;

  List<String> allTags = [];
  List<String> allPics = [];
  List<String> allRecentTags = [];

  double scale = 1.0;

  String addingTagId = '';
  int addingTagIndex = 0;

//  Pic selectedPic;

  void findPicsByTag(String tag) {}

  void searchResultsTags(String text) {
    if (text == '') {
      searchResults = null;
      notifyListeners();
      return;
    }

    var tags = allTags.where((e) => e.toLowerCase().startsWith(text.toLowerCase()));
    searchResults = [];
    searchResults.addAll(tags);
    notifyListeners();
  }

  void switchSearchingTags() {
    searchingTags = !searchingTags;
    notifyListeners();
  }

  void switchEditingTags() {
    editingTags = !editingTags;
    notifyListeners();
  }

  void gridScale(double multiplier) {
    scale = scale;
    print('new scale value: $scale');
//    notifyListeners();
  }

  Pic getPicInfo(String photoId) {
    print('loading pic info from: $photoId');
    var picsBox = Hive.box('pics');

    if (allPics.contains(photoId)) {
      int indexOfPic = allPics.indexOf(photoId);
      Pic getPic = picsBox.getAt(indexOfPic);
      return getPic;
    }

    return null;
  }

  loadPics() {
    var picsBox = Hive.box('pics');

    for (Pic pic in picsBox.values) {
      allPics.add(pic.photoId);
    }

    if (allPics.length == 0) {
      noTaggedPhoto = true;
    } else {
      noTaggedPhoto = false;
    }
    print('loaded all pics in memory: $allPics');
  }

  loadTags() {
    var tagsBox = Hive.box('tags');

    for (Tag tag in tagsBox.values) {
      allTags.add(tag.name);
    }
    print('loaded all tags in memory: $allTags');
  }

  void loadRecentTags() {
    var userBox = Hive.box('user');

    User getUser = userBox.getAt(0);
    if (getUser == null) {
      print('no user returning no tags');
      allRecentTags = [];
      return;
    }

    print('${getUser.recentTags}');

    allRecentTags = getUser.recentTags ?? [];
    print('Recent tags: $allRecentTags');
  }

  // allRecentTags = getUser.recentTags (diferent do loadTags e loadPics ** prestar atencao)
  addTagToRecent(String tag) {
    print('adding tag to recent: $tag');

    var userBox = Hive.box('user');
    User getUser = userBox.getAt(0);

    if (allRecentTags.contains(tag)) {
      allRecentTags.remove(tag);
      allRecentTags.insert(0, tag);
      userBox.putAt(0, getUser);
      return;
    }

    if (allRecentTags.length >= maxNumOfRecentTags) {
      print('removing last');
      allRecentTags.removeLast();
    }

    allRecentTags.insert(0, tag);
    userBox.putAt(0, getUser);
    print('final tags in recent: $allRecentTags');
  }

  addTagToPic(String tag, String photoId, int photoIndex) {
    var picsBox = Hive.box('pics');

    if (allPics.contains(photoId)) {
      print('this picture is in db going to update');

      int indexOfPic = allPics.indexOf(photoId);
      Pic getPic = picsBox.getAt(indexOfPic);
      getPic.tags.add(tag);
      picsBox.putAt(indexOfPic, getPic);
      print('updated picture');

      return;
    }

    print('this picture is not in db, adding it...');
    Pic pic = Pic(photoId, photoIndex, DateTime.now(), 0.0, 0.0, 'No Location', [tag]);
    picsBox.add(pic);
    allPics.add(photoId);
  }

  addTag(String tag, String photoId, int photoIndex) {
    print('Adding tag: $tag');
    noTaggedPhoto = false;

    var tagsBox = Hive.box('tags');

    if (allTags.contains(tag)) {
      print('user already has this tag');

      int indexOfTag = allTags.indexOf(tag);
      Tag getTag = tagsBox.getAt(indexOfTag);

      if (getTag.photoId.contains(photoId)) {
        print('this tag is already in this picture');
        return;
      }

      getTag.photoId.add(photoId);
      tagsBox.putAt(indexOfTag, getTag);
      addTagToPic(tag, photoId, photoIndex);
      addTagToRecent(tag);
      print('updated pictures in tag');
      notifyListeners();
      return;
    }

    print('adding tag to database...');
    tagsBox.add(Tag(tag, [photoId]));
    addTagToPic(tag, photoId, photoIndex);
    addTagToRecent(tag);
    allTags.add(tag);
    notifyListeners();
  }

  loadFirstPhotos() async {
    await assetProvider.loadMore();
    print('loaded first photos');
  }

  loadMore() async {
    print('calling asset provider loadmore');
    await assetProvider.loadMore();
    print('calling notify listeners');
    notifyListeners();
  }

  String formatDate(DateTime date) {
    int daysDif = calculateDifference(date);

    if (daysDif == 0) {
      return 'Hoje';
    } else if (daysDif == -1) {
      return 'Ontem';
    }

    switch (date.weekday) {
      case 1:
        {
          return 'Segunda, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
        }
        break;

      case 2:
        {
          return 'Terça, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
        }
        break;

      case 3:
        {
          return 'Quarta, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
        }
        break;

      case 4:
        {
          return 'Quinta, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
        }
        break;

      case 5:
        {
          return 'Sexta, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
        }
        break;

      case 6:
        {
          return 'Sábado, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
        }
        break;

      case 7:
        {
          return 'Domingo, ${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
        }
        break;

      default:
        {
          return '${date.day} de ${monthString(date.month)}${date.year != DateTime.now().year ? ' de ${date.year}' : ''}';
        }
        break;
    }
  }

  String monthString(int month) {
    switch (month) {
      case 1:
        {
          return 'janeiro';
        }
        break;
      case 2:
        {
          return 'fevereiro';
        }
        break;
      case 3:
        {
          return 'março';
        }
        break;
      case 4:
        {
          return 'abril';
        }
        break;
      case 5:
        {
          return 'maio';
        }
        break;
      case 6:
        {
          return 'junho';
        }
        break;
      case 7:
        {
          return 'julho';
        }
        break;
      case 8:
        {
          return 'agosto';
        }
        break;
      case 9:
        {
          return 'setembro';
        }
        break;
      case 10:
        {
          return 'outubro';
        }
        break;
      case 11:
        {
          return 'novembro';
        }
        break;
      case 12:
        {
          return 'dezembro';
        }
        break;
    }
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  Future findLocation(double latitude, double longitude) async {
    print('Finding location...');
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'pt_BR');
    print('Placemark: ${placemark.first.locality}');
    currentPhotoCity = placemark.first.locality;
    currentPhotoState = placemark.first.administrativeArea;
    lastLocationRequest = [latitude, longitude];
//    notifyListeners();
  }
}
