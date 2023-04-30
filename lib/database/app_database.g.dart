// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _originalLatitudeMeta =
      const VerificationMeta('originalLatitude');
  @override
  late final GeneratedColumn<double> originalLatitude = GeneratedColumn<double>(
      'original_latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _originalLongitudeMeta =
      const VerificationMeta('originalLongitude');
  @override
  late final GeneratedColumn<double> originalLongitude =
      GeneratedColumn<double>('original_longitude', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isPrivateMeta =
      const VerificationMeta('isPrivate');
  @override
  late final GeneratedColumn<bool> isPrivate =
      GeneratedColumn<bool>('is_private', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_private" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _deletedFromCameraRollMeta =
      const VerificationMeta('deletedFromCameraRoll');
  @override
  late final GeneratedColumn<bool> deletedFromCameraRoll =
      GeneratedColumn<bool>('deleted_from_camera_roll', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("deleted_from_camera_roll" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _isStarredMeta =
      const VerificationMeta('isStarred');
  @override
  late final GeneratedColumn<bool> isStarred =
      GeneratedColumn<bool>('is_starred', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_starred" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
      tags = GeneratedColumn<String>('tags', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, String>>($PhotosTable.$convertertags);
  static const VerificationMeta _specificLocationMeta =
      const VerificationMeta('specificLocation');
  @override
  late final GeneratedColumn<String> specificLocation = GeneratedColumn<String>(
      'specific_location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _generalLocationMeta =
      const VerificationMeta('generalLocation');
  @override
  late final GeneratedColumn<String> generalLocation = GeneratedColumn<String>(
      'general_location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _base64encodedMeta =
      const VerificationMeta('base64encoded');
  @override
  late final GeneratedColumn<String> base64encoded = GeneratedColumn<String>(
      'base64encoded', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  String get aliasedName => _alias ?? 'photos';
  @override
  String get actualTableName => 'photos';
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      originalLatitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}original_latitude']),
      originalLongitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}original_longitude']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      isPrivate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_private'])!,
      deletedFromCameraRoll: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}deleted_from_camera_roll'])!,
      isStarred: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_starred'])!,
      tags: $PhotosTable.$convertertags.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!),
      specificLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}specific_location']),
      generalLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}general_location']),
      base64encoded: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base64encoded']),
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, String>, String> $convertertags =
      MapStringConvertor();
}

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
  const Photo(
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
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
    map['is_private'] = Variable<bool>(isPrivate);
    map['deleted_from_camera_roll'] = Variable<bool>(deletedFromCameraRoll);
    map['is_starred'] = Variable<bool>(isStarred);
    {
      final converter = $PhotosTable.$convertertags;
      map['tags'] = Variable<String>(converter.toSql(tags));
    }
    if (!nullToAbsent || specificLocation != null) {
      map['specific_location'] = Variable<String>(specificLocation);
    }
    if (!nullToAbsent || generalLocation != null) {
      map['general_location'] = Variable<String>(generalLocation);
    }
    if (!nullToAbsent || base64encoded != null) {
      map['base64encoded'] = Variable<String>(base64encoded);
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
          Value<double?> originalLatitude = const Value.absent(),
          Value<double?> originalLongitude = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          bool? isPrivate,
          bool? deletedFromCameraRoll,
          bool? isStarred,
          Map<String, String>? tags,
          Value<String?> specificLocation = const Value.absent(),
          Value<String?> generalLocation = const Value.absent(),
          Value<String?> base64encoded = const Value.absent()}) =>
      Photo(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        originalLatitude: originalLatitude.present
            ? originalLatitude.value
            : this.originalLatitude,
        originalLongitude: originalLongitude.present
            ? originalLongitude.value
            : this.originalLongitude,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        isPrivate: isPrivate ?? this.isPrivate,
        deletedFromCameraRoll:
            deletedFromCameraRoll ?? this.deletedFromCameraRoll,
        isStarred: isStarred ?? this.isStarred,
        tags: tags ?? this.tags,
        specificLocation: specificLocation.present
            ? specificLocation.value
            : this.specificLocation,
        generalLocation: generalLocation.present
            ? generalLocation.value
            : this.generalLocation,
        base64encoded:
            base64encoded.present ? base64encoded.value : this.base64encoded,
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
  int get hashCode => Object.hash(
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
      base64encoded);
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
  final Value<int> rowid;
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
    this.rowid = const Value.absent(),
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
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        tags = Value(tags);
  static Insertable<Photo> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<double>? originalLatitude,
    Expression<double>? originalLongitude,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isPrivate,
    Expression<bool>? deletedFromCameraRoll,
    Expression<bool>? isStarred,
    Expression<String>? tags,
    Expression<String>? specificLocation,
    Expression<String>? generalLocation,
    Expression<String>? base64encoded,
    Expression<int>? rowid,
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
      if (rowid != null) 'rowid': rowid,
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
      Value<String?>? base64encoded,
      Value<int>? rowid}) {
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
      rowid: rowid ?? this.rowid,
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
      final converter = $PhotosTable.$convertertags;
      map['tags'] = Variable<String>(converter.toSql(tags.value));
    }
    if (specificLocation.present) {
      map['specific_location'] = Variable<String>(specificLocation.value);
    }
    if (generalLocation.present) {
      map['general_location'] = Variable<String>(generalLocation.value);
    }
    if (base64encoded.present) {
      map['base64encoded'] = Variable<String>(base64encoded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('base64encoded: $base64encoded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PicBlurHashsTable extends PicBlurHashs
    with TableInfo<$PicBlurHashsTable, PicBlurHash> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PicBlurHashsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _photoIdMeta =
      const VerificationMeta('photoId');
  @override
  late final GeneratedColumn<String> photoId = GeneratedColumn<String>(
      'photo_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _blurHashMeta =
      const VerificationMeta('blurHash');
  @override
  late final GeneratedColumn<String> blurHash = GeneratedColumn<String>(
      'blur_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [photoId, blurHash];
  @override
  String get aliasedName => _alias ?? 'pic_blur_hashs';
  @override
  String get actualTableName => 'pic_blur_hashs';
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PicBlurHash(
      photoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_id'])!,
      blurHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blur_hash'])!,
    );
  }

  @override
  $PicBlurHashsTable createAlias(String alias) {
    return $PicBlurHashsTable(attachedDatabase, alias);
  }
}

class PicBlurHash extends DataClass implements Insertable<PicBlurHash> {
  final String photoId;
  final String blurHash;
  const PicBlurHash({required this.photoId, required this.blurHash});
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PicBlurHash(
      photoId: serializer.fromJson<String>(json['photoId']),
      blurHash: serializer.fromJson<String>(json['blurHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
  int get hashCode => Object.hash(photoId, blurHash);
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
  final Value<int> rowid;
  const PicBlurHashsCompanion({
    this.photoId = const Value.absent(),
    this.blurHash = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PicBlurHashsCompanion.insert({
    required String photoId,
    required String blurHash,
    this.rowid = const Value.absent(),
  })  : photoId = Value(photoId),
        blurHash = Value(blurHash);
  static Insertable<PicBlurHash> custom({
    Expression<String>? photoId,
    Expression<String>? blurHash,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (photoId != null) 'photo_id': photoId,
      if (blurHash != null) 'blur_hash': blurHash,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PicBlurHashsCompanion copyWith(
      {Value<String>? photoId, Value<String>? blurHash, Value<int>? rowid}) {
    return PicBlurHashsCompanion(
      photoId: photoId ?? this.photoId,
      blurHash: blurHash ?? this.blurHash,
      rowid: rowid ?? this.rowid,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PicBlurHashsCompanion(')
          ..write('photoId: $photoId, ')
          ..write('blurHash: $blurHash, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrivatesTable extends Privates with TableInfo<$PrivatesTable, Private> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<String> nonce = GeneratedColumn<String>(
      'nonce', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thumbPathMeta =
      const VerificationMeta('thumbPath');
  @override
  late final GeneratedColumn<String> thumbPath = GeneratedColumn<String>(
      'thumb_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createDateTimeMeta =
      const VerificationMeta('createDateTime');
  @override
  late final GeneratedColumn<DateTime> createDateTime =
      GeneratedColumn<DateTime>('create_date_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _originalLatitudeMeta =
      const VerificationMeta('originalLatitude');
  @override
  late final GeneratedColumn<double> originalLatitude = GeneratedColumn<double>(
      'original_latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _originalLongitudeMeta =
      const VerificationMeta('originalLongitude');
  @override
  late final GeneratedColumn<double> originalLongitude =
      GeneratedColumn<double>('original_longitude', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
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
  String get aliasedName => _alias ?? 'privates';
  @override
  String get actualTableName => 'privates';
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Private(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      nonce: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nonce'])!,
      thumbPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumb_path']),
      createDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}create_date_time']),
      originalLatitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}original_latitude']),
      originalLongitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}original_longitude']),
    );
  }

  @override
  $PrivatesTable createAlias(String alias) {
    return $PrivatesTable(attachedDatabase, alias);
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
  const Private(
      {required this.id,
      required this.path,
      required this.nonce,
      this.thumbPath,
      this.createDateTime,
      this.originalLatitude,
      this.originalLongitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['path'] = Variable<String>(path);
    map['nonce'] = Variable<String>(nonce);
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
          Value<String?> thumbPath = const Value.absent(),
          Value<DateTime?> createDateTime = const Value.absent(),
          Value<double?> originalLatitude = const Value.absent(),
          Value<double?> originalLongitude = const Value.absent()}) =>
      Private(
        id: id ?? this.id,
        path: path ?? this.path,
        nonce: nonce ?? this.nonce,
        thumbPath: thumbPath.present ? thumbPath.value : this.thumbPath,
        createDateTime:
            createDateTime.present ? createDateTime.value : this.createDateTime,
        originalLatitude: originalLatitude.present
            ? originalLatitude.value
            : this.originalLatitude,
        originalLongitude: originalLongitude.present
            ? originalLongitude.value
            : this.originalLongitude,
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
  int get hashCode => Object.hash(id, path, nonce, thumbPath, createDateTime,
      originalLatitude, originalLongitude);
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
  final Value<int> rowid;
  const PrivatesCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.nonce = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.createDateTime = const Value.absent(),
    this.originalLatitude = const Value.absent(),
    this.originalLongitude = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrivatesCompanion.insert({
    required String id,
    required String path,
    required String nonce,
    this.thumbPath = const Value.absent(),
    this.createDateTime = const Value.absent(),
    this.originalLatitude = const Value.absent(),
    this.originalLongitude = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        path = Value(path),
        nonce = Value(nonce);
  static Insertable<Private> custom({
    Expression<String>? id,
    Expression<String>? path,
    Expression<String>? nonce,
    Expression<String>? thumbPath,
    Expression<DateTime>? createDateTime,
    Expression<double>? originalLatitude,
    Expression<double>? originalLongitude,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (nonce != null) 'nonce': nonce,
      if (thumbPath != null) 'thumb_path': thumbPath,
      if (createDateTime != null) 'create_date_time': createDateTime,
      if (originalLatitude != null) 'original_latitude': originalLatitude,
      if (originalLongitude != null) 'original_longitude': originalLongitude,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrivatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? path,
      Value<String>? nonce,
      Value<String?>? thumbPath,
      Value<DateTime?>? createDateTime,
      Value<double?>? originalLatitude,
      Value<double?>? originalLongitude,
      Value<int>? rowid}) {
    return PrivatesCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      nonce: nonce ?? this.nonce,
      thumbPath: thumbPath ?? this.thumbPath,
      createDateTime: createDateTime ?? this.createDateTime,
      originalLatitude: originalLatitude ?? this.originalLatitude,
      originalLongitude: originalLongitude ?? this.originalLongitude,
      rowid: rowid ?? this.rowid,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('originalLongitude: $originalLongitude, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabelsTable extends Labels with TableInfo<$LabelsTable, Label> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(Uuid().v4()));
  static const VerificationMeta _counterMeta =
      const VerificationMeta('counter');
  @override
  late final GeneratedColumn<int> counter = GeneratedColumn<int>(
      'counter', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _photoIdMeta =
      const VerificationMeta('photoId');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
      photoId = GeneratedColumn<String>('photo_id', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, String>>($LabelsTable.$converterphotoId);
  @override
  List<GeneratedColumn> get $columns =>
      [key, counter, lastUsedAt, title, photoId];
  @override
  String get aliasedName => _alias ?? 'labels';
  @override
  String get actualTableName => 'labels';
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Label(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      counter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}counter'])!,
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      photoId: $LabelsTable.$converterphotoId.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_id'])!),
    );
  }

  @override
  $LabelsTable createAlias(String alias) {
    return $LabelsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, String>, String> $converterphotoId =
      MapStringConvertor();
}

class Label extends DataClass implements Insertable<Label> {
  final String key;
  final int counter;
  final DateTime lastUsedAt;
  final String title;
  final Map<String, String> photoId;
  const Label(
      {required this.key,
      required this.counter,
      required this.lastUsedAt,
      required this.title,
      required this.photoId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['counter'] = Variable<int>(counter);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    map['title'] = Variable<String>(title);
    {
      final converter = $LabelsTable.$converterphotoId;
      map['photo_id'] = Variable<String>(converter.toSql(photoId));
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
  int get hashCode => Object.hash(key, counter, lastUsedAt, title, photoId);
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
  final Value<int> rowid;
  const LabelsCompanion({
    this.key = const Value.absent(),
    this.counter = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.photoId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabelsCompanion.insert({
    this.key = const Value.absent(),
    this.counter = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.title = const Value.absent(),
    required Map<String, String> photoId,
    this.rowid = const Value.absent(),
  }) : photoId = Value(photoId);
  static Insertable<Label> custom({
    Expression<String>? key,
    Expression<int>? counter,
    Expression<DateTime>? lastUsedAt,
    Expression<String>? title,
    Expression<String>? photoId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (counter != null) 'counter': counter,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (title != null) 'title': title,
      if (photoId != null) 'photo_id': photoId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabelsCompanion copyWith(
      {Value<String>? key,
      Value<int>? counter,
      Value<DateTime>? lastUsedAt,
      Value<String>? title,
      Value<Map<String, String>>? photoId,
      Value<int>? rowid}) {
    return LabelsCompanion(
      key: key ?? this.key,
      counter: counter ?? this.counter,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      title: title ?? this.title,
      photoId: photoId ?? this.photoId,
      rowid: rowid ?? this.rowid,
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
      final converter = $LabelsTable.$converterphotoId;
      map['photo_id'] = Variable<String>(converter.toSql(photoId.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('photoId: $photoId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoorUsersTable extends MoorUsers
    with TableInfo<$MoorUsersTable, MoorUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoorUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _customPrimaryKeyMeta =
      const VerificationMeta('customPrimaryKey');
  @override
  late final GeneratedColumn<int> customPrimaryKey = GeneratedColumn<int>(
      'custom_primary_key', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(Uuid().v4()));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notificationMeta =
      const VerificationMeta('notification');
  @override
  late final GeneratedColumn<bool> notification =
      GeneratedColumn<bool>('notification', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("notification" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _dailyChallengesMeta =
      const VerificationMeta('dailyChallenges');
  @override
  late final GeneratedColumn<bool> dailyChallenges =
      GeneratedColumn<bool>('daily_challenges', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("daily_challenges" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _recentTagsMeta =
      const VerificationMeta('recentTags');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> recentTags =
      GeneratedColumn<String>('recent_tags', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($MoorUsersTable.$converterrecentTags);
  static const VerificationMeta _appLanguageMeta =
      const VerificationMeta('appLanguage');
  @override
  late final GeneratedColumn<String> appLanguage = GeneratedColumn<String>(
      'app_language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _appVersionMeta =
      const VerificationMeta('appVersion');
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
      'app_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _secretKeyMeta =
      const VerificationMeta('secretKey');
  @override
  late final GeneratedColumn<String> secretKey = GeneratedColumn<String>(
      'secret_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultWidgetImageMeta =
      const VerificationMeta('defaultWidgetImage');
  @override
  late final GeneratedColumn<String> defaultWidgetImage =
      GeneratedColumn<String>('default_widget_image', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<int> goal = GeneratedColumn<int>(
      'goal', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(20));
  static const VerificationMeta _hourOfDayMeta =
      const VerificationMeta('hourOfDay');
  @override
  late final GeneratedColumn<int> hourOfDay = GeneratedColumn<int>(
      'hour_of_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(20));
  static const VerificationMeta _minuteOfDayMeta =
      const VerificationMeta('minuteOfDay');
  @override
  late final GeneratedColumn<int> minuteOfDay = GeneratedColumn<int>(
      'minute_of_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _picsTaggedTodayMeta =
      const VerificationMeta('picsTaggedToday');
  @override
  late final GeneratedColumn<int> picsTaggedToday = GeneratedColumn<int>(
      'pics_tagged_today', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _tutorialCompletedMeta =
      const VerificationMeta('tutorialCompleted');
  @override
  late final GeneratedColumn<bool> tutorialCompleted =
      GeneratedColumn<bool>('tutorial_completed', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("tutorial_completed" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _hasGalleryPermissionMeta =
      const VerificationMeta('hasGalleryPermission');
  @override
  late final GeneratedColumn<bool> hasGalleryPermission =
      GeneratedColumn<bool>('has_gallery_permission', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("has_gallery_permission" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _loggedInMeta =
      const VerificationMeta('loggedIn');
  @override
  late final GeneratedColumn<bool> loggedIn =
      GeneratedColumn<bool>('logged_in', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("logged_in" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _secretPhotosMeta =
      const VerificationMeta('secretPhotos');
  @override
  late final GeneratedColumn<bool> secretPhotos =
      GeneratedColumn<bool>('secret_photos', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("secret_photos" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _isPinRegisteredMeta =
      const VerificationMeta('isPinRegistered');
  @override
  late final GeneratedColumn<bool> isPinRegistered =
      GeneratedColumn<bool>('is_pin_registered', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_pin_registered" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _keepAskingToDeleteMeta =
      const VerificationMeta('keepAskingToDelete');
  @override
  late final GeneratedColumn<bool> keepAskingToDelete =
      GeneratedColumn<bool>('keep_asking_to_delete', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("keep_asking_to_delete" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(true));
  static const VerificationMeta _shouldDeleteOnPrivateMeta =
      const VerificationMeta('shouldDeleteOnPrivate');
  @override
  late final GeneratedColumn<bool> shouldDeleteOnPrivate =
      GeneratedColumn<bool>('should_delete_on_private', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("should_delete_on_private" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _tourCompletedMeta =
      const VerificationMeta('tourCompleted');
  @override
  late final GeneratedColumn<bool> tourCompleted =
      GeneratedColumn<bool>('tour_completed', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("tour_completed" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _isBiometricActivatedMeta =
      const VerificationMeta('isBiometricActivated');
  @override
  late final GeneratedColumn<bool> isBiometricActivated =
      GeneratedColumn<bool>('is_biometric_activated', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_biometric_activated" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _lastTaggedPicDateMeta =
      const VerificationMeta('lastTaggedPicDate');
  @override
  late final GeneratedColumn<DateTime> lastTaggedPicDate =
      GeneratedColumn<DateTime>('last_tagged_pic_date', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: Constant(DateTime.now()));
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
        defaultWidgetImage,
        goal,
        hourOfDay,
        minuteOfDay,
        picsTaggedToday,
        tutorialCompleted,
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
  String get aliasedName => _alias ?? 'moor_users';
  @override
  String get actualTableName => 'moor_users';
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoorUser(
      customPrimaryKey: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}custom_primary_key'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      notification: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}notification'])!,
      dailyChallenges: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}daily_challenges'])!,
      recentTags: $MoorUsersTable.$converterrecentTags.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recent_tags'])!),
      appLanguage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_language']),
      appVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_version']),
      secretKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}secret_key']),
      defaultWidgetImage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}default_widget_image']),
      goal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goal'])!,
      hourOfDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour_of_day'])!,
      minuteOfDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minute_of_day'])!,
      picsTaggedToday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pics_tagged_today'])!,
      tutorialCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}tutorial_completed'])!,
      hasGalleryPermission: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_gallery_permission'])!,
      loggedIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}logged_in'])!,
      secretPhotos: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}secret_photos'])!,
      isPinRegistered: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_pin_registered'])!,
      keepAskingToDelete: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}keep_asking_to_delete'])!,
      shouldDeleteOnPrivate: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}should_delete_on_private'])!,
      tourCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}tour_completed'])!,
      isBiometricActivated: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_biometric_activated'])!,
      lastTaggedPicDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_tagged_pic_date'])!,
    );
  }

  @override
  $MoorUsersTable createAlias(String alias) {
    return $MoorUsersTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterrecentTags =
      ListStringConvertor();
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
  final String? defaultWidgetImage;
  final int goal;
  final int hourOfDay;
  final int minuteOfDay;
  final int picsTaggedToday;
  final bool tutorialCompleted;
  final bool hasGalleryPermission;
  final bool loggedIn;
  final bool secretPhotos;
  final bool isPinRegistered;
  final bool keepAskingToDelete;
  final bool shouldDeleteOnPrivate;
  final bool tourCompleted;
  final bool isBiometricActivated;
  final DateTime lastTaggedPicDate;
  const MoorUser(
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
      this.defaultWidgetImage,
      required this.goal,
      required this.hourOfDay,
      required this.minuteOfDay,
      required this.picsTaggedToday,
      required this.tutorialCompleted,
      required this.hasGalleryPermission,
      required this.loggedIn,
      required this.secretPhotos,
      required this.isPinRegistered,
      required this.keepAskingToDelete,
      required this.shouldDeleteOnPrivate,
      required this.tourCompleted,
      required this.isBiometricActivated,
      required this.lastTaggedPicDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['custom_primary_key'] = Variable<int>(customPrimaryKey);
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    map['notification'] = Variable<bool>(notification);
    map['daily_challenges'] = Variable<bool>(dailyChallenges);
    {
      final converter = $MoorUsersTable.$converterrecentTags;
      map['recent_tags'] = Variable<String>(converter.toSql(recentTags));
    }
    if (!nullToAbsent || appLanguage != null) {
      map['app_language'] = Variable<String>(appLanguage);
    }
    if (!nullToAbsent || appVersion != null) {
      map['app_version'] = Variable<String>(appVersion);
    }
    if (!nullToAbsent || secretKey != null) {
      map['secret_key'] = Variable<String>(secretKey);
    }
    if (!nullToAbsent || defaultWidgetImage != null) {
      map['default_widget_image'] = Variable<String>(defaultWidgetImage);
    }
    map['goal'] = Variable<int>(goal);
    map['hour_of_day'] = Variable<int>(hourOfDay);
    map['minute_of_day'] = Variable<int>(minuteOfDay);
    map['pics_tagged_today'] = Variable<int>(picsTaggedToday);
    map['tutorial_completed'] = Variable<bool>(tutorialCompleted);
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
      defaultWidgetImage: defaultWidgetImage == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultWidgetImage),
      goal: Value(goal),
      hourOfDay: Value(hourOfDay),
      minuteOfDay: Value(minuteOfDay),
      picsTaggedToday: Value(picsTaggedToday),
      tutorialCompleted: Value(tutorialCompleted),
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
      defaultWidgetImage:
          serializer.fromJson<String?>(json['defaultWidgetImage']),
      goal: serializer.fromJson<int>(json['goal']),
      hourOfDay: serializer.fromJson<int>(json['hourOfDay']),
      minuteOfDay: serializer.fromJson<int>(json['minuteOfDay']),
      picsTaggedToday: serializer.fromJson<int>(json['picsTaggedToday']),
      tutorialCompleted: serializer.fromJson<bool>(json['tutorialCompleted']),
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
      'defaultWidgetImage': serializer.toJson<String?>(defaultWidgetImage),
      'goal': serializer.toJson<int>(goal),
      'hourOfDay': serializer.toJson<int>(hourOfDay),
      'minuteOfDay': serializer.toJson<int>(minuteOfDay),
      'picsTaggedToday': serializer.toJson<int>(picsTaggedToday),
      'tutorialCompleted': serializer.toJson<bool>(tutorialCompleted),
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
          Value<String?> email = const Value.absent(),
          Value<String?> password = const Value.absent(),
          bool? notification,
          bool? dailyChallenges,
          List<String>? recentTags,
          Value<String?> appLanguage = const Value.absent(),
          Value<String?> appVersion = const Value.absent(),
          Value<String?> secretKey = const Value.absent(),
          Value<String?> defaultWidgetImage = const Value.absent(),
          int? goal,
          int? hourOfDay,
          int? minuteOfDay,
          int? picsTaggedToday,
          bool? tutorialCompleted,
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
        email: email.present ? email.value : this.email,
        password: password.present ? password.value : this.password,
        notification: notification ?? this.notification,
        dailyChallenges: dailyChallenges ?? this.dailyChallenges,
        recentTags: recentTags ?? this.recentTags,
        appLanguage: appLanguage.present ? appLanguage.value : this.appLanguage,
        appVersion: appVersion.present ? appVersion.value : this.appVersion,
        secretKey: secretKey.present ? secretKey.value : this.secretKey,
        defaultWidgetImage: defaultWidgetImage.present
            ? defaultWidgetImage.value
            : this.defaultWidgetImage,
        goal: goal ?? this.goal,
        hourOfDay: hourOfDay ?? this.hourOfDay,
        minuteOfDay: minuteOfDay ?? this.minuteOfDay,
        picsTaggedToday: picsTaggedToday ?? this.picsTaggedToday,
        tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
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
          ..write('defaultWidgetImage: $defaultWidgetImage, ')
          ..write('goal: $goal, ')
          ..write('hourOfDay: $hourOfDay, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('picsTaggedToday: $picsTaggedToday, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
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
  int get hashCode => Object.hashAll([
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
        defaultWidgetImage,
        goal,
        hourOfDay,
        minuteOfDay,
        picsTaggedToday,
        tutorialCompleted,
        hasGalleryPermission,
        loggedIn,
        secretPhotos,
        isPinRegistered,
        keepAskingToDelete,
        shouldDeleteOnPrivate,
        tourCompleted,
        isBiometricActivated,
        lastTaggedPicDate
      ]);
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
          other.defaultWidgetImage == this.defaultWidgetImage &&
          other.goal == this.goal &&
          other.hourOfDay == this.hourOfDay &&
          other.minuteOfDay == this.minuteOfDay &&
          other.picsTaggedToday == this.picsTaggedToday &&
          other.tutorialCompleted == this.tutorialCompleted &&
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
  final Value<String?> defaultWidgetImage;
  final Value<int> goal;
  final Value<int> hourOfDay;
  final Value<int> minuteOfDay;
  final Value<int> picsTaggedToday;
  final Value<bool> tutorialCompleted;
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
    this.defaultWidgetImage = const Value.absent(),
    this.goal = const Value.absent(),
    this.hourOfDay = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.picsTaggedToday = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
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
    this.defaultWidgetImage = const Value.absent(),
    this.goal = const Value.absent(),
    this.hourOfDay = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.picsTaggedToday = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
    this.hasGalleryPermission = const Value.absent(),
    this.loggedIn = const Value.absent(),
    this.secretPhotos = const Value.absent(),
    this.isPinRegistered = const Value.absent(),
    this.keepAskingToDelete = const Value.absent(),
    this.shouldDeleteOnPrivate = const Value.absent(),
    this.tourCompleted = const Value.absent(),
    this.isBiometricActivated = const Value.absent(),
    this.lastTaggedPicDate = const Value.absent(),
  }) : recentTags = Value(recentTags);
  static Insertable<MoorUser> custom({
    Expression<int>? customPrimaryKey,
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<bool>? notification,
    Expression<bool>? dailyChallenges,
    Expression<String>? recentTags,
    Expression<String>? appLanguage,
    Expression<String>? appVersion,
    Expression<String>? secretKey,
    Expression<String>? defaultWidgetImage,
    Expression<int>? goal,
    Expression<int>? hourOfDay,
    Expression<int>? minuteOfDay,
    Expression<int>? picsTaggedToday,
    Expression<bool>? tutorialCompleted,
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
      if (defaultWidgetImage != null)
        'default_widget_image': defaultWidgetImage,
      if (goal != null) 'goal': goal,
      if (hourOfDay != null) 'hour_of_day': hourOfDay,
      if (minuteOfDay != null) 'minute_of_day': minuteOfDay,
      if (picsTaggedToday != null) 'pics_tagged_today': picsTaggedToday,
      if (tutorialCompleted != null) 'tutorial_completed': tutorialCompleted,
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
      Value<String?>? defaultWidgetImage,
      Value<int>? goal,
      Value<int>? hourOfDay,
      Value<int>? minuteOfDay,
      Value<int>? picsTaggedToday,
      Value<bool>? tutorialCompleted,
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
      defaultWidgetImage: defaultWidgetImage ?? this.defaultWidgetImage,
      goal: goal ?? this.goal,
      hourOfDay: hourOfDay ?? this.hourOfDay,
      minuteOfDay: minuteOfDay ?? this.minuteOfDay,
      picsTaggedToday: picsTaggedToday ?? this.picsTaggedToday,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
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
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (notification.present) {
      map['notification'] = Variable<bool>(notification.value);
    }
    if (dailyChallenges.present) {
      map['daily_challenges'] = Variable<bool>(dailyChallenges.value);
    }
    if (recentTags.present) {
      final converter = $MoorUsersTable.$converterrecentTags;
      map['recent_tags'] = Variable<String>(converter.toSql(recentTags.value));
    }
    if (appLanguage.present) {
      map['app_language'] = Variable<String>(appLanguage.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (secretKey.present) {
      map['secret_key'] = Variable<String>(secretKey.value);
    }
    if (defaultWidgetImage.present) {
      map['default_widget_image'] = Variable<String>(defaultWidgetImage.value);
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
          ..write('defaultWidgetImage: $defaultWidgetImage, ')
          ..write('goal: $goal, ')
          ..write('hourOfDay: $hourOfDay, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('picsTaggedToday: $picsTaggedToday, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $PicBlurHashsTable picBlurHashs = $PicBlurHashsTable(this);
  late final $PrivatesTable privates = $PrivatesTable(this);
  late final $LabelsTable labels = $LabelsTable(this);
  late final $MoorUsersTable moorUsers = $MoorUsersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [photos, picBlurHashs, privates, labels, moorUsers];
}
