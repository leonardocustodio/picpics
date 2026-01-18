import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/pin_provider_full.dart';
import 'package:picpics/utils/app_logger.dart';

/// Integration tests for PIN provider functionality
/// Note: Tests for actual crypto validation require mocking FlutterSecureStorage
/// and Firebase. These tests focus on state management.
void main() {
  // Initialize logger once for all tests
  setUpAll(AppLogger.init);

  group('PIN Provider State Tests', () {
    late ProviderContainer container;
    late PinFullNotifier notifier;

    setUp(() {
      // Create a provider container with overrides
      container = ProviderContainer();
      notifier = container.read(pinFullProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be correct', () {
      final state = container.read(pinFullProvider);

      expect(state.email, isEmpty);
      expect(state.pinTemp, isEmpty);
      expect(state.confirmPinTemp, isEmpty);
      expect(state.accessCode, isEmpty);
      expect(state.invalidAccessCode, isFalse);
      expect(state.isWaitingRecoveryKey, isFalse);
      expect(state.isSettingNewPin, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.recoveryCode, isEmpty);
      expect(state.encryptedRecoveryKey, isEmpty);
      expect(state.generatedIv, isEmpty);
      expect(state.pin, isEmpty);
    });

    test('setEmail should update email', () {
      notifier.setEmail('test@example.com');

      expect(container.read(pinFullProvider).email, equals('test@example.com'));
    });

    test('setPinTemp should update pinTemp', () {
      notifier.setPinTemp('1234');

      expect(container.read(pinFullProvider).pinTemp, equals('1234'));
    });

    test('setConfirmPinTemp should update confirmPinTemp', () {
      notifier.setConfirmPinTemp('1234');

      expect(container.read(pinFullProvider).confirmPinTemp, equals('1234'));
    });

    test('setAccessCode should update accessCode', () {
      notifier.setAccessCode('ABC123');

      expect(container.read(pinFullProvider).accessCode, equals('ABC123'));
    });

    test('setInvalidAccessCode should update invalidAccessCode', () {
      notifier.setInvalidAccessCode(value: true);
      expect(container.read(pinFullProvider).invalidAccessCode, isTrue);

      notifier.setInvalidAccessCode(value: false);
      expect(container.read(pinFullProvider).invalidAccessCode, isFalse);
    });

    test('setIsWaitingRecoveryKey should update state', () {
      notifier.setIsWaitingRecoveryKey(value: true);
      expect(container.read(pinFullProvider).isWaitingRecoveryKey, isTrue);

      notifier.setIsWaitingRecoveryKey(value: false);
      expect(container.read(pinFullProvider).isWaitingRecoveryKey, isFalse);
    });

    test('setIsSettingNewPin should update state', () {
      notifier.setIsSettingNewPin(value: true);
      expect(container.read(pinFullProvider).isSettingNewPin, isTrue);

      notifier.setIsSettingNewPin(value: false);
      expect(container.read(pinFullProvider).isSettingNewPin, isFalse);
    });

    test('setRecoveryCode should update recoveryCode', () {
      notifier.setRecoveryCode('123456');

      expect(container.read(pinFullProvider).recoveryCode, equals('123456'));
    });

    test('setGeneratedIv should update generatedIv', () {
      notifier.setGeneratedIv('654321');

      expect(container.read(pinFullProvider).generatedIv, equals('654321'));
    });

    test('setPin should update pin', () {
      notifier.setPin('9999');

      expect(container.read(pinFullProvider).pin, equals('9999'));
    });

    test('PinFullState copyWith should preserve values', () {
      final initial = PinFullState(
        email: 'test@test.com',
        pin: '1234',
        pinTemp: '5678',
      );

      // copyWith with no changes
      final unchanged = initial.copyWith();
      expect(unchanged.email, equals('test@test.com'));
      expect(unchanged.pin, equals('1234'));
      expect(unchanged.pinTemp, equals('5678'));

      // copyWith with partial changes
      final changed = initial.copyWith(email: 'new@test.com', isLoading: true);
      expect(changed.email, equals('new@test.com'));
      expect(changed.pin, equals('1234')); // unchanged
      expect(changed.isLoading, isTrue);
    });

    test('State updates should be independent', () {
      notifier
        ..setEmail('user@test.com')
        ..setPin('1234')
        ..setPinTemp('5678')
        ..setRecoveryCode('recovery123');

      final state = container.read(pinFullProvider);
      expect(state.email, equals('user@test.com'));
      expect(state.pin, equals('1234'));
      expect(state.pinTemp, equals('5678'));
      expect(state.recoveryCode, equals('recovery123'));
    });

    test('Animation keys should be initialized', () {
      expect(notifier.shakeKey, isNotNull);
      expect(notifier.shakeKeyConfirm, isNotNull);
      expect(notifier.shakeRecovery, isNotNull);
    });

    test('Multiple containers should have independent state', () {
      final container2 = ProviderContainer();

      // Modify first container
      notifier
        ..setEmail('container1@test.com')
        ..setPin('1111');

      // Second container should be unaffected
      final state1 = container.read(pinFullProvider);
      final state2 = container2.read(pinFullProvider);

      expect(state1.email, equals('container1@test.com'));
      expect(state2.email, isEmpty);
      expect(state1.pin, equals('1111'));
      expect(state2.pin, isEmpty);

      container2.dispose();
    });

    test('Full PIN setup workflow state transitions', () {
      // Simulate PIN setup workflow
      // 1. User enters email
      notifier.setEmail('user@example.com');
      expect(container.read(pinFullProvider).email, equals('user@example.com'));

      // 2. User enters PIN
      notifier.setPin('1234');
      expect(container.read(pinFullProvider).pin, equals('1234'));

      // 3. User enters PIN again for confirmation
      notifier.setConfirmPinTemp('1234');
      expect(container.read(pinFullProvider).confirmPinTemp, equals('1234'));

      // 4. Waiting for access code
      notifier.setIsSettingNewPin(value: true);
      expect(container.read(pinFullProvider).isSettingNewPin, isTrue);

      // 5. User enters access code
      notifier.setAccessCode('ABCDEF');
      expect(container.read(pinFullProvider).accessCode, equals('ABCDEF'));
    });

    test('PIN recovery workflow state transitions', () {
      // Simulate PIN recovery workflow
      // 1. Start recovery - set waiting state
      notifier.setIsWaitingRecoveryKey(value: true);
      expect(container.read(pinFullProvider).isWaitingRecoveryKey, isTrue);

      // 2. Set generated IV (from server)
      notifier.setGeneratedIv('123456');
      expect(container.read(pinFullProvider).generatedIv, equals('123456'));

      // 3. User enters recovery code from email
      notifier.setRecoveryCode('RECOVER');
      expect(container.read(pinFullProvider).recoveryCode, equals('RECOVER'));

      // 4. Now setting new PIN
      notifier.setIsSettingNewPin(value: true);
      expect(container.read(pinFullProvider).isSettingNewPin, isTrue);

      // 5. User enters new PIN
      notifier.setPin('9999');
      expect(container.read(pinFullProvider).pin, equals('9999'));

      // 6. Complete - reset states
      notifier
        ..setIsWaitingRecoveryKey(value: false)
        ..setIsSettingNewPin(value: false);

      final finalState = container.read(pinFullProvider);
      expect(finalState.isWaitingRecoveryKey, isFalse);
      expect(finalState.isSettingNewPin, isFalse);
      expect(finalState.pin, equals('9999'));
    });
  });
}
