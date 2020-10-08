// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tagged_pics_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TaggedPicsStore on _TaggedPicsStore, Store {
  final _$tagAtom = Atom(name: '_TaggedPicsStore.tag');

  @override
  TagsStore get tag {
    _$tagAtom.reportRead();
    return super.tag;
  }

  @override
  set tag(TagsStore value) {
    _$tagAtom.reportWrite(value, super.tag, () {
      super.tag = value;
    });
  }

  final _$picsAtom = Atom(name: '_TaggedPicsStore.pics');

  @override
  ObservableList<PicStore> get pics {
    _$picsAtom.reportRead();
    return super.pics;
  }

  @override
  set pics(ObservableList<PicStore> value) {
    _$picsAtom.reportWrite(value, super.pics, () {
      super.pics = value;
    });
  }

  @override
  String toString() {
    return '''
tag: ${tag},
pics: ${pics}
    ''';
  }
}
