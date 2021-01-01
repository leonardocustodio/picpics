// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStore, Store {
  final _$slideIndexAtom = Atom(name: '_LoginStore.slideIndex');

  @override
  int get slideIndex {
    _$slideIndexAtom.reportRead();
    return super.slideIndex;
  }

  @override
  set slideIndex(int value) {
    _$slideIndexAtom.reportWrite(value, super.slideIndex, () {
      super.slideIndex = value;
    });
  }

  @override
  String toString() {
    return '''
slideIndex: ${slideIndex}
    ''';
  }
}
