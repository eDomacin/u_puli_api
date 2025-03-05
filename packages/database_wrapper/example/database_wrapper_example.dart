import 'package:database_wrapper/database_wrapper.dart';
import 'package:database_wrapper/src/values/database_endpoint_data_value.dart';

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

  final List<String> dbCurrentTime =
      await databaseWrapper.driftWrapper.current_timestamp().get();

  print("Current database time on open: $dbCurrentTime");

  await databaseWrapper.driftWrapper.close();
}
