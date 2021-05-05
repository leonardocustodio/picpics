import 'package:encrypt/encrypt.dart' as E;
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:picPics/stores/tags_controller.dart';
import '../constants.dart';

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
    String result;
    if (str?.isNotEmpty ?? false) {
      result = str.substring(0, str.length - 1);
    }

    return result ?? '';
  }
}

LinearGradient getGradient(int _) {
  switch (_) {
    case 0:
      return kPrimaryGradient;
    case 1:
      return kSecondaryGradient;
    case 2:
      return kPinkGradient;
    default:
      return kCardYellowGradient;
  }
}

typedef CallBack = Function(bool);

void doCustomisedSearching(
    dynamic tag, List<String> listOfLetters, CallBack callback) {
  if (tag == null) callback(false);

  var matched = true;
  var title = (tag is TagModel ? tag?.title : tag)?.toLowerCase();
  var i = 0;
  for (var index = 0; index < listOfLetters.length; index++) {
    var found = false;
    while (i < title.length) {
      if (listOfLetters[index] == title[i]) {
        found = true;
        i++;
        break;
      }
      i++;
    }
    if (!found) {
      matched = false;
      break;
    }
  }
  callback(matched);
}
