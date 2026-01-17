import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/managers/crypto_manager.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/private_photos_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/tabs_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/cupertino_input_dialog.dart';
import 'package:picpics/widgets/general_modal.dart';

class PinFullState {
  final String email;
  final String pinTemp;
  final String confirmPinTemp;
  final String accessCode;
  final bool invalidAccessCode;
  final bool isWaitingRecoveryKey;
  final bool isSettingNewPin;
  final bool isLoading;
  final String recoveryCode;
  final String encryptedRecoveryKey;
  final String generatedIv;
  final String pin; // Internal pin storage

  PinFullState({
    this.email = '',
    this.pinTemp = '',
    this.confirmPinTemp = '',
    this.accessCode = '',
    this.invalidAccessCode = false,
    this.isWaitingRecoveryKey = false,
    this.isSettingNewPin = false,
    this.isLoading = false,
    this.recoveryCode = '',
    this.encryptedRecoveryKey = '',
    this.generatedIv = '',
    this.pin = '',
  });

  PinFullState copyWith({
    String? email,
    String? pinTemp,
    String? confirmPinTemp,
    String? accessCode,
    bool? invalidAccessCode,
    bool? isWaitingRecoveryKey,
    bool? isSettingNewPin,
    bool? isLoading,
    String? recoveryCode,
    String? encryptedRecoveryKey,
    String? generatedIv,
    String? pin,
  }) {
    return PinFullState(
      email: email ?? this.email,
      pinTemp: pinTemp ?? this.pinTemp,
      confirmPinTemp: confirmPinTemp ?? this.confirmPinTemp,
      accessCode: accessCode ?? this.accessCode,
      invalidAccessCode: invalidAccessCode ?? this.invalidAccessCode,
      isWaitingRecoveryKey: isWaitingRecoveryKey ?? this.isWaitingRecoveryKey,
      isSettingNewPin: isSettingNewPin ?? this.isSettingNewPin,
      isLoading: isLoading ?? this.isLoading,
      recoveryCode: recoveryCode ?? this.recoveryCode,
      encryptedRecoveryKey: encryptedRecoveryKey ?? this.encryptedRecoveryKey,
      generatedIv: generatedIv ?? this.generatedIv,
      pin: pin ?? this.pin,
    );
  }
}

class PinFullNotifier extends StateNotifier<PinFullState> {
  final Ref ref;

  GlobalKey<AnimatorWidgetState> shakeKey = GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> shakeKeyConfirm =
      GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> shakeRecovery =
      GlobalKey<AnimatorWidgetState>();

  PinFullNotifier(this.ref) : super(PinFullState());

  void setEmail(String value) => state = state.copyWith(email: value);
  void setPinTemp(String value) => state = state.copyWith(pinTemp: value);
  void setConfirmPinTemp(String value) =>
      state = state.copyWith(confirmPinTemp: value);
  void setAccessCode(String value) => state = state.copyWith(accessCode: value);
  void setInvalidAccessCode(bool value) =>
      state = state.copyWith(invalidAccessCode: value);
  void setIsWaitingRecoveryKey(bool value) =>
      state = state.copyWith(isWaitingRecoveryKey: value);
  void setIsSettingNewPin(bool value) =>
      state = state.copyWith(isSettingNewPin: value);
  void setRecoveryCode(String value) =>
      state = state.copyWith(recoveryCode: value);
  void setGeneratedIv(String value) =>
      state = state.copyWith(generatedIv: value);
  void setPin(String value) => state = state.copyWith(pin: value);

  Future<bool> requestRecoveryKey(String userEmail) async {
    final callable =
        FirebaseFunctions.instance.httpsCallable('requestRecoveryKey');

    final rand = Random();
    final randomNumber = rand.nextInt(900000) + 100000;
    setGeneratedIv('$randomNumber');

    try {
      final result = await callable.call<Map<String, dynamic>>(
        <String, dynamic>{
          'user_mail': userEmail,
          'random_iv': randomNumber,
        },
      );

      AppLogger.d(result.data);

      // ignore: unnecessary_type_check
      if (result.data is Map && (result.data as Map).isNotEmpty) {
        AppLogger.d('Recovery Key Encrypted: ${result.data}');
        state = state.copyWith(encryptedRecoveryKey: result.data as String);
        setIsWaitingRecoveryKey(true);
        await Crypto.saveSaltKey();
        return true;
      }

      return false;
    } on FirebaseFunctionsException catch (e) {
      AppLogger.d(
          'caught firebase functions exception: ${e.message}:${e.details}');
    } catch (e) {
      AppLogger.d('caught generic exception: $e');
    }

    return false;
  }

