import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/generated/l10n.dart' as language;

class LanguageState {
  final language.S s;
  final String languageCode;

  LanguageState({
    required this.s,
    this.languageCode = 'en',
  });

  LanguageState copyWith({
    language.S? s,
    String? languageCode,
  }) {
    return LanguageState(
      s: s ?? this.s,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier() : super(LanguageState(s: language.S()));

  Future<void> initialize(String languageCode) async {
    final s = await language.S.load(Locale(languageCode));
    state = state.copyWith(s: s, languageCode: languageCode);
  }

  Future<void> changeLanguageTo(String languageCode) async {
    final s = await language.S.load(Locale(languageCode));
    state = state.copyWith(s: s, languageCode: languageCode);
  }
}

// Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, LanguageState>((ref) {
  return LanguageNotifier();
});

// Convenience provider to access the S object directly
final sProvider = Provider<language.S>((ref) {
  return ref.watch(languageProvider).s;
});
