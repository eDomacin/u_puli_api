import 'package:u_puli_api/src/auth/data/data_sources/auth_data_source.dart';
import 'package:u_puli_api/src/auth/data/entities/auth_entity.dart';
import 'package:u_puli_api/src/auth/data/entities/user_entity.dart';
import 'package:u_puli_api/src/auth/domain/values/auth_entity_value.dart';
import 'package:u_puli_api/src/auth/domain/values/create_auth_value.dart';
import 'package:u_puli_api/src/utils/extensions/iterable_extension.dart';

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<int> createAuth(CreateAuthValue data) async {
    // TODO test implementation
    final String email = data.email;

    final bool alreadyExists = _tempAuthEntities.any(
      (auth) => auth.email == email,
    );
    if (alreadyExists) {
      throw Exception('Email already exists');
    }

    // TODO wrap into transaction
    final int authsLength = _tempAuthEntities.length;
    final int authId = authsLength + 1;

    final AuthEntity authEntity = AuthEntity(
      id: authId,
      email: email,
      password: data.hashedPassword,
      authType: data.authType,
    );

    final int usersLength = _tempUserEntities.length;
    final int userId = usersLength + 1;

    final UserEntity userEntity = UserEntity(
      id: userId,
      firstName: data.firstName,
      lastName: data.lastName,
      authId: authId,
    );

    _tempAuthEntities.add(authEntity);
    _tempUserEntities.add(userEntity);

    return authId;
  }

  @override
  Future<AuthEntityValue?> getAuthByEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final AuthEntity? authEntity = _tempAuthEntities.firstWhereOrNull(
      (auth) => auth.email == email && auth.password == password,
    );

    if (authEntity == null) {
      return null;
    }

    // TODO create converter once needed
    final AuthEntityValue entityValue = AuthEntityValue(
      id: authEntity.id,
      email: authEntity.email,
      authType: authEntity.authType,
    );
    return entityValue;
  }
}

// TODO temp
final _tempAuthEntities = <AuthEntity>[];
final _tempUserEntities = <UserEntity>[];
