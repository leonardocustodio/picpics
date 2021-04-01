import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/secret.dart';
import 'package:picPics/model/tag.dart';

class MigrationStore extends GetxController {
  final isMigrating = true.obs;

  //@action
  void setIsMigrating(bool value) => isMigrating.value = value;

  //@action
  Future<void> startMigration() async {
    var userBox = Hive.box('user');
    var picsBox = Hive.box('pics');
    var tagsBox = Hive.box('tags');
    var secretBox = Hive.box('secrets');
    var keyBox = Hive.box('userkey');

    List<Tag> tags = [];
    List<Pic> pics = [];
    List<Secret> secrets = [];

    AppDatabase database = AppDatabase();

    for (Tag tag in tagsBox.values) {
      tags.add(tag);
    }
    await database.insertAllLabelsList(tags);

    for (Pic pic in picsBox.values) {
      pics.add(pic);
    }

    await database.insertAllPhotos(pics);
    await database.insertAllMoorUsers(
      userBox.getAt(0),
      userKey: keyBox.length > 0 ? keyBox.getAt(0) : null,
    );

    for (Secret secret in secretBox.values) {
      secrets.add(secret);
    }
    await database.insertAllPrivates(secrets);

    setIsMigrating(false);
  }
}
