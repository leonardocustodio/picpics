import 'package:hive/hive.dart';
part 'secret.g.dart';

@HiveType(typeId: 3)
class Secret extends HiveObject {
  @HiveField(0)
  String photoId;

  @HiveField(1)
  String photoPath;

  @HiveField(2)
  String thumbPath;

  @HiveField(3)
  final DateTime createDateTime;

  @HiveField(4)
  final double originalLatitude;

  @HiveField(5)
  final double originalLongitude;

  @HiveField(6)
  final String nonce;

  Secret({
    this.photoId,
    this.photoPath,
    this.thumbPath,
    this.createDateTime,
    this.originalLatitude,
    this.originalLongitude,
    this.nonce,
  });
}