  Future<bool> isRecoveryCodeValid() async {
    AppLogger.d('Typed Recovery Code: ${state.recoveryCode}');

    // TODO(Week 3D): Update Crypto.checkRecoveryKey to accept UserNotifier/UserState
    // For now, return false as placeholder until Crypto manager is migrated
    AppLogger.w(
        'Recovery key validation temporarily disabled - requires Crypto manager migration');
    return false;

    // Original code (commented until Crypto migration):
    // final userState = ref.read(userProvider);
    // final valid = await Crypto.checkRecoveryKey(
    //   state.encryptedRecoveryKey,
    //   state.recoveryCode,
    //   state.generatedIv,
    //   userState, // Needs UserController
    // );
    // return valid;
  }

  Future<void> saveNewPin() async {
    // TODO(Week 3D): Update Crypto.reSaveSpKey to accept UserNotifier/UserState
    // Temporarily skip encryption key operations until Crypto manager is migrated
    AppLogger.w(
        'PIN save temporarily simplified - requires Crypto manager migration');

    // Reset state
    setPin('');
    setIsWaitingRecoveryKey(false);
    AppLogger.d('Saved new pin (simplified)!!!');

    // Original code (commented until Crypto migration):
    // final userNotifier = ref.read(userProvider.notifier);
    // await Crypto.reSaveSpKey(state.pin, ref.read(userProvider)); // Needs UserController
    // userNotifier.setTempEncryptionKey(null); // Method doesn't exist yet
    // setPin('');
    // setIsWaitingRecoveryKey(false);
    // AppLogger.d('Saved new pin!!!');
  }

