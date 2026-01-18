import 'dart:async';
import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:picpics/managers/crypto_manager.dart';
import 'package:picpics/providers/encryption_key_provider.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/private_photos_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/tabs_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/cupertino_input_dialog.dart';
import 'package:picpics/widgets/general_modal.dart';

class PinFullState {
  // Internal pin storage

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
  final String pin;

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
  PinFullNotifier(this.ref) : super(PinFullState());
  final Ref ref;

  GlobalKey<AnimatorWidgetState> shakeKey = GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> shakeKeyConfirm = GlobalKey<AnimatorWidgetState>();
  GlobalKey<AnimatorWidgetState> shakeRecovery = GlobalKey<AnimatorWidgetState>();

  void setEmail(String value) => state = state.copyWith(email: value);
  void setPinTemp(String value) => state = state.copyWith(pinTemp: value);
  void setConfirmPinTemp(String value) => state = state.copyWith(confirmPinTemp: value);
  void setAccessCode(String value) => state = state.copyWith(accessCode: value);
  void setInvalidAccessCode({required bool value}) => state = state.copyWith(invalidAccessCode: value);
  void setIsWaitingRecoveryKey({required bool value}) => state = state.copyWith(isWaitingRecoveryKey: value);
  void setIsSettingNewPin({required bool value}) => state = state.copyWith(isSettingNewPin: value);
  void setRecoveryCode(String value) => state = state.copyWith(recoveryCode: value);
  void setGeneratedIv(String value) => state = state.copyWith(generatedIv: value);
  void setPin(String value) => state = state.copyWith(pin: value);

  Future<bool> requestRecoveryKey(String userEmail) async {
    final callable = FirebaseFunctions.instance.httpsCallable('requestRecoveryKey');

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
        setIsWaitingRecoveryKey(value: true);
        await Crypto.saveSaltKey();
        return true;
      }

      return false;
    } on FirebaseFunctionsException catch (e) {
      AppLogger.d('caught firebase functions exception: ${e.message}:${e.details}');
    } on Exception catch (e) {
      AppLogger.d('caught generic exception: $e');
    }

    return false;
  }

  Future<bool> isRecoveryCodeValid() async {
    AppLogger.d('Typed Recovery Code: ${state.recoveryCode}');

    try {
      final decryptedKeyString = await Crypto.checkRecoveryKey(
        state.encryptedRecoveryKey,
        state.recoveryCode,
        state.generatedIv,
      );

      if (decryptedKeyString == null) {
        AppLogger.d('Recovery key validation failed');
        return false;
      }

      // Store the temp encryption key string for PIN re-save
      ref.read(encryptionKeyProvider.notifier).setTempEncryptionKey(decryptedKeyString);
      AppLogger.d('Recovery key validated successfully');
      return true;
    } on Exception catch (e) {
      AppLogger.e('Error validating recovery code: $e');
      return false;
    }
  }

  Future<void> saveNewPin() async {
    final userState = ref.read(userProvider);
    final encryptionKeyState = ref.read(encryptionKeyProvider);

    final tempKeyString = encryptionKeyState.tempEncryptionKeyString;
    if (tempKeyString == null) {
      AppLogger.e('Cannot save new PIN - no temp encryption key available');
      return;
    }

    final encryptionKey = encryptionKeyState.encryptionKey;
    if (encryptionKey == null) {
      AppLogger.e('Cannot save new PIN - no encryption key available');
      return;
    }

    try {
      await Crypto.reSaveSpKey(
        state.pin,
        userState.email ?? '',
        tempKeyString,
        encryptionKey,
      );

      // Clear temp encryption key after saving
      ref.read(encryptionKeyProvider.notifier).setTempEncryptionKey(null);

      // Reset state
      setPin('');
      setIsWaitingRecoveryKey(value: false);
      AppLogger.d('Saved new PIN successfully!');
    } on Exception catch (e) {
      AppLogger.e('Error saving new PIN: $e');
    }
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
    } on Exception catch (error) {
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
    final callable = FirebaseFunctions.instance.httpsCallable('validateAccessCode');

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

        // Save the encryption key
        final encryptionKey = await Crypto.saveSpKey(
          state.accessCode,
          result.data['spkey'] as String? ?? '',
          state.pin,
          state.email,
        );

        // Store the encryption key in the provider
        ref.read(encryptionKeyProvider.notifier).setEncryptionKey(encryptionKey);
        AppLogger.d('Access code validated and encryption key stored');
        return true;
      }

      return false;
    } on FirebaseFunctionsException catch (e) {
      AppLogger.d('caught firebase functions exception: ${e.code}:${e.message}:${e.details}');
    } on Exception catch (e) {
      AppLogger.d('caught generic exception: $e');
    }

    return false;
  }

  Future<bool> isPinValid() async {
    final userState = ref.read(userProvider);
    final encryptionKey = await Crypto.checkIsPinValid(state.pinTemp, userState.email ?? '');

    if (encryptionKey != null) {
      // Store the encryption key for use in pic_store_provider
      ref.read(encryptionKeyProvider.notifier).setEncryptionKey(encryptionKey);
      return true;
    }

    return false;
  }

  Future<void> activateBiometric() async {
    final secretKey = await Crypto.saveEncryptedPin(state.pinTemp);
    if (secretKey != null) {
      // Store the secret key in secure storage for biometric authentication
      const storage = FlutterSecureStorage();
      await storage.write(key: 'biometric_secret', value: secretKey);
      AppLogger.d('Biometric secret key stored');
    }
  }

  Future<bool> isBiometricValidated() async {
    // Get secret string from secure storage
    const storage = FlutterSecureStorage();
    final secretString = await storage.read(key: 'biometric_secret');

    final pin = await Crypto.getEncryptedPin(secretString);
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
      setInvalidAccessCode(value: true);
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
            unawaited(recoverPin());
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
    ref.read(userProvider.notifier)
      ..setEmail(state.email)
      ..setIsPinRegistered(value: true)
      ..setWaitingAccessCode(value: false);
    ref.read(privatePhotosProvider.notifier).toggleShowPrivate();

    if (popToId != null) {
      unawaited(Navigator.of(context).pushNamedAndRemoveUntil(popToId, ModalRoute.withName(popToId)));
    } else {
      unawaited(Navigator.of(context).pushNamedAndRemoveUntil(TabsScreen.id, (route) => false));
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

  Future<void> showCreatedKeyModal(BuildContext context, {String? popToId}) async {
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

      if (authenticated) {
        final valid = await isBiometricValidated();

        if (valid) {
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

final pinFullProvider = StateNotifierProvider<PinFullNotifier, PinFullState>((ref) {
  return PinFullNotifier(ref);
});
