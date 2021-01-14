// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MigrationStore on _MigrationStore, Store {
  final _$isMigratingAtom = Atom(name: '_MigrationStore.isMigrating');

  @override
  bool get isMigrating {
    _$isMigratingAtom.reportRead();
    return super.isMigrating;
  }

  @override
  set isMigrating(bool value) {
    _$isMigratingAtom.reportWrite(value, super.isMigrating, () {
      super.isMigrating = value;
    });
  }

  final _$startMigrationAsyncAction =
      AsyncAction('_MigrationStore.startMigration');

  @override
  Future<void> startMigration() {
    return _$startMigrationAsyncAction.run(() => super.startMigration());
  }

  final _$_MigrationStoreActionController =
      ActionController(name: '_MigrationStore');

  @override
  void setIsMigrating(bool value) {
    final _$actionInfo = _$_MigrationStoreActionController.startAction(
        name: '_MigrationStore.setIsMigrating');
    try {
      return super.setIsMigrating(value);
    } finally {
      _$_MigrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isMigrating: ${isMigrating}
    ''';
  }
}
