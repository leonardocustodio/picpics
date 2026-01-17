import 'package:flutter_riverpod/legacy.dart';

class PercentageDialogState {
  PercentageDialogState({
    this.isShowing = false,
    this.progress = 0.0,
    this.message = '',
  });
  final bool isShowing;
  final double progress;
  final String message;

  PercentageDialogState copyWith({
    bool? isShowing,
    double? progress,
    String? message,
  }) {
    return PercentageDialogState(
      isShowing: isShowing ?? this.isShowing,
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
  }
}

class PercentageDialogNotifier extends StateNotifier<PercentageDialogState> {
  PercentageDialogNotifier() : super(PercentageDialogState());

  void show(String message) {
    state = state.copyWith(isShowing: true, message: message, progress: 0);
  }

  void updateProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void updateMessage(String message) {
    state = state.copyWith(message: message);
  }

  void hide() {
    state = PercentageDialogState();
  }
}

final percentageDialogProvider = StateNotifierProvider<PercentageDialogNotifier, PercentageDialogState>((ref) {
  return PercentageDialogNotifier();
});
