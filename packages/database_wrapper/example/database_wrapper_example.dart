import 'package:database_wrapper/database_wrapper.dart';

// NOTE: this will fail because of invalid credentials
Future<void> main() async {
  final DatabaseEndpointDataValue endpointData = DatabaseEndpointDataValue(
    pgHost: 'localhost',
    pgPort: 5432,
    pgUser: 'postgres',
    pgPassword: 'password',
    pgDatabase: 'database',
  );

  final DatabaseWrapper databaseWrapper = DatabaseWrapper.app(
    endpointData: endpointData,
  );

  databaseWrapper.initialize();

  print('Database initialized');

  await databaseWrapper.logDbTime();

  await databaseWrapper.close();
}
