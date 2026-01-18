import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:flutter_riverpod/legacy.dart';
import 'package:picpics/utils/app_logger.dart';

/// State for managing the encryption key
class EncryptionKeyState {
  const EncryptionKeyState({
    this.encryptionKey,
    this.isUnlocked = false,
    this.tempEncryptionKeyString,
  });

  /// The encryption key used for encrypting/decrypting private photos
  final cryptography.SecretKey? encryptionKey;

  /// Whether the user has unlocked the private photos (PIN validated)
  final bool isUnlocked;

  /// Temporary storage for the decrypted key string (used during PIN recovery)
  final String? tempEncryptionKeyString;

  EncryptionKeyState copyWith({
    cryptography.SecretKey? encryptionKey,
    bool? isUnlocked,
    String? tempEncryptionKeyString,
    bool clearEncryptionKey = false,
    bool clearTempKey = false,
  }) {
    return EncryptionKeyState(
      encryptionKey: clearEncryptionKey ? null : (encryptionKey ?? this.encryptionKey),
      isUnlocked: isUnlocked ?? this.isUnlocked,
      tempEncryptionKeyString: clearTempKey ? null : (tempEncryptionKeyString ?? this.tempEncryptionKeyString),
    );
  }
}

/// Notifier for managing encryption key state
class EncryptionKeyNotifier extends StateNotifier<EncryptionKeyState> {
  EncryptionKeyNotifier() : super(const EncryptionKeyState());

  /// Set the encryption key after successful PIN validation
  void setEncryptionKey(cryptography.SecretKey key) {
    state = state.copyWith(
      encryptionKey: key,
      isUnlocked: true,
    );
    AppLogger.d('Encryption key set and unlocked');
  }

  /// Set temporary encryption key string (for PIN recovery flow)
  void setTempEncryptionKey(String? keyString) {
    if (keyString == null) {
      state = state.copyWith(clearTempKey: true);
    } else {
      state = state.copyWith(tempEncryptionKeyString: keyString);
    }
  }

  /// Clear the encryption key (when locking private photos)
  void clearEncryptionKey() {
    state = state.copyWith(
      clearEncryptionKey: true,
      isUnlocked: false,
    );
    AppLogger.d('Encryption key cleared and locked');
  }

  /// Lock private photos without clearing the key
  /// (keeps key in memory but hides private photos)
  void lock() {
    state = state.copyWith(isUnlocked: false);
    AppLogger.d('Private photos locked');
  }

  /// Unlock private photos (if key is already set)
  void unlock() {
    if (state.encryptionKey != null) {
      state = state.copyWith(isUnlocked: true);
      AppLogger.d('Private photos unlocked');
    } else {
      AppLogger.w('Cannot unlock - no encryption key set');
    }
  }
}

/// Provider for encryption key management
final encryptionKeyProvider = StateNotifierProvider<EncryptionKeyNotifier, EncryptionKeyState>((ref) {
  return EncryptionKeyNotifier();
});
