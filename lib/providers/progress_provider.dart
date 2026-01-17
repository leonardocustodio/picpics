import 'package:flutter_riverpod/legacy.dart';

/// Progress dialog state for showing loading/progress indicators
class ProgressState {

  const ProgressState({
    this.total = 0.0,
    this.value = 0.0,
    this.show = false,
    this.text,
  });
  final double total;
  final double value;
  final bool show;
  final String? text;

  ProgressState copyWith({
    double? total,
    double? value,
    bool? show,
    String? text,
  }) {
    return ProgressState(
      total: total ?? this.total,
      value: value ?? this.value,
      show: show ?? this.show,
      text: text ?? this.text,
    );
  }
}

/// Notifier for progress dialog state
/// Handles showing/hiding progress indicators and updating progress values
class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier() : super(const ProgressState());

  void start(double totalLength, [String? showingText]) {
    if (!state.show) {
      state = state.copyWith(
        text: showingText,
        value: 0,
        total: totalLength,
        show: true,
      );
    }
  }

  void increaseValue(double val) {
    if ((state.value + val) < state.total) {
      state = state.copyWith(value: state.value + val);
    } else {
      stop();
    }
  }

  void stop() {
    if (state.show) {
      state = state.copyWith(
        show: false,
        value: 0,
      );
    }
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});
