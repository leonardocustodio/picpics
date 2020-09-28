import 'dart:io';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:picPics/stores/pic_store.dart';

class Crypto {
  static encryptImage(PicStore picStore) async {
    print('Going to encrypt image!!!');
    var crypt = AesCrypt('my cool password');
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
    var crypt = AesCrypt('my cool password');
    print('Decrypting image...');
    Uint8List decryptedData = await crypt.decryptDataFromFileSync(filePath);
    print('Decrypted data');
    return decryptedData;
    // return File.fromRawPath(decryptedData);
  }
}
