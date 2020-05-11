import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoProvider extends ChangeNotifier {
  PhotoProvider._();

  static PhotoProvider _instance;

  static PhotoProvider get instance {
    return _instance ??= PhotoProvider._();
  }

  List<AssetPathEntity> list = [];

  RequestType type = RequestType.image;
  var hasAll = true;
  var onlyAll = true;

  Map<AssetPathEntity, AssetPathProvider> pathProviderMap = {};

  bool _notifying = false;

  bool _needTitle = false;

  bool get needTitle => _needTitle;

  set needTitle(bool needTitle) {
    _needTitle = needTitle;
    notifyListeners();
  }

  DateTime _startDt = DateTime.fromMicrosecondsSinceEpoch(0); // Default Before 8 years

  DateTime get startDt => _startDt;

  set startDt(DateTime startDt) {
    _startDt = startDt;
    notifyListeners();
  }

  DateTime _endDt = DateTime.now();

  DateTime get endDt => _endDt;

  set endDt(DateTime endDt) {
    _endDt = endDt;
    notifyListeners();
  }

  bool _asc = false;

  bool get asc => _asc;

  set asc(bool asc) {
    _asc = asc;
    notifyListeners();
  }

  var _thumbFormat = ThumbFormat.png;

  ThumbFormat get thumbFormat => _thumbFormat;

  set thumbFormat(thumbFormat) {
    _thumbFormat = thumbFormat;
    notifyListeners();
  }

  bool get notifying => _notifying;

  String minWidth = "0";
  String maxWidth = "10000";
  String minHeight = "0";
  String maxHeight = "10000";
  bool _ignoreSize = true;

  bool get ignoreSize => _ignoreSize;

  set ignoreSize(bool ignoreSize) {
    _ignoreSize = ignoreSize;
    notifyListeners();
  }

  Duration _minDuration = Duration.zero;

  Duration get minDuration => _minDuration;

  set minDuration(Duration minDuration) {
    _minDuration = minDuration;
    notifyListeners();
  }

  Duration _maxDuration = Duration(hours: 1);

  Duration get maxDuration => _maxDuration;

  set maxDuration(Duration maxDuration) {
    _maxDuration = maxDuration;
    notifyListeners();
  }

  set notifying(bool notifying) {
    _notifying = notifying;
    notifyListeners();
  }

  void changeType(RequestType type) {
    this.type = type;
    notifyListeners();
  }

  void changeHasAll(bool value) {
    this.hasAll = value;
    notifyListeners();
  }

  void changeOnlyAll(bool value) {
    this.onlyAll = value;
    notifyListeners();
  }

  void reset() {
    this.list.clear();
    pathProviderMap.clear();
  }

  Future<void> refreshGalleryList() async {
    final option = makeOption();

    if (option == null) {
      assert(option != null);
      return;
    }

    reset();
    var galleryList = await PhotoManager.getAssetPathList(
      type: type,
      hasAll: hasAll,
      onlyAll: onlyAll,
      filterOption: option,
    );

    galleryList.sort((s1, s2) {
      return s2.assetCount.compareTo(s1.assetCount);
    });

    this.list.clear();
    this.list.addAll(galleryList);

    print('Loaded all photos: ${this.list[0].assetCount}');
  }

  AssetPathProvider getOrCreatePathProvider(AssetPathEntity pathEntity) {
    pathProviderMap[pathEntity] ??= AssetPathProvider(pathEntity);

    if (pathProviderMap[pathEntity].orderedList == null) {
      pathProviderMap[pathEntity].orderedList = [];
      print('initializing a ordered list with ${pathEntity.assetCount} photos');
    }

    return pathProviderMap[pathEntity];
  }

  FilterOptionGroup makeOption() {
    SizeConstraint sizeConstraint;
    try {
      final minW = int.tryParse(minWidth);
      final maxW = int.tryParse(maxWidth);
      final minH = int.tryParse(minHeight);
      final maxH = int.tryParse(maxHeight);
      sizeConstraint = SizeConstraint(
        minWidth: minW,
        maxWidth: maxW,
        minHeight: minH,
        maxHeight: maxH,
        ignoreSize: ignoreSize,
      );
    } catch (e) {
//      showToast("Cannot convert your size.");
      return null;
    }

    DurationConstraint durationConstraint = DurationConstraint(
      min: minDuration,
      max: maxDuration,
    );

    final option = FilterOption(
      sizeConstraint: sizeConstraint,
      durationConstraint: durationConstraint,
      needTitle: needTitle,
    );

    final dtCond = DateTimeCond(
      min: startDt,
      max: endDt,
      asc: asc,
    );

    return FilterOptionGroup()
      ..setOption(AssetType.video, option)
      ..setOption(AssetType.image, option)
      ..setOption(AssetType.audio, option)
      ..dateTimeCond = dtCond;
  }

  Future<void> refreshAllGalleryProperties() async {
    for (var gallery in list) {
      await gallery.refreshPathProperties();
    }
    notifyListeners();
  }

  void changeThumbFormat() {
    if (thumbFormat == ThumbFormat.jpeg) {
      thumbFormat = ThumbFormat.png;
    } else {
      thumbFormat = ThumbFormat.jpeg;
    }
  }
}

