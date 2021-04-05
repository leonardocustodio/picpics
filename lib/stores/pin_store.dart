import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:get/get.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/managers/crypto_manager.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/screens/tabs_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/widgets/cupertino_input_dialog.dart';
import 'package:picPics/widgets/general_modal.dart';

class PinStore extends GetxController {
  static PinStore get to => Get.find();
  //@observable
  final email = ''.obs;
  String pin = '';
  //@observable
  final pinTemp = ''.obs;
  //@observable
  final confirmPinTemp = ''.obs;
  //@observable
  final accessCode = ''.obs;
  //@observable
  final invalidAccessCode = false.obs;
  //@observable
  final isWaitingRecoveryKey = false.obs;
  //@observable
  final isSettingNewPin = false.obs;
  final isLoading = false.obs;
  //@observable
  final recoveryCode = ''.obs;

  GlobalKey<AnimatorWidgetState> shakeKey = GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> shakeKeyConfirm =
      GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> shakeRecovery =
      GlobalKey<AnimatorWidgetState>();

  //@action
  void setEmail(String value) => email.value = value;

  //@action
  void setPinTemp(String value) => pinTemp.value = value;

  //@action
  void setConfirmPinTemp(String value) => confirmPinTemp.value = value;

  //@action
  void setAccessCode(String value) => accessCode.value = value;

  //@action
  void setInvalidAccessCode(bool value) => invalidAccessCode.value = value;

  //@action
  void setIsWaitingRecoveryKey(bool value) =>
      isWaitingRecoveryKey.value = value;

  //@action
  void setIsSettingNewPin(bool value) => isSettingNewPin.value = value;

  String encryptedRecoveryKey;

  //@action
  void setRecoveryCode(String value) => recoveryCode.value = value;

  String generatedIv;
  void setGeneratedIv(String value) => generatedIv = value;

