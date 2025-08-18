import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:picpics/managers/crypto_manager.dart';
import 'package:picpics/screens/tabs_screen.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/private_photos_controller.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/cupertino_input_dialog.dart';
import 'package:picpics/widgets/general_modal.dart';

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

    final rand = Random();
    final randomNumber = rand.nextInt(900000) + 100000;
    setGeneratedIv('$randomNumber');

    try {
      final result = await callable.call(
        <String, dynamic>{
          'user_mail': userEmail,
          'random_iv': randomNumber,
        },
      );

      AppLogger.d(result.data);

      if (result.data != false) {
        AppLogger.d('Recovery Key Encrypted: ${result.data}');
        encryptedRecoveryKey = result.data as String;
        setIsWaitingRecoveryKey(true);
        AppLogger.d('Saving ${result.data} with access ');
        AppLogger.d('code $accessCode and pin $pin');
        await Crypto.saveSaltKey();
        // await Crypto.saveSpKey(accessCode, result.data, pin);
        return true;
      }

      return false;
    } on FirebaseFunctionsException catch (e) {
      AppLogger.d(
          'caught firebase functions exception: ${e.message}:${e.details}',);
    } catch (e) {
      AppLogger.d('caught generic exception: $e');
    }

    return false;
  }

  //@action
  Future<bool> isRecoveryCodeValid(UserController appStore) async {
    AppLogger.d('Typed Recovery Code: $recoveryCode');

    final valid = await Crypto.checkRecoveryKey(
        encryptedRecoveryKey, recoveryCode.value, generatedIv, appStore,);
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
    AppLogger.d('Saved new pin!!!');
  }

  //@action
  Future<Map<String, dynamic>> register() async {
    AppLogger.d('Email: $email - Pin: $pin');

    final result = <String, dynamic>{};

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
      AppLogger.d('Error creating user: $error');
      result['success'] = false;
      result['errorCode'] = error;
      return result;
    }

    AppLogger.d('User: $user');
    result['success'] = true;
    return result;
  }

  //@action
  Future<bool> _validateAccessCode(UserController appStore) async {
    final callable =
        FirebaseFunctions.instance.httpsCallable('validateAccessCode');
    //. = const Duration(seconds: 30);

    final rand = Random();
    final randomNumber = rand.nextInt(900000) + 100000;
    final accessKey = await Crypto.encryptAccessKey(
        accessCode.value, email.value, '$randomNumber',);

    try {
      final result = await callable.call(
        <String, dynamic>{
          'access_key': accessKey,
          'random_iv': randomNumber,
        },
      );
      AppLogger.d(result.data);

      if (result.data != false) {
        AppLogger.d('Saving ${result.data} with access code ');
        AppLogger.d('$accessCode and pin $pin');
        await Crypto.saveSaltKey();
        await Crypto.saveSpKey(
            accessCode.value, result.data as String, pin, email.value, appStore,);
        return true;
      }

      return false;
    } on FirebaseFunctionsException catch (e) {
      AppLogger.d('caught firebase functions exception');
      AppLogger.d(e.code);
      AppLogger.d(e.message);
      AppLogger.d(e.details);
    } catch (e) {
      AppLogger.d('caught generic exception');
      AppLogger.d(e);
    }

    return false;
  }

  //@action
  Future<bool> isPinValid() async {
    final valid = await Crypto.checkIsPinValid(pinTemp.value);
    return valid;
  }

  //@action
  Future<void> activateBiometric() async {
    await Crypto.saveEncryptedPin(pinTemp.value);
  }

  //@action
  Future<bool> isBiometricValidated() async {
    final pin = await Crypto.getEncryptedPin();
    if (pin == null) {
      return false;
    }

    pinTemp.value = pin;
    final valid = await isPinValid();
    if (valid == false) {
      return false;
    }

    return true;
  }

  Future<void> cancelAuthentication() async {
    await UserController.to.biometricAuth.stopAuthentication();
  }

  Future<void> validateAccessCode() async {
    isLoading.value = true;

    final valid = await _validateAccessCode(UserController.to);

    setAccessCode('');

    isLoading.value = false;

    if (valid) {
      AppLogger.d('Is valid: $valid');
      showCreatedKeyModal();
    } else {
      shakeKey.currentState?.forward();
      setInvalidAccessCode(true);
      // showErrorModal('The access code you typed is invalid!');
    }
  }

  Future<void> askEmail() async {
    AppLogger.d('asking email');

    final alertInputController = TextEditingController();

    AppLogger.d('showModal');
    await showDialog<void>(
      context: Get.context!,
      builder: (BuildContext buildContext) {
        return Obx(
          () => CupertinoInputDialog(
            alertInputController: alertInputController,
            title: 'Type your email',
            destructiveButtonTitle: LangControl.to.S.value.cancel,
            onPressedDestructive: () {
              Get.back<void>();
            },
            defaultButtonTitle: LangControl.to.S.value.ok,
            onPressedDefault: () {
              setEmail(alertInputController.text);
              Get.back<void>();
              recoverPin();
            },
          ),
        );
      },
    );
  }

  Future<void> recoverPin() async {
    isLoading.value = true;

    final request =
        await requestRecoveryKey(UserController.to.email ?? email.value);

    isLoading.value = false;

    if (request == true) {
      showErrorModal('We will send an access code soon');
      return;
    }

    showErrorModal('An error has occurred, please try again!');
  }

  Future<void> setPinAndPop() async {
    await UserController.to.setEmail(email.value);
    await UserController.to.setIsPinRegistered(true);
    await PrivatePhotosController.to.switchSecretPhotos();
    UserController.to.setWaitingAccessCode(false);

    if (UserController.to.popPinScreenToId != null) {
      await Get.offNamedUntil<void>(UserController.to.popPinScreenToId!,
          ModalRoute.withName(UserController.to.popPinScreenToId!),);
    } else {
      await Get.offAllNamed<void>(TabsScreen.id);
    }
  }

  Future<void> showErrorModal(String message) async {
    await showDialog<void>(
      context: Get.context!,
      builder: (BuildContext buildContext) {
        return GeneralModal(
          message: message,
          onPressedDelete: () {
            Get.back<void>();
          },
          onPressedOk: () {
            Get.back<void>();
          },
        );
      },
    );
  }

  Future<void> showCreatedKeyModal() async {
    await showDialog<void>(
      context: Get.context!,
      builder: (BuildContext buildContext) {
        return GeneralModal(
          message: 'Secret Key successfully created!',
          onPressedDelete: () {
            Get.back<void>();
          },
          onPressedOk: () {
            Get.back<void>();
          },
        );
      },
    ).then((_) {
      setPinAndPop();
    });
  }

  Future<void> authenticate() async {
    try {
      final authenticated = await UserController.to.biometricAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated == true) {
        final valid = await isBiometricValidated();

        if (valid == true) {
          await PrivatePhotosController.to.switchSecretPhotos();
          //GalleryStore.to.checkIsLibraryUpdated();
          setPinTemp('');
          setConfirmPinTemp('');
          Get.back<void>();
          return;
        }

        shakeKey.currentState?.forward();
        setPinTemp('');
        setConfirmPinTemp('');
      }
    } on PlatformException catch (_) {
      AppLogger.d(e);
      shakeKey.currentState?.forward();
      setPinTemp('');
      setConfirmPinTemp('');
    }
  }
}
