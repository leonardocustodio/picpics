// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PinStore on _PinStore, Store {
  final _$emailAtom = Atom(name: '_PinStore.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$pinTempAtom = Atom(name: '_PinStore.pinTemp');

  @override
  String get pinTemp {
    _$pinTempAtom.reportRead();
    return super.pinTemp;
  }

  @override
  set pinTemp(String value) {
    _$pinTempAtom.reportWrite(value, super.pinTemp, () {
      super.pinTemp = value;
    });
  }

  final _$confirmPinTempAtom = Atom(name: '_PinStore.confirmPinTemp');

  @override
  String get confirmPinTemp {
    _$confirmPinTempAtom.reportRead();
    return super.confirmPinTemp;
  }

  @override
  set confirmPinTemp(String value) {
    _$confirmPinTempAtom.reportWrite(value, super.confirmPinTemp, () {
      super.confirmPinTemp = value;
    });
  }

  final _$accessCodeAtom = Atom(name: '_PinStore.accessCode');

  @override
  String get accessCode {
    _$accessCodeAtom.reportRead();
    return super.accessCode;
  }

  @override
  set accessCode(String value) {
    _$accessCodeAtom.reportWrite(value, super.accessCode, () {
      super.accessCode = value;
    });
  }

  final _$invalidAccessCodeAtom = Atom(name: '_PinStore.invalidAccessCode');

  @override
  bool get invalidAccessCode {
    _$invalidAccessCodeAtom.reportRead();
    return super.invalidAccessCode;
  }

  @override
  set invalidAccessCode(bool value) {
    _$invalidAccessCodeAtom.reportWrite(value, super.invalidAccessCode, () {
      super.invalidAccessCode = value;
    });
  }

  final _$isWaitingRecoveryKeyAtom =
      Atom(name: '_PinStore.isWaitingRecoveryKey');

  @override
  bool get isWaitingRecoveryKey {
    _$isWaitingRecoveryKeyAtom.reportRead();
    return super.isWaitingRecoveryKey;
  }

  @override
  set isWaitingRecoveryKey(bool value) {
    _$isWaitingRecoveryKeyAtom.reportWrite(value, super.isWaitingRecoveryKey,
        () {
      super.isWaitingRecoveryKey = value;
    });
  }

  final _$isSettingNewPinAtom = Atom(name: '_PinStore.isSettingNewPin');

  @override
  bool get isSettingNewPin {
    _$isSettingNewPinAtom.reportRead();
    return super.isSettingNewPin;
  }

  @override
  set isSettingNewPin(bool value) {
    _$isSettingNewPinAtom.reportWrite(value, super.isSettingNewPin, () {
      super.isSettingNewPin = value;
    });
  }

  final _$recoveryCodeAtom = Atom(name: '_PinStore.recoveryCode');

  @override
  String get recoveryCode {
    _$recoveryCodeAtom.reportRead();
    return super.recoveryCode;
  }

  @override
  set recoveryCode(String value) {
    _$recoveryCodeAtom.reportWrite(value, super.recoveryCode, () {
      super.recoveryCode = value;
    });
  }

  final _$requestRecoveryKeyAsyncAction =
      AsyncAction('_PinStore.requestRecoveryKey');

  @override
  Future<bool> requestRecoveryKey(String userEmail) {
    return _$requestRecoveryKeyAsyncAction
        .run(() => super.requestRecoveryKey(userEmail));
  }

  final _$isRecoveryCodeValidAsyncAction =
      AsyncAction('_PinStore.isRecoveryCodeValid');

  @override
  Future<bool> isRecoveryCodeValid(AppStore appStore) {
    return _$isRecoveryCodeValidAsyncAction
        .run(() => super.isRecoveryCodeValid(appStore));
  }

  final _$saveNewPinAsyncAction = AsyncAction('_PinStore.saveNewPin');

  @override
  Future<void> saveNewPin(AppStore appStore) {
    return _$saveNewPinAsyncAction.run(() => super.saveNewPin(appStore));
  }

  final _$registerAsyncAction = AsyncAction('_PinStore.register');

  @override
  Future<Map<String, dynamic>> register() {
    return _$registerAsyncAction.run(() => super.register());
  }

  final _$validateAccessCodeAsyncAction =
      AsyncAction('_PinStore.validateAccessCode');

  @override
  Future<bool> validateAccessCode(AppStore appStore) {
    return _$validateAccessCodeAsyncAction
        .run(() => super.validateAccessCode(appStore));
  }

  final _$isPinValidAsyncAction = AsyncAction('_PinStore.isPinValid');

  @override
  Future<bool> isPinValid(AppStore appStore) {
    return _$isPinValidAsyncAction.run(() => super.isPinValid(appStore));
  }

  final _$activateBiometricAsyncAction =
      AsyncAction('_PinStore.activateBiometric');

  @override
  Future<void> activateBiometric(AppStore appStore) {
    return _$activateBiometricAsyncAction
        .run(() => super.activateBiometric(appStore));
  }

  final _$isBiometricValidatedAsyncAction =
      AsyncAction('_PinStore.isBiometricValidated');

  @override
  Future<bool> isBiometricValidated(AppStore appStore) {
    return _$isBiometricValidatedAsyncAction
        .run(() => super.isBiometricValidated(appStore));
  }

  final _$_PinStoreActionController = ActionController(name: '_PinStore');

  @override
  void setEmail(String value) {
    final _$actionInfo =
        _$_PinStoreActionController.startAction(name: '_PinStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPinTemp(String value) {
    final _$actionInfo =
        _$_PinStoreActionController.startAction(name: '_PinStore.setPinTemp');
    try {
      return super.setPinTemp(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmPinTemp(String value) {
    final _$actionInfo = _$_PinStoreActionController.startAction(
        name: '_PinStore.setConfirmPinTemp');
    try {
      return super.setConfirmPinTemp(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAccessCode(String value) {
    final _$actionInfo = _$_PinStoreActionController.startAction(
        name: '_PinStore.setAccessCode');
    try {
      return super.setAccessCode(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInvalidAccessCode(bool value) {
    final _$actionInfo = _$_PinStoreActionController.startAction(
        name: '_PinStore.setInvalidAccessCode');
    try {
      return super.setInvalidAccessCode(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsWaitingRecoveryKey(bool value) {
    final _$actionInfo = _$_PinStoreActionController.startAction(
        name: '_PinStore.setIsWaitingRecoveryKey');
    try {
      return super.setIsWaitingRecoveryKey(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsSettingNewPin(bool value) {
    final _$actionInfo = _$_PinStoreActionController.startAction(
        name: '_PinStore.setIsSettingNewPin');
    try {
      return super.setIsSettingNewPin(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRecoveryCode(String value) {
    final _$actionInfo = _$_PinStoreActionController.startAction(
        name: '_PinStore.setRecoveryCode');
    try {
      return super.setRecoveryCode(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
pinTemp: ${pinTemp},
confirmPinTemp: ${confirmPinTemp},
accessCode: ${accessCode},
invalidAccessCode: ${invalidAccessCode},
isWaitingRecoveryKey: ${isWaitingRecoveryKey},
isSettingNewPin: ${isSettingNewPin},
recoveryCode: ${recoveryCode}
    ''';
  }
}
