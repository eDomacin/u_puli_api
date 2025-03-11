import 'package:u_puli_api/src/auth/data/data_sources/auth_data_source.dart';
import 'package:u_puli_api/src/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/auth/domain/repositories/auth_repository.dart';
import 'package:u_puli_api/src/auth/domain/values/auth_entity_value.dart';
import 'package:u_puli_api/src/auth/domain/values/create_auth_value.dart';
import 'package:u_puli_api/src/utils/converters/auth_converter.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthDataSource authDataSource})
    : _authDataSource = authDataSource;

  final AuthDataSource _authDataSource;

  @override
  Future<int> registerWithUserAndPassword(
    CreateEmailPasswordAuthEntityDataValue data,
  ) async {
    final int id = await _authDataSource.createAuth(data);
    return id;
  }

  @override
  Future<AuthModel?> getAuthByEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final AuthEntityValue? value = await _authDataSource
        .getAuthByEmailAndPassword(email: email, password: password);

    if (value == null) {
      return null;
    }

    final AuthModel model = AuthConverter.modelFromEntityValue(value: value);

    return model;
  }
}
