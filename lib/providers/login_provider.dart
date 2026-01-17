import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/utils/app_logger.dart';

enum Board {
  createTags,
  swipeRight,
  keepSecret,
  multiSelect,
}

class LoginState {

  LoginState({
    this.slideIndex = 0,
    List<Board>? boards,
    this.isLoading = false,
  }) : boards = boards ?? Board.values;
  final int slideIndex;
  final List<Board> boards;
  final bool isLoading;

  int get totalSlides => boards.length;

  List<Map<String, String>> get screensList {
    return boards.map((board) {
      final index = boards.indexOf(board);
      return {
        'title': getDescription(index) ?? '',
        'description': getDescription(index) ?? '',
        'image': _getImagePath(board),
      };
    }).toList();
  }

  String _getImagePath(Board board) {
    switch (board) {
      case Board.createTags:
        return 'lib/images/onboardtagging.png';
      case Board.swipeRight:
        return 'lib/images/onboardswipe.png';
      case Board.keepSecret:
        return 'lib/images/onboardsecret.png';
      case Board.multiSelect:
        return 'lib/images/onboardmultiselect.png';
    }
  }

  String? getDescription(int index) {
    if (index < 0 || index >= boards.length) return null;
    final board = boards[index];
    // These will be replaced with actual translations
    switch (board) {
      case Board.createTags:
        return 'Organize however you want';
      case Board.swipeRight:
        return 'Just swipe to navigate';
      case Board.keepSecret:
        return 'Keep photos private';
      case Board.multiSelect:
        return 'Select multiple photos';
    }
  }

  Image? getImage(int index) {
    if (index < 0 || index >= boards.length) return null;
    final board = boards[index];
    switch (board) {
      case Board.createTags:
        return Image.asset('lib/images/onboardtagging.png');
      case Board.swipeRight:
        return Image.asset('lib/images/onboardswipe.png');
      case Board.keepSecret:
        return Image.asset('lib/images/onboardsecret.png');
      case Board.multiSelect:
        return Image.asset('lib/images/onboardmultiselect.png');
    }
  }

  LoginState copyWith({
    int? slideIndex,
    List<Board>? boards,
    bool? isLoading,
  }) {
    return LoginState(
      slideIndex: slideIndex ?? this.slideIndex,
      boards: boards ?? this.boards,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {

  LoginNotifier(this.ref) : super(LoginState());
  final Ref ref;
  final AppDatabase _database = AppDatabase();

  void initializeScreens() {
    // Initialize with default boards
    state = LoginState(boards: Board.values);
  }

  void setSlideIndex(int index) {
    state = state.copyWith(slideIndex: index);
    AppLogger.d('Slide index changed to: $index');
  }

  Future<void> skipIntroduction() async {
    AppLogger.i('User skipped introduction');
    await Analytics.sendEvent(Event.tutorial_begin);
    await _completeOnboarding();
  }

  Future<void> completeIntroduction() async {
    AppLogger.i('User completed introduction');
    await Analytics.sendEvent(Event.tutorial_complete);
    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    state = state.copyWith(isLoading: true);

    try {
      // Update user state
      unawaited(ref.read(userProvider.notifier).setTutorialCompleted(value: true));

      // Update database
      final user = await _database.getSingleMoorUser();
      if (user != null) {
        await _database.updateMoorUser(
          user.copyWith(tutorialCompleted: true),
        );
      }

      AppLogger.i('Onboarding completed successfully');
    } catch (e) {
      AppLogger.e('Error completing onboarding: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void nextSlide() {
    if (state.slideIndex < state.screensList.length) {
      setSlideIndex(state.slideIndex + 1);
    }
  }

  void previousSlide() {
    if (state.slideIndex > 0) {
      setSlideIndex(state.slideIndex - 1);
    }
  }

  bool get isLastSlide => state.slideIndex == state.screensList.length;
  bool get isFirstSlide => state.slideIndex == 0;
}

// Provider
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});
