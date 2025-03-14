import 'package:u_puli_api/src/features/auth/domain/models/auth_model.dart';
import 'package:u_puli_api/src/features/auth/domain/models/auth_user_model.dart';
import 'package:u_puli_api/src/features/auth/domain/values/create_auth_value.dart';

abstract interface class AuthRepository {
  Future<AuthUserModel?> getAuthUser(int authId);

  Future<int> registerWithUserAndPassword(
    CreateEmailPasswordAuthEntityDataValue data,
  );

  Future<AuthModel?> getAuthByEmail(String email);

  // Future<AuthModel?> getAuthByEmailAndPassword({
  //   required String email,
  //   required String password,
  // });
}
