import 'package:home_widget/home_widget.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/stores/pic_store.dart';

class WidgetManager {
  static AppDatabase appDatabase = AppDatabase();
  static Future<void> saveData(
      {List<PicStore> picsStores = const <PicStore>[]}) async {
    for (var store in picsStores) {
      await store.switchIsStarred();
    }
    //print('Setted is starred to true');
  }

  static Future<void> sendAndUpdate() async {
    //print('Sending data to widget');
    await _sendData();
    await _updateWidget();
    //print('Finished sending data');
  }

  static Future<void> _sendData() async {
    try {
      //print('Future send data');

      //var userBox = await Hive.openBox('user');
      //var picsBox = await Hive.openBox('pics');

      var currentUser = (await appDatabase.getSingleMoorUser())!;

      /* final starredPhotos = currentUser.starredPhotos; */
      //print('Number of starred photos: ${starredPhotos.length}');
/* 
      String? baseString;

      if (starredPhotos.isEmpty) {
        baseString = currentUser.defaultWidgetImage;
      } else {
        final rand = Random();
        final randInt = rand.nextInt(starredPhotos.length);
        //print('Sorted number for widget: $randInt');

        final pic = await appDatabase
            .getPhotoByPhotoId(starredPhotos.keys.toList()[randInt]);
        //print('Base64: ${pic.base64encoded}');
        baseString = pic?.base64encoded;
      }
      if (baseString == null) {
        return;
      }

      //print('Send base string!');
      await Future.wait(
          [HomeWidget.saveWidgetData<String>('imageEncoded', baseString)]); */
      return;
    } catch (exception) {
      //print('Error Sending Data. $exception');
    }
  }

  static Future<void> _updateWidget() async {
    try {
      //print('Future update widget');
      await HomeWidget.updateWidget(
        name: 'PicsWidgetProvider',
        androidName: 'PicsWidgetProvider',
        iOSName: 'PicsWidget',
      );
      return;
    } catch (exception) {
      //print('Error Updating Widget. $exception');
    }
    //print('After return in update widget');
  }

  // Future<void> _loadData() async {
  //   try {
  //     return Future.wait([
  //       HomeWidget.getWidgetData<String>('title', defaultValue: 'Default Title')
  //           .then((value) => _titleController.text = value),
  //       HomeWidget.getWidgetData<String>('message',
  //           defaultValue: 'Default Message')
  //           .then((value) => _messageController.text = value),
  //     ]);
  //   } catch (exception) {
  //     debug//print('Error Getting Data. $exception');
  //   }
  // }
}
