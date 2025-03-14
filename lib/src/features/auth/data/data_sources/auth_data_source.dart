import 'package:u_puli_api/src/features/auth/domain/values/auth_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_user_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/create_auth_value.dart';

abstract interface class AuthDataSource {
  // this function is used by all three login options:
  // - login - login will first check if user with email exists, and then it will check if password is correct, and then it will use the auth id to get authUser
  // - register - register will first check if user with email exists, and then it will create a new auth entity, and then it will use the auth id to get authUser
  // - refresh token - refresh token will use the auth id from the token to get authUser
  Future<AuthUserEntityValue?> getAuthUser(int authId);

  /// Creates a user entity and an auth entity.
  ///
  /// Returns the id of the created auth entity.
  /// TODO this should return the created auth entity - AuthUserEntityValue to be specific - but then we would not have the id of the created auth entity
  Future<int> createAuth(CreateAuthValue data);
  Future<AuthEntityValue?> getAuthByEmail(String email);
  // TODO this makes no sense to have - we will never have same password for same user
  // Future<AuthEntityValue?> getAuthByEmailAndPassword({
  //   required String email,
  //   required String password,
  // });
}
