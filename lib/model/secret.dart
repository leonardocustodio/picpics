import 'package:hive/hive.dart';
part 'secret.g.dart';

@HiveType(typeId: 3)
class Secret extends HiveObject {
  @HiveField(0)
  String photoId;

  @HiveField(1)
  String privatePath;

  @HiveField(2)
  final DateTime createDateTime;

  @HiveField(3)
  final double originalLatitude;

  @HiveField(4)
  final double originalLongitude;

  @HiveField(5)
  final String nonce;

  Secret({
    this.photoId,
    this.privatePath,
    this.createDateTime,
    this.originalLatitude,
    this.originalLongitude,
    this.nonce,
  });
}
