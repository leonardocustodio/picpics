import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:picPics/model/pic.dart';
import 'package:picPics/model/secret.dart';
import 'package:picPics/model/tag.dart';
import 'package:picPics/model/user.dart';
import 'package:picPics/model/user_key.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

extension MoorTValue<T> on T {
  get moorValue {
    if (this == null) {
      return Value.absent();
    }
    return Value(this);
  }

  /* get moor {
    if (this == null) {
      return Value.absent();
    }
    return this;
  } */
}

/* class PhotosWithLabels extends Table {
  final Photo photo;
  final List<Label> labels;

  PhotosWithLabels(this.photo, this.labels);
} */

/// Old Info @Hive: Pic
class Photos extends Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime()();

  RealColumn get originalLatitude => real()();
  RealColumn get originalLongitude => real()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();

  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
  BoolColumn get deletedFromCameraRoll =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();

  TextColumn get tags => text().nullable().map(ListStringConvertor())();

  TextColumn get specificLocation => text().nullable()();
  TextColumn get generalLocation => text().nullable()();
  TextColumn get base64encoded => text().nullable()();
}

class Labels extends Table {
  TextColumn get key => text().withDefault(Constant(Uuid().v4()))();
  @override
  Set<Column> get primaryKey => {key};
  TextColumn get title => text().nullable()();
  TextColumn get photoId => text().nullable().map(ListStringConvertor())();
}

@DataClassName('LabelEntry')
class LabelEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get photo => text()();
  TextColumn get label => text()();
}

// Old Info @Hive: Secret
class Privates extends Table {
  TextColumn get id => text()();
  TextColumn get path => text()();
  TextColumn get nonce => text()();
  TextColumn get thumbPath => text().nullable()();
  DateTimeColumn get createDateTime => dateTime()();
  RealColumn get originalLatitude => real()();
  RealColumn get originalLongitude => real()();
}

/// Old Info @Hive: made from : User and UserKey-secretKey
class MoorUsers extends Table {
  IntColumn get customPrimaryKey => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {customPrimaryKey};

  TextColumn get id => text().withDefault(Constant(Uuid().v4()))();
  TextColumn get email => text().nullable()();
  TextColumn get password => text().nullable()();
  BoolColumn get notification => boolean().withDefault(const Constant(false))();
  BoolColumn get dailyChallenges =>
      boolean().withDefault(const Constant(false))();
  TextColumn get recentTags => text().nullable().map(ListStringConvertor())();
  TextColumn get appLanguage => text().nullable()();
  TextColumn get appVersion => text().nullable()();
  TextColumn get secretKey => text().nullable()();
  TextColumn get starredPhotos =>
      text().nullable().map(ListStringConvertor())();
  TextColumn get defaultWidgetImage => text().nullable()();

  IntColumn get goal => integer().withDefault(const Constant(20))();
  IntColumn get hourOfDay => integer().withDefault(const Constant(20))();
  IntColumn get minuteOfDay => integer().withDefault(const Constant(0))();
  IntColumn get picsTaggedToday => integer().withDefault(const Constant(0))();

  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  BoolColumn get tutorialCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get canTagToday => boolean().withDefault(const Constant(true))();
  BoolColumn get hasGalleryPermission =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get loggedIn => boolean().withDefault(const Constant(false))();
  BoolColumn get secretPhotos => boolean().withDefault(const Constant(false))();
  BoolColumn get isPinRegistered =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get keepAskingToDelete =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get shouldDeleteOnPrivate =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get tourCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isBiometricActivated =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get lastTaggedPicDate =>
      dateTime().withDefault(Constant(DateTime.now()))();
}

class ListStringConvertor extends TypeConverter<List<String>, String> {
  @override
  List<String> mapToDart(String fromDb) {
    if (fromDb == null) {
      return <String>[];
    }
    return json.decode(fromDb);
  }

