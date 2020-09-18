import 'package:hive/hive.dart';
part 'secret.g.dart';

@HiveType(typeId: 3)
class Secret extends HiveObject {
  @HiveField(0)
  int pin;

  Secret({
    this.pin,
  });
}
