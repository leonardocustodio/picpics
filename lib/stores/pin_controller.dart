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
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/widgets/cupertino_input_dialog.dart';
import 'package:picPics/widgets/general_modal.dart';

class PinController extends GetxController {
  static PinController get to => Get.find();
  //@observable
  final email = Rx<String>('');
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
  @override
  void onReady() {
    super.onReady();
    if (UserController.to.isPinRegistered.value == true &&
        UserController.to.isBiometricActivated.value == true) {
      authenticate();
    }
  }

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

  String encryptedRecoveryKey = '';

  //@action
  void setRecoveryCode(String value) => recoveryCode.value = value;

  String generatedIv = '';
  void setGeneratedIv(String value) => generatedIv = value;

  //@action
  Future<bool> requestRecoveryKey(String userEmail) async {
    final callable =
        FirebaseFunctions.instance.httpsCallable('requestRecoveryKey');
    //..timeout = const Duration(seconds: 30);

    var rand = Random();
    var randomNumber = rand.nextInt(900000) + 100000;
    setGeneratedIv('$randomNumber');

    try {
      final result = await callable.call(
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
  Future<bool> isRecoveryCodeValid(UserController appStore) async {
    //print('Typed Recovery Code: $recoveryCode');

    var valid = await Crypto.checkRecoveryKey(
        encryptedRecoveryKey, recoveryCode.value, generatedIv, appStore);
    if (valid == true) {
      return true;
    }
    return false;
  }

  //@action
  Future<void> saveNewPin(UserController appStore) async {
    await Crypto.reSaveSpKey(pin, appStore);
    appStore.setTempEncryptionKey(null);
    pin = '';
    setIsWaitingRecoveryKey(false);
    //print('Saved new pin!!!');
  }

  //@action
  Future<Map<String, dynamic>> register() async {
    //print('Email: $email - Pin: $pin');

    var result = <String, dynamic>{};

    final auth = FirebaseAuth.instance;
    User? user;

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
      result['errorCode'] = error;
      return result;
    }

    //print('User: $user');
    result['success'] = true;
    return result;
  }

  //@action
  Future<bool> _validateAccessCode(UserController appStore) async {
    final callable =
        FirebaseFunctions.instance.httpsCallable('validateAccessCode');
    //. = const Duration(seconds: 30);

    var rand = Random();
    var randomNumber = rand.nextInt(900000) + 100000;
    var accessKey = await Crypto.encryptAccessKey(
        accessCode.value, email.value, '$randomNumber');

    try {
      final result = await callable.call(
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
  Future<bool> isPinValid(UserController appStore) async {
    var valid = await Crypto.checkIsPinValid(pinTemp.value, appStore);
    return valid;
  }

  //@action
  Future<void> activateBiometric(UserController appStore) async {
    await Crypto.saveEncryptedPin(pinTemp.value, appStore);
  }

  //@action
  Future<bool> isBiometricValidated(UserController appStore) async {
    var pin = await Crypto.getEncryptedPin(appStore);
    if (pin == null) {
      return false;
    }

    pinTemp.value = pin;
    var valid = await isPinValid(appStore);
    if (valid == false) {
      return false;
    }

    return true;
  }

  void cancelAuthentication() async {
    await UserController.to.biometricAuth.stopAuthentication();
  }

  Future<void> validateAccessCode() async {
    isLoading.value = true;

    var valid = await _validateAccessCode(UserController.to);

    setAccessCode('');

    isLoading.value = false;

    if (valid) {
      //print('Is valid: $valid');
      showCreatedKeyModal();
    } else {
      shakeKey.currentState?.forward();
      setInvalidAccessCode(true);
      // showErrorModal('The access code you typed is invalid!');
    }
  }

  void askEmail() async {
    //print('asking email');

    var alertInputController = TextEditingController();

    //print('showModal');
    await showDialog<void>(
      context: Get.context!,
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

    var request =
        await requestRecoveryKey(UserController.to.email ?? email.value);

    isLoading.value = false;

    if (request == true) {
      showErrorModal('We will send an access code soon');
      return;
    }

    showErrorModal('An error has occurred, please try again!');
  }

  void setPinAndPop() async {
    await UserController.to.setEmail(email.value);
    await UserController.to.setIsPinRegistered(true);
    await PrivatePhotosController.to.switchSecretPhotos();
    UserController.to.setWaitingAccessCode(false);

    if (UserController.to.popPinScreen == PopPinScreenTo.SettingsScreen) {
      Navigator.popUntil(Get.context!, ModalRoute.withName(SettingsScreen.id));
    } else {
      Navigator.popUntil(Get.context!, ModalRoute.withName(TabsScreen.id));
    }
  }

  void showErrorModal(String message) async {
    await showDialog<void>(
      context: Get.context!,
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

  void showCreatedKeyModal() async {
    await showDialog<void>(
      context: Get.context!,
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
      var authenticated = await UserController.to.biometricAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        biometricOnly: true,
        stickyAuth: true,
      );

      if (authenticated == true) {
        var valid = await isBiometricValidated(UserController.to);

        if (valid == true) {
          await PrivatePhotosController.to.switchSecretPhotos();
          //GalleryStore.to.checkIsLibraryUpdated();
          setPinTemp('');
          setConfirmPinTemp('');
          Get.back();
          return;
        }

        shakeKey.currentState?.forward();
        setPinTemp('');
        setConfirmPinTemp('');
      }
    } on PlatformException catch (_) {
      //print(e);
      shakeKey.currentState?.forward();
      setPinTemp('');
      setConfirmPinTemp('');
    }
  }
}
