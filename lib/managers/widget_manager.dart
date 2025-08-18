import 'package:home_widget/home_widget.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/stores/pic_store.dart';

class WidgetManager {
  static AppDatabase appDatabase = AppDatabase();
  static Future<void> saveData(
      {List<PicStore> picsStores = const <PicStore>[],}) async {
    for (final store in picsStores) {
      await store.switchIsStarred();
    }
    //AppLogger.d('Setted is starred to true');
  }

  static Future<void> sendAndUpdate() async {
    //AppLogger.d('Sending data to widget');
    await _sendData();
    await _updateWidget();
    //AppLogger.d('Finished sending data');
  }

  static Future<void> _sendData() async {
    try {
      //AppLogger.d('Future send data');

      //var userBox = await Hive.openBox('user');
      //var picsBox = await Hive.openBox('pics');

      await appDatabase.getSingleMoorUser();

      /* final starredPhotos = currentUser.starredPhotos; */
      //AppLogger.d('Number of starred photos: ${starredPhotos.length}');
/* 
      String? baseString;

      if (starredPhotos.isEmpty) {
        baseString = currentUser.defaultWidgetImage;
      } else {
        final rand = Random();
        final randInt = rand.nextInt(starredPhotos.length);
        //AppLogger.d('Sorted number for widget: $randInt');

        final pic = await appDatabase
            .getPhotoByPhotoId(starredPhotos.keys.toList()[randInt]);
        //AppLogger.d('Base64: ${pic.base64encoded}');
        baseString = pic?.base64encoded;
      }
      if (baseString == null) {
        return;
      }

      //AppLogger.d('Send base string!');
      await Future.wait(
          [HomeWidget.saveWidgetData<String>('imageEncoded', baseString)]); */
      return;
    } catch (exception) {
      //AppLogger.d('Error Sending Data. $exception');
    }
  }

  static Future<void> _updateWidget() async {
    try {
      //AppLogger.d('Future update widget');
      await HomeWidget.updateWidget(
        name: 'PicsWidgetProvider',
        androidName: 'PicsWidgetProvider',
        iOSName: 'PicsWidget',
      );
      return;
    } catch (exception) {
      //AppLogger.d('Error Updating Widget. $exception');
    }
    //AppLogger.d('After return in update widget');
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
  //     debug//AppLogger.d('Error Getting Data. $exception');
  //   }
  // }
}