  Future<Map<String, dynamic>> register() async {
    AppLogger.d('Email: ${state.email} - Pin: ${state.pin}');

    final result = <String, dynamic>{};
    final auth = FirebaseAuth.instance;
    User? user;

    try {
      user = (await auth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.pin,
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

  Future<bool> _validateAccessCode() async {
    final callable =
        FirebaseFunctions.instance.httpsCallable('validateAccessCode');

    final rand = Random();
    final randomNumber = rand.nextInt(900000) + 100000;
    final accessKey = await Crypto.encryptAccessKey(
      state.accessCode,
      state.email,
      '$randomNumber',
    );

    try {
      final result = await callable.call<Map<String, dynamic>>(
        <String, dynamic>{
          'access_key': accessKey,
          'random_iv': randomNumber,
        },
      );
      AppLogger.d(result.data);

      // ignore: unnecessary_type_check
      if (result.data is Map && (result.data as Map).isNotEmpty) {
        await Crypto.saveSaltKey();
        // TODO(Week 3D): Update Crypto.saveSpKey to accept UserNotifier/UserState
        AppLogger.w(
            'Access code validation simplified - requires Crypto manager migration');
        // await Crypto.saveSpKey(
        //   state.accessCode,
        //   result.data as String,
        //   state.pin,
        //   state.email,
        //   ref.read(userProvider), // Needs UserController
        // );
        return true;
      }

      return false;
    } on FirebaseFunctionsException catch (e) {
      AppLogger.d(
          'caught firebase functions exception: ${e.code}:${e.message}:${e.details}');
    } catch (e) {
      AppLogger.d('caught generic exception: $e');
    }

    return false;
  }

  Future<bool> isPinValid() async {
    final userState = ref.read(userProvider);
    final encryptionKey =
        await Crypto.checkIsPinValid(state.pinTemp, userState.email ?? '');
    return encryptionKey != null;
  }

  Future<void> activateBiometric() async {
    final secretKey = await Crypto.saveEncryptedPin(state.pinTemp);
    if (secretKey != null) {
      // Store the secret key if needed
      // TODO: Store secretKey in user provider or secure storage
    }
  }

  Future<bool> isBiometricValidated() async {
    // TODO: Get secretString from secure storage or user provider
    final pin = await Crypto.getEncryptedPin(null);
    if (pin == null) {
      return false;
    }

    setPinTemp(pin);
    final valid = await isPinValid();
    return valid;
  }

  Future<void> cancelAuthentication() async {
    final userNotifier = ref.read(userProvider.notifier);
    await userNotifier.biometricAuth.stopAuthentication();
  }

  Future<void> validateAccessCode() async {
    state = state.copyWith(isLoading: true);
    final valid = await _validateAccessCode();
    setAccessCode('');
    state = state.copyWith(isLoading: false);

    if (valid) {
      AppLogger.d('Is valid: $valid');
    } else {
      shakeKey.currentState?.forward();
      setInvalidAccessCode(true);
    }
  }

  Future<void> askEmail(BuildContext context) async {
    final alertInputController = TextEditingController();
    final s = ref.read(sProvider);

    await showDialog<void>(
      context: context,
      builder: (buildContext) {
        return CupertinoInputDialog(
          alertInputController: alertInputController,
          title: 'Type your email',
          destructiveButtonTitle: s.cancel,
          onPressedDestructive: () => Navigator.of(buildContext).pop(),
          defaultButtonTitle: s.ok,
          onPressedDefault: () {
            setEmail(alertInputController.text);
            Navigator.of(buildContext).pop();
            recoverPin();
          },
        );
      },
    );
  }

  Future<void> recoverPin() async {
    state = state.copyWith(isLoading: true);
    final userState = ref.read(userProvider);
    await requestRecoveryKey(userState.email ?? state.email);
    state = state.copyWith(isLoading: false);
  }

  Future<void> setPinAndPop(BuildContext context, {String? popToId}) async {
    final userNotifier = ref.read(userProvider.notifier);
    userNotifier.setEmail(state.email);
    userNotifier.setIsPinRegistered(true);
    ref.read(privatePhotosProvider.notifier).toggleShowPrivate();
    userNotifier.setWaitingAccessCode(false);

    if (popToId != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(popToId, ModalRoute.withName(popToId));
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(TabsScreen.id, (route) => false);
    }
  }

  Future<void> showErrorModal(BuildContext context, String message) async {
    await showDialog<void>(
      context: context,
      builder: (buildContext) {
        return GeneralModal(
          message: message,
          onPressedDelete: () => Navigator.of(buildContext).pop(),
          onPressedOk: () => Navigator.of(buildContext).pop(),
        );
      },
    );
  }

  Future<void> showCreatedKeyModal(BuildContext context,
      {String? popToId}) async {
    await showDialog<void>(
      context: context,
      builder: (buildContext) {
        return GeneralModal(
          message: 'Secret Key successfully created!',
          onPressedDelete: () => Navigator.of(buildContext).pop(),
          onPressedOk: () => Navigator.of(buildContext).pop(),
        );
      },
    );

    if (!context.mounted) return;
    await setPinAndPop(context, popToId: popToId);
  }

  Future<void> authenticate() async {
    final userNotifier = ref.read(userProvider.notifier);

    try {
      final authenticated = await userNotifier.biometricAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
      );

      if (authenticated == true) {
        final valid = await isBiometricValidated();

        if (valid == true) {
          ref.read(privatePhotosProvider.notifier).toggleShowPrivate();
          setPinTemp('');
          setConfirmPinTemp('');
          return;
        }

        shakeKey.currentState?.forward();
        setPinTemp('');
        setConfirmPinTemp('');
      }
    } on PlatformException catch (e) {
      AppLogger.d(e);
      shakeKey.currentState?.forward();
      setPinTemp('');
      setConfirmPinTemp('');
    }
  }

  Future<void> checkBiometricOnReady() async {
    final userState = ref.read(userProvider);
    if (userState.isPinRegistered && userState.isBiometricActivated) {
      await authenticate();
    }
  }
}

final pinFullProvider =
    StateNotifierProvider<PinFullNotifier, PinFullState>((ref) {
  return PinFullNotifier(ref);
});
