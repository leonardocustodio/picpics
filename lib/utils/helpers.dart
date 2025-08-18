import 'package:diacritic/diacritic.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/utils/app_logger.dart';

class Helpers {
  static Widget failedItem = const Center(
    child: Text(
      'Failed loading',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18),
    ),
  );
  static String dateFormat(DateTime dateTime, {bool isMonth = true}) {
    DateFormat formatter;
    AppLogger.d('Date Time Formatting: $dateTime');

    /// More Optimized code
    if (isMonth) {
      formatter = DateFormat.yMMMM();
    } else {
      formatter = dateTime.year == DateTime.now().year
          ? DateFormat.MMMEd()
          : DateFormat.yMMMEd();
    }
    return formatter.format(dateTime);
  }

  static String stripTag(String tag) => removeDiacritics(tag.toLowerCase());

  static String encryptTag(String tag) {
    final plainText = stripTag(tag);

    final key = encrypt.Key.fromUtf8('picpics key for encrypting tags!');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    AppLogger.d('Stripped tag: $tag');

    AppLogger.d('Encrypted tag: ${encrypted.base16}');
    return encrypted.base16;
  }

  static String decryptTag(String encrypted) {
    final key = encrypt.Key.fromUtf8('picpics key for encrypting tags!');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encryptedData = encrypt.Encrypted.fromBase16(encrypted);
    final decrypted = encrypter.decrypt(encryptedData, iv: iv);

    AppLogger.d('Decrypted tag: $decrypted');
    return decrypted;
  }

  static String removeLastCharacter(String? str) {
    String? result;
    if (str?.isNotEmpty ?? false) {
      result = str!.substring(0, str.length - 1);
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
    tag, List<String> listOfLetters, CallBack callback,) {
  if (tag == null) {
    callback(false);
    return;
  }

  var matched = true;
  final titleNullable = tag is TagModel ? tag.title : tag?.toString();
  if (titleNullable == null) {
    callback(false);
    return;
  }
  final title = titleNullable.toLowerCase();
  
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
