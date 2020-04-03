import 'package:flutter/cupertino.dart';
import 'package:picPics/asset_provider.dart';
import 'package:photo_manager/photo_manager.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:picPics/model/tag.dart';

class DatabaseManager extends ChangeNotifier {
  DatabaseManager._();

  static DatabaseManager _instance;

  static DatabaseManager get instance {
    return _instance ??= DatabaseManager._();
  }

  bool hasGalleryPermission = true;
  AssetProvider assetProvider = AssetProvider();
  AssetEntity selectedPhoto;
  List<double> lastLocationRequest = [0.0, 0.0];

  String currentPhotoCity;
  String currentPhotoState;

  List<String> allTags = [];

  loadTags() {
    var tagsBox = Hive.box('tags');

    for (Tag tag in tagsBox.values) {
      allTags.add(tag.name);
    }
    print('loaded all tags in memory: $allTags');
  }

  addTag(String tag, String photoId) {
    print('Adding tag: $tag');

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
      print('updated pictures in tag');
      return;
    }

    print('adding tag to database...');
    tagsBox.add(Tag(tag, [photoId]));
    allTags.add(tag);
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
