import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Crypto {
  static encryptImage(AssetEntity entity) async {
    print('Going to encrypt image!!!');
    var crypt = AesCrypt('my cool password');
    crypt.setOverwriteMode(AesCryptOwMode.rename);

    File assetFile = await entity.originFile;
    File assetOtherFile = await entity.file;

    print('Asset Name: ${entity.id}');
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

    AssetEntity entity = AssetEntity();

    final AssetEntity imageEntity = await PhotoManager.editor.saveImageWithPath(path);
  }
}
