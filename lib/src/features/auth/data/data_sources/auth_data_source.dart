import 'package:u_puli_api/src/features/auth/domain/values/auth_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/create_auth_value.dart';

abstract interface class AuthDataSource {
  /// Creates a user entity and an auth entity.
  ///
  /// Returns the id of the created auth entity.
  Future<int> createAuth(CreateAuthValue data);
  Future<AuthEntityValue?> getAuthByEmail(String email);
  Future<AuthEntityValue?> getAuthByEmailAndPassword({
    required String email,
    required String password,
  });
}
