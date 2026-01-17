import 'package:flutter_riverpod/legacy.dart';

class PinState {

  PinState({
    this.pin = '',
    this.isPinSet = false,
    this.isAuthenticated = false,
    this.failedAttempts = 0,
  });
  final String pin;
  final bool isPinSet;
  final bool isAuthenticated;
  final int failedAttempts;

  PinState copyWith({
    String? pin,
    bool? isPinSet,
    bool? isAuthenticated,
    int? failedAttempts,
  }) {
    return PinState(
      pin: pin ?? this.pin,
      isPinSet: isPinSet ?? this.isPinSet,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      failedAttempts: failedAttempts ?? this.failedAttempts,
    );
  }
}

class PinNotifier extends StateNotifier<PinState> {
  PinNotifier() : super(PinState());

  void setPin(String pin) {
    state = state.copyWith(pin: pin, isPinSet: true);
  }

  bool verifyPin(String enteredPin) {
    if (enteredPin == state.pin) {
      state = state.copyWith(isAuthenticated: true, failedAttempts: 0);
      return true;
    } else {
      state = state.copyWith(failedAttempts: state.failedAttempts + 1);
      return false;
    }
  }

  void resetAuthentication() {
    state = state.copyWith(isAuthenticated: false);
  }

  void clearPin() {
    state = PinState();
  }
}

final pinProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  return PinNotifier();
});
