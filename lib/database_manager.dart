import 'package:flutter/cupertino.dart';
import 'package:picPics/asset_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManager extends ChangeNotifier {
  DatabaseManager._();

  static DatabaseManager _instance;

  static DatabaseManager get instance {
    return _instance ??= DatabaseManager._();
  }

  bool hasGalleryPermission = true;
  AssetProvider assetProvider = AssetProvider();

  loadMore() async {
    print('calling asset provider loadmore');
    await assetProvider.loadMore();
    print('calling notify listeners');
    notifyListeners();
  }
}
