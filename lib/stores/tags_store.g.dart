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

  final _$countAtom = Atom(name: '_TagsStore.count');

  @override
  int get count {
    _$countAtom.reportRead();
    return super.count;
  }

  @override
  set count(int value) {
    _$countAtom.reportWrite(value, super.count, () {
      super.count = value;
    });
  }

  final _$timeAtom = Atom(name: '_TagsStore.time');

  @override
  DateTime get time {
    _$timeAtom.reportRead();
    return super.time;
  }

  @override
  set time(DateTime value) {
    _$timeAtom.reportWrite(value, super.time, () {
      super.time = value;
    });
  }

  final _$_TagsStoreActionController = ActionController(name: '_TagsStore');

  @override
  void setTagInfo(
      {String tagId,
      String tagName,
      @required int count,
      @required DateTime time}) {
    final _$actionInfo =
        _$_TagsStoreActionController.startAction(name: '_TagsStore.setTagInfo');
    try {
      return super
          .setTagInfo(tagId: tagId, tagName: tagName, count: count, time: time);
    } finally {
      _$_TagsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
id: ${id},
name: ${name},
count: ${count},
time: ${time}
    ''';
  }
}
