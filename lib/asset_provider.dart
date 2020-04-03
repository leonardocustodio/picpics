import 'dart:async';

import 'package:photo_manager/photo_manager.dart';

class AssetProvider {
  Map<AssetPathEntity, AssetPaging> _dataMap = {};

  AssetPathEntity _current;

  AssetPathEntity get current => _current;

  set current(AssetPathEntity current) {
    _current = current;
    if (_dataMap[current] == null) {
      final paging = AssetPaging(current);
      _dataMap[current] = paging;
    }
  }

  List<AssetEntity> get data => _dataMap[current]?.data ?? [];

  Future<void> loadMore() async {
    final paging = getPaging();
    if (paging != null) {
      await paging.loadMore();
    }
  }

  AssetPaging getPaging() => _dataMap[current];

  bool get noMore => getPaging()?.noMore ?? false;

  int get count => data?.length ?? 0;
}

class AssetPaging {
  int page = 0;

  List<AssetEntity> data = [];

  final AssetPathEntity path;

  final int pageCount;

  bool noMore = false;

  AssetPaging(this.path, {this.pageCount = 50});

  Future<void> loadMore() async {
    if (noMore == true) {
      return;
    }
    var data = await path.getAssetListPaged(page, pageCount);
    print('loaded assets paged');
    print('data length: ${data.length} - pagecount: $pageCount');
    if (data.length == 0 || data.length <= pageCount) {
      print('added everything');
      noMore = true;
    }
    print('added page');
    page++;
    this.data.addAll(data);
  }
}
