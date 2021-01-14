import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:picPics/model/pic.dart';
import 'package:picPics/model/tag.dart';

part 'app_database.g.dart';

class PhotosWithLabels extends Table {
  final Photo photo;
  final List<Label> labels;

  PhotosWithLabels(this.photo, this.labels);
}

class Photos extends Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime()();

  RealColumn get originalLatitude => real().nullable()();
  RealColumn get originalLongitude => real().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  TextColumn get specificLocation => text().nullable()();
  TextColumn get generalLocation => text().nullable()();

  BoolColumn get isPrivate => boolean().nullable()();
  BoolColumn get deletedFromCameraRoll => boolean().nullable()();
  BoolColumn get isStarred => boolean().nullable()();

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

class Privates extends Table {
  TextColumn get id => text()();
  TextColumn get path => text().nullable()();
  TextColumn get thumbPath => text().nullable()();

  DateTimeColumn get createDateTime => dateTime()();

  RealColumn get originalLatitude => real().nullable()();
  RealColumn get originalLongitude => real().nullable()();

  TextColumn get nonce => text()();
}

class Configs extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().nullable()();
  TextColumn get password => text().nullable()();

  BoolColumn get notification => boolean().nullable()();
  BoolColumn get dailyChallenge => boolean().nullable()();

  IntColumn get goal => integer().nullable()();
  IntColumn get hourOfDay => integer().nullable()();
  IntColumn get minuteOfDay => integer().nullable()();

  BoolColumn get isPremium => boolean()();

// @HiveField(9)
// final List<String> recentTags;

  BoolColumn get tutorialCompleted => boolean()();
  IntColumn get picsTaggedToday => integer()();

  DateTimeColumn get lastTaggedPicDate => dateTime().nullable()();
  BoolColumn get canTagToday => boolean()();

  TextColumn get appLanguage => text()();
  TextColumn get appVersion => text()();

  BoolColumn get hasGalleryPermission => boolean().nullable()();
  BoolColumn get loggedIn => boolean().nullable()();
  BoolColumn get secretPhotos => boolean()();
  BoolColumn get isPinRegistered => boolean()();
  BoolColumn get keepAskingToDelete => boolean()();
  BoolColumn get shouldDeleteOnPrivate => boolean()();
  BoolColumn get tourCompleted => boolean().nullable()();
  BoolColumn get isBiometricActivated => boolean()();

// @HiveField(25)
// List<String> starredPhotos;

  TextColumn get defaultWidgetImage => text().nullable()();
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

  Future<void> insertAllLabelsEntries(Map<String, List<String>> photosTags) async {
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
          originalLatitude: pic.originalLatitude,
          originalLongitude: pic.originalLongitude,
          latitude: pic.latitude,
          longitude: pic.longitude,
          specificLocation: pic.specificLocation,
          generalLocation: pic.generalLocation,
          isPrivate: pic.isPrivate,
          deletedFromCameraRoll: pic.deletedFromCameraRoll,
          isStarred: pic.isStarred,
          base64encoded: pic.base64encoded,
        ),
      );
    }

    await batch((batch) {
      batch.insertAll(photos, photosCompanions);
    });

    await insertAllLabelsEntries(photosTags);
  }
}
