// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TabsStore on _TabsStore, Store {
  final _$currentTabAtom = Atom(name: '_TabsStore.currentTab');

  @override
  int get currentTab {
    _$currentTabAtom.reportRead();
    return super.currentTab;
  }

  @override
  set currentTab(int value) {
    _$currentTabAtom.reportWrite(value, super.currentTab, () {
      super.currentTab = value;
    });
  }

  final _$multiPicBarAtom = Atom(name: '_TabsStore.multiPicBar');

  @override
  bool get multiPicBar {
    _$multiPicBarAtom.reportRead();
    return super.multiPicBar;
  }

  @override
  set multiPicBar(bool value) {
    _$multiPicBarAtom.reportWrite(value, super.multiPicBar, () {
      super.multiPicBar = value;
    });
  }

  final _$_TabsStoreActionController = ActionController(name: '_TabsStore');

  @override
  void setCurrentTab(int value) {
    final _$actionInfo = _$_TabsStoreActionController.startAction(
        name: '_TabsStore.setCurrentTab');
    try {
      return super.setCurrentTab(value);
    } finally {
      _$_TabsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMultiPicBar(bool value) {
    final _$actionInfo = _$_TabsStoreActionController.startAction(
        name: '_TabsStore.setMultiPicBar');
    try {
      return super.setMultiPicBar(value);
    } finally {
      _$_TabsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentTab: ${currentTab},
multiPicBar: ${multiPicBar}
    ''';
  }
}
