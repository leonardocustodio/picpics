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
import 'package:picPics/stores/database_controller.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

extension MoorTValue<T> on T {
  Value<T> get moorValue {
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

class PicBlurHashs extends Table {
  TextColumn get photoId => text()();
  @override
  Set<Column> get primaryKey => {photoId};

  TextColumn get blurHash => text()();
}

/// Old Info @Hive: Pic
class Photos extends Table {
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id};

  DateTimeColumn get createdAt => dateTime()();

  RealColumn get originalLatitude => real()();
  RealColumn get originalLongitude => real()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

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
  IntColumn get counter => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastUsedAt =>
      dateTime().withDefault(Constant(DateTime.now()))();
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
  @override
  Set<Column> get primaryKey => {id};
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
  List<String> mapToDart(String? fromDb) {
    if (fromDb == null) {
      return <String>[];
    }
    var r = json.decode(fromDb);
    if (r is List) {
      return r.toList().map((e) => e.toString()).toList();
    }
    return r;
  }

  @override
  String mapToSql(List<String>? value) {
    return json.encode(value ?? <String>[]);
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationSupportDirectory();
    //final path = p.join(dbFolder.path, 'db.sqlite');
    ////print('db:path:-$path');
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, setup: (rawDb) {
      rawDb.execute("PRAGMA key = 'Leonardo';");
    });
  });
}

