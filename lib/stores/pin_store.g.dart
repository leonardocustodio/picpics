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

  final _$pinAtom = Atom(name: '_PinStore.pin');

  @override
  String get pin {
    _$pinAtom.reportRead();
    return super.pin;
  }

  @override
  set pin(String value) {
    _$pinAtom.reportWrite(value, super.pin, () {
      super.pin = value;
    });
  }

  final _$confirmPinAtom = Atom(name: '_PinStore.confirmPin');

  @override
  String get confirmPin {
    _$confirmPinAtom.reportRead();
    return super.confirmPin;
  }

  @override
  set confirmPin(String value) {
    _$confirmPinAtom.reportWrite(value, super.confirmPin, () {
      super.confirmPin = value;
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

  final _$registerAsyncAction = AsyncAction('_PinStore.register');

  @override
  Future<bool> register() {
    return _$registerAsyncAction.run(() => super.register());
  }

  final _$validateAccessCodeAsyncAction =
      AsyncAction('_PinStore.validateAccessCode');

  @override
  Future<bool> validateAccessCode() {
    return _$validateAccessCodeAsyncAction
        .run(() => super.validateAccessCode());
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
  void setPin(String value) {
    final _$actionInfo =
        _$_PinStoreActionController.startAction(name: '_PinStore.setPin');
    try {
      return super.setPin(value);
    } finally {
      _$_PinStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmPin(String value) {
    final _$actionInfo = _$_PinStoreActionController.startAction(
        name: '_PinStore.setConfirmPin');
    try {
      return super.setConfirmPin(value);
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
  String toString() {
    return '''
email: ${email},
pin: ${pin},
confirmPin: ${confirmPin},
accessCode: ${accessCode}
    ''';
  }
}
