import 'package:hive/hive.dart';
part 'user_key.g.dart';

@HiveType(typeId: 5)
class UserKey extends HiveObject {
  @HiveField(0)
  final String secretKey;

  UserKey({
    this.secretKey,
  });
}