@UseMoor(
    tables: [Photos, PicBlurHashs, Privates, Labels, LabelEntries, MoorUsers])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase _singleton = AppDatabase._internal();

  factory AppDatabase() {
    return _singleton;
  }
  AppDatabase._internal() : super(_openConnection());

  int get schemaVersion => 1;

  ///
  ///
  ///Blur Hash operations Start
  ///
  ///
  Future createBlurHash(PicBlurHash newBlurHash) =>
      into(picBlurHashs).insert(newBlurHash);

  Future<List<PicBlurHash>> getAllPicBlurHash() => select(picBlurHashs).get();

  Future<PicBlurHash> getSinglePicBlurHash(String photoId) =>
      (select(picBlurHashs)
            ..where((l) =>
                l.photoId.equals(photoId) /* ?? const Constant(false) */))
          .getSingle();

  ///
  ///
  ///Labels CRUD operations Start
  ///
  ///
  Future createLabel(Label newLabel) => into(labels).insert(newLabel);

  Future<Label?> getLabelByLabelKey(String labelKey) => (select(labels)
        ..where((l) => l.key.equals(labelKey) /* ?? const Constant(false) */))
      .getSingleOrNull();

  Future<void> incrementLabelByKey(String labelKey) async {
    var label = await getLabelByLabelKey(labelKey);
    if (label != null) {
      var updatedLabel = label.copyWith(
          counter: label.counter + 1, lastUsedAt: DateTime.now());
      await updateLabel(updatedLabel);
    }
  }

  Future<void> decrementLabelByKey(String labelKey) async {
    var label = await getLabelByLabelKey(labelKey);
    if (label != null) {
      var count = (label.counter - 1);
      if (count < 1) count = 1;
      var updatedLabel =
          label.copyWith(counter: count, lastUsedAt: DateTime.now());
      await updateLabel(updatedLabel);
    }
  }

  Future<List<Label>> getAllLabel() => select(labels).get();

  Future deleteLabelByLabelId(String labelKey) => (delete(labels)
        ..where((l) => l.key.equals(labelKey) /* ?? const Constant(false) */))
      .go();

  Future updateLabel(Label oldLabel) => update(labels).replace(oldLabel);

  Future deleteLabel(Label oldLabel) => delete(labels).delete(oldLabel);

  Future<List<Label>> getAllLabelsInAscendingOrder() => (select(labels)
        ..orderBy([
          (u) => OrderingTerm(expression: u.title, mode: OrderingMode.asc),
        ]))
      .get();

  Future<List<Label>> fetchMostUsedLabels() => (select(labels)
        ..orderBy([
          (u) => OrderingTerm(expression: u.counter, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.title, mode: OrderingMode.asc),
        ]))
      .get();

  Future<List<Label>> fetchLastWeekUsedLabels() {
    var sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return (select(labels)
          ..where((tbl) => tbl.lastUsedAt.isBiggerOrEqualValue(sevenDaysAgo))
          ..orderBy([
            (u) => OrderingTerm(expression: u.counter, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<Label>> fetchLastMonthUsedLabels() {
    var thirty1Days = DateTime.now().subtract(const Duration(days: 31));
    return (select(labels)
          ..where((tbl) => tbl.lastUsedAt.isBiggerOrEqualValue(thirty1Days))
          ..orderBy([
            (u) => OrderingTerm(expression: u.counter, mode: OrderingMode.desc),
          ]))
        .get();
  }

  ///
  ///
  ///Labels CRUD operations End
  ///
  ///

  ///
  ///
  ///Photos CRUD operations Start
  ///
  ///
  Future createPhoto(Photo newPhoto) => into(photos).insert(newPhoto);

  Future<Photo> getPhotoByPhotoId(String photoId) => (select(photos)
        ..where((pri) => pri.id.equals(photoId) /* ?? const Constant(false) */))
      .getSingle();

  Future<List<Photo>> getAllTaggedPhotoIdList() {
    var convertor = ListStringConvertor();
    return (select(photos)
          ..where((tbl) {
            return Constant(convertor
                    .mapToDart(tbl.tags.moorValue.toString())
                    .isNotEmpty /* ??
                false */
                );
          }))
        .get();
  }

  Future<List<Photo>> getPrivatePhotoList() =>
      (select(photos)..where((tbl) => tbl.isPrivate.equals(true))).get();

  Future<List<Photo>> getAllPhoto() => select(photos).get();

  Future updatePhoto(Photo oldPhoto) => update(photos).replace(oldPhoto);

  Future deletePhotoByPhotoId(String photoId) => (delete(photos)
        ..where((picture) =>
            picture.id.equals(photoId) /* ?? const Constant(false) */))
      .go();

  Future deletePhoto(Photo oldPhoto) => delete(photos).delete(oldPhoto);

  ///
  ///
  ///Photos CRUD operations End
  ///
  ///

  ///
  ///
  ///Private CRUD operations Start
  ///
  ///
  Future createPrivate(Private newPrivate) => into(privates).insert(newPrivate);

  Future<Private> getPrivateByPhotoId(String photoId) => (select(privates)
        ..where((pri) => pri.id.equals(photoId) /* ?? const Constant(false) */))
      .getSingle();

  Future<List<Private>> getAllPrivate() => select(privates).get();

  Future updatePrivate(Private oldPrivate) =>
      update(privates).replace(oldPrivate);

  Future deletePrivate(Private oldPrivate) =>
      delete(privates).delete(oldPrivate);

  ///
  ///
  ///Private CRUD operations End
  ///
  ///

  ///
  ///
  ///MoorUser CRUD operations Start
  ///
  ///
  Future createMoorUser(MoorUser newMoorUser) =>
      into(moorUsers).insert(newMoorUser, mode: InsertMode.insertOrReplace);

  //Future<List<MoorUser>> getAllMoorUser() => select(moorUsers).get();

  Future<MoorUser?> getSingleMoorUser({bool createIfNotExist = true}) async {
    var moorUserReturn = await select(moorUsers).getSingleOrNull();
    if (createIfNotExist && moorUserReturn == null) {
      await createMoorUser(getDefaultMoorUser());
      return await select(moorUsers).getSingle();
    } else {
      return moorUserReturn;
    }
  }

  Future updateMoorUser(MoorUser newMoorUser) =>
      update(moorUsers).replace(newMoorUser.copyWith(customPrimaryKey: 0));

  Future deleteMoorUser(MoorUser newMoorUser) => (delete(moorUsers)
        ..where(
            (u) => u.customPrimaryKey.equals(0) /* ?? const Constant(false) */))
      .delete(newMoorUser);

  ///
  ///
  ///MoorUser CRUD operations End
  ///
  ///

  ///
  ///
  ///Batch insert the photoBlurHash
  ///
  ///

  Future<void> insertAllPicBlurHash(List<PicBlurHash> blurHashes) async {
    List<PicBlurHashsCompanion> blurHashedCompanion = [];

    for (PicBlurHash blurHash in blurHashes) {
      blurHashedCompanion.add(PicBlurHashsCompanion.insert(
          photoId: blurHash.photoId, blurHash: blurHash.blurHash));
    }

    await batch((batch) {
      batch.insertAll(
        picBlurHashs,
        blurHashedCompanion,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  ///
  ///
  ///
  ///
  ///
  ///Migration queries Start
  ///
  ///
  ///
  ///
  ///

  Future<void> insertAllPrivates(List<Secret> secretPhotos) async {
    List<PrivatesCompanion> privatesCompanions = [];

    for (Secret secret in secretPhotos) {
      privatesCompanions.add(
        PrivatesCompanion.insert(
          id: secret.photoId,
          path: secret.photoPath,
          thumbPath: secret.thumbPath.moorValue,
          createDateTime: secret.createDateTime,
          originalLatitude: secret.originalLatitude /* ?? 0.0 */,
          originalLongitude: secret.originalLongitude /* ?? 0.0 */,
          nonce: secret.nonce,
        ),
      );
    }

    await batch((batch) {
      batch.insertAll(privates, privatesCompanions);
    });
  }

  Future<void> insertAllMoorUsers(User user, {UserKey? userKey}) async {
    var moorUserCompanionVariable;

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
      secretKey: userKey?.secretKey.moorValue,
    );

    await into(moorUsers).insert(
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
          key: tag.key.moorValue,
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
    var photosTags = <String, List<String>>{};

    for (Pic pic in pics) {
      photosTags[pic.photoId] = pic.tags;
      photosCompanions.add(
        PhotosCompanion.insert(
          id: pic.photoId,
          createdAt: pic.createdAt,
          originalLatitude: pic.originalLatitude /* ?? 0.0 */,
          originalLongitude: pic.originalLongitude /* ?? 0.0 */,
          latitude: pic.latitude.moorValue,
          longitude: pic.longitude.moorValue,
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

  ///
  ///
  ///
  ///
  ///
  ///Migration queries Start
  ///
  ///
  ///
  ///
  ///
}
