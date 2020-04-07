import 'package:hive/hive.dart';

part 'pic.g.dart';

@HiveType(typeId: 0)
class Pic {
  @HiveField(0)
  final String photoId;

  @HiveField(1)
  final int photoIndex;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final String location;

  @HiveField(6)
  final List<String> tags;

  Pic(this.photoId, this.photoIndex, this.createdAt, this.latitude, this.longitude, this.location, this.tags);
}
