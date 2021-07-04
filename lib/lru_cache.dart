import 'dart:collection';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/stores/pic_store.dart';

class ImageLruCache {
  static final LRUMap<_ImageCacheEntity, Uint8List> _map = LRUMap(500);

  static Uint8List? getData(PicStore picStore, [int size = 64]) {
    return _map.get(_ImageCacheEntity(picStore.entity.value!, size));
  }

  static void setData(AssetEntity entity, int size, Uint8List list) {
    _map.put(_ImageCacheEntity(entity, size), list);
  }

  static void clearCache() {
    _map.clear();
  }
}

class _ImageCacheEntity {
  AssetEntity entity;
  int size;

  _ImageCacheEntity(this.entity, this.size);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ImageCacheEntity &&
          runtimeType == other.runtimeType &&
          entity == other.entity &&
          size == other.size;

  @override
  int get hashCode => entity.hashCode ^ size.hashCode;
}

// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

typedef EvictionHandler<_ImageCacheEntity, Uint8List> = Function(
    _ImageCacheEntity key, Uint8List? value);

class LRUMap<_ImageCacheEntity, Uint8List> {
  final LinkedHashMap<_ImageCacheEntity, Uint8List> _map =
      LinkedHashMap<_ImageCacheEntity, Uint8List>();
  final int _maxSize;
  final EvictionHandler<_ImageCacheEntity, Uint8List>? _handler;

  LRUMap(this._maxSize, [this._handler]);

  Uint8List? get(_ImageCacheEntity key) {
    if (_map[key] == null) {
      return null;
    }
    return _map[key];
  }

  void put(_ImageCacheEntity key, Uint8List value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > _maxSize) {
      final evictedKey = _map.keys.first;
      final evictedValue = _map.remove(evictedKey);
      _handler?.call(evictedKey, evictedValue);
    }
  }

  void remove(_ImageCacheEntity key) {
    _map.remove(key);
  }

  void clear() {
    _map.clear();
  }
}
