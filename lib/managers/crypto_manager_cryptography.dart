import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:uuid/uuid.dart';
import 'package:cryptography/cryptography.dart' as cryptography;

class Crypto {
  static Future<String> encryptAccessKey(
      String accessCode, String email, String randomIv) async {
    /// preparing the algorithm
    final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256());

    /// preparing the cryptography.SecretKey
    final picKey = await algorithm
        .newSecretKeyFromBytes(utf8.encode('bQeThWmZq3t6w9z9CxF0JLNcRfUjXn2r'));

    final ivString = '$randomIv$randomIv${randomIv.substring(0, 4)}';
    final ivKey = utf8.encode(ivString);

    final encryptValue = '$accessCode:$email';
    final encryptedData = await algorithm.encrypt(utf8.encode(encryptValue),
        secretKey: picKey, nonce: ivKey);

    final hexData = hex.encode(encryptedData.cipherText);

    //print('Encrypting $encryptValue - With ivString: $ivString');
    //print('Encrypted value: $hexData');

    return hexData;
  }

  static Future<void> reSaveSpKey(
      String userPin, UserController appStore) async {
    final storage = FlutterSecureStorage();

    final ppkey = await storage.read(key: 'ppkey') ?? '';
    final stringToBase64 = utf8.fuse(base64);

    //print('Decrypted spKey is: ${appStore.tempEncryptionKey}');

    /// preparing the algorithm
    final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256());

    final encryptionKey = await algorithm
        .newSecretKeyFromBytes(utf8.encode(appStore.tempEncryptionKey));

    appStore.setEncryptionKey(encryptionKey);

    final picKey =
        await algorithm.newSecretKeyFromBytes(utf8.encode('1HxMbQeThWmZq3t6'));

    final ivString =
        stringToBase64.encode('$userPin${appStore.email}').substring(0, 16);

    //print('New generated IV for encryption: $ivString');
    final ivKey = utf8.encode(ivString);

    final encryptedData = await algorithm.encrypt(
        utf8.encode(appStore.tempEncryptionKey),
        secretKey: picKey,
        nonce: ivKey);
    final hexData = hex.encode(encryptedData.cipherText);

    //print('New key encrypted with new pin: $hexData');
    await storage.write(key: 'spkey', value: hexData);
    //print('New key saved to storage!');
  }

  static Future<bool> checkRecoveryKey(String encryptedRecoveryKey,
      String recoveryCode, String randomIv, UserController appStore) async {
    final storage = FlutterSecureStorage();
    final hpkey = await storage.read(key: 'hpkey');

    final generatedIv = '$randomIv$randomIv${randomIv.substring(0, 4)}';
    final recoveryIv =
        '$recoveryCode${recoveryCode.substring(0, 4)}$recoveryCode';

    /// preparing the algorithm
    final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256());

    final picKey = await algorithm
        .newSecretKeyFromBytes(utf8.encode('PeShVkYp3s6v9y9BVEpHxMcQfTjWnZq4'));
    final ivRecovery = utf8.encode(recoveryIv);
    final ivGenerated = utf8.encode(generatedIv);

    var encryptedValue = hex.decode(encryptedRecoveryKey);
    //print('Encrypted Recovery Key: $encryptedRecoveryKey - Recovery Code: $recoveryCode - Random IV: $randomIv - Generated IV: $generatedIv');

    try {
      final secretBoxFirstStep = cryptography.SecretBox(encryptedValue,
          nonce: ivRecovery,
          mac: await cryptography.MacAlgorithm.empty
              .calculateMac(encryptedValue, secretKey: picKey));

      final decryptedFirstData =
          await algorithm.decrypt(secretBoxFirstStep, secretKey: picKey);

      final secretBoxFinalStep = cryptography.SecretBox(decryptedFirstData,
          nonce: ivGenerated,
          mac: await cryptography.MacAlgorithm.empty
              .calculateMac(encryptedValue, secretKey: picKey));
      //print('First Step Decrypted: $decryptedFirstStep');

      final decryptedFinal =
          await algorithm.decrypt(secretBoxFinalStep, secretKey: picKey);
      final decryptedData = utf8.decode(decryptedFinal);
      //print('Final decrypted value: $decryptedData');
      //print('Hp Key: $hpkey');

      final digest =
          hex.encode((await cryptography.Sha256().hash(decryptedFinal)).bytes);
      //print('Final key hashed: $digest');
      //print('Saved hash: $hpkey');

      //print('Final key hash');
      if (hpkey == null) {
        await storage.write(key: 'hpkey', value: digest);
        appStore.setTempEncryptionKey(decryptedData);
        return true;
      }

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

  static Future<bool> checkIsPinValid(
      String userPin, UserController appStore) async {
    final storage = FlutterSecureStorage();
    final ppkey = await storage.read(key: 'ppkey');
    final hpkey = await storage.read(key: 'hpkey');
    final spkey = await storage.read(key: 'spkey') ?? '';

    final stringToBase64 = utf8.fuse(base64);

    final ivString =
        stringToBase64.encode('$userPin${appStore.email}').substring(0, 16);

    /// preparing the algorithm
    final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256());

    final picKey =
        await algorithm.newSecretKeyFromBytes(utf8.encode('1HxMbQeThWmZq3t6'));

    final iv = utf8.encode(ivString);

    try {
      final encryptedValue = hex.decode(spkey);

      final secretBox = cryptography.SecretBox(encryptedValue,
          nonce: iv,
          mac: await cryptography.MacAlgorithm.empty
              .calculateMac(encryptedValue, secretKey: picKey));

      final decryptedData =
          await algorithm.decrypt(secretBox, secretKey: picKey);
      final decryptedString = hex.encode(decryptedData);

      //print('Server key after decrypt: $decryptedString');

      //print('Hasing it to check if it is the correct key');
      final digest =
          hex.encode((await cryptography.Sha256().hash(decryptedData)).bytes);
      //print('Hashed key is: $digest');

      if (digest == hpkey) {
        //print('The key is valid!');
        //print('ppkey: $ppkey - nonce: ${utf8.encode(ppkey)}');
        //print('Decrypted Key: $decryptedData');
        appStore.setEncryptionKey(
            await algorithm.newSecretKeyFromBytes(decryptedData));
        return true;
      }

      //print('The key is invalid');
      return false;
    } catch (error) {
      //print('Failed to decrypt key invalid padblock!');
      return false;
    }
  }

  static Future<String?> getEncryptedPin(UserController appStore) async {
    final storage = FlutterSecureStorage();

    final secretString = appStore.getSecretKey();
    final nounceString = await storage.read(key: 'npkey') ?? '';
    final encryptedPin = await storage.read(key: 'epkey') ?? '';

    /// preparing the algorithm
    final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256());

    final picKey =
        await algorithm.newSecretKeyFromBytes(hex.decode(secretString));

    final ivKey = hex.decode(nounceString);

    try {
      final encryptedValue = hex.decode(encryptedPin);
      final secretBox = cryptography.SecretBox(encryptedValue,
          nonce: ivKey,
          mac: await cryptography.MacAlgorithm.empty
              .calculateMac(encryptedValue, secretKey: picKey));
      final decryptedData =
          await algorithm.decrypt(secretBox, secretKey: picKey);
      //print('Pin: ${utf8.decode(decryptedData)}');
      return utf8.decode(decryptedData);
    } catch (error) {
      return null;
    }
  }

  static Future<void> deleteEncryptedPin() async {
    final storage = FlutterSecureStorage();

    await storage.delete(key: 'epkey');
    await storage.delete(key: 'npkey');
  }

  static Future<bool> saveEncryptedPin(
      String userPin, UserController appStore) async {
    final storage = FlutterSecureStorage();

    /// preparing the algorithm
    final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256());

    final picKey = await algorithm.newSecretKey();
    final ivKey = algorithm.newNonce();

    final encryptedData = await algorithm.encrypt(utf8.encode(userPin),
        secretKey: picKey, nonce: ivKey);
    final hexData = hex.encode(encryptedData.cipherText);

    await appStore.saveSecretKey(hex.encode(await picKey.extractBytes()));
    await storage.write(key: 'epkey', value: hexData);
    await storage.write(key: 'npkey', value: hex.encode(ivKey));

    return true;
  }

  static Future<void> saveSaltKey() async {
    final storage = FlutterSecureStorage();
    final stringToBase64 = utf8.fuse(base64);
    final secretSalt = stringToBase64.encode(Uuid().v4()).substring(0, 16);
    await storage.write(key: 'ppkey', value: secretSalt);
    //print('Secret salt: $secretSalt');
  }

  static Future<void> saveSpKey(String accessKey, String spKey, String userPin,
      String userEmail, UserController appStore) async {
    final storage = FlutterSecureStorage();
    final ppkey = await storage.read(key: 'ppkey');
    final stringToBase64 = utf8.fuse(base64);

    final generateIv = '$accessKey${accessKey.substring(0, 4)}$accessKey';

    final picAccessKey = (utf8.encode('PeShVkYp3s6v9y9BVEpHxMcQfTjWnZq4'));
    final ivAccess = (utf8.encode(generateIv));

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

    Uint8List assetData = await picStore.entity.value.originBytes;
    Uint8List thumbData = await picStore.entity.value
        .thumbDataWithSize(150, 150, format: ThumbFormat.jpeg, quality: 90);

    String title = Platform.isAndroid
        ? picStore.entity.value.title
        : await picStore.entity.value.titleAsync;

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
    //print('Writing to ${savedPicFile.path}');
    //print('Writing to ${savedThumbFile.path}');

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

    //print('Secret Key: ${secretKey.toString()}');
    //print('Nonce: ${nonce.toString()}');
    //print('File exists: ${await file.exists()}');
    //print('App Support Dir: ${(await getApplicationDocumentsDirectory()).path}');

    Uint8List decryptedData;
    //print('Decrypting image: $filePath');
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
    //print('Decrypted');

    return decryptedData;
  }
}
