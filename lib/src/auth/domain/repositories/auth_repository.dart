import 'package:u_puli_api/src/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/auth/domain/values/create_auth_value.dart';

abstract interface class AuthRepository {
  Future<int> registerWithUserAndPassword(
    CreateEmailPasswordAuthEntityDataValue data,
  );

  Future<AuthModel?> getAuthByEmail(String email);

  Future<AuthModel?> getAuthByEmailAndPassword({
    required String email,
    required String password,
  });
}
