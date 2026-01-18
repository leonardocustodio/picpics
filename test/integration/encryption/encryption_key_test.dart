import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/encryption_key_provider.dart';
import 'package:picpics/utils/app_logger.dart';

/// Integration tests for encryption key management
void main() {
  // Initialize logger once for all tests
  setUpAll(AppLogger.init);

  group('Encryption Key Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should have no encryption key', () {
      final state = container.read(encryptionKeyProvider);

      expect(state.encryptionKey, isNull);
      expect(state.isUnlocked, isFalse);
      expect(state.tempEncryptionKeyString, isNull);
    });

    test('setEncryptionKey should store key and unlock', () async {
      // Create a test secret key
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
      final testKey = await algorithm.newSecretKey();

      container.read(encryptionKeyProvider.notifier).setEncryptionKey(testKey);

      final state = container.read(encryptionKeyProvider);
      expect(state.encryptionKey, isNotNull);
      expect(state.isUnlocked, isTrue);
    });

    test('clearEncryptionKey should remove key and lock', () async {
      // First set a key
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
      final testKey = await algorithm.newSecretKey();
      container.read(encryptionKeyProvider.notifier).setEncryptionKey(testKey);

      // Verify it's set
      expect(container.read(encryptionKeyProvider).isUnlocked, isTrue);

      // Clear the key
      container.read(encryptionKeyProvider.notifier).clearEncryptionKey();

      final state = container.read(encryptionKeyProvider);
      expect(state.encryptionKey, isNull);
      expect(state.isUnlocked, isFalse);
    });

    test('lock should set isUnlocked to false without clearing key', () async {
      // Set a key
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
      final testKey = await algorithm.newSecretKey();
      container.read(encryptionKeyProvider.notifier).setEncryptionKey(testKey);

      // Lock
      container.read(encryptionKeyProvider.notifier).lock();

      final state = container.read(encryptionKeyProvider);
      expect(state.encryptionKey, isNotNull); // Key is preserved
      expect(state.isUnlocked, isFalse); // But locked
    });

    test('unlock should set isUnlocked to true if key exists', () async {
      // Set a key then lock
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
      final testKey = await algorithm.newSecretKey();
      container.read(encryptionKeyProvider.notifier)
        ..setEncryptionKey(testKey)
        ..lock();

      // Verify locked
      expect(container.read(encryptionKeyProvider).isUnlocked, isFalse);

      // Unlock
      container.read(encryptionKeyProvider.notifier).unlock();

      expect(container.read(encryptionKeyProvider).isUnlocked, isTrue);
    });

    test('unlock should do nothing if no key exists', () {
      container.read(encryptionKeyProvider.notifier).unlock();

      final state = container.read(encryptionKeyProvider);
      expect(state.encryptionKey, isNull);
      expect(state.isUnlocked, isFalse);
    });

    test('setTempEncryptionKey should store temp key string', () {
      container.read(encryptionKeyProvider.notifier).setTempEncryptionKey('test_key_string');

      final state = container.read(encryptionKeyProvider);
      expect(state.tempEncryptionKeyString, equals('test_key_string'));
    });

    test('setTempEncryptionKey with null should clear temp key', () {
      // First set a temp key
      container.read(encryptionKeyProvider.notifier).setTempEncryptionKey('test_key_string');
      expect(container.read(encryptionKeyProvider).tempEncryptionKeyString, isNotNull);

      // Clear it
      container.read(encryptionKeyProvider.notifier).setTempEncryptionKey(null);

      expect(container.read(encryptionKeyProvider).tempEncryptionKeyString, isNull);
    });

    test('Full workflow: set key, lock, unlock, clear', () async {
      final notifier = container.read(encryptionKeyProvider.notifier);
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
      final testKey = await algorithm.newSecretKey();

      // 1. Set encryption key
      notifier.setEncryptionKey(testKey);
      expect(container.read(encryptionKeyProvider).isUnlocked, isTrue);
      expect(container.read(encryptionKeyProvider).encryptionKey, isNotNull);

      // 2. Lock (key preserved but hidden)
      notifier.lock();
      expect(container.read(encryptionKeyProvider).isUnlocked, isFalse);
      expect(container.read(encryptionKeyProvider).encryptionKey, isNotNull);

      // 3. Unlock again
      notifier.unlock();
      expect(container.read(encryptionKeyProvider).isUnlocked, isTrue);

      // 4. Full clear
      notifier.clearEncryptionKey();
      expect(container.read(encryptionKeyProvider).isUnlocked, isFalse);
      expect(container.read(encryptionKeyProvider).encryptionKey, isNull);
    });

    test('EncryptionKeyState copyWith preserves values', () async {
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
      final testKey = await algorithm.newSecretKey();

      const initial = EncryptionKeyState();

      // Test copyWith with encryption key
      final withKey = initial.copyWith(encryptionKey: testKey, isUnlocked: true);
      expect(withKey.encryptionKey, equals(testKey));
      expect(withKey.isUnlocked, isTrue);
      expect(withKey.tempEncryptionKeyString, isNull);

      // Test copyWith with temp key
      final withTemp = withKey.copyWith(tempEncryptionKeyString: 'temp');
      expect(withTemp.encryptionKey, equals(testKey));
      expect(withTemp.tempEncryptionKeyString, equals('temp'));

      // Test clearEncryptionKey flag
      final cleared = withTemp.copyWith(clearEncryptionKey: true);
      expect(cleared.encryptionKey, isNull);
      expect(cleared.tempEncryptionKeyString, equals('temp'));

      // Test clearTempKey flag
      final clearedTemp = withTemp.copyWith(clearTempKey: true);
      expect(clearedTemp.encryptionKey, equals(testKey));
      expect(clearedTemp.tempEncryptionKeyString, isNull);
    });

    test('Multiple containers should have independent state', () async {
      final container2 = ProviderContainer();
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
      final testKey = await algorithm.newSecretKey();

      // Set key in first container
      container.read(encryptionKeyProvider.notifier).setEncryptionKey(testKey);

      // Second container should be unaffected
      expect(container.read(encryptionKeyProvider).isUnlocked, isTrue);
      expect(container2.read(encryptionKeyProvider).isUnlocked, isFalse);

      container2.dispose();
    });
  });
}
