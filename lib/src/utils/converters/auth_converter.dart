import 'package:u_puli_api/src/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/auth/domain/values/auth_entity_value.dart';

abstract class AuthConverter {
  static AuthModel modelFromEntityValue({required AuthEntityValue value}) {
    final AuthModel model = AuthModel(
      id: value.id,
      email: value.email,
      authType: value.authType,
    );

    return model;
  }
}
