import 'package:u_puli_api/src/features/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_user_model.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_user_entity_value.dart';

abstract class AuthConverter {
  static AuthModel modelFromEntityValue({required AuthEntityValue value}) {
    final AuthModel model = AuthModel(
      id: value.id,
      email: value.email,
      authType: value.authType,
      password: value.password,
    );

    return model;
  }

  static AuthUserModel authUserModelFromEntityValue({
    required AuthUserEntityValue value,
  }) {
    final AuthUserModel model = AuthUserModel(
      userId: value.userId,
      email: value.email,
      firstName: value.firstName,
      lastName: value.lastName,
    );

    return model;
  }
}
