import 'package:hive/hive.dart';
part 'tag.g.dart';

@HiveType(typeId: 1)
class Tag extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<String> photoId;

  Tag(this.name, this.photoId);
}
