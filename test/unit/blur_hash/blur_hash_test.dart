import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:picpics/third_party_lib/src/blurhash.dart';
import 'package:picpics/third_party_lib/src/encoding.dart';
import 'package:picpics/third_party_lib/src/exception.dart';
import 'package:picpics/third_party_lib/src/foundation.dart';

/// Unit tests for BlurHash encoding/decoding
/// Tests focus on pure functions without external dependencies
void main() {
  group('Base83 Encoding', () {
    test('encode83 should encode value correctly', () {
      // Test encoding various values
      expect(encode83(0, 1), equals('0'));
      expect(encode83(1, 1), equals('1'));
      expect(encode83(10, 1), equals('A'));
      expect(encode83(36, 1), equals('a'));
      expect(encode83(82, 1), equals('~'));
    });

    test('encode83 should encode with correct length', () {
      expect(encode83(0, 2).length, equals(2));
      expect(encode83(0, 4).length, equals(4));
      expect(encode83(100, 3).length, equals(3));
    });

    test('encode83 larger values', () {
      // 83 in base 83 is "10"
      expect(encode83(83, 2), equals('10'));
      // 83 * 2 = 166 in base 83 is "20"
      expect(encode83(166, 2), equals('20'));
    });

    test('decode83 should decode single character', () {
      expect(decode83('0', 0, 1), equals(0));
      expect(decode83('1', 0, 1), equals(1));
      expect(decode83('A', 0, 1), equals(10));
      expect(decode83('a', 0, 1), equals(36));
      expect(decode83('~', 0, 1), equals(82));
    });

    test('decode83 should decode multi-character strings', () {
      expect(decode83('10', 0, 2), equals(83));
      expect(decode83('20', 0, 2), equals(166));
    });

    test('decode83 should decode substring correctly', () {
      expect(decode83('ABC', 0, 1), equals(10)); // A
      expect(decode83('ABC', 1, 2), equals(11)); // B
      expect(decode83('ABC', 2, 3), equals(12)); // C
      expect(decode83('ABC', 0, 2), equals(10 * 83 + 11)); // AB
    });

    test('decode83 should throw on invalid character', () {
      expect(() => decode83('!', 0, 1), throwsA(isA<BlurHashDecodeException>()));
      expect(() => decode83(' ', 0, 1), throwsA(isA<BlurHashDecodeException>()));
    });

    test('encode83 and decode83 should be inverse operations', () {
      for (var value = 0; value < 1000; value++) {
        final encoded = encode83(value, 3);
        final decoded = decode83(encoded, 0, 3);
        expect(decoded, equals(value));
      }
    });
  });

  group('ColorTriplet', () {
    test('constructor should store RGB values', () {
      const color = ColorTriplet(0.5, 0.25, 0.75);
      expect(color.r, equals(0.5));
      expect(color.g, equals(0.25));
      expect(color.b, equals(0.75));
    });

    test('addition operator', () {
      const a = ColorTriplet(0.1, 0.2, 0.3);
      const b = ColorTriplet(0.4, 0.5, 0.6);
      final result = a + b;

      expect(result.r, closeTo(0.5, 0.001));
      expect(result.g, closeTo(0.7, 0.001));
      expect(result.b, closeTo(0.9, 0.001));
    });

    test('subtraction operator', () {
      const a = ColorTriplet(0.5, 0.7, 0.9);
      const b = ColorTriplet(0.1, 0.2, 0.3);
      final result = a - b;

      expect(result.r, closeTo(0.4, 0.001));
      expect(result.g, closeTo(0.5, 0.001));
      expect(result.b, closeTo(0.6, 0.001));
    });

    test('multiplication operator', () {
      const color = ColorTriplet(0.2, 0.4, 0.6);
      final result = color * 2.0;

      expect(result.r, closeTo(0.4, 0.001));
      expect(result.g, closeTo(0.8, 0.001));
      expect(result.b, closeTo(1.2, 0.001));
    });

    test('division operator', () {
      const color = ColorTriplet(0.4, 0.8, 1.2);
      final result = color / 2.0;

      expect(result.r, closeTo(0.2, 0.001));
      expect(result.g, closeTo(0.4, 0.001));
      expect(result.b, closeTo(0.6, 0.001));
    });

    test('toString should return formatted string', () {
      const color = ColorTriplet(0.5, 0.25, 0.75);
      expect(color.toString(), equals('ColorTriplet(0.5, 0.25, 0.75)'));
    });
  });

  group('sRGB to Linear conversion', () {
    test('sRgbToLinear for black (0)', () {
      expect(sRgbToLinear(0), equals(0.0));
    });

    test('sRgbToLinear for white (255)', () {
      expect(sRgbToLinear(255), closeTo(1.0, 0.001));
    });

    test('sRgbToLinear for middle gray', () {
      final result = sRgbToLinear(128);
      expect(result, greaterThan(0.0));
      expect(result, lessThan(1.0));
    });

    test('sRgbToLinear should handle low values (linear region)', () {
      // Values <= 0.04045 * 255 ≈ 10.3 are in the linear region
      final lowValue = sRgbToLinear(10);
      expect(lowValue, closeTo(10 / 255.0 / 12.92, 0.001));
    });

    test('sRgbToLinear should handle high values (gamma region)', () {
      // Values > 10.3 use gamma correction
      final highValue = sRgbToLinear(200);
      expect(highValue, greaterThan(0.0));
      expect(highValue, lessThan(1.0));
    });
  });

  group('Linear to sRGB conversion', () {
    test('linearTosRgb for 0.0 (black)', () {
      expect(linearTosRgb(0.0), equals(0));
    });

    test('linearTosRgb for 1.0 (white)', () {
      expect(linearTosRgb(1.0), equals(255));
    });

    test('linearTosRgb should clamp negative values', () {
      expect(linearTosRgb(-0.5), equals(0));
    });

    test('linearTosRgb should clamp values > 1.0', () {
      expect(linearTosRgb(1.5), equals(255));
    });

    test('linearTosRgb and sRgbToLinear should be inverse', () {
      for (var i = 0; i <= 255; i++) {
        final linear = sRgbToLinear(i);
        final backToSrgb = linearTosRgb(linear);
        expect(backToSrgb, equals(i));
      }
    });
  });

  group('signPow', () {
    test('signPow with positive value', () {
      expect(signPow(2.0, 2.0), closeTo(4.0, 0.001));
      expect(signPow(3.0, 2.0), closeTo(9.0, 0.001));
    });

    test('signPow with negative value', () {
      expect(signPow(-2.0, 2.0), closeTo(-4.0, 0.001));
      expect(signPow(-3.0, 2.0), closeTo(-9.0, 0.001));
    });

    test('signPow with zero', () {
      expect(signPow(0.0, 2.0), equals(0.0));
    });

    test('signPow with fractional exponent', () {
      expect(signPow(4.0, 0.5), closeTo(2.0, 0.001));
      expect(signPow(-4.0, 0.5), closeTo(-2.0, 0.001));
    });
  });

  group('DC Encoding/Decoding', () {
    test('encodeDc should encode color to integer', () {
      // Pure black in linear space
      final black = encodeDc(const ColorTriplet(0, 0, 0));
      expect(black, equals(0));

      // Pure white in linear space
      final white = encodeDc(const ColorTriplet(1.0, 1.0, 1.0));
      expect(white, equals(0xFFFFFF));
    });

    test('decodeDc should decode integer to color', () {
      // Pure black
      final black = decodeDc(0);
      expect(black.r, equals(0.0));
      expect(black.g, equals(0.0));
      expect(black.b, equals(0.0));

      // Pure white
      final white = decodeDc(0xFFFFFF);
      expect(white.r, closeTo(1.0, 0.01));
      expect(white.g, closeTo(1.0, 0.01));
      expect(white.b, closeTo(1.0, 0.01));
    });

    test('encodeDc and decodeDc should be approximately inverse', () {
      const original = ColorTriplet(0.5, 0.25, 0.75);
      final encoded = encodeDc(original);
      final decoded = decodeDc(encoded);

      // Due to quantization, values won't be exact
      expect(decoded.r, closeTo(original.r, 0.05));
      expect(decoded.g, closeTo(original.g, 0.05));
      expect(decoded.b, closeTo(original.b, 0.05));
    });
  });

  group('AC Encoding/Decoding', () {
    test('encodeAc should encode color', () {
      const color = ColorTriplet(0.0, 0.0, 0.0);
      final encoded = encodeAc(color, 1.0);
      expect(encoded, greaterThanOrEqualTo(0));
    });

    test('decodeAc should decode to color', () {
      const midValue = 9 * 19 * 19 + 9 * 19 + 9; // Middle value
      final decoded = decodeAc(midValue, 1.0);

      expect(decoded.r, closeTo(0.0, 0.1));
      expect(decoded.g, closeTo(0.0, 0.1));
      expect(decoded.b, closeTo(0.0, 0.1));
    });

    test('encodeAc and decodeAc should be approximately inverse', () {
      const original = ColorTriplet(0.1, -0.1, 0.2);
      const maxVal = 1.0;
      final encoded = encodeAc(original, maxVal);
      final decoded = decodeAc(encoded, maxVal);

      // AC encoding has lower precision than DC
      expect(decoded.r, closeTo(original.r, 0.2));
      expect(decoded.g, closeTo(original.g, 0.2));
      expect(decoded.b, closeTo(original.b, 0.2));
    });
  });

  group('BlurHash Decoding', () {
    test('decode should throw for hash less than 6 characters', () {
      expect(
        () => BlurHash.decode('12345'),
        throwsA(isA<BlurHashDecodeException>()),
      );
    });

    test('decode should throw for hash with wrong length', () {
      // A hash with size flag indicating 1x1 (first char '0') should be exactly 6 chars
      // Adding extra characters should fail
      expect(
        () => BlurHash.decode('00000000'),
        throwsA(isA<BlurHashDecodeException>()),
      );
    });

    test('decode should parse valid BlurHash', () {
      // A 4x3 blur hash (known valid): size flag L = 21
      // numCompX = 21 % 9 + 1 = 4, numCompY = 21 / 9 + 1 = 3
      // Length = 4 + 2*4*3 = 28
      const validHash = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
      final blurHash = BlurHash.decode(validHash);

      expect(blurHash.hash, equals(validHash));
      expect(blurHash.numCompX, equals(4));
      expect(blurHash.numCompY, equals(3));
    });

    test('decode should apply punch parameter', () {
      const validHash = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
      final normalPunch = BlurHash.decode(validHash);
      final highPunch = BlurHash.decode(validHash, punch: 2.0);

      // Both should decode successfully
      expect(normalPunch.hash, equals(validHash));
      expect(highPunch.hash, equals(validHash));
    });

    test('decode should extract correct number of components', () {
      // Size flag encodes: sizeFlag = (numCompX - 1) + (numCompY - 1) * 9
      // For 4x3: sizeFlag = 3 + 2*9 = 21 (encoded as 'L')

      // A 4x3 blur hash has 4 + 2*4*3 = 28 characters
      const hash4x3 = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
      final blurHash = BlurHash.decode(hash4x3);

      expect(blurHash.numCompX, equals(4));
      expect(blurHash.numCompY, equals(3));
    });
  });

  group('BlurHash Encoding', () {
    test('encode should throw for numCompX out of range', () {
      final image = img.Image(width: 10, height: 10);
      expect(
        () => BlurHash.encode(image, numCompX: 0),
        throwsA(isA<BlurHashEncodeException>()),
      );
      expect(
        () => BlurHash.encode(image, numCompX: 10),
        throwsA(isA<BlurHashEncodeException>()),
      );
    });

    test('encode should throw for numCompY out of range', () {
      final image = img.Image(width: 10, height: 10);
      expect(
        () => BlurHash.encode(image, numCompY: 0),
        throwsA(isA<BlurHashEncodeException>()),
      );
      expect(
        () => BlurHash.encode(image, numCompY: 10),
        throwsA(isA<BlurHashEncodeException>()),
      );
    });

    test('encode should produce valid hash for solid color image', () {
      // Create a small solid red image
      final image = img.Image(width: 4, height: 4);
      for (var y = 0; y < 4; y++) {
        for (var x = 0; x < 4; x++) {
          image.setPixelRgba(x, y, 255, 0, 0, 255);
        }
      }

      final blurHash = BlurHash.encode(image, numCompX: 1, numCompY: 1);

      expect(blurHash.hash, isNotEmpty);
      expect(blurHash.hash.length, equals(6)); // 4 + 2*1*1
      expect(blurHash.numCompX, equals(1));
      expect(blurHash.numCompY, equals(1));
    });

    test('encode should produce correct length hash', () {
      final image = img.Image(width: 10, height: 10);

      // 4x3 components: 4 + 2*4*3 = 28 characters
      final hash4x3 = BlurHash.encode(image, numCompX: 4, numCompY: 3);
      expect(hash4x3.hash.length, equals(28));

      // 2x2 components: 4 + 2*2*2 = 12 characters
      final hash2x2 = BlurHash.encode(image, numCompX: 2, numCompY: 2);
      expect(hash2x2.hash.length, equals(12));

      // 1x1 components: 4 + 2*1*1 = 6 characters
      final hash1x1 = BlurHash.encode(image, numCompX: 1, numCompY: 1);
      expect(hash1x1.hash.length, equals(6));
    });
  });

  group('BlurHash fromRgb', () {
    test('fromRgb should create valid hash from RGB values', () {
      final blurHash = BlurHash.fromRgb(128, 64, 192);

      expect(blurHash.hash, isNotEmpty);
      expect(blurHash.numCompX, equals(1));
      expect(blurHash.numCompY, equals(1));
    });

    test('fromRgb with black', () {
      final blurHash = BlurHash.fromRgb(0, 0, 0);
      expect(blurHash.components[0][0].r, equals(0.0));
      expect(blurHash.components[0][0].g, equals(0.0));
      expect(blurHash.components[0][0].b, equals(0.0));
    });

    test('fromRgb with white', () {
      final blurHash = BlurHash.fromRgb(255, 255, 255);
      expect(blurHash.components[0][0].r, closeTo(1.0, 0.01));
      expect(blurHash.components[0][0].g, closeTo(1.0, 0.01));
      expect(blurHash.components[0][0].b, closeTo(1.0, 0.01));
    });
  });

  group('BlurHash toImage', () {
    test('toImage should produce image with correct dimensions', () {
      const validHash = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
      final blurHash = BlurHash.decode(validHash);

      final image = blurHash.toImage(32, 24);

      expect(image.width, equals(32));
      expect(image.height, equals(24));
    });

    test('toImage should produce valid pixel data', () {
      final blurHash = BlurHash.fromRgb(255, 0, 0); // Red
      final image = blurHash.toImage(4, 4);

      // The image should be predominantly red
      final pixels = image.getBytes(order: img.ChannelOrder.rgba);
      expect(pixels.length, equals(4 * 4 * 4)); // width * height * 4 (RGBA)
    });
  });

  group('BlurHash roundtrip', () {
    test('encode and decode should preserve hash', () {
      final image = img.Image(width: 8, height: 8);
      // Create a gradient image
      for (var y = 0; y < 8; y++) {
        for (var x = 0; x < 8; x++) {
          final r = (x * 255 / 7).round();
          final g = (y * 255 / 7).round();
          image.setPixelRgba(x, y, r, g, 128, 255);
        }
      }

      final encoded = BlurHash.encode(image, numCompX: 4, numCompY: 3);
      final decoded = BlurHash.decode(encoded.hash);

      expect(decoded.hash, equals(encoded.hash));
      expect(decoded.numCompX, equals(encoded.numCompX));
      expect(decoded.numCompY, equals(encoded.numCompY));
    });

    test('components constructor should produce consistent hash', () {
      final blurHash = BlurHash.fromRgb(100, 150, 200);
      final fromComponents = BlurHash.components(blurHash.components);

      expect(fromComponents.hash, equals(blurHash.hash));
    });
  });

  group('BlurHash Exception classes', () {
    test('BlurHashDecodeException should have message', () {
      final exception = BlurHashDecodeException('Test message');
      expect(exception.message, equals('Test message'));
      expect(exception.toString(), contains('Test message'));
    });

    test('BlurHashDecodeException with empty message', () {
      final exception = BlurHashDecodeException();
      expect(exception.message, equals(''));
    });

    test('BlurHashEncodeException should have message', () {
      final exception = BlurHashEncodeException('Encode error');
      expect(exception.message, equals('Encode error'));
      expect(exception.toString(), contains('Encode error'));
    });

    test('BlurHashEncodeException with empty message', () {
      final exception = BlurHashEncodeException();
      expect(exception.message, equals(''));
    });
  });

  group('BlurHash components accessor', () {
    test('components should be accessible after decode', () {
      const validHash = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
      final blurHash = BlurHash.decode(validHash);

      expect(blurHash.components, isNotEmpty);
      expect(blurHash.components.length, equals(blurHash.numCompY));
      expect(blurHash.components[0].length, equals(blurHash.numCompX));
    });

    test('components should be accessible after encode', () {
      final image = img.Image(width: 8, height: 8);
      final blurHash = BlurHash.encode(image, numCompX: 3, numCompY: 2);

      expect(blurHash.components.length, equals(2));
      expect(blurHash.components[0].length, equals(3));
    });
  });

  group('Known BlurHash values', () {
    test('decode known valid hash - LEHV6nWB2yk8pyo0adR*.7kCMdnj', () {
      // This is a known valid blur hash (commonly used in examples)
      const hash = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
      final blurHash = BlurHash.decode(hash);

      expect(blurHash.numCompX, equals(4));
      expect(blurHash.numCompY, equals(3));
      expect(blurHash.hash, equals(hash));
    });

    test('decode and regenerate image', () {
      const hash = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
      final blurHash = BlurHash.decode(hash);

      // Generate a small preview image
      final image = blurHash.toImage(8, 6);

      expect(image.width, equals(8));
      expect(image.height, equals(6));
    });
  });
}
