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

part 'app_database.g.dart';

class PhotosWithLabels extends Table {
  final Photo photo;
  final List<Label> labels;

  PhotosWithLabels(this.photo, this.labels);
}

/// Old Info @Hive: Pic
class Photos extends Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime()();

  RealColumn get originalLatitude => real()();
  RealColumn get originalLongitude => real()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();

  BoolColumn get isPrivate => boolean()();
  BoolColumn get deletedFromCameraRoll => boolean()();
  BoolColumn get isStarred => boolean()();

  TextColumn get specificLocation => text().nullable()();
  TextColumn get generalLocation => text().nullable()();
  TextColumn get base64encoded => text().nullable()();
}

class Labels extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
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
  TextColumn get thumbPath => text().nullable()();
  DateTimeColumn get createDateTime => dateTime()();
  RealColumn get originalLatitude => real()();
  RealColumn get originalLongitude => real()();
  TextColumn get nonce => text()();
}

/// Old Info @Hive: made from : User and UserKey
class Configs extends Table {
  IntColumn get customPrimaryKey => integer()();
  @override
  Set<Column> get primaryKey => {customPrimaryKey};

  TextColumn get id => text().nullable()();

  TextColumn get email => text().nullable()();
  TextColumn get password => text().nullable()();

  BoolColumn get notification => boolean()();
  BoolColumn get dailyChallenge => boolean()();

  IntColumn get goal => integer().nullable()();
  IntColumn get hourOfDay => integer().nullable()();
  IntColumn get minuteOfDay => integer().nullable()();

  BoolColumn get isPremium => boolean()();

  // @HiveField(9)
  // List<String> recentTags
  TextColumn get recentTags => text().map(ListStringConvertor())();

  BoolColumn get tutorialCompleted => boolean()();
  IntColumn get picsTaggedToday => integer().nullable()();

  DateTimeColumn get lastTaggedPicDate => dateTime().nullable()();
  BoolColumn get canTagToday => boolean()();

  TextColumn get appLanguage => text().nullable()();
  TextColumn get appVersion => text().nullable()();

  BoolColumn get hasGalleryPermission => boolean()();
  BoolColumn get loggedIn => boolean()();
  BoolColumn get secretPhotos => boolean()();
  BoolColumn get isPinRegistered => boolean()();
  BoolColumn get keepAskingToDelete => boolean()();
  BoolColumn get shouldDeleteOnPrivate => boolean()();
  BoolColumn get tourCompleted => boolean()();
  BoolColumn get isBiometricActivated => boolean()();

  /// merged from userKey integration
  TextColumn get secretKey => text().nullable()();
  // @HiveField(25)
  // List<String> starredPhotos
  TextColumn get starredPhotos => text().map(ListStringConvertor())();

  TextColumn get defaultWidgetImage => text().nullable()();
}

class ListStringConvertor extends TypeConverter<List<String>, String> {
  @override
  List<String> mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    final hourly = json.decode(fromDb) as List<String>;
    return hourly;
  }

  @override
  String mapToSql(List<String> value) {
    if (value == null) {
      return null;
    }
    return json.encode(value);
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

@UseMoor(tables: [Photos, Privates, Labels, LabelEntries, Configs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> insertAllPrivates(List<Secret> secretPhotos) async {
    List<PrivatesCompanion> privatesCompanions = [];

    for (Secret secret in secretPhotos) {
      privatesCompanions.add(
        PrivatesCompanion.insert(
          id: secret.photoId,
          path: secret.photoPath,
          thumbPath: secret.thumbPath ?? Value.absent(),
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

  Future updateConfig(Config newConfig) async {
    return (update(configs)..where((tbl) => tbl.customPrimaryKey.equals(0)))
        .replace(newConfig);
  }

  Future<List<Config>> getSingleConfig() =>
      (select(configs)..where((tbl) => tbl._customPrimaryKey.equals(0))).get();

  Future<void> insertAllConfigs(User user, {UserKey userKey}) async {
    print('User goal: ${user.goal}');

    return into(configs).insert(
      ConfigsCompanion.insert(
        customPrimaryKey: Value(0), /// TODO: This will prevent the user from being added to multiple rows
        id: user.id,
        recentTags: user.recentTags,
        starredPhotos: user.starredPhotos,
        email: user.email ?? Value.absent(),
        password: user.password ?? Value.absent(),
        notification: user.notifications ?? false,
        dailyChallenge: user.dailyChallenges ?? false,
        goal: Value(user.goal),
        hourOfDay: Value(user.hourOfDay),
        minuteOfDay: Value(user.minutesOfDay),
        isPremium: user.isPremium ?? false,
        tutorialCompleted: user.tutorialCompleted ?? false,
        picsTaggedToday: Value(user.picsTaggedToday),
        lastTaggedPicDate: Value(user.lastTaggedPicDate),
        canTagToday: user.canTagToday ?? true,
        appLanguage: Value(user.appLanguage),
        appVersion: Value(user.appVersion),
        hasGalleryPermission: user.hasGalleryPermission,
        loggedIn: user.loggedIn ?? false,
        secretPhotos: user.secretPhotos ?? false,
        isPinRegistered: user.isPinRegistered ?? false,
        keepAskingToDelete: user.keepAskingToDelete ?? true,
        shouldDeleteOnPrivate: user.shouldDeleteOnPrivate ?? false,
        tourCompleted: user.tourCompleted ?? false,
        isBiometricActivated: user.isBiometricActivated ?? false,
        secretKey: userKey != null ? Value(userKey.secretKey) : Value.absent(),
        defaultWidgetImage: Value.absent(), // Value(user.defaultWidgetImage),
      ),
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
          id: tag.key,
          title: tag.name,
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
          specificLocation: pic.specificLocation ?? Value.absent(),
          generalLocation: pic.generalLocation ?? Value.absent(),
          isPrivate: pic.isPrivate ?? false,
          deletedFromCameraRoll: pic.deletedFromCameraRoll ?? false,
          isStarred: pic.isStarred ?? false,
          base64encoded: pic.base64encoded ?? Value.absent(),
        ),
      );
    }

    await batch((batch) {
      batch.insertAll(photos, photosCompanions);
    });

    await insertAllLabelsEntries(photosTags);
  }
}
