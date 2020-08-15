import 'package:hive/hive.dart';
part 'pic.g.dart';

@HiveType(typeId: 0)
class Pic extends HiveObject {
  @HiveField(0)
  final String photoId;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final double originalLatitude;

  @HiveField(3)
  final double originalLongitude;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitude;

  @HiveField(6)
  String specificLocation;

  @HiveField(7)
  String generalLocation;

  @HiveField(8)
  final List<String> tags;

  Pic(
    this.photoId,
    this.createdAt,
    this.originalLatitude,
    this.originalLongitude,
    this.latitude,
    this.longitude,
    this.specificLocation,
    this.generalLocation,
    this.tags,
  );
}