class AssetPathProvider extends ChangeNotifier {
  static const loadCount = 50;

  bool isInit = false;
  bool isLoaded = false;

  final AssetPathEntity path;
  AssetPathProvider(this.path);

  List<AssetEntity> list = [];

  List<AssetEntity> orderedList;

  var page = 0;

  int get showItemCount {
    if (list.length == path.assetCount) {
      return path.assetCount;
    } else {
      return path.assetCount;
    }
  }

  Future onRefresh() async {
    await path.refreshPathProperties();
    final list = await path.getAssetListPaged(0, loadCount);
    page = 0;
    this.list.clear();
    this.list.addAll(list);
    isInit = true;
    notifyListeners();
    printListLength("onRefresh");
  }

  Future<void> onLoadMore() async {
    if (showItemCount > path.assetCount) {
      print("already max");
      return;
    }
    final list = await path.getAssetListPaged(page + 1, loadCount);
    page = page + 1;
    this.list.addAll(list);
    notifyListeners();
    printListLength("loadmore");
  }

  Future<void> loadAllPics() async {
    print('Loading all pics');
    if (isLoaded) {
      print('Already loaded');
      return;
    }

    final list = await path.getAssetListRange(start: 0, end: path.assetCount);
    this.orderedList = list;
    isLoaded = true;

    print('LOADED ALL PHOTOS!!!!');
    notifyListeners();
  }

//  Future<void> loadPaths({int start, int end}) async {
//    if (isLoaded) {
//      return;
//    }
//
//    // Verificar essa parte
////    int useThisEnd = end;
////
////    if (end > path.assetCount) {
////      useThisEnd = path.assetCount;
////    }
////
////    if (this.orderedList[useThisEnd - 1] != null) {
////      int newEnd = useThisEnd - 3;
////      while (this.orderedList[newEnd] != null) {
////        newEnd -= 3;
////        if (newEnd <= start) {
////          break;
////        }
////      }
////      useThisEnd = newEnd;
////    }
////    // Verificar essa parte
////
////    print('Loading from range: $start to $useThisEnd');
//    final list = await path.getAssetListRange(start: 0, end: path.assetCount);
//    this.orderedList = list;
//    isLoaded = true;
//
////    int x = start;
////    for (AssetEntity entity in list) {
////      this.orderedList[x] = entity;
////      x++;
////    }
////    print(this.orderedList);
//    print('LOADED ALL PHOTOS!!!!');
//    notifyListeners();
//  }

//  void delete(AssetEntity entity) async {
//    final result = await PhotoManager.editor.deleteWithIds([entity.id]);
//    if (result.isNotEmpty) {
//      final rangeEnd = this.list.length;
//      await provider.refreshAllGalleryProperties();
//      final list = await path.getAssetListRange(start: 0, end: rangeEnd);
//      this.list.clear();
//      this.list.addAll(list);
//      printListLength("deleted");
//    }
//  }
//
//  void removeInAlbum(AssetEntity entity) async {
//    if (await PhotoManager.editor.iOS.removeInAlbum(entity, path)) {
//      final rangeEnd = this.list.length;
//      await provider.refreshAllGalleryProperties();
//      final list = await path.getAssetListRange(start: 0, end: rangeEnd);
//      this.list.clear();
//      this.list.addAll(list);
//      printListLength("removeInAlbum");
//    }
//  }

  void printListLength(String tag) {
    print("$tag length : ${list.length}");
  }
}

//class AssetProvider extends ChangeNotifier {
//  Map<AssetPathEntity, AssetPaging> _dataMap = {};
//
//  AssetPathEntity _current;
//
//  AssetPathEntity get current => _current;
//
//  set current(AssetPathEntity current) {
//    _current = current;
//    if (_dataMap[current] == null) {
//      final paging = AssetPaging(current);
//      _dataMap[current] = paging;
//    }
//  }
//
//  List<AssetEntity> get data => _dataMap[current]?.data ?? [];
//
//  Future<void> loadMore() async {
//    final paging = getPaging();
//    if (paging != null) {
//      await paging.loadMore();
//    }
//  }
//
//  AssetPaging getPaging() => _dataMap[current];
//
//  bool get noMore => getPaging()?.noMore ?? false;
//
//  int get count => data?.length ?? 0;
//}
//
//class AssetPaging extends ChangeNotifier {
//  int page = 0;
//
//  List<AssetEntity> data = [];
//
//  final AssetPathEntity path;
//
//  final int pageCount;
//
//  bool isLoading = false;
//
//  bool noMore = false;
//
//  AssetPaging(this.path, {this.pageCount = 50});
//
//  Future<void> loadMore() async {
//    if (noMore == true || isLoading == true) {
//      print('NoMore or IsLoading!!!');
//      return;
//    }
//    isLoading = true;
//    var data = await path.getAssetListPaged(page, pageCount);
//    print('asset count: ${path.assetCount}');
//    print('loaded assets paged');
//    print('data length: ${data.length} - pageCount $pageCount');
//    if (data.length == 0) {
//      print('added everything');
//      noMore = true;
//    }
//    print('added page');
//    page++;
//    this.data.addAll(data);
//    print('### all data: ${this.data.length}');
//    isLoading = false;
//  }
//}
