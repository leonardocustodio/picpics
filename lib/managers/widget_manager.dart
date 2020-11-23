import 'dart:math';
import 'package:home_widget/home_widget.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:hive/hive.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/model/pic.dart';

class WidgetManager {
  static Future<void> saveData({List<PicStore> picsStores}) async {
    for (PicStore store in picsStores) {
      store.switchIsStarred();
    }
    print('Setted is starred to true');
  }

  static Future<void> sendAndUpdate() async {
    print('Sending data to widget');
    await _sendData();
    await _updateWidget();
    print('Finished sending data');
  }

  static Future<void> _sendData() async {
    try {
      print('Future send data');

      var userBox = await Hive.openBox('user');
      var picsBox = await Hive.openBox('pics');

      User currentUser = userBox.getAt(0);
      List<String> starredPhotos = currentUser.starredPhotos;
      print('Number of starred photos: ${starredPhotos.length}');

      String baseString;

      if (starredPhotos.length == 0) {
        baseString = currentUser.defaultWidgetImage;
      } else {
        Random rand = new Random();
        int randInt = rand.nextInt(starredPhotos.length);
        print('Sorted number for widget: $randInt');

        Pic pic = picsBox.get(starredPhotos[randInt]);
        print('Base64: ${pic.base64encoded}');
        baseString = pic.base64encoded;
      }

      print('Send base string!');
      return Future.wait([HomeWidget.saveWidgetData<String>('imageEncoded', baseString)]);
    } catch (exception) {
      print('Error Sending Data. $exception');
    }
  }

  static Future<void> _updateWidget() async {
    try {
      print('Future update widget');
      return HomeWidget.updateWidget(
        name: 'PicsWidgetProvider',
        androidName: 'PicsWidgetProvider',
        iOSName: 'PicsWidget',
      );
    } catch (exception) {
      print('Error Updating Widget. $exception');
    }
    print('After return in update widget');
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
  //     debugPrint('Error Getting Data. $exception');
  //   }
  // }

}
