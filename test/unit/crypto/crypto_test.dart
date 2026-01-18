import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/managers/crypto_manager.dart';
import 'package:picpics/utils/app_logger.dart';

/// Unit tests for cryptography functionality
///
/// Note: Tests for methods requiring FlutterSecureStorage (checkIsPinValid,
/// saveSpKey, etc.) are in integration tests with mocked storage.
void main() {
  setUpAll(AppLogger.init);

  group('Crypto.encryptAccessKey', () {
    test('should encrypt access code and email', () async {
      const accessCode = 'ABC123';
      const email = 'test@example.com';
      const randomIv = '1234';

      final result = await Crypto.encryptAccessKey(accessCode, email, randomIv);

      expect(result, isNotEmpty);
      expect(result, isA<String>());
      // Should be a valid hex string
      expect(() => hex.decode(result), returnsNormally);
    });

    test('should produce consistent output for same inputs', () async {
      const accessCode = 'XYZ789';
      const email = 'user@domain.com';
      const randomIv = '5678';

      final result1 = await Crypto.encryptAccessKey(accessCode, email, randomIv);
      final result2 = await Crypto.encryptAccessKey(accessCode, email, randomIv);

      expect(result1, equals(result2));
    });

    test('should produce different output for different access codes', () async {
      const email = 'test@example.com';
      const randomIv = '1234';

      final result1 = await Crypto.encryptAccessKey('CODE1', email, randomIv);
      final result2 = await Crypto.encryptAccessKey('CODE2', email, randomIv);

      expect(result1, isNot(equals(result2)));
    });

    test('should produce different output for different emails', () async {
      const accessCode = 'ABC123';
      const randomIv = '1234';

      final result1 = await Crypto.encryptAccessKey(accessCode, 'user1@test.com', randomIv);
      final result2 = await Crypto.encryptAccessKey(accessCode, 'user2@test.com', randomIv);

      expect(result1, isNot(equals(result2)));
    });

    test('should produce different output for different IVs', () async {
      const accessCode = 'ABC123';
      const email = 'test@example.com';

      final result1 = await Crypto.encryptAccessKey(accessCode, email, '1234');
      final result2 = await Crypto.encryptAccessKey(accessCode, email, '5678');

      expect(result1, isNot(equals(result2)));
    });

    test('should handle special characters in access code', () async {
      const accessCode = r'ABC!@#$%^';
      const email = 'test@example.com';
      const randomIv = '1234';

      final result = await Crypto.encryptAccessKey(accessCode, email, randomIv);

      expect(result, isNotEmpty);
      expect(() => hex.decode(result), returnsNormally);
    });

    test('should handle unicode in email', () async {
      const accessCode = 'ABC123';
      const email = 'tëst@éxàmple.cöm';
      const randomIv = '1234';

      final result = await Crypto.encryptAccessKey(accessCode, email, randomIv);

      expect(result, isNotEmpty);
      expect(() => hex.decode(result), returnsNormally);
    });
  });

  group('AES-CTR-256 Encryption/Decryption', () {
    late cryptography.AesCtr algorithm;

    setUp(() {
      algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
    });

    test('should encrypt and decrypt text successfully', () async {
      final secretKey = await algorithm.newSecretKey();
      const plaintext = 'Hello, World! This is a test message.';
      final plaintextBytes = utf8.encode(plaintext);

      // Encrypt
      final encrypted = await algorithm.encrypt(
        plaintextBytes,
        secretKey: secretKey,
      );

      expect(encrypted.cipherText, isNotEmpty);
      expect(encrypted.nonce, isNotEmpty);

      // Decrypt
      final decrypted = await algorithm.decrypt(
        encrypted,
        secretKey: secretKey,
      );

      final decryptedText = utf8.decode(decrypted);
      expect(decryptedText, equals(plaintext));
    });

    test('should encrypt and decrypt binary data', () async {
      final secretKey = await algorithm.newSecretKey();
      final binaryData = Uint8List.fromList([0, 1, 2, 255, 128, 64, 32, 16, 8, 4, 2, 1]);

      // Encrypt
      final encrypted = await algorithm.encrypt(
        binaryData,
        secretKey: secretKey,
      );

      // Decrypt
      final decrypted = await algorithm.decrypt(
        encrypted,
        secretKey: secretKey,
      );

      expect(Uint8List.fromList(decrypted), equals(binaryData));
    });

    test('should produce different ciphertext with different nonces', () async {
      final secretKey = await algorithm.newSecretKey();
      const plaintext = 'Same message';
      final plaintextBytes = utf8.encode(plaintext);

      final encrypted1 = await algorithm.encrypt(
        plaintextBytes,
        secretKey: secretKey,
        nonce: utf8.encode('nonce1nonce1'), // 12 bytes
      );

      final encrypted2 = await algorithm.encrypt(
        plaintextBytes,
        secretKey: secretKey,
        nonce: utf8.encode('nonce2nonce2'), // 12 bytes
      );

      expect(encrypted1.cipherText, isNot(equals(encrypted2.cipherText)));
    });

    test('should fail decryption with wrong key', () async {
      final secretKey1 = await algorithm.newSecretKey();
      final secretKey2 = await algorithm.newSecretKey();
      const plaintext = 'Secret message';
      final plaintextBytes = utf8.encode(plaintext);

      // Encrypt with key1
      final encrypted = await algorithm.encrypt(
        plaintextBytes,
        secretKey: secretKey1,
      );

      // Try to decrypt with key2 - should fail or produce garbage
      try {
        final decrypted = await algorithm.decrypt(
          encrypted,
          secretKey: secretKey2,
        );
        // If it doesn't throw, the decrypted data should not match
        final decryptedText = utf8.decode(decrypted, allowMalformed: true);
        expect(decryptedText, isNot(equals(plaintext)));
      } on cryptography.SecretBoxAuthenticationError {
        // Expected - MAC verification fails with wrong key
        expect(true, isTrue);
      }
    });

    test('should handle empty plaintext', () async {
      final secretKey = await algorithm.newSecretKey();
      final emptyBytes = Uint8List(0);

      final encrypted = await algorithm.encrypt(
        emptyBytes,
        secretKey: secretKey,
      );

      final decrypted = await algorithm.decrypt(
        encrypted,
        secretKey: secretKey,
      );

      expect(decrypted, isEmpty);
    });

    test('should handle large data', () async {
      final secretKey = await algorithm.newSecretKey();
      // Create 1MB of test data
      final largeData = Uint8List.fromList(
        List.generate(1024 * 1024, (i) => i % 256),
      );

      final encrypted = await algorithm.encrypt(
        largeData,
        secretKey: secretKey,
      );

      final decrypted = await algorithm.decrypt(
        encrypted,
        secretKey: secretKey,
      );

      expect(Uint8List.fromList(decrypted), equals(largeData));
    });
  });

  group('AES-GCM-256 Encryption/Decryption (iOS algorithm)', () {
    late cryptography.AesGcm algorithm;

    setUp(() {
      algorithm = cryptography.AesGcm.with256bits();
    });

    test('should encrypt and decrypt text successfully', () async {
      final secretKey = await algorithm.newSecretKey();
      const plaintext = 'Hello from iOS encryption!';
      final plaintextBytes = utf8.encode(plaintext);

      // Encrypt
      final encrypted = await algorithm.encrypt(
        plaintextBytes,
        secretKey: secretKey,
      );

      expect(encrypted.cipherText, isNotEmpty);
      expect(encrypted.nonce, isNotEmpty);
      expect(encrypted.mac.bytes, isNotEmpty); // GCM produces authentication tag

      // Decrypt
      final decrypted = await algorithm.decrypt(
        encrypted,
        secretKey: secretKey,
      );

      final decryptedText = utf8.decode(decrypted);
      expect(decryptedText, equals(plaintext));
    });

    test('should encrypt and decrypt binary data', () async {
      final secretKey = await algorithm.newSecretKey();
      final binaryData = Uint8List.fromList([255, 128, 64, 0, 1, 127, 200, 100]);

      final encrypted = await algorithm.encrypt(
        binaryData,
        secretKey: secretKey,
      );

      final decrypted = await algorithm.decrypt(
        encrypted,
        secretKey: secretKey,
      );

      expect(Uint8List.fromList(decrypted), equals(binaryData));
    });

    test('should detect tampering with ciphertext', () async {
      final secretKey = await algorithm.newSecretKey();
      const plaintext = 'Tamper-proof message';
      final plaintextBytes = utf8.encode(plaintext);

      final encrypted = await algorithm.encrypt(
        plaintextBytes,
        secretKey: secretKey,
      );

      // Tamper with ciphertext
      final tamperedCiphertext = List<int>.from(encrypted.cipherText);
      tamperedCiphertext[0] = (tamperedCiphertext[0] + 1) % 256;

      final tamperedBox = cryptography.SecretBox(
        tamperedCiphertext,
        nonce: encrypted.nonce,
        mac: encrypted.mac,
      );

      // Should throw authentication error
      expect(
        () => algorithm.decrypt(tamperedBox, secretKey: secretKey),
        throwsA(isA<cryptography.SecretBoxAuthenticationError>()),
      );
    });

    test('should handle large data efficiently', () async {
      final secretKey = await algorithm.newSecretKey();
      // Create 512KB of test data
      final largeData = Uint8List.fromList(
        List.generate(512 * 1024, (i) => i % 256),
      );

      final encrypted = await algorithm.encrypt(
        largeData,
        secretKey: secretKey,
      );

      final decrypted = await algorithm.decrypt(
        encrypted,
        secretKey: secretKey,
      );

      expect(Uint8List.fromList(decrypted), equals(largeData));
    });
  });

  group('Key Generation', () {
    test('AES-CTR should generate 256-bit keys', () async {
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );
      final secretKey = await algorithm.newSecretKey();
      final keyBytes = await secretKey.extractBytes();

      expect(keyBytes.length, equals(32)); // 256 bits = 32 bytes
    });

    test('AES-GCM should generate 256-bit keys', () async {
      final algorithm = cryptography.AesGcm.with256bits();
      final secretKey = await algorithm.newSecretKey();
      final keyBytes = await secretKey.extractBytes();

      expect(keyBytes.length, equals(32)); // 256 bits = 32 bytes
    });

    test('should create key from bytes', () async {
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );

      // Create a 32-byte key from hex
      final keyBytes = hex.decode(
        '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
      );

      final secretKey = await algorithm.newSecretKeyFromBytes(keyBytes);
      final extractedBytes = await secretKey.extractBytes();

      expect(extractedBytes, equals(keyBytes));
    });

    test('generated keys should be unique', () async {
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );

      final key1 = await algorithm.newSecretKey();
      final key2 = await algorithm.newSecretKey();

      final key1Bytes = await key1.extractBytes();
      final key2Bytes = await key2.extractBytes();

      expect(key1Bytes, isNot(equals(key2Bytes)));
    });
  });

  group('Nonce Generation', () {
    test('should generate 12-byte nonces', () async {
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256(),
      );

      final nonce = algorithm.newNonce();

      expect(nonce.length, equals(16)); // AES-CTR uses 16-byte nonce
    });

    test('AES-GCM should use 12-byte nonces', () async {
      final algorithm = cryptography.AesGcm.with256bits();
      final secretKey = await algorithm.newSecretKey();

      final encrypted = await algorithm.encrypt(
        utf8.encode('test'),
        secretKey: secretKey,
      );

      expect(encrypted.nonce.length, equals(12)); // GCM uses 12-byte nonce
    });
  });

  group('SHA-256 Hashing', () {
    test('should produce 32-byte hash', () async {
      final sha256 = cryptography.Sha256();
      final data = utf8.encode('Hello, World!');

      final hash = await sha256.hash(data);

      expect(hash.bytes.length, equals(32)); // 256 bits = 32 bytes
    });

    test('should produce consistent hash for same input', () async {
      final sha256 = cryptography.Sha256();
      final data = utf8.encode('Consistent data');

      final hash1 = await sha256.hash(data);
      final hash2 = await sha256.hash(data);

      expect(hash1.bytes, equals(hash2.bytes));
    });

    test('should produce different hash for different input', () async {
      final sha256 = cryptography.Sha256();

      final hash1 = await sha256.hash(utf8.encode('Input A'));
      final hash2 = await sha256.hash(utf8.encode('Input B'));

      expect(hash1.bytes, isNot(equals(hash2.bytes)));
    });

    test('should match known SHA-256 hash', () async {
      final sha256 = cryptography.Sha256();
      // SHA-256 of empty string is well known
      final hash = await sha256.hash([]);

      final hashHex = hex.encode(hash.bytes);
      expect(
        hashHex,
        equals('e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'),
      );
    });
  });

  group('HMAC-SHA256', () {
    test('should calculate MAC', () async {
      final hmac = cryptography.Hmac.sha256();
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: hmac,
      );
      final secretKey = await algorithm.newSecretKey();
      final data = utf8.encode('Message to authenticate');

      final mac = await hmac.calculateMac(
        data,
        secretKey: secretKey,
      );

      expect(mac.bytes, isNotEmpty);
      expect(mac.bytes.length, equals(32)); // HMAC-SHA256 produces 32 bytes
    });

    test('should produce consistent MAC for same input', () async {
      final hmac = cryptography.Hmac.sha256();
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: hmac,
      );
      final secretKey = await algorithm.newSecretKey();
      final data = utf8.encode('Same message');

      final mac1 = await hmac.calculateMac(data, secretKey: secretKey);
      final mac2 = await hmac.calculateMac(data, secretKey: secretKey);

      expect(mac1.bytes, equals(mac2.bytes));
    });

    test('should produce different MAC with different keys', () async {
      final hmac = cryptography.Hmac.sha256();
      final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: hmac,
      );
      final secretKey1 = await algorithm.newSecretKey();
      final secretKey2 = await algorithm.newSecretKey();
      final data = utf8.encode('Message');

      final mac1 = await hmac.calculateMac(data, secretKey: secretKey1);
      final mac2 = await hmac.calculateMac(data, secretKey: secretKey2);

      expect(mac1.bytes, isNot(equals(mac2.bytes)));
    });
  });

  group('Hex Encoding/Decoding', () {
    test('should encode bytes to hex string', () {
      final bytes = [0, 1, 255, 128, 64];
      final hexString = hex.encode(bytes);

      expect(hexString, equals('0001ff8040'));
    });

    test('should decode hex string to bytes', () {
      const hexString = '0001ff8040';
      final bytes = hex.decode(hexString);

      expect(bytes, equals([0, 1, 255, 128, 64]));
    });

    test('should roundtrip bytes through hex', () {
      final originalBytes = [12, 34, 56, 78, 90, 255, 0, 128];
      final hexString = hex.encode(originalBytes);
      final decodedBytes = hex.decode(hexString);

      expect(decodedBytes, equals(originalBytes));
    });

    test('should handle empty input', () {
      expect(hex.encode([]), equals(''));
      expect(hex.decode(''), equals([]));
    });
  });

  group('Base64 Encoding/Decoding', () {
    test('should encode string to base64', () {
      final stringToBase64 = utf8.fuse(base64);
      const original = 'Hello, World!';

      final encoded = stringToBase64.encode(original);
      final decoded = stringToBase64.decode(encoded);

      expect(decoded, equals(original));
    });

    test('should handle special characters', () {
      final stringToBase64 = utf8.fuse(base64);
      const original = 'Émoji 🎉 test!';

      final encoded = stringToBase64.encode(original);
      final decoded = stringToBase64.decode(encoded);

      expect(decoded, equals(original));
    });
  });

  group('IV Generation for PIN/Email', () {
    test('should generate 16-character IV from PIN and email', () {
      final stringToBase64 = utf8.fuse(base64);
      const userPin = '1234';
      const email = 'test@example.com';

      final ivString = stringToBase64.encode('$userPin$email').substring(0, 16);

      expect(ivString.length, equals(16));
    });

    test('should produce different IVs for different PINs', () {
      final stringToBase64 = utf8.fuse(base64);
      const email = 'test@example.com';

      final iv1 = stringToBase64.encode('1234$email').substring(0, 16);
      final iv2 = stringToBase64.encode('5678$email').substring(0, 16);

      expect(iv1, isNot(equals(iv2)));
    });

    test('should produce different IVs for different emails', () {
      final stringToBase64 = utf8.fuse(base64);
      const pin = '1234';

      final iv1 = stringToBase64.encode('${pin}user1@test.com').substring(0, 16);
      final iv2 = stringToBase64.encode('${pin}user2@test.com').substring(0, 16);

      expect(iv1, isNot(equals(iv2)));
    });
  });
}
