import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'migration_store.g.dart';

class MigrationStore = _MigrationStore with _$MigrationStore;

abstract class _MigrationStore with Store {
  _MigrationStore() {
    // autorun((_) {
    //   // print('autorun');
    // });
  }
}
