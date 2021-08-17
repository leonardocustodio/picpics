// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Photo extends DataClass implements Insertable<Photo> {
  final String id;
  final DateTime createdAt;
  final double? originalLatitude;
  final double? originalLongitude;
  final double? latitude;
  final double? longitude;
  final bool isPrivate;
  final bool deletedFromCameraRoll;
  final bool isStarred;
  final Map<String, String> tags;
  final String? specificLocation;
  final String? generalLocation;
  final String? base64encoded;
  Photo(
      {required this.id,
      required this.createdAt,
      this.originalLatitude,
      this.originalLongitude,
      this.latitude,
      this.longitude,
      required this.isPrivate,
      required this.deletedFromCameraRoll,
      required this.isStarred,
      required this.tags,
      this.specificLocation,
      this.generalLocation,
      this.base64encoded});
  factory Photo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Photo(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      originalLatitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}original_latitude']),
      originalLongitude: const RealType().mapFromDatabaseResponse(
          data['${effectivePrefix}original_longitude']),
      latitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      longitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
      isPrivate: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_private'])!,
      deletedFromCameraRoll: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}deleted_from_camera_roll'])!,
      isStarred: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_starred'])!,
      tags: $PhotosTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tags']))!,
      specificLocation: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}specific_location']),
      generalLocation: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}general_location']),
      base64encoded: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}base64encoded']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || originalLatitude != null) {
      map['original_latitude'] = Variable<double?>(originalLatitude);
    }
    if (!nullToAbsent || originalLongitude != null) {
      map['original_longitude'] = Variable<double?>(originalLongitude);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double?>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double?>(longitude);
    }
    map['is_private'] = Variable<bool>(isPrivate);
    map['deleted_from_camera_roll'] = Variable<bool>(deletedFromCameraRoll);
    map['is_starred'] = Variable<bool>(isStarred);
    {
      final converter = $PhotosTable.$converter0;
      map['tags'] = Variable<String>(converter.mapToSql(tags)!);
    }
    if (!nullToAbsent || specificLocation != null) {
      map['specific_location'] = Variable<String?>(specificLocation);
    }
    if (!nullToAbsent || generalLocation != null) {
      map['general_location'] = Variable<String?>(generalLocation);
    }
    if (!nullToAbsent || base64encoded != null) {
      map['base64encoded'] = Variable<String?>(base64encoded);
    }
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      originalLatitude: originalLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLatitude),
      originalLongitude: originalLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLongitude),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      isPrivate: Value(isPrivate),
      deletedFromCameraRoll: Value(deletedFromCameraRoll),
      isStarred: Value(isStarred),
      tags: Value(tags),
      specificLocation: specificLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(specificLocation),
      generalLocation: generalLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(generalLocation),
      base64encoded: base64encoded == null && nullToAbsent
          ? const Value.absent()
          : Value(base64encoded),
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      originalLatitude: serializer.fromJson<double?>(json['originalLatitude']),
      originalLongitude:
          serializer.fromJson<double?>(json['originalLongitude']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      deletedFromCameraRoll:
          serializer.fromJson<bool>(json['deletedFromCameraRoll']),
      isStarred: serializer.fromJson<bool>(json['isStarred']),
      tags: serializer.fromJson<Map<String, String>>(json['tags']),
      specificLocation: serializer.fromJson<String?>(json['specificLocation']),
      generalLocation: serializer.fromJson<String?>(json['generalLocation']),
      base64encoded: serializer.fromJson<String?>(json['base64encoded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'originalLatitude': serializer.toJson<double?>(originalLatitude),
      'originalLongitude': serializer.toJson<double?>(originalLongitude),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'deletedFromCameraRoll': serializer.toJson<bool>(deletedFromCameraRoll),
      'isStarred': serializer.toJson<bool>(isStarred),
      'tags': serializer.toJson<Map<String, String>>(tags),
      'specificLocation': serializer.toJson<String?>(specificLocation),
      'generalLocation': serializer.toJson<String?>(generalLocation),
      'base64encoded': serializer.toJson<String?>(base64encoded),
    };
  }

  Photo copyWith(
          {String? id,
          DateTime? createdAt,
          double? originalLatitude,
          double? originalLongitude,
          double? latitude,
          double? longitude,
          bool? isPrivate,
          bool? deletedFromCameraRoll,
          bool? isStarred,
          Map<String, String>? tags,
          String? specificLocation,
          String? generalLocation,
          String? base64encoded}) =>
      Photo(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        originalLatitude: originalLatitude ?? this.originalLatitude,
        originalLongitude: originalLongitude ?? this.originalLongitude,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        isPrivate: isPrivate ?? this.isPrivate,
        deletedFromCameraRoll:
            deletedFromCameraRoll ?? this.deletedFromCameraRoll,
        isStarred: isStarred ?? this.isStarred,
        tags: tags ?? this.tags,
        specificLocation: specificLocation ?? this.specificLocation,
        generalLocation: generalLocation ?? this.generalLocation,
        base64encoded: base64encoded ?? this.base64encoded,
      );
  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('originalLatitude: $originalLatitude, ')
          ..write('originalLongitude: $originalLongitude, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('deletedFromCameraRoll: $deletedFromCameraRoll, ')
          ..write('isStarred: $isStarred, ')
          ..write('tags: $tags, ')
          ..write('specificLocation: $specificLocation, ')
          ..write('generalLocation: $generalLocation, ')
          ..write('base64encoded: $base64encoded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          createdAt.hashCode,
          $mrjc(
              originalLatitude.hashCode,
              $mrjc(
                  originalLongitude.hashCode,
                  $mrjc(
                      latitude.hashCode,
                      $mrjc(
                          longitude.hashCode,
                          $mrjc(
                              isPrivate.hashCode,
                              $mrjc(
                                  deletedFromCameraRoll.hashCode,
                                  $mrjc(
                                      isStarred.hashCode,
                                      $mrjc(
                                          tags.hashCode,
                                          $mrjc(
                                              specificLocation.hashCode,
                                              $mrjc(
                                                  generalLocation.hashCode,
                                                  base64encoded
                                                      .hashCode)))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.originalLatitude == this.originalLatitude &&
          other.originalLongitude == this.originalLongitude &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isPrivate == this.isPrivate &&
          other.deletedFromCameraRoll == this.deletedFromCameraRoll &&
          other.isStarred == this.isStarred &&
          other.tags == this.tags &&
          other.specificLocation == this.specificLocation &&
          other.generalLocation == this.generalLocation &&
          other.base64encoded == this.base64encoded);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<double?> originalLatitude;
  final Value<double?> originalLongitude;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> isPrivate;
  final Value<bool> deletedFromCameraRoll;
  final Value<bool> isStarred;
  final Value<Map<String, String>> tags;
  final Value<String?> specificLocation;
  final Value<String?> generalLocation;
  final Value<String?> base64encoded;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.originalLatitude = const Value.absent(),
    this.originalLongitude = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.deletedFromCameraRoll = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.tags = const Value.absent(),
    this.specificLocation = const Value.absent(),
    this.generalLocation = const Value.absent(),
    this.base64encoded = const Value.absent(),
  });
  PhotosCompanion.insert({
    required String id,
    required DateTime createdAt,
    this.originalLatitude = const Value.absent(),
    this.originalLongitude = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.deletedFromCameraRoll = const Value.absent(),
    this.isStarred = const Value.absent(),
    required Map<String, String> tags,
    this.specificLocation = const Value.absent(),
    this.generalLocation = const Value.absent(),
    this.base64encoded = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        tags = Value(tags);
  static Insertable<Photo> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<double?>? originalLatitude,
    Expression<double?>? originalLongitude,
    Expression<double?>? latitude,
    Expression<double?>? longitude,
    Expression<bool>? isPrivate,
    Expression<bool>? deletedFromCameraRoll,
    Expression<bool>? isStarred,
    Expression<Map<String, String>>? tags,
    Expression<String?>? specificLocation,
    Expression<String?>? generalLocation,
    Expression<String?>? base64encoded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (originalLatitude != null) 'original_latitude': originalLatitude,
      if (originalLongitude != null) 'original_longitude': originalLongitude,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isPrivate != null) 'is_private': isPrivate,
      if (deletedFromCameraRoll != null)
        'deleted_from_camera_roll': deletedFromCameraRoll,
      if (isStarred != null) 'is_starred': isStarred,
      if (tags != null) 'tags': tags,
      if (specificLocation != null) 'specific_location': specificLocation,
      if (generalLocation != null) 'general_location': generalLocation,
      if (base64encoded != null) 'base64encoded': base64encoded,
    });
  }

  PhotosCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<double?>? originalLatitude,
      Value<double?>? originalLongitude,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<bool>? isPrivate,
      Value<bool>? deletedFromCameraRoll,
      Value<bool>? isStarred,
      Value<Map<String, String>>? tags,
      Value<String?>? specificLocation,
      Value<String?>? generalLocation,
      Value<String?>? base64encoded}) {
    return PhotosCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      originalLatitude: originalLatitude ?? this.originalLatitude,
      originalLongitude: originalLongitude ?? this.originalLongitude,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isPrivate: isPrivate ?? this.isPrivate,
      deletedFromCameraRoll:
          deletedFromCameraRoll ?? this.deletedFromCameraRoll,
      isStarred: isStarred ?? this.isStarred,
      tags: tags ?? this.tags,
      specificLocation: specificLocation ?? this.specificLocation,
      generalLocation: generalLocation ?? this.generalLocation,
      base64encoded: base64encoded ?? this.base64encoded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (originalLatitude.present) {
      map['original_latitude'] = Variable<double?>(originalLatitude.value);
    }
    if (originalLongitude.present) {
      map['original_longitude'] = Variable<double?>(originalLongitude.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double?>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double?>(longitude.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (deletedFromCameraRoll.present) {
      map['deleted_from_camera_roll'] =
          Variable<bool>(deletedFromCameraRoll.value);
    }
    if (isStarred.present) {
      map['is_starred'] = Variable<bool>(isStarred.value);
    }
    if (tags.present) {
      final converter = $PhotosTable.$converter0;
      map['tags'] = Variable<String>(converter.mapToSql(tags.value)!);
    }
    if (specificLocation.present) {
      map['specific_location'] = Variable<String?>(specificLocation.value);
    }
    if (generalLocation.present) {
      map['general_location'] = Variable<String?>(generalLocation.value);
    }
    if (base64encoded.present) {
      map['base64encoded'] = Variable<String?>(base64encoded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('originalLatitude: $originalLatitude, ')
          ..write('originalLongitude: $originalLongitude, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('deletedFromCameraRoll: $deletedFromCameraRoll, ')
          ..write('isStarred: $isStarred, ')
          ..write('tags: $tags, ')
          ..write('specificLocation: $specificLocation, ')
          ..write('generalLocation: $generalLocation, ')
          ..write('base64encoded: $base64encoded')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PhotosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedTextColumn id = _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedDateTimeColumn createdAt = _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _originalLatitudeMeta =
      const VerificationMeta('originalLatitude');
  @override
  late final GeneratedRealColumn originalLatitude =
      _constructOriginalLatitude();
  GeneratedRealColumn _constructOriginalLatitude() {
    return GeneratedRealColumn(
      'original_latitude',
      $tableName,
      true,
    );
  }

  final VerificationMeta _originalLongitudeMeta =
      const VerificationMeta('originalLongitude');
  @override
  late final GeneratedRealColumn originalLongitude =
      _constructOriginalLongitude();
  GeneratedRealColumn _constructOriginalLongitude() {
    return GeneratedRealColumn(
      'original_longitude',
      $tableName,
      true,
    );
  }

  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  @override
  late final GeneratedRealColumn latitude = _constructLatitude();
  GeneratedRealColumn _constructLatitude() {
    return GeneratedRealColumn(
      'latitude',
      $tableName,
      true,
    );
  }

  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  @override
  late final GeneratedRealColumn longitude = _constructLongitude();
  GeneratedRealColumn _constructLongitude() {
    return GeneratedRealColumn(
      'longitude',
      $tableName,
      true,
    );
  }

  final VerificationMeta _isPrivateMeta = const VerificationMeta('isPrivate');
  @override
  late final GeneratedBoolColumn isPrivate = _constructIsPrivate();
  GeneratedBoolColumn _constructIsPrivate() {
    return GeneratedBoolColumn('is_private', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _deletedFromCameraRollMeta =
      const VerificationMeta('deletedFromCameraRoll');
  @override
  late final GeneratedBoolColumn deletedFromCameraRoll =
      _constructDeletedFromCameraRoll();
  GeneratedBoolColumn _constructDeletedFromCameraRoll() {
    return GeneratedBoolColumn('deleted_from_camera_roll', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _isStarredMeta = const VerificationMeta('isStarred');
  @override
  late final GeneratedBoolColumn isStarred = _constructIsStarred();
  GeneratedBoolColumn _constructIsStarred() {
    return GeneratedBoolColumn('is_starred', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedTextColumn tags = _constructTags();
  GeneratedTextColumn _constructTags() {
    return GeneratedTextColumn(
      'tags',
      $tableName,
      false,
    );
  }

  final VerificationMeta _specificLocationMeta =
      const VerificationMeta('specificLocation');
  @override
  late final GeneratedTextColumn specificLocation =
      _constructSpecificLocation();
  GeneratedTextColumn _constructSpecificLocation() {
    return GeneratedTextColumn(
      'specific_location',
      $tableName,
      true,
    );
  }

  final VerificationMeta _generalLocationMeta =
      const VerificationMeta('generalLocation');
  @override
  late final GeneratedTextColumn generalLocation = _constructGeneralLocation();
  GeneratedTextColumn _constructGeneralLocation() {
    return GeneratedTextColumn(
      'general_location',
      $tableName,
      true,
    );
  }

  final VerificationMeta _base64encodedMeta =
      const VerificationMeta('base64encoded');
  @override
  late final GeneratedTextColumn base64encoded = _constructBase64encoded();
  GeneratedTextColumn _constructBase64encoded() {
    return GeneratedTextColumn(
      'base64encoded',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        originalLatitude,
        originalLongitude,
        latitude,
        longitude,
        isPrivate,
        deletedFromCameraRoll,
        isStarred,
        tags,
        specificLocation,
        generalLocation,
        base64encoded
      ];
  @override
  $PhotosTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'photos';
  @override
  final String actualTableName = 'photos';
  @override
  VerificationContext validateIntegrity(Insertable<Photo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('original_latitude')) {
      context.handle(
          _originalLatitudeMeta,
          originalLatitude.isAcceptableOrUnknown(
              data['original_latitude']!, _originalLatitudeMeta));
    }
    if (data.containsKey('original_longitude')) {
      context.handle(
          _originalLongitudeMeta,
          originalLongitude.isAcceptableOrUnknown(
              data['original_longitude']!, _originalLongitudeMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('is_private')) {
      context.handle(_isPrivateMeta,
          isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta));
    }
    if (data.containsKey('deleted_from_camera_roll')) {
      context.handle(
          _deletedFromCameraRollMeta,
          deletedFromCameraRoll.isAcceptableOrUnknown(
              data['deleted_from_camera_roll']!, _deletedFromCameraRollMeta));
    }
    if (data.containsKey('is_starred')) {
      context.handle(_isStarredMeta,
          isStarred.isAcceptableOrUnknown(data['is_starred']!, _isStarredMeta));
    }
    context.handle(_tagsMeta, const VerificationResult.success());
    if (data.containsKey('specific_location')) {
      context.handle(
          _specificLocationMeta,
          specificLocation.isAcceptableOrUnknown(
              data['specific_location']!, _specificLocationMeta));
    }
    if (data.containsKey('general_location')) {
      context.handle(
          _generalLocationMeta,
          generalLocation.isAcceptableOrUnknown(
              data['general_location']!, _generalLocationMeta));
    }
    if (data.containsKey('base64encoded')) {
      context.handle(
          _base64encodedMeta,
          base64encoded.isAcceptableOrUnknown(
              data['base64encoded']!, _base64encodedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Photo.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(_db, alias);
  }

  static TypeConverter<Map<String, String>, String> $converter0 =
      MapStringConvertor();
}

class PicBlurHash extends DataClass implements Insertable<PicBlurHash> {
  final String photoId;
  final String blurHash;
  PicBlurHash({required this.photoId, required this.blurHash});
  factory PicBlurHash.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PicBlurHash(
      photoId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}photo_id'])!,
      blurHash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}blur_hash'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['photo_id'] = Variable<String>(photoId);
    map['blur_hash'] = Variable<String>(blurHash);
    return map;
  }

  PicBlurHashsCompanion toCompanion(bool nullToAbsent) {
    return PicBlurHashsCompanion(
      photoId: Value(photoId),
      blurHash: Value(blurHash),
    );
  }

  factory PicBlurHash.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PicBlurHash(
      photoId: serializer.fromJson<String>(json['photoId']),
      blurHash: serializer.fromJson<String>(json['blurHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'photoId': serializer.toJson<String>(photoId),
      'blurHash': serializer.toJson<String>(blurHash),
    };
  }

  PicBlurHash copyWith({String? photoId, String? blurHash}) => PicBlurHash(
        photoId: photoId ?? this.photoId,
        blurHash: blurHash ?? this.blurHash,
      );
  @override
  String toString() {
    return (StringBuffer('PicBlurHash(')
          ..write('photoId: $photoId, ')
          ..write('blurHash: $blurHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(photoId.hashCode, blurHash.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PicBlurHash &&
          other.photoId == this.photoId &&
          other.blurHash == this.blurHash);
}

class PicBlurHashsCompanion extends UpdateCompanion<PicBlurHash> {
  final Value<String> photoId;
  final Value<String> blurHash;
  const PicBlurHashsCompanion({
    this.photoId = const Value.absent(),
    this.blurHash = const Value.absent(),
  });
  PicBlurHashsCompanion.insert({
    required String photoId,
    required String blurHash,
  })  : photoId = Value(photoId),
        blurHash = Value(blurHash);
  static Insertable<PicBlurHash> custom({
    Expression<String>? photoId,
    Expression<String>? blurHash,
  }) {
    return RawValuesInsertable({
      if (photoId != null) 'photo_id': photoId,
      if (blurHash != null) 'blur_hash': blurHash,
    });
  }

  PicBlurHashsCompanion copyWith(
      {Value<String>? photoId, Value<String>? blurHash}) {
    return PicBlurHashsCompanion(
      photoId: photoId ?? this.photoId,
      blurHash: blurHash ?? this.blurHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (photoId.present) {
      map['photo_id'] = Variable<String>(photoId.value);
    }
    if (blurHash.present) {
      map['blur_hash'] = Variable<String>(blurHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PicBlurHashsCompanion(')
          ..write('photoId: $photoId, ')
          ..write('blurHash: $blurHash')
          ..write(')'))
        .toString();
  }
}

class $PicBlurHashsTable extends PicBlurHashs
    with TableInfo<$PicBlurHashsTable, PicBlurHash> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PicBlurHashsTable(this._db, [this._alias]);
  final VerificationMeta _photoIdMeta = const VerificationMeta('photoId');
  @override
  late final GeneratedTextColumn photoId = _constructPhotoId();
  GeneratedTextColumn _constructPhotoId() {
    return GeneratedTextColumn(
      'photo_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _blurHashMeta = const VerificationMeta('blurHash');
  @override
  late final GeneratedTextColumn blurHash = _constructBlurHash();
  GeneratedTextColumn _constructBlurHash() {
    return GeneratedTextColumn(
      'blur_hash',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [photoId, blurHash];
  @override
  $PicBlurHashsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'pic_blur_hashs';
  @override
  final String actualTableName = 'pic_blur_hashs';
  @override
  VerificationContext validateIntegrity(Insertable<PicBlurHash> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('photo_id')) {
      context.handle(_photoIdMeta,
          photoId.isAcceptableOrUnknown(data['photo_id']!, _photoIdMeta));
    } else if (isInserting) {
      context.missing(_photoIdMeta);
    }
    if (data.containsKey('blur_hash')) {
      context.handle(_blurHashMeta,
          blurHash.isAcceptableOrUnknown(data['blur_hash']!, _blurHashMeta));
    } else if (isInserting) {
      context.missing(_blurHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {photoId};
  @override
  PicBlurHash map(Map<String, dynamic> data, {String? tablePrefix}) {
    return PicBlurHash.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PicBlurHashsTable createAlias(String alias) {
    return $PicBlurHashsTable(_db, alias);
  }
}

class Private extends DataClass implements Insertable<Private> {
  final String id;
  final String path;
  final String nonce;
  final String? thumbPath;
  final DateTime? createDateTime;
  final double? originalLatitude;
  final double? originalLongitude;
  Private(
      {required this.id,
      required this.path,
      required this.nonce,
      this.thumbPath,
      this.createDateTime,
      this.originalLatitude,
      this.originalLongitude});
  factory Private.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Private(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      path: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}path'])!,
      nonce: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nonce'])!,
      thumbPath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}thumb_path']),
      createDateTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}create_date_time']),
      originalLatitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}original_latitude']),
      originalLongitude: const RealType().mapFromDatabaseResponse(
          data['${effectivePrefix}original_longitude']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['path'] = Variable<String>(path);
    map['nonce'] = Variable<String>(nonce);
    if (!nullToAbsent || thumbPath != null) {
      map['thumb_path'] = Variable<String?>(thumbPath);
    }
    if (!nullToAbsent || createDateTime != null) {
      map['create_date_time'] = Variable<DateTime?>(createDateTime);
    }
    if (!nullToAbsent || originalLatitude != null) {
      map['original_latitude'] = Variable<double?>(originalLatitude);
    }
    if (!nullToAbsent || originalLongitude != null) {
      map['original_longitude'] = Variable<double?>(originalLongitude);
    }
    return map;
  }

  PrivatesCompanion toCompanion(bool nullToAbsent) {
    return PrivatesCompanion(
      id: Value(id),
      path: Value(path),
      nonce: Value(nonce),
      thumbPath: thumbPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbPath),
      createDateTime: createDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(createDateTime),
      originalLatitude: originalLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLatitude),
      originalLongitude: originalLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLongitude),
    );
  }

  factory Private.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Private(
      id: serializer.fromJson<String>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      nonce: serializer.fromJson<String>(json['nonce']),
      thumbPath: serializer.fromJson<String?>(json['thumbPath']),
      createDateTime: serializer.fromJson<DateTime?>(json['createDateTime']),
      originalLatitude: serializer.fromJson<double?>(json['originalLatitude']),
      originalLongitude:
          serializer.fromJson<double?>(json['originalLongitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'path': serializer.toJson<String>(path),
      'nonce': serializer.toJson<String>(nonce),
      'thumbPath': serializer.toJson<String?>(thumbPath),
      'createDateTime': serializer.toJson<DateTime?>(createDateTime),
      'originalLatitude': serializer.toJson<double?>(originalLatitude),
      'originalLongitude': serializer.toJson<double?>(originalLongitude),
    };
  }

  Private copyWith(
          {String? id,
          String? path,
          String? nonce,
          String? thumbPath,
          DateTime? createDateTime,
          double? originalLatitude,
          double? originalLongitude}) =>
      Private(
        id: id ?? this.id,
        path: path ?? this.path,
        nonce: nonce ?? this.nonce,
        thumbPath: thumbPath ?? this.thumbPath,
        createDateTime: createDateTime ?? this.createDateTime,
        originalLatitude: originalLatitude ?? this.originalLatitude,
        originalLongitude: originalLongitude ?? this.originalLongitude,
      );
  @override
  String toString() {
    return (StringBuffer('Private(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('nonce: $nonce, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('createDateTime: $createDateTime, ')
          ..write('originalLatitude: $originalLatitude, ')
          ..write('originalLongitude: $originalLongitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          path.hashCode,
          $mrjc(
              nonce.hashCode,
              $mrjc(
                  thumbPath.hashCode,
                  $mrjc(
                      createDateTime.hashCode,
                      $mrjc(originalLatitude.hashCode,
                          originalLongitude.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Private &&
          other.id == this.id &&
          other.path == this.path &&
          other.nonce == this.nonce &&
          other.thumbPath == this.thumbPath &&
          other.createDateTime == this.createDateTime &&
          other.originalLatitude == this.originalLatitude &&
          other.originalLongitude == this.originalLongitude);
}

class PrivatesCompanion extends UpdateCompanion<Private> {
  final Value<String> id;
  final Value<String> path;
  final Value<String> nonce;
  final Value<String?> thumbPath;
  final Value<DateTime?> createDateTime;
  final Value<double?> originalLatitude;
  final Value<double?> originalLongitude;
  const PrivatesCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.nonce = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.createDateTime = const Value.absent(),
    this.originalLatitude = const Value.absent(),
    this.originalLongitude = const Value.absent(),
  });
  PrivatesCompanion.insert({
    required String id,
    required String path,
    required String nonce,
    this.thumbPath = const Value.absent(),
    this.createDateTime = const Value.absent(),
    this.originalLatitude = const Value.absent(),
    this.originalLongitude = const Value.absent(),
  })  : id = Value(id),
        path = Value(path),
        nonce = Value(nonce);
  static Insertable<Private> custom({
    Expression<String>? id,
    Expression<String>? path,
    Expression<String>? nonce,
    Expression<String?>? thumbPath,
    Expression<DateTime?>? createDateTime,
    Expression<double?>? originalLatitude,
    Expression<double?>? originalLongitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (nonce != null) 'nonce': nonce,
      if (thumbPath != null) 'thumb_path': thumbPath,
      if (createDateTime != null) 'create_date_time': createDateTime,
      if (originalLatitude != null) 'original_latitude': originalLatitude,
      if (originalLongitude != null) 'original_longitude': originalLongitude,
    });
  }

  PrivatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? path,
      Value<String>? nonce,
      Value<String?>? thumbPath,
      Value<DateTime?>? createDateTime,
      Value<double?>? originalLatitude,
      Value<double?>? originalLongitude}) {
    return PrivatesCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      nonce: nonce ?? this.nonce,
      thumbPath: thumbPath ?? this.thumbPath,
      createDateTime: createDateTime ?? this.createDateTime,
      originalLatitude: originalLatitude ?? this.originalLatitude,
      originalLongitude: originalLongitude ?? this.originalLongitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<String>(nonce.value);
    }
    if (thumbPath.present) {
      map['thumb_path'] = Variable<String?>(thumbPath.value);
    }
    if (createDateTime.present) {
      map['create_date_time'] = Variable<DateTime?>(createDateTime.value);
    }
    if (originalLatitude.present) {
      map['original_latitude'] = Variable<double?>(originalLatitude.value);
    }
    if (originalLongitude.present) {
      map['original_longitude'] = Variable<double?>(originalLongitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivatesCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('nonce: $nonce, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('createDateTime: $createDateTime, ')
          ..write('originalLatitude: $originalLatitude, ')
          ..write('originalLongitude: $originalLongitude')
          ..write(')'))
        .toString();
  }
}

class $PrivatesTable extends Privates with TableInfo<$PrivatesTable, Private> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PrivatesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedTextColumn id = _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedTextColumn path = _constructPath();
  GeneratedTextColumn _constructPath() {
    return GeneratedTextColumn(
      'path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedTextColumn nonce = _constructNonce();
  GeneratedTextColumn _constructNonce() {
    return GeneratedTextColumn(
      'nonce',
      $tableName,
      false,
    );
  }

  final VerificationMeta _thumbPathMeta = const VerificationMeta('thumbPath');
  @override
  late final GeneratedTextColumn thumbPath = _constructThumbPath();
  GeneratedTextColumn _constructThumbPath() {
    return GeneratedTextColumn(
      'thumb_path',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createDateTimeMeta =
      const VerificationMeta('createDateTime');
  @override
  late final GeneratedDateTimeColumn createDateTime =
      _constructCreateDateTime();
  GeneratedDateTimeColumn _constructCreateDateTime() {
    return GeneratedDateTimeColumn(
      'create_date_time',
      $tableName,
      true,
    );
  }

  final VerificationMeta _originalLatitudeMeta =
      const VerificationMeta('originalLatitude');
  @override
  late final GeneratedRealColumn originalLatitude =
      _constructOriginalLatitude();
  GeneratedRealColumn _constructOriginalLatitude() {
    return GeneratedRealColumn(
      'original_latitude',
      $tableName,
      true,
    );
  }

  final VerificationMeta _originalLongitudeMeta =
      const VerificationMeta('originalLongitude');
  @override
  late final GeneratedRealColumn originalLongitude =
      _constructOriginalLongitude();
  GeneratedRealColumn _constructOriginalLongitude() {
    return GeneratedRealColumn(
      'original_longitude',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        path,
        nonce,
        thumbPath,
        createDateTime,
        originalLatitude,
        originalLongitude
      ];
  @override
  $PrivatesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'privates';
  @override
  final String actualTableName = 'privates';
  @override
  VerificationContext validateIntegrity(Insertable<Private> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
          _nonceMeta, nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta));
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('thumb_path')) {
      context.handle(_thumbPathMeta,
          thumbPath.isAcceptableOrUnknown(data['thumb_path']!, _thumbPathMeta));
    }
    if (data.containsKey('create_date_time')) {
      context.handle(
          _createDateTimeMeta,
          createDateTime.isAcceptableOrUnknown(
              data['create_date_time']!, _createDateTimeMeta));
    }
    if (data.containsKey('original_latitude')) {
      context.handle(
          _originalLatitudeMeta,
          originalLatitude.isAcceptableOrUnknown(
              data['original_latitude']!, _originalLatitudeMeta));
    }
    if (data.containsKey('original_longitude')) {
      context.handle(
          _originalLongitudeMeta,
          originalLongitude.isAcceptableOrUnknown(
              data['original_longitude']!, _originalLongitudeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Private map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Private.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PrivatesTable createAlias(String alias) {
    return $PrivatesTable(_db, alias);
  }
}

class Label extends DataClass implements Insertable<Label> {
  final String key;
  final int counter;
  final DateTime lastUsedAt;
  final String title;
  final Map<String, String> photoId;
  Label(
      {required this.key,
      required this.counter,
      required this.lastUsedAt,
      required this.title,
      required this.photoId});
  factory Label.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Label(
      key: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key'])!,
      counter: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}counter'])!,
      lastUsedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_used_at'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      photoId: $LabelsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}photo_id']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['counter'] = Variable<int>(counter);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    map['title'] = Variable<String>(title);
    {
      final converter = $LabelsTable.$converter0;
      map['photo_id'] = Variable<String>(converter.mapToSql(photoId)!);
    }
    return map;
  }

  LabelsCompanion toCompanion(bool nullToAbsent) {
    return LabelsCompanion(
      key: Value(key),
      counter: Value(counter),
      lastUsedAt: Value(lastUsedAt),
      title: Value(title),
      photoId: Value(photoId),
    );
  }

  factory Label.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Label(
      key: serializer.fromJson<String>(json['key']),
      counter: serializer.fromJson<int>(json['counter']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
      title: serializer.fromJson<String>(json['title']),
      photoId: serializer.fromJson<Map<String, String>>(json['photoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'counter': serializer.toJson<int>(counter),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
      'title': serializer.toJson<String>(title),
      'photoId': serializer.toJson<Map<String, String>>(photoId),
    };
  }

  Label copyWith(
          {String? key,
          int? counter,
          DateTime? lastUsedAt,
          String? title,
          Map<String, String>? photoId}) =>
      Label(
        key: key ?? this.key,
        counter: counter ?? this.counter,
        lastUsedAt: lastUsedAt ?? this.lastUsedAt,
        title: title ?? this.title,
        photoId: photoId ?? this.photoId,
      );
  @override
  String toString() {
    return (StringBuffer('Label(')
          ..write('key: $key, ')
          ..write('counter: $counter, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('title: $title, ')
          ..write('photoId: $photoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      key.hashCode,
      $mrjc(
          counter.hashCode,
          $mrjc(
              lastUsedAt.hashCode, $mrjc(title.hashCode, photoId.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Label &&
          other.key == this.key &&
          other.counter == this.counter &&
          other.lastUsedAt == this.lastUsedAt &&
          other.title == this.title &&
          other.photoId == this.photoId);
}

class LabelsCompanion extends UpdateCompanion<Label> {
  final Value<String> key;
  final Value<int> counter;
  final Value<DateTime> lastUsedAt;
  final Value<String> title;
  final Value<Map<String, String>> photoId;
  const LabelsCompanion({
    this.key = const Value.absent(),
    this.counter = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.photoId = const Value.absent(),
  });
  LabelsCompanion.insert({
    this.key = const Value.absent(),
    this.counter = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.title = const Value.absent(),
    required Map<String, String> photoId,
  }) : photoId = Value(photoId);
  static Insertable<Label> custom({
    Expression<String>? key,
    Expression<int>? counter,
    Expression<DateTime>? lastUsedAt,
    Expression<String>? title,
    Expression<Map<String, String>>? photoId,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (counter != null) 'counter': counter,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (title != null) 'title': title,
      if (photoId != null) 'photo_id': photoId,
    });
  }

  LabelsCompanion copyWith(
      {Value<String>? key,
      Value<int>? counter,
      Value<DateTime>? lastUsedAt,
      Value<String>? title,
      Value<Map<String, String>>? photoId}) {
    return LabelsCompanion(
      key: key ?? this.key,
      counter: counter ?? this.counter,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      title: title ?? this.title,
      photoId: photoId ?? this.photoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (counter.present) {
      map['counter'] = Variable<int>(counter.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (photoId.present) {
      final converter = $LabelsTable.$converter0;
      map['photo_id'] = Variable<String>(converter.mapToSql(photoId.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelsCompanion(')
          ..write('key: $key, ')
          ..write('counter: $counter, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('title: $title, ')
          ..write('photoId: $photoId')
          ..write(')'))
        .toString();
  }
}

class $LabelsTable extends Labels with TableInfo<$LabelsTable, Label> {
  final GeneratedDatabase _db;
  final String? _alias;
  $LabelsTable(this._db, [this._alias]);
  final VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedTextColumn key = _constructKey();
  GeneratedTextColumn _constructKey() {
    return GeneratedTextColumn('key', $tableName, false,
        defaultValue: Constant(Uuid().v4()));
  }

  final VerificationMeta _counterMeta = const VerificationMeta('counter');
  @override
  late final GeneratedIntColumn counter = _constructCounter();
  GeneratedIntColumn _constructCounter() {
    return GeneratedIntColumn('counter', $tableName, false,
        defaultValue: const Constant(1));
  }

  final VerificationMeta _lastUsedAtMeta = const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedDateTimeColumn lastUsedAt = _constructLastUsedAt();
  GeneratedDateTimeColumn _constructLastUsedAt() {
    return GeneratedDateTimeColumn('last_used_at', $tableName, false,
        defaultValue: Constant(DateTime.now()));
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedTextColumn title = _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false,
        defaultValue: const Constant(''));
  }

  final VerificationMeta _photoIdMeta = const VerificationMeta('photoId');
  @override
  late final GeneratedTextColumn photoId = _constructPhotoId();
  GeneratedTextColumn _constructPhotoId() {
    return GeneratedTextColumn(
      'photo_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [key, counter, lastUsedAt, title, photoId];
  @override
  $LabelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'labels';
  @override
  final String actualTableName = 'labels';
  @override
  VerificationContext validateIntegrity(Insertable<Label> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    }
    if (data.containsKey('counter')) {
      context.handle(_counterMeta,
          counter.isAcceptableOrUnknown(data['counter']!, _counterMeta));
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    context.handle(_photoIdMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Label map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Label.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $LabelsTable createAlias(String alias) {
    return $LabelsTable(_db, alias);
  }

  static TypeConverter<Map<String, String>, String> $converter0 =
      MapStringConvertor();
}

class MoorUser extends DataClass implements Insertable<MoorUser> {
  final int customPrimaryKey;
  final String id;
  final String? email;
  final String? password;
  final bool notification;
  final bool dailyChallenges;
  final List<String> recentTags;
  final String? appLanguage;
  final String? appVersion;
  final String? secretKey;
  final Map<String, String> starredPhotos;
  final String? defaultWidgetImage;
  final int goal;
  final int hourOfDay;
  final int minuteOfDay;
  final int picsTaggedToday;
  final bool tutorialCompleted;
  final bool canTagToday;
  final bool hasGalleryPermission;
  final bool loggedIn;
  final bool secretPhotos;
  final bool isPinRegistered;
  final bool keepAskingToDelete;
  final bool shouldDeleteOnPrivate;
  final bool tourCompleted;
  final bool isBiometricActivated;
  final DateTime lastTaggedPicDate;
  MoorUser(
      {required this.customPrimaryKey,
      required this.id,
      this.email,
      this.password,
      required this.notification,
      required this.dailyChallenges,
      required this.recentTags,
      this.appLanguage,
      this.appVersion,
      this.secretKey,
      required this.starredPhotos,
      this.defaultWidgetImage,
      required this.goal,
      required this.hourOfDay,
      required this.minuteOfDay,
      required this.picsTaggedToday,
      required this.tutorialCompleted,
      required this.canTagToday,
      required this.hasGalleryPermission,
      required this.loggedIn,
      required this.secretPhotos,
      required this.isPinRegistered,
      required this.keepAskingToDelete,
      required this.shouldDeleteOnPrivate,
      required this.tourCompleted,
      required this.isBiometricActivated,
      required this.lastTaggedPicDate});
  factory MoorUser.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return MoorUser(
      customPrimaryKey: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}custom_primary_key'])!,
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email']),
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      notification: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}notification'])!,
      dailyChallenges: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}daily_challenges'])!,
      recentTags: $MoorUsersTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}recent_tags']))!,
      appLanguage: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}app_language']),
      appVersion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}app_version']),
      secretKey: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}secret_key']),
      starredPhotos: $MoorUsersTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}starred_photos']))!,
      defaultWidgetImage: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}default_widget_image']),
      goal: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}goal'])!,
      hourOfDay: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hour_of_day'])!,
      minuteOfDay: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}minute_of_day'])!,
      picsTaggedToday: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}pics_tagged_today'])!,
      tutorialCompleted: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}tutorial_completed'])!,
      canTagToday: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}can_tag_today'])!,
      hasGalleryPermission: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}has_gallery_permission'])!,
      loggedIn: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}logged_in'])!,
      secretPhotos: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}secret_photos'])!,
      isPinRegistered: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}is_pin_registered'])!,
      keepAskingToDelete: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}keep_asking_to_delete'])!,
      shouldDeleteOnPrivate: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}should_delete_on_private'])!,
      tourCompleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tour_completed'])!,
      isBiometricActivated: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}is_biometric_activated'])!,
      lastTaggedPicDate: const DateTimeType().mapFromDatabaseResponse(
          data['${effectivePrefix}last_tagged_pic_date'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['custom_primary_key'] = Variable<int>(customPrimaryKey);
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String?>(email);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String?>(password);
    }
    map['notification'] = Variable<bool>(notification);
    map['daily_challenges'] = Variable<bool>(dailyChallenges);
    {
      final converter = $MoorUsersTable.$converter0;
      map['recent_tags'] = Variable<String>(converter.mapToSql(recentTags)!);
    }
    if (!nullToAbsent || appLanguage != null) {
      map['app_language'] = Variable<String?>(appLanguage);
    }
    if (!nullToAbsent || appVersion != null) {
      map['app_version'] = Variable<String?>(appVersion);
    }
    if (!nullToAbsent || secretKey != null) {
      map['secret_key'] = Variable<String?>(secretKey);
    }
    {
      final converter = $MoorUsersTable.$converter1;
      map['starred_photos'] =
          Variable<String>(converter.mapToSql(starredPhotos)!);
    }
    if (!nullToAbsent || defaultWidgetImage != null) {
      map['default_widget_image'] = Variable<String?>(defaultWidgetImage);
    }
    map['goal'] = Variable<int>(goal);
    map['hour_of_day'] = Variable<int>(hourOfDay);
    map['minute_of_day'] = Variable<int>(minuteOfDay);
    map['pics_tagged_today'] = Variable<int>(picsTaggedToday);
    map['tutorial_completed'] = Variable<bool>(tutorialCompleted);
    map['can_tag_today'] = Variable<bool>(canTagToday);
    map['has_gallery_permission'] = Variable<bool>(hasGalleryPermission);
    map['logged_in'] = Variable<bool>(loggedIn);
    map['secret_photos'] = Variable<bool>(secretPhotos);
    map['is_pin_registered'] = Variable<bool>(isPinRegistered);
    map['keep_asking_to_delete'] = Variable<bool>(keepAskingToDelete);
    map['should_delete_on_private'] = Variable<bool>(shouldDeleteOnPrivate);
    map['tour_completed'] = Variable<bool>(tourCompleted);
    map['is_biometric_activated'] = Variable<bool>(isBiometricActivated);
    map['last_tagged_pic_date'] = Variable<DateTime>(lastTaggedPicDate);
    return map;
  }

  MoorUsersCompanion toCompanion(bool nullToAbsent) {
    return MoorUsersCompanion(
      customPrimaryKey: Value(customPrimaryKey),
      id: Value(id),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      notification: Value(notification),
      dailyChallenges: Value(dailyChallenges),
      recentTags: Value(recentTags),
      appLanguage: appLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(appLanguage),
      appVersion: appVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(appVersion),
      secretKey: secretKey == null && nullToAbsent
          ? const Value.absent()
          : Value(secretKey),
      starredPhotos: Value(starredPhotos),
      defaultWidgetImage: defaultWidgetImage == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultWidgetImage),
      goal: Value(goal),
      hourOfDay: Value(hourOfDay),
      minuteOfDay: Value(minuteOfDay),
      picsTaggedToday: Value(picsTaggedToday),
      tutorialCompleted: Value(tutorialCompleted),
      canTagToday: Value(canTagToday),
      hasGalleryPermission: Value(hasGalleryPermission),
      loggedIn: Value(loggedIn),
      secretPhotos: Value(secretPhotos),
      isPinRegistered: Value(isPinRegistered),
      keepAskingToDelete: Value(keepAskingToDelete),
      shouldDeleteOnPrivate: Value(shouldDeleteOnPrivate),
      tourCompleted: Value(tourCompleted),
      isBiometricActivated: Value(isBiometricActivated),
      lastTaggedPicDate: Value(lastTaggedPicDate),
    );
  }

  factory MoorUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return MoorUser(
      customPrimaryKey: serializer.fromJson<int>(json['customPrimaryKey']),
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String?>(json['email']),
      password: serializer.fromJson<String?>(json['password']),
      notification: serializer.fromJson<bool>(json['notification']),
      dailyChallenges: serializer.fromJson<bool>(json['dailyChallenges']),
      recentTags: serializer.fromJson<List<String>>(json['recentTags']),
      appLanguage: serializer.fromJson<String?>(json['appLanguage']),
      appVersion: serializer.fromJson<String?>(json['appVersion']),
      secretKey: serializer.fromJson<String?>(json['secretKey']),
      starredPhotos:
          serializer.fromJson<Map<String, String>>(json['starredPhotos']),
      defaultWidgetImage:
          serializer.fromJson<String?>(json['defaultWidgetImage']),
      goal: serializer.fromJson<int>(json['goal']),
      hourOfDay: serializer.fromJson<int>(json['hourOfDay']),
      minuteOfDay: serializer.fromJson<int>(json['minuteOfDay']),
      picsTaggedToday: serializer.fromJson<int>(json['picsTaggedToday']),
      tutorialCompleted: serializer.fromJson<bool>(json['tutorialCompleted']),
      canTagToday: serializer.fromJson<bool>(json['canTagToday']),
      hasGalleryPermission:
          serializer.fromJson<bool>(json['hasGalleryPermission']),
      loggedIn: serializer.fromJson<bool>(json['loggedIn']),
      secretPhotos: serializer.fromJson<bool>(json['secretPhotos']),
      isPinRegistered: serializer.fromJson<bool>(json['isPinRegistered']),
      keepAskingToDelete: serializer.fromJson<bool>(json['keepAskingToDelete']),
      shouldDeleteOnPrivate:
          serializer.fromJson<bool>(json['shouldDeleteOnPrivate']),
      tourCompleted: serializer.fromJson<bool>(json['tourCompleted']),
      isBiometricActivated:
          serializer.fromJson<bool>(json['isBiometricActivated']),
      lastTaggedPicDate:
          serializer.fromJson<DateTime>(json['lastTaggedPicDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'customPrimaryKey': serializer.toJson<int>(customPrimaryKey),
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String?>(email),
      'password': serializer.toJson<String?>(password),
      'notification': serializer.toJson<bool>(notification),
      'dailyChallenges': serializer.toJson<bool>(dailyChallenges),
      'recentTags': serializer.toJson<List<String>>(recentTags),
      'appLanguage': serializer.toJson<String?>(appLanguage),
      'appVersion': serializer.toJson<String?>(appVersion),
      'secretKey': serializer.toJson<String?>(secretKey),
      'starredPhotos': serializer.toJson<Map<String, String>>(starredPhotos),
      'defaultWidgetImage': serializer.toJson<String?>(defaultWidgetImage),
      'goal': serializer.toJson<int>(goal),
      'hourOfDay': serializer.toJson<int>(hourOfDay),
      'minuteOfDay': serializer.toJson<int>(minuteOfDay),
      'picsTaggedToday': serializer.toJson<int>(picsTaggedToday),
      'tutorialCompleted': serializer.toJson<bool>(tutorialCompleted),
      'canTagToday': serializer.toJson<bool>(canTagToday),
      'hasGalleryPermission': serializer.toJson<bool>(hasGalleryPermission),
      'loggedIn': serializer.toJson<bool>(loggedIn),
      'secretPhotos': serializer.toJson<bool>(secretPhotos),
      'isPinRegistered': serializer.toJson<bool>(isPinRegistered),
      'keepAskingToDelete': serializer.toJson<bool>(keepAskingToDelete),
      'shouldDeleteOnPrivate': serializer.toJson<bool>(shouldDeleteOnPrivate),
      'tourCompleted': serializer.toJson<bool>(tourCompleted),
      'isBiometricActivated': serializer.toJson<bool>(isBiometricActivated),
      'lastTaggedPicDate': serializer.toJson<DateTime>(lastTaggedPicDate),
    };
  }

  MoorUser copyWith(
          {int? customPrimaryKey,
          String? id,
          String? email,
          String? password,
          bool? notification,
          bool? dailyChallenges,
          List<String>? recentTags,
          String? appLanguage,
          String? appVersion,
          String? secretKey,
          Map<String, String>? starredPhotos,
          String? defaultWidgetImage,
          int? goal,
          int? hourOfDay,
          int? minuteOfDay,
          int? picsTaggedToday,
          bool? tutorialCompleted,
          bool? canTagToday,
          bool? hasGalleryPermission,
          bool? loggedIn,
          bool? secretPhotos,
          bool? isPinRegistered,
          bool? keepAskingToDelete,
          bool? shouldDeleteOnPrivate,
          bool? tourCompleted,
          bool? isBiometricActivated,
          DateTime? lastTaggedPicDate}) =>
      MoorUser(
        customPrimaryKey: customPrimaryKey ?? this.customPrimaryKey,
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        notification: notification ?? this.notification,
        dailyChallenges: dailyChallenges ?? this.dailyChallenges,
        recentTags: recentTags ?? this.recentTags,
        appLanguage: appLanguage ?? this.appLanguage,
        appVersion: appVersion ?? this.appVersion,
        secretKey: secretKey ?? this.secretKey,
        starredPhotos: starredPhotos ?? this.starredPhotos,
        defaultWidgetImage: defaultWidgetImage ?? this.defaultWidgetImage,
        goal: goal ?? this.goal,
        hourOfDay: hourOfDay ?? this.hourOfDay,
        minuteOfDay: minuteOfDay ?? this.minuteOfDay,
        picsTaggedToday: picsTaggedToday ?? this.picsTaggedToday,
        tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
        canTagToday: canTagToday ?? this.canTagToday,
        hasGalleryPermission: hasGalleryPermission ?? this.hasGalleryPermission,
        loggedIn: loggedIn ?? this.loggedIn,
        secretPhotos: secretPhotos ?? this.secretPhotos,
        isPinRegistered: isPinRegistered ?? this.isPinRegistered,
        keepAskingToDelete: keepAskingToDelete ?? this.keepAskingToDelete,
        shouldDeleteOnPrivate:
            shouldDeleteOnPrivate ?? this.shouldDeleteOnPrivate,
        tourCompleted: tourCompleted ?? this.tourCompleted,
        isBiometricActivated: isBiometricActivated ?? this.isBiometricActivated,
        lastTaggedPicDate: lastTaggedPicDate ?? this.lastTaggedPicDate,
      );
  @override
  String toString() {
    return (StringBuffer('MoorUser(')
          ..write('customPrimaryKey: $customPrimaryKey, ')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('notification: $notification, ')
          ..write('dailyChallenges: $dailyChallenges, ')
          ..write('recentTags: $recentTags, ')
          ..write('appLanguage: $appLanguage, ')
          ..write('appVersion: $appVersion, ')
          ..write('secretKey: $secretKey, ')
          ..write('starredPhotos: $starredPhotos, ')
          ..write('defaultWidgetImage: $defaultWidgetImage, ')
          ..write('goal: $goal, ')
          ..write('hourOfDay: $hourOfDay, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('picsTaggedToday: $picsTaggedToday, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
          ..write('canTagToday: $canTagToday, ')
          ..write('hasGalleryPermission: $hasGalleryPermission, ')
          ..write('loggedIn: $loggedIn, ')
          ..write('secretPhotos: $secretPhotos, ')
          ..write('isPinRegistered: $isPinRegistered, ')
          ..write('keepAskingToDelete: $keepAskingToDelete, ')
          ..write('shouldDeleteOnPrivate: $shouldDeleteOnPrivate, ')
          ..write('tourCompleted: $tourCompleted, ')
          ..write('isBiometricActivated: $isBiometricActivated, ')
          ..write('lastTaggedPicDate: $lastTaggedPicDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      customPrimaryKey.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              email.hashCode,
              $mrjc(
                  password.hashCode,
                  $mrjc(
                      notification.hashCode,
                      $mrjc(
                          dailyChallenges.hashCode,
                          $mrjc(
                              recentTags.hashCode,
                              $mrjc(
                                  appLanguage.hashCode,
                                  $mrjc(
                                      appVersion.hashCode,
                                      $mrjc(
                                          secretKey.hashCode,
                                          $mrjc(
                                              starredPhotos.hashCode,
                                              $mrjc(
                                                  defaultWidgetImage.hashCode,
                                                  $mrjc(
                                                      goal.hashCode,
                                                      $mrjc(
                                                          hourOfDay.hashCode,
                                                          $mrjc(
                                                              minuteOfDay
                                                                  .hashCode,
                                                              $mrjc(
                                                                  picsTaggedToday
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      tutorialCompleted
                                                                          .hashCode,
                                                                      $mrjc(
                                                                          canTagToday
                                                                              .hashCode,
                                                                          $mrjc(
                                                                              hasGalleryPermission.hashCode,
                                                                              $mrjc(loggedIn.hashCode, $mrjc(secretPhotos.hashCode, $mrjc(isPinRegistered.hashCode, $mrjc(keepAskingToDelete.hashCode, $mrjc(shouldDeleteOnPrivate.hashCode, $mrjc(tourCompleted.hashCode, $mrjc(isBiometricActivated.hashCode, lastTaggedPicDate.hashCode)))))))))))))))))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoorUser &&
          other.customPrimaryKey == this.customPrimaryKey &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.notification == this.notification &&
          other.dailyChallenges == this.dailyChallenges &&
          other.recentTags == this.recentTags &&
          other.appLanguage == this.appLanguage &&
          other.appVersion == this.appVersion &&
          other.secretKey == this.secretKey &&
          other.starredPhotos == this.starredPhotos &&
          other.defaultWidgetImage == this.defaultWidgetImage &&
          other.goal == this.goal &&
          other.hourOfDay == this.hourOfDay &&
          other.minuteOfDay == this.minuteOfDay &&
          other.picsTaggedToday == this.picsTaggedToday &&
          other.tutorialCompleted == this.tutorialCompleted &&
          other.canTagToday == this.canTagToday &&
          other.hasGalleryPermission == this.hasGalleryPermission &&
          other.loggedIn == this.loggedIn &&
          other.secretPhotos == this.secretPhotos &&
          other.isPinRegistered == this.isPinRegistered &&
          other.keepAskingToDelete == this.keepAskingToDelete &&
          other.shouldDeleteOnPrivate == this.shouldDeleteOnPrivate &&
          other.tourCompleted == this.tourCompleted &&
          other.isBiometricActivated == this.isBiometricActivated &&
          other.lastTaggedPicDate == this.lastTaggedPicDate);
}

class MoorUsersCompanion extends UpdateCompanion<MoorUser> {
  final Value<int> customPrimaryKey;
  final Value<String> id;
  final Value<String?> email;
  final Value<String?> password;
  final Value<bool> notification;
  final Value<bool> dailyChallenges;
  final Value<List<String>> recentTags;
  final Value<String?> appLanguage;
  final Value<String?> appVersion;
  final Value<String?> secretKey;
  final Value<Map<String, String>> starredPhotos;
  final Value<String?> defaultWidgetImage;
  final Value<int> goal;
  final Value<int> hourOfDay;
  final Value<int> minuteOfDay;
  final Value<int> picsTaggedToday;
  final Value<bool> tutorialCompleted;
  final Value<bool> canTagToday;
  final Value<bool> hasGalleryPermission;
  final Value<bool> loggedIn;
  final Value<bool> secretPhotos;
  final Value<bool> isPinRegistered;
  final Value<bool> keepAskingToDelete;
  final Value<bool> shouldDeleteOnPrivate;
  final Value<bool> tourCompleted;
  final Value<bool> isBiometricActivated;
  final Value<DateTime> lastTaggedPicDate;
  const MoorUsersCompanion({
    this.customPrimaryKey = const Value.absent(),
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.notification = const Value.absent(),
    this.dailyChallenges = const Value.absent(),
    this.recentTags = const Value.absent(),
    this.appLanguage = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.secretKey = const Value.absent(),
    this.starredPhotos = const Value.absent(),
    this.defaultWidgetImage = const Value.absent(),
    this.goal = const Value.absent(),
    this.hourOfDay = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.picsTaggedToday = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
    this.canTagToday = const Value.absent(),
    this.hasGalleryPermission = const Value.absent(),
    this.loggedIn = const Value.absent(),
    this.secretPhotos = const Value.absent(),
    this.isPinRegistered = const Value.absent(),
    this.keepAskingToDelete = const Value.absent(),
    this.shouldDeleteOnPrivate = const Value.absent(),
    this.tourCompleted = const Value.absent(),
    this.isBiometricActivated = const Value.absent(),
    this.lastTaggedPicDate = const Value.absent(),
  });
  MoorUsersCompanion.insert({
    this.customPrimaryKey = const Value.absent(),
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.notification = const Value.absent(),
    this.dailyChallenges = const Value.absent(),
    required List<String> recentTags,
    this.appLanguage = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.secretKey = const Value.absent(),
    required Map<String, String> starredPhotos,
    this.defaultWidgetImage = const Value.absent(),
    this.goal = const Value.absent(),
    this.hourOfDay = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.picsTaggedToday = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
    this.canTagToday = const Value.absent(),
    this.hasGalleryPermission = const Value.absent(),
    this.loggedIn = const Value.absent(),
    this.secretPhotos = const Value.absent(),
    this.isPinRegistered = const Value.absent(),
    this.keepAskingToDelete = const Value.absent(),
    this.shouldDeleteOnPrivate = const Value.absent(),
    this.tourCompleted = const Value.absent(),
    this.isBiometricActivated = const Value.absent(),
    this.lastTaggedPicDate = const Value.absent(),
  })  : recentTags = Value(recentTags),
        starredPhotos = Value(starredPhotos);
  static Insertable<MoorUser> custom({
    Expression<int>? customPrimaryKey,
    Expression<String>? id,
    Expression<String?>? email,
    Expression<String?>? password,
    Expression<bool>? notification,
    Expression<bool>? dailyChallenges,
    Expression<List<String>>? recentTags,
    Expression<String?>? appLanguage,
    Expression<String?>? appVersion,
    Expression<String?>? secretKey,
    Expression<Map<String, String>>? starredPhotos,
    Expression<String?>? defaultWidgetImage,
    Expression<int>? goal,
    Expression<int>? hourOfDay,
    Expression<int>? minuteOfDay,
    Expression<int>? picsTaggedToday,
    Expression<bool>? tutorialCompleted,
    Expression<bool>? canTagToday,
    Expression<bool>? hasGalleryPermission,
    Expression<bool>? loggedIn,
    Expression<bool>? secretPhotos,
    Expression<bool>? isPinRegistered,
    Expression<bool>? keepAskingToDelete,
    Expression<bool>? shouldDeleteOnPrivate,
    Expression<bool>? tourCompleted,
    Expression<bool>? isBiometricActivated,
    Expression<DateTime>? lastTaggedPicDate,
  }) {
    return RawValuesInsertable({
      if (customPrimaryKey != null) 'custom_primary_key': customPrimaryKey,
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (notification != null) 'notification': notification,
      if (dailyChallenges != null) 'daily_challenges': dailyChallenges,
      if (recentTags != null) 'recent_tags': recentTags,
      if (appLanguage != null) 'app_language': appLanguage,
      if (appVersion != null) 'app_version': appVersion,
      if (secretKey != null) 'secret_key': secretKey,
      if (starredPhotos != null) 'starred_photos': starredPhotos,
      if (defaultWidgetImage != null)
        'default_widget_image': defaultWidgetImage,
      if (goal != null) 'goal': goal,
      if (hourOfDay != null) 'hour_of_day': hourOfDay,
      if (minuteOfDay != null) 'minute_of_day': minuteOfDay,
      if (picsTaggedToday != null) 'pics_tagged_today': picsTaggedToday,
      if (tutorialCompleted != null) 'tutorial_completed': tutorialCompleted,
      if (canTagToday != null) 'can_tag_today': canTagToday,
      if (hasGalleryPermission != null)
        'has_gallery_permission': hasGalleryPermission,
      if (loggedIn != null) 'logged_in': loggedIn,
      if (secretPhotos != null) 'secret_photos': secretPhotos,
      if (isPinRegistered != null) 'is_pin_registered': isPinRegistered,
      if (keepAskingToDelete != null)
        'keep_asking_to_delete': keepAskingToDelete,
      if (shouldDeleteOnPrivate != null)
        'should_delete_on_private': shouldDeleteOnPrivate,
      if (tourCompleted != null) 'tour_completed': tourCompleted,
      if (isBiometricActivated != null)
        'is_biometric_activated': isBiometricActivated,
      if (lastTaggedPicDate != null) 'last_tagged_pic_date': lastTaggedPicDate,
    });
  }

  MoorUsersCompanion copyWith(
      {Value<int>? customPrimaryKey,
      Value<String>? id,
      Value<String?>? email,
      Value<String?>? password,
      Value<bool>? notification,
      Value<bool>? dailyChallenges,
      Value<List<String>>? recentTags,
      Value<String?>? appLanguage,
      Value<String?>? appVersion,
      Value<String?>? secretKey,
      Value<Map<String, String>>? starredPhotos,
      Value<String?>? defaultWidgetImage,
      Value<int>? goal,
      Value<int>? hourOfDay,
      Value<int>? minuteOfDay,
      Value<int>? picsTaggedToday,
      Value<bool>? tutorialCompleted,
      Value<bool>? canTagToday,
      Value<bool>? hasGalleryPermission,
      Value<bool>? loggedIn,
      Value<bool>? secretPhotos,
      Value<bool>? isPinRegistered,
      Value<bool>? keepAskingToDelete,
      Value<bool>? shouldDeleteOnPrivate,
      Value<bool>? tourCompleted,
      Value<bool>? isBiometricActivated,
      Value<DateTime>? lastTaggedPicDate}) {
    return MoorUsersCompanion(
      customPrimaryKey: customPrimaryKey ?? this.customPrimaryKey,
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      notification: notification ?? this.notification,
      dailyChallenges: dailyChallenges ?? this.dailyChallenges,
      recentTags: recentTags ?? this.recentTags,
      appLanguage: appLanguage ?? this.appLanguage,
      appVersion: appVersion ?? this.appVersion,
      secretKey: secretKey ?? this.secretKey,
      starredPhotos: starredPhotos ?? this.starredPhotos,
      defaultWidgetImage: defaultWidgetImage ?? this.defaultWidgetImage,
      goal: goal ?? this.goal,
      hourOfDay: hourOfDay ?? this.hourOfDay,
      minuteOfDay: minuteOfDay ?? this.minuteOfDay,
      picsTaggedToday: picsTaggedToday ?? this.picsTaggedToday,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      canTagToday: canTagToday ?? this.canTagToday,
      hasGalleryPermission: hasGalleryPermission ?? this.hasGalleryPermission,
      loggedIn: loggedIn ?? this.loggedIn,
      secretPhotos: secretPhotos ?? this.secretPhotos,
      isPinRegistered: isPinRegistered ?? this.isPinRegistered,
      keepAskingToDelete: keepAskingToDelete ?? this.keepAskingToDelete,
      shouldDeleteOnPrivate:
          shouldDeleteOnPrivate ?? this.shouldDeleteOnPrivate,
      tourCompleted: tourCompleted ?? this.tourCompleted,
      isBiometricActivated: isBiometricActivated ?? this.isBiometricActivated,
      lastTaggedPicDate: lastTaggedPicDate ?? this.lastTaggedPicDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (customPrimaryKey.present) {
      map['custom_primary_key'] = Variable<int>(customPrimaryKey.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String?>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String?>(password.value);
    }
    if (notification.present) {
      map['notification'] = Variable<bool>(notification.value);
    }
    if (dailyChallenges.present) {
      map['daily_challenges'] = Variable<bool>(dailyChallenges.value);
    }
    if (recentTags.present) {
      final converter = $MoorUsersTable.$converter0;
      map['recent_tags'] =
          Variable<String>(converter.mapToSql(recentTags.value)!);
    }
    if (appLanguage.present) {
      map['app_language'] = Variable<String?>(appLanguage.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String?>(appVersion.value);
    }
    if (secretKey.present) {
      map['secret_key'] = Variable<String?>(secretKey.value);
    }
    if (starredPhotos.present) {
      final converter = $MoorUsersTable.$converter1;
      map['starred_photos'] =
          Variable<String>(converter.mapToSql(starredPhotos.value)!);
    }
    if (defaultWidgetImage.present) {
      map['default_widget_image'] = Variable<String?>(defaultWidgetImage.value);
    }
    if (goal.present) {
      map['goal'] = Variable<int>(goal.value);
    }
    if (hourOfDay.present) {
      map['hour_of_day'] = Variable<int>(hourOfDay.value);
    }
    if (minuteOfDay.present) {
      map['minute_of_day'] = Variable<int>(minuteOfDay.value);
    }
    if (picsTaggedToday.present) {
      map['pics_tagged_today'] = Variable<int>(picsTaggedToday.value);
    }
    if (tutorialCompleted.present) {
      map['tutorial_completed'] = Variable<bool>(tutorialCompleted.value);
    }
    if (canTagToday.present) {
      map['can_tag_today'] = Variable<bool>(canTagToday.value);
    }
    if (hasGalleryPermission.present) {
      map['has_gallery_permission'] =
          Variable<bool>(hasGalleryPermission.value);
    }
    if (loggedIn.present) {
      map['logged_in'] = Variable<bool>(loggedIn.value);
    }
    if (secretPhotos.present) {
      map['secret_photos'] = Variable<bool>(secretPhotos.value);
    }
    if (isPinRegistered.present) {
      map['is_pin_registered'] = Variable<bool>(isPinRegistered.value);
    }
    if (keepAskingToDelete.present) {
      map['keep_asking_to_delete'] = Variable<bool>(keepAskingToDelete.value);
    }
    if (shouldDeleteOnPrivate.present) {
      map['should_delete_on_private'] =
          Variable<bool>(shouldDeleteOnPrivate.value);
    }
    if (tourCompleted.present) {
      map['tour_completed'] = Variable<bool>(tourCompleted.value);
    }
    if (isBiometricActivated.present) {
      map['is_biometric_activated'] =
          Variable<bool>(isBiometricActivated.value);
    }
    if (lastTaggedPicDate.present) {
      map['last_tagged_pic_date'] = Variable<DateTime>(lastTaggedPicDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoorUsersCompanion(')
          ..write('customPrimaryKey: $customPrimaryKey, ')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('notification: $notification, ')
          ..write('dailyChallenges: $dailyChallenges, ')
          ..write('recentTags: $recentTags, ')
          ..write('appLanguage: $appLanguage, ')
          ..write('appVersion: $appVersion, ')
          ..write('secretKey: $secretKey, ')
          ..write('starredPhotos: $starredPhotos, ')
          ..write('defaultWidgetImage: $defaultWidgetImage, ')
          ..write('goal: $goal, ')
          ..write('hourOfDay: $hourOfDay, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('picsTaggedToday: $picsTaggedToday, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
          ..write('canTagToday: $canTagToday, ')
          ..write('hasGalleryPermission: $hasGalleryPermission, ')
          ..write('loggedIn: $loggedIn, ')
          ..write('secretPhotos: $secretPhotos, ')
          ..write('isPinRegistered: $isPinRegistered, ')
          ..write('keepAskingToDelete: $keepAskingToDelete, ')
          ..write('shouldDeleteOnPrivate: $shouldDeleteOnPrivate, ')
          ..write('tourCompleted: $tourCompleted, ')
          ..write('isBiometricActivated: $isBiometricActivated, ')
          ..write('lastTaggedPicDate: $lastTaggedPicDate')
          ..write(')'))
        .toString();
  }
}

class $MoorUsersTable extends MoorUsers
    with TableInfo<$MoorUsersTable, MoorUser> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MoorUsersTable(this._db, [this._alias]);
  final VerificationMeta _customPrimaryKeyMeta =
      const VerificationMeta('customPrimaryKey');
  @override
  late final GeneratedIntColumn customPrimaryKey = _constructCustomPrimaryKey();
  GeneratedIntColumn _constructCustomPrimaryKey() {
    return GeneratedIntColumn('custom_primary_key', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedTextColumn id = _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false,
        defaultValue: Constant(Uuid().v4()));
  }

  final VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedTextColumn email = _constructEmail();
  GeneratedTextColumn _constructEmail() {
    return GeneratedTextColumn(
      'email',
      $tableName,
      true,
    );
  }

  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  @override
  late final GeneratedTextColumn password = _constructPassword();
  GeneratedTextColumn _constructPassword() {
    return GeneratedTextColumn(
      'password',
      $tableName,
      true,
    );
  }

  final VerificationMeta _notificationMeta =
      const VerificationMeta('notification');
  @override
  late final GeneratedBoolColumn notification = _constructNotification();
  GeneratedBoolColumn _constructNotification() {
    return GeneratedBoolColumn('notification', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _dailyChallengesMeta =
      const VerificationMeta('dailyChallenges');
  @override
  late final GeneratedBoolColumn dailyChallenges = _constructDailyChallenges();
  GeneratedBoolColumn _constructDailyChallenges() {
    return GeneratedBoolColumn('daily_challenges', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _recentTagsMeta = const VerificationMeta('recentTags');
  @override
  late final GeneratedTextColumn recentTags = _constructRecentTags();
  GeneratedTextColumn _constructRecentTags() {
    return GeneratedTextColumn(
      'recent_tags',
      $tableName,
      false,
    );
  }

  final VerificationMeta _appLanguageMeta =
      const VerificationMeta('appLanguage');
  @override
  late final GeneratedTextColumn appLanguage = _constructAppLanguage();
  GeneratedTextColumn _constructAppLanguage() {
    return GeneratedTextColumn(
      'app_language',
      $tableName,
      true,
    );
  }

  final VerificationMeta _appVersionMeta = const VerificationMeta('appVersion');
  @override
  late final GeneratedTextColumn appVersion = _constructAppVersion();
  GeneratedTextColumn _constructAppVersion() {
    return GeneratedTextColumn(
      'app_version',
      $tableName,
      true,
    );
  }

  final VerificationMeta _secretKeyMeta = const VerificationMeta('secretKey');
  @override
  late final GeneratedTextColumn secretKey = _constructSecretKey();
  GeneratedTextColumn _constructSecretKey() {
    return GeneratedTextColumn(
      'secret_key',
      $tableName,
      true,
    );
  }

  final VerificationMeta _starredPhotosMeta =
      const VerificationMeta('starredPhotos');
  @override
  late final GeneratedTextColumn starredPhotos = _constructStarredPhotos();
  GeneratedTextColumn _constructStarredPhotos() {
    return GeneratedTextColumn(
      'starred_photos',
      $tableName,
      false,
    );
  }

  final VerificationMeta _defaultWidgetImageMeta =
      const VerificationMeta('defaultWidgetImage');
  @override
  late final GeneratedTextColumn defaultWidgetImage =
      _constructDefaultWidgetImage();
  GeneratedTextColumn _constructDefaultWidgetImage() {
    return GeneratedTextColumn(
      'default_widget_image',
      $tableName,
      true,
    );
  }

  final VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedIntColumn goal = _constructGoal();
  GeneratedIntColumn _constructGoal() {
    return GeneratedIntColumn('goal', $tableName, false,
        defaultValue: const Constant(20));
  }

  final VerificationMeta _hourOfDayMeta = const VerificationMeta('hourOfDay');
  @override
  late final GeneratedIntColumn hourOfDay = _constructHourOfDay();
  GeneratedIntColumn _constructHourOfDay() {
    return GeneratedIntColumn('hour_of_day', $tableName, false,
        defaultValue: const Constant(20));
  }

  final VerificationMeta _minuteOfDayMeta =
      const VerificationMeta('minuteOfDay');
  @override
  late final GeneratedIntColumn minuteOfDay = _constructMinuteOfDay();
  GeneratedIntColumn _constructMinuteOfDay() {
    return GeneratedIntColumn('minute_of_day', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _picsTaggedTodayMeta =
      const VerificationMeta('picsTaggedToday');
  @override
  late final GeneratedIntColumn picsTaggedToday = _constructPicsTaggedToday();
  GeneratedIntColumn _constructPicsTaggedToday() {
    return GeneratedIntColumn('pics_tagged_today', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _tutorialCompletedMeta =
      const VerificationMeta('tutorialCompleted');
  @override
  late final GeneratedBoolColumn tutorialCompleted =
      _constructTutorialCompleted();
  GeneratedBoolColumn _constructTutorialCompleted() {
    return GeneratedBoolColumn('tutorial_completed', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _canTagTodayMeta =
      const VerificationMeta('canTagToday');
  @override
  late final GeneratedBoolColumn canTagToday = _constructCanTagToday();
  GeneratedBoolColumn _constructCanTagToday() {
    return GeneratedBoolColumn('can_tag_today', $tableName, false,
        defaultValue: const Constant(true));
  }

  final VerificationMeta _hasGalleryPermissionMeta =
      const VerificationMeta('hasGalleryPermission');
  @override
  late final GeneratedBoolColumn hasGalleryPermission =
      _constructHasGalleryPermission();
  GeneratedBoolColumn _constructHasGalleryPermission() {
    return GeneratedBoolColumn('has_gallery_permission', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _loggedInMeta = const VerificationMeta('loggedIn');
  @override
  late final GeneratedBoolColumn loggedIn = _constructLoggedIn();
  GeneratedBoolColumn _constructLoggedIn() {
    return GeneratedBoolColumn('logged_in', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _secretPhotosMeta =
      const VerificationMeta('secretPhotos');
  @override
  late final GeneratedBoolColumn secretPhotos = _constructSecretPhotos();
  GeneratedBoolColumn _constructSecretPhotos() {
    return GeneratedBoolColumn('secret_photos', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _isPinRegisteredMeta =
      const VerificationMeta('isPinRegistered');
  @override
  late final GeneratedBoolColumn isPinRegistered = _constructIsPinRegistered();
  GeneratedBoolColumn _constructIsPinRegistered() {
    return GeneratedBoolColumn('is_pin_registered', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _keepAskingToDeleteMeta =
      const VerificationMeta('keepAskingToDelete');
  @override
  late final GeneratedBoolColumn keepAskingToDelete =
      _constructKeepAskingToDelete();
  GeneratedBoolColumn _constructKeepAskingToDelete() {
    return GeneratedBoolColumn('keep_asking_to_delete', $tableName, false,
        defaultValue: const Constant(true));
  }

  final VerificationMeta _shouldDeleteOnPrivateMeta =
      const VerificationMeta('shouldDeleteOnPrivate');
  @override
  late final GeneratedBoolColumn shouldDeleteOnPrivate =
      _constructShouldDeleteOnPrivate();
  GeneratedBoolColumn _constructShouldDeleteOnPrivate() {
    return GeneratedBoolColumn('should_delete_on_private', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _tourCompletedMeta =
      const VerificationMeta('tourCompleted');
  @override
  late final GeneratedBoolColumn tourCompleted = _constructTourCompleted();
  GeneratedBoolColumn _constructTourCompleted() {
    return GeneratedBoolColumn('tour_completed', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _isBiometricActivatedMeta =
      const VerificationMeta('isBiometricActivated');
  @override
  late final GeneratedBoolColumn isBiometricActivated =
      _constructIsBiometricActivated();
  GeneratedBoolColumn _constructIsBiometricActivated() {
    return GeneratedBoolColumn('is_biometric_activated', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _lastTaggedPicDateMeta =
      const VerificationMeta('lastTaggedPicDate');
  @override
  late final GeneratedDateTimeColumn lastTaggedPicDate =
      _constructLastTaggedPicDate();
  GeneratedDateTimeColumn _constructLastTaggedPicDate() {
    return GeneratedDateTimeColumn('last_tagged_pic_date', $tableName, false,
        defaultValue: Constant(DateTime.now()));
  }

  @override
  List<GeneratedColumn> get $columns => [
        customPrimaryKey,
        id,
        email,
        password,
        notification,
        dailyChallenges,
        recentTags,
        appLanguage,
        appVersion,
        secretKey,
        starredPhotos,
        defaultWidgetImage,
        goal,
        hourOfDay,
        minuteOfDay,
        picsTaggedToday,
        tutorialCompleted,
        canTagToday,
        hasGalleryPermission,
        loggedIn,
        secretPhotos,
        isPinRegistered,
        keepAskingToDelete,
        shouldDeleteOnPrivate,
        tourCompleted,
        isBiometricActivated,
        lastTaggedPicDate
      ];
  @override
  $MoorUsersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'moor_users';
  @override
  final String actualTableName = 'moor_users';
  @override
  VerificationContext validateIntegrity(Insertable<MoorUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('custom_primary_key')) {
      context.handle(
          _customPrimaryKeyMeta,
          customPrimaryKey.isAcceptableOrUnknown(
              data['custom_primary_key']!, _customPrimaryKeyMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('notification')) {
      context.handle(
          _notificationMeta,
          notification.isAcceptableOrUnknown(
              data['notification']!, _notificationMeta));
    }
    if (data.containsKey('daily_challenges')) {
      context.handle(
          _dailyChallengesMeta,
          dailyChallenges.isAcceptableOrUnknown(
              data['daily_challenges']!, _dailyChallengesMeta));
    }
    context.handle(_recentTagsMeta, const VerificationResult.success());
    if (data.containsKey('app_language')) {
      context.handle(
          _appLanguageMeta,
          appLanguage.isAcceptableOrUnknown(
              data['app_language']!, _appLanguageMeta));
    }
    if (data.containsKey('app_version')) {
      context.handle(
          _appVersionMeta,
          appVersion.isAcceptableOrUnknown(
              data['app_version']!, _appVersionMeta));
    }
    if (data.containsKey('secret_key')) {
      context.handle(_secretKeyMeta,
          secretKey.isAcceptableOrUnknown(data['secret_key']!, _secretKeyMeta));
    }
    context.handle(_starredPhotosMeta, const VerificationResult.success());
    if (data.containsKey('default_widget_image')) {
      context.handle(
          _defaultWidgetImageMeta,
          defaultWidgetImage.isAcceptableOrUnknown(
              data['default_widget_image']!, _defaultWidgetImageMeta));
    }
    if (data.containsKey('goal')) {
      context.handle(
          _goalMeta, goal.isAcceptableOrUnknown(data['goal']!, _goalMeta));
    }
    if (data.containsKey('hour_of_day')) {
      context.handle(
          _hourOfDayMeta,
          hourOfDay.isAcceptableOrUnknown(
              data['hour_of_day']!, _hourOfDayMeta));
    }
    if (data.containsKey('minute_of_day')) {
      context.handle(
          _minuteOfDayMeta,
          minuteOfDay.isAcceptableOrUnknown(
              data['minute_of_day']!, _minuteOfDayMeta));
    }
    if (data.containsKey('pics_tagged_today')) {
      context.handle(
          _picsTaggedTodayMeta,
          picsTaggedToday.isAcceptableOrUnknown(
              data['pics_tagged_today']!, _picsTaggedTodayMeta));
    }
    if (data.containsKey('tutorial_completed')) {
      context.handle(
          _tutorialCompletedMeta,
          tutorialCompleted.isAcceptableOrUnknown(
              data['tutorial_completed']!, _tutorialCompletedMeta));
    }
    if (data.containsKey('can_tag_today')) {
      context.handle(
          _canTagTodayMeta,
          canTagToday.isAcceptableOrUnknown(
              data['can_tag_today']!, _canTagTodayMeta));
    }
    if (data.containsKey('has_gallery_permission')) {
      context.handle(
          _hasGalleryPermissionMeta,
          hasGalleryPermission.isAcceptableOrUnknown(
              data['has_gallery_permission']!, _hasGalleryPermissionMeta));
    }
    if (data.containsKey('logged_in')) {
      context.handle(_loggedInMeta,
          loggedIn.isAcceptableOrUnknown(data['logged_in']!, _loggedInMeta));
    }
    if (data.containsKey('secret_photos')) {
      context.handle(
          _secretPhotosMeta,
          secretPhotos.isAcceptableOrUnknown(
              data['secret_photos']!, _secretPhotosMeta));
    }
    if (data.containsKey('is_pin_registered')) {
      context.handle(
          _isPinRegisteredMeta,
          isPinRegistered.isAcceptableOrUnknown(
              data['is_pin_registered']!, _isPinRegisteredMeta));
    }
    if (data.containsKey('keep_asking_to_delete')) {
      context.handle(
          _keepAskingToDeleteMeta,
          keepAskingToDelete.isAcceptableOrUnknown(
              data['keep_asking_to_delete']!, _keepAskingToDeleteMeta));
    }
    if (data.containsKey('should_delete_on_private')) {
      context.handle(
          _shouldDeleteOnPrivateMeta,
          shouldDeleteOnPrivate.isAcceptableOrUnknown(
              data['should_delete_on_private']!, _shouldDeleteOnPrivateMeta));
    }
    if (data.containsKey('tour_completed')) {
      context.handle(
          _tourCompletedMeta,
          tourCompleted.isAcceptableOrUnknown(
              data['tour_completed']!, _tourCompletedMeta));
    }
    if (data.containsKey('is_biometric_activated')) {
      context.handle(
          _isBiometricActivatedMeta,
          isBiometricActivated.isAcceptableOrUnknown(
              data['is_biometric_activated']!, _isBiometricActivatedMeta));
    }
    if (data.containsKey('last_tagged_pic_date')) {
      context.handle(
          _lastTaggedPicDateMeta,
          lastTaggedPicDate.isAcceptableOrUnknown(
              data['last_tagged_pic_date']!, _lastTaggedPicDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {customPrimaryKey};
  @override
  MoorUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    return MoorUser.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MoorUsersTable createAlias(String alias) {
    return $MoorUsersTable(_db, alias);
  }

  static TypeConverter<List<String>, String> $converter0 =
      ListStringConvertor();
  static TypeConverter<Map<String, String>, String> $converter1 =
      MapStringConvertor();
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $PicBlurHashsTable picBlurHashs = $PicBlurHashsTable(this);
  late final $PrivatesTable privates = $PrivatesTable(this);
  late final $LabelsTable labels = $LabelsTable(this);
  late final $MoorUsersTable moorUsers = $MoorUsersTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [photos, picBlurHashs, privates, labels, moorUsers];
}
