import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:uuid/uuid.dart';
import 'package:cryptography_flutter/cryptography.dart';

class Crypto {
  static Future<String> encryptAccessKey(
      String accessCode, String email, String randomIv) async {
    final SecretKey picKey =
        SecretKey(utf8.encode('bQeThWmZq3t6w9z9CxF0JLNcRfUjXn2r'));
    final String ivString = '$randomIv$randomIv${randomIv.substring(0, 4)}';
    final Nonce ivKey = Nonce(utf8.encode(ivString));

    String encryptValue = '$accessCode:${email}';
    final encryptedData = await aesCtr.encrypt(utf8.encode(encryptValue),
        secretKey: picKey, nonce: ivKey);
    final hexData = hex.encode(encryptedData);

    //print('Encrypting $encryptValue - With ivString: $ivString');
    //print('Encrypted value: $hexData');

    return hexData;
  }

  static Future<void> reSaveSpKey(String userPin, AppStore appStore) async {
    final storage = FlutterSecureStorage();
    String ppkey = await storage.read(key: 'ppkey');
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    //print('Decrypted spKey is: ${appStore.tempEncryptionKey}');

    appStore
        .setEncryptionKey(SecretKey(utf8.encode(appStore.tempEncryptionKey)));

    final SecretKey picKey = SecretKey(utf8.encode('1HxMbQeThWmZq3t6'));
    final String ivString =
        stringToBase64.encode('${userPin}${appStore.email}').substring(0, 16);
    //print('New generated IV for encryption: $ivString');
    final Nonce ivKey = Nonce(utf8.encode(ivString));

    final encryptedData = await aesCtr.encrypt(
        utf8.encode(appStore.tempEncryptionKey),
        secretKey: picKey,
        nonce: ivKey);
    final hexData = hex.encode(encryptedData);

    //print('New key encrypted with new pin: $hexData');
    await storage.write(key: 'spkey', value: hexData);
    //print('New key saved to storage!');
  }

  static Future<bool> checkRecoveryKey(String encryptedRecoveryKey,
      String recoveryCode, String randomIv, AppStore appStore) async {
    final storage = FlutterSecureStorage();
    String hpkey = await storage.read(key: 'hpkey');

    String generatedIv = '$randomIv$randomIv${randomIv.substring(0, 4)}';
    String recoveryIv =
        '$recoveryCode${recoveryCode.substring(0, 4)}$recoveryCode';

    final SecretKey picKey =
        SecretKey(utf8.encode('PeShVkYp3s6v9y9BVEpHxMcQfTjWnZq4'));
    final Nonce ivRecovery = Nonce(utf8.encode(recoveryIv));
    final Nonce ivGenerated = Nonce(utf8.encode(generatedIv));

    var encryptedValue = hex.decode(encryptedRecoveryKey);
    //print('Encrypted Recovery Key: $encryptedRecoveryKey - Recovery Code: $recoveryCode - Random IV: $randomIv - Generated IV: $generatedIv');

    try {
      final decryptedFirstData = await aesCtr.decrypt(encryptedValue,
          secretKey: picKey, nonce: ivRecovery);
      final decryptedFirstStep = utf8.decode(decryptedFirstData);
      //print('First Step Decrypted: $decryptedFirstStep');

      final decryptedFinal = await aesCtr.decrypt(
          hex.decode(decryptedFirstStep),
          secretKey: picKey,
          nonce: ivGenerated);
      final decryptedData = utf8.decode(decryptedFinal);
      //print('Final decrypted value: $decryptedData');

      final digest = hex.encode((await sha256.hash(decryptedFinal)).bytes);
      //print('Final key hashed: $digest');
      //print('Saved hash: $hpkey');

      if (digest == hpkey) {
        appStore.setTempEncryptionKey(decryptedData);
        return true;
      }

      //print('Not the real key');
      return false;
    } catch (error) {
      //print('Not the real key');
      return false;
    }
  }

  static Future<bool> checkIsPinValid(String userPin, AppStore appStore) async {
    final storage = FlutterSecureStorage();
    String ppkey = await storage.read(key: 'ppkey');
    String hpkey = await storage.read(key: 'hpkey');
    String spkey = await storage.read(key: 'spkey');

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String ivString =
        stringToBase64.encode('${userPin}${appStore.email}').substring(0, 16);
    final SecretKey picKey = SecretKey(utf8.encode('1HxMbQeThWmZq3t6'));
    final Nonce iv = Nonce(utf8.encode(ivString));

    try {
      final decryptedData =
          await aesCtr.decrypt(hex.decode(spkey), secretKey: picKey, nonce: iv);
      final decryptedString = hex.encode(decryptedData);

      //print('Server key after decrypt: $decryptedString');

      //print('Hasing it to check if it is the correct key');
      final digest = hex.encode((await sha256.hash(decryptedData)).bytes);
      //print('Hashed key is: $digest');

      if (digest == hpkey) {
        //print('The key is valid!');
        //print('ppkey: $ppkey - nonce: ${utf8.encode(ppkey)}');
        print('Decrypted Key: $decryptedData');
        appStore.setEncryptionKey(SecretKey(decryptedData));
        return true;
      }

      //print('The key is invalid');
      return false;
    } catch (error) {
      //print('Failed to decrypt key invalid padblock!');
      return false;
    }
  }

