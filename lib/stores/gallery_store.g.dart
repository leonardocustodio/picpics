// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GalleryStore on _GalleryStore, Store {
  Computed<bool> _$deviceHasPicsComputed;

  @override
  bool get deviceHasPics =>
      (_$deviceHasPicsComputed ??= Computed<bool>(() => super.deviceHasPics,
              name: '_GalleryStore.deviceHasPics'))
          .value;

  final _$isLoadedAtom = Atom(name: '_GalleryStore.isLoaded');

  @override
  bool get isLoaded {
    _$isLoadedAtom.reportRead();
    return super.isLoaded;
  }

  @override
  set isLoaded(bool value) {
    _$isLoadedAtom.reportWrite(value, super.isLoaded, () {
      super.isLoaded = value;
    });
  }

  final _$loadEntitiesAsyncAction = AsyncAction('_GalleryStore.loadEntities');

  @override
  Future<void> loadEntities() {
    return _$loadEntitiesAsyncAction.run(() => super.loadEntities());
  }

  final _$loadAssetsPathAsyncAction =
      AsyncAction('_GalleryStore.loadAssetsPath');

  @override
  Future<void> loadAssetsPath() {
    return _$loadAssetsPathAsyncAction.run(() => super.loadAssetsPath());
  }

  @override
  String toString() {
    return '''
isLoaded: ${isLoaded},
deviceHasPics: ${deviceHasPics}
    ''';
  }
}
