// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Photo extends DataClass implements Insertable<Photo> {
  final String id;
  final DateTime createdAt;
  final double originalLatitude;
  final double originalLongitude;
  final double latitude;
  final double longitude;
  final String specificLocation;
  final String generalLocation;
  final bool isPrivate;
  final bool deletedFromCameraRoll;
  final bool isStarred;
  final String base64encoded;
  Photo(
      {@required this.id,
      @required this.createdAt,
      @required this.originalLatitude,
      @required this.originalLongitude,
      @required this.latitude,
      @required this.longitude,
      @required this.specificLocation,
      @required this.generalLocation,
      @required this.isPrivate,
      @required this.deletedFromCameraRoll,
      @required this.isStarred,
      @required this.base64encoded});
  factory Photo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Photo(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      originalLatitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}original_latitude']),
      originalLongitude: doubleType.mapFromDatabaseResponse(
          data['${effectivePrefix}original_longitude']),
      latitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      longitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
      specificLocation: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}specific_location']),
      generalLocation: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}general_location']),
      isPrivate: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_private']),
      deletedFromCameraRoll: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}deleted_from_camera_roll']),
      isStarred: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_starred']),
      base64encoded: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}base64encoded']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || originalLatitude != null) {
      map['original_latitude'] = Variable<double>(originalLatitude);
    }
    if (!nullToAbsent || originalLongitude != null) {
      map['original_longitude'] = Variable<double>(originalLongitude);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || specificLocation != null) {
      map['specific_location'] = Variable<String>(specificLocation);
    }
    if (!nullToAbsent || generalLocation != null) {
      map['general_location'] = Variable<String>(generalLocation);
    }
    if (!nullToAbsent || isPrivate != null) {
      map['is_private'] = Variable<bool>(isPrivate);
    }
    if (!nullToAbsent || deletedFromCameraRoll != null) {
      map['deleted_from_camera_roll'] = Variable<bool>(deletedFromCameraRoll);
    }
    if (!nullToAbsent || isStarred != null) {
      map['is_starred'] = Variable<bool>(isStarred);
    }
    if (!nullToAbsent || base64encoded != null) {
      map['base64encoded'] = Variable<String>(base64encoded);
    }
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
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
      specificLocation: specificLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(specificLocation),
      generalLocation: generalLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(generalLocation),
      isPrivate: isPrivate == null && nullToAbsent
          ? const Value.absent()
          : Value(isPrivate),
      deletedFromCameraRoll: deletedFromCameraRoll == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedFromCameraRoll),
      isStarred: isStarred == null && nullToAbsent
          ? const Value.absent()
          : Value(isStarred),
      base64encoded: base64encoded == null && nullToAbsent
          ? const Value.absent()
          : Value(base64encoded),
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      originalLatitude: serializer.fromJson<double>(json['originalLatitude']),
      originalLongitude: serializer.fromJson<double>(json['originalLongitude']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      specificLocation: serializer.fromJson<String>(json['specificLocation']),
      generalLocation: serializer.fromJson<String>(json['generalLocation']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      deletedFromCameraRoll:
          serializer.fromJson<bool>(json['deletedFromCameraRoll']),
      isStarred: serializer.fromJson<bool>(json['isStarred']),
      base64encoded: serializer.fromJson<String>(json['base64encoded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'originalLatitude': serializer.toJson<double>(originalLatitude),
      'originalLongitude': serializer.toJson<double>(originalLongitude),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'specificLocation': serializer.toJson<String>(specificLocation),
      'generalLocation': serializer.toJson<String>(generalLocation),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'deletedFromCameraRoll': serializer.toJson<bool>(deletedFromCameraRoll),
      'isStarred': serializer.toJson<bool>(isStarred),
      'base64encoded': serializer.toJson<String>(base64encoded),
    };
  }

  Photo copyWith(
          {String id,
          DateTime createdAt,
          double originalLatitude,
          double originalLongitude,
          double latitude,
          double longitude,
          String specificLocation,
          String generalLocation,
          bool isPrivate,
          bool deletedFromCameraRoll,
          bool isStarred,
          String base64encoded}) =>
      Photo(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        originalLatitude: originalLatitude ?? this.originalLatitude,
        originalLongitude: originalLongitude ?? this.originalLongitude,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        specificLocation: specificLocation ?? this.specificLocation,
        generalLocation: generalLocation ?? this.generalLocation,
        isPrivate: isPrivate ?? this.isPrivate,
        deletedFromCameraRoll:
            deletedFromCameraRoll ?? this.deletedFromCameraRoll,
        isStarred: isStarred ?? this.isStarred,
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
          ..write('specificLocation: $specificLocation, ')
          ..write('generalLocation: $generalLocation, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('deletedFromCameraRoll: $deletedFromCameraRoll, ')
          ..write('isStarred: $isStarred, ')
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
                              specificLocation.hashCode,
                              $mrjc(
                                  generalLocation.hashCode,
                                  $mrjc(
                                      isPrivate.hashCode,
                                      $mrjc(
                                          deletedFromCameraRoll.hashCode,
                                          $mrjc(
                                              isStarred.hashCode,
                                              base64encoded
                                                  .hashCode))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.originalLatitude == this.originalLatitude &&
          other.originalLongitude == this.originalLongitude &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.specificLocation == this.specificLocation &&
          other.generalLocation == this.generalLocation &&
          other.isPrivate == this.isPrivate &&
          other.deletedFromCameraRoll == this.deletedFromCameraRoll &&
          other.isStarred == this.isStarred &&
          other.base64encoded == this.base64encoded);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<double> originalLatitude;
  final Value<double> originalLongitude;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> specificLocation;
  final Value<String> generalLocation;
  final Value<bool> isPrivate;
  final Value<bool> deletedFromCameraRoll;
  final Value<bool> isStarred;
  final Value<String> base64encoded;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.originalLatitude = const Value.absent(),
    this.originalLongitude = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.specificLocation = const Value.absent(),
    this.generalLocation = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.deletedFromCameraRoll = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.base64encoded = const Value.absent(),
  });
  PhotosCompanion.insert({
    @required String id,
    @required DateTime createdAt,
    @required double originalLatitude,
    @required double originalLongitude,
    @required double latitude,
    @required double longitude,
    @required String specificLocation,
    @required String generalLocation,
    @required bool isPrivate,
    @required bool deletedFromCameraRoll,
    @required bool isStarred,
    @required String base64encoded,
  })  : id = Value(id),
        createdAt = Value(createdAt),
        originalLatitude = Value(originalLatitude),
        originalLongitude = Value(originalLongitude),
        latitude = Value(latitude),
        longitude = Value(longitude),
        specificLocation = Value(specificLocation),
        generalLocation = Value(generalLocation),
        isPrivate = Value(isPrivate),
        deletedFromCameraRoll = Value(deletedFromCameraRoll),
        isStarred = Value(isStarred),
        base64encoded = Value(base64encoded);
  static Insertable<Photo> custom({
    Expression<String> id,
    Expression<DateTime> createdAt,
    Expression<double> originalLatitude,
    Expression<double> originalLongitude,
    Expression<double> latitude,
    Expression<double> longitude,
    Expression<String> specificLocation,
    Expression<String> generalLocation,
    Expression<bool> isPrivate,
    Expression<bool> deletedFromCameraRoll,
    Expression<bool> isStarred,
    Expression<String> base64encoded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (originalLatitude != null) 'original_latitude': originalLatitude,
      if (originalLongitude != null) 'original_longitude': originalLongitude,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (specificLocation != null) 'specific_location': specificLocation,
      if (generalLocation != null) 'general_location': generalLocation,
      if (isPrivate != null) 'is_private': isPrivate,
      if (deletedFromCameraRoll != null)
        'deleted_from_camera_roll': deletedFromCameraRoll,
      if (isStarred != null) 'is_starred': isStarred,
      if (base64encoded != null) 'base64encoded': base64encoded,
    });
  }

  PhotosCompanion copyWith(
      {Value<String> id,
      Value<DateTime> createdAt,
      Value<double> originalLatitude,
      Value<double> originalLongitude,
      Value<double> latitude,
      Value<double> longitude,
      Value<String> specificLocation,
      Value<String> generalLocation,
      Value<bool> isPrivate,
      Value<bool> deletedFromCameraRoll,
      Value<bool> isStarred,
      Value<String> base64encoded}) {
    return PhotosCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      originalLatitude: originalLatitude ?? this.originalLatitude,
      originalLongitude: originalLongitude ?? this.originalLongitude,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      specificLocation: specificLocation ?? this.specificLocation,
      generalLocation: generalLocation ?? this.generalLocation,
      isPrivate: isPrivate ?? this.isPrivate,
      deletedFromCameraRoll:
          deletedFromCameraRoll ?? this.deletedFromCameraRoll,
      isStarred: isStarred ?? this.isStarred,
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
      map['original_latitude'] = Variable<double>(originalLatitude.value);
    }
    if (originalLongitude.present) {
      map['original_longitude'] = Variable<double>(originalLongitude.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (specificLocation.present) {
      map['specific_location'] = Variable<String>(specificLocation.value);
    }
    if (generalLocation.present) {
      map['general_location'] = Variable<String>(generalLocation.value);
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
    if (base64encoded.present) {
      map['base64encoded'] = Variable<String>(base64encoded.value);
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
          ..write('specificLocation: $specificLocation, ')
          ..write('generalLocation: $generalLocation, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('deletedFromCameraRoll: $deletedFromCameraRoll, ')
          ..write('isStarred: $isStarred, ')
          ..write('base64encoded: $base64encoded')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  final GeneratedDatabase _db;
  final String _alias;
  $PhotosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _originalLatitudeMeta =
      const VerificationMeta('originalLatitude');
  GeneratedRealColumn _originalLatitude;
  @override
  GeneratedRealColumn get originalLatitude =>
      _originalLatitude ??= _constructOriginalLatitude();
  GeneratedRealColumn _constructOriginalLatitude() {
    return GeneratedRealColumn(
      'original_latitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _originalLongitudeMeta =
      const VerificationMeta('originalLongitude');
  GeneratedRealColumn _originalLongitude;
  @override
  GeneratedRealColumn get originalLongitude =>
      _originalLongitude ??= _constructOriginalLongitude();
  GeneratedRealColumn _constructOriginalLongitude() {
    return GeneratedRealColumn(
      'original_longitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  GeneratedRealColumn _latitude;
  @override
  GeneratedRealColumn get latitude => _latitude ??= _constructLatitude();
  GeneratedRealColumn _constructLatitude() {
    return GeneratedRealColumn(
      'latitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  GeneratedRealColumn _longitude;
  @override
  GeneratedRealColumn get longitude => _longitude ??= _constructLongitude();
  GeneratedRealColumn _constructLongitude() {
    return GeneratedRealColumn(
      'longitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _specificLocationMeta =
      const VerificationMeta('specificLocation');
  GeneratedTextColumn _specificLocation;
  @override
  GeneratedTextColumn get specificLocation =>
      _specificLocation ??= _constructSpecificLocation();
  GeneratedTextColumn _constructSpecificLocation() {
    return GeneratedTextColumn(
      'specific_location',
      $tableName,
      false,
    );
  }

  final VerificationMeta _generalLocationMeta =
      const VerificationMeta('generalLocation');
  GeneratedTextColumn _generalLocation;
  @override
  GeneratedTextColumn get generalLocation =>
      _generalLocation ??= _constructGeneralLocation();
  GeneratedTextColumn _constructGeneralLocation() {
    return GeneratedTextColumn(
      'general_location',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isPrivateMeta = const VerificationMeta('isPrivate');
  GeneratedBoolColumn _isPrivate;
  @override
  GeneratedBoolColumn get isPrivate => _isPrivate ??= _constructIsPrivate();
  GeneratedBoolColumn _constructIsPrivate() {
    return GeneratedBoolColumn(
      'is_private',
      $tableName,
      false,
    );
  }

  final VerificationMeta _deletedFromCameraRollMeta =
      const VerificationMeta('deletedFromCameraRoll');
  GeneratedBoolColumn _deletedFromCameraRoll;
  @override
  GeneratedBoolColumn get deletedFromCameraRoll =>
      _deletedFromCameraRoll ??= _constructDeletedFromCameraRoll();
  GeneratedBoolColumn _constructDeletedFromCameraRoll() {
    return GeneratedBoolColumn(
      'deleted_from_camera_roll',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isStarredMeta = const VerificationMeta('isStarred');
  GeneratedBoolColumn _isStarred;
  @override
  GeneratedBoolColumn get isStarred => _isStarred ??= _constructIsStarred();
  GeneratedBoolColumn _constructIsStarred() {
    return GeneratedBoolColumn(
      'is_starred',
      $tableName,
      false,
    );
  }

  final VerificationMeta _base64encodedMeta =
      const VerificationMeta('base64encoded');
  GeneratedTextColumn _base64encoded;
  @override
  GeneratedTextColumn get base64encoded =>
      _base64encoded ??= _constructBase64encoded();
  GeneratedTextColumn _constructBase64encoded() {
    return GeneratedTextColumn(
      'base64encoded',
      $tableName,
      false,
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
        specificLocation,
        generalLocation,
        isPrivate,
        deletedFromCameraRoll,
        isStarred,
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
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('original_latitude')) {
      context.handle(
          _originalLatitudeMeta,
          originalLatitude.isAcceptableOrUnknown(
              data['original_latitude'], _originalLatitudeMeta));
    } else if (isInserting) {
      context.missing(_originalLatitudeMeta);
    }
    if (data.containsKey('original_longitude')) {
      context.handle(
          _originalLongitudeMeta,
          originalLongitude.isAcceptableOrUnknown(
              data['original_longitude'], _originalLongitudeMeta));
    } else if (isInserting) {
      context.missing(_originalLongitudeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude'], _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude'], _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('specific_location')) {
      context.handle(
          _specificLocationMeta,
          specificLocation.isAcceptableOrUnknown(
              data['specific_location'], _specificLocationMeta));
    } else if (isInserting) {
      context.missing(_specificLocationMeta);
    }
    if (data.containsKey('general_location')) {
      context.handle(
          _generalLocationMeta,
          generalLocation.isAcceptableOrUnknown(
              data['general_location'], _generalLocationMeta));
    } else if (isInserting) {
      context.missing(_generalLocationMeta);
    }
    if (data.containsKey('is_private')) {
      context.handle(_isPrivateMeta,
          isPrivate.isAcceptableOrUnknown(data['is_private'], _isPrivateMeta));
    } else if (isInserting) {
      context.missing(_isPrivateMeta);
    }
    if (data.containsKey('deleted_from_camera_roll')) {
      context.handle(
          _deletedFromCameraRollMeta,
          deletedFromCameraRoll.isAcceptableOrUnknown(
              data['deleted_from_camera_roll'], _deletedFromCameraRollMeta));
    } else if (isInserting) {
      context.missing(_deletedFromCameraRollMeta);
    }
    if (data.containsKey('is_starred')) {
      context.handle(_isStarredMeta,
          isStarred.isAcceptableOrUnknown(data['is_starred'], _isStarredMeta));
    } else if (isInserting) {
      context.missing(_isStarredMeta);
    }
    if (data.containsKey('base64encoded')) {
      context.handle(
          _base64encodedMeta,
          base64encoded.isAcceptableOrUnknown(
              data['base64encoded'], _base64encodedMeta));
    } else if (isInserting) {
      context.missing(_base64encodedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Photo map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Photo.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(_db, alias);
  }
}

class Private extends DataClass implements Insertable<Private> {
  final String id;
  final String path;
  final String thumbPath;
  final DateTime createDateTime;
  final double originalLatitude;
  final double originalLongitude;
  final String nonce;
  Private(
      {@required this.id,
      @required this.path,
      @required this.thumbPath,
      @required this.createDateTime,
      @required this.originalLatitude,
      @required this.originalLongitude,
      @required this.nonce});
  factory Private.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Private(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      path: stringType.mapFromDatabaseResponse(data['${effectivePrefix}path']),
      thumbPath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thumb_path']),
      createDateTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}create_date_time']),
      originalLatitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}original_latitude']),
      originalLongitude: doubleType.mapFromDatabaseResponse(
          data['${effectivePrefix}original_longitude']),
      nonce:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}nonce']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || thumbPath != null) {
      map['thumb_path'] = Variable<String>(thumbPath);
    }
    if (!nullToAbsent || createDateTime != null) {
      map['create_date_time'] = Variable<DateTime>(createDateTime);
    }
    if (!nullToAbsent || originalLatitude != null) {
      map['original_latitude'] = Variable<double>(originalLatitude);
    }
    if (!nullToAbsent || originalLongitude != null) {
      map['original_longitude'] = Variable<double>(originalLongitude);
    }
    if (!nullToAbsent || nonce != null) {
      map['nonce'] = Variable<String>(nonce);
    }
    return map;
  }

  PrivatesCompanion toCompanion(bool nullToAbsent) {
    return PrivatesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
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
      nonce:
          nonce == null && nullToAbsent ? const Value.absent() : Value(nonce),
    );
  }

  factory Private.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Private(
      id: serializer.fromJson<String>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      thumbPath: serializer.fromJson<String>(json['thumbPath']),
      createDateTime: serializer.fromJson<DateTime>(json['createDateTime']),
      originalLatitude: serializer.fromJson<double>(json['originalLatitude']),
      originalLongitude: serializer.fromJson<double>(json['originalLongitude']),
      nonce: serializer.fromJson<String>(json['nonce']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'path': serializer.toJson<String>(path),
      'thumbPath': serializer.toJson<String>(thumbPath),
      'createDateTime': serializer.toJson<DateTime>(createDateTime),
      'originalLatitude': serializer.toJson<double>(originalLatitude),
      'originalLongitude': serializer.toJson<double>(originalLongitude),
      'nonce': serializer.toJson<String>(nonce),
    };
  }

  Private copyWith(
          {String id,
          String path,
          String thumbPath,
          DateTime createDateTime,
          double originalLatitude,
          double originalLongitude,
          String nonce}) =>
      Private(
        id: id ?? this.id,
        path: path ?? this.path,
        thumbPath: thumbPath ?? this.thumbPath,
        createDateTime: createDateTime ?? this.createDateTime,
        originalLatitude: originalLatitude ?? this.originalLatitude,
        originalLongitude: originalLongitude ?? this.originalLongitude,
        nonce: nonce ?? this.nonce,
      );
  @override
  String toString() {
    return (StringBuffer('Private(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('createDateTime: $createDateTime, ')
          ..write('originalLatitude: $originalLatitude, ')
          ..write('originalLongitude: $originalLongitude, ')
          ..write('nonce: $nonce')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          path.hashCode,
          $mrjc(
              thumbPath.hashCode,
              $mrjc(
                  createDateTime.hashCode,
                  $mrjc(originalLatitude.hashCode,
                      $mrjc(originalLongitude.hashCode, nonce.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Private &&
          other.id == this.id &&
          other.path == this.path &&
          other.thumbPath == this.thumbPath &&
          other.createDateTime == this.createDateTime &&
          other.originalLatitude == this.originalLatitude &&
          other.originalLongitude == this.originalLongitude &&
          other.nonce == this.nonce);
}

class PrivatesCompanion extends UpdateCompanion<Private> {
  final Value<String> id;
  final Value<String> path;
  final Value<String> thumbPath;
  final Value<DateTime> createDateTime;
  final Value<double> originalLatitude;
  final Value<double> originalLongitude;
  final Value<String> nonce;
  const PrivatesCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.createDateTime = const Value.absent(),
    this.originalLatitude = const Value.absent(),
    this.originalLongitude = const Value.absent(),
    this.nonce = const Value.absent(),
  });
  PrivatesCompanion.insert({
    @required String id,
    @required String path,
    @required String thumbPath,
    @required DateTime createDateTime,
    @required double originalLatitude,
    @required double originalLongitude,
    @required String nonce,
  })  : id = Value(id),
        path = Value(path),
        thumbPath = Value(thumbPath),
        createDateTime = Value(createDateTime),
        originalLatitude = Value(originalLatitude),
        originalLongitude = Value(originalLongitude),
        nonce = Value(nonce);
  static Insertable<Private> custom({
    Expression<String> id,
    Expression<String> path,
    Expression<String> thumbPath,
    Expression<DateTime> createDateTime,
    Expression<double> originalLatitude,
    Expression<double> originalLongitude,
    Expression<String> nonce,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (thumbPath != null) 'thumb_path': thumbPath,
      if (createDateTime != null) 'create_date_time': createDateTime,
      if (originalLatitude != null) 'original_latitude': originalLatitude,
      if (originalLongitude != null) 'original_longitude': originalLongitude,
      if (nonce != null) 'nonce': nonce,
    });
  }

  PrivatesCompanion copyWith(
      {Value<String> id,
      Value<String> path,
      Value<String> thumbPath,
      Value<DateTime> createDateTime,
      Value<double> originalLatitude,
      Value<double> originalLongitude,
      Value<String> nonce}) {
    return PrivatesCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      thumbPath: thumbPath ?? this.thumbPath,
      createDateTime: createDateTime ?? this.createDateTime,
      originalLatitude: originalLatitude ?? this.originalLatitude,
      originalLongitude: originalLongitude ?? this.originalLongitude,
      nonce: nonce ?? this.nonce,
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
    if (thumbPath.present) {
      map['thumb_path'] = Variable<String>(thumbPath.value);
    }
    if (createDateTime.present) {
      map['create_date_time'] = Variable<DateTime>(createDateTime.value);
    }
    if (originalLatitude.present) {
      map['original_latitude'] = Variable<double>(originalLatitude.value);
    }
    if (originalLongitude.present) {
      map['original_longitude'] = Variable<double>(originalLongitude.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<String>(nonce.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivatesCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('createDateTime: $createDateTime, ')
          ..write('originalLatitude: $originalLatitude, ')
          ..write('originalLongitude: $originalLongitude, ')
          ..write('nonce: $nonce')
          ..write(')'))
        .toString();
  }
}

class $PrivatesTable extends Privates with TableInfo<$PrivatesTable, Private> {
  final GeneratedDatabase _db;
  final String _alias;
  $PrivatesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pathMeta = const VerificationMeta('path');
  GeneratedTextColumn _path;
  @override
  GeneratedTextColumn get path => _path ??= _constructPath();
  GeneratedTextColumn _constructPath() {
    return GeneratedTextColumn(
      'path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _thumbPathMeta = const VerificationMeta('thumbPath');
  GeneratedTextColumn _thumbPath;
  @override
  GeneratedTextColumn get thumbPath => _thumbPath ??= _constructThumbPath();
  GeneratedTextColumn _constructThumbPath() {
    return GeneratedTextColumn(
      'thumb_path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createDateTimeMeta =
      const VerificationMeta('createDateTime');
  GeneratedDateTimeColumn _createDateTime;
  @override
  GeneratedDateTimeColumn get createDateTime =>
      _createDateTime ??= _constructCreateDateTime();
  GeneratedDateTimeColumn _constructCreateDateTime() {
    return GeneratedDateTimeColumn(
      'create_date_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _originalLatitudeMeta =
      const VerificationMeta('originalLatitude');
  GeneratedRealColumn _originalLatitude;
  @override
  GeneratedRealColumn get originalLatitude =>
      _originalLatitude ??= _constructOriginalLatitude();
  GeneratedRealColumn _constructOriginalLatitude() {
    return GeneratedRealColumn(
      'original_latitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _originalLongitudeMeta =
      const VerificationMeta('originalLongitude');
  GeneratedRealColumn _originalLongitude;
  @override
  GeneratedRealColumn get originalLongitude =>
      _originalLongitude ??= _constructOriginalLongitude();
  GeneratedRealColumn _constructOriginalLongitude() {
    return GeneratedRealColumn(
      'original_longitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  GeneratedTextColumn _nonce;
  @override
  GeneratedTextColumn get nonce => _nonce ??= _constructNonce();
  GeneratedTextColumn _constructNonce() {
    return GeneratedTextColumn(
      'nonce',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        path,
        thumbPath,
        createDateTime,
        originalLatitude,
        originalLongitude,
        nonce
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
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path'], _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('thumb_path')) {
      context.handle(_thumbPathMeta,
          thumbPath.isAcceptableOrUnknown(data['thumb_path'], _thumbPathMeta));
    } else if (isInserting) {
      context.missing(_thumbPathMeta);
    }
    if (data.containsKey('create_date_time')) {
      context.handle(
          _createDateTimeMeta,
          createDateTime.isAcceptableOrUnknown(
              data['create_date_time'], _createDateTimeMeta));
    } else if (isInserting) {
      context.missing(_createDateTimeMeta);
    }
    if (data.containsKey('original_latitude')) {
      context.handle(
          _originalLatitudeMeta,
          originalLatitude.isAcceptableOrUnknown(
              data['original_latitude'], _originalLatitudeMeta));
    } else if (isInserting) {
      context.missing(_originalLatitudeMeta);
    }
    if (data.containsKey('original_longitude')) {
      context.handle(
          _originalLongitudeMeta,
          originalLongitude.isAcceptableOrUnknown(
              data['original_longitude'], _originalLongitudeMeta));
    } else if (isInserting) {
      context.missing(_originalLongitudeMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
          _nonceMeta, nonce.isAcceptableOrUnknown(data['nonce'], _nonceMeta));
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Private map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Private.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PrivatesTable createAlias(String alias) {
    return $PrivatesTable(_db, alias);
  }
}

class Label extends DataClass implements Insertable<Label> {
  final String id;
  final String title;
  Label({@required this.id, @required this.title});
  factory Label.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Label(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  LabelsCompanion toCompanion(bool nullToAbsent) {
    return LabelsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory Label.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Label(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  Label copyWith({String id, String title}) => Label(
        id: id ?? this.id,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('Label(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, title.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Label && other.id == this.id && other.title == this.title);
}

class LabelsCompanion extends UpdateCompanion<Label> {
  final Value<String> id;
  final Value<String> title;
  const LabelsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
  });
  LabelsCompanion.insert({
    @required String id,
    @required String title,
  })  : id = Value(id),
        title = Value(title);
  static Insertable<Label> custom({
    Expression<String> id,
    Expression<String> title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
    });
  }

  LabelsCompanion copyWith({Value<String> id, Value<String> title}) {
    return LabelsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $LabelsTable extends Labels with TableInfo<$LabelsTable, Label> {
  final GeneratedDatabase _db;
  final String _alias;
  $LabelsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, title];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Label map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Label.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $LabelsTable createAlias(String alias) {
    return $LabelsTable(_db, alias);
  }
}

class LabelEntry extends DataClass implements Insertable<LabelEntry> {
  final int id;
  final String photo;
  final String label;
  LabelEntry({@required this.id, @required this.photo, @required this.label});
  factory LabelEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return LabelEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      photo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}photo']),
      label:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}label']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  LabelEntriesCompanion toCompanion(bool nullToAbsent) {
    return LabelEntriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
    );
  }

  factory LabelEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LabelEntry(
      id: serializer.fromJson<int>(json['id']),
      photo: serializer.fromJson<String>(json['photo']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'photo': serializer.toJson<String>(photo),
      'label': serializer.toJson<String>(label),
    };
  }

  LabelEntry copyWith({int id, String photo, String label}) => LabelEntry(
        id: id ?? this.id,
        photo: photo ?? this.photo,
        label: label ?? this.label,
      );
  @override
  String toString() {
    return (StringBuffer('LabelEntry(')
          ..write('id: $id, ')
          ..write('photo: $photo, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(photo.hashCode, label.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LabelEntry &&
          other.id == this.id &&
          other.photo == this.photo &&
          other.label == this.label);
}

class LabelEntriesCompanion extends UpdateCompanion<LabelEntry> {
  final Value<int> id;
  final Value<String> photo;
  final Value<String> label;
  const LabelEntriesCompanion({
    this.id = const Value.absent(),
    this.photo = const Value.absent(),
    this.label = const Value.absent(),
  });
  LabelEntriesCompanion.insert({
    this.id = const Value.absent(),
    @required String photo,
    @required String label,
  })  : photo = Value(photo),
        label = Value(label);
  static Insertable<LabelEntry> custom({
    Expression<int> id,
    Expression<String> photo,
    Expression<String> label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (photo != null) 'photo': photo,
      if (label != null) 'label': label,
    });
  }

  LabelEntriesCompanion copyWith(
      {Value<int> id, Value<String> photo, Value<String> label}) {
    return LabelEntriesCompanion(
      id: id ?? this.id,
      photo: photo ?? this.photo,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelEntriesCompanion(')
          ..write('id: $id, ')
          ..write('photo: $photo, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $LabelEntriesTable extends LabelEntries
    with TableInfo<$LabelEntriesTable, LabelEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $LabelEntriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _photoMeta = const VerificationMeta('photo');
  GeneratedTextColumn _photo;
  @override
  GeneratedTextColumn get photo => _photo ??= _constructPhoto();
  GeneratedTextColumn _constructPhoto() {
    return GeneratedTextColumn(
      'photo',
      $tableName,
      false,
    );
  }

  final VerificationMeta _labelMeta = const VerificationMeta('label');
  GeneratedTextColumn _label;
  @override
  GeneratedTextColumn get label => _label ??= _constructLabel();
  GeneratedTextColumn _constructLabel() {
    return GeneratedTextColumn(
      'label',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, photo, label];
  @override
  $LabelEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'label_entries';
  @override
  final String actualTableName = 'label_entries';
  @override
  VerificationContext validateIntegrity(Insertable<LabelEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo'], _photoMeta));
    } else if (isInserting) {
      context.missing(_photoMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label'], _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabelEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LabelEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $LabelEntriesTable createAlias(String alias) {
    return $LabelEntriesTable(_db, alias);
  }
}

class Config extends DataClass implements Insertable<Config> {
  final String id;
  final String email;
  final String password;
  final bool notification;
  final bool dailyChallenge;
  final int goal;
  final int hourOfDay;
  final int minuteOfDay;
  final bool isPremium;
  final bool tutorialCompleted;
  final int picsTaggedToday;
  final DateTime lastTaggedPicDate;
  final bool canTagToday;
  final String appLanguage;
  final String appVersion;
  final bool hasGalleryPermission;
  final bool loggedIn;
  final bool secretPhotos;
  final bool isPinRegistered;
  final bool keepAskingToDelete;
  final bool shouldDeleteOnPrivate;
  final bool tourCompleted;
  final bool isBiometricActivated;
  final String defaultWidgetImage;
  Config(
      {@required this.id,
      @required this.email,
      @required this.password,
      @required this.notification,
      @required this.dailyChallenge,
      @required this.goal,
      @required this.hourOfDay,
      @required this.minuteOfDay,
      @required this.isPremium,
      @required this.tutorialCompleted,
      @required this.picsTaggedToday,
      @required this.lastTaggedPicDate,
      @required this.canTagToday,
      @required this.appLanguage,
      @required this.appVersion,
      @required this.hasGalleryPermission,
      @required this.loggedIn,
      @required this.secretPhotos,
      @required this.isPinRegistered,
      @required this.keepAskingToDelete,
      @required this.shouldDeleteOnPrivate,
      @required this.tourCompleted,
      @required this.isBiometricActivated,
      @required this.defaultWidgetImage});
  factory Config.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Config(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      email:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}email']),
      password: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      notification: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}notification']),
      dailyChallenge: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}daily_challenge']),
      goal: intType.mapFromDatabaseResponse(data['${effectivePrefix}goal']),
      hourOfDay: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}hour_of_day']),
      minuteOfDay: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}minute_of_day']),
      isPremium: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_premium']),
      tutorialCompleted: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}tutorial_completed']),
      picsTaggedToday: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}pics_tagged_today']),
      lastTaggedPicDate: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}last_tagged_pic_date']),
      canTagToday: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}can_tag_today']),
      appLanguage: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}app_language']),
      appVersion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}app_version']),
      hasGalleryPermission: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}has_gallery_permission']),
      loggedIn:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}logged_in']),
      secretPhotos: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}secret_photos']),
      isPinRegistered: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_pin_registered']),
      keepAskingToDelete: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}keep_asking_to_delete']),
      shouldDeleteOnPrivate: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}should_delete_on_private']),
      tourCompleted: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}tour_completed']),
      isBiometricActivated: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}is_biometric_activated']),
      defaultWidgetImage: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}default_widget_image']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || notification != null) {
      map['notification'] = Variable<bool>(notification);
    }
    if (!nullToAbsent || dailyChallenge != null) {
      map['daily_challenge'] = Variable<bool>(dailyChallenge);
    }
    if (!nullToAbsent || goal != null) {
      map['goal'] = Variable<int>(goal);
    }
    if (!nullToAbsent || hourOfDay != null) {
      map['hour_of_day'] = Variable<int>(hourOfDay);
    }
    if (!nullToAbsent || minuteOfDay != null) {
      map['minute_of_day'] = Variable<int>(minuteOfDay);
    }
    if (!nullToAbsent || isPremium != null) {
      map['is_premium'] = Variable<bool>(isPremium);
    }
    if (!nullToAbsent || tutorialCompleted != null) {
      map['tutorial_completed'] = Variable<bool>(tutorialCompleted);
    }
    if (!nullToAbsent || picsTaggedToday != null) {
      map['pics_tagged_today'] = Variable<int>(picsTaggedToday);
    }
    if (!nullToAbsent || lastTaggedPicDate != null) {
      map['last_tagged_pic_date'] = Variable<DateTime>(lastTaggedPicDate);
    }
    if (!nullToAbsent || canTagToday != null) {
      map['can_tag_today'] = Variable<bool>(canTagToday);
    }
    if (!nullToAbsent || appLanguage != null) {
      map['app_language'] = Variable<String>(appLanguage);
    }
    if (!nullToAbsent || appVersion != null) {
      map['app_version'] = Variable<String>(appVersion);
    }
    if (!nullToAbsent || hasGalleryPermission != null) {
      map['has_gallery_permission'] = Variable<bool>(hasGalleryPermission);
    }
    if (!nullToAbsent || loggedIn != null) {
      map['logged_in'] = Variable<bool>(loggedIn);
    }
    if (!nullToAbsent || secretPhotos != null) {
      map['secret_photos'] = Variable<bool>(secretPhotos);
    }
    if (!nullToAbsent || isPinRegistered != null) {
      map['is_pin_registered'] = Variable<bool>(isPinRegistered);
    }
    if (!nullToAbsent || keepAskingToDelete != null) {
      map['keep_asking_to_delete'] = Variable<bool>(keepAskingToDelete);
    }
    if (!nullToAbsent || shouldDeleteOnPrivate != null) {
      map['should_delete_on_private'] = Variable<bool>(shouldDeleteOnPrivate);
    }
    if (!nullToAbsent || tourCompleted != null) {
      map['tour_completed'] = Variable<bool>(tourCompleted);
    }
    if (!nullToAbsent || isBiometricActivated != null) {
      map['is_biometric_activated'] = Variable<bool>(isBiometricActivated);
    }
    if (!nullToAbsent || defaultWidgetImage != null) {
      map['default_widget_image'] = Variable<String>(defaultWidgetImage);
    }
    return map;
  }

  ConfigsCompanion toCompanion(bool nullToAbsent) {
    return ConfigsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      notification: notification == null && nullToAbsent
          ? const Value.absent()
          : Value(notification),
      dailyChallenge: dailyChallenge == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyChallenge),
      goal: goal == null && nullToAbsent ? const Value.absent() : Value(goal),
      hourOfDay: hourOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(hourOfDay),
      minuteOfDay: minuteOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(minuteOfDay),
      isPremium: isPremium == null && nullToAbsent
          ? const Value.absent()
          : Value(isPremium),
      tutorialCompleted: tutorialCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(tutorialCompleted),
      picsTaggedToday: picsTaggedToday == null && nullToAbsent
          ? const Value.absent()
          : Value(picsTaggedToday),
      lastTaggedPicDate: lastTaggedPicDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTaggedPicDate),
      canTagToday: canTagToday == null && nullToAbsent
          ? const Value.absent()
          : Value(canTagToday),
      appLanguage: appLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(appLanguage),
      appVersion: appVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(appVersion),
      hasGalleryPermission: hasGalleryPermission == null && nullToAbsent
          ? const Value.absent()
          : Value(hasGalleryPermission),
      loggedIn: loggedIn == null && nullToAbsent
          ? const Value.absent()
          : Value(loggedIn),
      secretPhotos: secretPhotos == null && nullToAbsent
          ? const Value.absent()
          : Value(secretPhotos),
      isPinRegistered: isPinRegistered == null && nullToAbsent
          ? const Value.absent()
          : Value(isPinRegistered),
      keepAskingToDelete: keepAskingToDelete == null && nullToAbsent
          ? const Value.absent()
          : Value(keepAskingToDelete),
      shouldDeleteOnPrivate: shouldDeleteOnPrivate == null && nullToAbsent
          ? const Value.absent()
          : Value(shouldDeleteOnPrivate),
      tourCompleted: tourCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(tourCompleted),
      isBiometricActivated: isBiometricActivated == null && nullToAbsent
          ? const Value.absent()
          : Value(isBiometricActivated),
      defaultWidgetImage: defaultWidgetImage == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultWidgetImage),
    );
  }

  factory Config.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Config(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      notification: serializer.fromJson<bool>(json['notification']),
      dailyChallenge: serializer.fromJson<bool>(json['dailyChallenge']),
      goal: serializer.fromJson<int>(json['goal']),
      hourOfDay: serializer.fromJson<int>(json['hourOfDay']),
      minuteOfDay: serializer.fromJson<int>(json['minuteOfDay']),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      tutorialCompleted: serializer.fromJson<bool>(json['tutorialCompleted']),
      picsTaggedToday: serializer.fromJson<int>(json['picsTaggedToday']),
      lastTaggedPicDate:
          serializer.fromJson<DateTime>(json['lastTaggedPicDate']),
      canTagToday: serializer.fromJson<bool>(json['canTagToday']),
      appLanguage: serializer.fromJson<String>(json['appLanguage']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
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
      defaultWidgetImage:
          serializer.fromJson<String>(json['defaultWidgetImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'notification': serializer.toJson<bool>(notification),
      'dailyChallenge': serializer.toJson<bool>(dailyChallenge),
      'goal': serializer.toJson<int>(goal),
      'hourOfDay': serializer.toJson<int>(hourOfDay),
      'minuteOfDay': serializer.toJson<int>(minuteOfDay),
      'isPremium': serializer.toJson<bool>(isPremium),
      'tutorialCompleted': serializer.toJson<bool>(tutorialCompleted),
      'picsTaggedToday': serializer.toJson<int>(picsTaggedToday),
      'lastTaggedPicDate': serializer.toJson<DateTime>(lastTaggedPicDate),
      'canTagToday': serializer.toJson<bool>(canTagToday),
      'appLanguage': serializer.toJson<String>(appLanguage),
      'appVersion': serializer.toJson<String>(appVersion),
      'hasGalleryPermission': serializer.toJson<bool>(hasGalleryPermission),
      'loggedIn': serializer.toJson<bool>(loggedIn),
      'secretPhotos': serializer.toJson<bool>(secretPhotos),
      'isPinRegistered': serializer.toJson<bool>(isPinRegistered),
      'keepAskingToDelete': serializer.toJson<bool>(keepAskingToDelete),
      'shouldDeleteOnPrivate': serializer.toJson<bool>(shouldDeleteOnPrivate),
      'tourCompleted': serializer.toJson<bool>(tourCompleted),
      'isBiometricActivated': serializer.toJson<bool>(isBiometricActivated),
      'defaultWidgetImage': serializer.toJson<String>(defaultWidgetImage),
    };
  }

  Config copyWith(
          {String id,
          String email,
          String password,
          bool notification,
          bool dailyChallenge,
          int goal,
          int hourOfDay,
          int minuteOfDay,
          bool isPremium,
          bool tutorialCompleted,
          int picsTaggedToday,
          DateTime lastTaggedPicDate,
          bool canTagToday,
          String appLanguage,
          String appVersion,
          bool hasGalleryPermission,
          bool loggedIn,
          bool secretPhotos,
          bool isPinRegistered,
          bool keepAskingToDelete,
          bool shouldDeleteOnPrivate,
          bool tourCompleted,
          bool isBiometricActivated,
          String defaultWidgetImage}) =>
      Config(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        notification: notification ?? this.notification,
        dailyChallenge: dailyChallenge ?? this.dailyChallenge,
        goal: goal ?? this.goal,
        hourOfDay: hourOfDay ?? this.hourOfDay,
        minuteOfDay: minuteOfDay ?? this.minuteOfDay,
        isPremium: isPremium ?? this.isPremium,
        tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
        picsTaggedToday: picsTaggedToday ?? this.picsTaggedToday,
        lastTaggedPicDate: lastTaggedPicDate ?? this.lastTaggedPicDate,
        canTagToday: canTagToday ?? this.canTagToday,
        appLanguage: appLanguage ?? this.appLanguage,
        appVersion: appVersion ?? this.appVersion,
        hasGalleryPermission: hasGalleryPermission ?? this.hasGalleryPermission,
        loggedIn: loggedIn ?? this.loggedIn,
        secretPhotos: secretPhotos ?? this.secretPhotos,
        isPinRegistered: isPinRegistered ?? this.isPinRegistered,
        keepAskingToDelete: keepAskingToDelete ?? this.keepAskingToDelete,
        shouldDeleteOnPrivate:
            shouldDeleteOnPrivate ?? this.shouldDeleteOnPrivate,
        tourCompleted: tourCompleted ?? this.tourCompleted,
        isBiometricActivated: isBiometricActivated ?? this.isBiometricActivated,
        defaultWidgetImage: defaultWidgetImage ?? this.defaultWidgetImage,
      );
  @override
  String toString() {
    return (StringBuffer('Config(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('notification: $notification, ')
          ..write('dailyChallenge: $dailyChallenge, ')
          ..write('goal: $goal, ')
          ..write('hourOfDay: $hourOfDay, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('isPremium: $isPremium, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
          ..write('picsTaggedToday: $picsTaggedToday, ')
          ..write('lastTaggedPicDate: $lastTaggedPicDate, ')
          ..write('canTagToday: $canTagToday, ')
          ..write('appLanguage: $appLanguage, ')
          ..write('appVersion: $appVersion, ')
          ..write('hasGalleryPermission: $hasGalleryPermission, ')
          ..write('loggedIn: $loggedIn, ')
          ..write('secretPhotos: $secretPhotos, ')
          ..write('isPinRegistered: $isPinRegistered, ')
          ..write('keepAskingToDelete: $keepAskingToDelete, ')
          ..write('shouldDeleteOnPrivate: $shouldDeleteOnPrivate, ')
          ..write('tourCompleted: $tourCompleted, ')
          ..write('isBiometricActivated: $isBiometricActivated, ')
          ..write('defaultWidgetImage: $defaultWidgetImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          email.hashCode,
          $mrjc(
              password.hashCode,
              $mrjc(
                  notification.hashCode,
                  $mrjc(
                      dailyChallenge.hashCode,
                      $mrjc(
                          goal.hashCode,
                          $mrjc(
                              hourOfDay.hashCode,
                              $mrjc(
                                  minuteOfDay.hashCode,
                                  $mrjc(
                                      isPremium.hashCode,
                                      $mrjc(
                                          tutorialCompleted.hashCode,
                                          $mrjc(
                                              picsTaggedToday.hashCode,
                                              $mrjc(
                                                  lastTaggedPicDate.hashCode,
                                                  $mrjc(
                                                      canTagToday.hashCode,
                                                      $mrjc(
                                                          appLanguage.hashCode,
                                                          $mrjc(
                                                              appVersion
                                                                  .hashCode,
                                                              $mrjc(
                                                                  hasGalleryPermission
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      loggedIn
                                                                          .hashCode,
                                                                      $mrjc(
                                                                          secretPhotos
                                                                              .hashCode,
                                                                          $mrjc(
                                                                              isPinRegistered.hashCode,
                                                                              $mrjc(keepAskingToDelete.hashCode, $mrjc(shouldDeleteOnPrivate.hashCode, $mrjc(tourCompleted.hashCode, $mrjc(isBiometricActivated.hashCode, defaultWidgetImage.hashCode))))))))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Config &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.notification == this.notification &&
          other.dailyChallenge == this.dailyChallenge &&
          other.goal == this.goal &&
          other.hourOfDay == this.hourOfDay &&
          other.minuteOfDay == this.minuteOfDay &&
          other.isPremium == this.isPremium &&
          other.tutorialCompleted == this.tutorialCompleted &&
          other.picsTaggedToday == this.picsTaggedToday &&
          other.lastTaggedPicDate == this.lastTaggedPicDate &&
          other.canTagToday == this.canTagToday &&
          other.appLanguage == this.appLanguage &&
          other.appVersion == this.appVersion &&
          other.hasGalleryPermission == this.hasGalleryPermission &&
          other.loggedIn == this.loggedIn &&
          other.secretPhotos == this.secretPhotos &&
          other.isPinRegistered == this.isPinRegistered &&
          other.keepAskingToDelete == this.keepAskingToDelete &&
          other.shouldDeleteOnPrivate == this.shouldDeleteOnPrivate &&
          other.tourCompleted == this.tourCompleted &&
          other.isBiometricActivated == this.isBiometricActivated &&
          other.defaultWidgetImage == this.defaultWidgetImage);
}

class ConfigsCompanion extends UpdateCompanion<Config> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> password;
  final Value<bool> notification;
  final Value<bool> dailyChallenge;
  final Value<int> goal;
  final Value<int> hourOfDay;
  final Value<int> minuteOfDay;
  final Value<bool> isPremium;
  final Value<bool> tutorialCompleted;
  final Value<int> picsTaggedToday;
  final Value<DateTime> lastTaggedPicDate;
  final Value<bool> canTagToday;
  final Value<String> appLanguage;
  final Value<String> appVersion;
  final Value<bool> hasGalleryPermission;
  final Value<bool> loggedIn;
  final Value<bool> secretPhotos;
  final Value<bool> isPinRegistered;
  final Value<bool> keepAskingToDelete;
  final Value<bool> shouldDeleteOnPrivate;
  final Value<bool> tourCompleted;
  final Value<bool> isBiometricActivated;
  final Value<String> defaultWidgetImage;
  const ConfigsCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.notification = const Value.absent(),
    this.dailyChallenge = const Value.absent(),
    this.goal = const Value.absent(),
    this.hourOfDay = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
    this.picsTaggedToday = const Value.absent(),
    this.lastTaggedPicDate = const Value.absent(),
    this.canTagToday = const Value.absent(),
    this.appLanguage = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.hasGalleryPermission = const Value.absent(),
    this.loggedIn = const Value.absent(),
    this.secretPhotos = const Value.absent(),
    this.isPinRegistered = const Value.absent(),
    this.keepAskingToDelete = const Value.absent(),
    this.shouldDeleteOnPrivate = const Value.absent(),
    this.tourCompleted = const Value.absent(),
    this.isBiometricActivated = const Value.absent(),
    this.defaultWidgetImage = const Value.absent(),
  });
  ConfigsCompanion.insert({
    @required String id,
    @required String email,
    @required String password,
    @required bool notification,
    @required bool dailyChallenge,
    @required int goal,
    @required int hourOfDay,
    @required int minuteOfDay,
    @required bool isPremium,
    @required bool tutorialCompleted,
    @required int picsTaggedToday,
    @required DateTime lastTaggedPicDate,
    @required bool canTagToday,
    @required String appLanguage,
    @required String appVersion,
    @required bool hasGalleryPermission,
    @required bool loggedIn,
    @required bool secretPhotos,
    @required bool isPinRegistered,
    @required bool keepAskingToDelete,
    @required bool shouldDeleteOnPrivate,
    @required bool tourCompleted,
    @required bool isBiometricActivated,
    @required String defaultWidgetImage,
  })  : id = Value(id),
        email = Value(email),
        password = Value(password),
        notification = Value(notification),
        dailyChallenge = Value(dailyChallenge),
        goal = Value(goal),
        hourOfDay = Value(hourOfDay),
        minuteOfDay = Value(minuteOfDay),
        isPremium = Value(isPremium),
        tutorialCompleted = Value(tutorialCompleted),
        picsTaggedToday = Value(picsTaggedToday),
        lastTaggedPicDate = Value(lastTaggedPicDate),
        canTagToday = Value(canTagToday),
        appLanguage = Value(appLanguage),
        appVersion = Value(appVersion),
        hasGalleryPermission = Value(hasGalleryPermission),
        loggedIn = Value(loggedIn),
        secretPhotos = Value(secretPhotos),
        isPinRegistered = Value(isPinRegistered),
        keepAskingToDelete = Value(keepAskingToDelete),
        shouldDeleteOnPrivate = Value(shouldDeleteOnPrivate),
        tourCompleted = Value(tourCompleted),
        isBiometricActivated = Value(isBiometricActivated),
        defaultWidgetImage = Value(defaultWidgetImage);
  static Insertable<Config> custom({
    Expression<String> id,
    Expression<String> email,
    Expression<String> password,
    Expression<bool> notification,
    Expression<bool> dailyChallenge,
    Expression<int> goal,
    Expression<int> hourOfDay,
    Expression<int> minuteOfDay,
    Expression<bool> isPremium,
    Expression<bool> tutorialCompleted,
    Expression<int> picsTaggedToday,
    Expression<DateTime> lastTaggedPicDate,
    Expression<bool> canTagToday,
    Expression<String> appLanguage,
    Expression<String> appVersion,
    Expression<bool> hasGalleryPermission,
    Expression<bool> loggedIn,
    Expression<bool> secretPhotos,
    Expression<bool> isPinRegistered,
    Expression<bool> keepAskingToDelete,
    Expression<bool> shouldDeleteOnPrivate,
    Expression<bool> tourCompleted,
    Expression<bool> isBiometricActivated,
    Expression<String> defaultWidgetImage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (notification != null) 'notification': notification,
      if (dailyChallenge != null) 'daily_challenge': dailyChallenge,
      if (goal != null) 'goal': goal,
      if (hourOfDay != null) 'hour_of_day': hourOfDay,
      if (minuteOfDay != null) 'minute_of_day': minuteOfDay,
      if (isPremium != null) 'is_premium': isPremium,
      if (tutorialCompleted != null) 'tutorial_completed': tutorialCompleted,
      if (picsTaggedToday != null) 'pics_tagged_today': picsTaggedToday,
      if (lastTaggedPicDate != null) 'last_tagged_pic_date': lastTaggedPicDate,
      if (canTagToday != null) 'can_tag_today': canTagToday,
      if (appLanguage != null) 'app_language': appLanguage,
      if (appVersion != null) 'app_version': appVersion,
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
      if (defaultWidgetImage != null)
        'default_widget_image': defaultWidgetImage,
    });
  }

  ConfigsCompanion copyWith(
      {Value<String> id,
      Value<String> email,
      Value<String> password,
      Value<bool> notification,
      Value<bool> dailyChallenge,
      Value<int> goal,
      Value<int> hourOfDay,
      Value<int> minuteOfDay,
      Value<bool> isPremium,
      Value<bool> tutorialCompleted,
      Value<int> picsTaggedToday,
      Value<DateTime> lastTaggedPicDate,
      Value<bool> canTagToday,
      Value<String> appLanguage,
      Value<String> appVersion,
      Value<bool> hasGalleryPermission,
      Value<bool> loggedIn,
      Value<bool> secretPhotos,
      Value<bool> isPinRegistered,
      Value<bool> keepAskingToDelete,
      Value<bool> shouldDeleteOnPrivate,
      Value<bool> tourCompleted,
      Value<bool> isBiometricActivated,
      Value<String> defaultWidgetImage}) {
    return ConfigsCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      notification: notification ?? this.notification,
      dailyChallenge: dailyChallenge ?? this.dailyChallenge,
      goal: goal ?? this.goal,
      hourOfDay: hourOfDay ?? this.hourOfDay,
      minuteOfDay: minuteOfDay ?? this.minuteOfDay,
      isPremium: isPremium ?? this.isPremium,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      picsTaggedToday: picsTaggedToday ?? this.picsTaggedToday,
      lastTaggedPicDate: lastTaggedPicDate ?? this.lastTaggedPicDate,
      canTagToday: canTagToday ?? this.canTagToday,
      appLanguage: appLanguage ?? this.appLanguage,
      appVersion: appVersion ?? this.appVersion,
      hasGalleryPermission: hasGalleryPermission ?? this.hasGalleryPermission,
      loggedIn: loggedIn ?? this.loggedIn,
      secretPhotos: secretPhotos ?? this.secretPhotos,
      isPinRegistered: isPinRegistered ?? this.isPinRegistered,
      keepAskingToDelete: keepAskingToDelete ?? this.keepAskingToDelete,
      shouldDeleteOnPrivate:
          shouldDeleteOnPrivate ?? this.shouldDeleteOnPrivate,
      tourCompleted: tourCompleted ?? this.tourCompleted,
      isBiometricActivated: isBiometricActivated ?? this.isBiometricActivated,
      defaultWidgetImage: defaultWidgetImage ?? this.defaultWidgetImage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (notification.present) {
      map['notification'] = Variable<bool>(notification.value);
    }
    if (dailyChallenge.present) {
      map['daily_challenge'] = Variable<bool>(dailyChallenge.value);
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
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (tutorialCompleted.present) {
      map['tutorial_completed'] = Variable<bool>(tutorialCompleted.value);
    }
    if (picsTaggedToday.present) {
      map['pics_tagged_today'] = Variable<int>(picsTaggedToday.value);
    }
    if (lastTaggedPicDate.present) {
      map['last_tagged_pic_date'] = Variable<DateTime>(lastTaggedPicDate.value);
    }
    if (canTagToday.present) {
      map['can_tag_today'] = Variable<bool>(canTagToday.value);
    }
    if (appLanguage.present) {
      map['app_language'] = Variable<String>(appLanguage.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
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
    if (defaultWidgetImage.present) {
      map['default_widget_image'] = Variable<String>(defaultWidgetImage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigsCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('notification: $notification, ')
          ..write('dailyChallenge: $dailyChallenge, ')
          ..write('goal: $goal, ')
          ..write('hourOfDay: $hourOfDay, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('isPremium: $isPremium, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
          ..write('picsTaggedToday: $picsTaggedToday, ')
          ..write('lastTaggedPicDate: $lastTaggedPicDate, ')
          ..write('canTagToday: $canTagToday, ')
          ..write('appLanguage: $appLanguage, ')
          ..write('appVersion: $appVersion, ')
          ..write('hasGalleryPermission: $hasGalleryPermission, ')
          ..write('loggedIn: $loggedIn, ')
          ..write('secretPhotos: $secretPhotos, ')
          ..write('isPinRegistered: $isPinRegistered, ')
          ..write('keepAskingToDelete: $keepAskingToDelete, ')
          ..write('shouldDeleteOnPrivate: $shouldDeleteOnPrivate, ')
          ..write('tourCompleted: $tourCompleted, ')
          ..write('isBiometricActivated: $isBiometricActivated, ')
          ..write('defaultWidgetImage: $defaultWidgetImage')
          ..write(')'))
        .toString();
  }
}

class $ConfigsTable extends Configs with TableInfo<$ConfigsTable, Config> {
  final GeneratedDatabase _db;
  final String _alias;
  $ConfigsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _emailMeta = const VerificationMeta('email');
  GeneratedTextColumn _email;
  @override
  GeneratedTextColumn get email => _email ??= _constructEmail();
  GeneratedTextColumn _constructEmail() {
    return GeneratedTextColumn(
      'email',
      $tableName,
      false,
    );
  }

  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  GeneratedTextColumn _password;
  @override
  GeneratedTextColumn get password => _password ??= _constructPassword();
  GeneratedTextColumn _constructPassword() {
    return GeneratedTextColumn(
      'password',
      $tableName,
      false,
    );
  }

  final VerificationMeta _notificationMeta =
      const VerificationMeta('notification');
  GeneratedBoolColumn _notification;
  @override
  GeneratedBoolColumn get notification =>
      _notification ??= _constructNotification();
  GeneratedBoolColumn _constructNotification() {
    return GeneratedBoolColumn(
      'notification',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dailyChallengeMeta =
      const VerificationMeta('dailyChallenge');
  GeneratedBoolColumn _dailyChallenge;
  @override
  GeneratedBoolColumn get dailyChallenge =>
      _dailyChallenge ??= _constructDailyChallenge();
  GeneratedBoolColumn _constructDailyChallenge() {
    return GeneratedBoolColumn(
      'daily_challenge',
      $tableName,
      false,
    );
  }

  final VerificationMeta _goalMeta = const VerificationMeta('goal');
  GeneratedIntColumn _goal;
  @override
  GeneratedIntColumn get goal => _goal ??= _constructGoal();
  GeneratedIntColumn _constructGoal() {
    return GeneratedIntColumn(
      'goal',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hourOfDayMeta = const VerificationMeta('hourOfDay');
  GeneratedIntColumn _hourOfDay;
  @override
  GeneratedIntColumn get hourOfDay => _hourOfDay ??= _constructHourOfDay();
  GeneratedIntColumn _constructHourOfDay() {
    return GeneratedIntColumn(
      'hour_of_day',
      $tableName,
      false,
    );
  }

  final VerificationMeta _minuteOfDayMeta =
      const VerificationMeta('minuteOfDay');
  GeneratedIntColumn _minuteOfDay;
  @override
  GeneratedIntColumn get minuteOfDay =>
      _minuteOfDay ??= _constructMinuteOfDay();
  GeneratedIntColumn _constructMinuteOfDay() {
    return GeneratedIntColumn(
      'minute_of_day',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isPremiumMeta = const VerificationMeta('isPremium');
  GeneratedBoolColumn _isPremium;
  @override
  GeneratedBoolColumn get isPremium => _isPremium ??= _constructIsPremium();
  GeneratedBoolColumn _constructIsPremium() {
    return GeneratedBoolColumn(
      'is_premium',
      $tableName,
      false,
    );
  }

  final VerificationMeta _tutorialCompletedMeta =
      const VerificationMeta('tutorialCompleted');
  GeneratedBoolColumn _tutorialCompleted;
  @override
  GeneratedBoolColumn get tutorialCompleted =>
      _tutorialCompleted ??= _constructTutorialCompleted();
  GeneratedBoolColumn _constructTutorialCompleted() {
    return GeneratedBoolColumn(
      'tutorial_completed',
      $tableName,
      false,
    );
  }

  final VerificationMeta _picsTaggedTodayMeta =
      const VerificationMeta('picsTaggedToday');
  GeneratedIntColumn _picsTaggedToday;
  @override
  GeneratedIntColumn get picsTaggedToday =>
      _picsTaggedToday ??= _constructPicsTaggedToday();
  GeneratedIntColumn _constructPicsTaggedToday() {
    return GeneratedIntColumn(
      'pics_tagged_today',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastTaggedPicDateMeta =
      const VerificationMeta('lastTaggedPicDate');
  GeneratedDateTimeColumn _lastTaggedPicDate;
  @override
  GeneratedDateTimeColumn get lastTaggedPicDate =>
      _lastTaggedPicDate ??= _constructLastTaggedPicDate();
  GeneratedDateTimeColumn _constructLastTaggedPicDate() {
    return GeneratedDateTimeColumn(
      'last_tagged_pic_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _canTagTodayMeta =
      const VerificationMeta('canTagToday');
  GeneratedBoolColumn _canTagToday;
  @override
  GeneratedBoolColumn get canTagToday =>
      _canTagToday ??= _constructCanTagToday();
  GeneratedBoolColumn _constructCanTagToday() {
    return GeneratedBoolColumn(
      'can_tag_today',
      $tableName,
      false,
    );
  }

  final VerificationMeta _appLanguageMeta =
      const VerificationMeta('appLanguage');
  GeneratedTextColumn _appLanguage;
  @override
  GeneratedTextColumn get appLanguage =>
      _appLanguage ??= _constructAppLanguage();
  GeneratedTextColumn _constructAppLanguage() {
    return GeneratedTextColumn(
      'app_language',
      $tableName,
      false,
    );
  }

  final VerificationMeta _appVersionMeta = const VerificationMeta('appVersion');
  GeneratedTextColumn _appVersion;
  @override
  GeneratedTextColumn get appVersion => _appVersion ??= _constructAppVersion();
  GeneratedTextColumn _constructAppVersion() {
    return GeneratedTextColumn(
      'app_version',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hasGalleryPermissionMeta =
      const VerificationMeta('hasGalleryPermission');
  GeneratedBoolColumn _hasGalleryPermission;
  @override
  GeneratedBoolColumn get hasGalleryPermission =>
      _hasGalleryPermission ??= _constructHasGalleryPermission();
  GeneratedBoolColumn _constructHasGalleryPermission() {
    return GeneratedBoolColumn(
      'has_gallery_permission',
      $tableName,
      false,
    );
  }

  final VerificationMeta _loggedInMeta = const VerificationMeta('loggedIn');
  GeneratedBoolColumn _loggedIn;
  @override
  GeneratedBoolColumn get loggedIn => _loggedIn ??= _constructLoggedIn();
  GeneratedBoolColumn _constructLoggedIn() {
    return GeneratedBoolColumn(
      'logged_in',
      $tableName,
      false,
    );
  }

  final VerificationMeta _secretPhotosMeta =
      const VerificationMeta('secretPhotos');
  GeneratedBoolColumn _secretPhotos;
  @override
  GeneratedBoolColumn get secretPhotos =>
      _secretPhotos ??= _constructSecretPhotos();
  GeneratedBoolColumn _constructSecretPhotos() {
    return GeneratedBoolColumn(
      'secret_photos',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isPinRegisteredMeta =
      const VerificationMeta('isPinRegistered');
  GeneratedBoolColumn _isPinRegistered;
  @override
  GeneratedBoolColumn get isPinRegistered =>
      _isPinRegistered ??= _constructIsPinRegistered();
  GeneratedBoolColumn _constructIsPinRegistered() {
    return GeneratedBoolColumn(
      'is_pin_registered',
      $tableName,
      false,
    );
  }

  final VerificationMeta _keepAskingToDeleteMeta =
      const VerificationMeta('keepAskingToDelete');
  GeneratedBoolColumn _keepAskingToDelete;
  @override
  GeneratedBoolColumn get keepAskingToDelete =>
      _keepAskingToDelete ??= _constructKeepAskingToDelete();
  GeneratedBoolColumn _constructKeepAskingToDelete() {
    return GeneratedBoolColumn(
      'keep_asking_to_delete',
      $tableName,
      false,
    );
  }

  final VerificationMeta _shouldDeleteOnPrivateMeta =
      const VerificationMeta('shouldDeleteOnPrivate');
  GeneratedBoolColumn _shouldDeleteOnPrivate;
  @override
  GeneratedBoolColumn get shouldDeleteOnPrivate =>
      _shouldDeleteOnPrivate ??= _constructShouldDeleteOnPrivate();
  GeneratedBoolColumn _constructShouldDeleteOnPrivate() {
    return GeneratedBoolColumn(
      'should_delete_on_private',
      $tableName,
      false,
    );
  }

  final VerificationMeta _tourCompletedMeta =
      const VerificationMeta('tourCompleted');
  GeneratedBoolColumn _tourCompleted;
  @override
  GeneratedBoolColumn get tourCompleted =>
      _tourCompleted ??= _constructTourCompleted();
  GeneratedBoolColumn _constructTourCompleted() {
    return GeneratedBoolColumn(
      'tour_completed',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isBiometricActivatedMeta =
      const VerificationMeta('isBiometricActivated');
  GeneratedBoolColumn _isBiometricActivated;
  @override
  GeneratedBoolColumn get isBiometricActivated =>
      _isBiometricActivated ??= _constructIsBiometricActivated();
  GeneratedBoolColumn _constructIsBiometricActivated() {
    return GeneratedBoolColumn(
      'is_biometric_activated',
      $tableName,
      false,
    );
  }

  final VerificationMeta _defaultWidgetImageMeta =
      const VerificationMeta('defaultWidgetImage');
  GeneratedTextColumn _defaultWidgetImage;
  @override
  GeneratedTextColumn get defaultWidgetImage =>
      _defaultWidgetImage ??= _constructDefaultWidgetImage();
  GeneratedTextColumn _constructDefaultWidgetImage() {
    return GeneratedTextColumn(
      'default_widget_image',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        email,
        password,
        notification,
        dailyChallenge,
        goal,
        hourOfDay,
        minuteOfDay,
        isPremium,
        tutorialCompleted,
        picsTaggedToday,
        lastTaggedPicDate,
        canTagToday,
        appLanguage,
        appVersion,
        hasGalleryPermission,
        loggedIn,
        secretPhotos,
        isPinRegistered,
        keepAskingToDelete,
        shouldDeleteOnPrivate,
        tourCompleted,
        isBiometricActivated,
        defaultWidgetImage
      ];
  @override
  $ConfigsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'configs';
  @override
  final String actualTableName = 'configs';
  @override
  VerificationContext validateIntegrity(Insertable<Config> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email'], _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password'], _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('notification')) {
      context.handle(
          _notificationMeta,
          notification.isAcceptableOrUnknown(
              data['notification'], _notificationMeta));
    } else if (isInserting) {
      context.missing(_notificationMeta);
    }
    if (data.containsKey('daily_challenge')) {
      context.handle(
          _dailyChallengeMeta,
          dailyChallenge.isAcceptableOrUnknown(
              data['daily_challenge'], _dailyChallengeMeta));
    } else if (isInserting) {
      context.missing(_dailyChallengeMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
          _goalMeta, goal.isAcceptableOrUnknown(data['goal'], _goalMeta));
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('hour_of_day')) {
      context.handle(_hourOfDayMeta,
          hourOfDay.isAcceptableOrUnknown(data['hour_of_day'], _hourOfDayMeta));
    } else if (isInserting) {
      context.missing(_hourOfDayMeta);
    }
    if (data.containsKey('minute_of_day')) {
      context.handle(
          _minuteOfDayMeta,
          minuteOfDay.isAcceptableOrUnknown(
              data['minute_of_day'], _minuteOfDayMeta));
    } else if (isInserting) {
      context.missing(_minuteOfDayMeta);
    }
    if (data.containsKey('is_premium')) {
      context.handle(_isPremiumMeta,
          isPremium.isAcceptableOrUnknown(data['is_premium'], _isPremiumMeta));
    } else if (isInserting) {
      context.missing(_isPremiumMeta);
    }
    if (data.containsKey('tutorial_completed')) {
      context.handle(
          _tutorialCompletedMeta,
          tutorialCompleted.isAcceptableOrUnknown(
              data['tutorial_completed'], _tutorialCompletedMeta));
    } else if (isInserting) {
      context.missing(_tutorialCompletedMeta);
    }
    if (data.containsKey('pics_tagged_today')) {
      context.handle(
          _picsTaggedTodayMeta,
          picsTaggedToday.isAcceptableOrUnknown(
              data['pics_tagged_today'], _picsTaggedTodayMeta));
    } else if (isInserting) {
      context.missing(_picsTaggedTodayMeta);
    }
    if (data.containsKey('last_tagged_pic_date')) {
      context.handle(
          _lastTaggedPicDateMeta,
          lastTaggedPicDate.isAcceptableOrUnknown(
              data['last_tagged_pic_date'], _lastTaggedPicDateMeta));
    } else if (isInserting) {
      context.missing(_lastTaggedPicDateMeta);
    }
    if (data.containsKey('can_tag_today')) {
      context.handle(
          _canTagTodayMeta,
          canTagToday.isAcceptableOrUnknown(
              data['can_tag_today'], _canTagTodayMeta));
    } else if (isInserting) {
      context.missing(_canTagTodayMeta);
    }
    if (data.containsKey('app_language')) {
      context.handle(
          _appLanguageMeta,
          appLanguage.isAcceptableOrUnknown(
              data['app_language'], _appLanguageMeta));
    } else if (isInserting) {
      context.missing(_appLanguageMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
          _appVersionMeta,
          appVersion.isAcceptableOrUnknown(
              data['app_version'], _appVersionMeta));
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('has_gallery_permission')) {
      context.handle(
          _hasGalleryPermissionMeta,
          hasGalleryPermission.isAcceptableOrUnknown(
              data['has_gallery_permission'], _hasGalleryPermissionMeta));
    } else if (isInserting) {
      context.missing(_hasGalleryPermissionMeta);
    }
    if (data.containsKey('logged_in')) {
      context.handle(_loggedInMeta,
          loggedIn.isAcceptableOrUnknown(data['logged_in'], _loggedInMeta));
    } else if (isInserting) {
      context.missing(_loggedInMeta);
    }
    if (data.containsKey('secret_photos')) {
      context.handle(
          _secretPhotosMeta,
          secretPhotos.isAcceptableOrUnknown(
              data['secret_photos'], _secretPhotosMeta));
    } else if (isInserting) {
      context.missing(_secretPhotosMeta);
    }
    if (data.containsKey('is_pin_registered')) {
      context.handle(
          _isPinRegisteredMeta,
          isPinRegistered.isAcceptableOrUnknown(
              data['is_pin_registered'], _isPinRegisteredMeta));
    } else if (isInserting) {
      context.missing(_isPinRegisteredMeta);
    }
    if (data.containsKey('keep_asking_to_delete')) {
      context.handle(
          _keepAskingToDeleteMeta,
          keepAskingToDelete.isAcceptableOrUnknown(
              data['keep_asking_to_delete'], _keepAskingToDeleteMeta));
    } else if (isInserting) {
      context.missing(_keepAskingToDeleteMeta);
    }
    if (data.containsKey('should_delete_on_private')) {
      context.handle(
          _shouldDeleteOnPrivateMeta,
          shouldDeleteOnPrivate.isAcceptableOrUnknown(
              data['should_delete_on_private'], _shouldDeleteOnPrivateMeta));
    } else if (isInserting) {
      context.missing(_shouldDeleteOnPrivateMeta);
    }
    if (data.containsKey('tour_completed')) {
      context.handle(
          _tourCompletedMeta,
          tourCompleted.isAcceptableOrUnknown(
              data['tour_completed'], _tourCompletedMeta));
    } else if (isInserting) {
      context.missing(_tourCompletedMeta);
    }
    if (data.containsKey('is_biometric_activated')) {
      context.handle(
          _isBiometricActivatedMeta,
          isBiometricActivated.isAcceptableOrUnknown(
              data['is_biometric_activated'], _isBiometricActivatedMeta));
    } else if (isInserting) {
      context.missing(_isBiometricActivatedMeta);
    }
    if (data.containsKey('default_widget_image')) {
      context.handle(
          _defaultWidgetImageMeta,
          defaultWidgetImage.isAcceptableOrUnknown(
              data['default_widget_image'], _defaultWidgetImageMeta));
    } else if (isInserting) {
      context.missing(_defaultWidgetImageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Config map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Config.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ConfigsTable createAlias(String alias) {
    return $ConfigsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PhotosTable _photos;
  $PhotosTable get photos => _photos ??= $PhotosTable(this);
  $PrivatesTable _privates;
  $PrivatesTable get privates => _privates ??= $PrivatesTable(this);
  $LabelsTable _labels;
  $LabelsTable get labels => _labels ??= $LabelsTable(this);
  $LabelEntriesTable _labelEntries;
  $LabelEntriesTable get labelEntries =>
      _labelEntries ??= $LabelEntriesTable(this);
  $ConfigsTable _configs;
  $ConfigsTable get configs => _configs ??= $ConfigsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [photos, privates, labels, labelEntries, configs];
}
