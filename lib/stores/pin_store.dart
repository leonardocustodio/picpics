import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/stores/app_store.dart';

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

  String pin = '';

  @action
  void setEmail(String value) => email = value;

  @observable
  String pinTemp = '';

  @action
  void setPinTemp(String value) => pinTemp = value;

  @observable
  String confirmPinTemp = '';

  @action
  void setConfirmPinTemp(String value) => confirmPinTemp = value;

  @observable
  String accessCode = '';

  @action
  void setAccessCode(String value) => accessCode = value;

  @observable
  bool invalidAccessCode = false;

  @action
  void setInvalidAccessCode(bool value) => invalidAccessCode = value;

  @observable
  bool isWaitingRecoveryKey = false;

  @action
  void setIsWaitingRecoveryKey(bool value) => isWaitingRecoveryKey = value;

  @observable
  bool isSettingNewPin = false;

  @action
  void setIsSettingNewPin(bool value) => isSettingNewPin = value;

  String encryptedRecoveryKey;

  @observable
  String recoveryCode = '';

  @action
  void setRecoveryCode(String value) => recoveryCode = value;

  @action
  Future<bool> requestRecoveryKey() async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'requestRecoveryKey')..timeout = const Duration(seconds: 30);

    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'user_mail': 'leonardo@custodio.me',
          'random_iv': '145789',
        },
      );

      print(result.data);

      if (result.data != false) {
        print('Recovery Key Encrypted: ${result.data}');
        encryptedRecoveryKey = result.data;
        setIsWaitingRecoveryKey(true);
        // print('Saving ${result.data} with access code $accessCode and pin $pin');
        // await Crypto.saveSaltKey();
        // await Crypto.saveSpKey(accessCode, result.data, pin);
        return true;
      }

      return result.data;
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

  @action
  Future<bool> isRecoveryCodeValid(AppStore appStore) async {
    print('Typed Recovery Code: $recoveryCode');

    bool valid = await Crypto.checkRecoveryKey(encryptedRecoveryKey, recoveryCode, '145789', appStore);
    if (valid == true) {
      return true;
    }
    return false;
  }

  @action
  Future<void> saveNewPin(AppStore appStore) async {
    await Crypto.reSaveSpKey(pin, appStore);
    appStore.setTempEncryptionKey(null);
    pin = null;
    setIsWaitingRecoveryKey(false);
    print('Saved new pin!!!');
  }

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

      if (result.data != false) {
        print('Saving ${result.data} with access code $accessCode and pin $pin');
        await Crypto.saveSaltKey();
        await Crypto.saveSpKey(accessCode, result.data, pin);
        return true;
      }

      return result.data;
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

  @action
  Future<bool> isPinValid(AppStore appStore) async {
    bool valid = await Crypto.checkIsPinValid(pinTemp, appStore);
    return valid;
  }
}
