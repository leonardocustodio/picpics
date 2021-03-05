import 'dart:math';
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
      //print('autorun');
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

  String generatedIv;
  void setGeneratedIv(String value) => generatedIv = value;

  @action
  Future<bool> requestRecoveryKey(String userEmail) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('requestRecoveryKey');
    //..timeout = const Duration(seconds: 30);

    Random rand = Random();
    int randomNumber = rand.nextInt(900000) + 100000;
    setGeneratedIv('$randomNumber');

    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'user_mail': userEmail,
          'random_iv': randomNumber,
        },
      );

      //print(result.data);

      if (result.data != false) {
        //print('Recovery Key Encrypted: ${result.data}');
        encryptedRecoveryKey = result.data;
        setIsWaitingRecoveryKey(true);
        //print(            'Saving ${result.data} with access code $accessCode and pin $pin');
        // await Crypto.saveSaltKey();
        // await Crypto.saveSpKey(accessCode, result.data, pin);
        return true;
      }

      return result.data;
    } on FirebaseFunctionsException catch (e) {
      //print('caught firebase functions exception');
      //print(e.code);
      //print(e.message);
      //print(e.details);
    } catch (e) {
      //print('caught generic exception');
      //print(e);
    }

    return false;
  }

  @action
  Future<bool> isRecoveryCodeValid(AppStore appStore) async {
    //print('Typed Recovery Code: $recoveryCode');

    bool valid = await Crypto.checkRecoveryKey(
        encryptedRecoveryKey, recoveryCode, generatedIv, appStore);
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
    //print('Saved new pin!!!');
  }

  @action
  Future<Map<String, dynamic>> register() async {
    //print('Email: $email - Pin: $pin');

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
      //print('Error creating user: $error');
      result['success'] = false;
      result['errorCode'] = error.code;
      return result;
    }

    //print('User: $user');
    result['success'] = true;
    return result;
  }

  @action
  Future<bool> validateAccessCode(AppStore appStore) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('validateAccessCode');
    //. = const Duration(seconds: 30);

    Random rand = Random();
    int randomNumber = rand.nextInt(900000) + 100000;
    String accessKey =
        await Crypto.encryptAccessKey(accessCode, email, '$randomNumber');

    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'access_key': accessKey,
          'random_iv': randomNumber,
        },
      );
      //print(result.data);

      if (result.data != false) {
        //print(            'Saving ${result.data} with access code $accessCode and pin $pin');
        await Crypto.saveSaltKey();
        await Crypto.saveSpKey(accessCode, result.data, pin, email, appStore);
        return true;
      }

      return result.data;
    } on FirebaseFunctionsException catch (e) {
      //print('caught firebase functions exception');
      //print(e.code);
      //print(e.message);
      //print(e.details);
    } catch (e) {
      //print('caught generic exception');
      //print(e);
    }

    return false;
  }

  @action
  Future<bool> isPinValid(AppStore appStore) async {
    bool valid = await Crypto.checkIsPinValid(pinTemp, appStore);
    return valid;
  }

  @action
  Future<void> activateBiometric(AppStore appStore) async {
    await Crypto.saveEncryptedPin(pinTemp, appStore);
  }

  @action
  Future<bool> isBiometricValidated(AppStore appStore) async {
    String pin = await Crypto.getEncryptedPin(appStore);
    if (pin == null) {
      return false;
    }

    pinTemp = pin;
    bool valid = await isPinValid(appStore);
    if (valid == false) {
      return false;
    }

    return true;
  }
}
