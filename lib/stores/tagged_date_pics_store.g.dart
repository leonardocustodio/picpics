// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tagged_date_pics_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TaggedDatePicsStore on _TaggedDatePicsStore, Store {
  Computed<List<String>> _$picStoresIdsComputed;

  @override
  List<String> get picStoresIds => (_$picStoresIdsComputed ??=
          Computed<List<String>>(() => super.picStoresIds,
              name: '_TaggedDatePicsStore.picStoresIds'))
      .value;

  final _$_TaggedDatePicsStoreActionController =
      ActionController(name: '_TaggedDatePicsStore');

  @override
  void addPicStore(PicStore picStore) {
    final _$actionInfo = _$_TaggedDatePicsStoreActionController.startAction(
        name: '_TaggedDatePicsStore.addPicStore');
    try {
      return super.addPicStore(picStore);
    } finally {
      _$_TaggedDatePicsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePicStore(PicStore picStore) {
    final _$actionInfo = _$_TaggedDatePicsStoreActionController.startAction(
        name: '_TaggedDatePicsStore.removePicStore');
    try {
      return super.removePicStore(picStore);
    } finally {
      _$_TaggedDatePicsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
picStoresIds: ${picStoresIds}
    ''';
  }
}
