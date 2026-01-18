import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/providers/pin_provider_full.dart';

/// Unit tests for PinFullState
/// Note: Tests for methods requiring Firebase/SecureStorage are in integration tests
void main() {
  group('PinFullState', () {
    group('Constructor and defaults', () {
      test('default constructor should create empty state', () {
        final state = PinFullState();

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

      test('constructor with all parameters', () {
        final state = PinFullState(
          email: 'test@example.com',
          pinTemp: '1234',
          confirmPinTemp: '1234',
          accessCode: 'ACCESS',
          invalidAccessCode: true,
          isWaitingRecoveryKey: true,
          isSettingNewPin: true,
          isLoading: true,
          recoveryCode: 'RECOVER',
          encryptedRecoveryKey: 'encrypted',
          generatedIv: '123456',
          pin: '5678',
        );

        expect(state.email, equals('test@example.com'));
        expect(state.pinTemp, equals('1234'));
        expect(state.confirmPinTemp, equals('1234'));
        expect(state.accessCode, equals('ACCESS'));
        expect(state.invalidAccessCode, isTrue);
        expect(state.isWaitingRecoveryKey, isTrue);
        expect(state.isSettingNewPin, isTrue);
        expect(state.isLoading, isTrue);
        expect(state.recoveryCode, equals('RECOVER'));
        expect(state.encryptedRecoveryKey, equals('encrypted'));
        expect(state.generatedIv, equals('123456'));
        expect(state.pin, equals('5678'));
      });
    });

    group('copyWith', () {
      test('copyWith with no arguments should preserve all values', () {
        final original = PinFullState(
          email: 'test@example.com',
          pin: '1234',
          pinTemp: '5678',
        );

        final copy = original.copyWith();

        expect(copy.email, equals(original.email));
        expect(copy.pin, equals(original.pin));
        expect(copy.pinTemp, equals(original.pinTemp));
      });

      test('copyWith should update only specified fields', () {
        final original = PinFullState(
          email: 'old@example.com',
          pin: '1234',
        );

        final updated = original.copyWith(email: 'new@example.com');

        expect(updated.email, equals('new@example.com'));
        expect(updated.pin, equals('1234')); // preserved
      });

      test('copyWith email', () {
        final state = PinFullState().copyWith(email: 'user@test.com');
        expect(state.email, equals('user@test.com'));
      });

      test('copyWith pinTemp', () {
        final state = PinFullState().copyWith(pinTemp: '1234');
        expect(state.pinTemp, equals('1234'));
      });

      test('copyWith confirmPinTemp', () {
        final state = PinFullState().copyWith(confirmPinTemp: '5678');
        expect(state.confirmPinTemp, equals('5678'));
      });

      test('copyWith accessCode', () {
        final state = PinFullState().copyWith(accessCode: 'ABC123');
        expect(state.accessCode, equals('ABC123'));
      });

      test('copyWith invalidAccessCode', () {
        final state = PinFullState().copyWith(invalidAccessCode: true);
        expect(state.invalidAccessCode, isTrue);

        final reset = state.copyWith(invalidAccessCode: false);
        expect(reset.invalidAccessCode, isFalse);
      });

      test('copyWith isWaitingRecoveryKey', () {
        final state = PinFullState().copyWith(isWaitingRecoveryKey: true);
        expect(state.isWaitingRecoveryKey, isTrue);
      });

      test('copyWith isSettingNewPin', () {
        final state = PinFullState().copyWith(isSettingNewPin: true);
        expect(state.isSettingNewPin, isTrue);
      });

      test('copyWith isLoading', () {
        final state = PinFullState().copyWith(isLoading: true);
        expect(state.isLoading, isTrue);
      });

      test('copyWith recoveryCode', () {
        final state = PinFullState().copyWith(recoveryCode: 'RECOVER123');
        expect(state.recoveryCode, equals('RECOVER123'));
      });

      test('copyWith encryptedRecoveryKey', () {
        final state = PinFullState().copyWith(encryptedRecoveryKey: 'encrypted_key');
        expect(state.encryptedRecoveryKey, equals('encrypted_key'));
      });

      test('copyWith generatedIv', () {
        final state = PinFullState().copyWith(generatedIv: '123456');
        expect(state.generatedIv, equals('123456'));
      });

      test('copyWith pin', () {
        final state = PinFullState().copyWith(pin: '9999');
        expect(state.pin, equals('9999'));
      });

      test('copyWith multiple fields at once', () {
        final state = PinFullState().copyWith(
          email: 'multi@test.com',
          pin: '1111',
          pinTemp: '2222',
          isLoading: true,
          isSettingNewPin: true,
        );

        expect(state.email, equals('multi@test.com'));
        expect(state.pin, equals('1111'));
        expect(state.pinTemp, equals('2222'));
        expect(state.isLoading, isTrue);
        expect(state.isSettingNewPin, isTrue);
      });

      test('chained copyWith calls', () {
        final state1 = PinFullState();
        final state2 = state1.copyWith(email: 'step1@test.com');
        final state3 = state2.copyWith(pin: '1234');
        final state4 = state3.copyWith(isLoading: true);

        expect(state4.email, equals('step1@test.com'));
        expect(state4.pin, equals('1234'));
        expect(state4.isLoading, isTrue);
      });
    });

    group('State transitions', () {
      test('PIN entry workflow state', () {
        // Simulate user entering PIN
        var state = PinFullState();

        // Enter first digit
        state = state.copyWith(pinTemp: '1');
        expect(state.pinTemp, equals('1'));

        // Enter remaining digits
        state = state.copyWith(pinTemp: '1234');
        expect(state.pinTemp, equals('1234'));
      });

      test('PIN confirmation workflow', () {
        var state = PinFullState(pinTemp: '1234');

        // Enter confirmation PIN
        state = state.copyWith(confirmPinTemp: '1234');
        expect(state.pinTemp, equals('1234'));
        expect(state.confirmPinTemp, equals('1234'));
        expect(state.pinTemp == state.confirmPinTemp, isTrue);
      });

      test('PIN mismatch detection', () {
        final state = PinFullState(
          pinTemp: '1234',
          confirmPinTemp: '5678',
        );

        expect(state.pinTemp == state.confirmPinTemp, isFalse);
      });

      test('Access code validation flow', () {
        var state = PinFullState(
          email: 'user@test.com',
          pin: '1234',
        );

        // Enter access code
        state = state.copyWith(accessCode: 'VALID_CODE');
        expect(state.accessCode, equals('VALID_CODE'));

        // Start loading
        state = state.copyWith(isLoading: true);
        expect(state.isLoading, isTrue);

        // Invalid access code
        state = state.copyWith(
          isLoading: false,
          invalidAccessCode: true,
          accessCode: '',
        );
        expect(state.isLoading, isFalse);
        expect(state.invalidAccessCode, isTrue);
        expect(state.accessCode, isEmpty);

        // Retry with valid code
        state = state.copyWith(
          invalidAccessCode: false,
          accessCode: 'ANOTHER_CODE',
        );
        expect(state.invalidAccessCode, isFalse);
      });

      test('Recovery flow state transitions', () {
        var state = PinFullState(email: 'user@test.com');

        // Request recovery - start loading
        state = state.copyWith(isLoading: true);
        expect(state.isLoading, isTrue);

        // Received encrypted recovery key
        state = state.copyWith(
          isLoading: false,
          encryptedRecoveryKey: 'encrypted_key_from_server',
          generatedIv: '123456',
          isWaitingRecoveryKey: true,
        );
        expect(state.isWaitingRecoveryKey, isTrue);
        expect(state.encryptedRecoveryKey, isNotEmpty);
        expect(state.generatedIv, equals('123456'));

        // User enters recovery code
        state = state.copyWith(recoveryCode: 'USER_RECOVERY_CODE');
        expect(state.recoveryCode, equals('USER_RECOVERY_CODE'));

        // Start setting new PIN
        state = state.copyWith(isSettingNewPin: true);
        expect(state.isSettingNewPin, isTrue);

        // Set new PIN
        state = state.copyWith(pin: '9999');
        expect(state.pin, equals('9999'));

        // Complete recovery
        state = state.copyWith(
          isWaitingRecoveryKey: false,
          isSettingNewPin: false,
          pin: '',
        );
        expect(state.isWaitingRecoveryKey, isFalse);
        expect(state.isSettingNewPin, isFalse);
      });

      test('Registration flow state', () {
        var state = PinFullState();

        // Enter email
        state = state.copyWith(email: 'newuser@test.com');
        expect(state.email, equals('newuser@test.com'));

        // Enter and confirm PIN
        state = state.copyWith(
          pinTemp: '1234',
          confirmPinTemp: '1234',
        );
        expect(state.pinTemp, equals(state.confirmPinTemp));

        // Set final PIN
        state = state.copyWith(pin: '1234');
        expect(state.pin, equals('1234'));

        // Wait for access code
        state = state.copyWith(isSettingNewPin: true);

        // Enter access code
        state = state.copyWith(accessCode: 'ACCESS123');

        // Start validation
        state = state.copyWith(isLoading: true);
        expect(state.isLoading, isTrue);
      });
    });

    group('Edge cases', () {
      test('empty strings', () {
        final state = PinFullState(
          
        );

        expect(state.email, isEmpty);
        expect(state.pin, isEmpty);
        expect(state.accessCode, isEmpty);
      });

      test('special characters in access code', () {
        final state = PinFullState().copyWith(accessCode: r'ABC!@#$%^&*()');
        expect(state.accessCode, equals(r'ABC!@#$%^&*()'));
      });

      test('unicode in email', () {
        final state = PinFullState().copyWith(email: 'tëst@éxàmple.cöm');
        expect(state.email, equals('tëst@éxàmple.cöm'));
      });

      test('long recovery code', () {
        final longCode = 'A' * 1000;
        final state = PinFullState().copyWith(recoveryCode: longCode);
        expect(state.recoveryCode.length, equals(1000));
      });

      test('null-like empty strings after reset', () {
        final state = PinFullState(
          pin: '1234',
          pinTemp: '5678',
        ).copyWith(
          pin: '',
          pinTemp: '',
        );

        expect(state.pin, isEmpty);
        expect(state.pinTemp, isEmpty);
      });
    });

    group('Boolean state combinations', () {
      test('all boolean flags false', () {
        final state = PinFullState();

        expect(state.invalidAccessCode, isFalse);
        expect(state.isWaitingRecoveryKey, isFalse);
        expect(state.isSettingNewPin, isFalse);
        expect(state.isLoading, isFalse);
      });

      test('all boolean flags true', () {
        final state = PinFullState(
          invalidAccessCode: true,
          isWaitingRecoveryKey: true,
          isSettingNewPin: true,
          isLoading: true,
        );

        expect(state.invalidAccessCode, isTrue);
        expect(state.isWaitingRecoveryKey, isTrue);
        expect(state.isSettingNewPin, isTrue);
        expect(state.isLoading, isTrue);
      });

      test('toggle boolean flags', () {
        var state = PinFullState();

        // Toggle isLoading
        state = state.copyWith(isLoading: true);
        expect(state.isLoading, isTrue);
        state = state.copyWith(isLoading: false);
        expect(state.isLoading, isFalse);

        // Toggle invalidAccessCode
        state = state.copyWith(invalidAccessCode: true);
        expect(state.invalidAccessCode, isTrue);
        state = state.copyWith(invalidAccessCode: false);
        expect(state.invalidAccessCode, isFalse);
      });

      test('isLoading should block other state changes conceptually', () {
        // When loading, typically other state shouldn't change
        // This tests that we can track this relationship
        final loadingState = PinFullState(isLoading: true);

        // Even if we try to set other things, loading is still true
        final modifiedWhileLoading = loadingState.copyWith(pin: '9999');

        expect(modifiedWhileLoading.isLoading, isTrue);
        expect(modifiedWhileLoading.pin, equals('9999'));
      });
    });

    group('PIN validation helpers', () {
      test('PIN length check simulation', () {
        const requiredLength = 4;

        final shortPin = PinFullState(pinTemp: '12');
        final validPin = PinFullState(pinTemp: '1234');
        final longPin = PinFullState(pinTemp: '123456');

        expect(shortPin.pinTemp.length < requiredLength, isTrue);
        expect(validPin.pinTemp.length == requiredLength, isTrue);
        expect(longPin.pinTemp.length > requiredLength, isTrue);
      });

      test('PIN match check simulation', () {
        final matching = PinFullState(
          pinTemp: '1234',
          confirmPinTemp: '1234',
        );

        final notMatching = PinFullState(
          pinTemp: '1234',
          confirmPinTemp: '4321',
        );

        expect(matching.pinTemp == matching.confirmPinTemp, isTrue);
        expect(notMatching.pinTemp == notMatching.confirmPinTemp, isFalse);
      });

      test('email presence check', () {
        final noEmail = PinFullState();
        final hasEmail = PinFullState(email: 'user@test.com');

        expect(noEmail.email.isEmpty, isTrue);
        expect(hasEmail.email.isNotEmpty, isTrue);
      });

      test('access code presence check', () {
        final noCode = PinFullState();
        final hasCode = PinFullState(accessCode: 'CODE123');

        expect(noCode.accessCode.isEmpty, isTrue);
        expect(hasCode.accessCode.isNotEmpty, isTrue);
      });
    });
  });
}
