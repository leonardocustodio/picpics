/* import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/stores/pic_store.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:uuid/uuid.dart';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:picpics/utils/app_logger.dart';

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

    AppLogger.d('Encrypting $encryptValue - With ivString: $ivString');
    AppLogger.d('Encrypted value: $hexData');

    return hexData;
  }

  static Future<void> reSaveSpKey(
      String userPin, UserController appStore) async {
    final storage = FlutterSecureStorage();

    final ppkey = await storage.read(key: 'ppkey') ?? '';
    final stringToBase64 = utf8.fuse(base64);

    AppLogger.d('Decrypted spKey is: ${appStore.tempEncryptionKey}');

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

    AppLogger.d('New generated IV for encryption: $ivString');
    final ivKey = utf8.encode(ivString);

    final encryptedData = await algorithm.encrypt(
        utf8.encode(appStore.tempEncryptionKey),
        secretKey: picKey,
        nonce: ivKey);
    final hexData = hex.encode(encryptedData.cipherText);

    AppLogger.d('New key encrypted with new pin: $hexData');
    await storage.write(key: 'spkey', value: hexData);
    AppLogger.d('New key saved to storage!');
  }

  static Future<bool> checkRecoveryKey(String encryptedRecoveryKey,
      String recoveryCode, String randomIv, UserController appStore) async {
    final storage = FlutterSecureStorage();
    final hpkey = await storage.read(key: 'hpkey') ?? '';

    final generatedIv = '$randomIv$randomIv${randomIv.substring(0, 4)}';
    final recoveryIv =
        '$recoveryCode${recoveryCode.substring(0, 4)}$recoveryCode';

    /// preparing the algorithm
    final algorithm = cryptography.AesCtr.with256bits(
        macAlgorithm: cryptography.Hmac.sha256());

    final picKey = algorithm
        .newSecretKeyFromBytes(utf8.encode('PeShVkYp3s6v9y9BVEpHxMcQfTjWnZq4'));
    final ivRecovery = utf8.encode(recoveryIv);
    final ivGenerated = utf8.encode(generatedIv);

    var encryptedValue = hex.decode(encryptedRecoveryKey);
    AppLogger.d('Encrypted Recovery Key: $encryptedRecoveryKey - Recovery Code: $recoveryCode - Random IV: $randomIv - Generated IV: $generatedIv');

    try {
      final secretBox = cryptography.SecretBox.
      final decryptedFirstData = await algorithm.decrypt(encryptedValue,
          secretKey: picKey, nonce: ivRecovery);
      final decryptedFirstStep = utf8.decode(decryptedFirstData);
      AppLogger.d('First Step Decrypted: $decryptedFirstStep');

      final decryptedFinal = await aesCtr.decrypt(
          hex.decode(decryptedFirstStep),
          secretKey: picKey,
          nonce: ivGenerated);
      final decryptedData = utf8.decode(decryptedFinal);
      AppLogger.d('Final decrypted value: $decryptedData');
      AppLogger.d('Hp Key: $hpkey');

      final digest = hex.encode((await sha256.hash(decryptedFinal)).bytes);
      AppLogger.d('Final key hashed: $digest');
      AppLogger.d('Saved hash: $hpkey');

      AppLogger.d('Final key hash');
      if (hpkey == null) {
        await storage.write(key: 'hpkey', value: digest);
        appStore.setTempEncryptionKey(decryptedData);
        return true;
      }

      if (digest == hpkey) {
        appStore.setTempEncryptionKey(decryptedData);
        return true;
      }

      AppLogger.d('Not the real key');
      return false;
    } catch (error) {
      AppLogger.d('Not the real key');
      return false;
    }
  }

  static Future<bool> checkIsPinValid(
      String userPin, UserController appStore) async {
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

      AppLogger.d('Server key after decrypt: $decryptedString');

      AppLogger.d('Hasing it to check if it is the correct key');
      final digest = hex.encode((await sha256.hash(decryptedData)).bytes);
      AppLogger.d('Hashed key is: $digest');

      if (digest == hpkey) {
        AppLogger.d('The key is valid!');
        AppLogger.d('ppkey: $ppkey - nonce: ${utf8.encode(ppkey)}');
        AppLogger.d('Decrypted Key: $decryptedData');
        appStore.setEncryptionKey(SecretKey(decryptedData));
        return true;
      }

      AppLogger.d('The key is invalid');
      return false;
    } catch (error) {
      AppLogger.d('Failed to decrypt key invalid padblock!');
      return false;
    }
  }

  static Future<String> getEncryptedPin(UserController appStore) async {
    final storage = FlutterSecureStorage();

    String secretString = appStore.getSecretKey();
    String nounceString = await storage.read(key: 'npkey');
    String encryptedPin = await storage.read(key: 'epkey');

    final SecretKey picKey = SecretKey(hex.decode(secretString));
    final Nonce ivKey = Nonce(hex.decode(nounceString));

    try {
      final decryptedData = await aesCtr.decrypt(hex.decode(encryptedPin),
          secretKey: picKey, nonce: ivKey);
      AppLogger.d('Pin: ${utf8.decode(decryptedData)}');
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

    final SecretKey picKey = aesCtr.newSecretKeySync();
    final Nonce ivKey = aesCtr.newNonce();

    final encryptedData = await aesCtr.encrypt(utf8.encode(userPin),
        secretKey: picKey, nonce: ivKey);
    final hexData = hex.encode(encryptedData);

    appStore.saveSecretKey(hex.encode(picKey.extractSync()));
    await storage.write(key: 'epkey', value: hexData);
    await storage.write(key: 'npkey', value: hex.encode(ivKey.bytes));

    return true;
  }

  static Future<void> saveSaltKey() async {
    final storage = FlutterSecureStorage();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String secretSalt =
        stringToBase64.encode(Uuid().v4()).substring(0, 16);
    await storage.write(key: 'ppkey', value: secretSalt);
    AppLogger.d('Secret salt: $secretSalt');
  }

  static Future<void> saveSpKey(String accessKey, String spKey, String userPin,
      String userEmail, UserController appStore) async {
    final storage = FlutterSecureStorage();
    String ppkey = await storage.read(key: 'ppkey');
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String generateIv = '$accessKey${accessKey.substring(0, 4)}$accessKey';

    final SecretKey picAccessKey =
        SecretKey(utf8.encode('PeShVkYp3s6v9y9BVEpHxMcQfTjWnZq4'));
    final Nonce ivAccess = Nonce(utf8.encode(generateIv));

    AppLogger.d('SpKey: $spKey');
    AppLogger.d('Encrypted: $spKey');

    final decryptedKey = await aesCtr.decrypt(hex.decode(spKey),
        secretKey: picAccessKey, nonce: ivAccess);
    final hexData = hex.encode(decryptedKey);

    AppLogger.d('Decrypted spKey is: $hexData');
    appStore.setEncryptionKey(SecretKey(decryptedKey));

    AppLogger.d('Before digest....');
    final digest = hex.encode((await sha256.hash(decryptedKey)).bytes);
    AppLogger.d('Saving hashed spKey: $digest');
    await storage.write(key: 'hpkey', value: digest);

    final SecretKey picKey = SecretKey(utf8.encode('1HxMbQeThWmZq3t6'));
    final String ivString =
        stringToBase64.encode('${userPin}${userEmail}').substring(0, 16);
    AppLogger.d('New generated IV for encryption: $ivString');

    final Nonce ivKey = Nonce(utf8.encode(ivString));
    final encrypted =
        await aesCtr.encrypt(decryptedKey, secretKey: picKey, nonce: ivKey);
    final encryptedData = hex.encode(encrypted);

    AppLogger.d('New key encrypted with pin: $encryptedData');

    await storage.write(key: 'spkey', value: encryptedData);
    AppLogger.d('key saved to storage!');
  }

  static Future<void> encryptImage(
      PicStore picStore, SecretKey secretKey) async {
    AppLogger.d('Going to encrypt image with encryption key');

    Uint8List assetData = await picStore.entity.value.originBytes;
    Uint8List thumbData = await picStore.entity.value
        .thumbDataWithSize(150, 150, format: ThumbFormat.jpeg, quality: 90);

    String title = Platform.isAndroid
        ? picStore.entity.value.title
        : await picStore.entity.value.titleAsync;

    AppLogger.d('Asset Name: ${picStore.entity.id}');
    AppLogger.d('Origin file: $title');

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

    AppLogger.d('Encrypting....');
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

    AppLogger.d('Saving to file...');

    final File savedPicFile = File(finalPhotoPath);
    final File savedThumbFile = File(finalThumbPath);
    savedPicFile.writeAsBytes(encryptedPicData);
    savedThumbFile.writeAsBytes(encryptedThumbData);
    AppLogger.d('Writing to ${savedPicFile.path}');
    AppLogger.d('Writing to ${savedThumbFile.path}');

    AppLogger.d('Saved file: $title to ${savedPicFile.path}');
    // AppLogger.d('File sizes: ${savedPicFile.lengthSync()} - Thumb Size: ${savedThumbFile.lengthSync()}');

    await picStore.setPrivatePath(
        photosPath, thumbnailsPath, hex.encode(nonce.bytes));
  }

  static Future<Uint8List> decryptImage(
      String imagePath, SecretKey secretKey, Nonce nonce) async {
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String filePath = p.join(appDocumentsDir.path, imagePath);

    final File file = File(filePath);

    AppLogger.d('Secret Key: ${secretKey.toString()}');
    AppLogger.d('Nonce: ${nonce.toString()}');
    AppLogger.d('File exists: ${await file.exists()}');
    AppLogger.d('App Support Dir: ${(await getApplicationDocumentsDirectory()).path}');

    Uint8List decryptedData;
    AppLogger.d('Decrypting image: $filePath');
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
    AppLogger.d('Decrypted');

    return decryptedData;
  }
} */
