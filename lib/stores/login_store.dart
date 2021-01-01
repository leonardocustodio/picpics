import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  _LoginStore() {
    // autorun((_) {
    //   // print('autorun');
    // });
  }

  @observable
  int slideIndex = 0;

  // @observable
  // String id;
  //
  // @observable
  // String name;

}