  //@action
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
        //print('Saving ${result.data} with access ');
        //print('code $accessCode and pin $pin');
        await Crypto.saveSaltKey();
        // await Crypto.saveSpKey(accessCode, result.data, pin);
        return true;
      }

      return result.data;
    } on FirebaseFunctionsException catch (_) {
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

  //@action
  Future<bool> isRecoveryCodeValid(AppStore appStore) async {
    //print('Typed Recovery Code: $recoveryCode');

    bool valid = await Crypto.checkRecoveryKey(
        encryptedRecoveryKey, recoveryCode.value, generatedIv, appStore);
    if (valid == true) {
      return true;
    }
    return false;
  }

  //@action
  Future<void> saveNewPin(AppStore appStore) async {
    await Crypto.reSaveSpKey(pin, appStore);
    appStore.setTempEncryptionKey(null);
    pin = null;
    setIsWaitingRecoveryKey(false);
    //print('Saved new pin!!!');
  }

  //@action
  Future<Map<String, dynamic>> register() async {
    //print('Email: $email - Pin: $pin');

    Map<String, dynamic> result = {};

    final FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    try {
      user = (await auth.createUserWithEmailAndPassword(
        email: email.value,
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

  //@action
  Future<bool> _validateAccessCode(AppStore appStore) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('validateAccessCode');
    //. = const Duration(seconds: 30);

    Random rand = Random();
    int randomNumber = rand.nextInt(900000) + 100000;
    String accessKey = await Crypto.encryptAccessKey(
        accessCode.value, email.value, '$randomNumber');

    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'access_key': accessKey,
          'random_iv': randomNumber,
        },
      );
      //print(result.data);

      if (result.data != false) {
        //print('Saving ${result.data} with access code ');
        //print('$accessCode and pin $pin');
        await Crypto.saveSaltKey();
        await Crypto.saveSpKey(
            accessCode.value, result.data, pin, email.value, appStore);
        return true;
      }

      return result.data;
    } on FirebaseFunctionsException catch (_) {
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

  //@action
  Future<bool> isPinValid(AppStore appStore) async {
    bool valid = await Crypto.checkIsPinValid(pinTemp.value, appStore);
    return valid;
  }

  //@action
  Future<void> activateBiometric(AppStore appStore) async {
    await Crypto.saveEncryptedPin(pinTemp.value, appStore);
  }

  //@action
  Future<bool> isBiometricValidated(AppStore appStore) async {
    String pin = await Crypto.getEncryptedPin(appStore);
    if (pin == null) {
      return false;
    }

    pinTemp.value = pin;
    bool valid = await isPinValid(appStore);
    if (valid == false) {
      return false;
    }

    return true;
  }

  void cancelAuthentication() {
    AppStore.to.biometricAuth.stopAuthentication();
  }

  Future<void> validateAccessCode() async {
    isLoading.value = true;

    bool valid = await _validateAccessCode(AppStore.to);

    setAccessCode('');

    isLoading.value = false;

    if (valid) {
      //print('Is valid: $valid');
      showCreatedKeyModal();
    } else {
      shakeKey.currentState.forward();
      setInvalidAccessCode(true);
      // showErrorModal('The access code you typed is invalid!');
    }
  }

  void askEmail() async {
    //print('asking email');

    TextEditingController alertInputController = TextEditingController();

    //print('showModal');
    showDialog<void>(
      context: Get.context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return CupertinoInputDialog(
          alertInputController: alertInputController,
          title: 'Type your email',
          destructiveButtonTitle: S.current.cancel,
          onPressedDestructive: () {
            Get.back();
          },
          defaultButtonTitle: S.current.ok,
          onPressedDefault: () {
            setEmail(alertInputController.text);
            Get.back();
            recoverPin();
          },
        );
      },
    );
  }

  Future<void> recoverPin() async {
    isLoading.value = true;

    bool request = await requestRecoveryKey(AppStore.to.email ?? email.value);

    isLoading.value = false;

    if (request == true) {
      showErrorModal('We will send an access code soon');
      return;
    }

    showErrorModal('An error has occurred, please try again!');
  }

  void setPinAndPop() {
    AppStore.to.setEmail(email.value);
    AppStore.to.setIsPinRegistered(true);
    AppStore.to.switchSecretPhotos();
    AppStore.to.setWaitingAccessCode(false);

    if (AppStore.to.popPinScreen == PopPinScreenTo.SettingsScreen) {
      Navigator.popUntil(Get.context, ModalRoute.withName(SettingsScreen.id));
    } else {
      Navigator.popUntil(Get.context, ModalRoute.withName(TabsScreen.id));
    }
  }

  void showErrorModal(String message) {
    showDialog<void>(
      context: Get.context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return GeneralModal(
          message: message,
          onPressedDelete: () {
            Get.back();
          },
          onPressedOk: () {
            Get.back();
          },
        );
      },
    );
  }

  void showCreatedKeyModal() {
    showDialog<void>(
      context: Get.context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return GeneralModal(
          message: 'Secret Key successfully created!',
          onPressedDelete: () {
            Get.back();
          },
          onPressedOk: () {
            Get.back();
          },
        );
      },
    ).then((_) {
      setPinAndPop();
    });
  }

  Future<void> authenticate() async {
    try {
      bool authenticated =
          await AppStore.to.biometricAuth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (authenticated == true) {
        bool valid = await isBiometricValidated(AppStore.to);

        if (valid == true) {
          AppStore.to.switchSecretPhotos();
          GalleryStore.to.checkIsLibraryUpdated();
          setPinTemp('');
          setConfirmPinTemp('');
          Get.back();
          return;
        }

        shakeKey.currentState.forward();
        setPinTemp('');
        setConfirmPinTemp('');
      }
    } on PlatformException catch (e) {
      //print(e);
      shakeKey.currentState.forward();
      setPinTemp('');
      setConfirmPinTemp('');
    }
  }
}
