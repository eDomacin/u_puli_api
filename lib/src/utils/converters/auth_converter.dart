import 'package:database_wrapper/database_wrapper.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_user_model.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_user_entity_value.dart';

abstract class AuthConverter {
  static AuthModel authModelFromEntityValue({required AuthEntityValue value}) {
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

  static AuthEntityValue authEntityValueFromEntityData({
    required AuthEntityData entityData,
  }) {
    final AuthEntityValue value = AuthEntityValue(
      id: entityData.id,
      email: entityData.email,
      password: entityData.password,
      authType: entityData.authType,
    );

    return value;
  }

  static AuthUserEntityValue authUserEntityValueFromEntitiesData({
    required UserEntityData userData,
    required AuthEntityData authData,
  }) {
    final AuthUserEntityValue value = AuthUserEntityValue(
      userId: userData.id,
      email: authData.email,
      firstName: userData.firstName,
      lastName: userData.lastName,
    );

    return value;
  }
}
