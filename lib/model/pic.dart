import 'package:hive/hive.dart';
part 'pic.g.dart';

@HiveType(typeId: 0)
class Pic {
  @HiveField(0)
  final String photoId;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final double latitude;

  @HiveField(3)
  final double longitude;

  @HiveField(4)
  final String location;

  @HiveField(5)
  final List<String> tags;

  Pic(
    this.photoId,
//    this.photoIndex,
    this.createdAt,
    this.latitude,
    this.longitude,
    this.location,
    this.tags,
  );
}
