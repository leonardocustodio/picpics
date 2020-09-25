import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_functions/cloud_functions.dart';

part 'pin_store.g.dart';

class PinStore = _PinStore with _$PinStore;

abstract class _PinStore with Store {
  _PinStore() {
    autorun((_) {
      print('autorun');
    });
  }

  @observable
  String email = '';

  @action
  void setEmail(String value) => email = value;

  @observable
  String pin = '';

  @action
  void setPin(String value) => pin = value;

  @observable
  String confirmPin = '';

  @action
  void setConfirmPin(String value) => confirmPin = value;

  @observable
  String accessCode = '';

  @action
  void setAccessCode(String value) => accessCode = value;

  @action
  Future<Map<String, dynamic>> register() async {
    print('Email: $email - Pin: $pin');

    Map<String, dynamic> result = {};

    final FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    try {
      user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: pin,
      ))
          .user;

      if (user == null) {
        result['success'] = false;
        result['errorCode'] = 'NULL_USER';
        return result;
      }
    } catch (error) {
      print('Error creating user: $error');
      result['success'] = false;
      result['errorCode'] = error.code;
      return result;
    }

    print('User: $user');
    result['success'] = true;
    return result;
  }

  @action
  Future<bool> validateAccessCode() async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'validateAccessCode')..timeout = const Duration(seconds: 30);
    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'access_code': int.parse(accessCode),
        },
      );
      print(result.data);
      return result.data;
      // setState(() {
      //   _response = result.data['repeat_message'];
      //   _responseCount = result.data['repeat_count'];
      // });
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }

    return false;
  }
}