  static Future<void> saveSaltKey() async {
    final storage = FlutterSecureStorage();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String secretSalt =
        stringToBase64.encode(Uuid().v4()).substring(0, 16);
    await storage.write(key: 'ppkey', value: secretSalt);
    //print('Secret salt: $secretSalt');
  }

  static Future<void> saveSpKey(String accessKey, String spKey, String userPin,
      String userEmail, AppStore appStore) async {
    final storage = FlutterSecureStorage();
    String ppkey = await storage.read(key: 'ppkey');
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String generateIv = '$accessKey${accessKey.substring(0, 4)}$accessKey';

    final SecretKey picAccessKey =
        SecretKey(utf8.encode('PeShVkYp3s6v9y9BVEpHxMcQfTjWnZq4'));
    final Nonce ivAccess = Nonce(utf8.encode(generateIv));

    //print('SpKey: $spKey');
    //print('Encrypted: $spKey');

    final decryptedKey = await aesCtr.decrypt(hex.decode(spKey),
        secretKey: picAccessKey, nonce: ivAccess);
    final hexData = hex.encode(decryptedKey);

    //print('Decrypted spKey is: $hexData');
    appStore.setEncryptionKey(SecretKey(decryptedKey));

    //print('Before digest....');
    final digest = hex.encode((await sha256.hash(decryptedKey)).bytes);
    //print('Saving hashed spKey: $digest');
    await storage.write(key: 'hpkey', value: digest);

    final SecretKey picKey = SecretKey(utf8.encode('1HxMbQeThWmZq3t6'));
    final String ivString =
        stringToBase64.encode('${userPin}${userEmail}').substring(0, 16);
    //print('New generated IV for encryption: $ivString');

    final Nonce ivKey = Nonce(utf8.encode(ivString));
    final encrypted =
        await aesCtr.encrypt(decryptedKey, secretKey: picKey, nonce: ivKey);
    final encryptedData = hex.encode(encrypted);

    //print('New key encrypted with pin: $encryptedData');

    await storage.write(key: 'spkey', value: encryptedData);
    //print('key saved to storage!');
  }

  static Future<void> encryptImage(
      PicStore picStore, SecretKey secretKey) async {
    //print('Going to encrypt image with encryption key');

    Uint8List assetData = await picStore.entity.originBytes;
    Uint8List thumbData = await picStore.entity
        .thumbDataWithSize(150, 150, format: ThumbFormat.jpeg, quality: 90);

    String title = Platform.isAndroid
        ? picStore.entity.title
        : await picStore.entity.titleAsync;

    //print('Asset Name: ${picStore.entity.id}');
    //print('Origin file: $title');

    if (assetData == null) {
      return;
    }

    Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    String photosPath = p.join('photos', title);
    String thumbnailsPath = p.join('thumbnails', title);

    final dirExists =
        await Directory(p.join(appDocumentsDir.path, 'photos')).exists();
    if (!dirExists) {
      Directory(p.join(appDocumentsDir.path, 'photos')).create();
      Directory(p.join(appDocumentsDir.path, 'thumbnails')).create();
    }

    String finalPhotoPath = p.join(appDocumentsDir.path, photosPath);
    String finalThumbPath = p.join(appDocumentsDir.path, thumbnailsPath);

    //print('Encrypting....');
    // Using 96 bytes nonce
    final Nonce nonce = Nonce.randomBytes(12);

    var encryptedPicData;
    var encryptedThumbData;
    if (Platform.isAndroid) {
      encryptedPicData =
          await aesCtr.encrypt(assetData, secretKey: secretKey, nonce: nonce);
      encryptedThumbData =
          await aesCtr.encrypt(thumbData, secretKey: secretKey, nonce: nonce);
    } else {
      encryptedPicData =
          await aesGcm.encrypt(assetData, secretKey: secretKey, nonce: nonce);
      encryptedThumbData =
          await aesGcm.encrypt(thumbData, secretKey: secretKey, nonce: nonce);
    }

    //print('Saving to file...');

    final File savedPicFile = File(finalPhotoPath);
    final File savedThumbFile = File(finalThumbPath);
    savedPicFile.writeAsBytes(encryptedPicData);
    savedThumbFile.writeAsBytes(encryptedThumbData);
    print('Writing to ${savedPicFile.path}');
    print('Writing to ${savedThumbFile.path}');

    //print('Saved file: $title to ${savedPicFile.path}');
    // //print('File sizes: ${savedPicFile.lengthSync()} - Thumb Size: ${savedThumbFile.lengthSync()}');

    await picStore.setPrivatePath(
        photosPath, thumbnailsPath, hex.encode(nonce.bytes));
  }

  static Future<Uint8List> decryptImage(
      String imagePath, SecretKey secretKey, Nonce nonce) async {
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String filePath = p.join(appDocumentsDir.path, imagePath);

    final File file = File(filePath);

    print('Secret Key: ${secretKey.toString()}');
    print('Nonce: ${nonce.toString()}');
    print('File exists: ${await file.exists()}');
    print(
        'App Support Dir: ${(await getApplicationDocumentsDirectory()).path}');

    Uint8List decryptedData;
    print('Decrypting image: $filePath');
    if (Platform.isAndroid) {
      decryptedData = await aesCtr.decrypt(
        file.readAsBytesSync(),
        secretKey: secretKey,
        nonce: nonce,
      );
    } else {
      decryptedData = await aesGcm.decrypt(
        file.readAsBytesSync(),
        secretKey: secretKey,
        nonce: nonce,
      );
    }
    print('Decrypted');

    return decryptedData;
  }
}