  @override
  String mapToSql(List<String> value) {
    return json.encode(value ?? <String>[]);
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Photos, Privates, Labels, LabelEntries, MoorUsers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /**
   * 
   * Labels CRUD operations Start
   * 
   */
  Future createLabel(Label newLabel) => into(labels).insert(newLabel);

  Future<Label> getLabelByLabelKey(String labelKey) =>
      (select(labels)..where((l) => l.key.equals(labelKey))).getSingle();

  Future<List<Label>> getAllLabel() => select(labels).get();

  Future updateLabel(Label oldLabel) => update(labels).replace(oldLabel);

  Future deleteLabel(Label oldLabel) => delete(labels).delete(oldLabel);
  /**
   * 
   * Labels CRUD operations End
   * 
   */

  /**
   * 
   * Photos CRUD operations Start
   * 
   */
  Future createPhoto(Photo newPhoto) => into(photos).insert(newPhoto);

  Future<Photo> getPhotoByPhotoId(String photoId) =>
      (select(photos)..where((pri) => pri.id.equals(photoId))).getSingle();

  Future<List<Photo>> getAllPhoto() => select(photos).get();

  Future updatePhoto(Photo oldPhoto) => update(photos).replace(oldPhoto);

  Future deletePhotoByPhotoId(String photoId) =>
      (delete(photos)..where((picture) => picture.id.equals(photoId))).go();

  Future deletePhoto(Photo oldPhoto) => delete(photos).delete(oldPhoto);
  /**
   * 
   * Photos CRUD operations End
   * 
   */

  /**
   * 
   * Private CRUD operations Start
   * 
   */
  Future createPrivate(Private newPrivate) => into(privates).insert(newPrivate);

  Future<Private> getPrivateByPhotoId(String photoId) =>
      (select(privates)..where((pri) => pri.id.equals(photoId))).getSingle();

  Future<List<Private>> getAllPrivate() => select(privates).get();

  Future updatePrivate(Private oldPrivate) =>
      update(privates).replace(oldPrivate);

  Future deletePrivate(Private oldPrivate) =>
      delete(privates).delete(oldPrivate);
  /**
   * 
   * Private CRUD operations End
   * 
   */

  /**
   * 
   * MoorUser CRUD operations Start
   * 
   */
  Future createMoorUser(MoorUser newMoorUser) =>
      into(moorUsers).insert(newMoorUser);

  //Future<List<MoorUser>> getAllMoorUser() => select(moorUsers).get();

  Future<MoorUser> getSingleMoorUser({bool createIfNotExist = true}) async {
    var moorUserReturn = await (select(moorUsers)
          ..where((u) => u._customPrimaryKey.equals(0)))
        .getSingle();
    if (createIfNotExist && moorUserReturn == null) {
      insertAllMoorUsers(null);
      return await (select(moorUsers)
            ..where((u) => u._customPrimaryKey.equals(0)))
          .getSingle();
    } else {
      return moorUserReturn;
    }
  }

  Future updateMoorUser(MoorUser newMoorUser) =>
      (update(moorUsers)..where((u) => u.customPrimaryKey.equals(0)))
          .replace(newMoorUser);

  Future deleteMoorUser(MoorUser newMoorUser) =>
      (delete(moorUsers)..where((u) => u.customPrimaryKey.equals(0)))
          .delete(newMoorUser);
  /**
   * 
   * MoorUser CRUD operations End
   * 
   */

  /** 
   * 
   * 
   * 
   * 
   * Migration queries Start
   * 
   * 
   * 
   * 
   */

  Future<void> insertAllPrivates(List<Secret> secretPhotos) async {
    List<PrivatesCompanion> privatesCompanions = [];

    for (Secret secret in secretPhotos) {
      privatesCompanions.add(
        PrivatesCompanion.insert(
          id: secret.photoId,
          path: secret.photoPath,
          thumbPath: secret.thumbPath.moorValue,
          createDateTime: secret.createDateTime,
          originalLatitude: secret.originalLatitude ?? 0.0,
          originalLongitude: secret.originalLongitude ?? 0.0,
          nonce: secret.nonce,
        ),
      );
    }

    await batch((batch) {
      batch.insertAll(privates, privatesCompanions);
    });
  }

  Future<void> insertAllMoorUsers(User user, {UserKey userKey}) async {
    var moorUserCompanionVariable;
    if (user == null) {
      moorUserCompanionVariable =
          MoorUsersCompanion.insert(customPrimaryKey: const Value(0));
    } else {
      moorUserCompanionVariable = MoorUsersCompanion.insert(
        customPrimaryKey: const Value(0),
        id: user.id.moorValue,
        recentTags: user.recentTags.moorValue,
        starredPhotos: user.starredPhotos.moorValue,
        email: user.email.moorValue,
        password: user.password.moorValue,
        notification: user.notifications.moorValue,
        dailyChallenges: user.dailyChallenges.moorValue,
        goal: user.goal.moorValue,
        hourOfDay: user.hourOfDay.moorValue,
        minuteOfDay: user.minutesOfDay.moorValue,
        isPremium: user.isPremium.moorValue,
        tutorialCompleted: user.tutorialCompleted.moorValue,
        picsTaggedToday: user.picsTaggedToday.moorValue,
        lastTaggedPicDate: user.lastTaggedPicDate.moorValue,
        canTagToday: user.canTagToday.moorValue,
        appLanguage: user.appLanguage.moorValue,
        appVersion: user.appVersion.moorValue,
        hasGalleryPermission: user.hasGalleryPermission.moorValue,
        loggedIn: user.loggedIn.moorValue,
        secretPhotos: user.secretPhotos.moorValue,
        isPinRegistered: user.isPinRegistered.moorValue,
        keepAskingToDelete: user.keepAskingToDelete.moorValue,
        shouldDeleteOnPrivate: user.shouldDeleteOnPrivate.moorValue,
        tourCompleted: user.tourCompleted.moorValue,
        isBiometricActivated: user.isBiometricActivated.moorValue,
        secretKey: userKey?.secretKey?.moorValue,
      );
    }
    return into(moorUsers).insert(
      moorUserCompanionVariable,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> insertAllLabelsEntries(
      Map<String, List<String>> photosTags) async {
    List<LabelEntriesCompanion> labelsEntriesCompanions = [];

    photosTags.forEach((key, value) {
      for (String tag in value) {
        labelsEntriesCompanions.add(
          LabelEntriesCompanion.insert(
            photo: key,
            label: tag,
          ),
        );
      }
    });

    await batch((batch) {
      batch.insertAll(labelEntries, labelsEntriesCompanions);
    });
  }

  Future<void> insertAllLabelsList(List<Tag> tags) async {
    List<LabelsCompanion> labelsCompanions = [];

    for (Tag tag in tags) {
      labelsCompanions.add(
        LabelsCompanion.insert(
          key: 'tag.key'.moorValue, // TODO: make it tag.key
          title: tag.name.moorValue,
          photoId: tag.photoId.moorValue,
        ),
      );
    }

    await batch((batch) {
      batch.insertAll(labels, labelsCompanions);
    });
  }

  Future<void> insertAllPhotos(List<Pic> pics) async {
    List<PhotosCompanion> photosCompanions = [];
    Map<String, List<String>> photosTags = {};

    for (Pic pic in pics) {
      photosTags[pic.photoId] = pic.tags;
      photosCompanions.add(
        PhotosCompanion.insert(
          id: pic.photoId,
          createdAt: pic.createdAt,
          originalLatitude: pic.originalLatitude ?? 0.0,
          originalLongitude: pic.originalLongitude ?? 0.0,
          latitude: pic.latitude ?? 0.0,
          longitude: pic.longitude ?? 0.0,
          specificLocation: pic.specificLocation.moorValue,
          generalLocation: pic.generalLocation.moorValue,
          isPrivate: pic.isPrivate.moorValue,
          deletedFromCameraRoll: pic.deletedFromCameraRoll.moorValue,
          isStarred: pic.isStarred.moorValue,
          base64encoded: pic.base64encoded.moorValue,
        ),
      );
    }

    await batch((batch) {
      batch.insertAll(photos, photosCompanions);
    });

    await insertAllLabelsEntries(photosTags);
  }

  /** 
   * 
   * 
   * 
   * 
   * Migration queries Start
   * 
   * 
   * 
   * 
   */
}
