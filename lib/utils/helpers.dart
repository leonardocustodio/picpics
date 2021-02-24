import 'package:encrypt/encrypt.dart' as E;
import 'package:diacritic/diacritic.dart';

class Helpers {
  static String stripTag(String tag) => removeDiacritics(tag.toLowerCase());

  static String encryptTag(String tag) {
    final plainText = stripTag(tag);

    final key = E.Key.fromUtf8('picpics key for encrypting tags!');
    final iv = E.IV.fromLength(16);
    final encrypter = E.Encrypter(E.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    //print('Stripped tag: $tag');

    //print('Encrypted tag: ${encrypted.base16}');
    return encrypted.base16;
  }

  static String decryptTag(String encrypted) {
    final key = E.Key.fromUtf8('picpics key for encrypting tags!');
    final iv = E.IV.fromLength(16);
    final encrypter = E.Encrypter(E.AES(key));
    var encrypt = E.Encrypted.fromBase16(encrypted);
    final decrypted = encrypter.decrypt(encrypt, iv: iv);

    //print('Decrypted tag: $decrypted');
    return decrypted;
  }

  static String removeLastCharacter(String str) {
    String result = null;
    if ((str != null) && (str.length > 0)) {
      result = str.substring(0, str.length - 1);
    }

    return result ?? '';
  }
}
