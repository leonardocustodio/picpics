// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pic_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PicStore on _PicStore, Store {
  final _$latitudeAtom = Atom(name: '_PicStore.latitude');

  @override
  double get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(double value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  final _$longitudeAtom = Atom(name: '_PicStore.longitude');

  @override
  double get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(double value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  final _$specificLocationAtom = Atom(name: '_PicStore.specificLocation');

  @override
  String get specificLocation {
    _$specificLocationAtom.reportRead();
    return super.specificLocation;
  }

  @override
  set specificLocation(String value) {
    _$specificLocationAtom.reportWrite(value, super.specificLocation, () {
      super.specificLocation = value;
    });
  }

  final _$generalLocationAtom = Atom(name: '_PicStore.generalLocation');

  @override
  String get generalLocation {
    _$generalLocationAtom.reportRead();
    return super.generalLocation;
  }

  @override
  set generalLocation(String value) {
    _$generalLocationAtom.reportWrite(value, super.generalLocation, () {
      super.generalLocation = value;
    });
  }

  @override
  String toString() {
    return '''
latitude: ${latitude},
longitude: ${longitude},
specificLocation: ${specificLocation},
generalLocation: ${generalLocation}
    ''';
  }
}
