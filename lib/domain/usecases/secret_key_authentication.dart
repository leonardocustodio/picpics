import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class SecretKeyAuthentication {
  Future<SecretKeyEntity> auth({
    @required String pin,
  });
}
