// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TagsStore on _TagsStore, Store {
  final _$idAtom = Atom(name: '_TagsStore.id');

  @override
  String get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(String value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$nameAtom = Atom(name: '_TagsStore.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$_TagsStoreActionController = ActionController(name: '_TagsStore');

  @override
  void setTagInfo({String tagId, dynamic tagName}) {
    final _$actionInfo =
        _$_TagsStoreActionController.startAction(name: '_TagsStore.setTagInfo');
    try {
      return super.setTagInfo(tagId: tagId, tagName: tagName);
    } finally {
      _$_TagsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
id: ${id},
name: ${name}
    ''';
  }
}
