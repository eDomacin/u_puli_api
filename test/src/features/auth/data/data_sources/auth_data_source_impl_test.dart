import 'package:database_wrapper/database_wrapper.dart';
import 'package:test/test.dart';
import 'package:u_puli_api/src/features/auth/data/data_sources/auth_data_source.dart';
import 'package:u_puli_api/src/features/auth/data/data_sources/auth_data_source_impl.dart';

import 'package:u_puli_api/src/features/auth/domain/values/auth_user_entity_value.dart';

import '../../../../../helpers/database/test_database_wrapper.dart';

// TODO complete this
void main() {
  final TestDatabaseWrapper testDatabaseWrapper = getTestDatabaseWrapper();
  final AuthDataSource authDataSource = AuthDataSourceImpl(
    databaseWrapper: testDatabaseWrapper.databaseWrapper,
  );

  tearDown(() async {
    await testDatabaseWrapper.clearAll();
  });

  tearDownAll(() async {
    await testDatabaseWrapper.close();
  });
  test('auth data source impl ...', () async {
    // add data to db
    final int authId = await testDatabaseWrapper.databaseWrapper.transaction(
      () async {
        final AuthEntityCompanion authCompanion = AuthEntityCompanion.insert(
          email: "email",
          password: Value("data.hashedPassword"),
          authType: AuthType.emailPassword,
        );

        final int authId = await testDatabaseWrapper.databaseWrapper.authsRepo
            .insertOne(authCompanion);

        final UserEntityCompanion userCompanion = UserEntityCompanion.insert(
          firstName: "data.firstName",
          lastName: "data.lastName",
          authId: authId,
        );
        await testDatabaseWrapper.databaseWrapper.usersRepo.insertOne(
          userCompanion,
        );

        return authId;
      },
    );

    // check

    final AuthUserEntityValue? auth = await authDataSource.getAuthUser(1);

    print(auth);
  });
}
