import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:picPics/stores/pic_store.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

class Crypto {
  static Future<bool> checkIsPinValid(String userPin) async {
    final storage = FlutterSecureStorage();
    String ppkey = await storage.read(key: 'ppkey');
    String hpkey = await storage.read(key: 'hpkey');
    String spkey = await storage.read(key: 'spkey');

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String ivString = stringToBase64.encode('${userPin}leonardo@custodio.me').substring(0, 16);
    final picKey = Key.fromUtf8('pic key password');
    final iv = IV.fromUtf8(ivString);

    final encrypter = Encrypter(AES(picKey, mode: AESMode.ctr));

    try {
      final String decryptedKey = encrypter.decrypt(Encrypted.fromBase64(spkey), iv: iv);
      print('Server key after decrypt: $decryptedKey');

      print('Hasing it to check if it is the correct key');
      final bytes = utf8.encode(decryptedKey); // data being hashed
      final digest = sha256.convert(bytes).toString();
      print('Hashed key is: $digest');

      if (digest == hpkey) {
        print('The key is valid!');
        return true;
      }

      print('The key is invalid');
      return false;
    } catch (error) {
      print('Failed to decrypt key invalid padblock!');
      return false;
    }
  }

  static Future<void> saveSaltKey() async {
    final storage = FlutterSecureStorage();
    final secretSalt = Uuid().v4();
    await storage.write(key: 'ppkey', value: secretSalt);
    print('Secret salt: $secretSalt');
  }

  static Future<void> saveSpKey(String accessKey, String spKey, String userPin) async {
    final storage = FlutterSecureStorage();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // String accessBase64 = stringToBase64.encode(accessKey);
    String generateIv = '$accessKey${accessKey.substring(0, 4)}$accessKey';

    final picAccessKey = Key.fromUtf8('PeShVkYp3s6v9y9BVEpHxMcQfTjWnZq4');
    final ivAccess = IV.fromUtf8(generateIv);

    print('SpKey: $spKey');
    var encryptedValue = Encrypted.fromBase16(spKey);
    print('Encrypted: $encryptedValue');

    final encrypter = Encrypter(AES(picAccessKey, mode: AESMode.ctr, padding: null));
    final String decryptedKey = encrypter.decrypt(encryptedValue, iv: ivAccess);

    print('Decrypted spKey is: $decryptedKey');

    final bytes = utf8.encode(decryptedKey); // data being hashed
    final digest = sha256.convert(bytes);
    print('Saving hashed spKey: ${digest.toString()}');
    await storage.write(key: 'hpkey', value: digest.toString());

    final picKey = Key.fromUtf8('pic key password');
    final String ivString = stringToBase64.encode('${userPin}leonardo@custodio.me').substring(0, 16);
    print('New generated IV for encryption: $ivString');
    final ivKey = IV.fromUtf8(ivString);

    final encrypt = Encrypter(AES(picKey, mode: AESMode.ctr));
    final encrypted = encrypt.encrypt(decryptedKey, iv: ivKey);

    print('New key encrypted with pin: ${encrypted.base64}');

    await storage.write(key: 'spkey', value: encrypted.base64);
    print('key saved to storage!');
  }

  static Future<String> getAesKey() async {
    final storage = FlutterSecureStorage();
    final String secretSalt = await storage.read(key: 'ppkey');
    final String serverKey = await storage.read(key: 'spkey');
    print('Server key encoded as base64: $serverKey');

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String ivString = stringToBase64.encode('111111leonardo@custodio.me').substring(0, 16);

    final picKey = Key.fromUtf8('pic key password');
    final iv = IV.fromUtf8(ivString);

    final encrypter = Encrypter(AES(picKey, mode: AESMode.ctr));
    final String decryptedKey = encrypter.decrypt(Encrypted.fromBase64(serverKey), iv: iv);
    print('Server key after decrypt: $decryptedKey');
    print('Key used for encrypting files: ${stringToBase64.encode("${secretSalt}:${decryptedKey}")}');
    return stringToBase64.encode("${secretSalt}:${decryptedKey}");
  }

  static encryptImage(PicStore picStore) async {
    print('Going to encrypt image!!!');
    String key = await getAesKey();
    print('final key: $key');

    var crypt = AesCrypt(key);
    crypt.setOverwriteMode(AesCryptOwMode.rename);

    File assetFile = await picStore.entity.originFile;
    File assetOtherFile = await picStore.entity.file;

    print('Asset Name: ${picStore.entity.id}');
    print('Origin file: ${assetFile.path} - File: ${assetOtherFile.path}');

    if (assetFile == null) {
      return;
    }

    Directory appSupportDir = await getApplicationSupportDirectory();
    String appSupportPath = p.join(appSupportDir.path, 'photos');

    final dirExists = await Directory(appSupportPath).exists();
    if (!dirExists) {
      Directory(appSupportPath).create();
    }

    String fileName = p.basename(assetFile.path);
    String finalPath = p.join(appSupportPath, fileName);

    print('Got asset file!!! Going to encrypt it!');
    String savedFile = crypt.encryptFileSync(assetFile.path, finalPath);
    print('Saved file: ${assetFile.path} to $savedFile');

    await picStore.setPrivatePath(savedFile);
  }

  static Future<Uint8List> decryptImage(String filePath) async {
    String key = await getAesKey();
    print('final key: $key');

    var crypt = AesCrypt(key);
    print('Decrypting image...');
    Uint8List decryptedData = await crypt.decryptDataFromFileSync(filePath);
    print('Decrypted data');
    return decryptedData;
    // return File.fromRawPath(decryptedData);
  }
}
