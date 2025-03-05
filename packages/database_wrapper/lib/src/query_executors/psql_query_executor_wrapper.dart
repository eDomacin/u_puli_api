import 'package:database_wrapper/src/values/database_endpoint_data_value.dart';
import 'package:drift/drift.dart';
import 'package:postgres/postgres.dart';
import 'package:drift_postgres/drift_postgres.dart';

class PsqlQueryExecutorWrapper {
  const PsqlQueryExecutorWrapper(DatabaseEndpointDataValue endpointData)
    : _endpointData = endpointData;

  final DatabaseEndpointDataValue _endpointData;

  QueryExecutor get queryExecuter {
    final PgDatabase pgDatabase = PgDatabase(
      endpoint: Endpoint(
        host: _endpointData.pgHost,
        port: _endpointData.pgPort,
        username: _endpointData.pgUser,
        password: _endpointData.pgPassword,
        database: _endpointData.pgDatabase,
      ),
      settings: ConnectionSettings(
        sslMode: SslMode.require,
        onOpen: (connection) async {
          print("Connected to database");
        },
      ),
    );

    return pgDatabase;
  }
}
