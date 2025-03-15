import 'package:database_wrapper/database_wrapper.dart';
import 'package:u_puli_api/src/features/auth/data/data_sources/auth_data_source.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/auth_user_entity_value.dart';
import 'package:u_puli_api/src/features/auth/domain/values/create_auth_value.dart';
import 'package:u_puli_api/src/utils/converters/auth_converter.dart';

class AuthDataSourceImpl implements AuthDataSource {
  const AuthDataSourceImpl({required DatabaseWrapper databaseWrapper})
    : _databaseWrapper = databaseWrapper;

  final DatabaseWrapper _databaseWrapper;

  @override
  Future<AuthUserEntityValue?> getAuthUser(int authId) async {
    final SimpleSelectStatement<$UserEntityTable, UserEntityData> select =
        _databaseWrapper.usersRepo.select();
    final JoinedSelectStatement<HasResultSet, dynamic> joinedSelect = select
        .join([
          leftOuterJoin(
            _databaseWrapper.authsRepo,
            _databaseWrapper.authsRepo.id.equalsExp(
              _databaseWrapper.usersRepo.authId,
            ),
          ),
        ]);

    final JoinedSelectStatement<HasResultSet, dynamic> findUserSelect =
        joinedSelect..where(_databaseWrapper.authsRepo.id.equals(authId));

    final TypedResult? result = await findUserSelect.getSingleOrNull();

    if (result == null) {
      return null;
    }

    final UserEntityData userData = result.readTable(
      _databaseWrapper.usersRepo,
    );
    final AuthEntityData authData = result.readTable(
      _databaseWrapper.authsRepo,
    );

    final AuthUserEntityValue entityValue =
        AuthConverter.authUserEntityValueFromEntitiesData(
          userData: userData,
          authData: authData,
        );

    return entityValue;
  }

  // TODO maybe can be called createAuthUser
  // we cannot return AuthUser because we do need id

  @override
  Future<int> createAuth(CreateAuthValue data) async {
    final int authId = await _databaseWrapper.transaction(() async {
      final AuthEntityCompanion authCompanion = AuthEntityCompanion.insert(
        email: data.email,
        password: Value(data.hashedPassword),
        authType: data.authType,
      );

      final int authId = await _databaseWrapper.authsRepo.insertOne(
        authCompanion,
      );

      final UserEntityCompanion userCompanion = UserEntityCompanion.insert(
        firstName: data.firstName,
        lastName: data.lastName,
        authId: authId,
      );
      await _databaseWrapper.usersRepo.insertOne(userCompanion);

      return authId;
    });

    return authId;
  }

  @override
  Future<AuthEntityValue?> getAuthByEmail(String email) async {
    final SimpleSelectStatement<$AuthEntityTable, AuthEntityData> select =
        _databaseWrapper.authsRepo.select();
    final SimpleSelectStatement<$AuthEntityTable, AuthEntityData> findAuth =
        select..where((tbl) => tbl.email.equals(email));

    final AuthEntityData? auth = await findAuth.getSingleOrNull();
    if (auth == null) {
      return null;
    }

    final AuthEntityValue entityValue =
        AuthConverter.authEntityValueFromEntityData(entityData: auth);
    return entityValue;
  }
}
