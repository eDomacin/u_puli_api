import 'package:u_puli_api/src/features/auth/data/data_sources/auth_data_source.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_user_model.dart';
import 'package:u_puli_api/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_user_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/create_auth_value.dart';
import 'package:u_puli_api/src/utils/converters/auth_converter.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthDataSource authDataSource})
    : _authDataSource = authDataSource;

  final AuthDataSource _authDataSource;

  @override
  Future<AuthUserModel?> getAuthUser(int authId) async {
    final AuthUserEntityValue? value = await _authDataSource.getAuthUser(
      authId,
    );
    if (value == null) {
      return null;
    }

    final AuthUserModel model = AuthConverter.authUserModelFromEntityValue(
      value: value,
    );

    return model;
  }

  @override
  Future<int> registerWithUserAndPassword(
    CreateEmailPasswordAuthEntityDataValue data,
  ) async {
    final int id = await _authDataSource.createAuth(data);
    return id;
  }

  @override
  Future<AuthModel?> getAuthByEmail(String email) async {
    final AuthEntityValue? value = await _authDataSource.getAuthByEmail(email);
    if (value == null) {
      return null;
    }

    final AuthModel model = AuthConverter.authModelFromEntityValue(
      value: value,
    );

    return model;
  }

  // TODO this is unusable
  // @override
  // Future<AuthModel?> getAuthByEmailAndPassword({
  //   required String email,
  //   required String password,
  // }) async {
  //   final AuthEntityValue? value = await _authDataSource
  //       .getAuthByEmailAndPassword(email: email, password: password);

  //   if (value == null) {
  //     return null;
  //   }

  //   final AuthModel model = AuthConverter.modelFromEntityValue(value: value);

  //   return model;
  // }
}
